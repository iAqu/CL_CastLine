-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:54
-- Luau version 6, Types version 3
-- Time taken: 0.000976 seconds

local StarterGui_upvr = game:GetService("StarterGui")
local TranslationHelper_upvr = require(game:GetService("ReplicatedStorage").Tool.TranslationHelper)
script.Parent.MouseButton1Click:Connect(function() -- Line 9
	--[[ Upvalues[2]:
		[1]: StarterGui_upvr (readonly)
		[2]: TranslationHelper_upvr (readonly)
	]]
	for _, v in pairs(StarterGui_upvr:GetDescendants()) do
		if v:HasTag("本地化") then
			if TranslationHelper_upvr.CheckTranslateByKey(v.Name) == false then
				warn("没有本地化", v.Name)
			else
				print("已经本地化", v.Name)
			end
		end
	end
	for _, v_2 in pairs(workspace:GetDescendants()) do
		if v_2:HasTag("本地化") then
			if TranslationHelper_upvr.CheckTranslateByKey(v_2.Name) == false then
				warn("没有本地化", v_2.Name)
			else
				print("已经本地化", v_2.Name)
			end
		end
	end
	print("检测本地化完成")
end)