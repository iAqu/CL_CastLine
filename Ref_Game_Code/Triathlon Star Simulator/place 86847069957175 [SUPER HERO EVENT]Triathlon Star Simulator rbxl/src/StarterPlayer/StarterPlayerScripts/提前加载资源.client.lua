-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:37
-- Luau version 6, Types version 3
-- Time taken: 0.002313 seconds

local ReplicatedStorage_upvr = game.ReplicatedStorage
local ContentProvider_upvr_2 = game:GetService("ContentProvider")
wait()
local any_GetPreloadTable_result1_upvr = require(ReplicatedStorage_upvr.Tool.AnimationModule).GetPreloadTable()
local Debris_upvr = game:GetService("Debris")
task.spawn(function() -- Line 13
	--[[ Upvalues[4]:
		[1]: any_GetPreloadTable_result1_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: Debris_upvr (readonly)
		[4]: ContentProvider_upvr_2 (readonly)
	]]
	local tbl_upvr = {}
	for _, v in pairs(any_GetPreloadTable_result1_upvr) do
		local Animation_2 = Instance.new("Animation")
		Animation_2.Parent = ReplicatedStorage_upvr
		Animation_2.AnimationId = v
		table.insert(tbl_upvr, Animation_2)
	end
	ContentProvider_upvr_2:PreloadAsync(tbl_upvr, function() -- Line 22
		--[[ Upvalues[2]:
			[1]: tbl_upvr (readonly)
			[2]: Debris_upvr (copied, readonly)
		]]
		for _, v_2 in pairs(tbl_upvr) do
			Debris_upvr:AddItem(v_2, 0)
		end
	end)
end)
for _, v_3 in pairs(ReplicatedStorage_upvr:GetDescendants()) do
	if v_3:IsA("ParticleEmitter") then
		local Texture_6 = v_3.Texture
		if Texture_6 ~= "" then
			table.insert({}, Texture_6)
		end
	end
	if v_3:IsA("SpecialMesh") then
		local TextureId_2 = v_3.TextureId
		if TextureId_2 ~= "" then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.insert({}, TextureId_2)
		end
	end
	if v_3:IsA("Beam") then
		local Texture = v_3.Texture
		if Texture ~= "" then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.insert({}, Texture)
		end
	end
	if v_3:IsA("Trail") then
		local Texture_4 = v_3.Texture
		if Texture_4 ~= "" then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.insert({}, Texture_4)
		end
	end
	if v_3:IsA("Sound") then
		local SoundId = v_3.SoundId
		if SoundId ~= "" then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.insert({}, SoundId)
		end
	end
end
wait()
if game:GetService("RunService"):IsStudio() then
else
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	ContentProvider_upvr_2:PreloadAsync({})
end