-- [[ 根據地點調整亮度 ]] --

-- add new map id by yourself:
-- https://wow.gamepedia.com/UiMapID
-- https://wowpedia.fandom.com/wiki/InstanceID
-- macro to get your map id:
-- /dump C_Map.GetBestMapForUnit("player")
-- CVar Gamma/Brightness/Contrast

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetInstanceInfo, GetGameTime, GetSubZoneText = GetInstanceInfo, GetGameTime, GetSubZoneText
local SetCVar = C_CVar.SetCVar

local timeID = {
	-- BFA
	[896] = true,	-- Drustvar / 佐司瓦
	[895] = true,	-- Tiragarde Sound / 提加拉德
	[942] = true,	-- Stormsong Valley / 斯托頌恩
	-- DF
	[2022] = true,	-- The Waking Shores / 甦醒海岸
	[2023] = true,	-- 	Ohn'ahran Plains / 雍亞拉平原
	[2024] = true,	-- The Azure Span / 蒼藍高地
	[2025] = true,	-- 	Thaldraszus / 薩爪祖斯
	--[1462] = true,	-- 麥卡貢/機械岡
	--[1196] = true,
	--[1197] = true,
	--[1198] = true,
}

local zoneDarkID = {
	-- SL
	[1533] = true,	-- Bastion / 昇靈堡
	[1707] = true,	-- Elysian Hold, Archon's Rise / 樂土堡
	[1708] = true,	-- Elysian Hold, Sanctum of Binding / 樂土堡
}

local zoneLightID = {
	-- AZEROTH
	[86] = true,	-- Orgrimmar / 奧格瑪暗影裂谷
	-- LEGION
	[885] = true,	-- Antoran Wastes / 安托洛斯荒原
	-- BFA
	[1162] = true,	-- Siege of Boralus / 波拉勒斯圍城戰
	[1038] = true,	-- Temple of Sethraliss / 瑟沙利斯神廟
	[1152] = true,	-- Uldir, Plague Vault / 奧迪爾，維克提斯
	[1169] = true,	-- Tol Dagor outside / 托達戈爾戶外	
	-- BFA VISION
	[1469] = true, -- Vision of Orgrimmar / 奧格瑪幻象
	[1470] = true, -- Vision of Stormwind / 暴風城幻象
	[1570] = true, -- 恆春谷幻象
	[1571] = true, -- 奧丹姆幻象
	-- sl
	[1543] = true, -- The Maw / 噬淵
	--[1961] = true, -- Korthia / 科西亞
	-- DF
	[2151] = true,	-- The Forbidden Reach / 禁忌離島 (澤斯克拉密庫沒有單獨的地圖)
	[2095] = true,	-- Infusion Chambers / 閃霜入侵點
	[2133] = true,	-- Zaralek Cavern / 扎拉萊克洞穴
	
}

local insLightID = {
	-- AZEROTH
	[289] = true,	-- Scholomance OLD / 舊通靈學院
	[1007] = true,	-- Scholomance / 新通靈學院
	[329] = true,	-- Stratholme / 斯坦索姆
	[533] = true,	-- Naxxramas / 納克薩瑪斯
	-- WOD
	[1176] = true,	-- Shadowmoon Burial Grounds / 影月墓地
	-- LEG
	[1466] = true,	-- Darkheart Thicket / 暗心灌木林
	[1501] = true,	-- Black Rook Hold / 玄鴉堡
	-- BFA
	[1841] = true,	-- The Underrot / 幽腐深窟
	[1762] = true,	-- Kings' Rest / 諸王之眠
	[1711] = true,	-- Tol Dagor / 托達戈爾
	[1862] = true,	-- Waycrest Manor / 威奎斯特莊園
	-- SL
	[2284] = true,	-- Sanguine Depths / 血紅深淵
	[2162] = true,	-- Torghast, Tower of the Damned / 托加斯特
	-- DF
	[2515] = true,	-- The Azure Vault / 蒼藍密庫
	[2519] = true,	-- Neltharus / 奈薩魯斯堡
	[2520] = true,	-- Brackenhide Hollow / 撅屁...蕨皮谷
	--[2527] = true,	-- Halls of Infusion / 灌注迴廊
}

local insDarkID = {
	[2285] = true,	-- Spires Of Ascension / 晉升之巔
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