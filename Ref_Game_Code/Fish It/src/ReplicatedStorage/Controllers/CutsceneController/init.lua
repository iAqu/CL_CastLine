-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
game:GetService("StarterGui")
game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Loader = require(ReplicatedStorage.Packages.Loader)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Shared.CutsceneUtility)
local ModelProvider = require(ReplicatedStorage.ModelProvider)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local MainlineQuestController = require(ReplicatedStorage.Controllers.MainlineQuestController)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
require(script.Internal.Transition)
local t = { "Legendary" }
require(ReplicatedStorage.Types.Fishing)
require(ReplicatedStorage.Types.Modifiers)
local v1 = Net:RemoteEvent("ReplicateCutscene")
local v2 = Net:RemoteEvent("StopCutscene")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v3 = nil
local v4 = nil
local v5 = false
local v6 = nil
local Cutscenes = script:WaitForChild("Cutscenes")
local v7 = Loader.LoadChildren(Cutscenes)
local t2 = {
	Start = function(p1) --[[ Start | Line: 56 | Upvalues: v3 (ref), Replion (copy) ]]
		v3 = Replion.Client:WaitReplion("Data")
	end
}
function t2.Init(p1) --[[ Init | Line: 60 | Upvalues: v1 (copy), t2 (copy), v2 (copy), Observers (copy), LocalPlayer (copy), v4 (ref) ]]
	v1.OnClientEvent:Connect(function(...) --[[ Line: 61 | Upvalues: t2 (ref) ]]
		t2:Play(...)
	end)
	v2.OnClientEvent:Connect(function() --[[ Line: 65 | Upvalues: t2 (ref) ]]
		t2:Stop()
	end)
	Observers.observeCharacter(function(p1, p2) --[[ Line: 70 | Upvalues: LocalPlayer (ref), v4 (ref), t2 (ref) ]]
		if p1 == LocalPlayer then
			local v1 = false
			local Humanoid = p2:WaitForChild("Humanoid")
			local v2 = nil
			local function characterDied() --[[ characterDied | Line: 79 | Upvalues: v1 (ref), v2 (ref), v4 (ref), t2 (ref) ]]
				if v1 then
					return
				end
				if v2 and v2.Connected then
					v2:Disconnect()
				end
				v1 = true
				if not (v4 and v4:find("Admin")) then
					t2:Stop()
				end
			end
			v2 = Humanoid.Died:Once(characterDied)
			return characterDied
		end
	end)
end
function t2.GetCutsceneModule(p1, p2) --[[ GetCutsceneModule | Line: 101 | Upvalues: v7 (copy) ]]
	return v7[p2]
