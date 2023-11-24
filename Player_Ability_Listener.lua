-- Player Ability Listener Module

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
local Ability_Manager = require(ReplicatedStorage:WaitForChild("Ability_Manager"))  -- Assuming the Ability Manager is a sibling script

local GameEvents = require(ReplicatedStorage:WaitForChild("Game_Events"))
local NPC_Manager = require(ServerScripts:WaitForChild("NPC_Manager"))


local Ki_Blast = GameEvents.Ki_Blast
local Charge_Ki = GameEvents.Charge_Ki

-- Remote Events

local KiBlastEvent = ReplicatedStorage:WaitForChild("Ability_Manager"):WaitForChild("Ki_Blast"):WaitForChild("Event")
local ChargeKiEvent = ReplicatedStorage:WaitForChild("Ability_Manager"):WaitForChild("Charge_Ki"):WaitForChild("Event")


local function SendKiBlastTo(player: Player, target: Model)
	
	local result, message = Ability_Manager:Ki_Blast(player, target)
	if not result then
		warn("Server Ability Failed: ", message)
	end
	
end

Ki_Blast.OnServerEvent:Connect(function(player: Player, target:Model) 

	warn("Ki_Blast ", player, target, " New")
	
	-- Validate, Spawn Model with attributes , deduct energy 
	SendKiBlastTo(player, target)
end)
-- Event Handler for Ki Blast
--KiBlastEvent.OnServerEvent:Connect(function(player, target)
--	-- Server-side validation and execution of the Ki Blast ability
--	local result, message = Ability_Manager:Ki_Blast(player, target)
--	if not result then
--		warn("Server Ability Failed: ", message)
--	end
--end)


-- Event Handler for Ki Blast
KiBlastEvent.OnServerEvent:Connect(SendKiBlastTo)


-- Event Handler for Charging Ki
ChargeKiEvent.OnServerEvent:Connect(function(player)
	-- Implement Ki charging logic here
	local currentEnergy = player:GetAttribute("Energy") or 0
	local newEnergy = currentEnergy + 100
	local maxEnergy = player:GetAttribute("Energy_Max") or 1000

	if newEnergy > maxEnergy then
		newEnergy = maxEnergy
	end

	player:SetAttribute("Energy", newEnergy)
end)
