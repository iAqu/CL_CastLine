-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:21
-- Luau version 6, Types version 3
-- Time taken: 0.005504 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local ServiceUtil_upvr = require(ReplicatedStorage.Tool.ServiceUtil)
function module_upvr.ChangeTimeValue(arg1, arg2) -- Line 13
	--[[ Upvalues[2]:
		[1]: InsMgr_upvr (readonly)
		[2]: ServiceUtil_upvr (readonly)
	]]
	if not arg2 then
	end
	if not arg1 then
	else
		local IsPlayingChangeTween_upvw = arg1:FindFirstChild("IsPlayingChangeTween")
		if not IsPlayingChangeTween_upvw then
			IsPlayingChangeTween_upvw = InsMgr_upvr.GetIns("IsPlayingChangeTween", "BoolValue", arg1)
			IsPlayingChangeTween_upvw.Value = false
		end
		if IsPlayingChangeTween_upvw.Value == true then return end
		IsPlayingChangeTween_upvw.Value = true
		local var7_upvw = 0
		local const_number_upvw = 1
		local var9_upvw
		var9_upvw = ServiceUtil_upvr.RunService.RenderStepped:Connect(function(arg1_2) -- Line 33
			--[[ Upvalues[5]:
				[1]: var7_upvw (read and write)
				[2]: const_number_upvw (read and write)
				[3]: arg1 (readonly)
				[4]: IsPlayingChangeTween_upvw (read and write)
				[5]: var9_upvw (read and write)
			]]
			-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
			var7_upvw += arg1_2
			local var10
			local function INLINED() -- Internal function, doesn't exist in bytecode
				var10 = IsPlayingChangeTween_upvw
				return var10.Value == false
			end
			if var10 <= var7_upvw or not arg1 or not IsPlayingChangeTween_upvw or INLINED() then
				var10 = false
				IsPlayingChangeTween_upvw.Value = var10
				var9_upvw:Disconnect()
				var9_upvw = nil
			else
				var10 = var7_upvw
				local var11 = var10 / const_number_upvw
				var10 = var11
				local var12 = var11
				if var12 <= 1 then
					var10 = var12 - 0.01
				end
				if 0 <= var10 then
				end
				arg1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(math.clamp(var10, 0, 1), 1, 0), NumberSequenceKeypoint.new(math.clamp(var10 + 0.01, 0, 1), 0, 0), NumberSequenceKeypoint.new(1, 0, 0)})
			end
		end)
	end
end
function module_upvr.SetTransparency(arg1, arg2, arg3) -- Line 73
	if arg2 == nil then
	end
	local var15 = 1 - 1
	if not arg1 then
		error("_uiGradient is invalid")
	else
		if 1 < var15 or var15 < 0 then
			error("_rate is out of range")
			return
		end
		if var15 ~= var15 then
			error("_rate is nan or inf")
			return
		end
		if not arg3 then
			local var16 = 0
		end
		local clamped = math.clamp(var15, 0, 1)
		if clamped == 0 then
			arg1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, var16, 0), NumberSequenceKeypoint.new(1, var16, 0)})
			return
		end
		if clamped == 1 then
			arg1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(1, 1, 0)})
			return
		end
		arg1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(clamped, 1, 0), NumberSequenceKeypoint.new(math.clamp(var15 + 0.01, 0, 1), var16, 0), NumberSequenceKeypoint.new(1, var16, 0)})
	end
end
function module_upvr.SetColor(arg1, arg2) -- Line 137
	if not arg1 then
		error("_uiGradient is invalid")
	else
		local tbl = {}
		local len = #arg2
		for i_2 = 1, len do
			local var26 = arg2[i_2]
			local start = var26.start
			local var28
			if start < 0 or 1 < start then
				error("错误")
			end
			if i_2 < len then
				var28 = math.clamp(arg2[i_2 + 1].start - 0.00001, 0, 1)
			end
			if start < 1 then
				tbl[#tbl + 1] = ColorSequenceKeypoint.new(start, var26.color)
				tbl[#tbl + 1] = ColorSequenceKeypoint.new(var28, var26.color)
			else
				tbl[#tbl + 1] = ColorSequenceKeypoint.new(start, var26.color)
			end
		end
		if len == 2 and arg2[1].start == 0 and arg2[2].start == 0 then
			arg1.Enabled = false
			return
		end
		arg1.Enabled = true
		arg1.Color = ColorSequence.new(tbl)
	end
end
function module_upvr.SetPercentByParent(arg1, arg2, arg3) -- Line 171
	--[[ Upvalues[2]:
		[1]: InsMgr_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var37 = arg2.AbsolutePosition.X + arg2.AbsoluteSize.X
	for _, v in pairs(arg3) do
		local X = v.AbsolutePosition.X
		local var42
		if not v:FindFirstChildOfClass("UIGradient") then
			var42 = InsMgr_upvr.GetIns("UIGradient", "UIGradient", v)
		end
		var42 = 0
		if var37 <= X then
			var42 = 0
		else
			var42 = (var37 - X) / v.AbsoluteSize.X
		end
		if 1 < var42 then
		end
		module_upvr.SetColor(var42, {{
			start = 0;
			color = Color3.fromRGB(0, 0, 0);
		}, {
			start = 1;
			color = Color3.fromRGB(255, 255, 255);
		}})
	end
end
local _______upvr = ReplicatedStorage.UI["流光"]
function module_upvr.AddStreamer(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 212
	--[[ Upvalues[1]:
		[1]: _______upvr (readonly)
	]]
	arg1.Visible = true
	local class_UIGradient = arg1:FindFirstChildOfClass("UIGradient")
	if class_UIGradient then
		class_UIGradient:Destroy()
		class_UIGradient = nil
	end
	if class_UIGradient == nil then
		local clone = _______upvr:Clone()
		clone:SetAttribute("hex", arg2)
		clone:SetAttribute("max", arg3)
		clone:SetAttribute("min", arg4)
		clone:SetAttribute("duration", arg5)
		clone:SetAttribute("cd", arg6)
		clone.Rotation = arg7
		clone.Parent = arg1
	end
end
function module_upvr.DestroyGradient(arg1) -- Line 231
	arg1.Visible = false
	local class_UIGradient_2 = arg1:FindFirstChildOfClass("UIGradient")
	if class_UIGradient_2 then
		class_UIGradient_2:Destroy()
	end
end
return module_upvr