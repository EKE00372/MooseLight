-- [[ 根據地點調整亮度 ]] --

-- add new map id by yourself:
-- https://wow.gamepedia.com/UiMapID
-- macro to get your map id:
-- /dump C_Map.GetBestMapForUnit("player")

local ID = {
	-- Orgrimmar / 奧格瑪
	[86] = true,	-- 暗影裂谷
	
	-- Drustvar / 佐司瓦
	[896] = true,
	
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

local function eventHandler(self, event, ...)
	changeGamma() 
end

local CG = CreateFrame("Frame", "changeGamma")
	CG:RegisterEvent("PLAYER_LOGIN")
	CG:RegisterEvent("PLAYER_ENTERING_WORLD")
	CG:RegisterEvent("ZONE_CHANGED")
	CG:RegisterEvent("ZONE_CHANGED_INDOORS")
	CG:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	CG:SetScript("OnEvent", eventHandler)
