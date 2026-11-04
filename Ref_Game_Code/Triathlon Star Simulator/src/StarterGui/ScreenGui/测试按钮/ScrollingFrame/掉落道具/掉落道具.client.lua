-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:53
-- Luau version 6, Types version 3
-- Time taken: 0.000990 seconds

local _____________upvr = game:GetService("ReplicatedStorage")["测试消息"]["特殊处理"]
script.Parent.MouseButton1Click:Connect(function() -- Line 7
	--[[ Upvalues[1]:
		[1]: _____________upvr (readonly)
	]]
	local Character_2 = game.Players.LocalPlayer.Character
	if Character_2 then
		local HumanoidRootPart_2 = Character_2:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart_2 then
			require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
			_____________upvr:FireServer("掉落道具", {tonumber(script.Parent.Parent.Parent["背包系统"]["道具ID"].Text), HumanoidRootPart_2.Position, script.Parent.Parent.Parent["背包系统"]["一次加多少"].Text})
		end
	end
end)