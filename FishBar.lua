--[[ Acknowledgement: Several portions of this code are based on Votan's Fisherman ]]
local FB = _G.FishBar
local fishingInteractableName = nil
local interactionReady = false
local lastAction = nil
local lure = nil
local FISHING_INTERVAL = 30
local DEFAULT_FISHING_INTERVAL = 30
local FRAME_MOVE_INTERVAL = 604800
local isFishing = false
local bonus = 1

--FB.AchievementProgress = {}

local function StartTimer(interval)
    local now = GetFrameTimeMilliseconds()
    local timerStartSeconds = now / 1000
    local timerEndSeconds = timerStartSeconds + interval

    FB.GUI:SetHidden(false)
    FB.timer:Start(timerStartSeconds, timerEndSeconds)
end

local function StopTimer()
    FB.timer:Stop()
    FB.GUI:SetHidden(true)
end

local function NewInteraction()
    if (not interactionReady or FB.moving) then
        return
    end

    local action, interactableName, _, _, additionalInfo = GetGameCameraInteractableActionInfo()

    if (action and interactableName) then
        if (lastAction == action) then
            return
        end

        lastAction = action

        if (additionalInfo == _G.ADDITIONAL_INTERACT_INFO_FISHING_NODE) then
            fishingInteractableName = interactableName
        else
            local fishing = interactableName == fishingInteractableName

            if (fishing) then
                --FB.Log("fishing started", "info")
                lure = GetFishingLure()
                isFishing = true
                --FB.Log("interval: " .. FISHING_INTERVAL, "warn")
                StartTimer(FISHING_INTERVAL)
            else
                isFishing = false
                lure = nil
                StopTimer()
            end
        end
    else
        if (lastAction == action) then
            return
        end

        lastAction = action
    end
end

-- capture situations where fishing is interrupted
local function CheckInteraction(interactionPossible, _)
    if (interactionPossible) then
        local action = GetGameCameraInteractableActionInfo()

        if (action ~= FB.ReelIn) then
            if (isFishing) then
                StopTimer()
                PlaySound(_G.SOUNDS.GENERAL_ALERT_ERROR)
                isFishing = false
            end
        end
    end
end

local function HookInteraction()
    ZO_PreHookHandler(RETICLE.interact, "OnEffectivelyShown", NewInteraction)
    ZO_PreHookHandler(RETICLE.interact, "OnHide", NewInteraction)
    ZO_PostHook(RETICLE, "TryHandlingInteraction", CheckInteraction)
end

-- local function GetCompletedCount(achievementId)
--     local criterionCount = GetAchievementNumCriteria(achievementId)
--     local completedCount = 0

--     for criterionNumber = 1, criterionCount do
--         local _, completed = GetAchievementCriterion(criterionNumber, 1)

--         if (completed) then
--             completedCount = completedCount + 1
--         end
--     end

--     return completedCount
-- end

local function OnPlayerActivated()
    zo_callLater(
        function()
            interactionReady = true
        end,
        1000
    )

    -- record the current progress of all fishing achievements
    -- for id, _ in ipairs(FB.Achievements) do
    --     FB.AchievementProgress[id] = GetCompletedCount(id)
    -- end
end

local function OnSlotUpdated(_, bagId, _, isNew)
    if (lure == nil) then
        return
    end

    if (bagId ~= _G.BAG_BACKPACK and bagId ~= _G.BAG_VIRTUAL) then
        return
    end

    if (not isNew) then
        if (lure) then
            --FB.Log("stopped fishing", "info")
            isFishing = false
            lure = nil
            StopTimer()

            -- play a sound if Votan's Fisherman is not installed
            if (not _G.VOTANS_FISHERMAN) then
                PlaySound(_G.SOUNDS.QUEST_ABANDONED)
            end
        end
    end
end

local function OnActionLayerChanged()
    if (not FB.moving) then
        StopTimer()
        return
    end
end

local function InitialiseGui(gui)
    FB.GUI = gui
    gui.owner = FB

    -- lock button
    FB.GUI.LockButton = gui:GetNamedChild("LockButton")

    -- timer
    local timerBar = gui:GetNamedChild("TimerBar")
    FB.timer = ZO_TimerBar:New(timerBar)
    FB.timer:SetDirection(_G.TIMER_BAR_COUNTS_DOWN)

    -- set the 'Fishing...' label
    FB.Label = timerBar:GetNamedChild("Label")
    FB.Label:SetText(GetString(_G.SI_GUILDACTIVITYATTRIBUTEVALUE9) .. "...")

    -- bar
    FB.Bar = timerBar:GetNamedChild("Status")

    -- set position and colours
    FB.Setup()
end

local function OnBonusChanged(_, bonusType)
    if (bonusType == _G.NON_COMBAT_BONUS_FISHING_TIME_REDUCTION_PERCENT) then
        bonus = 1 - (GetNonCombatBonus(bonusType) / 100)
        --FB.Log("Bonus: " .. (bonus or "nil"), "warn")
        FISHING_INTERVAL = DEFAULT_FISHING_INTERVAL * bonus
    end
end

local function OnAchievementUpdated(_, achievementId)
    if (FB.Vars.PlayEmote) then
        -- are we tracking this achievement?
        if (FB.Achievements[achievementId]) then
            -- we caught a special fishy
            PlayEmoteByIndex(FB.Vars.Emote)
        end
    end
end

local function Initialise()
    if (_G.LibDebugLogger ~= nil) then
        FB.Logger = _G.LibDebugLogger(FB.Name)
    end

    -- saved variables
    FB.Vars =
        _G.LibSavedVars:NewAccountWide("FishBarSavedVars", "Account", FB.Defaults):AddCharacterSettingsToggle(
        "FishBarSavedVars",
        "Characters"
    )

    -- get current language
    FB.Language = GetCVar("language.2")
    FB.ReelIn = GetString(_G.SI_GAMECAMERAACTIONTYPE17)

    HookInteraction()

    EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
    EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnSlotUpdated)
    EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_ACTION_LAYER_POPPED, OnActionLayerChanged)
    EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_ACTION_LAYER_PUSHED, OnActionLayerChanged)
    EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_NON_COMBAT_BONUS_CHANGED, OnBonusChanged)
    EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_ACHIEVEMENT_UPDATED, OnAchievementUpdated)

    FB.RegisterSettings()

    bonus = 1 - (GetNonCombatBonus(_G.NON_COMBAT_BONUS_FISHING_TIME_REDUCTION_PERCENT) / 100)
    FISHING_INTERVAL = DEFAULT_FISHING_INTERVAL * bonus

    InitialiseGui(_G.FishBarWindow)

    local libWarning = FB.Vars.LibWarning

    if (not _G.LibFBCommon and not libWarning) then
        ZO_Dialogs_RegisterCustomDialog(
            "FishBarLibWarning",
            {
                title = {text = "|c4f34ebFish Bar|r"},
                mainText = {
                    text = GetString(_G.FISHBAR_LFC)
                },
                buttons = {
                    {
                        text = ZO_CachedStrFormat("<<C:1>>", GetString(_G.SI_DIALOG_CONFIRM)),
                        callback = function()
                            FB.Vars.LibWarning = true
                        end
                    }
                }
            }
        )

        ZO_Dialogs_ShowDialog("FishBarLibWarning")
    end
