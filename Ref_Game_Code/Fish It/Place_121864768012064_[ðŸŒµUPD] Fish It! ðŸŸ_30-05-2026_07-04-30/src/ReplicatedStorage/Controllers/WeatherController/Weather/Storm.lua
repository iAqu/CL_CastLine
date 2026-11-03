-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Base = require(script.Parent.Parent.Internal.Base)
local t = {}
t.__index = t
setmetatable(t, Base)
function t.new() --[[ new | Line: 15 | Upvalues: Base (copy), Players (copy), t (copy) ]]
	local v1 = Base.new("Storm", script.Parent.Parent.Assets.Rain, Players.LocalPlayer.Character, Vector3.new(0, 20, 0))
	setmetatable(v1, t)
	return v1
end
function t.Start(p1) --[[ Start | Line: 21 | Upvalues: SoundService (copy), RunService (copy) ]]
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
	local Storm = Instance.new("Sound")
	Storm.Name = "Storm"
	Storm.Looped = true
	Storm.SoundId = "rbxassetid://18214464638"
	Storm.Parent = SoundService
	p1._CleanUp:Add(RunService.Heartbeat:Connect(function() --[[ Line: 44 | Upvalues: Storm (copy), p1 (copy) ]]
		if Storm then
			RefreshSoundGroups(Storm, p1._Active)
		end
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
	p1._CleanUp:Add(Storm)
	Storm:Play()
	p1._Active = true
end
function SetSoundGroup(p1, p2) --[[ SetSoundGroup | Line: 67 | Upvalues: TweenService (copy) ]]
	if p1:GetAttribute("CurrentSoundGroup") == p2.Name then
		return
	end
	p1:SetAttribute("CurrentSoundGroup", p2.Name)
	local v1 = p2:GetAttribute("OriginalVolume")
	if not v1 then
		p2:SetAttribute("OriginalVolume", p2.Volume)
		v1 = p2.Volume
	end
	local v2 = p1:GetAttribute("LastVolume") or 1
	p1:SetAttribute("LastVolume", v1)
	local v3
	if p2.Name == "RainSoundGroup" and v2 < 1 then
		p1.SoundGroup = p2
		v3 = v2 * 0.1
	else
		v3 = v2
	end
	p1.Volume = v3
	p2.Volume = 1
	if v2 == v1 then
		p1.SoundGroup = p2
		return
	end
	if p2.Name == "IndoorRainGroup" or p2.Name == "FloorSoundGroup" then
		v1 = v1 * 0.2
	end
	TweenService:Create(p1, TweenInfo.new(0.5), {
		Volume = v1
	}):Play()
end
function RefreshSoundGroups(p1, p2) --[[ RefreshSoundGroups | Line: 104 | Upvalues: Players (copy), SoundService (copy) ]]
	if Players.LocalPlayer:GetAttribute("Underwater") then
		SetSoundGroup(p1, SoundService.UnderwaterRainGroup)
		return
	end
	if p2 then
		SetSoundGroup(p1, SoundService.RainSoundGroup)
	else
		SetSoundGroup(p1, SoundService.IndoorRainGroup)
	end
end
return t