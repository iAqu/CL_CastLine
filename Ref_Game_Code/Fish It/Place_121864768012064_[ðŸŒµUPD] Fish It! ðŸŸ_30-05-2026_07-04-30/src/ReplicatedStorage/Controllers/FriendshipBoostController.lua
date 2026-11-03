-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local LocalPlayer = Players.LocalPlayer
local FriendshipBoostVFX = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("FriendshipBoostVFX")
local BeamAssets = FriendshipBoostVFX:WaitForChild("BeamAssets")
local Attachment = FriendshipBoostVFX:WaitForChild("AuraVFX"):WaitForChild("Attachment")
local t = {}
local t2 = {}
local v1 = true
local v2 = false
local function getTorsoPart(p1) --[[ getTorsoPart | Line: 34 ]]
	local Character = p1.Character
	if not Character then
		return nil
	end
	local Torso = Character:FindFirstChild("Torso")
	if Torso and Torso:IsA("BasePart") then
		return Torso
	end
	local UpperTorso = Character:FindFirstChild("UpperTorso")
	if UpperTorso and UpperTorso:IsA("BasePart") then
		return UpperTorso
	else
		return nil
	end
end
local function parsePartnerIds() --[[ parsePartnerIds | Line: 53 | Upvalues: LocalPlayer (copy) ]]
	local v1 = LocalPlayer:GetAttribute("FriendshipBoostPartnerIds")
	if typeof(v1) ~= "string" or v1 == "" then
		return {}
	end
	local t = {}
	for v2 in string.gmatch(v1, "[^,]+") do
		local v3 = tonumber(v2)
		if v3 then
			t[v3] = true
		end
	end
	return t
end
local function destroyRender(p1) --[[ destroyRender | Line: 70 | Upvalues: t2 (copy) ]]
	local v1 = t2[p1]
	if v1 then
		v1.BeamStart:Destroy()
		v1.BeamEnd:Destroy()
		v1.LocalAura:Destroy()
		v1.OtherAura:Destroy()
		t2[p1] = nil
	end
