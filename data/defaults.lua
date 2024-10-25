_G.FishBar = {
    Name = "FishBar",
    Defaults = {
        Position = nil,
        BarColour = {r = 50 / 255, g = 115 / 255, b = 168 / 255, a = 1},
        ShowFishing = true,
        LabelColour = {r = 1, g = 1, b = 1, a = 1},
        PlayEmote = true,
        Emote = 4
    },
    LC = _G.LibFBCommon
}

local FB = _G.FishBar

if (not FB.LC) then
    ZO_Dialogs_RegisterCustomDialog(
        FB.Name .. "LibWarning",
        {
            title = {text = "|c4f34ebFish Bar|r"},
            mainText = {
                text = GetString(_G.FISHBAR_LIB_TEXT)
            },
            buttons = {
                {
                    text = ZO_CachedStrFormat("<<C:1>>", GetString(_G.SI_DIALOG_CONFIRM)),
                    callback = function()
                    end
                }
            }
        }
    )

    ZO_Dialogs_ShowDialog(FB.Name .. "LibWarning")
end