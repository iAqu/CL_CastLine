-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local abs = math.abs
local clamp = math.clamp
local exp = math.exp
local rad = math.rad
local sign = math.sign
local sqrt = math.sqrt
local tan = math.tan
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameSettings = UserSettings().GameSettings
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end
local v1 = require(game.ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data")
if not v1 or v1.Destroyed then
	return
end
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local v2 = LocalPlayer:GetAttribute("Dev") or LocalPlayer:GetAttribute("ContentCreator") or LocalPlayer:GetAttribute("SeniorStaff") or UserPriority:IsValidTestSession()
if not v2 then
	print("[Client] No freecam access!")
	return
end
local v3 = nil
local v4 = nil
local CurrentCamera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() --[[ Line: 85 | Upvalues: Workspace (copy), CurrentCamera (ref) ]]
	local CurrentCamera_2 = Workspace.CurrentCamera
	if not CurrentCamera_2 then
		return
	end
	CurrentCamera = CurrentCamera_2
end)
local v5 = nil
local v6 = nil
local v7 = nil
local v8, v9 = pcall(function() --[[ Line: 98 ]]
	return UserSettings():IsUserFeatureEnabled("UserExitFreecamBreaksWithShiftlock")
end)
local v10 = v8 and v9
local v11, v12 = pcall(function() --[[ Line: 106 ]]
	return UserSettings():IsUserFeatureEnabled("UserShowGuiHideToggles")
end)
local v13 = v11 and v12
local v14, v15 = pcall(function() --[[ Line: 114 ]]
	return UserSettings():IsUserFeatureEnabled("UserFixFreecamDeltaTimeCalculation")
end)
local v16 = v14 and v15
local v17, v18 = pcall(function() --[[ Line: 122 ]]
	return UserSettings():IsUserFeatureEnabled("UserFixFreecamGuiChangeVisibility2")
end)
local v19 = v17 and v18
local v20, v21 = pcall(function() --[[ Line: 130 ]]
	return UserSettings():IsUserFeatureEnabled("UserFreecamControlSpeed")
end)
local v22 = v20 and v21
local v23, v24 = pcall(function() --[[ Line: 138 ]]
	return UserSettings():IsUserFeatureEnabled("UserFreecamTiltControl")
end)
local v25 = v23 and v24
local v26, v27 = pcall(function() --[[ Line: 146 ]]
	return UserSettings():IsUserFeatureEnabled("UserFreecamSmoothnessControl")
end)
local v28 = v26 and v27
local v29, v30 = pcall(function() --[[ Line: 154 ]]
	return UserSettings():IsUserFeatureEnabled("UserFreecamGuiDestabilization")
end)
local v31 = v29 and v30
local v32, v33 = pcall(function() --[[ Line: 162 ]]
	return UserSettings():IsUserFeatureEnabled("UserFreecamDepthOfFieldEffect3")
end)
local v34 = v32 and v33
local v35, v36 = pcall(function() --[[ Line: 170 ]]
	return UserSettings():IsUserFeatureEnabled("UserFreecamPlayerLock2")
end)
local v37 = v35 and v36
local v38, v39 = pcall(function() --[[ Line: 178 ]]
	return UserSettings():IsUserFeatureEnabled("UserFreecamPlayerLockResetHeight")
end)
local v40 = v38 and v39
local v41, v42 = pcall(function() --[[ Line: 186 ]]
	return UserSettings():IsUserFeatureEnabled("UserFreecamCustomGui")
end)
local v43 = v41 and v42
local Low = Enum.ContextActionPriority.Low.Value
local High = Enum.ContextActionPriority.High.Value
local t = { Enum.KeyCode.LeftShift, Enum.KeyCode.P }
local t2 = {
	[Enum.KeyCode.Z] = true,
	[Enum.KeyCode.C] = true
}
local t3 = {
	[Enum.KeyCode.ButtonL1] = true,
	[Enum.KeyCode.ButtonR1] = true
}
local t4 = {
	[Enum.KeyCode.BackSlash] = true
}
local t5 = {
	[Enum.KeyCode.Slash] = true
}
local t6 = {
	[Enum.KeyCode.R] = true,
	[Enum.KeyCode.T] = true
}
local t7 = {
	[Enum.KeyCode.G] = true
}
local t8 = {
	[Enum.KeyCode.X] = true
}
local t9 = {
	[Enum.KeyCode.L] = true
}
local v44 = Vector2.new(0.75, 1) * 8
local v45 = 1.5
local v46 = 1
local v47 = 4
local v48 = 1
local t10 = {}
local v49 = 0
local t11 = {}
local v50 = nil
local v51 = nil
local v52 = nil
local v53 = nil
local v54 = nil
local v55 = false
local v56 = 20
local v57 = 0
local t12 = {}
local v58 = 1
local v59 = nil
local v60 = false
local v61 = false
local t13 = {}
t13.__index = t13
function t13.new(p1, p2) --[[ new | Line: 285 | Upvalues: t13 (copy) ]]
	local v2 = setmetatable({}, t13)
	v2.f = p1
	v2.p = p2
	v2.v = p2 * 0
	return v2
end
function t13.Update(p1, p2, p3) --[[ Update | Line: 293 | Upvalues: exp (copy) ]]
	local v1 = p1.f * 2 * math.pi
	local v = p1.v
	local v2 = p3 - p1.p
	local v3 = exp(-v1 * p2)
	local v4 = p3 + (v * p2 - v2 * (v1 * p2 + 1)) * v3
	p1.p = v4
	p1.v = (v1 * p2 * (v2 * v1 - v) + v) * v3
	return v4
end
function t13.SetFreq(p1, p2) --[[ SetFreq | Line: 310 ]]
	p1.f = p2
