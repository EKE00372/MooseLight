-- [[ 根據地點調整亮度 ]] --

-- add new map id by yourself:
-- https://wow.gamepedia.com/UiMapID
-- https://wowpedia.fandom.com/wiki/InstanceID
-- macro to get your map id:
-- /dump C_Map.GetBestMapForUnit("player")
-- CVar Gamma/Brightness/Contrast

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetGameTime, GetSubZoneText = GetGameTime, GetSubZoneText
local SetCVar = C_CVar.SetCVar


local timeID = {
	-- BFA
	[896] = true,	-- Drustvar / 佐司瓦
	[895] = true,	-- Tiragarde Sound / 提加拉德
	[942] = true,	-- Stormsong Valley / 斯托頌恩
	-- DF
	[2022] = true,	-- 甦醒海岸
	[2023] = true,	-- 雍亞拉平原
	[2024] = true,	-- 蒼藍高地
	[2025] = true,	-- 薩爪祖斯
}

local zoneDarkID = {
	--DF
	[1533] = true,	-- Bastion / 昇靈堡
	[1707] = true,	-- Elysian Hold, Archon's Rise / 樂土堡
	[1708] = true,	-- Elysian Hold, Sanctum of Binding / 樂土堡
}

local zoneLightID = {
	-- AZEROTH
	[86] = true,	-- Orgrimmar / 奧格瑪暗影裂谷
	-- LEGION
	[885] = true,	-- 安托洛斯荒原
	-- BFA
	[1038] = true,	-- Temple of Sethraliss / 瑟沙利斯神廟，尾王中庭以外
	[1152] = true,	-- Uldir, Plague Vault / 奧迪爾，維克提斯
	[1169] = true,	-- Tol Dagor outside / 托達戈爾戶外	
	[1469] = true, -- Vision of Orgrimmar / 奧格瑪幻象
	[1470] = true, -- Vision of Stormwind / 暴風城幻象
	[1570] = true, -- 恆春谷幻象
	[1571] = true, -- 奧丹姆幻象
	-- DF
	[2095] = true,	-- 晶紅生命之池，閃霜入侵點 / Ruby Life Pools, Infusion Chambers
	[2095] = true,	-- 洪荒化身牢獄，孵育窩巢 / Vault of the Incarnates, The Primal Convergence
	[2151] = true,	-- 澤斯克拉密庫
	[2168] = true,	-- 亞貝魯斯，違抗者壁壘
}

local insLightID = {
	-- WOD
	[1176] = true,	-- 影月墓地 / Shadowmoon Burial Grounds
	-- BFA
	[1762] = true,	-- 諸王之眠 / Kings' Rest
	[1711] = true,	-- 托達戈爾 / Tol Dagor
	[1862] = true,	-- 威奎斯特莊園 / Waycrest Manor
	[1822] = true,	-- Siege of Boralus / 波拉勒斯圍城戰
	-- SL
	[2284] = true,	-- 血紅深淵 / Sanguine Depths
	[2162] = true,	-- 托加斯特 / Torghast, Tower of the Damned
	-- DF
	[2515] = true,	-- 蒼藍密庫 / The Azure Vault
	[2519] = true,	-- 奈薩魯斯堡 / Neltharus
	[2527] = true,	-- 灌注迴廊 / Halls of Infusion
}

local insDarkID = {
	[2285] = true,	-- 	晉升之巔 / Spires Of Ascension
}

local function OnEvent()
	local MapID = C_Map_GetBestMapForUnit("player")
	local hour = GetGameTime()
	local name = GetSubZoneText()
	local instanceID = select(8, GetInstanceInfo())
	
	if not MapID then return end
	
	if zoneLightID[MapID] or insLightID[instanceID] then
		-- set gamma here
		SetCVar("Gamma", 1.2)		-- 0.3~2.8
		SetCVar("Brightness", 50)	-- 1~100
	elseif zoneDarkID[MapID] or insDarkID[instanceID] then
		SetCVar("Gamma", .9)
		SetCVar("Brightness", 40)
	elseif timeID[MapID] then
		if hour and (hour < 6 or hour > 17) then
			SetCVar("Gamma", 1.2)
			SetCVar("Brightness", 50)
		else
			SetCVar("Gamma", 1)
			SetCVar("Brightness", 50)
		end
	elseif nameList[name] then
		SetCVar("Gamma", 1.2)
		SetCVar("Brightness", 50)
	else
		SetCVar("Gamma", 1)
		SetCVar("Brightness", 50)
	end
	
	-- FUCK YOU!
	SetCVar("ffxGlow", 0)
	SetCVar("ffxDeath", 0)
end

local CG = CreateFrame("Frame")
	CG:RegisterEvent("PLAYER_ENTERING_WORLD")
	CG:RegisterEvent("ZONE_CHANGED")
	CG:RegisterEvent("ZONE_CHANGED_INDOORS")
	CG:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	CG:SetScript("OnEvent", function() C_Timer.After(3, OnEvent) end)