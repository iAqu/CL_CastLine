-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:15
-- Luau version 6, Types version 3
-- Time taken: 0.002436 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local any_new_result1 = Util_upvr.Maid.new()
	local var6
	if arg1:GetAttribute("ValueType") == "Luck" then
		local function UpdateValue() -- Line 14
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: LocalPlayer_upvr (copied, readonly)
			]]
			arg1.ValueField.Text = (LocalPlayer_upvr:GetAttribute("Luck") or 1) - 1
		end
		var6 = (LocalPlayer_upvr:GetAttribute("Luck") or 1) - 1
		arg1.ValueField.Text = var6
		any_new_result1.OnUpdate = LocalPlayer_upvr:GetAttributeChangedSignal("Luck"):Connect(UpdateValue)
		return any_new_result1
	end
	local FormatType_upvr = arg1:GetAttribute("FormatType")
	local var8_upvr = arg1:GetAttribute("Format") or "%s"
	local function UpdateValue(arg1_2) -- Line 20
		--[[ Upvalues[4]:
			[1]: FormatType_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: var8_upvr (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		if FormatType_upvr == "Time" then
			arg1.ValueField.Text = var8_upvr:format(Util_upvr.ValueConvertor:FormatTime(math.ceil(arg1_2 or 0)))
		else
			local var9
			if var9 == "Rank" then
				local function INLINED() -- Internal function, doesn't exist in bytecode
					var9 = Util_upvr.Settings.RANK_TITLES[arg1_2]
					return var9
				end
				if not arg1_2 or not INLINED() then
					var9 = Util_upvr.Settings.RANK_TITLES[#Util_upvr.Settings.RANK_TITLES]
				end
				arg1.ValueField.Text = var8_upvr:format(var9, arg1_2)
				return
			end
			arg1.ValueField.Text = var8_upvr:format(Util_upvr.ValueConvertor:ShrinkNumber(math.ceil(arg1_2 or 0)))
		end
	end
	var6 = arg1.Name
	local string_split_result1 = string.split(var6, '_')
	var6 = Util_upvr.Link:GetLink()
	while 0 < #string_split_result1 do
		var6 = var6[table.remove(string_split_result1, 1)]
		local popped = table.remove(string_split_result1, 1)
	end
	any_new_result1.OnUpdate = var6.Changed:On(popped, UpdateValue)
	UpdateValue(var6[popped])
	return any_new_result1
end
return module