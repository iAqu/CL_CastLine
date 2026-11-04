-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:28
-- Luau version 6, Types version 3
-- Time taken: 0.001880 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
local _______upvr = script.Parent["箭头"]
local Bar_upvr = script.Parent.Bar
local Parent_upvr = script.Parent
local X_upvw = Parent_upvr.AbsolutePosition.X
local X_upvw_2 = Parent_upvr.AbsoluteSize.X
local var8_upvw = true
local var9_upvw
local function _() -- Line 22, Named "clearListen"
	--[[ Upvalues[1]:
		[1]: var9_upvw (read and write)
	]]
	if var9_upvw then
		var9_upvw:Disconnect()
		var9_upvw = nil
	end
end
function Down() -- Line 29
	--[[ Upvalues[7]:
		[1]: UIanima_upvr (readonly)
		[2]: _______upvr (readonly)
		[3]: var9_upvw (read and write)
		[4]: X_upvw (read and write)
		[5]: Parent_upvr (readonly)
		[6]: X_upvw_2 (read and write)
		[7]: var8_upvw (read and write)
	]]
	UIanima_upvr.ButtonDown(_______upvr.Frame)
	if var9_upvw then
		var9_upvw:Disconnect()
		var9_upvw = nil
	end
	X_upvw = Parent_upvr.AbsolutePosition.X
	X_upvw_2 = Parent_upvr.AbsoluteSize.X
	var8_upvw = false
	var9_upvw = _______upvr.MouseMoved:Connect(Move)
end
function Up() -- Line 41
	--[[ Upvalues[4]:
		[1]: UIanima_upvr (readonly)
		[2]: _______upvr (readonly)
		[3]: var9_upvw (read and write)
		[4]: var8_upvw (read and write)
	]]
	UIanima_upvr.ButtonUp(_______upvr.Frame)
	if var9_upvw then
		var9_upvw:Disconnect()
		var9_upvw = nil
	end
	var8_upvw = true
end
local Setting_upvr = ReplicatedStorage.ServerMsg.Setting
function Move(arg1) -- Line 48
	--[[ Upvalues[6]:
		[1]: var8_upvw (read and write)
		[2]: X_upvw (read and write)
		[3]: X_upvw_2 (read and write)
		[4]: _______upvr (readonly)
		[5]: Bar_upvr (readonly)
		[6]: Setting_upvr (readonly)
	]]
	if var8_upvw ~= true then
		local var11 = (arg1 - X_upvw) / X_upvw_2
		if var11 <= 0 then
			var11 = 0
		elseif 1 <= var11 then
			var11 = 1
		end
		_______upvr.Position = UDim2.new(var11, 0, 0.5, 0)
		Bar_upvr.Size = UDim2.new(var11, 0, 1, 0)
		Setting_upvr:InvokeServer("EFFECT", var11)
	end
end
_______upvr.MouseButton1Down:connect(Down)
_______upvr.MouseButton1Up:connect(Up)
_______upvr.MouseLeave:connect(Up)
_______upvr.MouseEnter:Connect(function() -- Line 71
	--[[ Upvalues[2]:
		[1]: UIanima_upvr (readonly)
		[2]: _______upvr (readonly)
	]]
	UIanima_upvr.BtnScaleAnimEnter(_______upvr.Frame)
end)
_______upvr.MouseLeave:Connect(function() -- Line 75
	--[[ Upvalues[2]:
		[1]: UIanima_upvr (readonly)
		[2]: _______upvr (readonly)
	]]
	UIanima_upvr.BtnScaleAnimLeave(_______upvr.Frame)
end)
local EFFECT = game.Players.LocalPlayer:WaitForChild("Setting", math.huge):WaitForChild("EFFECT")
require(ReplicatedStorage.Tool.AddListen).NumValueAdd(EFFECT, function(arg1) -- Line 80
	--[[ Upvalues[1]:
		[1]: Bar_upvr (readonly)
	]]
	local var16
	if var16 <= 0 then
		var16 = 0
	elseif 1 <= var16 then
		var16 = 1
	end
	Bar_upvr.Size = UDim2.new(var16, 0, 1, 0)
end)
_______upvr.Position = UDim2.new(EFFECT.Value, 0, 0.5, 0)