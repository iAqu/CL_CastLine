-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")
require("../types")
local v3 = require("../mod/utility")
local v4 = require("../mod/common/bezier")
local v5 = require("../obj/Bezier")
local v6 = require("../pkg/Promise")
require("../obj/ObjectCache")
local t = {}
local v7 = nil
function t.init(p1) --[[ init | Line: 18 | Upvalues: v7 (ref) ]]
	v7 = p1
end
function t.deinit() --[[ deinit | Line: 22 | Upvalues: v7 (ref) ]]
	v7 = nil
end
local function readBezierAttributes(p1) --[[ readBezierAttributes | Line: 26 | Upvalues: v1 (copy), v3 (copy) ]]
	return {
		facePath = v1.get(p1, "FacePath", false),
		arcSpace = v1.get(p1, "ArcSpace", false),
		rotSpeedStart = v1.getRange(p1, "RotSpeed_Start", NumberRange.new(0, 0)),
		rotSpeedEnd = v1.getRange(p1, "RotSpeed_End", NumberRange.new(0, 0)),
		minInitRot = v1.get(p1, "MinInitRot", Vector3.new(0, 0, 0)),
		maxInitRot = v1.get(p1, "MaxInitRot", Vector3.new(0, 0, 0)),
		speedCurve = v1.get(p1, "Speed_Curve", v3.default_bezier),
		speedDuration = v1.get(p1, "Speed_Duration", 0.1),
		easingCurve = v1.get(p1, "Easing_Curve", v3.linear_bezier)
	}
