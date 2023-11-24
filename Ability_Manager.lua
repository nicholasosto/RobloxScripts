-- Ability Manager Module

local CollectionServices = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

-- Ability Base Class
local Ability = {}
Ability.__index = Ability
Ability.ValidationMessage = ""
-- Ability Constructor
function Ability.new(cooldown, cost, attribute)
	local self = setmetatable({}, Ability)
	self.Cooldown = cooldown or 0.5
	self.Cost = cost or 0
	self.Attribute = attribute or "None"

	warn("Ability Created: ", self)
	return self
end

-- Validation functions
function Ability:ValidateTarget(target)
	-- Target validation logic (tags-based)
	local success = false
	local message = ""
	
	if not target then
		message = "Nil Target"
		success = false
	elseif target:HasTag("PvP_Enabled") or target:HasTag("Targetable") or target:HasTag("NPC") then
		return true
	else
		message = " Invalid Target: " .. target.Name
		success = false
	end
end

function Ability:ValidateResourceAmount(player: Player)
	-- Target validation logic (tags-based)
	local currentAmount = player:GetAttribute(self.Attribute)
	local balance = currentAmount - self.Cost
	
	warn("Ability Validation: ",currentAmount, balance)
	
	if balance >= 0 then
		player:SetAttribute(self.Attribute, balance)
		return true
	end
	
	return false
end

-- KiBlast Subclass
local KiBlast = setmetatable({}, Ability)
KiBlast.__index = KiBlast
KiBlast.Model = script:WaitForChild("Ki_Blast")  -- Assumes Ki_Blast model is a child of the script

function KiBlast.new()
	local cooldown = 3  -- seconds
	local cost = 10     -- Energy
	local attributeName = "Energy"
	local self = setmetatable(Ability.new(cooldown, cost, attributeName), KiBlast)

	warn("New Ki Blast created", self)
	return self
end

-- KiBlast specific functions
function KiBlast:Blast(target)
	-- KiBlast logic implementation
end

-- Ability Manager
local Ability_Manager = {}

function Ability_Manager:Ki_Blast(player, target)
	
	local result = true
	-- Create the Ki Blast Instance
	local kiBlastInstance = KiBlast.new()

	-- Validate target and cost
	local validTarget, message = kiBlastInstance:ValidateTarget(target)
	
	if not validTarget then	
		warn(script.Name, " ", message)
		return false
	end
	
	local validResourceAmount = kiBlastInstance:ValidateResourceAmount(player)

	-- Ki Blast Logic
	-- Example: Tween the Ki Blast towards the target
	local part = script:WaitForChild("Ki_Blast"):WaitForChild("Ability_Part"):Clone()  -- Clone the Ki Blast model
	part.Parent = game.Workspace  -- Add the cloned model to Workspace
	part.Position = player.Character.PrimaryPart.Position  -- Position at player
	
	local damage = player:GetAttribute("Ki_Power") + 10
	warn("Setting Damage: ", damage)
	part:SetAttribute("Damage", damage)
	part:SetAttribute("Owner", player.UserId)

	-- Calculate the distance and time to reach the target
	local distance = (part.Position - target.PrimaryPart.Position).Magnitude
	local timeToReachTarget = distance / 100  -- Speed calculation

	-- Tween effect
	local tweenInfo = TweenInfo.new(timeToReachTarget, Enum.EasingStyle.Linear)
	local goal = {Position = target.PrimaryPart.Position}
	local tween = TweenService:Create(part, tweenInfo, goal)
	tween:Play()
	
	return true, message
end

return Ability_Manager
