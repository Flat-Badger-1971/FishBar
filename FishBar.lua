--[[ Several portions of this code are based on VoltansFisherman ]]
local FB = _G.FishBar
local fishingInteractableName = nil
local interactionReady = false
local lastAction = nil
local lure = nil
local FISHING_INTERVAL = 30
local FRAME_MOVE_INTERVAL = 604800

local function StartTimer(interval)
    local now = GetFrameTimeMilliseconds()
    local timerStartSeconds = now / 1000
    local timerEndSeconds = timerStartSeconds + interval

    FB.inDialog = false
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
                FB.Log("fishing started", "info")
                lure = GetFishingLure()
                StartTimer(FISHING_INTERVAL)
            else
                StopTimer()
                lure = nil
            end
        end
    else
        if (lastAction == action) then
            return
        end

        lastAction = action
    end
end

local function HookInteraction()
    ZO_PreHookHandler(RETICLE.interact, "OnEffectivelyShown", NewInteraction)
    ZO_PreHookHandler(RETICLE.interact, "OnHide", NewInteraction)
end

local function SlashCommand()
    FB.LAM:OpenToPanel(_G.FishBarOptionsPanel)
end

local function Initialise()
    HookInteraction()
    EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_PLAYER_ACTIVATED, FB.OnPlayerActivated)
    EVENT_MANAGER:RegisterForEvent(FB.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, FB.OnSlotUpdated)
    EVENT_MANAGER:RegisterForEvent(FB.name, EVENT_ACTION_LAYER_POPPED, FB.OnActionLayerChanged)
    EVENT_MANAGER:RegisterForEvent(FB.name, EVENT_ACTION_LAYER_PUSHED, FB.OnActionLayerChanged)
    FB.RegisterSettings()
    FB.InitialiseGui(_G.FishBarWindow)
    _G.SLASH_COMMANDS["/fb"] = SlashCommand
end

function FB.EnableMoving()
    if (SCENE_MANAGER:IsInUIMode() and not WINDOW_MANAGER:IsSecureRenderModeEnabled()) then
        SCENE_MANAGER:SetInUIMode(false)
    end

    --SetGameCameraUIMode(true)
    ZO_SceneManager_ToggleHUDUIBinding()
    StartTimer(FRAME_MOVE_INTERVAL)
    FB.GUI:SetMovable(true)
    FB.GUI:SetMouseEnabled(true)
    FB.GUI.LockButton:SetHidden(false)
    FB.moving = true
end

function FB.LockClick()
    -- save settings
    local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = FB.GUI:GetAnchor()

    if (isValidAnchor) then
        FB.Vars.Position = {point, relativeTo, relativePoint, offsetX, offsetY}
    end

    -- reset
    --SetGameCameraUIMode(false)
    ZO_SceneManager_ToggleHUDUIBinding()
    FB.GUI:SetMouseEnabled(false)
    FB.GUI:SetMovable(false)
    FB.GUI.LockButton:SetHidden(true)
    StopTimer()
    FB.moving = false
end

function FB.InitialiseGui(gui)
    FB.GUI = gui
    gui.owner = FB

    -- lock button
    FB.GUI.LockButton = gui:GetNamedChild("LockButton")

    -- timer
    local timerBar = gui:GetNamedChild("TimerBar")
    FB.timer = ZO_TimerBar:New(timerBar)
    FB.timer:SetDirection(_G.TIMER_BAR_COUNTS_DOWN)
    timerBar:GetNamedChild("Label"):SetText(GetString(_G.SI_GUILDACTIVITYATTRIBUTEVALUE9) .. "...")

    -- position
    -- the first time the frame is moved we change the relative point
    FB.Vars.Position[2] = FB.Vars.Position[2] or GuiRoot
    local position = FB.Vars.Position

    if (position) then
        FB.GUI:SetAnchor(unpack(position))
    end
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
    if (addonName == "LibDebugLogger") then
        zo_callLater(
            function()
                FB.Logger = _G.LibDebugLogger(FB.Name)
            end,
            2000
        )
    end

    if (addonName ~= FB.Name) then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(FB.Name, EVENT_ADD_ON_LOADED)

    -- saved variables
    FB.Vars =
        _G.LibSavedVars:NewAccountWide("FishBarSavedVars", "Account", FB.Defaults):AddCharacterSettingsToggle(
        "FishBarSavedVars",
        "Characters"
    )

    -- get current language
    FB.Language = GetCVar("language.2")

    Initialise()
end

function FB.OnPlayerActivated()
    zo_callLater(
        function()
            interactionReady = true
        end,
        1000
    )
end

function FB.OnActionLayerChanged()
    FB.inDialog = not HUD_SCENE:IsShowing()

    if (not FB.moving) then
        StopTimer()

        return
    end
end

function FB.OnSlotUpdated(_, bagId, _, isNew)
    if (lure == nil) then
        return
    end

    if (bagId ~= _G.BAG_BACKPACK and bagId ~= _G.BAG_VIRTUAL) then
        return
    end

    if (not isNew) then
        if (lure) then
            FB.Log("stopped fishing", "info")
            StopTimer()
            lure = nil
        end
    end
end

EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_ADD_ON_LOADED, FB.OnAddonLoaded)
