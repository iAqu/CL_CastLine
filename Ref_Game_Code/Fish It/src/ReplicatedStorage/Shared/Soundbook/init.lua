-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Dump = require(script.Dump)
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Replion = require(ReplicatedStorage.Packages.Replion)
local v1 = Net:RemoteEvent("PlaySound")
local v2 = RunService:IsClient()
RunService:IsServer()
local CosmeticFolder = workspace:WaitForChild("CosmeticFolder")
local t = {
	RE_PlaySound = v1,
	Sounds = {},
	HasSound = function(p1, p2) --[[ HasSound | Line: 46 | Upvalues: Dump (copy) ]]
		return Dump[p2] and true or false
	end
}
function t.RenderAt(p1, p2, p3) --[[ RenderAt | Line: 54 | Upvalues: t (copy), CosmeticFolder (copy) ]]
	local v1 = t.Sounds[p2]
	if v1 then
		local Part = Instance.new("Part")
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanTouch = false
		Part.CanQuery = false
		Part.CastShadow = false
		Part.CFrame = CFrame.new(p3)
		Part.Size = Vector3.new(0.1, 0.1, 0.1)
		Part.Transparency = 1
		Part.Parent = CosmeticFolder
		v1:Play(Part).Destroying:Once(function() --[[ Line: 72 | Upvalues: Part (copy) ]]
			Part:Destroy()
		end)
	end
end
function t.PlaySound(p1, p2, p3, p4, p5) --[[ PlaySound | Line: 77 | Upvalues: Replion (copy), Trove (copy), SoundService (copy) ]]
	local v1 = Replion.Client:GetReplion("Data")
	if v1 then
		v1:Get("Settings")
	end
	local v2 = if p2 then not p2:IsA("BasePart") and p2:FindFirstChildWhichIsA("BasePart") or p2 else p2
	if p2 and not p2:IsA("PVInstance") then
		v2 = p2
	end
	local v3 = if typeof(p3) == "string" then true else false
	local v4 = if typeof(p3) == "table" then true else false
	local v5 = (v3 or v4) and Instance.new("Sound") or p3:Clone()
	if v3 then
		v5.Name = p3
		v5.SoundId = p3
	end
	if v4 then
		for v6, v7 in p3 do
			if v6 ~= "Get" and v6 ~= "Play" then
				v5[v6] = v7
			end
		end
	end
	if p5 then
		for v8, v9 in p5 do
			v5[v8] = v9
		end
	end
	local v10 = p5 and p5.Volume or tbl and tbl.Volume
	if v10 then
		v5.Volume = v10
	end
	local v11 = Trove.new()
	if p2 or p4 then
		if p2 then
			v5.Parent = v2
			if p4 then
				if not v5.Looped then
					v11:Add(v5:GetPropertyChangedSignal("Playing"):Connect(function() --[[ Line: 150 | Upvalues: v5 (copy), v11 (copy) ]]
						if not v5.Playing then
							return
						end
						v11:Clean()
						if not v5.IsLoaded then
							v5.Loaded:Wait()
						end
						v5.Ended:Wait()
						v5:Destroy()
					end))
				end
				v11:Add(v5.Destroying:Connect(function() --[[ Line: 166 | Upvalues: v11 (copy) ]]
					v11:Destroy()
				end))
				v5:Play()
				return v5
			end
		elseif p4 then
			if not v5.Looped then
				v11:Add(v5:GetPropertyChangedSignal("Playing"):Connect(function() --[[ Line: 175 | Upvalues: v5 (copy), v11 (copy) ]]
					if not v5.Playing then
						return
					end
					v11:Clean()
					if not v5.IsLoaded then
						v5.Loaded:Wait()
					end
					v5.Ended:Wait()
					v5:Destroy()
				end))
			end
			v11:Add(v5.Destroying:Connect(function() --[[ Line: 191 | Upvalues: v11 (copy) ]]
				v11:Destroy()
			end))
			v5.Parent = SoundService
			v5:Play()
		end
	else
		if not v5.Looped then
			v11:Add(v5:GetPropertyChangedSignal("Playing"):Connect(function() --[[ Line: 122 | Upvalues: v5 (copy), v11 (copy) ]]
				if not v5.Playing then
					return
				end
				v11:Clean()
				if v5.IsLoaded then
					v5.Ended:Wait()
					v5:Destroy()
					return
				end
				v5.Loaded:Wait()
				v5.Ended:Wait()
				v5:Destroy()
			end))
		end
		v11:Add(v5.Destroying:Connect(function() --[[ Line: 138 | Upvalues: v11 (copy) ]]
			v11:Destroy()
		end))
	end
	return v5
end
local function v3(p1) --[[ DeepCopyTable | Line: 203 | Upvalues: v3 (copy) ]]
	local t = {}
	for v1, v2 in p1 do
		if typeof(v2) == "table" then
			t[v1] = v3(v2)
			continue
		end
		t[v1] = v2
	end
	return t
end
local function CreateSoundFromSound(p1) --[[ CreateSoundFromSound | Line: 215 | Upvalues: Dump (copy), v3 (copy), t (copy) ]]
	local v1 = v3(Dump[p1])
	function v1.Play(p1_2, p2_2, p3_2, p4_2, p5_2) --[[ Play | Line: 220 | Upvalues: t (ref), v1 (copy) ]]
		return t:PlaySound(p2_2, v1, true, p5_2)
	end
	function v1.Get(p1_2, p2_2, p3_2, p4_2, p5_2) --[[ Get | Line: 225 | Upvalues: t (ref), v1 (copy) ]]
		return t:PlaySound(nil, v1, nil, p5_2)
	end
	return v1
end
for v4, v5 in Dump do
	local v6 = v3(Dump[v4])
	function v6.Play(p1_2, p2_2, p3_2, p4_2, p5_2) --[[ Play | Line: 220 | Upvalues: t (copy), v6 (copy) ]]
		return t:PlaySound(p2_2, v6, true, p5_2)
	end
	function v6.Get(p1_2, p2_2, p3_2, p4_2, p5_2) --[[ Get | Line: 225 | Upvalues: t (copy), v6 (copy) ]]
		return t:PlaySound(nil, v6, nil, p5_2)
	end
	t.Sounds[v4] = v6
end
if v2 then
	v1.OnClientEvent:Connect(function(p1, p2) --[[ Line: 240 | Upvalues: t (copy) ]]
		local v1 = t.Sounds[p1]
		if v1 then
			v1:Play(nil, nil, nil, p2)
		else
			print("Failed to get sound data...")
		end
	end)
end
return t