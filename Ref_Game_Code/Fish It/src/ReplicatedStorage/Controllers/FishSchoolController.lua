-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {}
local v1 = Random.new()
local v2 = nil
local v3 = nil
local v4 = nil
local v5 = nil
local v6 = nil
local t2 = {}
local t3 = {}
local t4 = {}
local v7 = nil
local t5 = {}
local t6 = {}
local t7 = {}
local t8 = {}
local t9 = {}
local function readPositiveNumberAttribute(p1, p2) --[[ readPositiveNumberAttribute | Line: 111 ]]
	local v1 = p1:GetAttribute(p2)
	if typeof(v1) == "number" and not (v1 <= 0) then
		return v1
	else
		return nil
	end
end
local function readNumberAttribute(p1, p2, p3) --[[ readNumberAttribute | Line: 119 ]]
	local v1 = p1:GetAttribute(p2)
	if typeof(v1) == "number" then
		return v1
	else
		return p3
	end
end
local function readStringAttribute(p1, p2, p3) --[[ readStringAttribute | Line: 127 ]]
	local v1 = p1:GetAttribute(p2)
	if typeof(v1) == "string" and v1 ~= "" then
		return v1
	else
		return p3
	end
end
local function getFirstBasePart(p1) --[[ getFirstBasePart | Line: 135 ]]
	if p1:IsA("BasePart") then
		return p1
	end
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") then
			return v2
		end
	end
	return nil
end
local function getHandlePart(p1) --[[ getHandlePart | Line: 147 ]]
	local Handle = p1:FindFirstChild("Handle", true)
	if Handle and Handle:IsA("BasePart") then
		return Handle
	else
		return nil
	end
