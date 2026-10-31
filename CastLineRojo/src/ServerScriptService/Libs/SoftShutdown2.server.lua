--[[
	Evercyan @ June 27, 2023
	SoftShutdown2 v1.21
	
	Read more..
	https://devforum.roblox.com/t/softshutdown2/1156844
]]

--> Services
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--> Configuration
local ReserveCharacterPosition = false -- If true, the character's location is reserved when they get teleported back.

--------------------------------------------------------------------------------

local function CFrameToArray(CoordinateFrame: CFrame)
	return {CoordinateFrame:GetComponents()}
end

local function ArrayToCFrame(a: {number})
	return CFrame.new(table.unpack(a))
end

local function OnPlayerAdded(Player: Player)
	local TeleportData = Player:GetJoinData().TeleportData
	
	if TeleportData and TeleportData.isSoftShutdown == true then
		local CoordinateFrame = TeleportData.CharacterCFrames[tostring(Player.UserId)]
		
		-- Teleport the player to their original position
		if ReserveCharacterPosition and CoordinateFrame then
			local Character = Player.Character or Player.CharacterAdded:Wait()
			local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") :: BasePart
			
			if not Player:HasAppearanceLoaded() then
				Player.CharacterAppearanceLoaded:Wait()
			end
			
			task.wait(0.1) -- Roblox race conditions
			HumanoidRootPart:PivotTo(ArrayToCFrame(CoordinateFrame))
		end
	end
end

local Connection = Players.PlayerAdded:Connect(OnPlayerAdded)
for _, Player in Players:GetPlayers() do
	OnPlayerAdded(Player)
end

-- Code here runs when a server is marked as closing (e.g. 'Shut Down All Servers' button; 0 Players left)
game:BindToClose(function()
    print("SoftShutdown2: Server is shutting down")
	if RunService:IsStudio() then
		return
	end
	
	-- Give time for the client to make any adjustments to shutting down (ie. SS2's teleport gui if you use that)
	workspace:SetAttribute("SS2_ShuttingDown", true)
	task.wait(1)
	
	local CurrentPlayers = Players:GetPlayers()
	if not CurrentPlayers[1] then
		return
	end
	
	-- Optional: Reserve character positions in the world
	local CharacterCFrames = {}
	if ReserveCharacterPosition then
		for _, Player in CurrentPlayers do
			local Character = Player.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			
			if HumanoidRootPart then
				CharacterCFrames[tostring(Player.UserId)] = CFrameToArray(HumanoidRootPart.CFrame)
			end
		end
	end
	
	-- Teleport the player(s)
	local TeleportOptions = Instance.new("TeleportOptions")
	TeleportOptions:SetTeleportData({
		isSoftShutdown = true,
		CharacterCFrames = CharacterCFrames
	})

	-- 3
    -- Teleporting players to a private server
    -- https://github.com/MerelyRBLX/ROBLOX-Lua/blob/master/SoftShutdown.lua
    -- local reservedServerCode = TeleportService:ReserveServer(game.PlaceId)
    -- for _,player in pairs(Players:GetPlayers()) do
    --     TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
    -- end
    -- Players.PlayerAdded:Connect(function(player)
    --     TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
    -- end)

	-- 1
    -- original code, not working
	local TeleportResult = TeleportService:TeleportAsync(game.PlaceId, CurrentPlayers, TeleportOptions)

	-- 2
    -- Teleporting players one by one
    -- https://devforum.roblox.com/t/teleportserviceteleportasync-doesnt-work-after-a-shutdown-has-been-performed/2578600/20
    -- Teleporting each player individually instead as one group
    -- for _, player in Players:GetPlayers() do
    --     task.spawn(function()
    --         pcall(function()
    --             return TeleportService:TeleportAsync(game.PlaceId, {player}, TeleportOptions) -- teleport the user in a protected call to prevent erroring
    --         end)
    --     end)
    -- end

	-- Keep the server alive until all of the player(s) have been teleported.
	while Players:GetPlayers()[1] do
		task.wait(1)
	end
end)