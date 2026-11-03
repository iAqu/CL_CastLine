-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local v1 = require("../mod/tween")
local v2 = require("../mod/utility")
local v3 = require("../pkg/Promise")
require("../obj/ObjectCache")
local v4 = Random.new()
local t = {}
local v5 = nil
function t.init(p1) --[[ init | Line: 15 | Upvalues: v5 (ref) ]]
	v5 = p1
end
function t.deinit() --[[ deinit | Line: 19 | Upvalues: v5 (ref) ]]
	v5 = nil
end
function t.emit(p1, p2, p3) --[[ emit | Line: 23 | Upvalues: v5 (ref), v2 (copy), CollectionService (copy), v4 (copy), v1 (copy), v3 (copy) ]]
	if v5 then
		local v12 = v2.getAttribute(p1, "RayDirection", Vector3.new(0, -50, 0))
		local v22 = v2.getAttribute(p1, "RayCollisionGroup", "Default")
		local v32 = v2.getAttribute(p1, "FilterTag", "")
		local v42 = v2.getAttribute(p1, "FilterType", "Exclude")
		local v52 = v2.getAttribute(p1, "IgnoreWater", true)
		local v6 = v2.getAttribute(p1, "IgnoreCanCollide", false)
		local v7 = RaycastParams.new()
		v7.CollisionGroup = v22
		v7.IgnoreWater = v52
		v7.RespectCanCollide = not v6
		v7.FilterType = Enum.RaycastFilterType[v42]
		v7.FilterDescendantsInstances = CollectionService:GetTagged(v32)
		if v42 == "Exclude" then
			v7:AddToFilter({ workspace.Terrain })
		end
		local v8 = v2.getAttribute(p2, "EmitDelay", 0)
		local v9 = v2.getAttribute(p2, "Radius", 5)
		local v10 = v2.getAttribute(p2, "Segments", 7)
		local v11 = v2.getRangeAttribute(p2, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, (1 / 0)))
		local v122 = v2.getAttribute(p2, "PartOffset", Vector3.new(0, 0, 0), true)
		local v13 = v2.getAttribute(p2, "BaseOffset", v122)
		local v14 = v2.getAttribute(p2, "Offset_Start", v122)
		local v15 = v2.getAttribute(p2, "Offset_End", v122)
		local v16 = v2.getAttribute(p2, "Offset_Start_Duration", 0.5)
		local v17 = v2.getAttribute(p2, "Offset_End_Duration", 0.5)
		local v18 = v2.getAttribute(p2, "SizeScaleStart", Vector3.new(0, 0, 0))
		local v19 = v2.getAttribute(p2, "SizeScaleEnd", Vector3.new(0, 0, 0))
		local v20 = v2.getAttribute(p2, "MinSize", Vector3.new(2, 1, 2))
		local v21 = v2.getAttribute(p2, "MaxSize", Vector3.new(3, 2, 3))
		local v222 = v2.getAttribute(p2, "Size_Curve", v2.default_bezier, true)
		local v23 = v2.getAttribute(p2, "Size_Duration", 0.5, true)
		local v24 = v2.getAttribute(p2, "Size_Start_Curve", v222)
		local v25 = v2.getAttribute(p2, "Size_End_Curve", v222)
		local v26 = v2.getAttribute(p2, "Size_Start_Duration", v23)
		local v27 = v2.getAttribute(p2, "Size_End_Duration", v23)
		local v28 = v2.getAttribute(p2, "Transparency_Duration", 0.5)
		local v29 = v2.getAttribute(p2, "Transparency_Start", 0)
		local v30 = v2.getAttribute(p2, "Transparency_End", 0)
		task.wait(v8)
		local t = {}
		local v31, v322, v33
		for i = 0, v10 - 1 do
			local v34 = i / v10 * math.pi * 2
			local v37 = workspace:Raycast((p1.WorldCFrame * CFrame.new(v9 * math.cos(v34), 0, v9 * math.sin(v34))).Position, p1.WorldCFrame:VectorToWorldSpace(v12), v7)
			if v37 then
				local v38 = v4:NextNumber(v20.X, v21.X)
				local v39 = v4:NextNumber(v20.Y, v21.Y)
				local v40 = v4:NextNumber(v20.Z, v21.Z)
				local v41 = v2.getRanomId()
				local v422 = v5:get(v41)
				local v43 = v422._getReal()
				v2.copyProperties(p2, v43, v2.COPY_PART_PROPERTIES)
				v2.copyProperties(p2, v43, v2.COPY_EXTENDED_PART_PROPERTIES)
				if #p2:GetChildren() ~= 0 then
					local v44 = p2:Clone()
					for v45, v46 in v44:GetChildren() do
						v46.Parent = v43
					end
					v44:Destroy()
				end
				local function f47() --[[ Line: 128 | Upvalues: v5 (ref), v41 (copy) ]]
					if v5 then
						v5:free(v41)
					end
				end
				table.insert(p3, f47)
				v422.Color = v37.Instance.Color
				v422.Material = v37.Material
				v422.Transparency = v37.Instance.Transparency
				if v422.Transparency == 0 then
					v422.Transparency = v29
				end
				v422.Size = Vector3.new(0, 0, 0)
				local Unit = p1.WorldCFrame:VectorToWorldSpace((Vector3.new(-math.cos(v34), 0, -math.sin(v34)))):Cross(v37.Normal).Unit
				local v50 = CFrame.fromMatrix(v37.Position, Unit, v37.Normal) * CFrame.fromOrientation(-math.atan(v39 / v40), 0, 0)
				v422.CFrame = CFrame.new(v14) * v50
				v31 = nil
				v322 = Vector3.new(0, 0, 0)
				local v51, v522
				if v14 == v13 then
					v33 = nil
					v51 = Vector3.new(v38, v39, v40)
					if v51 * v18 == v51 then
						v422.Size = v51 * v18
						if shared.vfx and #v422:GetChildren() ~= 0 then
							v522 = shared.vfx.emit(v422).Finished
							table.insert(t, v522)
						end
						task.delay(v4:NextNumber(v11.Min, v11.Max), function() --[[ Line: 192 | Upvalues: v31 (ref), v33 (ref), v422 (copy), v51 (copy), v19 (copy), p3 (copy), v1 (ref), v25 (copy), v27 (copy), v322 (ref), v15 (copy), v2 (ref), p2 (copy), v17 (copy), v50 (copy), v30 (copy), v28 (copy) ]]
							if v31 then
								v31:Disconnect()
							end
							if v33 then
								v33:Disconnect()
							end
							local Size = v422.Size
							local Transparency = v422.Transparency
							if Size ~= v51 * v19 then
								local function f42(p1_2_2_2, p2_2_2_2) --[[ Line: 207 | Upvalues: v422 (ref), Size (copy), v51 (ref), v19 (ref) ]]
									v422.Size = Size:Lerp(v51 * v19, p1_2_2_2)
									return p2_2_2_2
								end
								table.insert(p3, v1.fromParams(v25, v27, f42))
							end
							if v322 ~= v15 then
								local function f82(p1_2_2_2, p2_2_2_2) --[[ Line: 220 | Upvalues: v422 (ref), v322 (ref), v15 (ref), v50 (ref) ]]
									v422.CFrame = CFrame.new(v322:Lerp(v15, p1_2_2_2)) * v50
									return p2_2_2_2
								end
								table.insert(p3, v1.fromParams(v2.getAttribute(p2, "Offset_End_Curve", v2.default_bezier), v17, f82))
							end
							if Transparency == v30 then
								v422.Transparency = Transparency
							else
								local v10 = v2.getAttribute(p2, "Transparency_Curve", v2.default_bezier)
								local function f122(p1_2_2_2, p2_2_2_2) --[[ Line: 234 | Upvalues: v422 (ref), v2 (ref), Transparency (copy), v30 (ref) ]]
									v422.Transparency = v2.lerp(Transparency, v30, p1_2_2_2)
									return p2_2_2_2
								end
								table.insert(p3, v1.fromParams(v10, v28, f122))
							end
						end)
					end
					v31 = v1.fromParams(v24, v26, function(p1_2, p2_2) --[[ Line: 177 | Upvalues: v422 (copy), v51 (copy), v18 (copy) ]]
						v422.Size = (v51 * v18):Lerp(v51, p1_2)
						return p2_2
					end)
					table.insert(p3, v31)
					if shared.vfx and #v422:GetChildren() ~= 0 then
						v522 = shared.vfx.emit(v422).Finished
						table.insert(t, v522)
					end
					task.delay(v4:NextNumber(v11.Min, v11.Max), function() --[[ Line: 192 | Upvalues: v31 (ref), v33 (ref), v422 (copy), v51 (copy), v19 (copy), p3 (copy), v1 (ref), v25 (copy), v27 (copy), v322 (ref), v15 (copy), v2 (ref), p2 (copy), v17 (copy), v50 (copy), v30 (copy), v28 (copy) ]]
						if v31 then
							v31:Disconnect()
						end
						if v33 then
							v33:Disconnect()
						end
						local Size = v422.Size
						local Transparency = v422.Transparency
						if Size ~= v51 * v19 then
							local function f42(p1_2_2_2, p2_2_2_2) --[[ Line: 207 | Upvalues: v422 (ref), Size (copy), v51 (ref), v19 (ref) ]]
								v422.Size = Size:Lerp(v51 * v19, p1_2_2_2)
								return p2_2_2_2
							end
							table.insert(p3, v1.fromParams(v25, v27, f42))
						end
						if v322 ~= v15 then
							local function f82(p1_2_2_2, p2_2_2_2) --[[ Line: 220 | Upvalues: v422 (ref), v322 (ref), v15 (ref), v50 (ref) ]]
								v422.CFrame = CFrame.new(v322:Lerp(v15, p1_2_2_2)) * v50
								return p2_2_2_2
							end
							table.insert(p3, v1.fromParams(v2.getAttribute(p2, "Offset_End_Curve", v2.default_bezier), v17, f82))
						end
						if Transparency == v30 then
							v422.Transparency = Transparency
						else
							local v10 = v2.getAttribute(p2, "Transparency_Curve", v2.default_bezier)
							local function f122(p1_2_2_2, p2_2_2_2) --[[ Line: 234 | Upvalues: v422 (ref), v2 (ref), Transparency (copy), v30 (ref) ]]
								v422.Transparency = v2.lerp(Transparency, v30, p1_2_2_2)
								return p2_2_2_2
							end
							table.insert(p3, v1.fromParams(v10, v28, f122))
						end
					end)
				end
				v33 = v1.fromParams(v2.getAttribute(p2, "Offset_Start_Curve", v2.default_bezier), v16, function(p1, p2) --[[ Line: 164 | Upvalues: v322 (ref), v14 (copy), v13 (copy), v422 (copy), v50 (copy) ]]
					v322 = v14:Lerp(v13, p1)
					v422.CFrame = CFrame.new(v322) * v50
					return p2
				end)
				table.insert(p3, v31)
				v51 = Vector3.new(v38, v39, v40)
				if v51 * v18 == v51 then
					v422.Size = v51 * v18
					if shared.vfx and #v422:GetChildren() ~= 0 then
						v522 = shared.vfx.emit(v422).Finished
						table.insert(t, v522)
					end
					task.delay(v4:NextNumber(v11.Min, v11.Max), function() --[[ Line: 192 | Upvalues: v31 (ref), v33 (ref), v422 (copy), v51 (copy), v19 (copy), p3 (copy), v1 (ref), v25 (copy), v27 (copy), v322 (ref), v15 (copy), v2 (ref), p2 (copy), v17 (copy), v50 (copy), v30 (copy), v28 (copy) ]]
						if v31 then
							v31:Disconnect()
						end
						if v33 then
							v33:Disconnect()
						end
						local Size = v422.Size
						local Transparency = v422.Transparency
						if Size ~= v51 * v19 then
							local function f42(p1_2_2_2, p2_2_2_2) --[[ Line: 207 | Upvalues: v422 (ref), Size (copy), v51 (ref), v19 (ref) ]]
								v422.Size = Size:Lerp(v51 * v19, p1_2_2_2)
								return p2_2_2_2
							end
							table.insert(p3, v1.fromParams(v25, v27, f42))
						end
						if v322 ~= v15 then
							local function f82(p1_2_2_2, p2_2_2_2) --[[ Line: 220 | Upvalues: v422 (ref), v322 (ref), v15 (ref), v50 (ref) ]]
								v422.CFrame = CFrame.new(v322:Lerp(v15, p1_2_2_2)) * v50
								return p2_2_2_2
							end
							table.insert(p3, v1.fromParams(v2.getAttribute(p2, "Offset_End_Curve", v2.default_bezier), v17, f82))
						end
						if Transparency == v30 then
							v422.Transparency = Transparency
						else
							local v10 = v2.getAttribute(p2, "Transparency_Curve", v2.default_bezier)
							local function f122(p1_2_2_2, p2_2_2_2) --[[ Line: 234 | Upvalues: v422 (ref), v2 (ref), Transparency (copy), v30 (ref) ]]
								v422.Transparency = v2.lerp(Transparency, v30, p1_2_2_2)
								return p2_2_2_2
							end
							table.insert(p3, v1.fromParams(v10, v28, f122))
						end
					end)
				end
				v31 = v1.fromParams(v24, v26, function(p1_2, p2_2) --[[ Line: 177 | Upvalues: v422 (copy), v51 (copy), v18 (copy) ]]
					v422.Size = (v51 * v18):Lerp(v51, p1_2)
					return p2_2
				end)
				table.insert(p3, v31)
				if shared.vfx and #v422:GetChildren() ~= 0 then
					v522 = shared.vfx.emit(v422).Finished
					table.insert(t, v522)
				end
				task.delay(v4:NextNumber(v11.Min, v11.Max), function() --[[ Line: 192 | Upvalues: v31 (ref), v33 (ref), v422 (copy), v51 (copy), v19 (copy), p3 (copy), v1 (ref), v25 (copy), v27 (copy), v322 (ref), v15 (copy), v2 (ref), p2 (copy), v17 (copy), v50 (copy), v30 (copy), v28 (copy) ]]
					if v31 then
						v31:Disconnect()
					end
					if v33 then
						v33:Disconnect()
					end
					local Size = v422.Size
					local Transparency = v422.Transparency
					if Size ~= v51 * v19 then
						local function f42(p1_2_2_2, p2_2_2_2) --[[ Line: 207 | Upvalues: v422 (ref), Size (copy), v51 (ref), v19 (ref) ]]
							v422.Size = Size:Lerp(v51 * v19, p1_2_2_2)
							return p2_2_2_2
						end
						table.insert(p3, v1.fromParams(v25, v27, f42))
					end
					if v322 ~= v15 then
						local function f82(p1_2_2_2, p2_2_2_2) --[[ Line: 220 | Upvalues: v422 (ref), v322 (ref), v15 (ref), v50 (ref) ]]
							v422.CFrame = CFrame.new(v322:Lerp(v15, p1_2_2_2)) * v50
							return p2_2_2_2
						end
						table.insert(p3, v1.fromParams(v2.getAttribute(p2, "Offset_End_Curve", v2.default_bezier), v17, f82))
					end
					if Transparency == v30 then
						v422.Transparency = Transparency
					else
						local v10 = v2.getAttribute(p2, "Transparency_Curve", v2.default_bezier)
						local function f122(p1_2_2_2, p2_2_2_2) --[[ Line: 234 | Upvalues: v422 (ref), v2 (ref), Transparency (copy), v30 (ref) ]]
							v422.Transparency = v2.lerp(Transparency, v30, p1_2_2_2)
							return p2_2_2_2
						end
						table.insert(p3, v1.fromParams(v10, v28, f122))
					end
				end)
			end
		end
		task.wait(v11.Max + math.max(v27, v17))
		v3.all(t):await()
	end
end
return t