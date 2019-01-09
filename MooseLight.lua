-- [[ 根據地點調整亮度 ]] --

-- add new map id by yourself:
-- https://wow.gamepedia.com/UiMapID
-- macro to get your map id:
-- /dump C_Map.GetBestMapForUnit("player")

local timeID = {
	[896] = true,	-- Drustvar / 佐司瓦
	[942] = true,	-- Stormsong Valley / 斯托頌恩
	[1196] = true,	-- Tiragarde Sound / 提加拉德
}

local ID = {
	-- Orgrimmar / 奧格瑪
	[86] = true,	-- 暗影裂谷
	
	-- 威奎斯特莊園 / Waycrest Manor
	[1015] = true,	-- The Grand Foyer 
	[1016] = true,	-- Upstairs
	[1017] = true,	-- The Cellar
	[1018] = true,	-- Catacombs
	[1029] = true,	-- 底層
	
	-- 托達戈爾 / Tol Dagor
	[974] = true,
	[975] = true,	-- The Drain
	[976] = true,	-- The Brig
	[977] = true,	-- Detention Block
	[978] = true,	-- Officer Quarters
	[979] = true,	-- Overseer's Redoubt
	[980] = true,	-- Overseer's Summit
	[1169] = true,
	
	-- Kings' Rest / 諸王之眠
	[1004] = true,
	
	-- Siege of Boralus / 波拉勒斯圍城戰
	[1162] = true,
	
	-- Temple of Sethraliss / 瑟沙利斯神廟
	[1038] = true,
	--[1042] = true,	-- Atrium of Sethraliss
	
	-- Shrine of the Storm / 風暴聖壇
	--[1040] = true,
	
	-- Uldir / 奧迪爾
	[1152] = true,	-- Plague Vault(維克提斯)
	--[[
	[1148] = true,	-- Ruin's Descent(一王)
	[1149] = true,	-- Hall of Sanitation(二王)
	[1150] = true,	-- Ring of Containment
	[1151] = true,	-- Archives of Eternity(蟲)
	[1153] = true,	-- Gallery of Failures(狗)
	[1154] = true,	-- The Oblivion Door(祖爾)
	[1155] = true,	-- The Festering Core(尾王)
	]]--
}

local function changeGamma()
	local MapId = C_Map.GetBestMapForUnit("player")
	if MapId and ID[MapId] then
		-- set gamma here
		SetCVar("Gamma", 1.2)
	else
		SetCVar("Gamma", 1)
	end
end


local function changeGammabyTime()
	local hour, _ = GetGameTime()
	local MapId = C_Map.GetBestMapForUnit("player")
	if MapId and timeID[MapId] then
		if hour > 17 or hour < 6 then
			SetCVar("Gamma", 1.2)
		else
			SetCVar("Gamma", 1)
		end
	end
end

local function eventHandler(self, event, ...)
	changeGamma()
	changeGammabyTime()
end

local CG = CreateFrame("Frame", "changeGamma")
	CG:RegisterEvent("PLAYER_LOGIN")
	CG:RegisterEvent("PLAYER_ENTERING_WORLD")
	CG:RegisterEvent("ZONE_CHANGED")
	CG:RegisterEvent("ZONE_CHANGED_INDOORS")
	CG:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	CG:RegisterEvent("VARIABLES_LOADED")
	--CG:RegisterEvent("PLAYER_REGEN_ENABLED")

	CG:SetScript("OnEvent", eventHandler)
