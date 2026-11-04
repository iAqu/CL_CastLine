-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:54
-- Luau version 6, Types version 3
-- Time taken: 0.000548 seconds

if not script.Parent then
else
	local LocalPlayer_upvr = game.Players.LocalPlayer
	script.Parent.MouseButton1Click:Connect(function() -- Line 7
		--[[ Upvalues[1]:
			[1]: LocalPlayer_upvr (readonly)
		]]
		require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
		local GM_________buff = LocalPlayer_upvr.PlayerGui.ScreenGui["GM服务器buff"]
		GM_________buff.Visible = not GM_________buff.Visible
	end)
end