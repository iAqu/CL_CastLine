-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:21
-- Luau version 6, Types version 3
-- Time taken: 0.001536 seconds

local Frame_upvr = script.Parent.Parent.Frame
local GM_______upvr = game:GetService("ReplicatedStorage")["测试消息"]["GM邮件"]
script.Parent.MouseButton1Click:Connect(function() -- Line 9
	--[[ Upvalues[2]:
		[1]: Frame_upvr (readonly)
		[2]: GM_______upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	for _, v in pairs(Frame_upvr:GetChildren()) do
		if v.Name == "玩家ID" then
			local TextBox = v.TextBox
			if TextBox.Text ~= "" and tonumber(TextBox.Text) then
				GM_______upvr:InvokeServer("查询邮箱", tonumber(TextBox.Text))
				return
			end
		end
	end
end)