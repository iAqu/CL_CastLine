-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:27
-- Luau version 6, Types version 3
-- Time taken: 0.003360 seconds

local module = {}
local CheckPlace_upvr = require(game:GetService("ReplicatedStorage").Tool.AnimationModule.CheckPlace)
local tbl_upvr = {
	idle = {
		Animation1 = {"http://www.roblox.com/asset/?id=18733008653", "http://www.roblox.com/asset/?id=131398984967009"};
		Animation2 = {"http://www.roblox.com/asset/?id=18733008653", "http://www.roblox.com/asset/?id=131398984967009"};
	};
}
local function _(arg1) -- Line 63, Named "InitAnim"
	--[[ Upvalues[2]:
		[1]: CheckPlace_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	spawn(function() -- Line 64
		--[[ Upvalues[3]:
			[1]: CheckPlace_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: tbl_upvr (copied, readonly)
		]]
		wait(1)
		local Animate_2 = arg1:WaitForChild("Animate", 5)
		if Animate_2 then
			for i, v in pairs(tbl_upvr) do
				if Animate_2:FindFirstChild(i) then
					for i_2, v_2 in pairs(v) do
						if Animate_2:FindFirstChild(i):FindFirstChild(i_2) then
							Animate_2:FindFirstChild(i):FindFirstChild(i_2):Destroy()
							local Animation_4 = Instance.new("Animation")
							Animation_4.AnimationId = v_2[CheckPlace_upvr.CheckPlaceID()]
							Animation_4.Name = i_2
							Animation_4.Parent = Animate_2:FindFirstChild(i)
						end
					end
				end
			end
		end
	end)
end
function module.Init(arg1) -- Line 100
	--[[ Upvalues[2]:
		[1]: CheckPlace_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local Character_3_upvr = arg1.Character
	if Character_3_upvr then
		spawn(function() -- Line 64
			--[[ Upvalues[3]:
				[1]: CheckPlace_upvr (copied, readonly)
				[2]: Character_3_upvr (readonly)
				[3]: tbl_upvr (copied, readonly)
			]]
			wait(1)
			local Animate = Character_3_upvr:WaitForChild("Animate", 5)
			if Animate then
				for i_3, v_3 in pairs(tbl_upvr) do
					if Animate:FindFirstChild(i_3) then
						for i_4, v_4 in pairs(v_3) do
							if Animate:FindFirstChild(i_3):FindFirstChild(i_4) then
								Animate:FindFirstChild(i_3):FindFirstChild(i_4):Destroy()
								local Animation = Instance.new("Animation")
								Animation.AnimationId = v_4[CheckPlace_upvr.CheckPlaceID()]
								Animation.Name = i_4
								Animation.Parent = Animate:FindFirstChild(i_3)
							end
						end
					end
				end
			end
		end)
	end
end
function module.ChangeDefaultAnim(arg1, arg2, arg3, arg4) -- Line 113
	--[[ Upvalues[1]:
		[1]: CheckPlace_upvr (readonly)
	]]
	task.delay(0, function() -- Line 115
		--[[ Upvalues[5]:
			[1]: CheckPlace_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
			[5]: arg4 (readonly)
		]]
		local Character = arg1.Character
		if not Character then
			Character = arg1.CharacterAppearanceLoaded:Wait()
		end
		if not Character then
		else
			local Animate_3 = Character:WaitForChild("Animate")
			if not Animate_3:FindFirstChild(arg2) then return end
			if not Animate_3:FindFirstChild(arg2):FindFirstChild(arg3) then return end
			Animate_3:FindFirstChild(arg2):FindFirstChild(arg3):Destroy()
			task.wait()
			local Animation_2 = Instance.new("Animation")
			Animation_2.AnimationId = "http://www.roblox.com/asset/?id="..arg4
			Animation_2.Name = arg3
			Animation_2.Parent = Animate_3:FindFirstChild(arg2)
		end
	end)
end
function module.ApplyDefaultAnim(arg1, arg2, arg3) -- Line 147
	--[[ Upvalues[2]:
		[1]: CheckPlace_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	task.delay(0, function() -- Line 148
		--[[ Upvalues[5]:
			[1]: CheckPlace_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
			[5]: tbl_upvr (copied, readonly)
		]]
		local Character_2 = arg1.Character
		if not Character_2 then
			Character_2 = arg1.CharacterAppearanceLoaded:Wait()
		end
		if not Character_2 then
		else
			local Animate_4 = Character_2:WaitForChild("Animate")
			if not Animate_4:FindFirstChild(arg2) then return end
			if not Animate_4:FindFirstChild(arg2):FindFirstChild(arg3) then return end
			Animate_4:FindFirstChild(arg2):FindFirstChild(arg3):Destroy()
			task.wait()
			local Animation_3 = Instance.new("Animation")
			Animation_3.AnimationId = "http://www.roblox.com/asset/?id="..tbl_upvr[arg2][arg3][CheckPlace_upvr.CheckPlaceID()]
			Animation_3.Name = arg3
			Animation_3.Parent = Animate_4:FindFirstChild(arg2)
		end
	end)
end
return module