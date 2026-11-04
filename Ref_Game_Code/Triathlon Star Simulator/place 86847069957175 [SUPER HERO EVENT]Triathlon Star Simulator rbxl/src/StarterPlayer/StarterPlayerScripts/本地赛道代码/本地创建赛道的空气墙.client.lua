-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:31:02
-- Luau version 6, Types version 3
-- Time taken: 0.002216 seconds

local PhysicalProperties_new_result1_upvr = PhysicalProperties.new(0.7, 0.3, 0, 1, 1)
local function _(arg1, arg2, arg3) -- Line 11
	--[[ Upvalues[1]:
		[1]: PhysicalProperties_new_result1_upvr (readonly)
	]]
	local Part_2 = Instance.new("Part", workspace["本地空气墙"])
	Part_2.Material = Enum.Material.Glass
	Part_2.CanCollide = true
	Part_2.CanTouch = false
	Part_2.CanQuery = false
	Part_2.Anchored = true
	Part_2.CustomPhysicalProperties = PhysicalProperties_new_result1_upvr
	Part_2.Transparency = 1
	Part_2.Size = arg1
	Part_2.Position = arg2
	Part_2.Name = "AirWall"
	return Part_2
end
local function CreateAirWall_upvr(arg1, arg2) -- Line 34, Named "CreateAirWall"
	--[[ Upvalues[1]:
		[1]: PhysicalProperties_new_result1_upvr (readonly)
	]]
	local vector3 = Vector3.new(2048, 3.523, arg2)
	local Z = vector3.Z
	local Part_3 = Instance.new("Part", workspace["本地空气墙"])
	Part_3.Material = Enum.Material.Glass
	Part_3.CanCollide = true
	Part_3.CanTouch = false
	Part_3.CanQuery = false
	Part_3.Anchored = true
	Part_3.CustomPhysicalProperties = PhysicalProperties_new_result1_upvr
	Part_3.Transparency = 1
	Part_3.Size = Vector3.new(vector3.X, Z, 100)
	Part_3.Position = arg1 + Vector3.new(0, Z / 2 + vector3.Y / 2, vector3.Z / 2 + 50)
	Part_3.Name = "AirWall"
	local Part_4 = Instance.new("Part", workspace["本地空气墙"])
	Part_4.Material = Enum.Material.Glass
	Part_4.CanCollide = true
	Part_4.CanTouch = false
	Part_4.CanQuery = false
	Part_4.Anchored = true
	Part_4.CustomPhysicalProperties = PhysicalProperties_new_result1_upvr
	Part_4.Transparency = 1
	Part_4.Size = Vector3.new(vector3.X, Z, 100)
	Part_4.Position = arg1 + Vector3.new(0, Z / 2 + vector3.Y / 2, -vector3.Z / 2 - 50)
	Part_4.Name = "AirWall"
	local Part = Instance.new("Part", workspace["本地空气墙"])
	Part.Material = Enum.Material.Glass
	Part.CanCollide = true
	Part.CanTouch = false
	Part.CanQuery = false
	Part.Anchored = true
	Part.CustomPhysicalProperties = PhysicalProperties_new_result1_upvr
	Part.Transparency = 1
	Part.Size = Vector3.new(vector3.X, 100, vector3.Z + 200)
	Part.Position = arg1 + Vector3.new(0, Z + vector3.Y / 2 + 50, 0)
	Part.Name = "AirWall"
	local Part_5 = Instance.new("Part", workspace["本地空气墙"])
	Part_5.Material = Enum.Material.Glass
	Part_5.CanCollide = true
	Part_5.CanTouch = false
	Part_5.CanQuery = false
	Part_5.Anchored = true
	Part_5.CustomPhysicalProperties = PhysicalProperties_new_result1_upvr
	Part_5.Transparency = 1
	Part_5.Size = Vector3.new(vector3.X, 100, vector3.Z + 200)
	Part_5.Position = arg1 + Vector3.new(0, -50 + vector3.Y / 2, 0)
	Part_5.Name = "AirWall"
end
;(function(arg1, arg2, arg3) -- Line 66, Named "createRoad"
	--[[ Upvalues[1]:
		[1]: CreateAirWall_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var23 = 0
	for _, v in pairs(arg1) do
		var23 += v.num * 100
	end
	for _ = 1, math.ceil(var23 / 2048) do
		CreateAirWall_upvr(arg2 + Vector3.new(-1024, 0, 0), arg3)
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		local var27
	end
end)(require(game.ReplicatedStorage.Tool.CfgFind).GetRoadCfg(), game.Workspace["场景"]:WaitForChild(require(game.ReplicatedStorage.Tool.WorldUtil).GetCurWorld(), math.huge):WaitForChild("赛道起点", math.huge).Position + Vector3.new(0, -1.5, 0), 64)