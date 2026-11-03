-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:32
-- Luau version 6, Types version 3
-- Time taken: 0.002117 seconds

local module = {}
local tbl_upvr = {}
local var3_upvw = 0
function SetVector(arg1, arg2, arg3, arg4) -- Line 8
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: var3_upvw (read and write)
	]]
	if not tbl_upvr[arg1 + 1] then
		return warn("set vector invalid count", arg1, var3_upvw, #tbl_upvr)
	end
	tbl_upvr[arg1 + 1].Size = Vector3.new(0.1, 0.1, arg2.magnitude)
	tbl_upvr[arg1 + 1].CFrame = CFrame.new(arg3 + arg2 / 2, arg3 + arg2)
	if arg4 then
		tbl_upvr[arg1 + 1].Color = arg4
	end
	return tbl_upvr[arg1 + 1]
end
function NewVector(arg1, arg2, arg3) -- Line 19
	--[[ Upvalues[2]:
		[1]: var3_upvw (read and write)
		[2]: tbl_upvr (readonly)
	]]
	local Part = Instance.new("Part")
	local var5
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var5 = arg3
		return var5
	end
	if not arg3 or not INLINED() then
		var5 = Color3.new(1, 0, 0)
	end
	Part.Color = var5
	var5 = true
	Part.Anchored = var5
	var5 = false
	Part.CanCollide = var5
	var5 = workspace
	Part.Parent = var5
	var5 = var3_upvw
	var5 += 1
	var3_upvw = var5
	var5 = tbl_upvr
	var5[var3_upvw] = Part
	var5 = SetVector
	var5(var3_upvw, arg1, arg2, arg3)
end
function module.View(arg1, arg2, arg3, arg4) -- Line 30
	--[[ Upvalues[2]:
		[1]: var3_upvw (read and write)
		[2]: tbl_upvr (readonly)
	]]
	if var3_upvw == #tbl_upvr then
		return NewVector(arg2, arg3, arg4)
	end
	var3_upvw += 1
	return SetVector(var3_upvw, arg2, arg3, arg4)
end
function module.Perma(arg1, arg2, arg3, arg4) -- Line 40
	local Part_2 = Instance.new("Part")
	local var7
	local function INLINED_2() -- Internal function, doesn't exist in bytecode
		var7 = arg4
		return var7
	end
	if not arg4 or not INLINED_2() then
		var7 = Color3.new(1, 0, 0)
	end
	Part_2.Color = var7
	var7 = true
	Part_2.Anchored = var7
	var7 = false
	Part_2.CanCollide = var7
	var7 = Vector3.new(0.1, 0.1, arg2.magnitude)
	Part_2.Size = var7
	var7 = "VectorViewer"
	Part_2.Name = var7
	var7 = CFrame.new(arg3 + arg2 / 2, arg3 + arg2)
	Part_2.CFrame = var7
	var7 = workspace
	Part_2.Parent = var7
	return Part_2
end
local var8
local function INLINED_3() -- Internal function, doesn't exist in bytecode
	var8 = game:GetService("RunService").Heartbeat
	return var8
end
if not game:GetService("RunService"):IsServer() or not INLINED_3() then
	var8 = game:GetService("RunService").RenderStepped
end
var8:Connect(function() -- Line 54
	--[[ Upvalues[1]:
		[1]: var3_upvw (read and write)
	]]
	var3_upvw = 0
end)
return module