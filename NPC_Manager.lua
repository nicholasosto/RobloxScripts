local ServerStorage = game:GetService("ServerStorage")
local NPC_Model_Folder = ServerStorage:WaitForChild("NPC_Models")


local NPC_Manager = {}


NPC_Manager.NPC_Models = {
	Zombie = NPC_Model_Folder:WaitForChild("Zombie"),
	Female_NPC = NPC_Model_Folder:WaitForChild("Female_NPC")
	
}

function NPC_Manager.SpawnAtLocation(NPC_Model: Model, location:Vector3)
	
	local newNPC = NPC_Model:Clone()
	newNPC.Parent = workspace
	newNPC.PrimaryPart.Position = location
	
end

return NPC_Manager
