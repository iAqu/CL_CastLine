-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:41
-- Luau version 6, Types version 3
-- Time taken: 0.000476 seconds

local _____________upvr = game:GetService("ReplicatedStorage")["测试消息"]["特殊处理"]
local ________________upvr = script.Parent.Parent.Parent["背包系统"]["一次加多少"]
script.Parent.MouseButton1Click:Connect(function() -- Line 7
	--[[ Upvalues[2]:
		[1]: _____________upvr (readonly)
		[2]: ________________upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	_____________upvr:FireServer("设置点击次数", ________________upvr.Text)
end)