end
function t2.Play(p1, p2, p3, p4, p5, p6, p7, p8) --[[ Play | Line: 105 | Upvalues: GuiControl (copy), UserPriority (copy), v4 (ref), v5 (ref), LocalPlayer (copy), t2 (copy), ModelProvider (copy), Players (copy), v6 (ref), MainlineQuestController (copy), ProximityPromptService (copy), v3 (ref), PlayerGui (copy), t (copy) ]]
	if GuiControl:IsOpen("!!!! AbilityUI") then
		return
	end
	if UserPriority:IsTradePlaza() then
		return
	end
	tick()
	if v4 and v4:find("Admin") then
		return
	end
	if v5 and not p2:find("Admin") then
		return
	end
	v4 = p2
	local v1 = if p3 == LocalPlayer.Character then true else p2:find("Admin")
	if v1 then
		v5 = true
		t2:Stop()
	end
	local v2 = nil
	if p7 == nil or p7 == true then
		if p5 then
			v2 = ModelProvider:GetModel(LocalPlayer, "Fish", {
				Id = p5,
				Metadata = p6
			}, true)
		end
		if not v2 then
			v5 = false
			v4 = nil
			return
		end
	end
	local v32 = t2:GetCutsceneModule(p2)
	local v42 = Players:GetPlayerFromCharacter(p3)
	if not (v32 or v42) then
		return
	end
	local Character = LocalPlayer.Character
	if not Character then
		return
	end
	local v52 = Character:FindFirstChildWhichIsA("Humanoid")
	if not v52 then
		return
	end
	if v52.Health <= 0 then
		return
	end
	if v52:GetState() == Enum.HumanoidStateType.Dead then
		return
	end
	if v1 and p2:find("Admin") then
		GuiControl:Close(true)
		GuiControl:FishingLock()
		GuiControl:Lock()
	elseif v1 then
		GuiControl:FishingLock()
	end
	local function RESET_STATE(p1) --[[ RESET_STATE | Line: 187 | Upvalues: v1 (copy), v5 (ref), v4 (ref) ]]
		if v1 then
			v5 = false
		end
		v4 = nil
	end
	local v62 = v32.new(v42, p3, p8)
	if v62 then
		v62.__performCameraCinematics = v1
		v62.Cleaner:Add(function() --[[ Line: 202 | Upvalues: v1 (copy), v5 (ref), v4 (ref) ]]
			if v1 then
				v5 = false
			end
			v4 = nil
		end)
		v62.Cleaner:Add(task.delay(60, function() --[[ Line: 207 | Upvalues: v1 (copy), v5 (ref), v4 (ref) ]]
			if not v1 then
				v4 = nil
				return
			end
			v5 = false
			v4 = nil
		end))
		v6 = v62
		if v1 then
			local v7 = ("Cutscene:%*"):format(p2)
			MainlineQuestController:Suppress(v7)
			v62.Cleaner:Add(function() --[[ Line: 216 | Upvalues: MainlineQuestController (ref), v7 (copy) ]]
				MainlineQuestController:Unsuppress(v7)
			end)
		end
		v62.Cleaner:Add(function() --[[ Line: 221 | Upvalues: ProximityPromptService (ref), v1 (copy), GuiControl (ref), v2 (ref), LocalPlayer (ref) ]]
			ProximityPromptService.Enabled = true
			if v1 then
				GuiControl:Unlock()
				GuiControl:SetHUDVisibility(true)
			end
			if v2 then
				v2:Destroy()
			end
			LocalPlayer:SetAttribute("IgnoreFOV", false)
			ProximityPromptService.Enabled = true
			if not v1 then
				return
			end
			GuiControl:FishingUnlock()
		end)
		local v8 = false
		local function closeHUD(p1) --[[ closeHUD | Line: 243 | Upvalues: v8 (ref), v1 (copy), GuiControl (ref) ]]
			if v8 then
				return
			end
			if not p1 then
				task.wait(0.1)
			end
			if not v1 then
				return
			end
			GuiControl:SetHUDVisibility(false)
		end
		local v9 = v3:OnChange("AutoFishing", function() --[[ Line: 257 | Upvalues: v8 (ref), v1 (copy), GuiControl (ref) ]]
			if v8 then
				return
			end
			task.wait(0.1)
			if not v1 then
				return
			end
			GuiControl:SetHUDVisibility(false)
		end)
		local v10 = LocalPlayer:GetAttributeChangedSignal("InCutscene"):Connect(function() --[[ Line: 260 | Upvalues: v8 (ref), v1 (copy), GuiControl (ref) ]]
			if v8 then
				return
			end
			task.wait(0.1)
			if not v1 then
				return
			end
			GuiControl:SetHUDVisibility(false)
		end)
		local v11 = PlayerGui.Backpack:GetPropertyChangedSignal("Enabled"):Connect(function() --[[ Line: 264 | Upvalues: v8 (ref), v1 (copy), GuiControl (ref) ]]
			if v8 then
				return
			end
			task.wait(0.1)
			if not v1 then
				return
			end
			GuiControl:SetHUDVisibility(false)
		end)
		local v12 = PlayerGui.Fishing:GetPropertyChangedSignal("Enabled"):Connect(function() --[[ Line: 267 | Upvalues: v8 (ref), v1 (copy), GuiControl (ref) ]]
			if v8 then
				return
			end
			task.wait(0.1)
			if not v1 then
				return
			end
			GuiControl:SetHUDVisibility(false)
		end)
		local v13 = PlayerGui.Fishing.Main:GetPropertyChangedSignal("Visible"):Connect(function() --[[ Line: 270 | Upvalues: v8 (ref), v1 (copy), GuiControl (ref) ]]
			if v8 then
				return
			end
			task.wait(0.1)
			if not v1 then
				return
			end
			GuiControl:SetHUDVisibility(false)
		end)
		v62.Cleaner:Add(function() --[[ Line: 274 | Upvalues: v8 (ref), v11 (copy), v12 (copy), v13 (copy), v9 (copy), v10 (copy), Players (ref), v1 (copy), GuiControl (ref) ]]
			v8 = true
			v11:Disconnect()
			v12:Disconnect()
			v13:Disconnect()
			v9:Disconnect()
			v10:Disconnect()
			Players.LocalPlayer:SetAttribute("InCutscene", false)
			if not v1 then
				return
			end
			GuiControl:SetHUDVisibility(true)
			task.spawn(function() --[[ Line: 290 | Upvalues: GuiControl (ref) ]]
				for i = 1, 10 do
					GuiControl:SetHUDVisibility(true)
					task.wait(0.05)
				end
			end)
		end)
		task.spawn(closeHUD, true)
		if v1 then
			local v14 = LocalPlayer:GetAttribute("LocationName")
			if v14 ~= "Christmas Cave" and (v14 ~= "Crystalline Passage" and (v14 ~= "Ancient Ruin" and v14 ~= "Esoteric Depths")) then
				ProximityPromptService.Enabled = false
			end
			GuiControl:SetHUDVisibility(false)
		end
		if table.find(t, p2) == nil and v1 then
			Players.LocalPlayer:SetAttribute("InCutscene", true)
		end
		LocalPlayer:SetAttribute("IgnoreFOV", true)
		local v15, v16 = pcall(function() --[[ Line: 321 | Upvalues: v62 (copy), p3 (copy), p4 (copy), v2 (ref), v1 (copy) ]]
			v62:Play(p3, p4, v2, v1)
		end)
		if v15 then
			return
		end
		warn(v16)
		Players.LocalPlayer:SetAttribute("InCutscene", false)
	else
		if v1 then
			GuiControl:Lock()
		end
		if v1 then
			v5 = false
		end
		v4 = nil
	end
end
function t2.Stop(p1) --[[ Stop | Line: 339 | Upvalues: v6 (ref), v4 (ref), GuiControl (copy) ]]
	if not v6 then
		return
	end
	pcall(function() --[[ Line: 341 | Upvalues: v6 (ref) ]]
		v6:Destroy()
	end)
	local v1 = v6 and v6.__performCameraCinematics
	v4 = nil
	if not v1 then
		return
	end
	GuiControl:SetHUDVisibility(true)
end
return t2