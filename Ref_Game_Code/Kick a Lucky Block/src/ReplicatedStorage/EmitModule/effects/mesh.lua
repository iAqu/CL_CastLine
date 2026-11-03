-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local v1 = require("../mod/tween")
local v2 = require("../mod/utility")
local v3 = require("../mod/color/Oklab")
local v4 = require("../pkg/Promise")
local v5 = Random.new()
return {
	emit = function(p1, p2, p3, p4, p5) --[[ emit | Line: 14 | Upvalues: v2 (copy), v5 (copy), v1 (copy), RunService (copy), v3 (copy), CollectionService (copy), v4 (copy) ]]
		local Start = p1:FindFirstChild("Start")
		local End = p1:FindFirstChild("End")
		if Start and (End and (Start:IsA("BasePart") and (End:IsA("BasePart") and (not p1:GetAttribute("Enabled") or p5)))) then
			local v12 = v2.getAttribute(p1, "Duration", 1, true)
			local v22 = v2.getRangeAttribute(p1, "EffectDuration", NumberRange.new(v12, v12), NumberRange.new(0, (1 / 0)))
			local v32 = v5:NextNumber(v22.Min, v22.Max)
			local v42 = v2.getAttribute(p1, "EmitDelay", 0)
			local v52 = v2.getAttribute(p1, "EmitDuration", 0, true)
			local v6 = v2.getAttribute(p1, "Flipbook", false, true)
			local v7 = v2.getAttribute(p1, "FlipbookFadeOffset", 0, true)
			local v8 = if v6 or not Start:FindFirstChildOfClass("Decal") then "Mesh_" else "Decal_"
			local v9 = p1:GetAttribute("StartTransparency")
			if v9 ~= nil then
				p1:SetAttribute(v8 .. "StartTransparency", v9)
				p1:SetAttribute("StartTransparency", nil)
			end
			local v10 = p1:GetAttribute("EndTransparency")
			if v10 ~= nil then
				p1:SetAttribute(v8 .. "EndTransparency", v10)
				p1:SetAttribute("EndTransparency", nil)
			end
			local v11 = if p1:GetAttribute("Enabled") == nil then false else p1:HasTag(v2.ENABLED_VFX_TAG) and if v32 > 0 then true else false
			local v122 = v2.getAttribute(p1, "Decal_StartTransparency", 0, true)
			local v13 = v2.getAttribute(p1, "Decal_EndTransparency", 1, true)
			local v14 = 0
			if if Start then Start:FindFirstChildOfClass("Decal") else Start then
				v14 = 1
			end
			local v16 = v2.getAttribute(p1, "Mesh_StartTransparency", v14, true)
			local v17 = v2.getAttribute(p1, "Mesh_EndTransparency", v14, true)
			local v18 = v2.getAttribute(p1, "SyncPosition", false)
			local v19 = v2.getAttribute(p1, "Speed_Start", 1)
			local v20 = v2.getAttribute(p1, "Speed_End", 1)
			local v21 = v2.getAttribute(p1, "Part_Transparency_Start", v16)
			local v222 = v2.getAttribute(p1, "Part_Transparency_End", v17)
			local v23 = v2.getAttribute(p1, "SpreadAngle", Vector3.new(0, 0, 0))
			local v24 = v2.getRangeAttribute(p1, "Part_RotSpeed_Start", NumberRange.new(0, 0))
			local v25 = v2.getRangeAttribute(p1, "Part_RotSpeed_End", NumberRange.new(0, 0))
			local v26 = v2.getAttribute(p1, "RotAroundOrigin", false)
			local v27 = v2.getAttribute(p1, "MinInitRot", Vector3.new(0, 0, 0))
			local v28 = v2.getAttribute(p1, "MaxInitRot", Vector3.new(0, 0, 0))
			local v29 = v5:NextNumber(v24.Min, v24.Max)
			local v30 = v5:NextNumber(v25.Min, v25.Max)
			local v34 = vector.create(v5:NextNumber(v27.x, v28.x), v5:NextNumber(v27.y, v28.y), v5:NextNumber(v27.z, v28.z)) * v2.DEG_TO_RAD
			task.wait(v42)
			if v11 and not p5 then
				p1:SetAttribute("Enabled", true)
				if v19 ~= v20 then
					p1:SetAttribute("SpeedTweening", true)
					local v35 = v2.getAttribute(p1, "Speed_Curve", v2.default_bezier)
					local v36 = v2.getAttribute(p1, "Speed_Duration", 0.1)
					local function f37(p12, p2) --[[ Line: 128 | Upvalues: p1 (copy), v2 (ref), v19 (copy), v20 (copy) ]]
						p1:SetAttribute("SpeedOverride", v2.lerp(v19, v20, p12))
						return p2
					end
					table.insert(p3, v1.fromParams(v35, v36, f37, nil, function() --[[ Line: 133 | Upvalues: p1 (copy) ]]
						p1:SetAttribute("SpeedTweening", nil)
					end))
				end
				task.wait(v52)
				p1:SetAttribute("Enabled", false)
				p1:SetAttribute("SpeedOverride", nil)
			else
				local v38 = p1:FindFirstAncestorOfClass("Attachment") or Start
				local v39 = (p1:FindFirstAncestorOfClass("Attachment") or Start) and p2._getReal() or p2
				local function getOrigin() --[[ getOrigin | Line: 151 | Upvalues: v38 (copy) ]]
					return v38:IsA("Attachment") and v38.WorldCFrame or v38.CFrame
				end
				local v40 = (function() --[[ getOrigin | Line: 151 | Upvalues: v38 (copy) ]]
					return v38:IsA("Attachment") and v38.WorldCFrame or v38.CFrame
				end) and v38.WorldCFrame or v38.CFrame
				local v41 = Start.CFrame:ToObjectSpace(End.CFrame)
				local v422 = v19
				local v43 = v29
				local v44 = CFrame.fromOrientation(v34.x, v34.y, v34.z)
				local identity = CFrame.identity
				local v48 = CFrame.fromOrientation(math.rad((v5:NextNumber(-v23.x, v23.x))), math.rad((v5:NextNumber(-v23.y, v23.y))), 0)
				local function updatePos(p1) --[[ updatePos | Line: 170 | Upvalues: v18 (copy), v38 (copy), v40 (copy), v34 (copy), v43 (ref), v44 (ref), v26 (copy), v48 (copy), identity (ref), p2 (copy) ]]
					local v1, v2, v3
					v1 = v18 and (v38:IsA("Attachment") and v38.WorldCFrame or v38.CFrame) or v40
					v2 = v34:Sign() * v43 * p1
					v44 = v44 * CFrame.fromOrientation(v2.x, v2.y, v2.z)
					v3 = if v26 then v1 * v48 * v44 * identity else v1 * v48 * identity * v44
					p2.CFrame = v3 * v44
				end
				updatePos(0)
				local v49 = v2.getRanomId()
				RunService:BindToRenderStep(v49, v2.RENDER_PRIORITY + p3.depth, updatePos)
				local function f50() --[[ Line: 196 | Upvalues: RunService (ref), v49 (copy) ]]
					RunService:UnbindFromRenderStep(v49)
				end
				table.insert(p3, f50)
				local t = {}
				local EmitOnFinish = p2:FindFirstChild("EmitOnFinish")
				if EmitOnFinish then
					EmitOnFinish.Parent = nil
					table.insert(p3, EmitOnFinish)
				end
				if shared.vfx and #p2:GetChildren() ~= 0 then
					local Finished = shared.vfx.emit(p2).Finished
					table.insert(t, Finished)
				end
				local v51
				if v19 == v20 or p1:GetAttribute("SpeedOverride") then
					v51 = nil
				else
					v51 = v1.fromParams(v2.getAttribute(p1, "Speed_Curve", v2.default_bezier), v2.getAttribute(p1, "Speed_Duration", 0.1), function(p1, p2) --[[ Line: 221 | Upvalues: v422 (ref), v2 (ref), v19 (copy), v20 (copy) ]]
						v422 = v2.lerp(v19, v20, p1)
						return p2
					end)
					table.insert(p3, v51)
				end
				if v41 ~= CFrame.identity then
					local function f53(p12, p2) --[[ Line: 236 | Upvalues: identity (ref), v41 (copy), p1 (copy), v422 (ref) ]]
						identity = CFrame.identity:Lerp(v41, p12)
						return p2 * (p1:GetAttribute("SpeedOverride") or v422)
					end
					table.insert(p3, v1.fromParams(v2.getAttribute(p1, "Part_CFrame_Curve", v2.default_bezier), v32, f53, v51))
				end
				if v29 ~= v30 then
					local v54 = v2.getAttribute(p1, "Part_RotSpeed_Curve", v2.default_bezier)
					local function f55(p12, p2) --[[ Line: 251 | Upvalues: v43 (ref), v2 (ref), v29 (copy), v30 (copy), p1 (copy), v422 (ref) ]]
						v43 = v2.lerp(v29, v30, p12)
						return p2 * (p1:GetAttribute("SpeedOverride") or v422)
					end
					table.insert(p3, v1.fromParams(v54, v32, f55, v51))
				end
				if v21 == v222 then
					p2.Transparency = v21
				else
					local v56 = v2.getAttribute(p1, "Part_Transparency_Curve", v2.default_bezier)
					local function f57(p12, p22) --[[ Line: 266 | Upvalues: p2 (copy), v2 (ref), v21 (copy), v222 (copy), p1 (copy), v422 (ref) ]]
						p2.Transparency = v2.lerp(v21, v222, p12)
						return p22 * (p1:GetAttribute("SpeedOverride") or v422)
					end
					table.insert(p3, v1.fromParams(v56, v32, f57, v51))
				end
				local v58 = Start.Size * p4
				local v59 = End.Size * p4
				if v58 == v59 then
					p2.Size = v58
				else
					table.insert(p3, v1.fromParams(v2.getAttribute(p1, "Part_Size_Curve", v2.default_bezier), v32, function(p12, p22) --[[ Line: 285 | Upvalues: p2 (copy), v58 (copy), v59 (copy), p1 (copy), v422 (ref) ]]
						p2.Size = v58:Lerp(v59, p12)
						return p22 * (p1:GetAttribute("SpeedOverride") or v422)
					end, v51))
				end
				local SpecialMesh = Start:FindFirstChildOfClass("SpecialMesh")
				local SpecialMesh_2 = End:FindFirstChildOfClass("SpecialMesh")
				local SpecialMesh_3 = p2:FindFirstChildOfClass("SpecialMesh")
				if SpecialMesh_3 and (SpecialMesh and SpecialMesh_2) then
					local v61 = SpecialMesh.Scale * p4
					local v62 = SpecialMesh_2.Scale * p4
					if v61 ~= v62 then
						local v63 = v2.getAttribute(p1, "Mesh_Scale_Curve", v2.default_bezier)
						local function f64(p12, p2) --[[ Line: 311 | Upvalues: SpecialMesh_3 (copy), v2 (ref), v61 (copy), v62 (copy), p1 (copy), v422 (ref) ]]
							SpecialMesh_3.Scale = v2.lerp(v61, v62, p12)
							return p2 * (p1:GetAttribute("SpeedOverride") or v422)
						end
						table.insert(p3, v1.fromParams(v63, v32, f64, v51))
					end
				elseif SpecialMesh_3 then
					SpecialMesh_3.Parent = nil
					table.insert(p3, function() --[[ Line: 322 | Upvalues: SpecialMesh_3 (copy), v39 (copy) ]]
						SpecialMesh_3.Parent = v39
					end)
				end
				local v65, v66, v67 = v2.getMeshDecals(p1, p2)
				local v68 = 0
				if v6 then
					table.sort(v65, function(p1, p2) --[[ Line: 333 ]]
						local v1 = p1.Name:match("%d+") or 0
						local v2 = p2.Name:match("%d+") or 0
						return tonumber(v1) < tonumber(v2)
					end)
					local Decal = Instance.new("Decal")
					Decal.Parent = v39
					table.insert(p3, Decal)
					if v7 > 0 and v122 ~= v13 then
						local default_bezier = v2.default_bezier
						local function f69(p12, p2) --[[ Line: 349 | Upvalues: Decal (copy), v2 (ref), v122 (copy), v13 (copy), p1 (copy), v422 (ref) ]]
							Decal.Transparency = v2.lerp(v122, v13, p12)
							return p2 * (p1:GetAttribute("SpeedOverride") or v422)
						end
						table.insert(p3, v1.fromParams(default_bezier, v32 + v7, f69, v51))
					end
					local default_bezier = v2.default_bezier
					local function f70(p12, p2) --[[ Line: 359 | Upvalues: v65 (copy), Decal (copy), v7 (copy), v2 (ref), v122 (copy), v13 (copy), p1 (copy), v422 (ref) ]]
						local v3 = v65[math.max(math.round(#v65 * p12), 1)]
						Decal.Texture = v3.Texture
						Decal.Color3 = v3.Color3
						Decal.ZIndex = v3.ZIndex
						if v7 == 0 then
							Decal.Transparency = v2.lerp(v122, v13, p12)
							Decal.ZIndex = v3.ZIndex
						end
						return p2 * (p1:GetAttribute("SpeedOverride") or v422)
					end
					table.insert(p3, v1.fromParams(default_bezier, v32, f70, v51))
				else
					local v71
					for v72, v73 in v65 do
						local v74 = v67[v73]
						local v75 = v2.getAttribute(v73, "Transparency_Start", v122)
						local v76 = v2.getAttribute(v73, "Transparency_End", v13)
						local v77, v78, v79, v80, v81, v82, v83, v84
						if v75 == v76 then
							v73.Transparency = v75
							if v73.Color3 ~= v74.Color3 then
								v77 = v1.fromParams
								v78 = v2.getAttribute(v73, "Color_Curve", v2.default_bezier)
								v79 = function(p12_2, p2_2) --[[ Line: 407 | Upvalues: v3 (ref), v73 (copy), v74 (copy), v73 (copy), p1 (copy), v422 (ref) ]]
									v73.Color3 = v3.toSRGB(v3.fromSRGB(v73.Color3):Lerp(v3.fromSRGB(v74.Color3), p12_2), true)
									return p2_2 * (p1:GetAttribute("SpeedOverride") or v422)
								end
								table.insert(p3, v77(v78, v32, v79, v51))
							end
							v80 = v66[v73]
							if v80 then
								v81 = v2.getAttribute(v73, "Flipbook_Change_Duration", v32) and v32
								if v68 < v81 then
									v68 = v81
								end
								v71 = false
								if RunService:IsStudio() then
									for v85, v86 in CollectionService:GetTags(v73) do
										if v86:match("^_local_flipbook_") then
											v71 = true
										else
											continue
										end
										break
									end
								end
								v82 = v1.fromParams
								v83 = v2.getAttribute(v73, "Flipbook_Change_Curve", v2.linear_bezier)
								v84 = function(p12_2, p2_2) --[[ Line: 449 | Upvalues: v80 (copy), v73 (copy), v71 (ref), p1 (copy), v422 (ref) ]]
									v73.Texture = ("%*%*"):format(if v71 then "rbxtemp://" else "rbxassetid://", v80[math.max(math.round(#v80 * p12_2), 1)])
									return p2_2 * (p1:GetAttribute("SpeedOverride") or v422)
								end
								table.insert(p3, v82(v83, v81, v84, v51))
							end
							continue
						end
						local v87 = v2.getAttribute(v73, "Transparency_Curve", v2.default_bezier)
						local function f88(p12, p2) --[[ Line: 390 | Upvalues: v73 (copy), v2 (ref), v75 (copy), v76 (copy), p1 (copy), v422 (ref) ]]
							v73.Transparency = v2.lerp(v75, v76, p12)
							return p2 * (p1:GetAttribute("SpeedOverride") or v422)
						end
						table.insert(p3, v1.fromParams(v87, v32, f88, v51))
						if v73.Color3 ~= v74.Color3 then
							v77 = v1.fromParams
							v78 = v2.getAttribute(v73, "Color_Curve", v2.default_bezier)
							v79 = function(p12_2, p2_2) --[[ Line: 407 | Upvalues: v3 (ref), v73 (copy), v74 (copy), v73 (copy), p1 (copy), v422 (ref) ]]
								v73.Color3 = v3.toSRGB(v3.fromSRGB(v73.Color3):Lerp(v3.fromSRGB(v74.Color3), p12_2), true)
								return p2_2 * (p1:GetAttribute("SpeedOverride") or v422)
							end
							table.insert(p3, v77(v78, v32, v79, v51))
						end
						v80 = v66[v73]
						if v80 then
							v81 = v2.getAttribute(v73, "Flipbook_Change_Duration", v32) and v32
							if v68 < v81 then
								v68 = v81
							end
							v71 = false
							if RunService:IsStudio() then
								for v85, v86 in CollectionService:GetTags(v73) do
									if v86:match("^_local_flipbook_") then
										v71 = true
									else
										continue
									end
									break
								end
							end
							v82 = v1.fromParams
							v83 = v2.getAttribute(v73, "Flipbook_Change_Curve", v2.linear_bezier)
							v84 = function(p12_2, p2_2) --[[ Line: 449 | Upvalues: v80 (copy), v73 (copy), v71 (ref), p1 (copy), v422 (ref) ]]
								v73.Texture = ("%*%*"):format(if v71 then "rbxtemp://" else "rbxassetid://", v80[math.max(math.round(#v80 * p12_2), 1)])
								return p2_2 * (p1:GetAttribute("SpeedOverride") or v422)
							end
							table.insert(p3, v82(v83, v81, v84, v51))
						end
					end
				end
				v1.timer(math.max(v32, v68) + v7, function(p12, p2) --[[ Line: 462 | Upvalues: p1 (copy), v422 (ref), v51 (ref) ]]
					local v1 = p1:GetAttribute("SpeedOverride") or v422
					v422 = v1
					if not (v1 > 0) then
						if p2 > 0 then
							if not if v51 then v51.Connected else p1:GetAttribute("SpeedTweening") then
								return nil
							end
							return p12 * v1
						end
						return nil
					end
					return p12 * v1
				end, v51, p3)
				v4.all(t):await()
				local v89 = EmitOnFinish and EmitOnFinish:GetChildren()
				if v89 and #v89 ~= 0 then
					for v90, v91 in v89 do
						v91.Parent = v39
					end
					shared.vfx.emit(table.unpack(v89)).Finished:await()
				end
			end
		end
	end
}