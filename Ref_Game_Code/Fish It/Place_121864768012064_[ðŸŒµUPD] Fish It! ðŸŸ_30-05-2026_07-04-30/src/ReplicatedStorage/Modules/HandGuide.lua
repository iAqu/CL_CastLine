-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local t = {
	Template = nil,
	Radius = 12,
	HeightOffset = 0,
	HalfSweepTime = 1,
	WaitAfterTap = 0.15,
	WaitBetweenSweeps = 0.2,
	TapDepth = 0.8,
	TapTime = 0.08,
	TapPause = 0.06,
	FirstStartAngle = -90,
	FirstEndAngle = 90,
	PivotCFrame = CFrame.new(0, 5, 0),
	HandTilt = CFrame.Angles(-0.7853981633974483, 0, 0),
	Parent = workspace
}
local t2 = {}
t2.__index = t2
local function resolveConfig(p1) --[[ resolveConfig | Line: 44 | Upvalues: t (copy) ]]
	local v1 = table.clone(t)
	if p1 then
		for v2, v3 in p1 do
			v1[v2] = v3
		end
	end
	return v1
end
local function createHand(p1, p2) --[[ createHand | Line: 56 ]]
	local v1 = p1:Clone()
	v1.Parent = p2
	return v1
end
local function setWorldCFrame(p1, p2) --[[ setWorldCFrame | Line: 63 ]]
	local _Instance = p1._Instance
	if _Instance then
		_Instance.CFrame = p2
	end
end
local function getArcCFrame(p1, p2) --[[ getArcCFrame | Line: 72 ]]
	local _Config = p1._Config
	local v1 = math.rad(p2)
	local Position = (_Config.PivotCFrame * (CFrame.Angles(0, v1, 0) * CFrame.new(_Config.Radius, _Config.HeightOffset, 0))).Position
	local Position_2 = _Config.PivotCFrame.Position
	return CFrame.lookAt(Position, (Vector3.new(Position_2.X, Position.Y, Position_2.Z))) * _Config.HandTilt
end
local function playSweep(p1, p2, p3, p4) --[[ playSweep | Line: 84 | Upvalues: getArcCFrame (copy), RunService (copy) ]]
	local v1 = os.clock()
	while p1._Running and not p1._Destroyed do
		local v3 = math.clamp((os.clock() - v1) / p4, 0, 1)
		local v4 = getArcCFrame(p1, p2 + (p3 - p2) * v3)
		local _Instance = p1._Instance
		if _Instance then
			_Instance.CFrame = v4
		end
		if v3 >= 1 then
			break
		end
		RunService.RenderStepped:Wait()
	end
end
local function tapOnce(p1) --[[ tapOnce | Line: 101 | Upvalues: TweenService (copy) ]]
	local _Instance = p1._Instance
	local Template = p1._Config.Template
	if not (_Instance and Template) then
		return
	end
	local _Config = p1._Config
	local v1 = _Instance.CFrame
	local v2 = v1 * CFrame.new(0, -_Config.TapDepth, 0)
	local v3 = TweenService:Create(_Instance, TweenInfo.new(_Config.TapTime), {
		CFrame = v2
	})
	v3:Play()
	v3.Completed:Wait()
	local Hang = Template.Hang
	local HandGuideVFX = script.HandGuideVFX
	local v4 = Hang.WaterSplash:Clone()
	local v5 = HandGuideVFX:Clone()
	local _, v6, _2 = v2:ToOrientation()
	local Part = Instance.new("Part")
	Part.Transparency = 1
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanQuery = false
	Part.AudioCanCollide = false
	Part.Size = Vector3.new()
	Part.CFrame = CFrame.new(v2.Position) * CFrame.new(if v6 <= 0 then -0.5 else 0.5, -Hang.Size.Z + 0.1, if v6 <= 0 then -5.25 else 5.25)
	Part.Parent = workspace
	v4.Parent = Part
	v5.Parent = Part
	for v9, v10 in v5:GetChildren() do
		v10:Emit(3)
	end
	v4:Play()
	local v11 = TweenService:Create(_Instance, TweenInfo.new(_Config.TapTime), {
		CFrame = v1
	})
	v11:Play()
	v11.Completed:Wait()
	task.delay(3, function() --[[ Line: 148 | Upvalues: Part (copy) ]]
		Part:Destroy()
	end)
end
local function doubleTap(p1) --[[ doubleTap | Line: 153 | Upvalues: tapOnce (copy) ]]
	tapOnce(p1)
	if p1._Running then
		task.wait(p1._Config.TapPause)
		tapOnce(p1)
	end
end
local function run(p1) --[[ run | Line: 165 | Upvalues: playSweep (copy), tapOnce (copy) ]]
	local _Config = p1._Config
	while p1._Running and not p1._Destroyed do
		playSweep(p1, _Config.FirstStartAngle, _Config.FirstEndAngle, _Config.HalfSweepTime)
		if not p1._Running then
			break
		end
		tapOnce(p1)
		if p1._Running then
			task.wait(p1._Config.TapPause)
			tapOnce(p1)
		end
		task.wait(_Config.WaitAfterTap)
		playSweep(p1, _Config.FirstEndAngle, _Config.FirstEndAngle + 180, _Config.HalfSweepTime)
		if not p1._Running then
			break
		end
		tapOnce(p1)
		if p1._Running then
			task.wait(p1._Config.TapPause)
			tapOnce(p1)
		end
		task.wait(_Config.WaitBetweenSweeps)
	end
end
function t2.new(p1) --[[ new | Line: 191 | Upvalues: t2 (copy), t (copy) ]]
	local v2 = setmetatable({}, t2)
	local v3 = table.clone(t)
	if p1 then
		for v4, v5 in p1 do
			v3[v4] = v5
		end
	end
	v2._Config = v3
	v2._Instance = nil
	v2._Running = false
	v2._Destroyed = false
	return v2
end
function t2.Start(p1) --[[ Start | Line: 202 | Upvalues: getArcCFrame (copy), run (copy) ]]
	if p1._Running or (p1._Destroyed or not p1._Config.Template) then
		return
	end
	local v2 = p1._Config.Template:Clone()
	v2.Parent = p1._Config.Parent
	p1._Instance = v2
	p1._Running = true
	local v3 = getArcCFrame(p1, p1._Config.FirstStartAngle)
	local _Instance = p1._Instance
	if not _Instance then
		task.spawn(run, p1)
		return
	end
	_Instance.CFrame = v3
	task.spawn(run, p1)
end
function t2.Stop(p1) --[[ Stop | Line: 216 ]]
	p1._Running = false
	p1._Destroyed = true
	if not p1._Instance then
		return
	end
	p1._Instance:Destroy()
	p1._Instance = nil
end
function t2.IsRunning(p1) --[[ IsRunning | Line: 228 ]]
	return p1._Running and not p1._Destroyed
end
function t2.SetPivotCFrame(p1, p2) --[[ SetPivotCFrame | Line: 233 ]]
	p1._Config.PivotCFrame = p2
end
function t2.SetRadius(p1, p2) --[[ SetRadius | Line: 238 ]]
	p1._Config.Radius = p2
end
function t2.SetHeightOffset(p1, p2) --[[ SetHeightOffset | Line: 243 ]]
	p1._Config.HeightOffset = p2
end
return t2