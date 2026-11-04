-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:02
-- Luau version 6, Types version 3
-- Time taken: 0.000933 seconds

local module = {}
local __________________ID_upvr = game:GetService("ReplicatedStorage")["游戏全局配置"]["服务器配置"]["主游戏服务器ID"]
local PlaceId_upvr = game.PlaceId
function module.GetTestOrPublic() -- Line 18
	--[[ Upvalues[2]:
		[1]: __________________ID_upvr (readonly)
		[2]: PlaceId_upvr (readonly)
	]]
	for _, v in pairs(__________________ID_upvr:GetChildren()) do
		if v.Value == PlaceId_upvr then
			return v.Name
		end
	end
end
function module.GetCurWorld() -- Line 26
	return 1
end
function module.GetMaxWorld(arg1) -- Line 31
	local MaxWorld = arg1:FindFirstChild("MaxWorld")
	if MaxWorld then
		return MaxWorld.Value
	end
end
return module