end
local function bindBeamAttachments(p1, p2) --[[ bindBeamAttachments | Line: 83 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("Beam") then
			v.Attachment1 = p2
			v.Enabled = true
		end
	end
end
local function createRender(p1, p2, p3) --[[ createRender | Line: 92 | Upvalues: BeamAssets (copy), Attachment (copy), bindBeamAttachments (copy), t2 (copy) ]]
	local v1 = BeamAssets:Clone()
	local Beam1 = v1:FindFirstChild("Beam1")
	local Beam2 = v1:FindFirstChild("Beam2")
	if Beam1 and (Beam1:IsA("Attachment") and (Beam2 and Beam2:IsA("Attachment"))) then
		local v2 = Attachment:Clone()
		local v3 = Attachment:Clone()
		Beam1.Parent = p2
		Beam2.Parent = p3
		v2.Parent = p2
		v3.Parent = p3
		bindBeamAttachments(Beam1, Beam2)
		v1:Destroy()
		t2[p1] = {
			BeamStart = Beam1,
			BeamEnd = Beam2,
			LocalAura = v2,
			OtherAura = v3,
			LocalTorso = p2,
			OtherTorso = p3
		}
	else
		v1:Destroy()
	end
end
local function syncRenders() --[[ syncRenders | Line: 121 | Upvalues: parsePartnerIds (copy), LocalPlayer (copy), v2 (ref), Soundbook (copy), t2 (copy), Players (copy), createRender (copy) ]]
	local v1 = parsePartnerIds()
	local Character = LocalPlayer.Character
	local v22
	if Character then
		local Torso = Character:FindFirstChild("Torso")
		if Torso and Torso:IsA("BasePart") then
			v22 = Torso
		else
			local UpperTorso = Character:FindFirstChild("UpperTorso")
			v22 = if UpperTorso and UpperTorso:IsA("BasePart") then UpperTorso else nil
		end
	else
		v22 = nil
	end
	local v3 = if next(v1) == nil then false else true
	if v3 and not v2 then
		Soundbook.Sounds.FriendshipBoostActivated:Play()
	end
	v2 = v3
	for v4 in t2 do
		if not (v1[v4] and v22) then
			local v5 = t2[v4]
			if v5 then
				v5.BeamStart:Destroy()
				v5.BeamEnd:Destroy()
				v5.LocalAura:Destroy()
				v5.OtherAura:Destroy()
				t2[v4] = nil
			end
		end
	end
	if not v22 then
		return
	end
	for v7 in v1 do
		local v6
		local v8 = Players:GetPlayerByUserId(v7)
		if v8 then
			local Character_2 = v8.Character
			if Character_2 then
				local Torso = Character_2:FindFirstChild("Torso")
				if Torso and Torso:IsA("BasePart") then
					v6 = Torso
				else
					local UpperTorso = Character_2:FindFirstChild("UpperTorso")
					v6 = if UpperTorso and UpperTorso:IsA("BasePart") then UpperTorso else nil
				end
			else
				v6 = nil
			end
			if not v6 then
				v6 = nil
			end
		else
			v6 = nil
		end
		local v9 = t2[v7]
		if v6 then
			if v9 then
				if v9.LocalTorso ~= v22 or v9.OtherTorso ~= v6 then
					local v10 = t2[v7]
					if v10 then
						v10.BeamStart:Destroy()
						v10.BeamEnd:Destroy()
						v10.LocalAura:Destroy()
						v10.OtherAura:Destroy()
						t2[v7] = nil
					end
					createRender(v7, v22, v6)
				end
				continue
			end
			createRender(v7, v22, v6)
			continue
		end
		if v9 then
			local v11 = t2[v7]
			if v11 then
				v11.BeamStart:Destroy()
				v11.BeamEnd:Destroy()
				v11.LocalAura:Destroy()
				v11.OtherAura:Destroy()
				t2[v7] = nil
			end
		end
	end
end
local function markDirty() --[[ markDirty | Line: 165 | Upvalues: v1 (ref) ]]
	v1 = true
end
local function observePlayer(p1) --[[ observePlayer | Line: 169 | Upvalues: markDirty (copy) ]]
	p1.CharacterAdded:Connect(markDirty)
	p1.CharacterRemoving:Connect(markDirty)
end
function t.Start(p1) --[[ Start | Line: 174 | Upvalues: Players (copy), markDirty (copy), v1 (ref), t2 (copy), LocalPlayer (copy), RunService (copy), syncRenders (copy) ]]
	for i, v in ipairs(Players:GetPlayers()) do
		v.CharacterAdded:Connect(markDirty)
		v.CharacterRemoving:Connect(markDirty)
	end
	Players.PlayerAdded:Connect(function(p1) --[[ Line: 179 | Upvalues: markDirty (ref), v1 (ref) ]]
		p1.CharacterAdded:Connect(markDirty)
		p1.CharacterRemoving:Connect(markDirty)
		v1 = true
	end)
	Players.PlayerRemoving:Connect(function(p1) --[[ Line: 184 | Upvalues: t2 (ref), v1 (ref) ]]
		local UserId = p1.UserId
		local v12 = t2[UserId]
		if not v12 then
			v1 = true
			return
		end
		v12.BeamStart:Destroy()
		v12.BeamEnd:Destroy()
		v12.LocalAura:Destroy()
		v12.OtherAura:Destroy()
		t2[UserId] = nil
		v1 = true
	end)
	LocalPlayer:GetAttributeChangedSignal("FriendshipBoostPartnerIds"):Connect(markDirty)
	LocalPlayer.CharacterAdded:Connect(markDirty)
	LocalPlayer.CharacterRemoving:Connect(markDirty)
	RunService.RenderStepped:Connect(function() --[[ Line: 193 | Upvalues: v1 (ref), syncRenders (ref) ]]
		if v1 then
			v1 = false
			syncRenders()
		end
	end)
end
return t