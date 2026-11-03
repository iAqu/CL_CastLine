-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:06
-- Luau version 6, Types version 3
-- Time taken: 0.000831 seconds

local module_upvr = {
	ClassName = "Sprite";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1) -- Line 25
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	assert(arg1.Texture, "Bad data")
	assert(arg1.Size, "Bad data")
	assert(arg1.Position, "Bad data")
	assert(arg1.Name, "Bad data")
	return setmetatable(arg1, module_upvr)
end
function module_upvr.Style(arg1, arg2) -- Line 41
	arg2.Image = arg1.Texture
	arg2.ImageRectOffset = arg1.Position
	arg2.ImageRectSize = arg1.Size
	return arg2
end
function module_upvr.Get(arg1, arg2) -- Line 54
	local any = Instance.new(arg2)
	any.Size = UDim2.new(0, arg1.Size.X, 0, arg1.Size.Y)
	any.Name = arg1.Name
	any.BackgroundTransparency = 1
	any.BorderSizePixel = 1
	arg1:Style(any)
	return any
end
return module_upvr