-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script.Parent.Types)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = {}
t.__index = t
function t.new(p1, p2, p3, p4) --[[ new | Line: 14 | Upvalues: Trove (copy), t (copy) ]]
	local v2 = setmetatable({
		_Active = false,
		_Destroyed = false,
		Event = p1,
		Instance = p2:Clone(),
		_Offset = p4 or Vector3.new(0, 0, 0),
		_CleanUp = Trove.new(),
		_Character = p3
	}, t)
	v2.Instance.Parent = p3
	return v2
end
function t.Start(p1) --[[ Start | Line: 32 | Upvalues: RunService (copy) ]]
	if p1.Instance:IsA("Model") then
		for v1, v2 in p1.Instance:GetDescendants() do
			if v2:IsA("BasePart") then
				v2.Transparency = 1
			end
		end
	else
		p1.Instance.Transparency = 1
	end
	for k, v in pairs(p1.Instance:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end
	p1._CleanUp:Add(RunService.Heartbeat:Connect(function() --[[ Line: 49 | Upvalues: p1 (copy) ]]
		if not p1._Character:IsDescendantOf(workspace) or (not p1._Active or p1._Destroyed) then
			return
		end
		local v1 = CFrame.new(p1._Character:GetPivot().Position) + p1._Offset
		if p1.Instance:IsA("Model") then
			p1.Instance:PivotTo(v1)
		else
			p1.Instance.CFrame = v1
		end
	end))
	p1._Active = true
end
function t.Resume(p1) --[[ Resume | Line: 64 ]]
	for k, v in pairs(p1.Instance:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end
	p1._Active = true
end
function t.Pause(p1) --[[ Pause | Line: 73 ]]
	for k, v in pairs(p1.Instance:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
	p1._Active = false
end
function t.IsActive(p1) --[[ IsActive | Line: 82 ]]
	return p1._Active
end
function t.Stop(p1) --[[ Stop | Line: 86 ]]
	if p1._Destroyed then
		return
	end
	p1._Active = false
	p1._Destroyed = true
	p1._CleanUp:Destroy()
	if not p1.Instance then
		return
	end
	p1.Instance:Destroy()
end
return t