-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:07
-- Luau version 6, Types version 3
-- Time taken: 0.002970 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {}
local any_load_result1_result1_upvr_2 = any_load_result1("Rx")
local var1_result1_upvr = any_load_result1("RxInstanceUtils")
local any_load_result1_result1_upvr = any_load_result1("RxBrioUtils")
function module.observeFolderBrio(arg1, arg2, arg3) -- Line 13
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	if arg2 and arg3 then
		local module_2 = {}
		local any_GetContainerName_result1_upvr = arg1:GetContainerName()
		module_2[1] = any_load_result1_result1_upvr_2.map(function(arg1_2) -- Line 21
			--[[ Upvalues[3]:
				[1]: any_GetContainerName_result1_upvr (readonly)
				[2]: arg3 (readonly)
				[3]: arg2 (readonly)
			]]
			if arg1_2.Name == any_GetContainerName_result1_upvr and arg1_2.Parent == arg3 then
				return arg2
			end
			return nil
		end)
		module_2[2] = any_load_result1_result1_upvr_2.distinct()
		module_2[3] = any_load_result1_result1_upvr.toBrio()
		module_2[4] = any_load_result1_result1_upvr.onlyLastBrioSurvives()
		return any_load_result1_result1_upvr_2.combineLatest({
			Parent = var1_result1_upvr.observeProperty(arg2, "Parent");
			Name = var1_result1_upvr.observeProperty(arg2, "Name");
		}):Pipe(module_2)
	end
	if arg2 then
		any_GetContainerName_result1_upvr = arg1:GetContainerName()
		return var1_result1_upvr.observePropertyBrio(arg2, "Name", function(arg1_3) -- Line 34
			--[[ Upvalues[1]:
				[1]: any_GetContainerName_result1_upvr (readonly)
			]]
			local var11
			if arg1_3 ~= any_GetContainerName_result1_upvr then
				var11 = false
			else
				var11 = true
			end
			return var11
		end):Pipe({any_load_result1_result1_upvr.map(function() -- Line 37
			--[[ Upvalues[1]:
				[1]: arg2 (readonly)
			]]
			return arg2
		end)})
	end
	if arg3 then
		any_GetContainerName_result1_upvr = arg1:GetContainerName()
		return var1_result1_upvr.observeLastNamedChildBrio(arg3, "Folder", any_GetContainerName_result1_upvr)
	end
	any_GetContainerName_result1_upvr = error
	any_GetContainerName_result1_upvr("No folder or adornee")
end
function module.getFolder(arg1, arg2, arg3) -- Line 49
	if arg2 and arg3 then
		if arg2.Parent == arg3 and arg2.Name == arg1:GetContainerName() then
			return arg2
		end
		return nil
	end
	if arg2 then
		if arg2.Name == arg1:GetContainerName() then
			return arg2
		end
		return nil
	end
	if arg3 then
		return arg3:FindFirstChild(arg1:GetContainerName())
	end
	error("Must have folder or adornee")
end
return module