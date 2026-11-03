-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:50
-- Luau version 6, Types version 3
-- Time taken: 0.001414 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {
	BulkNumber = 1;
	BulkNumberChanged = Util_upvr.Signal.new();
}
function module_upvr.Binder(arg1) -- Line 8
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	for _, v_upvr in pairs(arg1.Quantity:GetChildren()) do
		local children_upvr = v_upvr:IsA("ImageButton")
		if children_upvr then
			if v_upvr.Name == "Max" then
				children_upvr = math.huge
			else
				children_upvr = tonumber(v_upvr.Name)
				if not children_upvr then
					children_upvr = 1
				end
			end
			Util_upvr.Maid.new()[v_upvr] = v_upvr.MouseButton1Click:Connect(function() -- Line 14
				--[[ Upvalues[4]:
					[1]: module_upvr (copied, readonly)
					[2]: children_upvr (readonly)
					[3]: arg1 (readonly)
					[4]: v_upvr (readonly)
				]]
				module_upvr.BulkNumber = children_upvr
				module_upvr.BulkNumberChanged:Fire(children_upvr)
				for _, v_2 in pairs(arg1.Quantity:GetChildren()) do
					if v_2:IsA("ImageButton") then
						v_2:SetAttribute("UI_ButtonColor", Color3.new(1, 1, 1))
					end
				end
				v_upvr:SetAttribute("UI_ButtonColor", Color3.fromRGB(48, 184, 255))
			end)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return Util_upvr.Maid.new()
end
Util_upvr.UIUpgrades = module_upvr
return module_upvr