-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:45
-- Luau version 6, Types version 3
-- Time taken: 0.003057 seconds

local module_2_upvr = {
	ClassName = "InputImageLibrary";
}
module_2_upvr.__index = module_2_upvr
function module_2_upvr.new(arg1) -- Line 16
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_2_upvr)
	setmetatable_result1._spritesheets = {}
	setmetatable_result1:_loadSpriteSheets(arg1)
	return setmetatable_result1
end
function module_2_upvr.GetPreloadAssetIds(arg1) -- Line 30
	local module = {}
	for _, v in pairs(arg1._spritesheets) do
		for _, v_2 in pairs(v) do
			table.insert(module, v_2:GetPreloadAssetId())
		end
	end
	return module
end
local any_load_result1_upvr = require(script.Parent.loader).load(script)
function module_2_upvr._loadSpriteSheets(arg1, arg2) -- Line 40
	--[[ Upvalues[1]:
		[1]: any_load_result1_upvr (readonly)
	]]
	for _, v_3 in pairs(arg2:GetChildren()) do
		arg1._spritesheets[v_3.Name] = {}
		for _, v_4 in pairs(v_3:GetChildren()) do
			if v_4:IsA("ModuleScript") then
				arg1._spritesheets[v_3.Name][v_4.Name] = any_load_result1_upvr(v_4).new()
			end
		end
	end
end
function module_2_upvr.GetSprite(arg1, arg2, arg3, arg4) -- Line 59
	local any__pickSheet_result1 = arg1:_pickSheet(arg2, arg3, arg4)
	if any__pickSheet_result1 then
		return any__pickSheet_result1:GetSprite(arg2)
	end
	return nil
end
function module_2_upvr.GetScaledImageLabel(arg1, arg2, arg3, arg4) -- Line 68
	local any__getImageInstance_result1 = arg1:_getImageInstance("ImageLabel", arg2, arg3 or "Dark", arg4)
	if not any__getImageInstance_result1 then
		return nil
	end
	local Size = any__getImageInstance_result1.Size
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	UIAspectRatioConstraint.AspectRatio = Size.Y.Offset / Size.X.Offset
	UIAspectRatioConstraint.Parent = any__getImageInstance_result1
	any__getImageInstance_result1.Size = UDim2.new(1, 0, 1, 0)
	return any__getImageInstance_result1
end
function module_2_upvr._pickSheet(arg1, arg2, arg3, arg4) -- Line 87
	local var43 = arg1._spritesheets[arg4]
	local var44 = var43
	if var44 then
		var44 = (function(arg1_2) -- Line 88, Named "findSheet"
			--[[ Upvalues[2]:
				[1]: arg3 (readonly)
				[2]: arg2 (readonly)
			]]
			local var39 = arg1_2[arg3]
			if var39 and var39:HasSprite(arg2) then
				return var39
			end
			for _, v_5 in pairs(arg1_2) do
				if v_5:HasSprite(arg2) then
					return v_5
				end
			end
		end)(var43)
	end
	if var44 then
		return var44
	end
	for _, v_6 in pairs(arg1._spritesheets) do
		local findSheet_result1 = (function(arg1_2) -- Line 88, Named "findSheet"
			--[[ Upvalues[2]:
				[1]: arg3 (readonly)
				[2]: arg2 (readonly)
			]]
			local var39 = arg1_2[arg3]
			if var39 and var39:HasSprite(arg2) then
				return var39
			end
			for _, v_5 in pairs(arg1_2) do
				if v_5:HasSprite(arg2) then
					return v_5
				end
			end
		end)(v_6)
		if findSheet_result1 then
			return findSheet_result1
		end
	end
	return nil
end
function module_2_upvr._getImageInstance(arg1, arg2, arg3, arg4, arg5) -- Line 124
	local any__pickSheet_result1_2 = arg1:_pickSheet(arg3, arg4, arg5)
	if any__pickSheet_result1_2 then
		return any__pickSheet_result1_2:GetSprite(arg3):Get(arg2)
	end
	return nil
end
return module_2_upvr.new(script:WaitForChild("Spritesheets"))