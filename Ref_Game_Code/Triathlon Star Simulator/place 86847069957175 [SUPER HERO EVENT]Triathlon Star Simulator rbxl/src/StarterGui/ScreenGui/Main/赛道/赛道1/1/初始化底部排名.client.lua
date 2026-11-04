-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:58
-- Luau version 6, Types version 3
-- Time taken: 0.001143 seconds

local any_GetRoadCfg_result1 = require(game.ReplicatedStorage.Tool.CfgFind).GetRoadCfg(1)
local Parent = script.Parent
local tonumber_result1 = tonumber(Parent.Name)
local var16
for _, v in pairs(any_GetRoadCfg_result1) do
	if v.Rank == tonumber_result1 then
		var16 += v.num
	end
end
for _, v_2 in pairs(any_GetRoadCfg_result1) do
	if v_2.Rank == tonumber_result1 then
		local Frame = Instance.new("Frame", Parent)
		Frame.Size = UDim2.new(0, v_2.num / var16 * Parent.Size.X.Offset, 1, 0)
		Frame.AnchorPoint = Vector2.new(0, 0.5)
		Frame.Position = UDim2.new(0, 0, 0.5, 0)
		Frame.BackgroundColor3 = ({Color3.new(0.00392157, 0.866667, 1), Color3.new(0, 1, 0.482353), Color3.new(1, 0.960784, 0)})[v_2.AniTp + 1]
		Frame.BorderSizePixel = 0
	end
end