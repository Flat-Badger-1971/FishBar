_G.FishBar = {
    Name = "FishBar",
    Defaults = {
        Position = nil,
        BarColour = {r = 50 / 255, g = 115 / 255, b = 168 / 255, a = 1},
        ShowFishing = true,
        LabelColour = {r = 1, g = 1, b = 1, a = 1}
    }
}

local FB = _G.FishBar

FB.LAM = _G.LibAddonMenu2

local panel = {
    type = "panel",
    name = "Fish Bar",
    displayName = "Fish Bar",
    author = "Flat Badger",
    version = "1.0.3",
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
    }
}

function FB.RegisterSettings()
    FB.LAM:RegisterAddonPanel("FishBarOptionsPanel", panel)
    FB.LAM:RegisterOptionControls("FishBarOptionsPanel", options)
end
