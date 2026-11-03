-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")
require("../types")
local v3 = require("../mod/utility")
local v4 = require("../pkg/Promise")
require("../obj/ObjectCache")
local v5 = Random.new()
local t = {}
local t2 = {}
local v6 = nil
local v7 = nil
function t.init(p1) --[[ init | Line: 20 | Upvalues: v7 (ref), v6 (ref), v3 (copy), RunService (copy), t2 (copy) ]]
	if v7 then
		return
	end
	v6 = p1
	if not v3.PLUGIN_CONTEXT then
		return
	end
	v7 = RunService.RenderStepped:Connect(function(p1) --[[ Line: 28 | Upvalues: t2 (ref) ]]
		if #t2 ~= 0 then
			workspace:StepPhysics(p1, t2)
		end
	end)
end
function t.deinit() --[[ deinit | Line: 38 | Upvalues: v7 (ref), v6 (ref), t2 (copy) ]]
	if v7 then
		v7:Disconnect()
		v7 = nil
	end
	v6 = nil
	for v1, v2 in t2 do
		v2:Destroy()
	end
	table.clear(t2)
end
function t.emit(p1, p2, p3) --[[ emit | Line: 53 | Upvalues: v6 (ref), v1 (copy), CollectionService (copy), v5 (copy), v3 (copy), t2 (copy), v2 (copy), v4 (copy) ]]
	if not v6 then
		return
	end
	local v12 = v1.get(p2, "InheritanceEnabled", true)
	local v22 = v1.get(p2, "InheritanceRadius", 5)
	local v32 = v1.get(p1, "RayCollisionGroup", "Default")
	local v42 = v1.get(p1, "FilterTag", "")
	local v52 = v1.get(p1, "FilterType", "Exclude")
	local v62 = v1.get(p1, "IgnoreCanCollide", false)
	local v7
	if v12 then
		local v8 = v1.get(p2, "InheritanceMaxResults", 5)
		local v9 = OverlapParams.new()
		v9.MaxParts = v8
		v9.CollisionGroup = v32
		v9.RespectCanCollide = not v62
		v9.FilterType = Enum.RaycastFilterType[v52]
		v9.FilterDescendantsInstances = CollectionService:GetTagged(v42)
		if v52 == "Exclude" then
			v9:AddToFilter({ workspace.Terrain })
		end
		v7 = v9
	else
		v7 = nil
	end
	local v10 = v1.get(p2, "EmitDelay", 0)
	local v11 = v1.getRange(p2, "Amount", NumberRange.new(5, 10), NumberRange.new(0, (1 / 0)))
	local v122 = v1.getRange(p2, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, (1 / 0)))
	local v13 = v1.getRange(p2, "Airtime", NumberRange.new(0.5, 0.5), NumberRange.new(0, (1 / 0)))
	local v14 = v1.getRange(p2, "LinearMagnitude", NumberRange.new(15, 25))
	local v15 = v1.getRange(p2, "AngularMagnitude", NumberRange.new(5, 15))
	local v16 = v1.get(p2, "SizeScaleEnd", Vector3.new(0, 0, 0))
	local v17 = v1.get(p2, "MinSize", Vector3.new(2, 1, 2))
	local v18 = v1.get(p2, "MaxSize", Vector3.new(3, 2, 3))
	local v19 = v1.get(p2, "MinDirection", Vector3.new(-1, -1, -1))
	local v20 = v1.get(p2, "MaxDirection", Vector3.new(1, 1, 1))
	local v21 = v5:NextInteger(v11.Min, v11.Max)
	local v222 = v1.get(p2, "Size_Curve", v3.default_bezier)
	local v23 = v1.get(p2, "Transparency_Curve", v3.default_bezier)
	local v24 = v1.get(p2, "Transparency_Duration", 0.5)
	local v25 = v1.get(p2, "Size_Duration", 0.5)
	local v26 = v1.get(p2, "Transparency_Start", 0)
	local v27 = v1.get(p2, "Transparency_End", 1)
	local t = {}
	local t3 = {}
	p2.CanCollide = false
	local v28 = v3.getTransformedOriginExtents(p1)
	local Position = v28.Position
	if v7 then
		for v29, v30 in workspace:GetPartBoundsInRadius(Position, v22, v7) do
			if v30.Transparency ~= 1 then
				table.insert(t, v30)
			end
		end
	end
	task.wait(v10)
	for i = 1, v21 do
		local v31 = if #t == 0 then false else t[v5:NextInteger(1, #t)]
		local v322 = v3.getRandomId()
		local v33 = v6:get(v322)
		local v34 = v33._getReal()
		v3.copyProperties(p2, v34, v3.COPY_PART_PROPERTIES)
		v3.copyProperties(p2, v34, v3.COPY_EXTENDED_PART_PROPERTIES)
		if #p2:GetChildren() ~= 0 then
			local v35 = p2:Clone()
			for v36, v37 in v35:GetChildren() do
				v37.Parent = v34
			end
			v35:Destroy()
		end
		local v38 = p3.effects.prepareEmitOnFinish(v34, p3)
		local v39 = p3.effects.prepareEmitFolder(v34, "EmitOnImpact", p3)
		if v39 and #v39:GetChildren() > 0 then
			local v40 = nil
			v40 = v34.Touched:Connect(function(p1) --[[ Line: 162 | Upvalues: v62 (copy), v34 (copy), v52 (copy), v42 (copy), v40 (ref), p3 (copy), v39 (copy), t3 (copy) ]]
				if not (v62 or p1:CanCollideWith(v34)) then
					return
				end
				if not p1:IsDescendantOf(workspace.Terrain) and (v52 ~= "Exclude" or not p1:HasTag(v42)) then
					v40:Disconnect()
					local Finished = p3.effects.emitFromFolder(v39, v34, p3.depth + 1, p3).Finished
					table.insert(t3, Finished)
				end
			end)
			local function f41() --[[ Line: 177 | Upvalues: v40 (ref) ]]
				if not v40 then
					return
				end
				v40:Disconnect()
				v40 = nil
			end
			table.insert(p3, f41)
		end
		v33.Anchored = false
		v33.CanCollide = true
		if v33.CollisionGroup == "Default" then
			v33.CollisionGroup = "ForgeDebris"
		end
		v33.CFrame = CFrame.new(Position)
		local v45 = Vector3.new(v5:NextNumber(v17.X, v18.X), v5:NextNumber(v17.Y, v18.Y), v5:NextNumber(v17.Z, v18.Z))
		v33.Size = v45
		if v31 then
			v33.Material = v31.Material
			v33.Color = v31.Color
			v33.Transparency = v31.Transparency
		else
			v33.Transparency = v26
		end
		local function f46() --[[ Line: 210 | Upvalues: t2 (ref), v34 (copy), v6 (ref), v322 (copy) ]]
			local v1 = table.find(t2, v34)
			if v1 then
				table.remove(t2, v1)
			end
			if not v6 then
				return
			end
			v6:free(v322)
		end
		table.insert(p3, f46)
		local v47 = t2
		table.insert(v47, v34)
		v33.AssemblyLinearVelocity = v28:VectorToWorldSpace(v33.AssemblyLinearVelocity)
		local v48 = v28:VectorToWorldSpace((v3.randomUnitVector(v19, v20)))
		v33:ApplyImpulse(v33.AssemblyMass * v3.getImpulseForce(Position, Position + v48.Unit * v5:NextNumber(v14.Min, v14.Max), v5:NextNumber(v13.Min, v13.Max)))
		v33:ApplyAngularImpulse(v33.AssemblyMass * v5:NextUnitVector() * v5:NextNumber(v15.Min, v15.Max))
		local Finished = p3.effects.emitNested(v34, p3.depth + 1, p3).Finished
		table.insert(t3, Finished)
		task.delay(v5:NextNumber(v122.Min, v122.Max), function() --[[ Line: 243 | Upvalues: v33 (copy), v45 (copy), v16 (copy), p3 (copy), v2 (ref), v222 (copy), v25 (copy), v27 (copy), v23 (copy), v24 (copy), v3 (ref), v38 (copy), v34 (copy), t3 (copy) ]]
			local Size = v33.Size
			local Transparency = v33.Transparency
			if Size ~= v45 * v16 then
				local function f4(p1, p2) --[[ Line: 250 | Upvalues: v33 (ref), Size (copy), v45 (ref), v16 (ref) ]]
					v33.Size = Size:Lerp(v45 * v16, p1)
					return p2
				end
				table.insert(p3, v2.fromParams(v222, v25, f4))
			end
			local v6
			if Transparency ~= v27 then
				local function f10(p1, p2) --[[ Line: 260 | Upvalues: v33 (ref), v3 (ref), Transparency (copy), v27 (ref) ]]
					v33.Transparency = v3.lerp(Transparency, v27, p1)
					return p2
				end
				table.insert(p3, v2.fromParams(v23, v24, f10))
			end
			v6 = p3.effects.emitOnFinish(v38, v34, p3.depth + 1, p3).Finished
			table.insert(t3, v6)
		end)
	end
	task.wait(v122.Max + math.max(v24, v25))
	v4.all(t3):await()
end
return t