end
function t13.Reset(p1, p2) --[[ Reset | Line: 314 ]]
	p1.p = p2
	p1.v = p2 * 0
end
local v62 = Vector3.new()
local v63 = if v25 then Vector3.new() else Vector2.new()
local v64 = 0
local v65 = t13.new(v45, (Vector3.new()))
local v66 = t13.new(v46, Vector2.new())
local v67 = t13.new(v47, 0)
local v68 = t13.new(v48, 0)
local t14 = {}
local function fCurve(p1) --[[ fCurve | Line: 343 | Upvalues: exp (copy) ]]
	return (exp(2 * p1) - 1) / (math.exp(2) - 1)
end
local function fDeadzone(p1) --[[ fDeadzone | Line: 347 | Upvalues: exp (copy) ]]
	return (exp(2 * ((p1 - 0.15) / 0.85)) - 1) / (math.exp(2) - 1)
end
local function thumbstickCurve(p1) --[[ thumbstickCurve | Line: 351 | Upvalues: sign (copy), abs (copy), exp (copy), clamp (copy) ]]
	return sign(p1) * clamp((exp(2 * ((abs(p1) - 0.15) / 0.85)) - 1) / (math.exp(2) - 1), 0, 1)
end
local t15 = {
	ButtonX = 0,
	ButtonY = 0,
	DPadDown = 0,
	DPadUp = 0,
	DPadLeft = 0,
	DPadRight = 0,
	ButtonL2 = 0,
	ButtonR2 = 0,
	ButtonL1 = 0,
	ButtonR1 = 0,
	Thumbstick1 = Vector2.new(),
	Thumbstick2 = Vector2.new()
}
local t16 = {
	W = 0,
	A = 0,
	S = 0,
	D = 0,
	E = 0,
	Q = 0,
	U = 0,
	H = 0,
	J = 0,
	K = 0,
	I = 0,
	Y = 0,
	Up = 0,
	Down = 0,
	Left = 0,
	Right = 0,
	LeftShift = 0,
	RightShift = 0,
	Z = 0,
	C = 0,
	Comma = 0,
	Period = 0,
	LeftBracket = 0,
	RightBracket = 0,
	Semicolon = 0,
	Quote = 0,
	V = 0,
	B = 0,
	N = 0,
	M = 0,
	BackSlash = 0,
	Minus = 0,
	Equals = 0,
	Slash = 0,
	R = 0,
	T = 0,
	G = 0,
	X = 0,
	L = 0
}
local t17 = {
	MouseWheel = 0,
	Delta = Vector2.new()
}
local v69 = Vector2.new(1, 1) * 0.04908738521234052
local v70 = v69 / 60
local v71 = Vector2.new(1, 1) * 0.39269908169872414
local t18 = {
	FarIntensity = {
		ADJ = 0.1,
		MIN = 0,
		MAX = 1
	},
	NearIntensity = {
		ADJ = 0.1,
		MIN = 0,
		MAX = 1
	},
	FocusDistance = {
		ADJ = 20,
		MIN = 0,
		MAX = 200
	},
	FocusRadius = {
		ADJ = 5,
		MIN = 0,
		MAX = 50
	}
}
local v72 = 1
local v73 = 1
local v74 = 1
function t14.Vel(p1) --[[ Vel | Line: 466 | Upvalues: v22 (ref), v72 (ref), t16 (copy), t15 (copy), clamp (copy), thumbstickCurve (ref), UserInputService (copy) ]]
	v72 = if v22 then clamp(v72 + p1 * (t16.Up - t16.Down + t15.DPadUp - t15.DPadDown) * 0.75, 0.01, 4) else clamp(v72 + p1 * (t16.Up - t16.Down) * 0.75, 0.01, 4)
	local v5 = Vector3.new(thumbstickCurve(t15.Thumbstick1.X), thumbstickCurve(t15.ButtonR2) - thumbstickCurve(t15.ButtonL2), thumbstickCurve(-t15.Thumbstick1.Y)) * Vector3.new(1, 1, 1)
	local v9 = Vector3.new(t16.D - t16.A + t16.K - t16.H, t16.E - t16.Q + t16.I - t16.Y, t16.S - t16.W + t16.J - t16.U) * Vector3.new(1, 1, 1)
	return (v5 + v9) * (v72 * (if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then 0.25 else 1))
end
function t14.Pan(p1) --[[ Pan | Line: 489 | Upvalues: thumbstickCurve (ref), t15 (copy), v71 (copy), t17 (copy), v69 (copy), v16 (ref), v70 (copy) ]]
	local v1 = Vector2.new(thumbstickCurve(t15.Thumbstick2.Y), thumbstickCurve(-t15.Thumbstick2.X)) * v71
	local v2 = t17.Delta * v69
	if v16 and p1 > 0 then
		v2 = t17.Delta / p1 * v70
	end
	t17.Delta = Vector2.new()
	return v1 + v2
end
function t14.Fov(p1) --[[ Fov | Line: 504 | Upvalues: v22 (ref), v74 (ref), t16 (copy), t15 (copy), clamp (copy), t17 (copy), v16 (ref) ]]
	if v22 then
		v74 = clamp(v74 + p1 * (t16.Right - t16.Left + t15.DPadRight - t15.DPadLeft) * 0.75, 0.01, 4)
	end
	local v1 = (t15.ButtonX - t15.ButtonY) * 0.25
	local v2 = t17.MouseWheel * 1
	if v16 and p1 > 0 then
		v2 = t17.MouseWheel / p1 * 1 / 60
	end
	t17.MouseWheel = 0
	if v22 then
		return (v1 + v2) * v74
	else
		return v1 + v2
	end
