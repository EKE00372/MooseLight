-- [[ 根據地點調整亮度 ]] --

-- add new map id by yourself:
-- https://wow.gamepedia.com/UiMapID
-- macro to get your map id:
-- /dump C_Map.GetBestMapForUnit("player")
-- CVar Gamma/Brightness/Contrast

local timeID = {
	[896] = true,	-- Drustvar / 佐司瓦
	[895] = true,	-- Tiragarde Sound / 提加拉德
	[942] = true,	-- Stormsong Valley / 斯托頌恩
	--[1462] = true,	-- 麥卡貢/機械岡
	--[1196] = true,
	--[1197] = true,
	--[1198] = true,
}

local zoneDarkID = {
	[1533] = true,	-- Bastion / 昇靈堡
	[1707] = true,	-- Elysian Hold, Archon's Rise / 樂土堡
	[1708] = true,	-- Elysian Hold, Sanctum of Binding / 樂土堡
	
	-- 	Spires Of Ascension
	[1692] = true,
	[1693] = true,
	[1694] = true,
	[1695] = true,
}

local zoneLightID = {
	[86] = true,	-- Orgrimmar / 奧格瑪暗影裂谷
	
	[1004] = true,	-- Kings' Rest / 諸王之眠
	[1162] = true,	-- Siege of Boralus / 波拉勒斯圍城戰
	[1038] = true,	-- Temple of Sethraliss / 瑟沙利斯神廟
	[1152] = true,	-- Uldir, Plague Vault / 奧迪爾維克提斯
	
	-- 威奎斯特莊園 / Waycrest Manor
	[1015] = true,	-- The Grand Foyer
	[1016] = true,	-- Upstairs
	[1017] = true,	-- The Cellar
	[1018] = true,	-- Catacombs
	[1029] = true,	-- 底層
	
	-- 托達戈爾 / Tol Dagor
	[974] = true,	-- Tol Dagor
	[975] = true,	-- The Drain
	[976] = true,	-- The Brig
	[977] = true,	-- Detention Block
	[978] = true,	-- Officer Quarters
	[979] = true,	-- Overseer's Redoubt
	[980] = true,	-- Overseer's Summit
	[1169] = true,	-- Tol Dagor outside / 托達戈爾戶外	
	
	[1469] = true, -- Vision of Orgrimmar / 奧格瑪幻象
	[1470] = true, -- Vision of Stormwind / 暴風城幻象
	[1570] = true, -- 恆春谷幻象
	[1571] = true, -- 奧丹姆幻象
	
	-- 血紅深淵 / Sanguine Depths
	[1675] = true,
	[1676] = true,
}

local nameList = {
	["潮水聖所"] = true,
	["潮水圣殿"] = true,
}

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetGameTime, GetSubZoneText = GetGameTime, GetSubZoneText
local SetCVar = SetCVar

local function OnEvent()
	local MapId = C_Map_GetBestMapForUnit("player")
	local hour = GetGameTime()
	local name = GetSubZoneText()
	
	if not MapId then return end
	
	if zoneLightID[MapId] then
		-- set gamma here
		SetCVar("Gamma", 1.2)		-- 0.3~2.8
		SetCVar("Brightness", 50)	-- 1~100
	elseif zoneDarkID[MapId] then
		SetCVar("Gamma", .9)
		SetCVar("Brightness", 40)
	elseif timeID[MapId] then
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
end

local CG = CreateFrame("Frame")
	CG:RegisterEvent("PLAYER_ENTERING_WORLD")
	CG:RegisterEvent("ZONE_CHANGED")
	CG:RegisterEvent("ZONE_CHANGED_INDOORS")
	CG:RegisterEvent("ZONE_CHANGED_NEW_AREA")	
	CG:SetScript("OnEvent", OnEvent)