end

function FB.Setup()
    FB.Bar:SetColor(FB.Vars.BarColour.r, FB.Vars.BarColour.g, FB.Vars.BarColour.b, FB.Vars.BarColour.a)
    FB.Label:SetHidden(not FB.Vars.ShowFishing)
    FB.Label:SetColor(FB.Vars.LabelColour.r, FB.Vars.LabelColour.g, FB.Vars.LabelColour.b, FB.Vars.LabelColour.a)

    -- position
    local position = FB.Vars.Position

    if (position) then
        FB.GUI:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, position.Left, position.Top)
    end
end

function FB.EnableMoving()
    if (SCENE_MANAGER:IsInUIMode() and not WINDOW_MANAGER:IsSecureRenderModeEnabled()) then
        SCENE_MANAGER:SetInUIMode(false)
    end

    ZO_SceneManager_ToggleHUDUIBinding()
    StartTimer(FRAME_MOVE_INTERVAL)
    FB.GUI:SetMovable(true)
    FB.GUI:SetMouseEnabled(true)
    FB.GUI.LockButton:SetHidden(false)
    FB.moving = true
end

function FB.LockClick()
    -- save settings
    local top, left = FB.GUI:GetTop(), FB.GUI:GetLeft()

    FB.Vars.Position = {
        Top = top,
        Left = left
    }

    -- reset
    ZO_SceneManager_ToggleHUDUIBinding()
    FB.GUI:SetMouseEnabled(false)
    FB.GUI:SetMovable(false)
    FB.GUI.LockButton:SetHidden(true)
    StopTimer()
    FB.moving = false
end

function FB.Log(message, severity)
    if (FB.Logger) then
        if (severity == "info") then
            FB.Logger:Info(message)
        elseif (severity == "warn") then
            FB.Logger:Warn(message)
        elseif (severity == "debug") then
            FB.Logger:Debug(message)
        end
    end
end

function FB.OnAddonLoaded(_, addonName)
    if (addonName ~= FB.Name) then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(FB.Name, EVENT_ADD_ON_LOADED)

    Initialise()
end

EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_ADD_ON_LOADED, FB.OnAddonLoaded)