end
function t14.Roll(p1) --[[ Roll | Line: 523 | Upvalues: v73 (ref), t16 (copy), clamp (copy), t15 (copy) ]]
	v73 = clamp(v73 + p1 * (t16.Period - t16.Comma) * 0.75, 0.01, 4)
	return ((t15.ButtonR1 - t15.ButtonL1) * 1 + (t16.C - t16.Z) * 1) * v73
end
function t14.SpringControl(p1) --[[ SpringControl | Line: 532 | Upvalues: v34 (ref), UserInputService (copy), v45 (ref), t16 (copy), clamp (copy), v65 (copy), v46 (ref), v66 (copy), v47 (ref), v67 (copy), v48 (ref), v68 (copy) ]]
	if v34 then
		local v1 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		if v1 or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
			return
		end
	end
	v45 = clamp(v45 + p1 * (t16.RightBracket - t16.LeftBracket) * 0.75, 0.01, 10)
	v65:SetFreq(v45)
	v46 = clamp(v46 + p1 * (t16.Quote - t16.Semicolon) * 0.75, 0.01, 10)
	v66:SetFreq(v46)
	v47 = clamp(v47 + p1 * (t16.B - t16.V) * 0.75, 0.01, 10)
	v67:SetFreq(v47)
	v48 = clamp(v48 + p1 * (t16.M - t16.N) * 0.75, 0.01, 10)
	v68:SetFreq(v48)
end
function t14.DoF(p1) --[[ DoF | Line: 555 | Upvalues: UserInputService (copy), v5 (ref), t16 (copy), t18 (copy), clamp (copy) ]]
	local v1 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	local v2 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
	if v1 then
		v5.FarIntensity = clamp(v5.FarIntensity + p1 * (t16.RightBracket - t16.LeftBracket) * t18.FarIntensity.ADJ, t18.FarIntensity.MIN, t18.FarIntensity.MAX)
		v5.InFocusRadius = clamp(v5.InFocusRadius + p1 * (t16.Equals - t16.Minus) * t18.FocusRadius.ADJ, t18.FocusRadius.MIN, t18.FocusRadius.MAX)
		return
	end
	if v2 then
		v5.NearIntensity = clamp(v5.NearIntensity + p1 * (t16.RightBracket - t16.LeftBracket) * t18.NearIntensity.ADJ, t18.NearIntensity.MIN, t18.NearIntensity.MAX)
	else
		v5.FocusDistance = clamp(v5.FocusDistance + p1 * (t16.Equals - t16.Minus) * t18.FocusDistance.ADJ, t18.FocusDistance.MIN, t18.FocusDistance.MAX)
	end
end
local function resetKeys(p1, p2) --[[ resetKeys | Line: 586 ]]
	for k, v in pairs(p1) do
		if p2[k.Name] then
			p2[k.Name] = 0
		end
	end
end
local function handleDoubleTapReset(p1) --[[ handleDoubleTapReset | Line: 594 | Upvalues: t10 (copy), v49 (ref), v63 (ref), v68 (copy), v34 (ref), t3 (copy), t15 (copy), t2 (copy), t16 (copy) ]]
	local v1 = os.clock()
	local v2 = t10[p1]
	if v2 and ((v2 and v1 - v2 or -1) <= 0.25 and v1 - v49 >= 0.1) then
		v63 = Vector3.new(v63.x, v63.y, 0)
		v68:Reset(0)
		if v34 then
			local v5 = t15
			for k, v in pairs(t3) do
				if v5[k.Name] then
					v5[k.Name] = 0
				end
			end
			local v7 = t16
			for k, v in pairs(t2) do
				if v7[k.Name] then
					v7[k.Name] = 0
				end
			end
		else
			t15.ButtonL1 = 0
			t15.ButtonR1 = 0
			t16.C = 0
			t16.Z = 0
		end
		v49 = v1
	end
	t10[p1] = v1
end
local function findPlayerLockRootPart(p1) --[[ findPlayerLockRootPart | Line: 619 | Upvalues: t12 (ref), v58 (ref), v55 (ref) ]]
	if not t12 or #t12 < 1 then
		return nil
	end
	for i = 1, #t12 do
		v58 = (v58 - 1 + p1) % #t12 + 1
		local v1 = t12[v58]
		local v2 = if v1 then v1.Character else v1
		if v2 then
			local Humanoid = v2:FindFirstChildOfClass("Humanoid")
			if Humanoid and Humanoid.RootPart then
				return Humanoid.RootPart
			end
		end
		if p1 == 0 then
			p1 = 1
		end
	end
	v55 = false
	return nil
