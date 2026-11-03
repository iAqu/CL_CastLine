-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:21
-- Luau version 6, Types version 3
-- Time taken: 0.001272 seconds

local module = {}
local tbl_2_upvr = {}
function module.Create(arg1, arg2, arg3) -- Line 8
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	local module_2_upvr = {}
	module_2_upvr.Template = arg3
	tbl_2_upvr[arg2] = module_2_upvr
	function module_2_upvr.AddSprite(arg1_2, arg2_2, arg3_2, arg4) -- Line 14
		--[[ Upvalues[1]:
			[1]: module_2_upvr (readonly)
		]]
		local tbl = {}
		tbl.Position = arg3_2
		tbl.Size = arg4
		module_2_upvr[arg2_2] = tbl
	end
	return module_2_upvr
end
function module.Set(arg1, arg2, arg3, arg4, arg5) -- Line 21
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	local var9 = tbl_2_upvr[(arg4 or "Keyboard")..'_'..(arg5 or "Light")]
	local var10 = var9[arg3]
	arg2.Image = var9.Template
	arg2.ImageRectOffset = var10.Position
	arg2.ImageRectSize = var10.Size
end
for _, v in pairs(script.Spritesheets:GetChildren()) do
	for _, v_2 in pairs(v:GetChildren()) do
		if v_2:IsA("ModuleScript") then
			require(v_2)(module, v.Name)
		end
	end
end
return module