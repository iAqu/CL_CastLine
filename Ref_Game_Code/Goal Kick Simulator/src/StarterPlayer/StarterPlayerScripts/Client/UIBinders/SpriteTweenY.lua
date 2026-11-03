-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:53
-- Luau version 6, Types version 3
-- Time taken: 0.002267 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_upvr = {}
Util_upvr.Thread.Every(0, function() -- Line 8
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	for i, v in pairs(tbl_upvr) do
		if v.Visible then
			i.ImageRectOffset = Vector2.new(0, (math.ceil(os.clock() % v.Speed / v.Speed * v.Steps) - 1) * v.StepSize)
		end
	end
end)
function module.Binder(arg1) -- Line 17
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local tbl_upvr_2 = {
		StepSize = arg1.ImageRectSize.Y or 0;
	}
	local ImageSize = arg1:GetAttribute("ImageSize")
	if not ImageSize then
		ImageSize = Vector2.new()
	end
	tbl_upvr_2.ImageSize = ImageSize
	tbl_upvr_2.Speed = arg1:GetAttribute("SpriteSpeed") or 0.5
	tbl_upvr_2.Visible = Util_upvr:IsGuiObjectVisible(arg1)
	tbl_upvr_2.Steps = tbl_upvr_2.ImageSize.Y / tbl_upvr_2.StepSize
	any_new_result1.AttributeChangedSpriteSpeed = arg1:GetAttributeChangedSignal("SpriteSpeed"):Connect(function() -- Line 28
		--[[ Upvalues[2]:
			[1]: tbl_upvr_2 (readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr_2.Speed = arg1:GetAttribute("SpriteSpeed") or 0.5
	end)
	any_new_result1.AttributeChangedImageSize = arg1:GetAttributeChangedSignal("ImageSize"):Connect(function() -- Line 31
		--[[ Upvalues[2]:
			[1]: tbl_upvr_2 (readonly)
			[2]: arg1 (readonly)
		]]
		local ImageSize_2 = arg1:GetAttribute("ImageSize")
		if not ImageSize_2 then
			ImageSize_2 = Vector2.new()
		end
		tbl_upvr_2.ImageSize = ImageSize_2
		tbl_upvr_2.Steps = tbl_upvr_2.ImageSize.Y / tbl_upvr_2.StepSize
	end)
	any_new_result1.ImageRectSizeChanged = arg1:GetPropertyChangedSignal("ImageRectSize"):Connect(function() -- Line 35
		--[[ Upvalues[2]:
			[1]: tbl_upvr_2 (readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr_2.StepSize = arg1.ImageRectSize.Y or 0
		tbl_upvr_2.Steps = tbl_upvr_2.ImageSize.Y / tbl_upvr_2.StepSize
	end)
	any_new_result1.ImageVisibilityChanged = arg1:GetPropertyChangedSignal("Visible"):Connect(function() -- Line 39
		--[[ Upvalues[3]:
			[1]: tbl_upvr_2 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		tbl_upvr_2.Visible = Util_upvr:IsGuiObjectVisible(arg1)
	end)
	any_new_result1.AncestryChanged = arg1.AncestryChanged:Connect(function() -- Line 42
		--[[ Upvalues[3]:
			[1]: tbl_upvr_2 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		tbl_upvr_2.Visible = Util_upvr:IsGuiObjectVisible(arg1)
	end)
	any_new_result1.RoutineCheck = Util_upvr.Thread.Every(2, function() -- Line 45
		--[[ Upvalues[3]:
			[1]: tbl_upvr_2 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		tbl_upvr_2.Visible = Util_upvr:IsGuiObjectVisible(arg1)
	end)
	tbl_upvr[arg1] = tbl_upvr_2
	any_new_result1:GiveTask(function() -- Line 50
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr[arg1] = nil
	end)
	return any_new_result1
end
return module