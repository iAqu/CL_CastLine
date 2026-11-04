-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:54
-- Luau version 6, Types version 3
-- Time taken: 0.002893 seconds

local Parent_upvr = script.Parent
local vector2_upvr = Vector2.new(1920, 1080)
local UserInputService_upvr = game:GetService("UserInputService")
local UIScale_3_upvr = Parent_upvr.UIScale
local UISetMgr_upvr = require(game.ReplicatedStorage.Tool.UISetMgr)
local function onChanged() -- Line 12
	--[[ Upvalues[5]:
		[1]: Parent_upvr (readonly)
		[2]: vector2_upvr (readonly)
		[3]: UserInputService_upvr (readonly)
		[4]: UIScale_3_upvr (readonly)
		[5]: UISetMgr_upvr (readonly)
	]]
	local AbsoluteSize = Parent_upvr.AbsoluteSize
	if UserInputService_upvr.TouchEnabled then
		for _, v in pairs(script.Parent.Main:GetChildren()) do
			local class_UIScale_4 = v:FindFirstChildOfClass("UIScale")
			if class_UIScale_4 and v.Name ~= "Right" then
				if v.Name == "Right2" then
				else
					class_UIScale_4.Scale = 1.3
					if v.Name == "Top" then
						class_UIScale_4.Scale = 1.1
					end
					if v.Name == "Botton" then
						class_UIScale_4.Scale = 1.7
						v.Position = UDim2.new(0.5, 0, 1, -40)
					end
					if v.Name == "Left" or v.Name == "Left2" then
						class_UIScale_4.Scale = 1.1
					end
				end
			end
		end
		for _, v_2 in pairs(script.Parent:GetChildren()) do
			if v_2.Name ~= "Main" then
				local class_UIScale_3 = v_2:FindFirstChildOfClass("UIScale")
				if class_UIScale_3 then
					local InitScale_2 = class_UIScale_3:GetAttribute("InitScale")
					if not InitScale_2 then
						class_UIScale_3:SetAttribute("InitScale", class_UIScale_3.Scale)
						InitScale_2 = class_UIScale_3.Scale
					end
					class_UIScale_3.Scale = InitScale_2 * 1.2
					class_UIScale_3:SetAttribute("PopScale", InitScale_2 * 1.2)
					if v_2.Name == "训练UI" then
						class_UIScale_3.Scale = 1.1
					end
				end
			end
		end
	end
	UIScale_3_upvr.Scale = math.min(AbsoluteSize.x / vector2_upvr.x, AbsoluteSize.y / vector2_upvr.y) * 1
	UISetMgr_upvr.UpdateUIStroke(Parent_upvr, UIScale_3_upvr.Scale)
	local UIAnimGui = Parent_upvr.Parent:WaitForChild("UIAnimGui")
	if UIAnimGui then
		UISetMgr_upvr.UpdateUIStroke(UIAnimGui, UIScale_3_upvr.Scale)
	end
	local TipsGui_2 = Parent_upvr.Parent:FindFirstChild("TipsGui")
	if TipsGui_2 then
		local UIScale = TipsGui_2:FindFirstChild("UIScale")
		if UIScale then
			UIScale.Scale = UIScale_3_upvr.Scale
		end
	end
end
Parent_upvr.Changed:Connect(onChanged)
onChanged()