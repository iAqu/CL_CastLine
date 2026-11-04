-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:00
-- Luau version 6, Types version 3
-- Time taken: 0.004260 seconds

local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local var3_upvw = false
local SoundModule_upvr = require(ReplicatedStorage.Tool.SoundModule)
local Debris_upvr = game:GetService("Debris")
local AnimationModule_upvr = require(ReplicatedStorage.Tool.AnimationModule)
local function RankUp_upvr(arg1) -- Line 15, Named "RankUp"
	--[[ Upvalues[4]:
		[1]: var3_upvw (read and write)
		[2]: SoundModule_upvr (readonly)
		[3]: Debris_upvr (readonly)
		[4]: AnimationModule_upvr (readonly)
	]]
	if var3_upvw then
	else
		local Character_upvr = arg1.Character
		if not Character_upvr then return end
		local HumanoidRootPart_upvr = Character_upvr:FindFirstChild("HumanoidRootPart")
		if not HumanoidRootPart_upvr then return end
		local Humanoid_upvr = Character_upvr:FindFirstChild("Humanoid")
		if not Humanoid_upvr then return end
		local LowerTorso_2 = Character_upvr:FindFirstChild("LowerTorso")
		if not LowerTorso_2 then return end
		local Animator = Humanoid_upvr:FindFirstChild("Animator")
		var3_upvw = true
		local NameTag_2 = Character_upvr:FindFirstChild("NameTag")
		if NameTag_2 then
			NameTag_2.Enabled = false
		end
		SoundModule_upvr:PlaySoundLocal("蓄力音效")
		local clone_7_upvr = script.RankUp["能量波"]:Clone()
		local clone_4_upvr = script.RankUp["能量点"]:Clone()
		local clone_6_upvr = script.RankUp["能量爆气"]:Clone()
		local clone_3_upvr = script.RankUp["能量线"]:Clone()
		local clone_5_upvr = script.RankUp["多重爆气"]:Clone()
		clone_6_upvr.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 20), NumberSequenceKeypoint.new(0.184, 6.4, 2), NumberSequenceKeypoint.new(0.75, 9.5, 2), NumberSequenceKeypoint.new(1, 20)})
		local Ring = clone_7_upvr.Ring
		Ring.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 50), NumberSequenceKeypoint.new(1, 0)})
		local Energy = clone_4_upvr.Energy
		Energy.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 50), NumberSequenceKeypoint.new(1, 0)})
		clone_7_upvr.Parent = HumanoidRootPart_upvr
		clone_4_upvr.Parent = LowerTorso_2
		clone_6_upvr.Parent = LowerTorso_2
		clone_3_upvr.Parent = LowerTorso_2
		clone_5_upvr.Parent = HumanoidRootPart_upvr
		clone_7_upvr.CFrame = clone_7_upvr.CFrame.Rotation + Vector3.new(0, -Humanoid_upvr.HipHeight - HumanoidRootPart_upvr.Size.Y / 2, 0)
		clone_5_upvr.CFrame = clone_7_upvr.CFrame.Rotation + Vector3.new(0, -Humanoid_upvr.HipHeight - HumanoidRootPart_upvr.Size.Y / 2, 0)
		local Highlight = Instance.new("Highlight", Character_upvr)
		Highlight.OutlineColor = Color3.fromHex("#aaff00")
		Highlight.OutlineTransparency = 0
		Highlight.FillTransparency = 0.5
		Highlight.FillColor = Color3.fromHex("#aaff00")
		Debris_upvr:AddItem(Highlight, 3.4)
		Humanoid_upvr:ChangeState(Enum.HumanoidStateType.Physics)
		HumanoidRootPart_upvr.Anchored = true
		delay(4, function() -- Line 101
			--[[ Upvalues[4]:
				[1]: HumanoidRootPart_upvr (readonly)
				[2]: Humanoid_upvr (readonly)
				[3]: var3_upvw (copied, read and write)
				[4]: Character_upvr (readonly)
			]]
			HumanoidRootPart_upvr.Anchored = false
			Humanoid_upvr:ChangeState(Enum.HumanoidStateType.Running)
			var3_upvw = false
			local NameTag = Character_upvr:FindFirstChild("NameTag")
			if NameTag then
				NameTag.Enabled = true
			end
		end)
		AnimationModule_upvr.StopAnim(Animator, "聚气1")
		AnimationModule_upvr.PlayAnim(Animator, "聚气1", 1, {"Effect"}, {function() -- Line 115
			--[[ Upvalues[9]:
				[1]: SoundModule_upvr (copied, readonly)
				[2]: Debris_upvr (copied, readonly)
				[3]: clone_7_upvr (readonly)
				[4]: clone_4_upvr (readonly)
				[5]: clone_6_upvr (readonly)
				[6]: clone_3_upvr (readonly)
				[7]: clone_5_upvr (readonly)
				[8]: Character_upvr (readonly)
				[9]: HumanoidRootPart_upvr (readonly)
			]]
			SoundModule_upvr:PlaySoundLocal("爆发音效")
			Debris_upvr:AddItem(clone_7_upvr, 0)
			Debris_upvr:AddItem(clone_4_upvr, 0)
			Debris_upvr:AddItem(clone_6_upvr, 0)
			Debris_upvr:AddItem(clone_3_upvr, 0)
			Debris_upvr:AddItem(clone_5_upvr, 0)
			if Character_upvr then
				for _, v in pairs(Character_upvr:GetChildren()) do
					if v:IsA("MeshPart") then
						local clone_2 = script.RankUp["闪电"]:Clone()
						clone_2.Parent = v
						clone_2.Enabled = true
						Debris_upvr:AddItem(clone_2, 1.5)
					end
				end
			end
			if HumanoidRootPart_upvr then
				local clone = script.RankUp["能量扩散"]:Clone()
				clone.Parent = HumanoidRootPart_upvr
				clone.Position = Vector3.new(0, 6.5, 0)
				for _, v_2 in pairs(clone:GetChildren()) do
					if v_2.Name == "能量波" then
						v_2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 40)})
						v_2.Enabled = false
						v_2:Emit(3)
					end
					if v_2.Name == "旋风" then
						v_2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(0.03, 5, 5), NumberSequenceKeypoint.new(1, 100, 10)})
						v_2.Enabled = false
						v_2:Emit(3)
					end
					if v_2.Name == "小旋风" then
						v_2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(0.03, 5, 5), NumberSequenceKeypoint.new(1, 90, 5)})
						v_2.Enabled = false
						v_2:Emit(5)
					end
					if v_2.Name == "闪光1" then
						v_2.Enabled = false
						v_2:Emit(2)
					end
					if v_2.Name == "爆炸" then
						v_2.Enabled = false
						v_2:Emit(1)
					end
				end
				Debris_upvr:AddItem(clone, 1)
			end
		end})
		Ring.Enabled = true
		Energy.Enabled = true
		clone_6_upvr.Enabled = true
		clone_3_upvr.Enabled = true
		Ring:Emit(10)
		Energy:Emit(10)
		clone_6_upvr:Emit(10)
		clone_3_upvr:Emit(10)
	end
end
local Players_upvr = game:GetService("Players")
local CameraMoveLocal_upvr = require(ReplicatedStorage.Tool.CameraMoveLocal)
function module.ShowRankUp(arg1) -- Line 222
	--[[ Upvalues[3]:
		[1]: RankUp_upvr (readonly)
		[2]: Players_upvr (readonly)
		[3]: CameraMoveLocal_upvr (readonly)
	]]
	RankUp_upvr(arg1)
	if arg1 == Players_upvr.LocalPlayer then
		local Character = arg1.Character
		if not Character then return end
		local LowerTorso = Character:FindFirstChild("LowerTorso")
		if LowerTorso then
			CameraMoveLocal_upvr.SurroundingWatch(LowerTorso)
		end
	end
end
return module