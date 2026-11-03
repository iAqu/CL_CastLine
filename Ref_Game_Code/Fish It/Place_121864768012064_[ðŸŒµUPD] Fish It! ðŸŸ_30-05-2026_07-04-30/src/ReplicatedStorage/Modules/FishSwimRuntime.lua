-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local t = {}
t.__index = t
t.Priorty = {
	Extreme = 3,
	Medium = 2,
	Low = 1
}
local v1 = Random.new()
local function getFirstBasePart(p1) --[[ getFirstBasePart | Line: 23 ]]
	if p1:IsA("BasePart") then
		return p1
	end
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			return v
		end
	end
	return nil
end
local function getHandlePart(p1) --[[ getHandlePart | Line: 37 ]]
	local Handle = p1:FindFirstChild("Handle", true)
	if Handle and Handle:IsA("BasePart") then
		return Handle
	else
		return nil
	end
end
local function setModelStatic(p1) --[[ setModelStatic | Line: 46 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = false
			v.Massless = true
		end
	end
end
local function unitOr(p1, p2) --[[ unitOr | Line: 58 ]]
	if p1.Magnitude <= 0.001 then
		return p2
	else
		return p1.Unit
	end
end
local function clampPitch(p1) --[[ clampPitch | Line: 66 ]]
	local v1 = if p1.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else p1.Unit
	local v2 = math.clamp(v1.Y, -0.20791169081775934, 0.20791169081775934)
	local v3 = Vector3.new(v1.X, 0, v1.Z)
	local v4 = if v3.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else v3.Unit
	local v6 = math.sqrt((math.max(0, 1 - v2 * v2)))
	return Vector3.new(v4.X * v6, v2, v4.Z * v6)
end
local function clampLocal(p1, p2) --[[ clampLocal | Line: 76 ]]
	return Vector3.new(math.clamp(p1.X, -p2.X, p2.X), math.clamp(p1.Y, -p2.Y, p2.Y), (math.clamp(p1.Z, -p2.Z, p2.Z)))
end
local function randomLocal(p1) --[[ randomLocal | Line: 84 | Upvalues: v1 (copy) ]]
	return Vector3.new(v1:NextNumber(-p1.X, p1.X), v1:NextNumber(-p1.Y, p1.Y), v1:NextNumber(-p1.Z, p1.Z))
end
local function spreadLocal(p1, p2) --[[ spreadLocal | Line: 92 ]]
	return Vector3.new((p2 * 0.754877666 % 1 * 2 - 1) * p1.X, (p2 * 0.569840291 % 1 * 2 - 1) * p1.Y, (p2 * 0.438579011 % 1 * 2 - 1) * p1.Z)
end
local function createCFrame(p1, p2) --[[ createCFrame | Line: 99 ]]
	local v1 = if p2.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else p2.Unit
	local v2 = v1:Cross(Vector3.new(0, 1, 0))
	if v2.Magnitude <= 0.001 then
		v2 = v1:Cross(Vector3.new(0, 0, 1))
	end
	local v4 = if v2.Magnitude <= 0.001 then Vector3.new(1, 0, 0) else v2.Unit
	local Unit = v4:Cross(v1).Unit
	return CFrame.fromMatrix(p1, v4, Unit, -v1)
end
local function getRotationOffset(p1) --[[ getRotationOffset | Line: 113 | Upvalues: createCFrame (copy) ]]
	local v1 = p1:GetPivot()
	return createCFrame(v1.Position, v1.LookVector):ToObjectSpace(v1)
end
local function prepareModel(p1) --[[ prepareModel | Line: 119 | Upvalues: getFirstBasePart (copy), setModelStatic (copy) ]]
	local Handle = p1:FindFirstChild("Handle", true)
	local v1 = (if Handle and Handle:IsA("BasePart") then Handle else nil) or p1.PrimaryPart or getFirstBasePart(p1)
	if v1 then
		p1.PrimaryPart = v1
		setModelStatic(p1)
		return true
	else
		return false
	end
end
local function fitModelToContainer(p1, p2) --[[ fitModelToContainer | Line: 130 ]]
	local _, v1 = p1:GetBoundingBox()
	local v2 = p2 * 2 * 0.7
	local v6 = math.min(1, v2.X / math.max(v1.X, 0.001), v2.Y / math.max(v1.Y, 0.001), v2.Z / math.max(v1.Z, 0.001))
	if v6 < 1 then
		p1:ScaleTo(p1:GetScale() * v6)
		local _2, v7 = p1:GetBoundingBox()
		v1 = v7
	end
	return v1
end
local function getHalfSize(p1, p2) --[[ getHalfSize | Line: 148 ]]
	local sum = p1.Size * 0.5 - Vector3.new(1.25, 1.25, 1.25)
	if p2 then
		sum = sum - p2 * 0.5
	end
	return Vector3.new(math.max(sum.X, 1), math.max(sum.Y, 1), (math.max(sum.Z, 1)))
end
local function randomTarget(p1, p2, p3, p4) --[[ randomTarget | Line: 157 | Upvalues: v1 (copy) ]]
	local v3 = math.min(10, (math.max(4, p1.Magnitude * 0.28)))
	for i = 1, 6 do
		local v4
		if p3 and p4 then
			local v9 = p3 + Vector3.new(v1:NextNumber(-p4.X, p4.X), v1:NextNumber(-p4.Y, p4.Y), v1:NextNumber(-p4.Z, p4.Z))
			v4 = Vector3.new(math.clamp(v9.X, -p1.X, p1.X), math.clamp(v9.Y, -p1.Y, p1.Y), (math.clamp(v9.Z, -p1.Z, p1.Z)))
		else
			v4 = Vector3.new(v1:NextNumber(-p1.X, p1.X), v1:NextNumber(-p1.Y, p1.Y), v1:NextNumber(-p1.Z, p1.Z))
		end
		if v3 <= (v4 - p2).Magnitude then
			return v4
		end
	end
	if p3 and p4 then
		local v25 = p3 + Vector3.new(v1:NextNumber(-p4.X, p4.X), v1:NextNumber(-p4.Y, p4.Y), v1:NextNumber(-p4.Z, p4.Z))
		return Vector3.new(math.clamp(v25.X, -p1.X, p1.X), math.clamp(v25.Y, -p1.Y, p1.Y), (math.clamp(v25.Z, -p1.Z, p1.Z)))
	else
		return Vector3.new(v1:NextNumber(-p1.X, p1.X), v1:NextNumber(-p1.Y, p1.Y), v1:NextNumber(-p1.Z, p1.Z))
	end
end
local function countContainerItems(p1, p2) --[[ countContainerItems | Line: 169 ]]
	local count = 0
	for i, v in ipairs(p1) do
		if v.Container == p2 then
			count = count + 1
		end
	end
	return count
end
local function chooseContainer(p1, p2) --[[ chooseContainer | Line: 180 ]]
	local v1 = p2[1]
	local v2, count = v1, 0
	for i, v in ipairs(p1) do
		if v.Container == v2 then
			count = count + 1
		end
	end
	local v3 = count
	for i = 2, #p2 do
		local v4 = p2[i]
		local count_2 = 0
		for i2, v in ipairs(p1) do
			if v.Container == v4 then
				count_2 = count_2 + 1
			end
		end
		if count_2 < v3 then
			v3 = count_2
			v1 = v4
		end
	end
	return v1, v3
end
local function getPriorityEnum(p1) --[[ getPriorityEnum | Line: 195 | Upvalues: t (copy) ]]
	if not p1 then
		return t.Priorty.Low
	end
	local v1 = t.Priorty[p1]
	if v1 then
		return v1
	end
	for v2, v3 in t.Priorty do
		if v3 == p1 then
			return v3
		end
	end
	return t.Priorty.Low
end
function t.new(p1, p2) --[[ new | Line: 214 | Upvalues: t (copy), RunService (copy) ]]
	local v2 = setmetatable({}, t)
	local FishSwimRuntime = Instance.new("Folder")
	FishSwimRuntime.Name = "FishSwimRuntime"
	FishSwimRuntime.Parent = p1
	v2.Folder = FishSwimRuntime
	v2.Items = {}
	v2.ItemByKey = {}
	v2.Elapsed = 0
	local v3
	if p2 then
		local v4 = t.Priorty[p2]
		if v4 then
			v3 = v4
		else
			do
				local __inline_returned = false
				for v5, v6 in t.Priorty do
					if v6 == p2 then
						v3 = v6
						__inline_returned = true
						break
					end
				end
				if not __inline_returned then
					v3 = t.Priorty.Low
				end
			end
		end
	else
		v3 = t.Priorty.Low
	end
	v2.Priorty = v3
	if v2.Priorty == t.Priorty.Extreme then
		RunService:BindToRenderStep("PriortyExtremeFishSwim", Enum.RenderPriority.Camera.Value, function(p1) --[[ Line: 228 | Upvalues: v2 (copy) ]]
			v2:Update(p1)
		end)
		function v2.Disconnect() --[[ Line: 232 | Upvalues: RunService (ref) ]]
			RunService:UnbindFromRenderStep("PriortyExtremeFishSwim")
		end
		return v2
	end
	if v2.Priorty == t.Priorty.Medium then
		local v7 = RunService.PreRender:Connect(function(p1) --[[ Line: 237 | Upvalues: v2 (copy) ]]
			v2:Update(p1)
		end)
		function v2.Disconnect() --[[ Line: 241 | Upvalues: v7 (copy) ]]
			v7:Disconnect()
		end
	else
		local v8 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 246 | Upvalues: v2 (copy) ]]
			v2:Update(p1)
		end)
		function v2.Disconnect() --[[ Line: 250 | Upvalues: v8 (copy) ]]
			v8:Disconnect()
		end
	end
	return v2
