-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:01
-- Luau version 6, Types version 3
-- Time taken: 0.000618 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	any_new_result1.Submit = arg1.Redeem.MouseButton1Click:Connect(function() -- Line 8
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
		]]
		local Text = arg1.CodeBox.Box.Text
		if Text:len() == 0 then
		else
			Util_upvr.Network:Fire("SubmitCode", Text)
			arg1.CodeBox.Box.Text = ""
		end
	end)
	return any_new_result1
end
return module