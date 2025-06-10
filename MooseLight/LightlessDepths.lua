local addon, ns = ... 
if not ns.LDActive == true then return end

local GetInstanceInfo, GetSubZoneText = GetInstanceInfo, GetSubZoneText
local C_UnitAuras_GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local SetCVar = C_CVar.SetCVar

local LD = CreateFrame("Frame")  --Lightless Depths

-- 減益對應數值 亮度 / 對比 / Gamma
local spellCVar = {
    [422806] = {Brightness = 60, Contrast = 75, Gamma = 2.0},
    [420307] = {Brightness = 60, Contrast = 70, Gamma = 1.5},
    [420807] = {Brightness = 60, Contrast = 70, Gamma = 1.5},
}

local defaultCVar = {
    Brightness = 50,
    Contrast   = 50,
    Gamma      = 1.2,
}

local curSpell
local function setCVar(cfg)
    if not cfg then
        -- 還原
        if curSpell then
            for k, v in pairs(defaultCVar) do
                SetCVar(k, v)
            end
            curSpell = nil
        end
        return
    end
    
    if curSpell ~= cfg.id then
        SetCVar("Brightness", cfg.Brightness)
        SetCVar("Contrast",   cfg.Contrast)
        SetCVar("Gamma",      cfg.Gamma)
        curSpell = cfg.id
    end
end

local function checkAura()
    local matched

    for spellID, cfg in next, spellCVar do
        if C_UnitAuras_GetPlayerAuraBySpellID(spellID) then
            matched = cfg
            matched.id = spellID
            break
        end
    end

    setCVar(matched)
end

local function zoneCheck()
    local instanceID = select(8, GetInstanceInfo())
    local name = GetSubZoneText()
    local inDepths = ns.ignoreID[instanceID] and ns.subName[name]

    if inDepths then
        LD:RegisterUnitEvent("UNIT_AURA", "player")
        checkAura()
    else
        LD:UnregisterEvent("UNIT_AURA")
        setCVar(nil)
    end
end

local function OnEvent(self, event)
    if event == "UNIT_AURA" then
        checkAura()
    else
        zoneCheck()
    end
end

LD:SetScript("OnEvent", OnEvent)
LD:RegisterEvent("PLAYER_ENTERING_WORLD")
LD:RegisterEvent("ZONE_CHANGED_NEW_AREA")
LD:RegisterEvent("ZONE_CHANGED_INDOORS")
LD:RegisterEvent("ZONE_CHANGED")
