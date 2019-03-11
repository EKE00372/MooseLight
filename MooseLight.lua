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

	--[1196] = true,
	--[1197] = true,
	--[1198] = true,
}

local zoneID = {
	[86] = true,	-- Orgrimmar / 奧格瑪暗影裂谷
	--[1040] = true,	-- Shrine of the Storm / 風暴聖壇
	[1004] = true,	-- Kings' Rest / 諸王之眠
	[1162] = true,	-- Siege of Boralus / 波拉勒斯圍城戰
	[1038] = true,	-- Temple of Sethraliss / 瑟沙利斯神廟
	--[1042] = true,	-- Atrium of Sethraliss / 瑟沙利斯中庭
	[1152] = true,		-- Uldir, Plague Vault / 奧迪爾維克提斯
	
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
}

local nameList = {
	["潮水聖所"] = true,
	["潮水圣殿"] = true,
}

local function changeGamma()
	local MapId = C_Map.GetBestMapForUnit("player")
	local hour, _ = GetGameTime()
	local name = GetSubZoneText()
	
	if not MapId then return end
	
	if zoneID[MapId] then
		-- set gamma here
		SetCVar("Gamma", 1.2)
	elseif timeID[MapId] then
		if hour and (hour < 6 or hour > 17) then
			SetCVar("Gamma", 1.2)
		else
			SetCVar("Gamma", 1)
		end
	--elseif name == "潮水聖所" or name == "潮水圣殿" then
		--SetCVar("Gamma", 1.2)
	elseif nameList[name] then
		SetCVar("Gamma", 1.2)
	else
		SetCVar("Gamma", 1)
	end
end

local function eventHandler(self, event, ...)
	changeGamma()
end

local CG = CreateFrame("Frame", "changeGamma")
	--CG:RegisterEvent("PLAYER_LOGIN")
	--CG:RegisterEvent("CHALLENGE_MODE_START")
	--CG:RegisterEvent("PLAYER_REGEN_ENABLED")
	CG:RegisterEvent("PLAYER_ENTERING_WORLD")
	CG:RegisterEvent("ZONE_CHANGED")
	CG:RegisterEvent("ZONE_CHANGED_INDOORS")
	CG:RegisterEvent("ZONE_CHANGED_NEW_AREA")	
	CG:RegisterEvent("VARIABLES_LOADED")

	CG:SetScript("OnEvent", eventHandler)