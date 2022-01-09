_G.FishBar = {}

local FB = _G.FishBar
local fishingInteractableName = nil
local interactionReady = false
local lastAction = nil
local lure = nil

FB.Name = "FishBar"

local function StartTimer()
    local now = GetFrameTimeMilliseconds()
    local timerStartSeconds = now / 1000
    local timerEndSeconds = timerStartSeconds + 30

    FB.inDialog = false
    FB.GUI:SetHidden(false)
    FB.timer:Start(timerStartSeconds, timerEndSeconds)
end

local function StopTimer()
    FB.timer:Stop()
    FB.GUI:SetHidden(true)
end

--*** based on code borrowed from VoltansFisherman
local function NewInteraction()
    if (not interactionReady) then
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
                StartTimer()
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
--***

local function Initialise()
    HookInteraction()
    EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_PLAYER_ACTIVATED, FB.OnPlayerActivated)
    EVENT_MANAGER:RegisterForEvent(FB.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, FB.OnSlotUpdated)
    EVENT_MANAGER:RegisterForEvent(FB.name, EVENT_ACTION_LAYER_POPPED, FB.OnActionLayerChanged)
	EVENT_MANAGER:RegisterForEvent(FB.name, EVENT_ACTION_LAYER_PUSHED, FB.OnActionLayerChanged)
end

function FB.InitialiseGui(gui)
    FB.GUI = gui
    gui.owner = FB
    local timerBar = gui:GetNamedChild("TimerBar")
    FB.timer = ZO_TimerBar:New(timerBar)
    FB.timer:SetDirection(_G.TIMER_BAR_COUNTS_DOWN)
    timerBar:GetNamedChild("Label"):SetText(GetString(_G.SI_GUILDACTIVITYATTRIBUTEVALUE9) .. "...")
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
    StopTimer()
end

EVENT_MANAGER:RegisterForEvent(FB.Name, EVENT_ADD_ON_LOADED, FB.OnAddonLoaded)
