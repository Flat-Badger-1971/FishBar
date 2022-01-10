_G.FishBar ={
    Name = "FishBar",
    Defaults = {
        Position = nil
    }
}

local FB = _G.FishBar

FB.LAM = _G.LibAddonMenu2

local panel = {
    type = "panel",
    name = "Fish Bar",
    displayName = "Fish Bar",
    author = "Flat Badger",
    version = "1.0.0"
}

local options = {
    [1] = {
        type = "button",
        name = GetString(_G.FISHBAR_MOVEFRAME),
        func = function() FB.EnableMoving() end,
        width = "full"
    }
}


function FB.RegisterSettings()
    FB.LAM:RegisterAddonPanel("FishBarOptionsPanel", panel)
    FB.LAM:RegisterOptionControls("FishBarOptionsPanel", options)
end