-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:15
-- Luau version 6, Types version 3
-- Time taken: 0.001371 seconds

local Frame_upvr = script.Parent.Parent.Frame
local GM_______upvr = game:GetService("ReplicatedStorage")["测试消息"]["GM邮件"]
script.Parent.MouseButton1Click:Connect(function() -- Line 9
	--[[ Upvalues[2]:
		[1]: Frame_upvr (readonly)
		[2]: GM_______upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	for _, v in pairs(Frame_upvr:GetChildren()) do
		if v.Name == "Buff" then
			local BuffName_2 = v.BuffName
			local Buff______ = v["Buff加成"]
			if BuffName_2.Value ~= "" and tonumber(Buff______.Text) and tonumber(v["开始时间"].Text) and tonumber(v["结束时间"].Text) then
				local tbl = {
					BuffName = BuffName_2.Value;
					AddPower = tonumber(Buff______.Text);
				}
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				tbl.StartTime = tonumber(v["开始时间"].Text)
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				tbl.EndTime = tonumber(v["结束时间"].Text)
				table.insert({}, tbl)
			end
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	GM_______upvr:InvokeServer("设置服务器buff", {})
end)