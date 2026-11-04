-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:27
-- Luau version 6, Types version 3
-- Time taken: 0.000599 seconds

local ______ID_upvr = script.Parent.Parent["道具ID"]
local _____________upvr = game:GetService("ReplicatedStorage")["测试消息"]["背包处理"]
script.Parent.MouseButton1Click:Connect(function() -- Line 10
	--[[ Upvalues[2]:
		[1]: ______ID_upvr (readonly)
		[2]: _____________upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	_____________upvr:FireServer({
		msgType = 3;
		itemID = tonumber(______ID_upvr.Text);
	})
end)