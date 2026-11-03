-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")
require("../types")
local v3 = require("../mod/utility")
local v4 = require("../mod/common/flipbook")
local v5 = require("../mod/color/Oklab")
local v6 = require("../pkg/Promise")
local v7 = Random.new()
return {
	emit = function(p1, p2, p3, p4, p5) --[[ emit | Line: 17 | Upvalues: v1 (copy), v7 (copy), v3 (copy), v2 (copy), RunService (copy), v5 (copy), v4 (copy), v6 (copy) ]]
		local Start = p1:FindFirstChild("Start")
		local End = p1:FindFirstChild("End")
		if not Start or (not End or (not Start:IsA("BasePart") or (not End:IsA("BasePart") or v1.get(p1, "Enabled", false) and not p5))) then
			return
		end
		local v12 = v1.get(p1, "Duration", 1, true)
		local v22 = v1.getRange(p1, "EffectDuration", NumberRange.new(v12, v12), NumberRange.new(0, (1 / 0)))
		local v32 = v7:NextNumber(v22.Min, v22.Max)
		local v42 = v1.get(p1, "EmitDelay", 0)
		local v52 = v1.get(p1, "DestroyDelay", 0)
		local v62 = v1.get(p1, "EmitDuration", 0)
		local v72 = v1.get(p1, "Flipbook", false, true)
		local v8 = v1.get(p1, "FlipbookFadeOffset", 0, true)
		local v9 = if v72 or not Start:FindFirstChildOfClass("Decal") then "Mesh_" else "Decal_"
		local v10 = p1:GetAttribute("StartTransparency")
		if v10 ~= nil then
			p1:SetAttribute(v9 .. "StartTransparency", v10)
			p1:SetAttribute("StartTransparency", nil)
		end
		local v11 = p1:GetAttribute("EndTransparency")
		if v11 ~= nil then
			p1:SetAttribute(v9 .. "EndTransparency", v11)
			p1:SetAttribute("EndTransparency", nil)
		end
		local v122 = p1:HasTag(v3.ENABLED_VFX_TAG) and (if v62 > 0 then true else false)
		local v13 = v1.get(p1, "Decal_StartTransparency", 0, true)
		local v14 = v1.get(p1, "Decal_EndTransparency", 1, true)
		local v15 = 0
		if if Start then Start:FindFirstChildOfClass("Decal") else Start then
			v15 = 1
		end
		local v17 = v1.get(p1, "Mesh_StartTransparency", v15, true)
		local v18 = v1.get(p1, "Mesh_EndTransparency", v15, true)
		local v19 = v1.get(p1, "SyncPosition", false)
		local v20 = v1.get(p1, "Speed_Start", 1)
		local v21 = v1.get(p1, "Speed_End", 1)
		local v222 = v1.get(p1, "Part_Transparency_Start", v17)
		local v23 = v1.get(p1, "Part_Transparency_End", v18)
		local v24 = v1.get(p1, "SpreadAngle", Vector3.new(0, 0, 0))
		local v25 = v1.getRange(p1, "Part_RotSpeed_Start", NumberRange.new(0, 0))
		local v26 = v1.getRange(p1, "Part_RotSpeed_End", NumberRange.new(0, 0))
		local v27 = v1.get(p1, "RotAroundOrigin", false)
		local v28 = v1.get(p1, "MinInitRot", Vector3.new(0, 0, 0))
		local v29 = v1.get(p1, "MaxInitRot", Vector3.new(0, 0, 0))
		local v30 = v7:NextNumber(v25.Min, v25.Max)
		local v31 = v7:NextNumber(v26.Min, v26.Max)
		local v35 = vector.create(v7:NextNumber(v28.x, v29.x), v7:NextNumber(v28.y, v29.y), v7:NextNumber(v28.z, v29.z)) * v3.DEG_TO_RAD
		task.wait(v42)
		if v122 and not p5 then
			v3.forceEmit(p1, true)
			v1.trigger(p1, "Enabled", true)
			v3.onCancel(p3, function() --[[ Line: 125 | Upvalues: v3 (ref), p1 (copy) ]]
				local v1 = v3.stopEmitDuration(p1)
				if not v1 then
					return
				end
				v3.cancelToken(v1)
			end)
			if v20 ~= v21 then
				v1.setState(p1, "SpeedTweening", true)
				local v36 = v1.get(p1, "Speed_Curve", v3.default_bezier)
				local v37 = v1.get(p1, "Speed_Duration", 0.1)
				local function f38(p12, p2) --[[ Line: 141 | Upvalues: v1 (ref), p1 (copy), v3 (ref), v20 (copy), v21 (copy) ]]
					v1.setState(p1, "SpeedOverride", v3.lerp(v20, v21, p12))
					return p2
				end
				local function f39() --[[ Line: 146 | Upvalues: v1 (ref), p1 (copy) ]]
					v1.setState(p1, "SpeedTweening", nil)
				end
				table.insert(p3, v2.fromParams(v36, v37, f38, nil, f39))
			end
			task.wait(v62)
			v3.awaitEmitDuration(v3.stopEmitDuration(p1))
		else
			local v40 = p1:FindFirstAncestorOfClass("Attachment") or Start
			local v41 = typeof(p2) == "table" and p2._getReal() or p2
			local v422 = v3.getTransformedOriginExtents(v40)
			local v43 = Start.CFrame:ToObjectSpace(End.CFrame)
			local v44 = v20
			local v45 = v30
			local v46 = CFrame.fromOrientation(v35.x, v35.y, v35.z)
			local identity = CFrame.identity
			local v50 = CFrame.fromOrientation(math.rad((v7:NextNumber(-v24.x, v24.x))), math.rad((v7:NextNumber(-v24.y, v24.y))), 0)
			local function updatePos(p1) --[[ updatePos | Line: 178 | Upvalues: v19 (copy), v3 (ref), v40 (copy), v422 (copy), v35 (copy), v45 (ref), v46 (ref), v27 (copy), v50 (copy), identity (ref), p2 (copy) ]]
				local v1 = v19 and v3.getTransformedOriginExtents(v40) or v422
				local v2 = v35:Sign() * v45 * p1
				v46 = v46 * CFrame.fromOrientation(v2.x, v2.y, v2.z)
				p2.CFrame = (if v27 then v1 * v50 * v46 * identity else v1 * v50 * identity * v46) * v46
			end
			updatePos(0)
			local v51 = v3.getRandomId()
			RunService:BindToRenderStep(v51, v3.RENDER_PRIORITY + p3.depth, updatePos)
			local function f52() --[[ Line: 204 | Upvalues: RunService (ref), v51 (copy) ]]
				RunService:UnbindFromRenderStep(v51)
			end
			table.insert(p3, f52)
			local t = {}
			local v53 = p3.effects.prepareEmitOnFinish(p2, p3)
			local Finished = p3.effects.emitNested(p2, p3.depth + 1, p3).Finished
			table.insert(t, Finished)
			local v54
			if v20 == v21 or v1.getState(p1, "SpeedOverride", nil) then
				v54 = nil
			else
				v54 = v2.fromParams(v1.get(p1, "Speed_Curve", v3.default_bezier), v1.get(p1, "Speed_Duration", 0.1), function(p1, p2) --[[ Line: 222 | Upvalues: v44 (ref), v3 (ref), v20 (copy), v21 (copy) ]]
					v44 = v3.lerp(v20, v21, p1)
					return p2
				end)
				table.insert(p3, v54)
			end
			if v43 ~= CFrame.identity then
				local v55 = v1.get(p1, "Part_CFrame_Curve", v3.default_bezier)
				local function f56(p12, p2) --[[ Line: 234 | Upvalues: identity (ref), v43 (copy), v1 (ref), p1 (copy), v44 (ref) ]]
					identity = CFrame.identity:Lerp(v43, p12)
					return p2 * v1.getState(p1, "SpeedOverride", v44)
				end
				table.insert(p3, v2.fromParams(v55, v32, f56, v54))
			end
			if v30 ~= v31 then
				local v57 = v1.get(p1, "Part_RotSpeed_Curve", v3.default_bezier)
				local function f58(p12, p2) --[[ Line: 247 | Upvalues: v45 (ref), v3 (ref), v30 (copy), v31 (copy), v1 (ref), p1 (copy), v44 (ref) ]]
					v45 = v3.lerp(v30, v31, p12)
					return p2 * v1.getState(p1, "SpeedOverride", v44)
				end
				table.insert(p3, v2.fromParams(v57, v32, f58, v54))
			end
			if v222 == v23 then
				p2.Transparency = v222
			else
				local v59 = v1.get(p1, "Part_Transparency_Curve", v3.default_bezier)
				local function f60(p12, p22) --[[ Line: 262 | Upvalues: p2 (copy), v3 (ref), v222 (copy), v23 (copy), v1 (ref), p1 (copy), v44 (ref) ]]
					p2.Transparency = v3.lerp(v222, v23, p12)
					return p22 * v1.getState(p1, "SpeedOverride", v44)
				end
				table.insert(p3, v2.fromParams(v59, v32, f60, v54))
			end
			local v61 = Start.Size * p4
			local v622 = End.Size * p4
			if v61 == v622 then
				p2.Size = v61
			else
				local v63 = -1
				local v64 = v1.get(p1, "Part_Size_Curve", v3.default_bezier)
				local function f65(p12, p22) --[[ Line: 280 | Upvalues: v1 (ref), p1 (copy), v44 (ref), v63 (ref), p2 (copy), v61 (copy), v622 (copy) ]]
					local v12 = v1.getState(p1, "SpeedOverride", v44)
					if not (math.abs(p12 - v63) < 0.005) then
						v63 = p12
						p2.Size = v61:Lerp(v622, p12)
					end
					return p22 * v12
				end
				table.insert(p3, v2.fromParams(v64, v32, f65, v54))
			end
			local SpecialMesh = Start:FindFirstChildOfClass("SpecialMesh")
			local SpecialMesh_2 = End:FindFirstChildOfClass("SpecialMesh")
			local SpecialMesh_3 = p2:FindFirstChildOfClass("SpecialMesh")
			if SpecialMesh_3 and (SpecialMesh and SpecialMesh_2) then
				local v66 = SpecialMesh.Scale * p4
				local v67 = SpecialMesh_2.Scale * p4
				if v66 ~= v67 then
					local v68 = v1.get(p1, "Mesh_Scale_Curve", v3.default_bezier)
					local function f69(p12, p2) --[[ Line: 313 | Upvalues: SpecialMesh_3 (copy), v3 (ref), v66 (copy), v67 (copy), v1 (ref), p1 (copy), v44 (ref) ]]
						SpecialMesh_3.Scale = v3.lerp(v66, v67, p12)
						return p2 * v1.getState(p1, "SpeedOverride", v44)
					end
					table.insert(p3, v2.fromParams(v68, v32, f69, v54))
				end
			elseif SpecialMesh_3 then
				SpecialMesh_3.Parent = nil
				table.insert(p3, function() --[[ Line: 324 | Upvalues: SpecialMesh_3 (copy), v41 (copy) ]]
					SpecialMesh_3.Parent = v41
				end)
			end
			local v70, v71, v722 = v3.getMeshDecals(p1, p2)
			local v73 = 0
			if v72 then
				table.sort(v70, function(p1, p2) --[[ Line: 335 ]]
					local v1 = p1.Name:match("%d+") or 0
					local v2 = p2.Name:match("%d+") or 0
					return tonumber(v1) < tonumber(v2)
				end)
				local Decal = Instance.new("Decal")
				Decal.Parent = v41
				table.insert(p3, Decal)
				if v8 > 0 and v13 ~= v14 then
					local default_bezier = v3.default_bezier
					local function f74(p12, p2) --[[ Line: 351 | Upvalues: Decal (copy), v3 (ref), v13 (copy), v14 (copy), v1 (ref), p1 (copy), v44 (ref) ]]
						Decal.Transparency = v3.lerp(v13, v14, p12)
						return p2 * v1.getState(p1, "SpeedOverride", v44)
					end
					table.insert(p3, v2.fromParams(default_bezier, v32 + v8, f74, v54))
				end
				local default_bezier = v3.default_bezier
				local function f75(p12, p2) --[[ Line: 361 | Upvalues: v70 (copy), Decal (copy), v8 (copy), v3 (ref), v13 (copy), v14 (copy), v1 (ref), p1 (copy), v44 (ref) ]]
					local v32 = v70[math.max(math.round(#v70 * p12), 1)]
					Decal.Texture = v32.Texture
					Decal.Color3 = v32.Color3
					Decal.ZIndex = v32.ZIndex
					if v8 ~= 0 then
						return p2 * v1.getState(p1, "SpeedOverride", v44)
					end
					Decal.Transparency = v3.lerp(v13, v14, p12)
					Decal.ZIndex = v32.ZIndex
					return p2 * v1.getState(p1, "SpeedOverride", v44)
				end
				table.insert(p3, v2.fromParams(default_bezier, v32, f75, v54))
			else
				for v76, v77 in v70 do
					local v78 = v722[v77]
					local v79 = v1.get(v77, "Transparency_Start", v13)
					local v80 = v1.get(v77, "Transparency_End", v14)
					if v79 == v80 then
						v77.Transparency = v79
					else
						local v81 = v1.get(v77, "Transparency_Curve", v3.default_bezier)
						local function f82(p12, p2) --[[ Line: 392 | Upvalues: v77 (copy), v3 (ref), v79 (copy), v80 (copy), v1 (ref), p1 (copy), v44 (ref) ]]
							v77.Transparency = v3.lerp(v79, v80, p12)
							return p2 * v1.getState(p1, "SpeedOverride", v44)
						end
						table.insert(p3, v2.fromParams(v81, v32, f82, v54))
					end
					if v77.Color3 ~= v78.Color3 then
						local v83 = v1.get(v77, "Color_Curve", v3.default_bezier)
						local function f84(p12, p2) --[[ Line: 406 | Upvalues: v5 (ref), v77 (copy), v78 (copy), v77 (copy), v1 (ref), p1 (copy), v44 (ref) ]]
							local v12 = v5.fromSRGB(v77.Color3)
							v77.Color3 = v5.toSRGB(v12:Lerp(v5.fromSRGB(v78.Color3), p12), true)
							return p2 * v1.getState(p1, "SpeedOverride", v44)
						end
						table.insert(p3, v2.fromParams(v83, v32, f84, v54))
					end
					local v85 = v71[v77]
					if v85 then
						local t2 = {
							ref = v77,
							frames = v85,
							speedTween = v54,
							effectDuration = v32,
							curve = v1.get(v77, "Flipbook_Change_Curve", v3.linear_bezier),
							duration = v1.get(v77, "Flipbook_Change_Duration", v32),
							getSpeed = function() --[[ getSpeed | Line: 429 | Upvalues: v1 (ref), p1 (copy), v44 (ref) ]]
								return v1.getState(p1, "SpeedOverride", v44)
							end,
							setTexture = function(p1) --[[ setTexture | Line: 433 | Upvalues: v77 (copy) ]]
								v77.Texture = p1
							end
						}
						local v86 = v4.getChangeDuration(t2)
						if v73 < v86 then
							v73 = v86
						end
						table.insert(p3, v2.fromParams(t2.curve, v86, v4.createUpdateCallback(t2), v54))
					end
				end
			end
			v2.timer(math.max(v32, v73) + v8 + v52, function(p12, p2) --[[ Line: 454 | Upvalues: v1 (ref), p1 (copy), v44 (ref), v54 (ref) ]]
				local v12 = v1.getState(p1, "SpeedOverride", v44)
				v44 = v12
				if not (v12 > 0) then
					if not (p2 > 0) then
						return nil
					end
					if not (if v54 then v54.Connected else v1.getState(p1, "SpeedTweening", false)) then
						return nil
					end
				end
				return p12 * v12
			end, v54, p3)
			v6.all(t):await()
			p3.effects.emitOnFinish(v53, v41, p3.depth + 1, p3).Finished:await()
		end
	end
}