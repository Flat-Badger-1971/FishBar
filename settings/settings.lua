local FB = _G.FishBar
local emoteList = {}

do
    for _, emoteName in pairs(FB.Emotes) do
        table.insert(emoteList, emoteName)
    end

    table.sort(emoteList, function(a, b) return a < b end);
end

FB.LAM = _G.LibAddonMenu2

local panel = {
    type = "panel",
    name = "Fish Bar",
    displayName = "Fish Bar",
    author = "Flat Badger",
    version = "1.1.1",
    resetFunc = function()
        FB.Setup()
    end,
    registerForDefaults = true,
    slashCommand = "/fb"
}

local options = {
    [1] = {
        type = "button",
        name = GetString(_G.FISHBAR_MOVEFRAME),
        func = function()
            FB.EnableMoving()
        end,
        width = "full"
    },
    [2] = {
        type = "checkbox",
        name = GetString(_G.FISHBAR_SHOW_LABEL),
        getFunc = function()
            return FB.Vars.ShowFishing
        end,
        setFunc = function(value)
            FB.Vars.ShowFishing = value
            FB.Label:SetHidden(not value)
        end,
        width = "full",
        default = FB.Defaults.ShowFishing
    },
    [3] = {
        type = "colorpicker",
        name = GetString(_G.FISHBAR_LABEL_COLOUR),
        getFunc = function()
            return FB.Vars.LabelColour.r, FB.Vars.LabelColour.g, FB.Vars.LabelColour.b, FB.Vars.LabelColour.a
        end,
        setFunc = function(r, g, b, a)
            FB.Vars.LabelColour = {r = r, g = g, b = b, a = a}
            FB.Label:SetColor(r, g, b, a)
        end,
        width = "full",
        default = FB.Defaults.LabelColour
    },
    [4] = {
        type = "colorpicker",
        name = GetString(_G.FISHBAR_BAR_COLOUR),
        getFunc = function()
            return FB.Vars.BarColour.r, FB.Vars.BarColour.g, FB.Vars.BarColour.b, FB.Vars.BarColour.a
        end,
        setFunc = function(r, g, b, a)
            FB.Vars.BarColour = {r = r, g = g, b = b, a = a}
            FB.Bar:SetColor(r, g, b, a)
        end,
        width = "full",
        default = FB.Defaults.BarColour
    },
    [5] = {
        type = "checkbox",
        name = GetString(_G.FISHBAR_EMOTE),
        tooltip = GetString(_G.FISHBAR_EMOTE_DESC),
        getFunc = function()
            return FB.Vars.PlayEmote
        end,
        setFunc = function(value)
            FB.Vars.PlayEmote = value
            CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", FB.OptionsPanel)
        end,
        width = "full",
        default = FB.Defaults.PlayEmote
    },
    [6] = {
        type = "dropdown",
        name = GetString(_G.SI_CHAT_CHANNEL_NAME_EMOTE),
        choices = emoteList,
        getFunc = function()
            return FB.Emotes[FB.Vars.Emote]
        end,
        setFunc = function(value)
            for idx, name in pairs(FB.Emotes) do
                if (name == value) then
                    FB.Vars.Emote = idx
                end
            end
        end,
        disabled = function()
            return FB.Vars.PlayEmote == false
        end,
        width = "full"
    }
}

function FB.RegisterSettings()
    FB.OptionsPanel = FB.LAM:RegisterAddonPanel("FishBarOptionsPanel", panel)
    FB.LAM:RegisterOptionControls("FishBarOptionsPanel", options)
end
