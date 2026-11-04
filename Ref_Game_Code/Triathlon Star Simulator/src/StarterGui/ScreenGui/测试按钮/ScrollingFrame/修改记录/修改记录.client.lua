-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:47
-- Luau version 6, Types version 3
-- Time taken: 0.000774 seconds

local _____________upvr = game:GetService("ReplicatedStorage")["测试消息"]["特殊处理"]
local ______ID_upvr = script.Parent.Parent.Parent["背包系统"]["道具ID"]
local ________________upvr = script.Parent.Parent.Parent["背包系统"]["一次加多少"]
script.Parent.MouseButton1Click:Connect(function() -- Line 8
	--[[ Upvalues[3]:
		[1]: _____________upvr (readonly)
		[2]: ______ID_upvr (readonly)
		[3]: ________________upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	_____________upvr:FireServer("修改记录", {______ID_upvr.Text, ________________upvr.Text})
end)