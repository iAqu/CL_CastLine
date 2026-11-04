-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:53
-- Luau version 6, Types version 3
-- Time taken: 0.000549 seconds

if not script.Parent then
else
	local LocalPlayer_upvr = game.Players.LocalPlayer
	script.Parent.MouseButton1Click:Connect(function() -- Line 7
		--[[ Upvalues[1]:
			[1]: LocalPlayer_upvr (readonly)
		]]
		require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
		local GM______ = LocalPlayer_upvr.PlayerGui.ScreenGui["GM邮件"]
		GM______["GM邮件初始化"].Enabled = true
		GM______.Visible = not GM______.Visible
	end)
end