-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
game:GetService("TextService")
local SoundService = game:GetService("SoundService")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local CameraController = require(ReplicatedStorage.Utility.DialogueSystem.CameraController)
local Assets = script.Parent.Assets
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
function t.DisplayMessage(p1, p2, p3, p4) --[[ DisplayMessage | Line: 50 | Upvalues: SoundService (copy), TweenService (copy) ]]
	local v1 = p4:Extend()
	local v2 = SoundService.Effects.UI.Hover:Clone()
	v2.Parent = SoundService
	v2.SoundGroup = SoundService.Effects
	v2:Play()
	for k, v in pairs(p3.text or { p3.text_trigger() }) do
		local v4 = v1:Add(Instance.new("IntValue"))
		v4.Parent = workspace.Debris
		v4.Value = 0
		local v5 = #v:gsub("<font.->", ""):gsub("</font>", "")
		p2.Text = v
		p2.MaxVisibleGraphemes = 0
		v1:Add(v4.Changed:Connect(function(p1) --[[ Line: 74 | Upvalues: p2 (copy), v2 (copy) ]]
			p2.MaxVisibleGraphemes = p1
			v2:Play()
		end))
		local v7 = TweenService:Create(v4, TweenInfo.new(math.min(v5 * 0.045454545454545456, 2), Enum.EasingStyle.Linear), {
			Value = v5
		})
		v7:Play()
		v7.Completed:Wait()
		task.wait(0.75)
		v1:Clean()
	end
end
function t.LoadChoices(p1, p2, p3, p4) --[[ LoadChoices | Line: 91 ]]
	local v1 = p4:Extend()
	local v2 = coroutine.running()
	v1:Add(function() --[[ Line: 98 | Upvalues: v2 (copy) ]]
		local v1 = coroutine.status(v2)
		if v1 and v1 ~= "running" then
			coroutine.resume(v2)
		end
	end)
	local v3 = nil
	local v4 = false
	for k, v in pairs(p2) do
		local v5 = p3:Clone()
		local ChoiceNum = v5:WaitForChild("ChoiceNum", 4)
		local ChoiceText = v5:WaitForChild("ChoiceText", 4)
		if not (ChoiceNum and (ChoiceText and v5)) then
			return
		end
		ChoiceNum.Text = ("%*"):format(k)
		ChoiceText.Text = v.text
		v5.Parent = p3.Parent
		v5.Visible = true
		v1:Add(v5)
		task.wait(0.1)
		v1:Add(v5.Activated:Connect(function() --[[ Line: 121 | Upvalues: v4 (ref), v3 (ref), v (copy), v2 (copy) ]]
			if v4 then
				v3 = v.id
				if v2 and coroutine.status(v2) == "suspended" then
					coroutine.resume(v2)
				end
			end
		end))
		task.wait(0.1)
	end
	coroutine.yield()
	v1:Clean()
	return v3
end
function t.StartConversation(p1) --[[ StartConversation | Line: 144 | Upvalues: LocalPlayer (copy), Trove (copy), Assets (copy), PlayerGui (copy), CameraController (copy), RunService (copy), t (copy) ]]
	local v1 = p1:GetAttribute("Name")
	if v1 and LocalPlayer.Character then
		local v2 = script.Configs:FindFirstChild(v1)
		if v2 then
			local v3 = Trove.new()
			local v4 = require(v2)
			local Character = LocalPlayer.Character
			v3:AttachToInstance(Character)
			local Hitbox = p1:FindFirstChild("Hitbox")
			if Hitbox then
				v3:Add(Hitbox.TouchEnded:Connect(function(p1) --[[ Line: 171 | Upvalues: Character (copy), v3 (copy) ]]
					if p1.Name == "HumanoidRootPart" and p1.Parent == Character then
						v3:Destroy()
					end
				end))
			end
			local v5 = Assets.NPCGui:Clone()
			local Label = v5:WaitForChild("TextFrame"):WaitForChild("Label")
			Label.Text = ""
			v5.Parent = p1
			v5.Adornee = p1.PrimaryPart
			local DialogueOffset = p1.PrimaryPart:FindFirstChild("DialogueOffset")
			if DialogueOffset then
				v5.StudsOffsetWorldSpace = DialogueOffset.Position
			end
			v3:Add(v5)
			local v6 = Assets.DialogueGui:Clone()
			local ChoiceTemplate = v6:WaitForChild("ChoiceTemplate")
			v6.Parent = PlayerGui
			v6.Adornee = Character
			v3:Add(v6)
			local v7 = true
			local v8 = true
			local v9 = v4.GetCorrectOpening(LocalPlayer)
			v3:Add(function() --[[ Line: 205 | Upvalues: v8 (ref), CameraController (ref) ]]
				v8 = false
				CameraController.TweenCameraOut()
			end)
			CameraController.TweenCameraIn()
			v3:Add(RunService.PreRender:Connect(function() --[[ Line: 212 | Upvalues: LocalPlayer (ref), p1 (copy), v3 (copy) ]]
				if LocalPlayer:DistanceFromCharacter(p1:GetPivot().Position) > 20 then
					v3:Clean()
				end
			end))
			while true do
				v7 = false
				if not (v7 and v8) then
					v3:Clean()
					return
				end
				task.wait()
				local v10 = v4.Nodes[v9]
				if not v10 then
					break
				end
				if v10.text or v10.text_trigger then
					t:DisplayMessage(Label, v10, v3)
				end
				if not v8 then
					v3:Clean()
					return
				end
				if v10.trigger then
					v10.trigger()
				end
				if v10.choices then
					local v11 = t:LoadChoices(v10.choices, ChoiceTemplate, v3)
					if not v8 then
						v3:Clean()
						return
					end
					v9 = v11
					if not (v7 and v8) then
						v3:Clean()
						return
					end
				end
			end
			warn((("Dialogue System: No choice data was found for ID:%*"):format(v9)))
			v3:Clean()
		else
			warn((("Dialogue System: Configuration was not found for Name: %*."):format(v1)))
		end
	end
end
return t