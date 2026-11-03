-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")
require("../types")
local v3 = require("../mod/logger")
local v4 = require("../mod/utility")
local v5 = require("../obj/Bezier")
local v6 = require("../pkg/Promise")
require("../obj/ObjectCache")
local v7 = Random.new()
local t = {}
local v8 = nil
function t.init(p1) --[[ init | Line: 19 | Upvalues: v8 (ref) ]]
	v8 = p1
end
function t.deinit() --[[ deinit | Line: 23 | Upvalues: v8 (ref) ]]
	v8 = nil
end
function t.emit(p1, p2, p3) --[[ emit | Line: 27 | Upvalues: v8 (ref), v1 (copy), CollectionService (copy), v4 (copy), v2 (copy), v3 (copy), v5 (copy), v7 (copy), v6 (copy) ]]
	if not v8 then
		return
	end
	local v12 = v1.get(p1, "RayDirection", Vector3.new(0, -50, 0))
	local v22 = v1.get(p1, "RayCollisionGroup", "Default")
	local v32 = v1.get(p1, "FilterTag", "")
	local v42 = v1.get(p1, "FilterType", "Exclude")
	local v52 = v1.get(p1, "IgnoreWater", true)
	local v62 = v1.get(p1, "IgnoreCanCollide", false)
	local v72 = RaycastParams.new()
	v72.CollisionGroup = v22
	v72.IgnoreWater = v52
	v72.RespectCanCollide = not v62
	v72.FilterType = Enum.RaycastFilterType[v42]
	v72.FilterDescendantsInstances = CollectionService:GetTagged(v32)
	if v42 == "Exclude" then
		v72:AddToFilter({ workspace.Terrain })
	end
	local v82 = v1.get(p2, "EmitDelay", 0)
	local v9 = v1.get(p2, "Rate_Start", 30)
	local v10 = v1.get(p2, "Rate_End", 30)
	local v11 = v1.get(p2, "FixedAmount", 0)
	local v122 = v1.get(p2, "Scale_Start", 1)
	local v13 = v1.get(p2, "Scale_End", 1)
	local v14 = v1.get(p2, "Duration", 1)
	local v15 = v1.get(p2, "Direction", Vector3.new(0, 0, -1))
	local v16 = v1.get(p2, "Length", 50)
	local v17 = v1.getRange(p2, "Rotation", NumberRange.new(-180, 180))
	local v18 = v1.get(p2, "PartOffset", Vector3.new(0, 0, 0), true)
	local v19 = v1.get(p2, "BaseOffset", v18)
	local v20 = v1.get(p2, "Offset_Start", v18)
	local v21 = v1.get(p2, "Offset_End", v18)
	local v222 = v1.get(p2, "Offset_Start_Duration", 0.5)
	local v23 = v1.get(p2, "Offset_End_Duration", 0.5)
	local v24 = v1.getRange(p2, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, (1 / 0)))
	local v25 = v1.get(p2, "SizeScaleStart", Vector3.new(0, 0, 0))
	local v26 = v1.get(p2, "SizeScaleEnd", Vector3.new(0, 0, 0))
	local v27 = v1.get(p2, "MinSize", Vector3.new(2, 1, 2))
	local v28 = v1.get(p2, "MaxSize", Vector3.new(3, 2, 3))
	local v29 = v1.get(p2, "Size_Curve", v4.default_bezier, true)
	local v30 = v1.get(p2, "Size_Duration", 0.5, true)
	local v31 = v1.get(p2, "Size_Start_Curve", v29)
	local v322 = v1.get(p2, "Size_End_Curve", v29)
	local v33 = v1.get(p2, "Size_Start_Duration", v30)
	local v34 = v1.get(p2, "Size_End_Duration", v30)
	local v35 = v1.get(p2, "Transparency_Duration", 0.5)
	local v36 = v1.get(p2, "Transparency_Start", 0)
	local v37 = v1.get(p2, "Transparency_End", 0)
	local v38 = v1.get(p2, "SyncPosition", false)
	local v39 = math.max(v14, 0.001)
	if v11 > 0 then
		local v40 = v11 / v39
		v9 = v40
		v10 = v40
	end
	local Unit = v15.Unit
	if Unit ~= Unit then
		Unit = Vector3.new(-0, -0, -1)
	end
	task.wait(v82)
	local t = {}
	local v41 = v4.getTransformedOriginExtents(p1)
	local v422 = 0
	local v43 = 0
	local v44 = v9
	local v45 = v122
	if v122 ~= v13 then
		local v46 = v1.get(p2, "Scale_Curve", v4.default_bezier)
		local function f47(p1, p2) --[[ Line: 131 | Upvalues: v45 (ref), v4 (ref), v122 (copy), v13 (copy) ]]
			v45 = v4.lerp(v122, v13, p1)
			return p2
		end
		table.insert(p3, v2.fromParams(v46, v39, f47))
	end
	if v9 ~= v10 then
		local v48 = v1.get(p2, "Rate_Curve", v4.default_bezier)
		local function f49(p1, p2) --[[ Line: 141 | Upvalues: v44 (ref), v4 (ref), v9 (ref), v10 (ref) ]]
			v44 = v4.lerp(v9, v10, p1)
			return p2
		end
		table.insert(p3, v2.fromParams(v48, v39, f49))
	end
	local v50 = v1.get(p2, "Path_Curve", v4.linear_bezier)
	local v51, v522 = pcall(function() --[[ Line: 150 | Upvalues: v4 (ref), v50 (copy) ]]
		return v4.deserializePath(v50)
	end)
	if not v51 then
		v3.error((("failed to decode bezier path data with error: %*"):format(v522)))
	end
	local v53 = v5.new(v522, 0)
	local fromParams = v2.fromParams
	local linear_bezier = v4.linear_bezier
	local function f54(p12, p22) --[[ Line: 162 | Upvalues: v422 (ref), v44 (ref), v39 (ref), v43 (ref), v53 (copy), v38 (copy), v41 (ref), v4 (ref), p1 (copy), Unit (ref), v16 (copy), v12 (copy), v72 (copy), v7 (ref), v27 (copy), v28 (copy), v8 (ref), p2 (copy), p3 (copy), v36 (copy), v17 (copy), v20 (copy), v19 (copy), v2 (ref), v1 (ref), v222 (copy), v45 (ref), v25 (copy), v31 (copy), v33 (copy), t (copy), v24 (copy), v26 (copy), v322 (copy), v34 (copy), v21 (copy), v23 (copy), v37 (copy), v35 (copy) ]]
		v422 = v422 + p22
		local v13 = 1 / v44
		local v22 = v39 * v44
		if v422 < v13 or v22 <= v43 then
			return p22
		end
		local v3
		for i = 1, v422 // v13 do
			if not (v22 <= v43) then
				v43 = v43 + 1
				local v5 = 1 - v53:getEase((math.clamp(v43 / v22, 0, 1))).y
				if v38 then
					v41 = v4.getTransformedOriginExtents(p1)
				end
				local v6 = v4.getTransformedOriginExtents(p1)
				local v73 = workspace:Raycast(v41.Position + v41:VectorToWorldSpace(Unit) * v16 * v5, v6:VectorToWorldSpace(v12), v72)
				if not v73 then
					v422 = 0
					return p22
				end
				local v82 = v7:NextNumber(v27.X, v28.X)
				local v9 = v7:NextNumber(v27.Y, v28.Y)
				local v10 = v7:NextNumber(v27.Z, v28.Z)
				local v11 = v4.getRandomId()
				local v122 = v8:get(v11)
				local v132 = v122._getReal()
				v4.copyProperties(p2, v132, v4.COPY_PART_PROPERTIES)
				v4.copyProperties(p2, v132, v4.COPY_EXTENDED_PART_PROPERTIES)
				if #p2:GetChildren() ~= 0 then
					local v14 = p2:Clone()
					for v15, v162 in v14:GetChildren() do
						v162.Parent = v132
					end
					v14:Destroy()
				end
				local v172 = p3.effects.prepareEmitOnFinish(v132, p3)
				local v18 = p3
				local function f19() --[[ Line: 226 | Upvalues: v8 (ref), v11 (copy) ]]
					if not v8 then
						return
					end
					v8:free(v11)
				end
				table.insert(v18, f19)
				v122.Color = v73.Instance.Color
				v122.Material = v73.Material
				v122.Transparency = v73.Instance.Transparency
				if v122.Transparency == 0 then
					v122.Transparency = v36
				end
				v122.Size = Vector3.new(0, 0, 0)
				local v202 = v7:NextNumber(v17.Min, v17.Max)
				local Unit_2 = v6:VectorToWorldSpace((Vector3.new(-math.cos(v202), 0, -math.sin(v202)))):Cross(v73.Normal).Unit
				local v232 = CFrame.fromMatrix(v73.Position, Unit_2, v73.Normal) * CFrame.fromOrientation(-math.atan(v9 / v10), 0, 0)
				v122.CFrame = CFrame.new(v20) * v232
				local v242 = nil
				local v252 = Vector3.new(0, 0, 0)
				if v20 == v19 then
					v3 = nil
				else
					v3 = v2.fromParams(v1.get(p2, "Offset_Start_Curve", v4.default_bezier), v222, function(p1, p2) --[[ Line: 264 | Upvalues: v252 (ref), v20 (ref), v19 (ref), v122 (copy), v232 (copy) ]]
						v252 = v20:Lerp(v19, p1)
						v122.CFrame = CFrame.new(v252) * v232
						return p2
					end)
					table.insert(p3, v3)
				end
				local v272 = Vector3.new(v82, v9, v10) * v45
				if v272 * v25 == v272 then
					v122.Size = v272 * v25
				else
					v242 = v2.fromParams(v31, v33, function(p1, p2) --[[ Line: 277 | Upvalues: v122 (copy), v272 (copy), v25 (ref) ]]
						v122.Size = (v272 * v25):Lerp(v272, p1)
						return p2
					end)
					table.insert(p3, v242)
				end
				local v29 = t
				local Finished = p3.effects.emitNested(v132, p3.depth + 1, p3).Finished
				table.insert(v29, Finished)
				task.delay(v7:NextNumber(v24.Min, v24.Max), function() --[[ Line: 290 | Upvalues: v242 (ref), v3 (ref), v122 (copy), v272 (copy), v26 (ref), p3 (ref), v2 (ref), v322 (ref), v34 (ref), v252 (ref), v21 (ref), v1 (ref), p2 (ref), v4 (ref), v23 (ref), v232 (copy), v37 (ref), v35 (ref), v172 (copy), v132 (copy), t (ref) ]]
					if v242 then
						v242:Disconnect()
					end
					if v3 then
						v3:Disconnect()
					end
					local Size = v122.Size
					local Transparency = v122.Transparency
					if Size ~= v272 * v26 then
						local function f4(p1, p2) --[[ Line: 305 | Upvalues: v122 (ref), Size (copy), v272 (ref), v26 (ref) ]]
							v122.Size = Size:Lerp(v272 * v26, p1)
							return p2
						end
						table.insert(p3, v2.fromParams(v322, v34, f4))
					end
					if v252 ~= v21 then
						local function f8(p1, p2) --[[ Line: 318 | Upvalues: v122 (ref), v252 (ref), v21 (ref), v232 (ref) ]]
							v122.CFrame = CFrame.new(v252:Lerp(v21, p1)) * v232
							return p2
						end
						table.insert(p3, v2.fromParams(v1.get(p2, "Offset_End_Curve", v4.default_bezier), v23, f8))
					end
					local v10
					if Transparency ~= v37 then
						local v12 = v1.get(p2, "Transparency_Curve", v4.default_bezier)
						local function f14(p1, p2) --[[ Line: 332 | Upvalues: v122 (ref), v4 (ref), Transparency (copy), v37 (ref) ]]
							v122.Transparency = v4.lerp(Transparency, v37, p1)
							return p2
						end
						table.insert(p3, v2.fromParams(v12, v35, f14))
					end
					v10 = p3.effects.emitOnFinish(v172, v132, p3.depth + 1, p3).Finished
					table.insert(t, v10)
				end)
			end
		end
		v422 = v422 % v13
		return p22
	end
	local v55 = v4.RENDER_PRIORITY + p3.depth
	table.insert(p3, fromParams(linear_bezier, v39, f54, nil, nil, true, v55))
	task.wait(v24.Max + v39 + math.max(v34, v23))
	v6.all(t):await()
end
return t