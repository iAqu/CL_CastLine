-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Signal = require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Net)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local ModelDownloader = require(ReplicatedStorage.Modules.ModelDownloader)
require(ReplicatedStorage.Halos)
local v1 = nil
local v2 = Signal.new()
local t = {}
local t2 = {}
local t3 = {}
function t3.Start(p1) --[[ Start | Line: 35 | Upvalues: v1 (ref), Replion (copy), v2 (copy), t (copy), t3 (copy), Observers (copy), RunService (copy), t2 (copy) ]]
	v1 = Replion.Client:WaitReplion("ReplicatedPlayerData")
	v2:Connect(function(p1) --[[ Line: 39 | Upvalues: t (ref), t3 (ref) ]]
		if t[p1] then
			t3:Render(p1, p1.Character)
		else
			t3:Unrender(p1)
		end
	end)
	Observers.observeCharacter(function(p1, p2) --[[ Line: 48 | Upvalues: v1 (ref), t3 (ref) ]]
		local v12 = ("User_%*"):format(p1.UserId)
		local v2 = nil
		local function replicationChanged() --[[ replicationChanged | Line: 54 | Upvalues: v2 (ref), v1 (ref), v12 (copy), t3 (ref), p1 (copy) ]]
			local v13 = v2
			local v22 = v1:Get(v12)
			if not v22 then
				return
			end
			local v3 = v22.Settings["Show VIP Halo"]
			local v4 = if v13 then v13.Settings["Show VIP Halo"] else v13
			if v3 then
				local v5 = if v3 and v2 == nil then true elseif v13 then not v4 and v3 else v13
				if v13 and (v13.EquippedHaloId and v22.EquippedHaloId ~= v13.EquippedHaloId) then
					t3:Render(p1, p1.Character)
				elseif v5 then
					t3:Enable(p1)
				end
			else
				t3:Disable(p1)
			end
			if v3 then
				if v22.HaloColor then
					local v6 = t3:_toColor3(v22.HaloColor)
					local v7 = t3:_getRender(p1.UserId)
					if v7 then
						t3:_modifyHalo(v7, v6)
					end
				end
				if v13 and (v13.EquippedHaloId and v22.EquippedHaloId ~= v13.EquippedHaloId) then
					t3:Render(p1, p1.Character)
				end
			end
			v2 = v22
		end
		local v3 = p1.AttributeChanged:Connect(function() --[[ Line: 116 | Upvalues: p1 (copy), t3 (ref) ]]
			if not p1:GetAttribute("VIP") then
				return
			end
			if not t3:GetHaloValue(p1) then
				return
			end
			t3:Render(p1, p1.Character)
		end)
		local v4 = v1:OnChange(v12, replicationChanged)
		if v1:Get(v12) then
			replicationChanged()
		end
		if t3:GetHaloValue(p1) then
			t3:Render(p1, p2)
		end
		return function() --[[ Line: 139 | Upvalues: v3 (copy), v4 (copy), t3 (ref), p1 (copy) ]]
			v3:Disconnect()
			v4:Disconnect()
			t3:Unrender(p1)
		end
	end)
	Observers.observePlayer(function(p1) --[[ Line: 149 | Upvalues: t (ref) ]]
		t[p1] = false
		return function() --[[ Line: 152 | Upvalues: t (ref), p1 (copy) ]]
			t[p1] = nil
		end
	end)
	RunService:BindToRenderStep("UpdateHalo", Enum.RenderPriority.Camera.Value + 1, function(p1) --[[ Line: 170 | Upvalues: t3 (ref), t2 (ref) ]]
		local v1 = t3:_getHaloDelta()
		for i, v in ipairs(t2) do
			t3:_updateRender(v, v1)
		end
	end)
end
function t3.GetHaloValue(p1, p2) --[[ GetHaloValue | Line: 178 | Upvalues: t (copy) ]]
	return t[p2]
end
function t3._setHalo(p1, p2, p3) --[[ _setHalo | Line: 182 | Upvalues: t (copy), v2 (copy) ]]
	if p3 ~= t[p2] then
		t[p2] = p3
		v2:Fire(p2)
	end
end
function t3._getRender(p1, p2) --[[ _getRender | Line: 191 | Upvalues: t2 (copy) ]]
	for i = #t2, 1, -1 do
		local v1 = t2[i]
		if v1 and v1.UserId == p2 then
			return v1
		end
	end