end
function t.emit(p1, p2, p3, p4) --[[ emit | Line: 45 | Upvalues: v7 (ref), v4 (copy), readBezierAttributes (copy), v3 (copy), v1 (copy), v2 (copy), v5 (copy), v6 (copy), RunService (copy) ]]
	local Points = p1:FindFirstChild("Points")
	if not (Points and (Points:IsA("Attachment") and v7)) then
		return
	end
	local v12 = v4.readCommonAttributes(p1)
	local v22 = readBezierAttributes(p1)
	local v32 = v4.drawFuncMap[v12.shapeType] and v4.drawFuncMap[v12.shapeType][v12.shapeStyle]
	if not v32 then
		return
	end
	local v42 = if v12.emitDuration > 0 then true else false
	task.wait(v12.emitDelay)
	if v42 and not p4 then
		v3.forceEmit(p1, true)
		v1.trigger(p1, "Enabled", true)
		v3.onCancel(p3, function() --[[ Line: 70 | Upvalues: v3 (ref), p1 (copy) ]]
			local v1 = v3.stopEmitDuration(p1)
			if not v1 then
				return
			end
			v3.cancelToken(v1)
		end)
		if v12.speedStart ~= v12.speedEnd then
			v1.setState(p1, "SpeedTweening", true)
			local function f5(p12, p2) --[[ Line: 86 | Upvalues: v1 (ref), p1 (copy), v3 (ref), v12 (copy) ]]
				v1.setState(p1, "SpeedOverride", v3.lerp(v12.speedStart, v12.speedEnd, p12))
				return p2
			end
			local function f6() --[[ Line: 91 | Upvalues: v1 (ref), p1 (copy) ]]
				v1.setState(p1, "SpeedTweening", nil)
			end
			table.insert(p3, v2.fromParams(v22.speedCurve, v22.speedDuration, f5, nil, f6))
		end
		task.wait(v12.emitDuration)
		v3.awaitEmitDuration(v3.stopEmitDuration(p1))
	else
		if v12.emitCount <= 0 then
			return
		end
		local v72 = v4.validateParent(p1)
		if not v72 then
			return
		end
		local v8, v9 = v3.getTransformedOriginExtents(v72)
		if not v8 then
			return
		end
		local v10, v11 = v4.findEndAttachments(p1)
		local v122 = v3.getBezierPoints(Points)
		local v13 = Random.new()
		local v14 = not v10 and v5.new(v122)
		local v15 = v4.createHitboxParams({
			enabled = v12.hitboxEnabled,
			collisionGroup = v12.hitboxCollisionGroup,
			filterTag = v12.hitboxFilterTag,
			filterType = v12.hitboxFilterType,
			ignoreCanCollide = v12.hitboxIgnoreCanCollide
		}, v72, Points)
		local t = {}
		for i = 1, v12.emitCount do
			local v16 = v13:NextNumber(v22.rotSpeedStart.Min, v22.rotSpeedStart.Max)
			local v17 = v13:NextNumber(v22.rotSpeedEnd.Min, v22.rotSpeedEnd.Max)
			local v20 = vector.create(v13:NextNumber(v22.minInitRot.x, v22.maxInitRot.x), v13:NextNumber(v22.minInitRot.y, v22.maxInitRot.y), v13:NextNumber(v22.minInitRot.z, v22.maxInitRot.z))
			local v21 = v13:NextNumber(v12.duration.Min, v12.duration.Max)
			local v222 = v12.projectileEnabled and v13:NextNumber(v12.projectileLifetime.Min, v12.projectileLifetime.Max)
			local function f24(p12) --[[ Line: 154 | Upvalues: v4 (ref), v8 (copy), v9 (copy), v12 (copy), v32 (copy), v13 (copy), v10 (copy), v72 (copy), v14 (copy), v122 (copy), v11 (copy), v22 (copy), v3 (ref), v7 (ref), p2 (copy), p3 (copy), t (copy), v20 (copy), v16 (copy), RunService (ref), v15 (copy), v1 (ref), p1 (copy), v2 (ref), v21 (copy), v17 (copy), v222 (copy) ]]
				local v18 = v4.calculateEmissionCFrame(v8, v9, {
					face = v12.face,
					spreadAngle = v12.spreadAngle,
					mirror = v12.mirror,
					mirrorRot = v12.mirrorRot,
					partial = v12.partial,
					emissionDirection = v12.emissionDirection
				}, v32, v13, v10, v72:IsA("Attachment"))
				local v23 = v14 or v4.createBezierWithEndpoint(v122, v18, v10, v11)
				local v33 = v4.createPosGetter(v23, v122, v18, v10, v22.arcSpace)
				local v42 = v3.getRandomId()
				if not v7 then
					p12()
					return
				end
				local v5 = v7:get(v42)
				v5.CFrame = CFrame.new(v33(0))
				local v6 = v5._getReal()
				v3.copyProperties(p2, v6, v3.COPY_PART_PROPERTIES)
				v3.copyProperties(p2, v6, v3.COPY_EXTENDED_PART_PROPERTIES)
				local v73 = p2:Clone()
				for v82, v92 in v73:GetChildren() do
					v92.Parent = v6
				end
				v73:Destroy()
				local v102 = p3.effects.prepareEmitOnFinish(v6, p3)
				local Finished = p3.effects.emitNested(v6, p3.depth + 1, p3).Finished
				table.insert(t, Finished)
				local v123 = p3
				local function f13() --[[ Line: 199 | Upvalues: v7 (ref), v42 (copy) ]]
					if not v7 then
						return
					end
					v7:free(v42)
				end
				table.insert(v123, f13)
				local v142 = Vector3.new(0, 0, 0)
				local v152 = Vector3.new(0, 0, 0)
				local v162 = false
				local v172 = false
				local identity = CFrame.identity
				local speedStart = v12.speedStart
				local v182 = CFrame.fromOrientation(v20.x, v20.y, v20.z)
				local v19 = v16
				local function onFinish() --[[ onFinish | Line: 218 | Upvalues: v172 (ref), v12 (ref), v3 (ref), v72 (ref), v5 (copy), RunService (ref), p3 (ref), v102 (copy), v6 (copy), p12 (copy) ]]
					if v172 then
						return
					end
					if v12.syncPosition then
						local v1 = v3.getTransformedOriginExtents(v72)
						local v2 = v5.CFrame
						local function updatePos() --[[ updatePos | Line: 227 | Upvalues: v5 (ref), v3 (ref), v72 (ref), v1 (copy), v2 (copy) ]]
							v5.CFrame = v3.getTransformedOriginExtents(v72) * v1:ToObjectSpace(v2)
						end
						local v32 = v3.getRandomId()
						RunService:BindToRenderStep(v32, v3.RENDER_PRIORITY + p3.depth, updatePos)
						local function f5() --[[ Line: 235 | Upvalues: RunService (ref), v32 (copy) ]]
							RunService:UnbindFromRenderStep(v32)
						end
						table.insert(p3, f5)
					end
					v172 = true
					p3.effects.emitOnFinish(v102, v6, p3.depth + 1, p3).Finished:finally(function() --[[ Line: 243 | Upvalues: p12 (ref) ]]
						p12()
					end)
				end
				local function shapecast() --[[ shapecast | Line: 248 | Upvalues: v12 (ref), v6 (copy), v15 (ref) ]]
					if not v12.hitboxEnabled then
						return false
					end
					return workspace:GetPartsInPart(v6, v15)[1] ~= nil
				end
				local v202
				if v12.speedStart == v12.speedEnd or v1.getState(p1, "SpeedOverride", nil) then
					v202 = nil
				else
					v202 = v2.fromParams(v22.speedCurve, v22.speedDuration, function(p1, p2) --[[ Line: 261 | Upvalues: speedStart (ref), v3 (ref), v12 (ref) ]]
						speedStart = v3.lerp(v12.speedStart, v12.speedEnd, p1)
						return p2
					end)
					table.insert(p3, v202)
				end
				local function getEffectiveSpeed() --[[ getEffectiveSpeed | Line: 269 | Upvalues: v1 (ref), p1 (ref), speedStart (ref) ]]
					return v1.getState(p1, "SpeedOverride", speedStart)
				end
				local function isSpeedTweening() --[[ isSpeedTweening | Line: 273 | Upvalues: v202 (ref), v1 (ref), p1 (ref) ]]
					if v202 then
						return v202.Connected
					else
						return v1.getState(p1, "SpeedTweening", false)
					end
				end
				v4.createPropertyTween(p3, p1, "RotSpeed", v21, v16, v17, function(p1) --[[ Line: 278 | Upvalues: v19 (ref) ]]
					v19 = p1
				end, function() --[[ Line: 280 | Upvalues: getEffectiveSpeed (copy) ]]
					return getEffectiveSpeed()
				end, v202)
				local v223 = p3
				local fromParams = v2.fromParams
				local easingCurve = v22.easingCurve
				local v232 = v21
				local function f24(p12, p2, p3) --[[ Line: 290 | Upvalues: v33 (copy), v22 (ref), v21 (ref), identity (ref), v20 (ref), v19 (ref), v3 (ref), v182 (ref), v12 (ref), v5 (copy), v72 (ref), v8 (ref), v152 (ref), v142 (ref), v6 (copy), v15 (ref), onFinish (copy), v162 (ref), v1 (ref), p1 (ref), speedStart (ref), v202 (ref), v222 (ref) ]]
					local v13 = v33(p12)
					local v2 = CFrame.new(v13)
					if v22.facePath then
						local v4 = v33((math.clamp((p3 + 1 / 60) / v21, 0, 1)))
						v2 = if v13 == v4 then v2 * identity.Rotation else CFrame.lookAt(v13, v4)
					end
					local v62 = v20:Sign() * v19 * v3.DEG_TO_RAD * p2
					v182 = v182 * CFrame.fromOrientation(v62.x, v62.y, v62.z)
					identity = v2
					local v7 = v2 * v182
					if v12.syncPosition then
						v5.CFrame = v3.getTransformedOriginExtents(v72) * v8:ToObjectSpace(v7)
					else
						v5.CFrame = v7
					end
					v152 = (v13 - v142) / p2
					v142 = v13
					if if v12.hitboxEnabled then if workspace:GetPartsInPart(v6, v15)[1] == nil then false else true else false then
						onFinish()
						v162 = true
						return nil
					end
					local v9 = v1.getState(p1, "SpeedOverride", speedStart)
					speedStart = v9
					if v9 == 0 and not (if v202 then v202.Connected else v1.getState(p1, "SpeedTweening", false)) then
						return nil
					end
					if not (v12.projectileEnabled and p12 * v21 < v222) and v12.projectileEnabled then
						onFinish()
						return nil
					end
					return p2 * v9
				end
				local v25 = v202
				local function f26(p12) --[[ Line: 341 | Upvalues: v12 (ref), v162 (ref), onFinish (copy), v10 (ref), v152 (ref), v6 (copy), v3 (ref), v72 (ref), v2 (ref), v222 (ref), v5 (copy), v15 (ref), v1 (ref), p1 (ref), speedStart (ref), v202 (ref), p3 (ref) ]]
					if v12.projectileEnabled and not v162 then
						local v13 = if v12.projectileMatchEnd and v10 then v10.WorldCFrame.LookVector else v152.Unit
						if v13 ~= v13 then
							v13 = Vector3.new(0, 0, 0)
						end
						v152 = v13 * v12.projectileSpeed
						local Position = v6.Position
						local v22 = v3.getTransformedOriginExtents(v72)
						v2.timer(v222, function(p12, p2) --[[ Line: 363 | Upvalues: v12 (ref), v5 (ref), v3 (ref), v72 (ref), v22 (copy), Position (copy), v152 (ref), v6 (ref), v15 (ref), onFinish (ref), v162 (ref), v1 (ref), p1 (ref), speedStart (ref), v202 (ref) ]]
							if v12.syncPosition then
								v5.CFrame = v3.getTransformedOriginExtents(v72) * v22:ToObjectSpace(CFrame.new(Position + v152 * p2))
							else
								v5.CFrame = CFrame.new(Position + v152 * p2) * v6.CFrame.Rotation
							end
							if if v12.hitboxEnabled then if workspace:GetPartsInPart(v6, v15)[1] == nil then false else true else false then
								onFinish()
								v162 = true
								return nil
							end
							local v2 = v1.getState(p1, "SpeedOverride", speedStart)
							speedStart = v2
							if not (v2 > 0) then
								if not (p2 > 0) then
									return nil
								end
								if not (if v202 then v202.Connected else v1.getState(p1, "SpeedTweening", false)) then
									return nil
								end
							end
							return p12 * v2
						end, v202, p3, v3.RENDER_PRIORITY + p3.depth)
						if v162 then
							return
						end
					elseif not p12 then
						return
					end
					onFinish()
				end
				local v27 = v3.RENDER_PRIORITY + p3.depth
				table.insert(v223, fromParams(easingCurve, v232, f24, v25, f26, true, v27))
			end
			table.insert(t, v6.new(f24))
		end
		v6.all(t):await()
		task.wait(v12.destroyDelay)
	end
end
return t