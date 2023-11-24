local CollectionService = game:GetService("CollectionService")
-- Script to store the target info for the player
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Modules
local Game_Events = require(ReplicatedStorage:WaitForChild("Game_Events"))

-- Events
local Target_Event: RemoteEvent = Game_Events.SetPlayerTarget

for _, instance in CollectionService:GetTagged("NPC") do
	
	print("NPC: ",instance)
	
	local humanoid: Humanoid = instance:WaitForChild("Humanoid")
	local clickDetector: ClickDetector = instance:FindFirstChild("ClickDetector")
	local NPC_Model = clickDetector.Parent
	
	clickDetector.MouseClick:Connect(function(player: Player) 
	
		local NPC_Model = clickDetector.Parent

		Target_Event:FireClient(player, NPC_Model)
	
	
	end)
	
	
end