end
function t3.Disable(p1, p2) --[[ Disable | Line: 202 | Upvalues: t3 (copy) ]]
	t3:_setHalo(p2, false)
end
function t3.Enable(p1, p2) --[[ Enable | Line: 206 | Upvalues: t3 (copy) ]]
	t3:_setHalo(p2, true)
end
function t3.Unrender(p1, p2) --[[ Unrender | Line: 210 | Upvalues: t2 (copy) ]]
	for i = #t2, 1, -1 do
		local v1 = t2[i]
		if v1 and v1.UserId == p2.UserId then
			if v1.PVInstance then
				v1.PVInstance:Destroy()
			end
			table.remove(t2, i)
		end
	end
end
function t3.Render(p1, p2, p3) --[[ Render | Line: 229 | Upvalues: t3 (copy), ItemUtility (copy), ModelDownloader (copy), t2 (copy) ]]
	if not p2:GetAttribute("VIP") then
		return
	end
	if not p3 then
		return
	end
	local Head = p3:FindFirstChild("Head")
	if not Head then
		return
	end
	t3:Unrender(p2)
	local v1 = t3:_getReplicatedData(p2)
	local v2 = t3:_toColor3(v1.HaloColor)
	local v3 = ItemUtility.GetItemDataFromItemType("Halos", v1.EquippedHaloId)
	if not v3 then
		warn("NO HALO DATA")
		return
	end
	local v4 = ModelDownloader:Wait("Halos", v3.Data.Name)
	if not v4 then
		warn("NO MODEL FOUND")
		return
	end
	local v5 = v4:Clone()
	if v5:IsA("BasePart") then
		v5.Anchored = true
		v5.CanCollide = false
	end
	for i, v in ipairs(v5:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
		end
	end
	local t = {
		UserId = p2.UserId
	}
	t.Rotation = v3.Rotation or CFrame.identity
	t.Height = v3.Height or 1.5
	t.Sensitivity = v3.Sensitivity or nil
	t.PVInstance = v5
	t.Head = Head
	local v7 = t3:_getHaloDelta()
	v5.Parent = workspace.CurrentCamera
	t3:_modifyHalo(t, v2)
	t3:_updateRender(t, v7)
	table.insert(t2, t)
end
function t3._getHaloDelta(p1) --[[ _getHaloDelta | Line: 304 ]]
	return (math.sin(4.71238898038469 + tick()) + 1) * 0.25
end
function t3._updateRender(p1, p2, p3) --[[ _updateRender | Line: 311 ]]
	if not p2.PVInstance then
		return
	end
	if not p2.Head then
		return
	end
	if not p2.Rotation then
		local identity = CFrame.identity
	end
	if p2.Sensitivity then
		p3 = p3 * p2.Sensitivity
	end
	local v2 = p2.Head.CFrame
	local Position = v2.Position
	p2.PVInstance:PivotTo(v2 + Vector3.new(0, 1, 0) * (p3 + (p2.Height or 1.5)))
end
function t3._modifyHalo(p1, p2, p3) --[[ _modifyHalo | Line: 336 ]]
	local PVInstance = p2.PVInstance
	if not PVInstance then
		return
	end
	local v1 = ColorSequence.new(p3)
	local function updateDescendant(p1) --[[ updateDescendant | Line: 344 | Upvalues: p3 (copy), v1 (copy) ]]
		if p1:IsA("BasePart") or p1:IsA("Light") then
			p1.Color = p3
		else
			if not (p1:IsA("ParticleEmitter") or (p1:IsA("Trail") or p1:IsA("Beam"))) then
				return
			end
			p1.Color = v1
		end
	end
	for i, v in ipairs(PVInstance:GetDescendants()) do
		updateDescendant(v)
	end
	if not PVInstance:IsA("BasePart") then
		return
	end
	updateDescendant(PVInstance)
end
function t3._toColor3(p1, p2) --[[ _toColor3 | Line: 364 ]]
	return Color3.fromRGB(p2[1], p2[2], p2[3])
end
function t3._getReplicatedData(p1, p2) --[[ _getReplicatedData | Line: 370 | Upvalues: v1 (ref) ]]
	return v1:Get((("User_%*"):format(p2.UserId)))
end
return t3