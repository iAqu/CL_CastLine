-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:47
-- Luau version 6, Types version 3
-- Time taken: 0.002432 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("Maid")
local any_load_result1_result1_upvr_2 = any_load_result1("ServiceBag")
local any_load_result1_result1_upvr = any_load_result1("ReticleHair")
local RunService_upvr = game:GetService("RunService")
return function(arg1) -- Line 13
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: RunService_upvr (readonly)
	]]
	local any_new_result1_3_upvr = any_load_result1_result1_upvr_3.new()
	local any_new_result1 = any_load_result1_result1_upvr_2.new()
	any_new_result1_3_upvr:GiveTask(any_new_result1)
	local tbl_upvr = {}
	for i = 0, 359.9, 15 do
		local any_new_result1_2 = any_load_result1_result1_upvr.new(any_new_result1, i)
		any_new_result1_2.Gui.Size = UDim2.new(0.5, 0, 0.5, 0)
		any_new_result1_2:SetDistance(0.75)
		any_new_result1_2:SetWidth(0.1)
		any_new_result1_2:SetTransparency(0)
		table.insert(tbl_upvr, {
			angle = i;
			hair = any_new_result1_2;
		})
		any_new_result1_3_upvr:GiveTask(any_new_result1_2)
		any_new_result1_2.Gui.Parent = arg1
	end
	any_new_result1_3_upvr:GiveTask(RunService_upvr.RenderStepped:Connect(function() -- Line 35
		--[[ Upvalues[1]:
			[1]: tbl_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var23
		if var23 < 0 then
			var23 *= 0.25
		end
		for _, v in pairs(tbl_upvr) do
			local var27 = math.sin(tick() * math.pi * 2 + math.rad(v.angle * 5)) * 0.8 + math.sin(tick() * math.pi * 2) * 0.2
			v.hair:SetLength(var27 * 0.25 + 0.5)
			v.hair:SetWidth(var27 * 0.01 + 0.1)
			v.hair:SetDistance(var23 * 0.1 * var27 + 0.75)
			v.hair:SetTransparency(-var27 * 0.25 + 0.25)
			v.hair:SetRotation(math.deg(tick() / 4 % (-math.pi*2)) % 360 + v.angle)
			local _
		end
	end))
	return function() -- Line 56
		--[[ Upvalues[1]:
			[1]: any_new_result1_3_upvr (readonly)
		]]
		any_new_result1_3_upvr:DoCleaning()
	end
end