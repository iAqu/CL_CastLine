-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")
require("../types")
local v3 = require("../mod/utility")
local v4 = require("../pkg/Promise")
local v5 = Random.new()
local t = {}
local v6 = nil
local function selectRandomSound(p1) --[[ selectRandomSound | Line: 17 | Upvalues: v1 (copy), CollectionService (copy), v5 (copy) ]]
	local v12 = v1.get(p1, "SoundPoolTag", "")
	if v12 == "" then
		return p1
	end
	local t = {}
	local t2 = {}
	local sum = 0
	for v2, v3 in CollectionService:GetTagged(v12) do
		if v3:IsA("Sound") then
			table.insert(t, v3)
			local v4 = v1.get(v3, "SoundPoolWeight", 1)
			table.insert(t2, v4)
			sum = sum + v4
		end
	end
	if #t == 0 then
		return p1
	end
	if sum > 0 then
		local v52 = v5:NextNumber() * sum
		local sum_2 = 0
		for v6, v7 in t2 do
			sum_2 = sum_2 + v7
			if v52 <= sum_2 then
				return t[v6]
			end
		end
	end
	return t[v5:NextInteger(1, #t)]
end
local function createSoundClone(p1, p2, p3) --[[ createSoundClone | Line: 64 | Upvalues: v3 (copy), v6 (ref) ]]
	local v1 = p2:Clone()
	for v2, v32 in v1:GetTags() do
		v1:RemoveTag(v32)
	end
	local v4 = p1:FindFirstAncestorWhichIsA("BasePart")
	local v5 = nil
	if v3.PLUGIN_CONTEXT then
		if v4 then
			local SoundEmitter = Instance.new("Part")
			SoundEmitter.Name = "SoundEmitter"
			SoundEmitter.Anchored = true
			SoundEmitter.CanCollide = false
			SoundEmitter.CanQuery = false
			SoundEmitter.CanTouch = false
			SoundEmitter.Transparency = 1
			SoundEmitter.Size = Vector3.new(1, 1, 1)
			SoundEmitter.CFrame = v4.CFrame
			SoundEmitter.Parent = v6
			v1.Parent = SoundEmitter
			table.insert(p3, SoundEmitter)
			v5 = SoundEmitter
		else
			v1.Parent = v6
			table.insert(p3, v1)
		end
	else
		if v4 then
			v1.Parent = v4
		else
			v1.Parent = workspace.Terrain
		end
		table.insert(p3, v1)
	end
	return v1, v5
end
local function playSingleSound(p1, p2, p3, p4, p5, p6) --[[ playSingleSound | Line: 109 | Upvalues: v1 (copy), v2 (copy), v3 (copy), RunService (copy) ]]
	local PlaybackSpeed = p3.PlaybackSpeed
	local v12 = v1.get(p2, "Volume_End", p3.Volume)
	local v22 = v1.get(p2, "Volume_Start", p3.Volume)
	p3.Volume = v22
	if v22 == v12 then
		p3.Volume = v22
	else
		local v32 = v1.get(p2, "Volume_Duration", p3.TimeLength)
		local v4 = v1.get(p2, "Volume_Curve", v3.default_bezier)
		local function f5(p1, p2) --[[ Line: 129 | Upvalues: p3 (copy), v3 (ref), v22 (copy), v12 (copy), PlaybackSpeed (ref) ]]
			p3.Volume = v3.lerp(v22, v12, p1)
			return p2 * PlaybackSpeed
		end
		table.insert(p5, v2.fromParams(v4, v32, f5))
	end
	local v6 = v1.get(p2, "Speed_End", p3.PlaybackSpeed)
	local v7 = v1.get(p2, "Speed_Start", p3.PlaybackSpeed)
	local v8 = v7
	local v9 = nil
	if v7 == v6 then
		p3.PlaybackSpeed = v7
	else
		local v10 = v1.get(p2, "Speed_Duration", p3.TimeLength)
		v9 = v2.fromParams(v1.get(p2, "Speed_Curve", v3.default_bezier), v10, function(p1, p2) --[[ Line: 151 | Upvalues: v8 (ref), v3 (ref), v7 (copy), v6 (copy), p3 (copy) ]]
			v8 = v3.lerp(v7, v6, p1)
			p3.PlaybackSpeed = v8
			return p2
		end)
		table.insert(p5, v9)
	end
	local v11 = v1.get(p2, "RollOff_End", p3.RollOffMinDistance)
	local v122 = v1.get(p2, "RollOff_Start", p3.RollOffMinDistance)
	if v122 ~= v11 then
		local v13 = v1.get(p2, "RollOff_Duration", p3.TimeLength)
		local v14 = v1.get(p2, "RollOff_Curve", v3.default_bezier)
		local function f15(p1, p2) --[[ Line: 174 | Upvalues: p3 (copy), v3 (ref), v122 (copy), v11 (copy), v8 (ref) ]]
			p3.RollOffMinDistance = v3.lerp(v122, v11, p1)
			return p2 * v8
		end
		table.insert(p5, v2.fromParams(v14, v13, f15, v9))
	end
	if p3.PlayOnRemove and not v3.PLUGIN_CONTEXT then
		p3:Destroy()
	else
		p3:Play()
	end
	if p4 then
		local v16 = p1:FindFirstAncestorWhichIsA("BasePart")
		if v16 then
			table.insert(p5, RunService.Heartbeat:Connect(function() --[[ Line: 195 | Upvalues: p4 (copy), v16 (copy) ]]
				if not p4.Parent then
					return
				end
				p4.CFrame = v16.CFrame
			end))
		end
	end
	if p6 > 0 then
		task.wait(p6)
		p3:Stop()
	else
		v2.timer(p3.TimeLength, function(p1, p2) --[[ Line: 208 | Upvalues: p3 (copy), v9 (ref) ]]
			if p3.PlaybackSpeed > 0 or p2 > 0 and (v9 and v9.Connected) then
				return p1 * p3.PlaybackSpeed
			else
				return nil
			end
		end, v9, p5)
	end
	return v9
end
function t.init() --[[ init | Line: 218 | Upvalues: v3 (copy), v6 (ref) ]]
	if not v3.PLUGIN_CONTEXT then
		return
	end
	local v1 = script:FindFirstAncestorOfClass("Plugin")
	if not v1 then
		return
	end
	v6 = v1:CreateDockWidgetPluginGui("VFXForgeSoundPlayer", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, true, 200, 100, 100, 50))
	if not v6 then
		return
	end
	v6.Name = "VFXForgeSoundPlayer"
end
function t.deinit() --[[ deinit | Line: 239 | Upvalues: v6 (ref) ]]
	if not v6 then
		return
	end
	v6:Destroy()
	v6 = nil
end
function t.emit(p1, p2) --[[ emit | Line: 246 | Upvalues: v1 (copy), selectRandomSound (copy), v4 (copy), createSoundClone (copy), playSingleSound (copy), v5 (copy) ]]
	if p1.Playing then
		p1:Stop()
	end
	local v12 = v1.get(p1, "SoundPoolIsSource", false)
	local v2 = v1.get(p1, "SoundPoolInheritAttributes", false)
	if v2 then
		p1 = not v12 and selectRandomSound(p1) or p1
	end
	local v42 = v1.get(p1, "EmitDelay", 0)
	local v52 = v1.get(p1, "EmitDuration", 0)
	local v6 = v1.get(p1, "EmitCount", 1)
	local v7 = v1.getRange(p1, "EmitInterval", NumberRange.new(0, 0))
	local v8 = v1.get(p1, "RepeatCount", 1)
	local v9 = v1.getRange(p1, "RepeatInterval", NumberRange.new(0, 0))
	task.wait(v42)
	local t = {}
	for i = 1, v6 do
		local v10 = v2 and p1 or (not v12 and selectRandomSound(p1) or p1)
		if v10 then
			local v11 = if v2 and v10 ~= p1 then v10 else p1
			for j = 1, v8 do
				local function f13(p12) --[[ Line: 283 | Upvalues: createSoundClone (ref), p1 (ref), v10 (copy), p2 (copy), playSingleSound (ref), v11 (copy), v52 (copy) ]]
					local v1, v2 = createSoundClone(p1, v10, p2)
					playSingleSound(p1, v11, v1, v2, p2, v52)
					if v2 then
						v2:Destroy()
					else
						v1:Destroy()
					end
					p12()
				end
				table.insert(t, v4.new(f13))
				if j < v8 and v9.Max > 0 then
					task.wait(v5:NextNumber(v9.Min, v9.Max))
				end
			end
			if i < v6 and v7.Max > 0 then
				task.wait(v5:NextNumber(v7.Min, v7.Max))
			end
		end
	end
	v4.all(t):await()
end
return t