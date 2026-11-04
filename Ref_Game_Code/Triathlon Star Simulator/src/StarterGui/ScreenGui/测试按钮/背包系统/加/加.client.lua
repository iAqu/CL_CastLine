-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:30
-- Luau version 6, Types version 3
-- Time taken: 0.000770 seconds

local ______ID_upvr = script.Parent.Parent["道具ID"]
local ________________upvr = script.Parent.Parent["一次加多少"]
local _____________upvr = game:GetService("ReplicatedStorage")["测试消息"]["背包处理"]
script.Parent.MouseButton1Click:Connect(function() -- Line 10
	--[[ Upvalues[3]:
		[1]: ______ID_upvr (readonly)
		[2]: ________________upvr (readonly)
		[3]: _____________upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	_____________upvr:FireServer({
		msgType = 1;
		itemID = tonumber(______ID_upvr.Text);
		itemCount = tonumber(________________upvr.Text);
	})
end)