end
local function setModelStatic(p1) --[[ setModelStatic | Line: 155 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") then
			v2.Anchored = true
			v2.CanCollide = false
			v2.CanTouch = false
			v2.CanQuery = false
			v2.Massless = true
		end
	end
end
local function randomUnitVector() --[[ randomUnitVector | Line: 167 | Upvalues: v1 (copy) ]]
	local v4 = Vector3.new(v1:NextNumber(-1, 1), v1:NextNumber(-0.3, 0.3), v1:NextNumber(-1, 1))
	if v4.Magnitude <= 0.001 then
		return Vector3.new(0, 0, 1)
	else
		return v4.Unit
	end
end
local function unitOr(p1, p2) --[[ unitOr | Line: 179 ]]
	if p1.Magnitude <= 0.001 then
		return p2
	else
		return p1.Unit
	end
end
local function clampPitch(p1) --[[ clampPitch | Line: 186 ]]
	local v1 = if p1.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else p1.Unit
	local v2 = math.clamp(v1.Y, -0.24192189559966773, 0.24192189559966773)
	local v3 = Vector3.new(v1.X, 0, v1.Z)
	local v4 = if v3.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else v3.Unit
	local v6 = math.sqrt((math.max(0, 1 - v2 * v2)))
	return Vector3.new(v4.X * v6, v2, v4.Z * v6)
end
local function clampPosition(p1, p2) --[[ clampPosition | Line: 196 ]]
	return Vector3.new(math.clamp(p1.X, -p2.X, p2.X), math.clamp(p1.Y, -p2.Y, p2.Y), (math.clamp(p1.Z, -p2.Z, p2.Z)))
end
local function computeHalfSize(p1) --[[ computeHalfSize | Line: 204 ]]
	local v1 = p1.Size * 0.5 - Vector3.new(2, 2, 2)
	return Vector3.new(math.max(v1.X, 2), math.max(v1.Y, 2), (math.max(v1.Z, 2)))
end
local function createUprightCFrame(p1, p2) --[[ createUprightCFrame | Line: 213 ]]
	local v1 = if p2.Magnitude > 0.001 then p2.Unit else Vector3.new(0, 0, 1)
	local v2 = v1:Cross(Vector3.new(0, 1, 0))
	if v2.Magnitude <= 0.001 then
		local v3 = v1:Cross(Vector3.new(0, 0, 1))
		v2 = if v3.Magnitude <= 0.001 then v1:Cross(Vector3.new(1, 0, 0)) else v3
	end
	local Unit = v2.Unit
	local Unit_2 = Unit:Cross(v1).Unit
	return CFrame.fromMatrix(p1, Unit, Unit_2, -v1)
end
local function randomOffset(p1, p2) --[[ randomOffset | Line: 230 | Upvalues: v1 (copy) ]]
	return Vector3.new(v1:NextNumber(-p1.X, p1.X), v1:NextNumber(-p1.Y * p2, p1.Y * p2), v1:NextNumber(-p1.Z, p1.Z))
end
local function getQualityScale() --[[ getQualityScale | Line: 238 | Upvalues: UserGameSettings (copy) ]]
	local SavedQualityLevel = UserGameSettings.SavedQualityLevel.Value
	if SavedQualityLevel <= 0 then
		return 0.7
	else
		return math.clamp(SavedQualityLevel / 10, 0.45, 1)
	end
end
local function isMobileDevice() --[[ isMobileDevice | Line: 246 | Upvalues: UserInputService (copy) ]]
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end
local function getOrCreateClientRoot() --[[ getOrCreateClientRoot | Line: 250 | Upvalues: v3 (ref) ]]
	local CurrentCamera = workspace.CurrentCamera
	if not CurrentCamera then
		return nil
	end
	if v3 and v3.Parent == CurrentCamera then
		return v3
	end
	if v3 then
		v3:Destroy()
		v3 = nil
	end
	local ClientRuntimeSchools = CurrentCamera:FindFirstChild("ClientRuntimeSchools")
	if ClientRuntimeSchools and ClientRuntimeSchools:IsA("Folder") then
		v3 = ClientRuntimeSchools
		return ClientRuntimeSchools
	end
	local ClientRuntimeSchools_2
	if not ClientRuntimeSchools then
		ClientRuntimeSchools_2 = Instance.new("Folder")
		ClientRuntimeSchools_2.Name = "ClientRuntimeSchools"
		ClientRuntimeSchools_2.Parent = CurrentCamera
		v3 = ClientRuntimeSchools_2
		return ClientRuntimeSchools_2
	end
	ClientRuntimeSchools:Destroy()
	ClientRuntimeSchools_2 = Instance.new("Folder")
	ClientRuntimeSchools_2.Name = "ClientRuntimeSchools"
	ClientRuntimeSchools_2.Parent = CurrentCamera
	v3 = ClientRuntimeSchools_2
	return ClientRuntimeSchools_2
end
local function getAssetFolder() --[[ getAssetFolder | Line: 277 | Upvalues: v7 (ref), ReplicatedStorage (copy), t5 (copy), t6 (copy) ]]
	if v7 and v7.Parent then
		return v7
	end
	local FishSchoolAssets = ReplicatedStorage:FindFirstChild("FishSchoolAssets")
	if FishSchoolAssets and FishSchoolAssets:IsA("Folder") then
		v7 = FishSchoolAssets
		table.clear(t5)
		table.clear(t6)
		return FishSchoolAssets
	else
		return nil
	end
end
local function getTemplate(p1) --[[ getTemplate | Line: 291 | Upvalues: t5 (copy), getAssetFolder (copy) ]]
	local v1 = t5[p1]
	if v1 and v1.Parent then
		return v1
	end
	local v2 = getAssetFolder()
	if not v2 then
		return nil
	end
	local v3 = v2:FindFirstChild(p1)
	if v3 and v3:IsA("Model") then
		t5[p1] = v3
		return v3
	else
		return nil
	end
end
local function getRotationOffset(p1) --[[ getRotationOffset | Line: 308 | Upvalues: t6 (copy), createUprightCFrame (copy) ]]
	local v1 = t6[p1]
	if v1 then
		return v1
	else
		local v2 = p1:GetPivot()
		local v3 = createUprightCFrame(v2.Position, v2.LookVector):ToObjectSpace(v2)
		t6[p1] = v3
		return v3
	end
end
local function getFlowBasis(p1) --[[ getFlowBasis | Line: 320 | Upvalues: clampPitch (copy) ]]
	local v3 = clampPitch(if p1.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else p1.Unit)
	local v4 = v3:Cross(Vector3.new(0, 1, 0))
	if v4.Magnitude <= 0.001 then
		v4 = Vector3.new(1, 0, 0)
	end
	local Unit = v4.Unit
	return v3, Unit, Unit:Cross(v3).Unit
end
local function updateFlowBasis(p1) --[[ updateFlowBasis | Line: 332 | Upvalues: clampPitch (copy) ]]
	local FlowDirectionLocal = p1.FlowDirectionLocal
	local v3 = clampPitch(if FlowDirectionLocal.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else FlowDirectionLocal.Unit)
	local v4 = v3:Cross(Vector3.new(0, 1, 0))
	if v4.Magnitude <= 0.001 then
		v4 = Vector3.new(1, 0, 0)
	end
	local Unit = v4.Unit
	local Unit_2 = Unit:Cross(v3).Unit
	p1.FlowForwardLocal = v3
	p1.FlowRightLocal = Unit
	p1.FlowUpLocal = Unit_2
end
local function chooseSchoolTarget(p1) --[[ chooseSchoolTarget | Line: 339 | Upvalues: v1 (copy) ]]
	local v12 = p1.BaseCenterLocal + p1.FlowForwardLocal * v1:NextNumber(p1.SpreadLocal.Z * 0.35, p1.SpreadLocal.Z * 0.9) + p1.FlowRightLocal * v1:NextNumber(-p1.SpreadLocal.X * 0.4, p1.SpreadLocal.X * 0.4) + p1.FlowUpLocal * v1:NextNumber(-p1.SpreadLocal.Y * 0.22, p1.SpreadLocal.Y * 0.22)
	local HalfSize = p1.HalfSize
	return Vector3.new(math.clamp(v12.X, -HalfSize.X, HalfSize.X), math.clamp(v12.Y, -HalfSize.Y, HalfSize.Y), (math.clamp(v12.Z, -HalfSize.Z, HalfSize.Z)))
end
local function getFishTargetLocal(p1, p2) --[[ getFishTargetLocal | Line: 347 ]]
	local v3 = p1.FlowRightLocal * math.sin(p2.OrbitPhase + p2.BobPhase) * p2.OrbitRadius
	local v6 = p1.CenterLocal + (p1.FlowRightLocal * p2.HomeOffsetLocal.X + p1.FlowUpLocal * p2.HomeOffsetLocal.Y + p1.FlowForwardLocal * p2.HomeOffsetLocal.Z) + p2.DriftLocal + (v3 + p1.FlowUpLocal * math.sin(p2.OrbitPhase * 0.7 + p2.BobPhase) * p2.OrbitRadius * p2.VerticalWaveScale)
	local HalfSize = p1.HalfSize
	return Vector3.new(math.clamp(v6.X, -HalfSize.X, HalfSize.X), math.clamp(v6.Y, -HalfSize.Y, HalfSize.Y), (math.clamp(v6.Z, -HalfSize.Z, HalfSize.Z)))
end
local function disconnectRootSignals() --[[ disconnectRootSignals | Line: 356 | Upvalues: v4 (ref), v5 (ref) ]]
	if v4 then
		v4:Disconnect()
		v4 = nil
	end
	if not v5 then
		return
	end
	v5:Disconnect()
	v5 = nil
end
local function setFishVisible(p1, p2, p3, p4, p5) --[[ setFishVisible | Line: 367 | Upvalues: getFishTargetLocal (copy), clampPitch (copy), createUprightCFrame (copy) ]]
	if p2.Visible == p3 then
		return
	end
	p2.Visible = p3
	if not p3 then
		p2.Model.Parent = nil
		return
	end
	p2.PositionLocal = getFishTargetLocal(p1, p2)
	local FlowDirectionLocal = p1.FlowDirectionLocal
	p2.DirectionLocal = clampPitch(if FlowDirectionLocal.Magnitude <= 0.001 then p2.DirectionLocal else FlowDirectionLocal.Unit)
	p2.VelocityLocal = p2.DirectionLocal * p2.BaseSpeed
	local v3 = p5:PointToWorldSpace(p2.PositionLocal)
	local v5 = v3 + p5.UpVector * math.sin(p4 + p2.BobPhase) * p2.BobAmplitude
	local v6 = p5:VectorToWorldSpace(p2.DirectionLocal)
	if v6.Magnitude <= 0.001 then
		v6 = p5.LookVector
	end
	p2.Model.Parent = p1.RenderFolder
	p2.Model:PivotTo(createUprightCFrame(v5, v6) * p2.RotationOffset)
end
local function destroySchool(p1) --[[ destroySchool | Line: 389 ]]
	for v1, v2 in p1.Fish do
		v2.Model:Destroy()
	end
	p1.RenderFolder:Destroy()
end
local function clearSchools() --[[ clearSchools | Line: 396 | Upvalues: t2 (copy), t3 (copy), t4 (copy) ]]
	for i = #t2, 1, -1 do
		local v1 = t2[i]
		for v2, v3 in v1.Fish do
			v3.Model:Destroy()
		end
		v1.RenderFolder:Destroy()
		t2[i] = nil
	end
	table.clear(t3)
	table.clear(t4)
end
local function unloadSchool(p1) --[[ unloadSchool | Line: 405 ]]
	for v1, v2 in p1.Fish do
		v2.Model:Destroy()
	end
	table.clear(p1.Fish)
	p1.ActiveCount = 0
	p1.TargetResidentCount = 0
	p1.DesiredActiveCount = 0
end
local function removeSchoolByFolder(p1) --[[ removeSchoolByFolder | Line: 415 | Upvalues: t3 (copy), t4 (copy), t2 (copy) ]]
	local v1 = t3[p1]
	local v2 = t4[p1]
	if not (v1 and v2) then
		return
	end
	local v3 = #t2
	local v4 = t2[v3]
	t2[v2] = v4
	t2[v3] = nil
	t3[p1] = nil
	t4[p1] = nil
	if v4 and v4 ~= v1 then
		t4[v4.Folder] = v2
	end
	for v5, v6 in v1.Fish do
		v6.Model:Destroy()
	end
	v1.RenderFolder:Destroy()
end
local function createSchoolFromFolder(p1) --[[ createSchoolFromFolder | Line: 433 | Upvalues: v3 (ref), getOrCreateClientRoot (copy), v1 (copy), clampPitch (copy), chooseSchoolTarget (copy) ]]
	local SpawnPart = p1:FindFirstChild("SpawnPart")
	if not (SpawnPart and SpawnPart:IsA("ObjectValue")) then
		return nil
	end
	local v12 = SpawnPart.Value
	if not (v12 and v12:IsA("BasePart")) then
		return nil
	end
	local v2 = v3 or getOrCreateClientRoot()
	if not v2 then
		return nil
	end
	local v32 = Instance.new("Folder")
	v32.Name = p1.Name
	v32.Parent = v2
	local v4 = v12.Size * 0.5 - Vector3.new(2, 2, 2)
	local v8 = Vector3.new(math.max(v4.X, 2), math.max(v4.Y, 2), (math.max(v4.Z, 2)))
	local v9 = p1:GetAttribute("CenterX")
	local v10 = if typeof(v9) == "number" then v9 else 0
	local v11 = p1:GetAttribute("CenterY")
	local v122, v13
	if typeof(v11) == "number" then
		v122 = v11
		v13 = v8
	else
		v122 = 0
		v13 = v8
	end
	local v14 = p1:GetAttribute("CenterZ")
	local v16 = Vector3.new(v10, v122, if typeof(v14) == "number" then v14 else 0)
	local v23 = Vector3.new(math.clamp(v16.X, -v13.X, v13.X), math.clamp(v16.Y, -v13.Y, v13.Y), (math.clamp(v16.Z, -v13.Z, v13.Z)))
	local v27 = Vector3.new(v1:NextNumber(-1, 1), v1:NextNumber(-0.3, 0.3), v1:NextNumber(-1, 1))
	local v28 = if v27.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else v27.Unit
	local v30, v31
	if v28.Magnitude <= 0.001 then
		v30 = Vector3.new(0, 0, 1)
		v31 = v23
	else
		v30 = v28.Unit
		v31 = v23
	end
	local v322 = clampPitch(v30)
	local v33 = v322:Cross(Vector3.new(0, 1, 0))
	if v33.Magnitude <= 0.001 then
		v33 = Vector3.new(1, 0, 0)
	end
	local Unit = v33.Unit
	local Unit_2 = Unit:Cross(v322).Unit
	local t = {
		VelocityLocal = Vector3.new(0, 0, 0),
		TargetResidentCount = 0,
		DesiredActiveCount = 0,
		ComputedDesiredCap = 0,
		ActiveCount = 0,
		OffscreenTime = 0,
		Folder = p1,
		RenderFolder = v32,
		SpawnPart = v12
	}
	local v34 = p1.Name
	local v35 = p1:GetAttribute("SchoolSpecies")
	local v36, v37, v38, v39
	if typeof(v35) == "string" and v35 ~= "" then
		v36 = v35
		v37 = v322
		v38 = Unit
		v39 = Unit_2
	else
		v36 = v34
		v37 = v322
		v38 = Unit
		v39 = Unit_2
	end
	t.Species = v36
	t.HalfSize = v13
	t.BaseCenterLocal = v31
	t.CenterLocal = v31
	t.TargetLocal = v31
	t.FlowDirectionLocal = v28
	t.FlowForwardLocal = v37
	t.FlowRightLocal = v38
	t.FlowUpLocal = v39
	local v40 = v1:NextNumber(4.4, 7.4)
	local v41 = p1:GetAttribute("SpeedMultiplier")
	t.SwimSpeed = v40 * ((if typeof(v41) == "number" and not (v41 <= 0) then v41 else nil) or 1)
	t.SwimTurnSpeed = v1:NextNumber(1.1, 1.9)
	local v45 = p1:GetAttribute("SpreadX")
	local v47 = math.max(4, if typeof(v45) == "number" then v45 else v13.X * 0.3)
	local v50 = p1:GetAttribute("SpreadY")
	local v52 = math.max(2, if typeof(v50) == "number" then v50 else v13.Y * 0.18)
	local v55 = p1:GetAttribute("SpreadZ")
	t.SpreadLocal = Vector3.new(v47, v52, (math.max(4, if typeof(v55) == "number" then v55 else v13.Z * 0.3)))
	local v58 = p1:GetAttribute("SpeedMultiplier")
	t.SpeedMultiplier = (if typeof(v58) == "number" and not (v58 <= 0) then v58 else nil) or 1
	local v61 = p1:GetAttribute("FishCount")
	t.FishCount = math.max(1, (math.floor(if typeof(v61) == "number" then v61 else 12)))
	t.Fish = {}
	local FlowDirectionLocal = t.FlowDirectionLocal
	t.VelocityLocal = clampPitch(if FlowDirectionLocal.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else FlowDirectionLocal.Unit) * t.SwimSpeed
	t.TargetLocal = chooseSchoolTarget(t)
	return t
end
local function addOrRefreshSchool(p1) --[[ addOrRefreshSchool | Line: 492 | Upvalues: t3 (copy), t4 (copy), t2 (copy), createSchoolFromFolder (copy) ]]
	local v1 = t3[p1]
	local v2 = t4[p1]
	if v1 and v2 then
		local v3 = #t2
		local v4 = t2[v3]
		t2[v2] = v4
		t2[v3] = nil
		t3[p1] = nil
		t4[p1] = nil
		if v4 and v4 ~= v1 then
			t4[v4.Folder] = v2
		end
		for v5, v6 in v1.Fish do
			v6.Model:Destroy()
		end
		v1.RenderFolder:Destroy()
	end
	local v7 = createSchoolFromFolder(p1)
	if not v7 then
		return
	end
	local v8 = #t2 + 1
	t2[v8] = v7
	t3[p1] = v7
	t4[p1] = v8
end
local function syncSchoolsFromRoot(p1) --[[ syncSchoolsFromRoot | Line: 503 | Upvalues: t3 (copy), t4 (copy), t2 (copy), createSchoolFromFolder (copy) ]]
	local t = {}
	for v1, v2 in p1:GetChildren() do
		if v2:IsA("Folder") then
			t[v2] = true
			if not t3[v2] then
				local v3 = t3[v2]
				local v4 = t4[v2]
				if v3 and v4 then
					local v5 = #t2
					local v6 = t2[v5]
					t2[v4] = v6
					t2[v5] = nil
					t3[v2] = nil
					t4[v2] = nil
					if v6 and v6 ~= v3 then
						t4[v6.Folder] = v4
					end
					for v7, v8 in v3.Fish do
						v8.Model:Destroy()
					end
					v3.RenderFolder:Destroy()
				end
				local v9 = createSchoolFromFolder(v2)
				if v9 then
					local v10 = #t2 + 1
					t2[v10] = v9
					t3[v2] = v9
					t4[v2] = v10
				end
			end
		end
	end
	for i = #t2, 1, -1 do
		local v11 = t2[i]
		if not (v11.Folder.Parent and t[v11.Folder]) then
			local Folder = v11.Folder
			local v12 = t3[Folder]
			local v13 = t4[Folder]
			if v12 and v13 then
				local v14 = #t2
				local v15 = t2[v14]
				t2[v13] = v15
				t2[v14] = nil
				t3[Folder] = nil
				t4[Folder] = nil
				if v15 and v15 ~= v12 then
					t4[v15.Folder] = v13
				end
				for v16, v17 in v12.Fish do
					v17.Model:Destroy()
				end
				v12.RenderFolder:Destroy()
			end
		end
	end
end
local function attachRuntimeRoot(p1) --[[ attachRuntimeRoot | Line: 521 | Upvalues: v4 (ref), v5 (ref), v2 (ref), clearSchools (copy), v3 (ref), getOrCreateClientRoot (copy), syncSchoolsFromRoot (copy), t3 (copy), t4 (copy), t2 (copy), createSchoolFromFolder (copy) ]]
	if v4 then
		v4:Disconnect()
		v4 = nil
	end
	if v5 then
		v5:Disconnect()
		v5 = nil
	end
	v2 = p1
	clearSchools()
	v3 = getOrCreateClientRoot()
	if v3 then
		v3:ClearAllChildren()
	end
	syncSchoolsFromRoot(p1)
	v4 = p1.ChildAdded:Connect(function(p1) --[[ Line: 530 | Upvalues: t3 (ref), t4 (ref), t2 (ref), createSchoolFromFolder (ref) ]]
		if not p1:IsA("Folder") then
			return
		end
		local v1 = t3[p1]
		local v2 = t4[p1]
		if v1 and v2 then
			local v3 = #t2
			local v4 = t2[v3]
			t2[v2] = v4
			t2[v3] = nil
			t3[p1] = nil
			t4[p1] = nil
			if v4 and v4 ~= v1 then
				t4[v4.Folder] = v2
			end
			for v5, v6 in v1.Fish do
				v6.Model:Destroy()
			end
			v1.RenderFolder:Destroy()
		end
		local v7 = createSchoolFromFolder(p1)
		if not v7 then
			return
		end
		local v8 = #t2 + 1
		t2[v8] = v7
		t3[p1] = v7
		t4[p1] = v8
	end)
	v5 = p1.ChildRemoved:Connect(function(p1) --[[ Line: 535 | Upvalues: t3 (ref), t4 (ref), t2 (ref) ]]
		if not p1:IsA("Folder") then
			return
		end
		local v1 = t3[p1]
		local v2 = t4[p1]
		if not v1 then
			return
		end
		if not v2 then
			return
		end
		local v3 = #t2
		local v4 = t2[v3]
		t2[v2] = v4
		t2[v3] = nil
		t3[p1] = nil
		t4[p1] = nil
		if v4 and v4 ~= v1 then
			t4[v4.Folder] = v2
		end
		for v5, v6 in v1.Fish do
			v6.Model:Destroy()
		end
		v1.RenderFolder:Destroy()
	end)
end
local function tryResolveRuntimeRoot() --[[ tryResolveRuntimeRoot | Line: 542 | Upvalues: v2 (ref), v4 (ref), v5 (ref), clearSchools (copy), attachRuntimeRoot (copy) ]]
	local FishContainer = workspace:FindFirstChild("FishContainer")
	if FishContainer then
		local RuntimeSchools = FishContainer:FindFirstChild("RuntimeSchools")
		if RuntimeSchools and RuntimeSchools:IsA("Folder") then
			if v2 == RuntimeSchools then
				return
			end
			attachRuntimeRoot(RuntimeSchools)
		else
			if not v2 then
				return
			end
			v2 = nil
			if v4 then
				v4:Disconnect()
				v4 = nil
			end
			if v5 then
				v5:Disconnect()
				v5 = nil
			end
			clearSchools()
		end
	else
		if not v2 then
			return
		end
		v2 = nil
		if v4 then
			v4:Disconnect()
			v4 = nil
		end
		if v5 then
			v5:Disconnect()
			v5 = nil
		end
		clearSchools()
	end
end
local function createFishState(p1, p2) --[[ createFishState | Line: 566 | Upvalues: getFirstBasePart (copy), setModelStatic (copy), v1 (copy), clampPitch (copy), t6 (copy), createUprightCFrame (copy) ]]
	local v12 = p2:Clone()
	local Handle = v12:FindFirstChild("Handle", true)
	local v2 = if Handle and Handle:IsA("BasePart") then Handle else nil
	if v2 then
		v12.PrimaryPart = v2
	elseif not v12.PrimaryPart then
		local v3 = getFirstBasePart(v12)
		if v3 then
			v12.PrimaryPart = v3
		end
	end
	if not v12.PrimaryPart then
		v12:Destroy()
		return nil
	end
	setModelStatic(v12)
	v12.Parent = nil
	local v4 = v1:NextNumber(3.2, 5.8) * p1.SpeedMultiplier
	local v8 = Vector3.new(v1:NextNumber(-p1.SpreadLocal.X * 0.5, p1.SpreadLocal.X * 0.5), v1:NextNumber(-p1.SpreadLocal.Y * 0.4, p1.SpreadLocal.Y * 0.4), -v1:NextNumber(0, p1.SpreadLocal.Z * 0.8))
	local v10 = p1.FlowForwardLocal * v1:NextNumber(0.86, 1) + p1.FlowRightLocal * v1:NextNumber(-0.18, 0.18) + p1.FlowUpLocal * v1:NextNumber(-0.08, 0.08)
	local v122 = clampPitch(if v10.Magnitude <= 0.001 then p1.FlowDirectionLocal else v10.Unit)
	local v13 = p1.CenterLocal + p1.FlowRightLocal * v8.X + p1.FlowUpLocal * v8.Y + p1.FlowForwardLocal * v8.Z
	local HalfSize = p1.HalfSize
	local t = {
		Visible = false,
		DriftLocal = Vector3.new(0, 0, 0),
		Model = v12,
		PositionLocal = Vector3.new(math.clamp(v13.X, -HalfSize.X, HalfSize.X), math.clamp(v13.Y, -HalfSize.Y, HalfSize.Y), (math.clamp(v13.Z, -HalfSize.Z, HalfSize.Z))),
		DirectionLocal = v122,
		VelocityLocal = v122 * v4,
		HomeOffsetLocal = v8
	}
	local v20 = p1.SpreadLocal * 0.08
	t.DriftTargetLocal = Vector3.new(v1:NextNumber(-v20.X, v20.X), v1:NextNumber(-v20.Y * 0.16, v20.Y * 0.16), v1:NextNumber(-v20.Z, v20.Z))
	t.DriftTimer = v1:NextNumber(1.8, 3.4)
	t.BaseSpeed = v4
	t.FollowSpeed = v1:NextNumber(1.8, 3)
	t.BobPhase = v1:NextNumber(0, 6.283185307179586)
	t.BobAmplitude = v1:NextNumber(0.015, 0.04)
	t.OrbitPhase = v1:NextNumber(0, 6.283185307179586)
	t.OrbitSpeed = v1:NextNumber(0.8, 1.2)
	t.OrbitRadius = v1:NextNumber(0.08, (math.max(0.24, math.min(p1.SpreadLocal.X, p1.SpreadLocal.Z) * 0.03)))
	t.VerticalWaveScale = v1:NextNumber(0.05, 0.14)
	local v27 = t6[p2]
	local v28
	if v27 then
		v28 = v27
	else
		local v29 = p2:GetPivot()
		local v30 = createUprightCFrame(v29.Position, v29.LookVector):ToObjectSpace(v29)
		t6[p2] = v30
		v28 = v30
	end
	t.RotationOffset = v28
	return t
end
local function getSchoolDistance(p1, p2, p3) --[[ getSchoolDistance | Line: 624 ]]
	local v1 = p3:PointToObjectSpace(p1) - p2.BaseCenterLocal
	return (p1 - p3:PointToWorldSpace(p2.BaseCenterLocal + Vector3.new(math.clamp(v1.X, -p2.SpreadLocal.X, p2.SpreadLocal.X), math.clamp(v1.Y, -p2.SpreadLocal.Y, p2.SpreadLocal.Y), (math.clamp(v1.Z, -p2.SpreadLocal.Z, p2.SpreadLocal.Z))))).Magnitude
end
local function computeResidentCap(p1, p2, p3) --[[ computeResidentCap | Line: 636 ]]
	return math.min(p1.FishCount, (math.max(3, (math.min(p2, (math.floor(math.sqrt(p1.FishCount) * (p3 * 0.35 + 1.55) + 0.5)))))))
end
local function setDesiredInactive(p1, p2, p3, p4) --[[ setDesiredInactive | Line: 641 | Upvalues: unloadSchool (copy) ]]
	p1.DesiredActiveCount = 0
	p1.TargetResidentCount = 0
	if #p1.Fish == 0 then
		return
	end
	if p4 <= p3 then
		p1.OffscreenTime = 0
		return
	end
	p1.OffscreenTime = p1.OffscreenTime + p2
	if not (p1.OffscreenTime >= 1) then
		return
	end
	unloadSchool(p1)
end
local function assignSchools(p1, p2, p3) --[[ assignSchools | Line: 657 ]]
	for v2, v3 in p1 do
		local v1
		if p3 <= 0 then
			return 0
		end
		v1 = if p2 then math.min(v3.ComputedDesiredCap, 3) else v3.ComputedDesiredCap
		local DesiredActiveCount = v3.DesiredActiveCount
		if DesiredActiveCount < v1 then
			local v4 = math.min(v1 - DesiredActiveCount, p3)
			v3.DesiredActiveCount = v3.DesiredActiveCount + v4
			p3 = p3 - v4
		end
	end
	return p3
end
local function ensureSchoolPool(p1, p2) --[[ ensureSchoolPool | Line: 679 | Upvalues: t5 (copy), getAssetFolder (copy), createFishState (copy) ]]
	if p2 <= 0 then
		return p2
	end
	local TargetResidentCount = p1.TargetResidentCount
	if TargetResidentCount <= #p1.Fish then
		return p2
	end
	local Species = p1.Species
	local v1 = t5[Species]
	local v2
	if v1 and v1.Parent then
		v2 = v1
	else
		local v3 = getAssetFolder()
		if v3 then
			local v4 = v3:FindFirstChild(Species)
			if v4 and v4:IsA("Model") then
				t5[Species] = v4
				v2 = v4
			else
				v2 = nil
			end
		else
			v2 = nil
		end
	end
	if not v2 then
		return p2
	end
	for i = 1, math.min(TargetResidentCount - #p1.Fish, p2) do
		local v6 = createFishState(p1, v2)
		if v6 then
			table.insert(p1.Fish, v6)
			p2 = p2 - 1
			if p2 <= 0 then
				break
			end
		end
	end
	return p2
end
local function applyActiveCount(p1, p2, p3) --[[ applyActiveCount | Line: 705 | Upvalues: setFishVisible (copy) ]]
	local v2 = math.min(p1.DesiredActiveCount, #p1.Fish)
	local ActiveCount = p1.ActiveCount
	if ActiveCount == v2 then
		return
	end
	p1.ActiveCount = v2
	if ActiveCount < v2 then
		for i = ActiveCount + 1, v2 do
			local v3 = p1.Fish[i]
			if v3 then
				setFishVisible(p1, v3, true, p2, p3)
			end
		end
	else
		for j = v2 + 1, ActiveCount do
			local v4 = p1.Fish[j]
			if v4 and v4.Visible ~= false then
				v4.Visible = false
				v4.Model.Parent = nil
			end
		end
	end
end
local function updateSchoolTarget(p1, p2) --[[ updateSchoolTarget | Line: 729 | Upvalues: chooseSchoolTarget (copy), clampPitch (copy) ]]
	local v1 = p1.TargetLocal - p1.CenterLocal
	local Magnitude = v1.Magnitude
	if Magnitude <= 4 then
		p1.TargetLocal = chooseSchoolTarget(p1)
		v1 = p1.TargetLocal - p1.CenterLocal
		Magnitude = v1.Magnitude
	end
	local v2 = if Magnitude > 0.001 then v1.Unit else p1.FlowDirectionLocal
	p1.VelocityLocal = p1.VelocityLocal:Lerp(v2 * p1.SwimSpeed, 1 - math.exp(-(p1.SwimTurnSpeed * 0.7) * p2))
	local v6 = p1.CenterLocal + p1.VelocityLocal * p2
	local HalfSize = p1.HalfSize
	local v13 = Vector3.new(math.clamp(v6.X, -HalfSize.X, HalfSize.X), math.clamp(v6.Y, -HalfSize.Y, HalfSize.Y), (math.clamp(v6.Z, -HalfSize.Z, HalfSize.Z)))
	local v14
	if (v13 - v6).Magnitude > 0.001 then
		local v16 = p1.BaseCenterLocal - p1.CenterLocal
		p1.VelocityLocal = p1.VelocityLocal:Lerp(clampPitch(if v16.Magnitude <= 0.001 then -v2 else v16.Unit) * p1.SwimSpeed, 1 - math.exp(-(p1.SwimTurnSpeed * 1.45) * p2))
		local v21 = p1.CenterLocal + p1.VelocityLocal * p2
		local HalfSize_2 = p1.HalfSize
		local v28 = Vector3.new(math.clamp(v21.X, -HalfSize_2.X, HalfSize_2.X), math.clamp(v21.Y, -HalfSize_2.Y, HalfSize_2.Y), (math.clamp(v21.Z, -HalfSize_2.Z, HalfSize_2.Z)))
		p1.TargetLocal = chooseSchoolTarget(p1)
		v14 = v28
	else
		v14 = v13
	end
	p1.CenterLocal = v14
	local VelocityLocal = p1.VelocityLocal
	local v31 = clampPitch(if VelocityLocal.Magnitude <= 0.001 then v2 else VelocityLocal.Unit)
	local v34 = p1.FlowDirectionLocal:Lerp(v31, 1 - math.exp(-(p1.SwimTurnSpeed * 0.55) * p2))
	p1.FlowDirectionLocal = clampPitch(if v34.Magnitude <= 0.001 then v31 else v34.Unit)
	local FlowDirectionLocal_2 = p1.FlowDirectionLocal
	local v38 = clampPitch(if FlowDirectionLocal_2.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else FlowDirectionLocal_2.Unit)
	local v39 = v38:Cross(Vector3.new(0, 1, 0))
	if v39.Magnitude <= 0.001 then
		v39 = Vector3.new(1, 0, 0)
	end
	local Unit = v39.Unit
	local Unit_2 = Unit:Cross(v38).Unit
	p1.FlowForwardLocal = v38
	p1.FlowRightLocal = Unit
	p1.FlowUpLocal = Unit_2
end
local function updateFish(p1, p2, p3, p4, p5) --[[ updateFish | Line: 758 | Upvalues: v1 (copy), getFishTargetLocal (copy), clampPitch (copy), createUprightCFrame (copy) ]]
	p2.DriftTimer = p2.DriftTimer - p3
	if p2.DriftTimer <= 0 then
		p2.DriftTimer = v1:NextNumber(1.8, 3.4)
		local v12 = p1.SpreadLocal * 0.08
		p2.DriftTargetLocal = Vector3.new(v1:NextNumber(-v12.X, v12.X), v1:NextNumber(-v12.Y * 0.16, v12.Y * 0.16), v1:NextNumber(-v12.Z, v12.Z))
	end
	p2.DriftLocal = p2.DriftLocal:Lerp(p2.DriftTargetLocal, 1 - math.exp(p3 * -0.45))
	p2.OrbitPhase = p2.OrbitPhase + p2.OrbitSpeed * p3
	local v6 = getFishTargetLocal(p1, p2) - p2.PositionLocal
	local v8 = (math.sin(p4 * 1.15 + p2.BobPhase) * 0.5 + 0.5) * 0.1 + 0.94
	local VelocityLocal = p1.VelocityLocal
	local v11 = clampPitch(if VelocityLocal.Magnitude <= 0.001 then p1.FlowDirectionLocal else VelocityLocal.Unit)
	local v15 = v11 * 0.18000000000000005 + (if v6.Magnitude <= 0.001 then v11 else v6.Unit) * 0.82
	local v17 = clampPitch(if v15.Magnitude <= 0.001 then v11 else v15.Unit)
	local v20 = p2.DirectionLocal:Lerp(v17, 1 - math.exp(-p2.FollowSpeed * 0.48 * p3))
	p2.DirectionLocal = clampPitch(if v20.Magnitude <= 0.001 then v17 else v20.Unit)
	local v22 = v6:Dot(p2.DirectionLocal)
	local v23 = v6 - p2.DirectionLocal * v22
	local Magnitude = v23.Magnitude
	local v25 = if Magnitude > 0.001 then v23.Unit * math.min(Magnitude, p2.BaseSpeed * 0.22) else Vector3.new(0, 0, 0)
	local v26 = p2.BaseSpeed * v8
	p2.VelocityLocal = p2.VelocityLocal:Lerp(p2.DirectionLocal * v26 + v25 * (p2.FollowSpeed * 0.32) + p2.DirectionLocal * (v22 * p2.FollowSpeed * 0.56 * 0.08), 1 - math.exp(-p2.FollowSpeed * 0.92 * p3))
	local v29 = p2.VelocityLocal:Dot(p2.DirectionLocal)
	p2.VelocityLocal = p2.DirectionLocal * math.max(v29, p2.BaseSpeed * 0.72) + (p2.VelocityLocal - p2.DirectionLocal * v29) * math.exp(p3 * -6.5)
	local v31 = p2.PositionLocal + p2.VelocityLocal * p3
	local HalfSize = p1.HalfSize
	local v38 = Vector3.new(math.clamp(v31.X, -HalfSize.X, HalfSize.X), math.clamp(v31.Y, -HalfSize.Y, HalfSize.Y), (math.clamp(v31.Z, -HalfSize.Z, HalfSize.Z)))
	local v39
	if (v38 - v31).Magnitude > 0.001 then
		local v41 = p1.CenterLocal - v38
		local v44 = clampPitch(if v41.Magnitude <= 0.001 then -p2.DirectionLocal else v41.Unit)
		p2.VelocityLocal = p2.VelocityLocal:Lerp(v44 * math.max(p2.BaseSpeed * 0.84, v26 * 0.86), 0.18)
		local v49 = p2.DirectionLocal:Lerp(v44, 1 - math.exp(-p2.FollowSpeed * 0.22 * p3))
		local v50
		if v49.Magnitude <= 0.001 then
			v50 = v44
			v39 = v38
		else
			v50 = v49.Unit
			v39 = v38
		end
		p2.DirectionLocal = clampPitch(v50)
	else
		v39 = v38
	end
	p2.PositionLocal = v39
	local v51 = p5:PointToWorldSpace(p2.PositionLocal)
	local v53 = v51 + p5.UpVector * math.sin(p4 * 1.6 + p2.BobPhase) * p2.BobAmplitude
	local v54 = p5:VectorToWorldSpace(p2.DirectionLocal)
	if v54.Magnitude <= 0.001 then
		v54 = p5.LookVector
	end
	p2.Model:PivotTo(createUprightCFrame(v53, v54) * p2.RotationOffset)
end
function t.Start(p1) --[[ Start | Line: 814 | Upvalues: tryResolveRuntimeRoot (copy), UserGameSettings (copy), UserInputService (copy), v6 (ref), RunService (copy), t7 (copy), t8 (copy), t9 (copy), t2 (copy), t3 (copy), t4 (copy), getSchoolDistance (copy), unloadSchool (copy), assignSchools (copy), ensureSchoolPool (copy), applyActiveCount (copy), updateSchoolTarget (copy), updateFish (copy) ]]
	tryResolveRuntimeRoot()
	local v1 = 0
	local v2 = 1.25
	local v3 = 0
	local SavedQualityLevel = UserGameSettings.SavedQualityLevel.Value
	local v4 = if SavedQualityLevel <= 0 then 0.7 else math.clamp(SavedQualityLevel / 10, 0.45, 1)
	local v5 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local v62 = if v5 then 0.9 else 1
	local v7 = 0.03333333333333333
	if v6 then
		v6:Disconnect()
	end
	v6 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 829 | Upvalues: v1 (ref), v2 (ref), v3 (ref), v7 (ref), v5 (copy), v62 (ref), tryResolveRuntimeRoot (ref), v4 (ref), UserGameSettings (ref), t7 (ref), t8 (ref), t9 (ref), t2 (ref), t3 (ref), t4 (ref), getSchoolDistance (ref), unloadSchool (ref), assignSchools (ref), ensureSchoolPool (ref), applyActiveCount (ref), updateSchoolTarget (ref), updateFish (ref) ]]
		v1 = v1 + p1
		v2 = v2 + p1
		v3 = v3 + p1
		v7 = v7 + (p1 - v7) * 0.08
		if v5 then
			local v12 = 0.02 - v7
			v62 = if v12 >= 0 then v62 + v12 * 5 * p1 else v62 + v12 * 14 * p1
			v62 = math.clamp(v62, 0.55, 1)
		end
		if v2 >= 1.25 then
			v2 = 0
			tryResolveRuntimeRoot()
		end
		if v3 >= 1 then
			v3 = 0
			local SavedQualityLevel = UserGameSettings.SavedQualityLevel.Value
			v4 = if SavedQualityLevel <= 0 then 0.7 else math.clamp(SavedQualityLevel / 10, 0.45, 1)
		end
		if v1 < 0.03333333333333333 then
			return
		end
		local v52 = v1
		v1 = 0
		local CurrentCamera = workspace.CurrentCamera
		if not CurrentCamera then
			return
		end
		local v6 = v4
		if v5 then
			v6 = math.max(0.45, v4 * 0.72 * v62)
		end
		local v9 = (v6 * 0.22 + 0.82) * 500
		local v10 = v9 + 70
		local v11 = if v5 then math.max(20, (math.floor(v6 * 36 * v62 + 0.5))) else math.max(42, (math.floor(v6 * 84 + 0.5)))
		local v15 = if v5 then math.max(6, (math.floor(v6 * 10 * v62 + 0.5))) else math.max(10, (math.floor(v6 * 18 + 0.5)))
		local v19 = if v5 then math.max(1, (math.floor(v62 * 3 + 0.5))) else 6
		table.clear(t7)
		table.clear(t8)
		table.clear(t9)
		local Position = CurrentCamera.CFrame.Position
		local LookVector = CurrentCamera.CFrame.LookVector
		for i = #t2, 1, -1 do
			local v22, v23
			local v24 = t2[i]
			if v24.Folder.Parent and v24.SpawnPart.Parent then
				local v25 = v24.SpawnPart.CFrame
				local v26 = getSchoolDistance(Position, v24, v25)
				local v27 = v25:PointToWorldSpace(v24.BaseCenterLocal) - Position
				local v28 = if v26 <= 110 then true else false
				if not v28 and v27.Magnitude > 0.001 then
					v28 = if LookVector:Dot(v27.Unit) >= -0.1 then true else false
				end
				if v26 <= v9 and v28 then
					v24.OffscreenTime = 0
					local v33 = math.min(v24.FishCount, (math.max(3, (math.min(v15, (math.floor(math.sqrt(v24.FishCount) * (v6 * 0.35 + 1.55) + 0.5)))))))
					if v26 > 190 then
						v22, v23 = v33, math.max(3, (math.floor(v33 * 0.45 + 0.5)))
					elseif v26 > 110 then
						v22, v23 = v33, math.max(3, (math.floor(v33 * 0.7 + 0.5)))
					else
						v22 = v33
						v23 = v33
					end
					v24.TargetResidentCount = v22
					v24.DesiredActiveCount = 0
					v24.ComputedDesiredCap = math.min(v23, v24.FishCount)
					if v26 <= 110 then
						table.insert(t7, v24)
						continue
					end
					if v26 <= 190 then
						table.insert(t8, v24)
						continue
					end
					table.insert(t9, v24)
					continue
				end
				v24.DesiredActiveCount = 0
				v24.TargetResidentCount = 0
				if #v24.Fish ~= 0 then
					if v26 <= v10 then
						v24.OffscreenTime = 0
						continue
					end
					v24.OffscreenTime = v24.OffscreenTime + v52
					if v24.OffscreenTime >= 1 then
						unloadSchool(v24)
					end
				end
				continue
			end
			local Folder = v24.Folder
			local v41 = t3[Folder]
			local v42 = t4[Folder]
			if v41 and v42 then
				local v43 = #t2
				local v44 = t2[v43]
				t2[v42] = v44
				t2[v43] = nil
				t3[Folder] = nil
				t4[Folder] = nil
				if v44 and v44 ~= v41 then
					t4[v44.Folder] = v42
				end
				for v45, v46 in v41.Fish do
					v46.Model:Destroy()
				end
				v41.RenderFolder:Destroy()
			end
		end
		assignSchools(t9, false, (assignSchools(t8, false, (assignSchools(t7, false, (assignSchools(t9, true, (assignSchools(t8, true, (assignSchools(t7, true, v11)))))))))))
		for v47, v48 in t7 do
			v19 = ensureSchoolPool(v48, v19)
		end
		for v50, v51 in t8 do
			v19 = ensureSchoolPool(v51, v19)
		end
		for v53, v54 in t9 do
			v19 = ensureSchoolPool(v54, v19)
		end
		local v56 = os.clock()
		for v57, v58 in t2 do
			local v59 = v58.SpawnPart.CFrame
			applyActiveCount(v58, v56, v59)
			if v58.ActiveCount > 0 then
				updateSchoolTarget(v58, v52)
				for j = 1, v58.ActiveCount do
					local v60 = v58.Fish[j]
					if v60 then
						updateFish(v58, v60, v52, v56, v59)
					end
				end
			end
		end
	end)
end
return t