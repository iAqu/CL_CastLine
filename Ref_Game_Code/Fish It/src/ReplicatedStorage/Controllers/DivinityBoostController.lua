-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local DivinityBoostVFX = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("DivinityBoostVFX")
local BeamAssets = DivinityBoostVFX:WaitForChild("BeamAssets")
local Attachment = DivinityBoostVFX:WaitForChild("AuraVFX"):WaitForChild("Attachment")
local t = {}
local t2 = {}
local t3 = {}
local v1 = true
local function getTorsoPart(p1) --[[ getTorsoPart | Line: 40 ]]
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
local function parsePartnerIds(p1) --[[ parsePartnerIds | Line: 59 ]]
	local v1 = p1:GetAttribute("DivinityBoostPartnerIds")
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
local function getConnectionKey(p1, p2) --[[ getConnectionKey | Line: 76 ]]
	if p1 < p2 then
		return ("%*:%*"):format(p1, p2)
	else
		return ("%*:%*"):format(p2, p1)
	end
end
local function destroyConnection(p1) --[[ destroyConnection | Line: 84 | Upvalues: t2 (copy) ]]
	local v1 = t2[p1]
	if v1 then
		v1.BeamStart:Destroy()
		v1.BeamEnd:Destroy()
		t2[p1] = nil
	end
