-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")
require("../types")
local v3 = require("../mod/utility")
local v4 = require("../pkg/Promise")
require("../obj/ObjectCache")
local v5 = Random.new()
local t = {}
local v6 = nil
function t.init(p1) --[[ init | Line: 17 | Upvalues: v6 (ref) ]]
	v6 = p1
end
function t.deinit() --[[ deinit | Line: 21 | Upvalues: v6 (ref) ]]
	v6 = nil
end
function t.emit(p1, p2, p3) --[[ emit | Line: 25 | Upvalues: v6 (ref), v1 (copy), CollectionService (copy), v3 (copy), v5 (copy), v2 (copy), v4 (copy) ]]
	if not v6 then
		return
	end
	local v12 = v1.get(p1, "RayDirection", Vector3.new(0, -50, 0))
	local v22 = v1.get(p1, "RayCollisionGroup", "Default")
	local v32 = v1.get(p1, "FilterTag", "")
	local v42 = v1.get(p1, "FilterType", "Exclude")
	local v52 = v1.get(p1, "IgnoreWater", true)
	local v62 = v1.get(p1, "IgnoreCanCollide", false)
	local v7 = RaycastParams.new()
	v7.CollisionGroup = v22
	v7.IgnoreWater = v52
	v7.RespectCanCollide = not v62
	v7.FilterType = Enum.RaycastFilterType[v42]
	v7.FilterDescendantsInstances = CollectionService:GetTagged(v32)
	if v42 == "Exclude" then
		v7:AddToFilter({ workspace.Terrain })
	end
	local v8 = v1.get(p2, "EmitDelay", 0)
	local v9 = v1.get(p2, "Radius", 5)
	local v10 = v1.get(p2, "Segments", 7)
	local v11 = v1.getRange(p2, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, (1 / 0)))
	local v122 = v1.get(p2, "PartOffset", Vector3.new(0, 0, 0), true)
	local v13 = v1.get(p2, "BaseOffset", v122)
	local v14 = v1.get(p2, "Offset_Start", v122)
	local v15 = v1.get(p2, "Offset_End", v122)
	local v16 = v1.get(p2, "Offset_Start_Duration", 0.5)
	local v17 = v1.get(p2, "Offset_End_Duration", 0.5)
	local v18 = v1.get(p2, "SizeScaleStart", Vector3.new(0, 0, 0))
	local v19 = v1.get(p2, "SizeScaleEnd", Vector3.new(0, 0, 0))
	local v20 = v1.get(p2, "MinSize", Vector3.new(2, 1, 2))
	local v21 = v1.get(p2, "MaxSize", Vector3.new(3, 2, 3))
	local v222 = v1.get(p2, "Size_Curve", v3.default_bezier, true)
	local v23 = v1.get(p2, "Size_Duration", 0.5, true)
	local v24 = v1.get(p2, "Size_Start_Curve", v222)
	local v25 = v1.get(p2, "Size_End_Curve", v222)
	local v26 = v1.get(p2, "Size_Start_Duration", v23)
	local v27 = v1.get(p2, "Size_End_Duration", v23)
	local v28 = v1.get(p2, "Transparency_Duration", 0.5)
	local v29 = v1.get(p2, "Transparency_Start", 0)
	local v30 = v1.get(p2, "Transparency_End", 0)
	task.wait(v8)
	local v31 = v3.getTransformedOriginExtents(p1)
	local t = {}
	local v322
	for i = 0, v10 - 1 do
		local v33 = i / v10 * math.pi * 2
		local v36 = workspace:Raycast((v31 * CFrame.new(v9 * math.cos(v33), 0, v9 * math.sin(v33))).Position, v31:VectorToWorldSpace(v12), v7)
		if v36 then
			local v37 = v5:NextNumber(v20.X, v21.X)
			local v38 = v5:NextNumber(v20.Y, v21.Y)
			local v39 = v5:NextNumber(v20.Z, v21.Z)
			local v40 = v3.getRandomId()
			local v41 = v6:get(v40)
			local v422 = v41._getReal()
			v3.copyProperties(p2, v422, v3.COPY_PART_PROPERTIES)
			v3.copyProperties(p2, v422, v3.COPY_EXTENDED_PART_PROPERTIES)
			if #p2:GetChildren() ~= 0 then
				local v43 = p2:Clone()
				for v44, v45 in v43:GetChildren() do
					v45.Parent = v422
				end
				v43:Destroy()
			end
			local v46 = p3.effects.prepareEmitOnFinish(v41, p3)
			local function f47() --[[ Line: 130 | Upvalues: v6 (ref), v40 (copy) ]]
				if not v6 then
					return
				end
				v6:free(v40)
			end
			table.insert(p3, f47)
			v41.Color = v36.Instance.Color
			v41.Material = v36.Material
			v41.Transparency = v36.Instance.Transparency
			if v41.Transparency == 0 then
				v41.Transparency = v29
			end
			v41.Size = Vector3.new(0, 0, 0)
			local Unit = v31:VectorToWorldSpace((Vector3.new(-math.cos(v33), 0, -math.sin(v33)))):Cross(v36.Normal).Unit
			local v50 = CFrame.fromMatrix(v36.Position, Unit, v36.Normal) * CFrame.fromOrientation(-math.atan(v38 / v39), 0, 0)
			v41.CFrame = CFrame.new(v14) * v50
			local v51 = nil
			local v522 = Vector3.new(0, 0, 0)
			if v14 == v13 then
				v322 = nil
			else
				v322 = v2.fromParams(v1.get(p2, "Offset_Start_Curve", v3.default_bezier), v16, function(p1, p2) --[[ Line: 166 | Upvalues: v522 (ref), v14 (copy), v13 (copy), v41 (copy), v50 (copy) ]]
					v522 = v14:Lerp(v13, p1)
					v41.CFrame = CFrame.new(v522) * v50
					return p2
				end)
				table.insert(p3, v51)
			end
			local v53 = Vector3.new(v37, v38, v39)
			if v53 * v18 == v53 then
				v41.Size = v53 * v18
			else
				v51 = v2.fromParams(v24, v26, function(p1, p2) --[[ Line: 179 | Upvalues: v41 (copy), v53 (copy), v18 (copy) ]]
					v41.Size = (v53 * v18):Lerp(v53, p1)
					return p2
				end)
				table.insert(p3, v51)
			end
			local Finished = p3.effects.emitNested(v41, p3.depth + 1, p3).Finished
			table.insert(t, Finished)
			task.delay(v5:NextNumber(v11.Min, v11.Max), function() --[[ Line: 192 | Upvalues: v51 (ref), v322 (ref), v41 (copy), v53 (copy), v19 (copy), p3 (copy), v2 (ref), v25 (copy), v27 (copy), v522 (ref), v15 (copy), v1 (ref), p2 (copy), v3 (ref), v17 (copy), v50 (copy), v30 (copy), v28 (copy), v46 (copy), t (copy) ]]
				if v51 then
					v51:Disconnect()
				end
				if v322 then
					v322:Disconnect()
				end
				local Size = v41.Size
				local Transparency = v41.Transparency
				if Size ~= v53 * v19 then
					local function f4(p1, p2) --[[ Line: 207 | Upvalues: v41 (ref), Size (copy), v53 (ref), v19 (ref) ]]
						v41.Size = Size:Lerp(v53 * v19, p1)
						return p2
					end
					table.insert(p3, v2.fromParams(v25, v27, f4))
				end
				if v522 ~= v15 then
					local function f8(p1, p2) --[[ Line: 220 | Upvalues: v41 (ref), v522 (ref), v15 (ref), v50 (ref) ]]
						v41.CFrame = CFrame.new(v522:Lerp(v15, p1)) * v50
						return p2
					end
					table.insert(p3, v2.fromParams(v1.get(p2, "Offset_End_Curve", v3.default_bezier), v17, f8))
				end
				local v10
				if Transparency ~= v30 then
					local v12 = v1.get(p2, "Transparency_Curve", v3.default_bezier)
					local function f14(p1, p2) --[[ Line: 234 | Upvalues: v41 (ref), v3 (ref), Transparency (copy), v30 (ref) ]]
						v41.Transparency = v3.lerp(Transparency, v30, p1)
						return p2
					end
					table.insert(p3, v2.fromParams(v12, v28, f14))
				end
				v10 = p3.effects.emitOnFinish(v46, v41, p3.depth + 1, p3).Finished
				table.insert(t, v10)
			end)
		end
	end
	task.wait(v11.Max + math.max(v27, v17))
	v4.all(t):await()
end
return t