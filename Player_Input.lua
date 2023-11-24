-- Player Input (Keys, taps, and mouse events)
-- Debugging function
local DEBUG = true
local function debugPrint(scriptName, message)
	if DEBUG then
		print(scriptName .. ": " .. message)
	end
end

-- keyboard_handler

-- Game Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGUI = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")


-- Modules
local Game_Events = require(ReplicatedStorage:WaitForChild("Game_Events"))

-- HUD
local playerGui = player:WaitForChild("PlayerGui")
local playerActionBarUI = StarterGUI:WaitForChild("MasterUI"):WaitForChild("PlayerActionBar")
local camera = game.Workspace.CurrentCamera


-- Buttons
local Ki_Blast_Button: ImageButton = playerGui:WaitForChild("MasterUI"):WaitForChild("PlayerActionBar"):WaitForChild("Buttons"):WaitForChild("KiBlastImgBtn")
local Charge_Ki_Button: ImageButton = playerGui:WaitForChild("MasterUI"):WaitForChild("PlayerActionBar"):WaitForChild("Buttons"):WaitForChild("ChargeKi_btn")

-- Ability Events
local KiBlastEvent = Game_Events.Ki_Blast
local ChargeKiEvent = ReplicatedStorage:WaitForChild("Ability_Manager"):WaitForChild("Charge_Ki"):WaitForChild("Event")

-- Other Events
--local target_Event = Game_Events.PlayerTarget
--local untarget_Event = Game_Events.PlayerDeTarget

-- Player Target
local playerTarget = nil

-- Variables
local clientEvents = {}


-- Client Validation function
local function validateAbility(abilityConfiguration: Configuration)
	
	local result = true
	local message = "All good"
	
	local attributeName = abilityConfiguration:WaitForChild("Player_Attribute_Name").Value
	local attributeCost = abilityConfiguration:WaitForChild("Attribute_Cost").Value
	
	
	if player:GetAttribute(attributeName)< attributeCost then
		message = "Cost to high"
		result = false
		warn(message)
	end
	
	warn(message)
	return result, message
end

-- Connect function to the Q key press
local function onInputBegan(input, gameProcessed)
	
	if gameProcessed then return end
	
	clientEvents = CollectionService:GetTagged("Player_Ability_Event")
	
	
	if input.KeyCode == Enum.KeyCode.Z then
		
		ChargeKiEvent:FireServer(player)
	elseif input.KeyCode == Enum.KeyCode.F then
		
	elseif input.KeyCode == Enum.KeyCode.Q then

		KiBlastEvent:FireServer(playerTarget)

	elseif input.KeyCode == Enum.KeyCode.E then
		--TODO: Add E code
	elseif input.KeyCode == Enum.KeyCode.T then
		--TODO: Add T code
	elseif input.KeyCode == Enum.KeyCode.R then
		player.Character.Humanoid.WalkSpeed += 10
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		-- Raycast to detect target
		local mouse = player:GetMouse()
		local ray = Ray.new(camera.CFrame.Position, (mouse.Hit.p - camera.CFrame.Position).unit * 500)
		local hit, position = workspace:FindPartOnRay(ray, player.Character)

		if hit and hit.Parent:FindFirstChild("Humanoid") then
			local target = hit.Parent
			--target_Event:Fire(target)
		else

		end
	end
end


-- Connect input events
UserInputService.InputBegan:Connect(onInputBegan)

-- UI Button Connections
Ki_Blast_Button.Activated:Connect(function(inputObject: InputObject, clickCount: number) 
	warn("Ki Button")
	KiBlastEvent:FireServer(playerTarget)
end)

Charge_Ki_Button.Activated:Connect(function(inputObject: InputObject, clickCount: number) 
	warn("Charge Button")
	ChargeKiEvent:FireServer(player)

end)

