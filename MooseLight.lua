-- This file is loaded from "MooseLight.toc"

-- [[ 根據地點調整亮度 ]] --

local ID = {
	--[85] = true,	-- 奧格瑪
	[86] = true,	-- 奧格瑪暗影裂谷
	
	[1015] = true,	-- 威奎斯特莊園 / Waycrest Manor - The Grand Foyer 
	[1016] = true,	-- 威奎斯特莊園 / Waycrest Manor - Upstairs
	[1017] = true,	-- 威奎斯特莊園 / Waycrest Manor - The Cellar
	[1018] = true,	-- 威奎斯特莊園 / Waycrest Manor - Catacombs
	[1029] = true,	-- 威奎斯特莊園 / Waycrest Manor 底層
	
	[974] = true,	-- 托達戈爾 / Tol Dagor
	[975] = true,	-- 托達戈爾 / Tol Dagor - The Drain
	[976] = true,	-- 托達戈爾 / Tol Dagor - The Brig
	[977] = true,	-- 托達戈爾 / Tol Dagor - Detention Block
	[978] = true,	-- 托達戈爾 / Tol Dagor - Officer Quarters
	[979] = true,	-- 托達戈爾 / Tol Dagor - Overseer's Redoubt
	[980] = true,	-- 托達戈爾 / Tol Dagor - Overseer's Summit
	
	[1004] = true,	-- 諸王之眠

	[1169] = true,	-- 托達戈爾野外 / Tol Dagor
	[1162] = true,	-- 波拉勒斯圍城戰
}

local function changeGamma()
	local MapId = C_Map.GetBestMapForUnit("player")
	if MapId and ID[MapId] then
		SetCVar("Gamma", 1.2)
	else
		SetCVar("Gamma", 1)
	end
end

local CG = CreateFrame("Frame", "changeGamma")
	CG:RegisterEvent("PLAYER_LOGIN")
	CG:RegisterEvent("PLAYER_ENTERING_WORLD")
	CG:RegisterEvent("ZONE_CHANGED")
	CG:RegisterEvent("ZONE_CHANGED_INDOORS")
	CG:RegisterEvent("ZONE_CHANGED_NEW_AREA")
local function eventHandler(self, event, ...)
	changeGamma() 
end
CG:SetScript("OnEvent", eventHandler)
