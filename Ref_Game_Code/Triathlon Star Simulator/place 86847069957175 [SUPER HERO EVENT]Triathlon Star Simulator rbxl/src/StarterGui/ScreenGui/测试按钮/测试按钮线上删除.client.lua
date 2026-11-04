-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:26
-- Luau version 6, Types version 3
-- Time taken: 0.001011 seconds

local ReplicatedStorage_2 = game:GetService("ReplicatedStorage")
if not game:GetService("RunService"):IsStudio() then
	script.Parent:Destroy()
else
	if require(ReplicatedStorage_2.Tool.Log).isDebug() == true then
		local LocalPlayer = game.Players.LocalPlayer
		if LocalPlayer then
			for _, v in pairs(ReplicatedStorage_2["游戏全局配置"]["测试人员ID"]:GetChildren()) do
				if v.Value == LocalPlayer.UserId then
					script.Parent.Visible = true
					return
				end
			end
		end
	end
	script.Parent:Destroy()
end