end
function t.Destroy(p1) --[[ Destroy | Line: 258 ]]
	if p1.Disconnect then
		p1.Disconnect()
	end
	if p1.Folder then
		p1.Folder:Destroy()
		p1.Folder = nil
	end
	table.clear(p1.Items)
	table.clear(p1.ItemByKey)
end
function t.Clear(p1) --[[ Clear | Line: 272 ]]
	for i, v in ipairs(p1.Items) do
		v.Model:Destroy()
	end
	table.clear(p1.Items)
	table.clear(p1.ItemByKey)
end
function t.RemoveFish(p1, p2) --[[ RemoveFish | Line: 281 ]]
	local v1 = p1.ItemByKey[p2]
	if not v1 then
		return
	end
	p1.ItemByKey[p2] = nil
	local v2 = table.find(p1.Items, v1)
	if not v2 then
		v1.Model:Destroy()
		return
	end
	table.remove(p1.Items, v2)
	v1.Model:Destroy()
end
function t.AddFish(p1, p2, p3, p4) --[[ AddFish | Line: 296 | Upvalues: getFirstBasePart (copy), setModelStatic (copy), chooseContainer (copy), fitModelToContainer (copy), v1 (copy), randomTarget (copy), clampPitch (copy), createCFrame (copy) ]]
	if #p3 ~= 0 then
		local Handle = p2:FindFirstChild("Handle", true)
		local v12 = if Handle and Handle:IsA("BasePart") then Handle else nil
		if not v12 then
			v12 = p2.PrimaryPart or getFirstBasePart(p2)
		end
		local v2
		if v12 then
			p2.PrimaryPart = v12
			setModelStatic(p2)
			v2 = true
		else
			v2 = false
		end
		if v2 then
			if p4 then
				p1:RemoveFish(p4)
			end
			local v3, v4 = chooseContainer(p1.Items, p3)
			local v5 = v3.Size * 0.5 - Vector3.new(1.25, 1.25, 1.25)
			local v9 = fitModelToContainer(p2, (Vector3.new(math.max(v5.X, 1), math.max(v5.Y, 1), (math.max(v5.Z, 1)))))
			local sum = v3.Size * 0.5 - Vector3.new(1.25, 1.25, 1.25)
			if v9 then
				sum = sum - v9 * 0.5
			end
			local v13 = Vector3.new(math.max(sum.X, 1), math.max(sum.Y, 1), (math.max(sum.Z, 1)))
			local v14 = v13 * 0.72
			local v15 = v4 + 1
			local v19 = Vector3.new((v15 * 0.754877666 % 1 * 2 - 1) * v14.X, (v15 * 0.569840291 % 1 * 2 - 1) * v14.Y, (v15 * 0.438579011 % 1 * 2 - 1) * v14.Z)
			local v26 = Vector3.new(math.max(v13.X * 0.34, 1), math.max(v13.Y * 0.34, 1), (math.max(v13.Z * 0.34, 1)))
			local v31 = v19 + Vector3.new(v1:NextNumber(-v26.X, v26.X), v1:NextNumber(-v26.Y, v26.Y), v1:NextNumber(-v26.Z, v26.Z))
			local v38 = Vector3.new(math.clamp(v31.X, -v13.X, v13.X), math.clamp(v31.Y, -v13.Y, v13.Y), (math.clamp(v31.Z, -v13.Z, v13.Z)))
			local v39 = randomTarget(v13, v38, v19, v26)
			local v41 = v39 - v38
			local v43 = clampPitch(if v41.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else v41.Unit)
			local v44 = v1:NextNumber(2.6, 5.4)
			local v45 = p2:GetPivot()
			local v46 = createCFrame(v45.Position, v45.LookVector):ToObjectSpace(v45)
			p2.Parent = p1.Folder
			p2:PivotTo(createCFrame(v3.CFrame:PointToWorldSpace(v38), v3.CFrame:VectorToWorldSpace(v43)) * v46)
			local t = {
				TargetAge = 0,
				Key = p4,
				Model = p2,
				Container = v3,
				HalfSize = v13,
				Home = v19,
				RoamHalfSize = v26,
				Position = v38,
				Target = v39,
				Direction = v43,
				Velocity = v43 * v44,
				Speed = v44,
				Turn = v1:NextNumber(1.4, 2.2),
				BobPhase = v1:NextNumber(0, 6.283185307179586),
				BobAmplitude = v1:NextNumber(0.015, 0.045),
				RotationOffset = v46
			}
			table.insert(p1.Items, t)
			if not p4 then
				return
			end
			p1.ItemByKey[p4] = t
			return
		end
	end
	p2:Destroy()
