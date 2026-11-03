-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Debris = game:GetService("Debris")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local Abilities = require(ReplicatedStorage.Abilities)
local AbilityPreviewController = require(ReplicatedStorage.Controllers.AbilityPreviewController)
local ParticleEmitter = require(ReplicatedStorage.Modules.ParticleEmitter)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local LocalPlayer = Players.LocalPlayer
local v1 = Net:RemoteEvent("PlayAbilityVFX")
local t = {}
local t2 = {}
local t3 = {}
local t4 = {}
local function getAbilityAssets() --[[ getAbilityAssets | Line: 30 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	if Assets then
		return Assets:FindFirstChild("Abilities")
	else
		return nil
	end
end
local function getTargetCharacter(p1, p2) --[[ getTargetCharacter | Line: 39 | Upvalues: LocalPlayer (copy), AbilityPreviewController (copy) ]]
	if p2 and p1 == LocalPlayer then
		local v1 = AbilityPreviewController:GetRig()
		if v1 then
			return v1, true
		end
	end
	return p1.Character, false
end
local function getFeetCFrame(p1) --[[ getFeetCFrame | Line: 50 ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
		return HumanoidRootPart.CFrame * CFrame.new(0, -(p1:GetExtentsSize().Y * 0.5), 0)
	else
		return nil
	end
end
local function getCenterCFrame(p1) --[[ getCenterCFrame | Line: 61 ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
		return HumanoidRootPart.CFrame
	else
		return p1:GetPivot()
	end
end
local function getTemplate(p1) --[[ getTemplate | Line: 70 | Upvalues: ReplicatedStorage (copy), Abilities (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1 = if Assets then Assets:FindFirstChild("Abilities") else nil
	if not v1 then
		return nil
	end
	local v2 = Abilities[p1]
	if v2 then
		local v3 = v1:FindFirstChild(v2.VFX)
		if v3 then
			return v3
		end
	end
	return v1:FindFirstChild(p1)
end
local function getAuraTemplate(p1) --[[ getAuraTemplate | Line: 87 | Upvalues: ReplicatedStorage (copy), Abilities (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1 = if Assets then Assets:FindFirstChild("Abilities") else nil
	if not v1 then
		return nil
	end
	local CharacterAuras = v1:FindFirstChild("CharacterAuras")
	if not CharacterAuras then
		return nil
	end
	local v2 = Abilities[p1]
	if v2 then
		local v3 = CharacterAuras:FindFirstChild(v2.VFX) or CharacterAuras:FindFirstChild(v2.Name)
		if v3 then
			return v3
		end
	end
	return CharacterAuras:FindFirstChild(p1)
end
local function preloadCharacterAuras() --[[ preloadCharacterAuras | Line: 109 | Upvalues: ReplicatedStorage (copy), ContentProvider (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1 = if Assets then Assets:FindFirstChild("Abilities") else nil
	if not v1 then
		return
	end
	local CharacterAuras = v1:FindFirstChild("CharacterAuras")
	if CharacterAuras then
		local v2 = CharacterAuras:GetDescendants()
		table.insert(v2, CharacterAuras)
		task.spawn(function() --[[ Line: 123 | Upvalues: ContentProvider (ref), v2 (copy) ]]
			pcall(ContentProvider.PreloadAsync, ContentProvider, v2)
		end)
	end
end
local function placeVFX(p1, p2) --[[ placeVFX | Line: 128 ]]
	if p1:IsA("BasePart") then
		p1.Anchored = true
		p1.CanCollide = false
		p1.CanTouch = false
		p1.CanQuery = false
		p1.CFrame = p2
		return
	end
	if not p1:IsA("Model") then
		return
	end
	p1:PivotTo(p2)
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = false
		end
	end
end
local function stopActiveVFX(p1) --[[ stopActiveVFX | Line: 148 | Upvalues: t2 (copy), t3 (copy) ]]
	local v1 = t2[p1]
	if v1 then
		v1:Destroy()
		t2[p1] = nil
	end
	local v2 = t3[p1]
	if v2 then
		v2:Destroy()
		t3[p1] = nil
	end
	for i, v in ipairs(p1:GetChildren()) do
		if v:GetAttribute("AbilityVFX") == true then
			v:Destroy()
		end
	end
	for i, v in ipairs(p1:GetDescendants()) do
		if v:GetAttribute("AbilityVFX") == true then
			v:Destroy()
		end
	end
end
local function stopActiveAura(p1) --[[ stopActiveAura | Line: 174 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]
	if v1 then
		v1:Destroy()
		t3[p1] = nil
	end
	for i, v in ipairs(p1:GetDescendants()) do
		if v:GetAttribute("AbilityAuraVFX") == true then
			v:Destroy()
		end
	end
end
local function createAttachToPart(p1, p2, p3) --[[ createAttachToPart | Line: 188 ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	local v1 = if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart.CFrame else p1:GetPivot()
	if not v1 then
		return nil
	end
	local AttachTo = Instance.new("Part")
	AttachTo.Name = "AttachTo"
	AttachTo.Anchored = true
	AttachTo.CanCollide = false
	AttachTo.CanTouch = false
	AttachTo.CanQuery = false
	AttachTo.Transparency = 1
	local v3 = p2:GetAttribute("PartSize") or p3:GetAttribute("PartSize")
	AttachTo.Size = if typeof(v3) == "Vector3" then v3 else Vector3.new(1, 1, 1)
	AttachTo.CFrame = v1
	local HumanoidRootPart_2 = p1:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart_2 and HumanoidRootPart_2:IsA("BasePart") then
		AttachTo.Anchored = false
		AttachTo.Massless = true
		local Weld = Instance.new("Weld")
		Weld.Part0 = AttachTo
		Weld.Part1 = HumanoidRootPart_2
		Weld.Parent = AttachTo
	end
	return AttachTo
end
local function getAuraDuration(p1) --[[ getAuraDuration | Line: 219 ]]
	local v1 = p1:GetAttribute("Duration") or (p1:GetAttribute("AuraDuration") or p1:GetAttribute("DisableAfter"))
	if typeof(v1) == "number" then
		return v1
	else
		return 2.5
	end
end
local function prepareAuraObject(p1) --[[ prepareAuraObject | Line: 224 ]]
	local v1 = 0
	if p1:IsA("ParticleEmitter") then
		p1.Enabled = true
		v1 = math.max(v1, p1.Lifetime.Max)
	elseif p1:IsA("Trail") or p1:IsA("Beam") then
		p1.Enabled = true
	end
	for i, v in ipairs(p1:GetDescendants()) do
		v:SetAttribute("AbilityVFX", true)
		v:SetAttribute("AbilityAuraVFX", true)
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
			v1 = math.max(v1, v.Lifetime.Max)
			continue
		end
		if v:IsA("Trail") then
			v.Enabled = true
			v1 = math.max(v1, v.Lifetime)
			continue
		end
		if v:IsA("Beam") then
			v.Enabled = true
		end
	end
	return v1
end
local function disableActiveAura(p1) --[[ disableActiveAura | Line: 252 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:GetAttribute("AbilityAuraVFX") == true and (v:IsA("ParticleEmitter") or (v:IsA("Trail") or v:IsA("Beam"))) then
			v.Enabled = false
		end
	end
end
local function playCharacterAura(p1, p2, p3, p4, p5) --[[ playCharacterAura | Line: 260 | Upvalues: getAuraTemplate (copy), stopActiveAura (copy), t3 (copy), createAttachToPart (copy), prepareAuraObject (copy), Abilities (copy), Soundbook (copy), disableActiveAura (copy) ]]
	local v1 = getAuraTemplate(p1)
	if not v1 then
		return false
	end
	stopActiveAura(p2)
	local AbilityCharacterAura = Instance.new("Folder")
	AbilityCharacterAura.Name = "AbilityCharacterAura"
	AbilityCharacterAura:SetAttribute("AbilityVFX", true)
	AbilityCharacterAura:SetAttribute("AbilityAuraVFX", true)
	AbilityCharacterAura.Parent = p2
	t3[p2] = AbilityCharacterAura
	local v2
	if p4 then
		v2 = p4
	else
		local v3 = v1:GetAttribute("Duration") or (v1:GetAttribute("AuraDuration") or v1:GetAttribute("DisableAfter"))
		v2 = if typeof(v3) == "number" then v3 else 2.5
	end
	local v4 = 0
	for i, v in ipairs(v1:GetChildren()) do
		local v5 = p2:FindFirstChild(v.Name)
		if v.Name == "AttachTo" then
			local v6 = createAttachToPart(p2, v, v1)
			if v6 then
				v6:SetAttribute("AbilityVFX", true)
				v6:SetAttribute("AbilityAuraVFX", true)
				v6.Parent = AbilityCharacterAura
			end
			v5 = v6
		end
		if v5 then
			for i2, v3 in ipairs(v:GetChildren()) do
				local v7 = v3:Clone()
				v7:SetAttribute("AbilityVFX", true)
				v7:SetAttribute("AbilityAuraVFX", true)
				v7.Parent = v5
				v4 = math.max(v4, (prepareAuraObject(v7)))
			end
		end
	end
	local v10 = Abilities[p1]
	if v10 and p3 then
		local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart")
		local v11 = if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart.CFrame else p2:GetPivot()
		for i, v in ipairs(v10.Sounds) do
			if v11 and Soundbook:HasSound(v) then
				Soundbook:RenderAt(v, v11.Position)
			end
		end
	end
	if not p5 then
		task.delay(v2, function() --[[ Line: 315 | Upvalues: t3 (ref), p2 (copy), AbilityCharacterAura (copy), disableActiveAura (ref) ]]
			if t3[p2] ~= AbilityCharacterAura then
				return
			end
			disableActiveAura(p2)
		end)
		task.delay(v2 + v4 + 1, function() --[[ Line: 321 | Upvalues: t3 (ref), p2 (copy), AbilityCharacterAura (copy), stopActiveAura (ref) ]]
			if t3[p2] ~= AbilityCharacterAura then
				return
			end
			stopActiveAura(p2)
		end)
	end
	return true
end
local function restoreSuppressedVFX(p1) --[[ restoreSuppressedVFX | Line: 330 | Upvalues: t4 (copy) ]]
	local v1 = t4[p1]
	if not v1 then
		return
	end
	for v2, v3 in v1.Instances do
		if v2:IsDescendantOf(game) and (v2:IsA("ParticleEmitter") or (v2:IsA("Trail") or v2:IsA("Beam"))) then
			v2.Transparency = v3
		end
	end
	t4[p1] = nil
end
local function isAbilityVFXDescendant(p1, p2) --[[ isAbilityVFXDescendant | Line: 345 ]]
	local v1 = p1
	while v1 and v1 ~= p2 do
		if v1:GetAttribute("AbilityVFX") == true then
			return true
		end
		v1 = v1.Parent
	end
	return false
end
local function suppressCharacterVFX(p1, p2) --[[ suppressCharacterVFX | Line: 358 | Upvalues: restoreSuppressedVFX (copy), isAbilityVFXDescendant (copy), t4 (copy) ]]
	restoreSuppressedVFX(p1)
	local t = {}
	for i, v in ipairs(p1:GetDescendants()) do
		if not isAbilityVFXDescendant(v, p1) and (v:IsA("ParticleEmitter") or (v:IsA("Trail") or v:IsA("Beam"))) then
			t[v] = v.Transparency
			v.Transparency = NumberSequence.new(1)
		end
	end
	local v1 = os.clock()
	t4[p1] = {
		Token = v1,
		Instances = t
	}
	task.delay(p2, function() --[[ Line: 379 | Upvalues: t4 (ref), p1 (copy), v1 (copy), restoreSuppressedVFX (ref) ]]
		local v12 = t4[p1]
		if not v12 or v12.Token ~= v1 then
			return
		end
		restoreSuppressedVFX(p1)
	end)
end
local function playAbilityVFX(p1, p2, p3, p4, p5, p6) --[[ playAbilityVFX | Line: 387 | Upvalues: LocalPlayer (copy), AbilityPreviewController (copy), stopActiveVFX (copy), playCharacterAura (copy), ReplicatedStorage (copy), Abilities (copy), getFeetCFrame (copy), placeVFX (copy), t2 (copy), Soundbook (copy), ParticleEmitter (copy), suppressCharacterVFX (copy), Debris (copy) ]]
	local v1, v2
	if p3 and p2 == LocalPlayer then
		local v3 = AbilityPreviewController:GetRig()
		if v3 then
			v1 = v3
			v2 = true
		else
			v1 = p2.Character
			v2 = false
		end
	else
		v1 = p2.Character
		v2 = false
	end
	if not v1 then
		return false
	end
	if v2 then
		stopActiveVFX(v1)
		return playCharacterAura(p1, v1, if p5 == true then true else false, nil, p6)
	else
		local Assets = ReplicatedStorage:FindFirstChild("Assets")
		local v7 = if Assets then Assets:FindFirstChild("Abilities") else nil
		local v8
		if v7 then
			local v9 = Abilities[p1]
			local v10
			if v9 then
				local v11 = v7:FindFirstChild(v9.VFX)
				if v11 then
					v8 = v11
				else
					v10 = v7:FindFirstChild(p1)
					v8 = v10
				end
			else
				v10 = v7:FindFirstChild(p1)
				v8 = v10
			end
		else
			v8 = nil
		end
		local v12 = if p4 then CFrame.new(p4) else getFeetCFrame(v1)
		if not (v8 and v12) then
			return false
		end
		stopActiveVFX(v1)
		local v13 = v8:Clone()
		v13:SetAttribute("AbilityVFX", true)
		placeVFX(v13, v12)
		v13.Parent = workspace
		t2[v1] = v13
		local v14 = Abilities[p1]
		if v14 then
			for i, v in ipairs(v14.Sounds) do
				if Soundbook:HasSound(v) then
					Soundbook:RenderAt(v, v12.Position)
				end
			end
		end
		local v15 = ParticleEmitter.emitContainer(v13) + 2
		if playCharacterAura(p1, v1, false, v15, false) then
			suppressCharacterVFX(v1, v15)
		end
		Debris:AddItem(v13, v15)
		task.delay(v15, function() --[[ Line: 429 | Upvalues: t2 (ref), v1 (copy), v13 (copy) ]]
			if t2[v1] ~= v13 then
				return
			end
			t2[v1] = nil
		end)
		return true
	end
end
function t.Start(p1) --[[ Start | Line: 437 | Upvalues: preloadCharacterAuras (copy), v1 (copy), Replion (copy), LocalPlayer (copy), playAbilityVFX (copy) ]]
	preloadCharacterAuras()
	v1.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 440 | Upvalues: Replion (ref), LocalPlayer (ref), playAbilityVFX (ref) ]]
		local v1 = Replion.Client:GetReplion("Data")
		if not v1 then
			return
		end
		local v2 = if p2 == LocalPlayer then v1:Get({ "Settings", "Self Rod VFX" }) else false
		if not (v2 or (if p2 == LocalPlayer then false else v1:Get({ "Settings", "Others Rod VFX" }))) then
			return
		end
		playAbilityVFX(p1, p2, false, p3)
	end)
end
function t.PlayForPlayer(p1, p2, p3) --[[ PlayForPlayer | Line: 454 | Upvalues: playAbilityVFX (copy) ]]
	return playAbilityVFX(p2, p3, true, nil, true, true)
end
function t.ShowPreviewAura(p1, p2, p3) --[[ ShowPreviewAura | Line: 458 | Upvalues: playAbilityVFX (copy) ]]
	return playAbilityVFX(p2, p3, true, nil, false, true)
end
return t