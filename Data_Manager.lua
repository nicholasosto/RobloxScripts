-- Header: Player Attributes Management
-- This script handles player attributes in Roblox Studio, including data storage and default player values.

local Data_Manager = {}

-- Game Services
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Required Modules

-- Database Setup for Player Attributes
-- 'database_PlayerAttributes' is the data store for player attributes in the "DB_Ki_Blast_Game"
local database_PlayerAttributes = DataStoreService:GetDataStore("DB_Ki_Blast_Game", "DB_Attributes")

-- Default Player Attributes
-- This table defines the default attributes for a new player
local DefaultPlayerAttributes = {
	Level = 1,
	Experience = 0,
	Experience_Required = 500,
	Ki_Power = 14,
	Melee_Power = 3,
	Energy = 10000,
	Energy_Max = 10000,
	Zeni = 100000
}

-- Saves attributes for the player: TODO: Add check for attribute structure
local function savePlayerAttributes(player)
	local success, errorMessage = pcall(function()
		database_PlayerAttributes:SetAsync(player.UserId, player:GetAttributes())
	end)
	if not success then
		warn("Failed to save player data for", player, errorMessage)
	end
end

-- 1. Loads Player Data if available
-- 2. Creates Default Data as attributes and performs initial save
local function loadPlayerAttributes(player)

	-- Load data for player with UserID as the key
	local playerData, keyExists
	local success, errorMessage = pcall(function()
		playerData, keyExists = database_PlayerAttributes:GetAsync(player.UserId)
	end)

	-- Create the attributes on the player and/or save the initial default data
	if success and keyExists then
		for attribute, defaultValue in pairs(DefaultPlayerAttributes) do
			local value = playerData[attribute]
			if value == nil then  -- If the attribute is missing in the loaded data
				value = defaultValue  -- Use the default value
			end
			player:SetAttribute(attribute, value)
		end

	elseif not keyExists then
		-- If the player has no stored data, set default attributes and save them
		for attribute, value in pairs(DefaultPlayerAttributes) do
			player:SetAttribute(attribute, value)
		end
		savePlayerAttributes(player)  -- Initial save for new player

	else
		warn("Failed to load player data for", player, errorMessage)
	end
end

-- Module function for main script to call
function Data_Manager:LoadAttributesForPlayer(player: Player)
	loadPlayerAttributes(player)
end

function Data_Manager:SaveAttributesForPlayer(player: Player)
	savePlayerAttributes(player)
end

-- Saves data for all players when the game crashes or Game_Main.Game_End is called
function Data_Manager:ShudownSaveDataAllPlayers()
	
	local players = Players:GetPlayers()	
	-- loop through all players and call save data
	for _, player in players do
		savePlayerAttributes(player)
	end
end

return Data_Manager