end
local function destroyAura(p1) --[[ destroyAura | Line: 95 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]
	if v1 then
		v1.Aura:Destroy()
		t3[p1] = nil
	end
end
local function bindBeamAttachments(p1, p2) --[[ bindBeamAttachments | Line: 105 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("Beam") then
			v.Attachment1 = p2
			v.Enabled = true
		end
	end
end
local function createConnection(p1, p2) --[[ createConnection | Line: 114 | Upvalues: BeamAssets (copy), bindBeamAttachments (copy), t2 (copy) ]]
	local v1 = BeamAssets:Clone()
	local Beam1 = v1:FindFirstChild("Beam1")
	local Beam2 = v1:FindFirstChild("Beam2")
	if Beam1 and (Beam1:IsA("Attachment") and (Beam2 and Beam2:IsA("Attachment"))) then
		Beam1.Parent = p2.SourceTorso
		Beam2.Parent = p2.TargetTorso
		bindBeamAttachments(Beam1, Beam2)
		v1:Destroy()
		t2[p1] = {
			BeamStart = Beam1,
			BeamEnd = Beam2,
			SourceUserId = p2.SourceUserId,
			TargetUserId = p2.TargetUserId,
			SourceTorso = p2.SourceTorso,
			TargetTorso = p2.TargetTorso
		}
	else
		v1:Destroy()
	end
end
local function createAura(p1, p2) --[[ createAura | Line: 138 | Upvalues: Attachment (copy), t3 (copy) ]]
	local v1 = Attachment:Clone()
	v1.Parent = p2
	t3[p1] = {
		Aura = v1,
		Torso = p2
	}
end
local function syncAuras(p1) --[[ syncAuras | Line: 148 | Upvalues: t3 (copy), Attachment (copy) ]]
	for v1 in t3 do
		if not p1[v1] then
			local v2 = t3[v1]
			if v2 then
				v2.Aura:Destroy()
				t3[v1] = nil
			end
		end
	end
	for v3, v4 in p1 do
		local v5 = t3[v3]
		if v5 then
			if v5.Torso ~= v4 then
				local v6 = t3[v3]
				if v6 then
					v6.Aura:Destroy()
					t3[v3] = nil
				end
				local v7 = Attachment:Clone()
				v7.Parent = v4
				t3[v3] = {
					Aura = v7,
					Torso = v4
				}
			end
			continue
		end
		local v8 = Attachment:Clone()
		v8.Parent = v4
		t3[v3] = {
			Aura = v8,
			Torso = v4
		}
	end
end
local function syncConnections(p1) --[[ syncConnections | Line: 168 | Upvalues: t2 (copy), createConnection (copy) ]]
	for v1 in t2 do
		if not p1[v1] then
			local v2 = t2[v1]
			if v2 then
				v2.BeamStart:Destroy()
				v2.BeamEnd:Destroy()
				t2[v1] = nil
			end
		end
	end
	for v3, v4 in p1 do
		local v5 = t2[v3]
		if v5 then
			if v5.SourceTorso ~= v4.SourceTorso or v5.TargetTorso ~= v4.TargetTorso then
				local v6 = t2[v3]
				if v6 then
					v6.BeamStart:Destroy()
					v6.BeamEnd:Destroy()
					t2[v3] = nil
				end
				createConnection(v3, v4)
			end
			continue
		end
		createConnection(v3, v4)
	end
end
local function syncRenders() --[[ syncRenders | Line: 188 | Upvalues: Players (copy), parsePartnerIds (copy), syncAuras (copy), syncConnections (copy) ]]
	local t = {}
	local t2 = {}
	for i, v in ipairs(Players:GetPlayers()) do
		local v1, v2
		if v:GetAttribute("DivinityBoostActive") == true then
			local Character = v.Character
			if Character then
				local Torso = Character:FindFirstChild("Torso")
				if Torso and Torso:IsA("BasePart") then
					v1 = Torso
				else
					local UpperTorso = Character:FindFirstChild("UpperTorso")
					v1 = if UpperTorso and UpperTorso:IsA("BasePart") then UpperTorso else nil
				end
			else
				v1 = nil
			end
			if v1 then
				t2[v.UserId] = v1
			end
		end
		local Character = v.Character
		if Character then
			local Torso = Character:FindFirstChild("Torso")
			if Torso and Torso:IsA("BasePart") then
				v2 = Torso
			else
				local UpperTorso = Character:FindFirstChild("UpperTorso")
				v2 = if UpperTorso and UpperTorso:IsA("BasePart") then UpperTorso else nil
			end
		else
			v2 = nil
		end
		if v2 then
			for v5 in parsePartnerIds(v) do
				local v3, v4
				if not (v5 < v.UserId) then
					local v6 = Players:GetPlayerByUserId(v5)
					if v6 then
						local Character_2 = v6.Character
						if Character_2 then
							local Torso = Character_2:FindFirstChild("Torso")
							if Torso and Torso:IsA("BasePart") then
								v3 = Torso
							else
								local UpperTorso = Character_2:FindFirstChild("UpperTorso")
								v3 = if UpperTorso and UpperTorso:IsA("BasePart") then UpperTorso else nil
							end
						else
							v3 = nil
						end
						if not v3 then
							v3 = nil
						end
					else
						v3 = nil
					end
					if v3 then
						local UserId = v.UserId
						v4 = if UserId < v5 then ("%*:%*"):format(UserId, v5) else ("%*:%*"):format(v5, UserId)
						t[v4] = {
							SourceUserId = v.UserId,
							TargetUserId = v5,
							SourceTorso = v2,
							TargetTorso = v3
						}
					end
				end
			end
		end
	end
	syncAuras(t2)
	syncConnections(t)
end
local function markDirty() --[[ markDirty | Line: 227 | Upvalues: v1 (ref) ]]
	v1 = true
end
local function observePlayer(p1) --[[ observePlayer | Line: 231 | Upvalues: markDirty (copy) ]]
	p1.CharacterAdded:Connect(markDirty)
	p1.CharacterRemoving:Connect(markDirty)
	p1:GetAttributeChangedSignal("DivinityBoostActive"):Connect(markDirty)
	p1:GetAttributeChangedSignal("DivinityBoostPartnerIds"):Connect(markDirty)
end
function t.Start(p1) --[[ Start | Line: 238 | Upvalues: Players (copy), observePlayer (copy), v1 (ref), t3 (copy), t2 (copy), RunService (copy), syncRenders (copy) ]]
	for i, v in ipairs(Players:GetPlayers()) do
		observePlayer(v)
	end
	Players.PlayerAdded:Connect(function(p1) --[[ Line: 243 | Upvalues: observePlayer (ref), v1 (ref) ]]
		observePlayer(p1)
		v1 = true
	end)
	Players.PlayerRemoving:Connect(function(p1) --[[ Line: 248 | Upvalues: t3 (ref), t2 (ref), v1 (ref) ]]
		local UserId = p1.UserId
		local v12 = t3[UserId]
		if v12 then
			v12.Aura:Destroy()
			t3[UserId] = nil
		end
		for v2, v3 in t2 do
			if v3.SourceUserId == p1.UserId or v3.TargetUserId == p1.UserId then
				local v4 = t2[v2]
				if v4 then
					v4.BeamStart:Destroy()
					v4.BeamEnd:Destroy()
					t2[v2] = nil
				end
			end
		end
		v1 = true
	end)
	RunService.RenderStepped:Connect(function() --[[ Line: 258 | Upvalues: v1 (ref), syncRenders (ref) ]]
		if v1 then
			v1 = false
			syncRenders()
		end
	end)
end
return t