end
function t.Update(p1, p2) --[[ Update | Line: 350 | Upvalues: t (copy), randomTarget (copy), clampPitch (copy), createCFrame (copy) ]]
	p1.Elapsed = p1.Elapsed + p2
	if p1.Priorty == t.Priorty.Low and p1.Elapsed < 0.03333333333333333 then
		return
	end
	local Elapsed = p1.Elapsed
	p1.Elapsed = 0
	local v1 = os.clock()
	for i = #p1.Items, 1, -1 do
		local v2 = p1.Items[i]
		if v2.Container.Parent then
			local v3 = v2.Target - v2.Position
			v2.TargetAge = v2.TargetAge + Elapsed
			if math.max(2, v2.Speed * Elapsed * 1.5) >= v3.Magnitude or v2.TargetAge >= 7 then
				v2.Target = randomTarget(v2.HalfSize, v2.Position, v2.Home, v2.RoamHalfSize)
				v2.TargetAge = 0
				v3 = v2.Target - v2.Position
			end
			local v7 = clampPitch(if v3.Magnitude <= 0.001 then v2.Direction else v3.Unit)
			local v11 = v2.Direction:Lerp(v7, 1 - math.exp(-v2.Turn * Elapsed))
			v2.Direction = clampPitch(if v11.Magnitude <= 0.001 then v7 else v11.Unit)
			v2.Velocity = v2.Velocity:Lerp(v2.Direction * v2.Speed, 1 - math.exp(-3.6 * Elapsed))
			local v13 = v2.Position + v2.Velocity * Elapsed
			local HalfSize = v2.HalfSize
			local v20 = Vector3.new(math.clamp(v13.X, -HalfSize.X, HalfSize.X), math.clamp(v13.Y, -HalfSize.Y, HalfSize.Y), (math.clamp(v13.Z, -HalfSize.Z, HalfSize.Z)))
			if (v20 - v13).Magnitude > 0.001 then
				v2.Target = randomTarget(v2.HalfSize, v20, v2.Home, v2.RoamHalfSize)
				v2.TargetAge = 0
				local v22 = v2.Target - v20
				v2.Direction = clampPitch(if v22.Magnitude <= 0.001 then -v2.Direction else v22.Unit)
				v2.Velocity = v2.Direction * v2.Speed
			end
			v2.Position = v20
			local v28 = Vector3.new(0, math.sin(v1 * 1.7 + v2.BobPhase) * v2.BobAmplitude, 0)
			v2.Model:PivotTo(createCFrame(v2.Container.CFrame:PointToWorldSpace(v2.Position) + v2.Container.CFrame:VectorToWorldSpace(v28), (v2.Container.CFrame:VectorToWorldSpace(v2.Direction))) * v2.RotationOffset)
			continue
		end
		if v2.Key then
			p1.ItemByKey[v2.Key] = nil
		end
		v2.Model:Destroy()
		table.remove(p1.Items, i)
	end
end
return t