std = "min"
max_line_length = 160

-- globals used within the Companion Frame addon
read_globals = {
    ["EVENT_MANAGER"] = {
        fields = {
            RegisterForEvent = {read_only = true},
            UnregisterForEvent = {read_only = true}
        }
    },
    ["SCENE_MANAGER"] = {
        fields = {
            GetCurrentScene = {read_only = true},
            GetScene = {read_only = true},
            IsInUIMode = {read_only = true},
            SetInUIMode = {read_only = true}
        }
    },
    ["WINDOW_MANAGER"] = {
        fields = {
            CreateTopLevelWindow = {read_only = true},
            CreateControl = {read_only = true},
            IsSecureRenderModeEnabled = {read_only = true}
        }
    },
    -- events
    "EVENT_ACTION_LAYER_POPPED",
    "EVENT_ACTION_LAYER_PUSHED",
    "EVENT_ACTIVE_COMPANION_STATE_CHANGED",
    "EVENT_ADD_ON_LOADED",
    "EVENT_COMPANION_ACTIVATED",
    "EVENT_COMPANION_DEACTIVATED",
    "EVENT_COMPANION_EXPERIENCE_GAIN",
    "EVENT_COMPANION_RAPPORT_UPDATE",
    "EVENT_INVENTORY_SINGLE_SLOT_UPDATE",
    "EVENT_NON_COMBAT_BONUS_CHANGED",
    "EVENT_PLAYER_ACTIVATED",
    "EVENT_POWER_UPDATE",
    "EVENT_UNIT_CREATED",
    "EVENT_UNIT_DESTROYED",
    "EVENT_ZONE_CHANGED",
    -- Flat Badger's translations
    "COMPANIONFRAME_COMPANIONBUTTONS",
    "COMPANIONFRAME_EXPERIENCEBARCOLOUR",
    "COMPANIONFRAME_FONTCOLOUR",
    "COMPANIONFRAME_FONTNAME",
    "COMPANIONFRAME_FONTSIZE",
    "COMPANIONFRAME_HEALTHBARCOLOUR",
    "COMPANIONFRAME_HIDEWHENGROUPED",
    "COMPANIONFRAME_HIDEWHENGROUPEDTOOLTIP",
    "COMPANIONFRAME_LOCKCOMPANIONBUTTONS",
    "COMPANIONFRAME_LOCKPOSITION",
    "COMPANIONFRAME_RAPPORTDISLIKE",
    "COMPANIONFRAME_RAPPORTLIKE",
    "COMPANIONFRAME_RAPPORTMODERATE",
    "COMPANIONFRAME_RELOAD",
    "COMPANIONFRAME_RESUMMON",
    "COMPANIONFRAME_RESUMMONTOOLTIP",
    "COMPANIONFRAME_SHOWCOMPANIONBUTTONS",
    "COMPANIONFRAME_SHOWDISMISS",
    "COMPANIONFRAME_SHOWEXPERIENCE",
    "COMPANIONFRAME_SHOWLEVEL",
    "COMPANIONFRAME_SHOWNAME",
    "COMPANIONFRAME_SHOWRAPPORT",
    "COMPANIONFRAME_SHOWRAPPORTICON",
    "COMPANIONFRAME_UNITFRAMEHEIGHT",
    "COMPANIONFRAME_UNITFRAMEWIDTH",
    "COMPANIONFRAME_RAPPORTTOOLTIP",
    "COMPANIONFRAME_SHOWSUMMONING",
    "COMPANIONFRAME_SUMMONING",
    "COMPANIONFRAME_SUMMONINGCOLOUR",
    -- constants
    "BOTTOM",
    "BOTTOMLEFT",
    "BSTATE_NORMAL",
    "CD_TYPE_RADIAL",
    "CD_TYPE_VERTICAL",
    "CD_TYPE_VERTICAL_REVEAL",
    "CD_TIME_TYPE_TIME_UNTIL",
    "CENTER",
    "COLLECTIBLE_CATEGORY_TYPE_ASSISTANT",
    "COLLECTIBLE_CATEGORY_TYPE_COMPANION",
    "CT_BACKDROP",
    "CT_BUTTON",
    "CT_CONTROL",
    "CT_COOLDOWN",
    "CT_LABEL",
    "CT_STATUSBAR",
    "CT_TEXTURE",
    "DT_HIGH",
    "LEFT",
    "POWERTYPE_HEALTH",
    "RETICLE",
    "RIGHT",
    "TOP",
    "TOPLEFT",
    "TOPRIGHT",
    ["UNIT_FRAMES"] = {
        fields = {
            GetFrame = {read_only = true}
        }
    },
    -- lua
    "FormatIntegerWithDigitGrouping",
    "GetCVar",
    "GetString",
    "GuiRoot",
    "unpack",
    --API
    "DoesUnitExist",
    "GetActiveCollectibleByType",
    "GetActiveCompanionDefId",
    "GetActiveCompanionLevelInfo",
    "GetActiveCompanionRapport",
    "GetActiveCompanionRapportLevel",
    "GetActiveCompanionRapportLevelDescription",
    "GetCollectibleCooldownAndDuration",
    "GetCollectibleInfo",
    "GetCompanionCollectibleId",
    "GetCompanionName",
    "GetFishingLure",
    "GetGameCameraInteractableActionInfo",
    "GetMaximumRapport",
    "GetMinimumRapport",
    "GetNonCombatBonus",
    "GetNumExperiencePointsInCompanionLevel",
    "GetPendingCompanionDefId",
    "GetFrameTimeMilliseconds",
    "GetUnitName",
    "GetUnitPower",
    "HasActiveCompanion",
    "HasPendingCompanion",
    "IsCollectibleBlocked",
    "IsCollectibleUsable",
    "IsUnitGrouped",
    "PlaySound",
    "ReloadUI",
    "UseCollectible",
    -- Zenimax objects
    "HUD_SCENE",
    "ZO_CreateStringId",
    ["ZO_HiddenReasons"] = {
        fields = {
            New = {read_only = true}
        }
    },
    ["ZO_HUDFadeSceneFragment"] = {
        fields = {
            New = {read_only = true}
        }
    },
    "ZO_PreHook",
    "ZO_PreHookHandler",
    "ZO_PostHook",
    ["ZO_SavedVars"] = {
        fields = {
            NewAccountWide = {read_only = true}
        }
    },
    "ZO_SceneManager_ToggleHUDUIBinding",
    "ZO_SmallGroupAnchorFrame",
    "ZO_TimerBar",
    "ZO_Tooltips_HideTextTooltip",
    "ZO_Tooltips_ShowTextTooltip",
    -- Zenimax functions
    "zo_callLater",
    "zo_roundToNearest",
    "zo_strformat",
    "zo_strsplit"
}