end
local function Keypress(p1, p2, p3) --[[ Keypress | Line: 646 | Upvalues: t16 (copy), v25 (ref), t2 (copy), handleDoubleTapReset (copy), v34 (ref), t4 (copy), v5 (ref), t11 (ref), CurrentCamera (ref), Lighting (copy), v51 (ref), v52 (ref), v37 (ref), t5 (copy), v55 (ref), v56 (ref), v40 (ref), v57 (ref), v59 (ref), findPlayerLockRootPart (copy), t6 (copy), t12 (ref), v43 (ref), t7 (copy), v4 (ref), t8 (copy), v60 (ref), v7 (ref), t9 (copy), v61 (ref), StarterGui (copy) ]]
	t16[p3.KeyCode.Name] = if p2 == Enum.UserInputState.Begin then 1 else 0
	if v25 and (t2[p3.KeyCode] and p3.UserInputState == Enum.UserInputState.Begin) then
		handleDoubleTapReset(p3.KeyCode)
	end
	if v34 and (t4[p3.KeyCode] and p3.UserInputState == Enum.UserInputState.Begin) then
		if v5.Enabled then
			for i, v in ipairs(t11) do
				if v.Parent then
					v.Enabled = true
				end
			end
			if v51 then
				v51:Disconnect()
				v51 = nil
			end
			if v52 then
				v52:Disconnect()
				v52 = nil
			end
			t11 = {}
		else
			t11 = {}
			for i, v in ipairs(CurrentCamera:GetChildren()) do
				if v:IsA("DepthOfFieldEffect") and v.Enabled then
					t11[#t11 + 1] = v
					v.Enabled = false
				end
			end
			for i, v in ipairs(Lighting:GetChildren()) do
				if v:IsA("DepthOfFieldEffect") and v.Enabled then
					t11[#t11 + 1] = v
					v.Enabled = false
				end
			end
			v51 = CurrentCamera.ChildAdded:Connect(function(p1) --[[ Line: 672 | Upvalues: t11 (ref) ]]
				if not (p1:IsA("DepthOfFieldEffect") and p1.Enabled) then
					return
				end
				t11[#t11 + 1] = p1
				p1.Enabled = false
			end)
			v52 = Lighting.ChildAdded:Connect(function(p1) --[[ Line: 678 | Upvalues: t11 (ref) ]]
				if not (p1:IsA("DepthOfFieldEffect") and p1.Enabled) then
					return
				end
				t11[#t11 + 1] = p1
				p1.Enabled = false
			end)
		end
		v5.Enabled = not v5.Enabled
		local v53 = t16
		for k, v in pairs(t4) do
			if v53[k.Name] then
				v53[k.Name] = 0
			end
		end
	end
	if v37 then
		if t5[p3.KeyCode] and p3.UserInputState == Enum.UserInputState.Begin then
			v55 = not v55
			if v55 then
				v56 = 20
				if v40 then
					v57 = 0
				end
				v59 = findPlayerLockRootPart(0)
			end
			local v72 = t16
			for k, v in pairs(t5) do
				if v72[k.Name] then
					v72[k.Name] = 0
				end
			end
		end
		if t6[p3.KeyCode] and p3.UserInputState == Enum.UserInputState.Begin then
			if v55 and #t12 > 0 then
				v59 = findPlayerLockRootPart(t16.T - t16.R)
			end
			local v9 = t16
			for k, v in pairs(t6) do
				if v9[k.Name] then
					v9[k.Name] = 0
				end
			end
		end
	end
	if not v43 then
		return Enum.ContextActionResult.Sink
	end
	if t7[p3.keyCode] and p3.UserInputState == Enum.UserInputState.Begin then
		if v4 and v4.Parent then
			v4.Enabled = not v4.Enabled
		end
		local v11 = t16
		for k, v in pairs(t7) do
			if v11[k.Name] then
				v11[k.Name] = 0
			end
		end
	end
	if t8[p3.keyCode] and p3.UserInputState == Enum.UserInputState.Begin then
		v60 = not v60
		if v7 then
			for k, v in pairs((v7.getScreenGuis())) do
				if v.Parent and v ~= v4 then
					v.Enabled = v60
				end
			end
		end
		local v14 = t16
		for k, v in pairs(t8) do
			if v14[k.Name] then
				v14[k.Name] = 0
			end
		end
	end
	if not t9[p3.keyCode] or p3.UserInputState ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Sink
	end
	v61 = not v61
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, v61)
	local v16 = t16
	for k, v in pairs(t9) do
		if v16[k.Name] then
			v16[k.Name] = 0
		end
	end
	return Enum.ContextActionResult.Sink
end
local function GpButton(p1, p2, p3) --[[ GpButton | Line: 759 | Upvalues: t15 (copy), v25 (ref), t3 (copy), handleDoubleTapReset (copy) ]]
	t15[p3.KeyCode.Name] = if p2 == Enum.UserInputState.Begin then 1 else 0
	if not v25 or (not t3[p3.KeyCode] or p3.UserInputState ~= Enum.UserInputState.Begin) then
		return Enum.ContextActionResult.Sink
	end
	handleDoubleTapReset(p3.KeyCode)
	return Enum.ContextActionResult.Sink
end
local function MousePan(p1, p2, p3) --[[ MousePan | Line: 771 | Upvalues: t17 (copy) ]]
	local Delta = p3.Delta
	t17.Delta = Vector2.new(-Delta.y, -Delta.x)
	return Enum.ContextActionResult.Sink
end
local function Thumb(p1, p2, p3) --[[ Thumb | Line: 777 | Upvalues: t15 (copy) ]]
	t15[p3.KeyCode.Name] = p3.Position
	return Enum.ContextActionResult.Sink
end
local function Trigger(p1, p2, p3) --[[ Trigger | Line: 782 | Upvalues: t15 (copy) ]]
	t15[p3.KeyCode.Name] = p3.Position.z
	return Enum.ContextActionResult.Sink
end
local function MouseWheel(p1, p2, p3) --[[ MouseWheel | Line: 787 | Upvalues: t17 (copy) ]]
	t17[p3.UserInputType.Name] = -p3.Position.z
	return Enum.ContextActionResult.Sink
end
local function Zero(p1) --[[ Zero | Line: 792 ]]
	for k, v in pairs(p1) do
		p1[k] = v * 0
	end
end
function t14.StartCapture() --[[ StartCapture | Line: 798 | Upvalues: v22 (ref), ContextActionService (copy), Keypress (copy), High (copy), GpButton (copy), v25 (ref), v28 (ref), v34 (ref), v37 (ref), v43 (ref), MousePan (copy), MouseWheel (copy), Trigger (copy), Thumb (copy) ]]
	if v22 then
		ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, High, Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y)
		ContextActionService:BindActionAtPriority("FreecamKeyboardControlSpeed", Keypress, false, High, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right)
		ContextActionService:BindActionAtPriority("FreecamGamepadControlSpeed", GpButton, false, High, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight)
	else
		ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, High, Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y, Enum.KeyCode.Up, Enum.KeyCode.Down)
	end
	if v25 then
		ContextActionService:BindActionAtPriority("FreecamKeyboardTiltControl", Keypress, false, High, Enum.KeyCode.Z, Enum.KeyCode.C)
		ContextActionService:BindActionAtPriority("FreecamGamepadTiltControl", GpButton, false, High, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
		ContextActionService:BindActionAtPriority("FreecamKeyboardTiltControlSpeed", Keypress, false, High, Enum.KeyCode.Comma, Enum.KeyCode.Period)
		if v28 then
			ContextActionService:BindActionAtPriority("FreecamKeyboardSmoothnessControl", Keypress, false, High, Enum.KeyCode.LeftBracket, Enum.KeyCode.RightBracket, Enum.KeyCode.Semicolon, Enum.KeyCode.Quote, Enum.KeyCode.V, Enum.KeyCode.B, Enum.KeyCode.N, Enum.KeyCode.M)
		end
	end
	if v34 then
		ContextActionService:BindActionAtPriority("FreecamKeyboardDoFToggle", Keypress, false, High, Enum.KeyCode.BackSlash)
		ContextActionService:BindActionAtPriority("FreecamKeyboardDoFControls", Keypress, false, High, Enum.KeyCode.Minus, Enum.KeyCode.Equals)
	end
	if v37 then
		ContextActionService:BindActionAtPriority("FreecamKeyboardPlayerLockToggle", Keypress, false, High, Enum.KeyCode.Slash)
		ContextActionService:BindActionAtPriority("FreecamKeyboardPlayerLockSwitch", Keypress, false, High, Enum.KeyCode.R, Enum.KeyCode.T)
	end
	if v43 then
		ContextActionService:BindActionAtPriority("FreecamKeyboardCustomGuiToggle", Keypress, false, High, Enum.KeyCode.G)
		ContextActionService:BindActionAtPriority("FreecamKeyboardPlayerGuiToggle", Keypress, false, High, Enum.KeyCode.X)
		ContextActionService:BindActionAtPriority("FreecamKeyboardLeaderboardToggle", Keypress, false, High, Enum.KeyCode.L)
	end
	ContextActionService:BindActionAtPriority("FreecamMousePan", MousePan, false, High, Enum.UserInputType.MouseMovement)
	ContextActionService:BindActionAtPriority("FreecamMouseWheel", MouseWheel, false, High, Enum.UserInputType.MouseWheel)
	ContextActionService:BindActionAtPriority("FreecamGamepadButton", GpButton, false, High, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
	ContextActionService:BindActionAtPriority("FreecamGamepadTrigger", Trigger, false, High, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
	ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb, false, High, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
end
function t14.StopCapture() --[[ StopCapture | Line: 878 | Upvalues: v43 (ref), v72 (ref), v22 (ref), v74 (ref), v25 (ref), v73 (ref), t15 (copy), t16 (copy), t17 (copy), ContextActionService (copy), v28 (ref), v34 (ref), v37 (ref) ]]
	if not v43 then
		v72 = 1
		if v22 then
			v74 = 1
		end
		if v25 then
			v73 = 1
		end
	end
	local v1 = t15
	for k, v in pairs(v1) do
		v1[k] = v * 0
	end
	local v2 = t16
	for k, v in pairs(v2) do
		v2[k] = v * 0
	end
	local v3 = t17
	for k, v in pairs(v3) do
		v3[k] = v * 0
	end
	ContextActionService:UnbindAction("FreecamKeyboard")
	if v22 then
		ContextActionService:UnbindAction("FreecamKeyboardControlSpeed")
		ContextActionService:UnbindAction("FreecamGamepadControlSpeed")
	end
	if v25 then
		ContextActionService:UnbindAction("FreecamKeyboardTiltControl")
		ContextActionService:UnbindAction("FreecamGamepadTiltControl")
		ContextActionService:UnbindAction("FreecamKeyboardTiltControlSpeed")
		if v28 then
			ContextActionService:UnbindAction("FreecamKeyboardSmoothnessControl")
		end
	end
	if v34 then
		ContextActionService:UnbindAction("FreecamKeyboardDoFToggle")
		ContextActionService:UnbindAction("FreecamKeyboardDoFControls")
	end
	if v37 then
		ContextActionService:UnbindAction("FreecamKeyboardPlayerLockToggle")
		ContextActionService:UnbindAction("FreecamKeyboardPlayerLockSwitch")
	end
	if v43 then
		ContextActionService:UnbindAction("FreecamKeyboardCustomGuiToggle")
		ContextActionService:UnbindAction("FreecamKeyboardPlayerGuiToggle")
		ContextActionService:UnbindAction("FreecamKeyboardLeaderboardToggle")
	end
	ContextActionService:UnbindAction("FreecamMousePan")
	ContextActionService:UnbindAction("FreecamMouseWheel")
	ContextActionService:UnbindAction("FreecamGamepadButton")
	ContextActionService:UnbindAction("FreecamGamepadTrigger")
	ContextActionService:UnbindAction("FreecamGamepadThumbstick")
end
function t14.getNavSpeed() --[[ getNavSpeed | Line: 924 | Upvalues: v72 (ref) ]]
	return v72
end
function t14.getFovSpeed() --[[ getFovSpeed | Line: 928 | Upvalues: v74 (ref) ]]
	return v74
end
function t14.getRollSpeed() --[[ getRollSpeed | Line: 932 | Upvalues: v73 (ref) ]]
	return v73
end
local function StepFreecam(p1) --[[ StepFreecam | Line: 940 | Upvalues: v28 (ref), t14 (copy), v34 (ref), v5 (ref), v65 (copy), v66 (copy), v67 (copy), v25 (ref), v68 (copy), v64 (ref), rad (copy), tan (copy), sqrt (copy), clamp (copy), v44 (copy), v63 (ref), v62 (ref), v37 (ref), v55 (ref), v59 (ref), v56 (ref), v57 (ref), v43 (ref), v6 (ref), v4 (ref), v45 (ref), v46 (ref), v47 (ref), v48 (ref), v22 (ref), t12 (ref), v58 (ref), CurrentCamera (ref) ]]
	if v28 then
		t14.SpringControl(p1)
	end
	if v34 and (v5 and v5.Parent) then
		t14.DoF(p1)
	end
	local v1 = v65:Update(p1, t14.Vel(p1))
	local v2 = v66:Update(p1, t14.Pan(p1))
	local v3 = v67:Update(p1, t14.Fov(p1))
	local v42 = if v25 then v68:Update(p1, t14.Roll(p1)) else nil
	local v69 = sqrt(0.7002075382097097 / tan((rad(v64 / 2))))
	v64 = clamp(v64 + v3 * 300 * (p1 / v69), 1, 120)
	local v7
	if v25 then
		local v8 = v2 * v44 * (p1 / v69)
		v63 = v63 + Vector3.new(v8.X, v8.Y, v42 * -1.5707963267948966 * (p1 / v69))
		v63 = if v28 then Vector3.new(v63.x % 6.283185307179586, v63.y % 6.283185307179586, v63.z % 6.283185307179586) else Vector3.new(clamp(v63.x, -1.5707963267948966, 1.5707963267948966), v63.y % 6.283185307179586, v63.z)
		v7 = CFrame.new(v62) * CFrame.fromOrientation(v63.x, v63.y, v63.z) * CFrame.new(v1 * Vector3.new(64, 64, 64) * p1)
	else
		v63 = v63 + v2 * v44 * (p1 / v69)
		v63 = Vector2.new(clamp(v63.x, -1.5707963267948966, 1.5707963267948966), v63.y % 6.283185307179586)
		v7 = CFrame.new(v62) * CFrame.fromOrientation(v63.x, v63.y, 0) * CFrame.new(v1 * Vector3.new(64, 64, 64) * p1)
	end
	if v37 and (v55 and v59) then
		v56 = clamp(v56 + v1.Z * 64 * p1, 5, 50)
		v57 = clamp(v57 + v1.Y * 64 * p1, -10, 10)
		local v18 = CFrame.new(v59.Position + Vector3.new(0, v57, 0))
		local v19 = if v25 then CFrame.fromOrientation(v63.x, v63.y, v63.z) else CFrame.fromOrientation(v63.x, v63.y, 0)
		v7 = v18 * v19 * CFrame.new(0, 0, v56)
	end
	if v43 and (v6 and (v6.Parent and (v4 and (v4.Parent and v4.Enabled)))) then
		local v222 = ""
		if p1 > 0 then
			local v23 = (v7.p - v62) / p1
			v222 = v222 .. string.format("Velocity: (%.1f, %.1f, %.1f)\n", v23.X, v23.Y, v23.Z)
		end
		local v24 = v222 .. string.format("FOV: %.1f\n", v64)
		if v25 then
			local format = string.format
			v24 = v24 .. format("Tilt: %.1f\194\176\n", (math.deg(v63.z)))
		end
		if v28 then
			v24 = (((v24 .. string.format("Stiffness (Vel): %.1f\n", v45)) .. string.format("Stiffness (Pan): %.1f\n", v46)) .. string.format("Stiffness (FOV): %.1f\n", v47)) .. string.format("Stiffness (Roll): %.1f\n", v48)
		end
		if v22 then
			v24 = ((v24 .. string.format("Movement Speed: %.1f\n", t14.getNavSpeed())) .. string.format("Zoom Speed: %.1f\n", t14.getFovSpeed())) .. string.format("Tilt Speed: %.1f\n", t14.getRollSpeed())
		end
		if v34 then
			v24 = if v5 and (v5.Parent and v5.Enabled) then ((((v24 .. string.format("Custom Depth Of Field: On\n")) .. string.format("Custom Depth Of Field Near Intensity: %.1f\n", v5.NearIntensity)) .. string.format("Custom Depth Of Field Far Intensity: %.1f\n", v5.FarIntensity)) .. string.format("Custom Depth Of Field Focus Distance: %.1f\n", v5.FocusDistance)) .. string.format("Custom Depth Of Field Focus Radius: %.1f\n", v5.InFocusRadius) else v24 .. string.format("Custom Depth Of Field: Off\n")
		end
		if v37 then
			v24 = if v55 and #t12 > 0 then v24 .. string.format("Player Lock: %s\n", t12[v58].Name) else v24 .. string.format("Player Lock: Off\n")
		end
		v6.Text = v24
	end
	v62 = v7.p
	CurrentCamera.CFrame = v7
	CurrentCamera.Focus = v7
	CurrentCamera.FieldOfView = v64
end
local function CheckMouseLockAvailability() --[[ CheckMouseLockAvailability | Line: 1056 | Upvalues: Players (copy), GameSettings (copy) ]]
	local DevEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock
	local isScriptable = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
	local v1 = if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then true else false
	return if DevEnableMouseLock then if v1 then not (if GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then true else false) and not isScriptable else v1 else DevEnableMouseLock
end
local t19 = {}
local v75 = nil
local v76 = nil
local v77 = nil
local v78 = nil
local v79 = nil
local v80 = nil
local t20 = {}
local t21 = {
	Backpack = true,
	Chat = true,
	Health = true,
	PlayerList = true
}
local t22 = {
	BadgesNotificationsActive = true,
	PointsNotificationsActive = true
}
function t19.Push() --[[ Push | Line: 1089 | Upvalues: t21 (copy), StarterGui (copy), t22 (copy), LocalPlayer (ref), t20 (ref), v19 (ref), v50 (ref), v43 (ref), v60 (ref), v80 (ref), CurrentCamera (ref), v77 (ref), v79 (ref), v78 (ref), v76 (ref), UserInputService (copy), v10 (ref), Players (copy), GameSettings (copy), v75 (ref) ]]
	for k in pairs(t21) do
		t21[k] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[k])
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], false)
	end
	for k in pairs(t22) do
		t22[k] = StarterGui:GetCore(k)
		StarterGui:SetCore(k, false)
	end
	local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if PlayerGui then
		for k, v in pairs(PlayerGui:GetChildren()) do
			if v:IsA("ScreenGui") and v.Enabled then
				t20[#t20 + 1] = v
				v.Enabled = false
			end
		end
		if v19 then
			v50 = PlayerGui.ChildAdded:Connect(function(p1) --[[ Line: 1107 | Upvalues: t20 (ref), v43 (ref), v60 (ref) ]]
				if not (p1:IsA("ScreenGui") and p1.Enabled) then
					return
				end
				t20[#t20 + 1] = p1
				if v43 then
					p1.Enabled = v60
					return
				end
				p1.Enabled = false
			end)
		end
	end
	v80 = CurrentCamera.FieldOfView
	CurrentCamera.FieldOfView = 65
	v77 = CurrentCamera.CameraType
	CurrentCamera.CameraType = Enum.CameraType.Custom
	v79 = CurrentCamera.CFrame
	v78 = CurrentCamera.Focus
	v76 = UserInputService.MouseIconEnabled
	UserInputService.MouseIconEnabled = false
	if v10 then
		local DevEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock
		local isScriptable = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
		local v1 = if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then true else false
		v75 = if if DevEnableMouseLock then if v1 then not (if GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then true else false) and not isScriptable else v1 else DevEnableMouseLock then Enum.MouseBehavior.Default else UserInputService.MouseBehavior
	else
		v75 = UserInputService.MouseBehavior
	end
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end
function t19.Pop() --[[ Pop | Line: 1141 | Upvalues: t21 (copy), StarterGui (copy), t22 (copy), t20 (ref), v43 (ref), v4 (ref), v19 (ref), v50 (ref), CurrentCamera (ref), v80 (ref), v77 (ref), v79 (ref), v78 (ref), UserInputService (copy), v76 (ref), v75 (ref) ]]
	for k, v in pairs(t21) do
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], v)
	end
	for k, v in pairs(t22) do
		StarterGui:SetCore(k, v)
	end
	for k, v in pairs(t20) do
		if v43 then
			if v.Parent and v ~= v4 then
				v.Enabled = true
			end
			continue
		end
		if v.Parent then
			v.Enabled = true
		end
	end
	if not v19 then
		CurrentCamera.FieldOfView = v80
		v80 = nil
		CurrentCamera.CameraType = v77
		v77 = nil
		CurrentCamera.CFrame = v79
		v79 = nil
		CurrentCamera.Focus = v78
		v78 = nil
		UserInputService.MouseIconEnabled = v76
		v76 = nil
		UserInputService.MouseBehavior = v75
		v75 = nil
		return
	end
	if v50 then
		v50:Disconnect()
		v50 = nil
	end
	t20 = {}
	CurrentCamera.FieldOfView = v80
	v80 = nil
	CurrentCamera.CameraType = v77
	v77 = nil
	CurrentCamera.CFrame = v79
	v79 = nil
	CurrentCamera.Focus = v78
	v78 = nil
	UserInputService.MouseIconEnabled = v76
	v76 = nil
	UserInputService.MouseBehavior = v75
	v75 = nil
end
function t19.getScreenGuis() --[[ getScreenGuis | Line: 1187 | Upvalues: t20 (ref) ]]
	return t20
end
local function removePlayerFromList(p1) --[[ removePlayerFromList | Line: 1192 | Upvalues: t12 (ref), v58 (ref), v55 (ref) ]]
	for i, v in ipairs(t12) do
		if v == p1 then
			table.remove(t12, i)
			if v58 == i and v55 then
				v55 = false
				v58 = 1
			end
			if i < v58 then
				v58 = v58 - 1
			end
			if #t12 < v58 or v58 < 1 then
				v58 = 1
				return
			else
				break
			end
		end
	end
end
local function initializePlayerList() --[[ initializePlayerList | Line: 1216 | Upvalues: t12 (ref), Players (copy), LocalPlayer (ref), v58 (ref), v53 (ref), v54 (ref), removePlayerFromList (copy) ]]
	t12 = Players:GetPlayers()
	for i, v in ipairs(t12) do
		if v == LocalPlayer then
			v58 = i
			break
		end
	end
	v53 = Players.PlayerAdded:Connect(function(p1) --[[ Line: 1226 | Upvalues: t12 (ref) ]]
		table.insert(t12, p1)
	end)
	v54 = Players.PlayerRemoving:Connect(removePlayerFromList)
end
local function StartFreecam() --[[ StartFreecam | Line: 1233 | Upvalues: v37 (ref), initializePlayerList (copy), v31 (ref), v13 (ref), CurrentCamera (ref), v25 (ref), v63 (ref), v62 (ref), v64 (ref), v65 (copy), v66 (copy), v67 (copy), v68 (copy), v43 (ref), v28 (ref), v45 (ref), v46 (ref), v47 (ref), v48 (ref), v3 (ref), LocalPlayer (ref), v4 (ref), v6 (ref), t19 (ref), v34 (ref), v5 (ref), RunService (copy), StepFreecam (copy), t14 (copy) ]]
	if v37 then
		initializePlayerList()
	end
	if not v31 and v13 then
		script:SetAttribute("FreecamEnabled", true)
	end
	local v1 = CurrentCamera.CFrame
	v63 = if v25 then Vector3.new(v1:toEulerAnglesYXZ()) else Vector2.new(v1:toEulerAnglesYXZ())
	v62 = v1.p
	v64 = CurrentCamera.FieldOfView
	v65:Reset((Vector3.new()))
	v66:Reset(Vector2.new())
	v67:Reset(0)
	if v25 then
		v68:Reset(0)
	end
	if not v43 and v28 then
		v45 = 1.5
		v46 = 1
		v47 = 4
		v48 = 1
	end
	if v43 then
		v3 = LocalPlayer:WaitForChild("PlayerGui")
		v4 = v3:WaitForChild("Freecam")
		if not (v6 and v6.Parent) then
			v6 = Instance.new("TextLabel")
			v6.Name = "FreecamCustomGui"
			v6.TextColor3 = Color3.new(255/255, 255/255, 255/255)
			v6.Font = Enum.Font.SourceSansBold
			v6.TextSize = 20
			v6.TextStrokeTransparency = 0
			v6.BackgroundTransparency = 1
			v6.TextWrapped = true
			v6.TextXAlignment = Enum.TextXAlignment.Right
			v6.AutomaticSize = Enum.AutomaticSize.Y
			v6.AnchorPoint = Vector2.new(1, 1)
			v6.Position = UDim2.new(1, -10, 1, -10)
			v6.Size = UDim2.new(0, 400, 0, 0)
			v6.Parent = v4
		end
	end
	t19.Push()
	if not v34 or v5 and v5.Parent then
		RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
		t14.StartCapture()
		return
	end
	v5 = Instance.new("DepthOfFieldEffect")
	v5.Enabled = false
	v5.Name = "FreecamDepthOfField"
	v5.Parent = CurrentCamera
	RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	t14.StartCapture()
end
local function StopFreecam() --[[ StopFreecam | Line: 1305 | Upvalues: v31 (ref), v13 (ref), v37 (ref), v53 (ref), v54 (ref), v55 (ref), v58 (ref), t12 (ref), v34 (ref), v5 (ref), t11 (ref), v51 (ref), v52 (ref), v43 (ref), v4 (ref), v60 (ref), v61 (ref), t14 (copy), RunService (copy), t19 (ref) ]]
	if not v31 and v13 then
		script:SetAttribute("FreecamEnabled", false)
	end
	if v37 then
		if v53 then
			v53:Disconnect()
			v53 = nil
		end
		if v54 then
			v54:Disconnect()
			v54 = nil
		end
		v55 = false
		v58 = 1
		t12 = {}
	end
	if v34 and (v5 and v5.Parent) then
		if v5.Enabled then
			for i, v in ipairs(t11) do
				if v.Parent then
					v.Enabled = true
				end
			end
			if v51 then
				v51:Disconnect()
				v51 = nil
			end
			if v52 then
				v52:Disconnect()
				v52 = nil
			end
			t11 = {}
		end
		v5.Enabled = false
	end
	if not v43 then
		t14.StopCapture()
		RunService:UnbindFromRenderStep("Freecam")
		t19.Pop()
		return
	end
	if v4 and v4.Parent then
		v4.Enabled = false
	end
	v60 = false
	v61 = false
	t14.StopCapture()
	RunService:UnbindFromRenderStep("Freecam")
	t19.Pop()
end
local v81 = false
local function ToggleFreecam() --[[ ToggleFreecam | Line: 1366 | Upvalues: v81 (ref), StopFreecam (copy), StartFreecam (copy), v31 (ref) ]]
	if v81 then
		StopFreecam()
	else
		StartFreecam()
	end
	v81 = not v81
	if not v31 then
		return
	end
	script:SetAttribute("FreecamEnabled", v81)
end
local function CheckMacro(p1) --[[ CheckMacro | Line: 1378 | Upvalues: UserInputService (copy), v81 (ref), StopFreecam (copy), StartFreecam (copy), v31 (ref) ]]
	for i = 1, #p1 - 1 do
		if not UserInputService:IsKeyDown(p1[i]) then
			return
		end
	end
	if v81 then
		StopFreecam()
	else
		StartFreecam()
	end
	v81 = not v81
	if not v31 then
		return
	end
	script:SetAttribute("FreecamEnabled", v81)
end
ContextActionService:BindActionAtPriority("FreecamToggle", function(p1, p2, p3) --[[ HandleActivationInput | Line: 1387 | Upvalues: t (copy), CheckMacro (copy) ]]
	if p2 ~= Enum.UserInputState.Begin or p3.KeyCode ~= t[#t] then
		return Enum.ContextActionResult.Pass
	end
	CheckMacro(t)
	return Enum.ContextActionResult.Pass
end, false, Low, t[#t])
if not (v31 or v13) then
	return {}
end
script:SetAttribute("FreecamEnabled", v81)
script:GetAttributeChangedSignal("FreecamEnabled"):Connect(function() --[[ Line: 1400 | Upvalues: v81 (ref), StartFreecam (copy), StopFreecam (copy) ]]
	local v1 = script:GetAttribute("FreecamEnabled")
	if typeof(v1) ~= "boolean" then
		script:SetAttribute("FreecamEnabled", v81)
		return
	end
	if v1 == v81 then
		return
	end
	if v1 then
		StartFreecam()
		v81 = true
		return
	end
	StopFreecam()
	v81 = false
end)
return {}