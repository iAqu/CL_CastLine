-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:53
-- Luau version 6, Types version 3
-- Time taken: 0.002582 seconds

local module = {}
local ContentProvider_upvr = game:GetService("ContentProvider")
local function Preload_A_Res_upvr(arg1) -- Line 6, Named "Preload_A_Res"
	--[[ Upvalues[1]:
		[1]: ContentProvider_upvr (readonly)
	]]
	if arg1:IsA("ParticleEmitter") then
		local Texture_4 = arg1.Texture
		if Texture_4 ~= "" then
			table.insert({}, Texture_4)
		end
	end
	if arg1:IsA("SpecialMesh") then
		local TextureId = arg1.TextureId
		if TextureId ~= "" then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.insert({}, TextureId)
		end
	end
	if arg1:IsA("Beam") then
		local Texture_3 = arg1.Texture
		if Texture_3 ~= "" then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.insert({}, Texture_3)
		end
	end
	if arg1:IsA("Trail") then
		local Texture_5 = arg1.Texture
		if Texture_5 ~= "" then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.insert({}, Texture_5)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	for _, v_upvr in pairs({}) do
		spawn(function() -- Line 55
			--[[ Upvalues[3]:
				[1]: ContentProvider_upvr (copied, readonly)
				[2]: v_upvr (readonly)
				[3]: arg1 (readonly)
			]]
			repeat
				local pcall_result1_3, _ = pcall(function() -- Line 61
					--[[ Upvalues[2]:
						[1]: ContentProvider_upvr (copied, readonly)
						[2]: v_upvr (copied, readonly)
					]]
					ContentProvider_upvr:PreloadAsync({v_upvr})
				end)
				local var33 = pcall_result1_3
				if not var33 then
					task.wait(0.1)
				end
			until var33 and 5 <= 0 + 1
			if not var33 then
				warn("Fail to load ", arg1.ClassName, ' '..v_upvr)
			end
		end)
	end
end
function module.Preload(arg1) -- Line 80
	--[[ Upvalues[1]:
		[1]: Preload_A_Res_upvr (readonly)
	]]
	for _, v_2 in pairs(arg1:GetDescendants()) do
		Preload_A_Res_upvr(v_2)
	end
end
function module.PreloadAnimation(arg1) -- Line 91
	--[[ Upvalues[1]:
		[1]: ContentProvider_upvr (readonly)
	]]
	local Animation_upvr = Instance.new("Animation", workspace)
	Animation_upvr.AnimationId = arg1
	repeat
		local pcall_result1, _ = pcall(function() -- Line 100
			--[[ Upvalues[2]:
				[1]: ContentProvider_upvr (copied, readonly)
				[2]: Animation_upvr (readonly)
			]]
			ContentProvider_upvr:PreloadAsync({Animation_upvr})
		end)
		local var44 = pcall_result1
		if not var44 then
			task.wait(0.1)
		end
	until var44 and 5 <= 0 + 1
	if not var44 then
		warn("Fail to preLoad Animation"..Animation_upvr.AnimationId)
	end
	game.Debris:AddItem(Animation_upvr, 0)
end
return module