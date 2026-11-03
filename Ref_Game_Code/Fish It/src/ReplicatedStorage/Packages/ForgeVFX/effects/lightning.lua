-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
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
function t.init(p1) --[[ init | Line: 16 | Upvalues: v7 (ref) ]]
	v7 = p1
end
function t.deinit() --[[ deinit | Line: 20 | Upvalues: v7 (ref) ]]
	v7 = nil
end
local function readLightningAttributes(p1) --[[ readLightningAttributes | Line: 24 | Upvalues: v1 (copy), v3 (copy) ]]
	local t = {}
	t.segments = math.max(v1.get(p1, "Segments", 8), 2)
	t.jaggedness = v1.getRange(p1, "Jaggedness", NumberRange.new(0.5, 1), NumberRange.new(0, (1 / 0)))
	t.offsetScale = v1.get(p1, "OffsetScale", 1)
	t.refreshRate = v1.get(p1, "RefreshRate", 15)
	t.independentSegments = v1.get(p1, "IndependentSegments", false)
	t.refreshDuringDissipate = v1.get(p1, "RefreshDuringDissipate", false)
	t.nestedEffectMode = v1.getEnum(p1, "NestedEffectMode", "None", { "None", "All", "Head", "Tail" })
	t.colorSequence = v1.get(p1, "Color", ColorSequence.new(Color3.new(255/255, 255/255, 255/255)))
	t.colorEasingData = v1.get(p1, "Color_Curve", v3.linear_bezier)
	t.colorDuration = v1.get(p1, "Color_Duration", 1)
	t.transparencyStart = v1.get(p1, "Transparency_Start", 0)
	t.transparencyEnd = v1.get(p1, "Transparency_End", 0)
	t.fillColorSequence = v1.get(p1, "Fill_Color", ColorSequence.new(Color3.new(255/255, 255/255, 255/255)))
	t.fillColorEasingData = v1.get(p1, "Fill_Color_Curve", v3.linear_bezier)
	t.fillColorDuration = v1.get(p1, "Fill_Color_Duration", 1)
	t.fillTransparencyStart = v1.get(p1, "Fill_Transparency_Start", 1)
	t.fillTransparencyEnd = v1.get(p1, "Fill_Transparency_End", 1)
	t.fillDepthMode = v1.getEnum(p1, "Fill_DepthMode", "Occluded", { "AlwaysOnTop", "Occluded" })
	t.fadeInStart = v1.get(p1, "Fade_In_Start", 1)
	t.fadeInDuration = v1.get(p1, "Fade_In_Duration", 0)
	t.fadeInCurveData = v1.get(p1, "Fade_In_Curve", v3.default_bezier)
	t.fadeOutEnd = v1.get(p1, "Fade_Out_End", 1)
	t.fadeOutDuration = v1.get(p1, "Fade_Out_Duration", 0)
	t.fadeOutCurveData = v1.get(p1, "Fade_Out_Curve", v3.default_bezier)
	t.lengthStart = v1.get(p1, "Length_Start", 1)
	t.lengthEnd = v1.get(p1, "Length_End", 1)
	t.dissipateMode = v1.getEnum(p1, "Dissipate_Mode", "None", { "None", "Retract", "Scale" })
	t.dissipateDuration = v1.get(p1, "Dissipate_Duration", 0.5)
	t.dissipateCurveData = v1.get(p1, "Dissipate_Curve", v3.default_bezier)
	t.widthStart = v1.get(p1, "Width_Start", 2)
	t.widthEnd = v1.get(p1, "Width_End", 0.2)
	return t
end
local function createSegmentStates(p1) --[[ createSegmentStates | Line: 77 ]]
	local t = {}
	for i = 1, p1 do
		t[i] = {
			birthTime = nil,
			initialWidth = nil,
			initialTransparency = nil,
			wasVisible = false
		}
	end
	return t
end
local function computeJaggedOffset(p1, p2, p3, p4, p5, p6) --[[ computeJaggedOffset | Line: 92 ]]
	local v2 = math.min(p1:NextNumber(p2.Min, p2.Max) * p3 * p4, p4 * 0.8)
	local v3 = p1:NextNumber(0, 6.283185307179586)
	return (p5 * math.cos(v3) + p6 * math.sin(v3)) * v2
end
local function generateLightningPoints(p1, p2, p3, p4, p5) --[[ generateLightningPoints | Line: 109 | Upvalues: v4 (copy) ]]
	local v1 = table.create(p2 + 1)
	v1[1] = p3(0)
	local v2 = v1[1]
	local v3 = 1 / p2
	for i = 1, p2 - 1 do
		local v42 = i * v3
		local v5 = p3(v42)
		local v6 = p3((math.min(v42 + 0.01, 1))) - v5
		local v8, v9 = v4.getPerpendicularVectors(if v6.Magnitude > 0.001 then v6.Unit else Vector3.new(0, 1, 0))
		local Magnitude = (v5 - v2).Magnitude
		local v11 = math.min(p1:NextNumber(p4.Min, p4.Max) * p5 * Magnitude, Magnitude * 0.8)
		local v12 = p1:NextNumber(0, 6.283185307179586)
		local v13 = v5 + (v8 * math.cos(v12) + v9 * math.sin(v12)) * v11
		v1[i + 1] = v13
		v2 = v13
	end
	v1[p2 + 1] = p3(1)
	return v1
end
local function generateProjectilePoints(p1, p2, p3, p4, p5, p6, p7) --[[ generateProjectilePoints | Line: 148 | Upvalues: v4 (copy) ]]
	local v1 = table.create(p2 + 1)
	local v2 = 1 / p2
	local v3 = p4 - p3
	local Magnitude = v3.Magnitude
	local v5, v6 = v4.getPerpendicularVectors(if Magnitude > 0.001 then v3 / Magnitude else p7)
	v1[1] = p3
	local v7 = Magnitude * v2
	for i = 1, p2 - 1 do
		local v8 = p3:Lerp(p4, i * v2)
		local v10 = math.min(p1:NextNumber(p5.Min, p5.Max) * p6 * v7, v7 * 0.8)
		local v11 = p1:NextNumber(0, 6.283185307179586)
		v1[i + 1] = v8 + (v5 * math.cos(v11) + v6 * math.sin(v11)) * v10
	end
	v1[p2 + 1] = p4
	return v1
end
local function getBlendedPosition(p1, p2, p3, p4, p5) --[[ getBlendedPosition | Line: 193 ]]
	local v3 = math.clamp((p5.distanceTraveled - (1 - p1) * p5.boltLength) / p5.transitionBuffer, 0, 1)
	return p2((math.min(1, p5.curvedTailT + p1 * p5.curvedLengthT + math.min(p5.distanceTraveled / p5.boltLength, 1) * p5.curvedLengthT))):Lerp(p3:Lerp(p4, p1), v3)
end
local function generateTransitionPoints(p1, p2, p3, p4, p5, p6, p7, p8, p9) --[[ generateTransitionPoints | Line: 217 | Upvalues: v4 (copy), getBlendedPosition (copy) ]]
	local v1 = table.create(p2 + 1)
	local v2 = table.create(p2 + 1)
	local v3 = 1 / p2
	local v42 = p5 - p4
	local Magnitude = v42.Magnitude
	local v6, v7 = v4.getPerpendicularVectors(if Magnitude > 0.001 then v42 / Magnitude else p8)
	local v8 = Magnitude * v3
	for i = 0, p2 do
		local v9 = getBlendedPosition(i * v3, p3, p4, p5, p9)
		if i == 0 or i == p2 then
			v1[i + 1] = v9
			v2[i + 1] = Vector3.new(0, 0, 0)
			continue
		end
		local v11 = math.min(p1:NextNumber(p6.Min, p6.Max) * p7 * v8, v8 * 0.8)
		local v12 = p1:NextNumber(0, 6.283185307179586)
		local v13 = (v6 * math.cos(v12) + v7 * math.sin(v12)) * v11
		v1[i + 1] = v9 + v13
		v2[i + 1] = v13
	end
	return v1, v2
end
local function updateTransitionPoints(p1, p2, p3, p4, p5) --[[ updateTransitionPoints | Line: 259 | Upvalues: getBlendedPosition (copy) ]]
	local v1 = table.create(p1 + 1)
	local jaggedOffsets = p5.jaggedOffsets
	local v2 = 1 / p1
	for i = 0, p1 do
		v1[i + 1] = getBlendedPosition(i * v2, p2, p3, p4, p5) + (if jaggedOffsets then jaggedOffsets[i + 1] else Vector3.new(0, 0, 0))
	end
	return v1
end
local function isTransitionComplete(p1) --[[ isTransitionComplete | Line: 281 ]]
	return p1.distanceTraveled >= p1.boltLength + p1.transitionBuffer
end
function t.emit(p1, p2, p3, p4) --[[ emit | Line: 285 | Upvalues: v7 (ref), v4 (copy), readLightningAttributes (copy), v3 (copy), v1 (copy), v2 (copy), v5 (copy), v6 (copy), createSegmentStates (copy), generateLightningPoints (copy), generateTransitionPoints (copy), generateProjectilePoints (copy), updateTransitionPoints (copy) ]]
	local Points = p1:FindFirstChild("Points")
	if not (Points and (Points:IsA("Attachment") and v7)) then
		return
	end
	local v12 = v4.readCommonAttributes(p1)
	local v22 = readLightningAttributes(p1)
	local v32 = v4.drawFuncMap[v12.shapeType] and v4.drawFuncMap[v12.shapeType][v12.shapeStyle]
	if not v32 then
		return
	end
	local v42 = if v12.emitDuration > 0 then true else false
	task.wait(v12.emitDelay)
	if v42 and not p4 then
		v3.forceEmit(p1, true)
		v1.trigger(p1, "Enabled", true)
		v3.onCancel(p3, function() --[[ Line: 310 | Upvalues: v3 (ref), p1 (copy) ]]
			local v1 = v3.stopEmitDuration(p1)
			if not v1 then
				return
			end
			v3.cancelToken(v1)
		end)
		if v12.speedStart ~= v12.speedEnd then
			v1.setState(p1, "SpeedTweening", true)
			local v52 = v1.get(p1, "Speed_Curve", v3.default_bezier)
			local v62 = v1.get(p1, "Speed_Duration", 0.1)
			local function f7(p12, p2) --[[ Line: 326 | Upvalues: v1 (ref), p1 (copy), v3 (ref), v12 (copy) ]]
				v1.setState(p1, "SpeedOverride", v3.lerp(v12.speedStart, v12.speedEnd, p12))
				return p2
			end
			local function f8() --[[ Line: 331 | Upvalues: v1 (ref), p1 (copy) ]]
				v1.setState(p1, "SpeedTweening", nil)
			end
			table.insert(p3, v2.fromParams(v52, v62, f7, nil, f8))
		end
		task.wait(v12.emitDuration)
		v3.awaitEmitDuration(v3.stopEmitDuration(p1))
	else
		if v12.emitCount <= 0 then
			return
		end
		local v9 = v4.validateParent(p1)
		if not v9 then
			return
		end
		local v10, v11 = v3.getTransformedOriginExtents(v9)
		if not v10 then
			return
		end
		local v122, v13 = v4.findEndAttachments(p1)
		local v14 = v3.getBezierPoints(Points)
		local v15 = Random.new()
		local v16 = not v122 and v5.new(v14)
		local v17 = v5.new(v3.deserializePath(v22.colorEasingData), 0)
		local v18 = v5.new(v3.deserializePath(v22.fillColorEasingData), 0)
		local v19 = v5.new(v3.deserializePath(v22.fadeInCurveData), 0)
		local v20 = v5.new(v3.deserializePath(v22.fadeOutCurveData), 0)
		local v21 = v4.createHitboxParams({
			enabled = v12.hitboxEnabled,
			collisionGroup = v12.hitboxCollisionGroup,
			filterTag = v12.hitboxFilterTag,
			filterType = v12.hitboxFilterType,
			ignoreCanCollide = v12.hitboxIgnoreCanCollide
		}, v9, Points)
		local t = {}
		for i = 1, v12.emitCount do
			local v222 = v15:NextNumber(v12.duration.Min, v12.duration.Max)
			local v23 = v12.projectileEnabled and v15:NextNumber(v12.projectileLifetime.Min, v12.projectileLifetime.Max)
			local function f25(p12) --[[ Line: 390 | Upvalues: v4 (ref), v10 (copy), v11 (copy), v12 (copy), v32 (copy), v15 (copy), v122 (copy), v9 (copy), v16 (copy), v14 (copy), v13 (copy), v22 (copy), createSegmentStates (ref), v7 (ref), v18 (copy), p3 (copy), p2 (copy), v3 (ref), generateLightningPoints (ref), t (copy), v1 (ref), p1 (copy), v2 (ref), v21 (copy), generateTransitionPoints (ref), generateProjectilePoints (ref), updateTransitionPoints (ref), v17 (copy), v19 (copy), v20 (copy), v222 (copy), v23 (copy) ]]
				local v110 = v4.calculateEmissionCFrame(v10, v11, {
					face = v12.face,
					spreadAngle = v12.spreadAngle,
					mirror = v12.mirror,
					mirrorRot = v12.mirrorRot,
					partial = v12.partial,
					emissionDirection = v12.emissionDirection
				}, v32, v15, v122, v9:IsA("Attachment"))
				local v24 = v16 or v4.createBezierWithEndpoint(v14, v110, v122, v13)
				local v33 = v4.createPosGetter(v24, v14, v110, v122, true)
				local v42 = table.create(v22.segments)
				local v5 = table.create(v22.segments)
				local v6 = createSegmentStates(v22.segments)
				local v72 = 1 / v22.segments
				local v8 = table.create(v22.segments)
				for i = 1, v22.segments do
					v8[i] = {
						start = (i - 1) * v72,
						finish = i * v72
					}
				end
				if not v7 then
					p12()
					return
				end
				local v92 = if v22.fillTransparencyStart < 1 then true else v22.fillTransparencyEnd < 1
				local v102, v112
				if v92 then
					local LightningContainer = Instance.new("Model")
					LightningContainer.Name = "LightningContainer"
					LightningContainer.Parent = workspace.Terrain
					local Highlight = Instance.new("Highlight")
					Highlight.Adornee = LightningContainer
					Highlight.FillColor = v4.getColorWithEasingOklab(v22.fillColorSequence, 0, v18)
					Highlight.FillTransparency = v22.fillTransparencyStart
					Highlight.OutlineTransparency = 1
					Highlight.DepthMode = Enum.HighlightDepthMode[v22.fillDepthMode]
					Highlight.Parent = LightningContainer
					v102 = Highlight
					v112 = LightningContainer
				else
					v102 = nil
					v112 = nil
				end
				local function shouldEmitNested(p1) --[[ shouldEmitNested | Line: 448 | Upvalues: v22 (ref) ]]
					local nestedEffectMode = v22.nestedEffectMode
					if nestedEffectMode == "All" then
						return true
					end
					if nestedEffectMode == "Head" then
						return p1 == v22.segments
					else
						if nestedEffectMode ~= "Tail" then
							return false
						end
						return p1 == 1
					end
				end
				local v123 = if v22.nestedEffectMode == "None" then nil else p3.effects.prepareEmitOnFinish(p2, p3)
				local t2 = {}
				local t3 = {}
				for j = 1, v22.segments do
					local v132
					local v142 = v3.getRandomId()
					local v152 = v7:get(v142)._getReal()
					v3.copyProperties(p2, v152, v3.COPY_PART_PROPERTIES)
					v152.Size = Vector3.new(v22.widthStart, v22.widthStart, 1)
					v152.Anchored = true
					v152.CanQuery = false
					v152.CanTouch = false
					v152.CanCollide = false
					if v92 and v112 then
						v152.Parent = v112
					end
					local nestedEffectMode = v22.nestedEffectMode
					v132 = if nestedEffectMode == "All" then true elseif nestedEffectMode == "Head" then j == v22.segments elseif nestedEffectMode == "Tail" then j == 1 else false
					if v132 then
						local v162 = p2:Clone()
						for v172, v182 in v162:GetChildren() do
							v182.Parent = v152
							if v22.nestedEffectMode == "Head" then
								table.insert(t2, v182)
							end
						end
						v162:Destroy()
						table.insert(t3, j)
					end
					v42[j] = v152
					v5[j] = v142
				end
				local v192
				if v22.nestedEffectMode == "Head" and #t2 > 0 then
					for v202, v212 in t2 do
						v212.Parent = v42[1]
					end
					v192 = 1
				else
					v192 = nil
				end
				local v223 = p3
				local function f23() --[[ Line: 521 | Upvalues: v7 (ref), v22 (ref), v5 (copy), v112 (ref) ]]
					if not v7 then
						return
					end
					for i = 1, v22.segments do
						v7:free(v5[i])
					end
					if not v112 then
						return
					end
					v112:Destroy()
				end
				table.insert(v223, f23)
				local v242 = v112 or p2
				local speedStart = v12.speedStart
				local widthStart = v22.widthStart
				local lengthStart = v22.lengthStart
				local transparencyStart = v22.transparencyStart
				local fillTransparencyStart = v22.fillTransparencyStart
				local v25 = generateLightningPoints(v15, v22.segments, v33, v22.jaggedness, v22.offsetScale)
				local v26 = 0
				local v27 = 0
				local v28 = false
				local v29 = 0
				for v30, v31 in t3 do
					local Finished = p3.effects.emitNested(v42[if v22.nestedEffectMode == "Head" then 1 else v31], p3.depth + 1, p3).Finished
					table.insert(t, Finished)
				end
				local v34 = Vector3.new(0, 0, 0)
				local v35 = Vector3.new(0, 0, 0)
				local v36 = 0
				local v37 = false
				local v38 = 0
				local v39 = 0
				local v40 = 0
				local widthStart_2 = v22.widthStart
				local v41 = v10
				local v422 = nil
				local v43 = nil
				local v44 = nil
				local v45 = nil
				local v46
				if v12.speedStart == v12.speedEnd or v1.getState(p1, "SpeedOverride", nil) then
					v46 = nil
				else
					v46 = v2.fromParams(v1.get(p1, "Speed_Curve", v3.default_bezier), v1.get(p1, "Speed_Duration", 0.1), function(p1, p2) --[[ Line: 586 | Upvalues: speedStart (ref), v3 (ref), v12 (ref) ]]
						speedStart = v3.lerp(v12.speedStart, v12.speedEnd, p1)
						return p2
					end)
					table.insert(p3, v46)
				end
				local function getEffectiveSpeed() --[[ getEffectiveSpeed | Line: 595 | Upvalues: v1 (ref), p1 (ref), speedStart (ref) ]]
					return v1.getState(p1, "SpeedOverride", speedStart)
				end
				local function isSpeedTweening() --[[ isSpeedTweening | Line: 599 | Upvalues: v46 (ref), v1 (ref), p1 (ref) ]]
					if v46 then
						return v46.Connected
					else
						return v1.getState(p1, "SpeedTweening", false)
					end
				end
				local function getSpeedDelta(p12, p2) --[[ getSpeedDelta | Line: 603 | Upvalues: v1 (ref), p1 (ref), speedStart (ref), v46 (ref) ]]
					local v12 = v1.getState(p1, "SpeedOverride", speedStart)
					speedStart = v12
					if v12 > 0 then
						return p12 * v12
					end
					if not (p2 or (if v46 then v46.Connected else v1.getState(p1, "SpeedTweening", false))) then
						return nil
					end
					return p12 * v12
				end
				local function getHeadSegmentIndex() --[[ getHeadSegmentIndex | Line: 616 | Upvalues: v38 (ref), v22 (ref) ]]
					local v2 = math.ceil(v38 * v22.segments)
					return math.clamp(v2, 1, v22.segments)
				end
				local function shapecast() --[[ shapecast | Line: 620 | Upvalues: v12 (ref), v42 (copy), v38 (ref), v22 (ref), v21 (ref) ]]
					if v12.hitboxEnabled then
						local v4 = v42[math.clamp(math.ceil(v38 * v22.segments), 1, v22.segments)]
						return v4 and (v4.Transparency < 1 and workspace:GetPartsInPart(v4, v21)[1]) and true or false
					else
						return false
					end
				end
				local function refreshPoints() --[[ refreshPoints | Line: 639 | Upvalues: v43 (ref), v44 (ref), v422 (ref), v45 (ref), v25 (ref), generateTransitionPoints (ref), v15 (ref), v22 (ref), v33 (copy), generateProjectilePoints (ref), generateLightningPoints (ref) ]]
					if v43 and (v44 and v422) then
						if v45 then
							local v1 = v45
							if not (v1.distanceTraveled >= v1.boltLength + v1.transitionBuffer) then
								local v4, v5 = generateTransitionPoints(v15, v22.segments, v33, v44, v43, v22.jaggedness, v22.offsetScale, v422, v45)
								v25 = v4
								v45.jaggedOffsets = v5
								return
							end
						end
						v25 = generateProjectilePoints(v15, v22.segments, v44, v43, v22.jaggedness, v22.offsetScale, v422)
						if v45 then
							v45.jaggedOffsets = nil
						end
					else
						v25 = generateLightningPoints(v15, v22.segments, v33, v22.jaggedness, v22.offsetScale)
					end
				end
				local function updatePointsBetweenRefreshes(p1) --[[ updatePointsBetweenRefreshes | Line: 674 | Upvalues: v45 (ref), v25 (ref), updateTransitionPoints (ref), v22 (ref), v33 (copy), v44 (ref), v43 (ref), generateTransitionPoints (ref), v15 (ref), v422 (ref), v12 (ref) ]]
					if v45 then
						local v1 = v45
						if not (v1.distanceTraveled >= v1.boltLength + v1.transitionBuffer) then
							if v45.jaggedOffsets then
								v25 = updateTransitionPoints(v22.segments, v33, v44, v43, v45)
							else
								local v4, v5 = generateTransitionPoints(v15, v22.segments, v33, v44, v43, v22.jaggedness, v22.offsetScale, v422, v45)
								v25 = v4
								v45.jaggedOffsets = v5
							end
							return
						end
					end
					local v6 = v422 * v12.projectileSpeed * p1
					for i = 1, #v25 do
						v25[i] = v25[i] + v6
					end
				end
				local function updateSegments(p1, p2, p3, p4, p5) --[[ updateSegments | Line: 708 | Upvalues: v38 (ref), lengthStart (ref), widthStart (ref), v22 (ref), v29 (ref), refreshPoints (copy), v6 (copy), v8 (copy), v42 (copy), transparencyStart (ref), v4 (ref), v26 (ref), v17 (ref), v36 (ref), v19 (ref), v3 (ref), v37 (ref), v39 (ref), v20 (ref), v25 (ref), v102 (ref), v27 (ref), v18 (ref), fillTransparencyStart (ref), v192 (ref), t2 (copy), v33 (copy), v34 (ref), v35 (ref) ]]
					local v1 = os.clock()
					v38 = p1
					local v2 = p2 or math.max(0, p1 - lengthStart)
					local v43 = if p5 then p5 else widthStart
					if p4 ~= false and v22.refreshRate > 0 then
						v29 = v29 + p3
						if 1 / v22.refreshRate <= v29 then
							refreshPoints()
							v29 = 0
						end
					end
					for i = 1, v22.segments do
						local v62, v7, v82, v9, v10
						local v11 = v6[i]
						local v12 = v8[i]
						local v13 = v42[i]
						local start = v12.start
						local finish = v12.finish
						if if v2 < finish then if start < p1 then true else false else false then
							if not v11.wasVisible then
								v11.wasVisible = true
								v11.birthTime = v1
								v11.initialWidth = widthStart
								v11.initialTransparency = transparencyStart
							end
							v13.Color = v4.getColorWithEasingOklab(v22.colorSequence, v26, v17)
							v62 = if v22.independentSegments and v11.initialTransparency then v11.initialTransparency else transparencyStart
							v7 = if v22.fadeInDuration > 0 then math.clamp(v36 / v22.fadeInDuration, 0, 1) else 1
							local v172 = v3.lerp(v22.fadeInStart, v62, 1 - v19:getEase(v7).y)
							v82 = if v37 and v22.fadeOutDuration > 0 then v3.lerp(v62, v22.fadeOutEnd, 1 - v20:getEase((math.clamp(v39 / v22.fadeOutDuration, 0, 1))).y) else v62
							v13.Transparency = if v7 < 1 then v172 elseif v37 then v82 else v62
							if p5 then
								v9 = if v22.independentSegments and v11.initialWidth then v11.initialWidth else widthStart
								v10 = v9 * (if widthStart > 0 then p5 / widthStart else 0)
							else
								v10 = if v22.independentSegments and v11.initialWidth then v11.initialWidth else v43
							end
							local v23 = v25[i]
							local v24 = v25[i + 1]
							if v23 and v24 then
								local v252 = if start < v2 then v23:Lerp(v24, (v2 - start) / (finish - start)) else v23
								local v262 = if p1 < finish then v23:Lerp(v24, (p1 - start) / (finish - start)) else v24
								local v272 = (v252 + v262) / 2
								local Magnitude = (v262 - v252).Magnitude
								if Magnitude > 0.001 then
									v13.Size = Vector3.new(v10, v10, Magnitude)
									v13.CFrame = CFrame.lookAt(v272, v262)
								end
							end
							continue
						end
						v13.Transparency = 1
						if v11.wasVisible then
							v11.wasVisible = false
							v11.birthTime = nil
							v11.initialWidth = nil
							v11.initialTransparency = nil
						end
					end
					if v102 then
						v102.FillColor = v4.getColorWithEasingOklab(v22.fillColorSequence, v27, v18)
						v102.FillTransparency = fillTransparencyStart
					end
					if v192 then
						local v30 = math.clamp(math.ceil(p1 * v22.segments), 1, v22.segments)
						if v30 ~= v192 then
							local v31 = v42[v30]
							for v32, v332 in t2 do
								v332.Parent = v31
							end
							v192 = v30
						end
					end
					local v342 = v33((math.min(p1, 1)))
					if p3 > 0 then
						v34 = (v342 - v35) / p3
					end
					v35 = v342
				end
				v4.createPropertyTween(p3, p1, "Width", v222, v22.widthStart, v22.widthEnd, function(p1) --[[ Line: 868 | Upvalues: widthStart (ref) ]]
					widthStart = p1
				end, getEffectiveSpeed, v46)
				v4.createPropertyTween(p3, p1, "Transparency", v222, v22.transparencyStart, v22.transparencyEnd, function(p1) --[[ Line: 879 | Upvalues: transparencyStart (ref) ]]
					transparencyStart = p1
				end, getEffectiveSpeed, v46)
				v4.createPropertyTween(p3, p1, "Length", v222, v22.lengthStart, v22.lengthEnd, function(p1) --[[ Line: 893 | Upvalues: lengthStart (ref) ]]
					lengthStart = p1
				end, getEffectiveSpeed, v46)
				if v92 then
					v4.createPropertyTween(p3, p1, "FillTransparency", v22.fillColorDuration, v22.fillTransparencyStart, v22.fillTransparencyEnd, function(p1) --[[ Line: 908 | Upvalues: fillTransparencyStart (ref) ]]
						fillTransparencyStart = p1
					end, getEffectiveSpeed, v46)
				end
				local function handleDissipation(p12, p2, p32, p4, p5, p6, p7) --[[ handleDissipation | Line: 917 | Upvalues: v37 (ref), v40 (ref), widthStart_2 (ref), v2 (ref), v39 (ref), v1 (ref), p1 (ref), speedStart (ref), v36 (ref), v22 (ref), v26 (ref), v27 (ref), v3 (ref), updateSegments (copy), v46 (ref), p3 (ref) ]]
					v37 = true
					v40 = p2
					widthStart_2 = p32
					v2.fromParams(p4, p5, function(p13_2_2, p2_2_2, p3_2_2) --[[ Line: 930 | Upvalues: v39 (ref), v1 (ref), p1 (ref), speedStart (ref), v36 (ref), v22 (ref), v26 (ref), v27 (ref), p6 (copy), v3 (ref), v40 (ref), p12 (copy), widthStart_2 (ref), updateSegments (ref) ]]
						v39 = p3_2_2
						local v12_2 = p2_2_2 * v1.getState(p1, "SpeedOverride", speedStart)
						v36 = v36 + v12_2
						if v22.refreshDuringDissipate then
							v26 = (v26 + v12_2 / v22.colorDuration) % 1
							v27 = (v27 + v12_2 / v22.fillColorDuration) % 1
						end
						updateSegments(p12, if p6 == "Retract" then v3.lerp(v40, p12, p13_2_2) else nil, v12_2, v22.refreshDuringDissipate, if p6 == "Scale" then v3.lerp(widthStart_2, 0, p13_2_2) else nil)
						local v4 = v1.getState(p1, "SpeedOverride", speedStart)
						speedStart = v4
						return p2_2_2 * v4
					end, v46, p7, true, v3.RENDER_PRIORITY + p3.depth)
				end
				local function startDissipation() --[[ startDissipation | Line: 950 | Upvalues: v37 (ref), v28 (ref), v38 (ref), v123 (copy), p3 (ref), v242 (copy), p12 (copy), v22 (ref), lengthStart (ref), widthStart (ref), v40 (ref), widthStart_2 (ref), v2 (ref), v39 (ref), v1 (ref), p1 (ref), speedStart (ref), v36 (ref), v26 (ref), v27 (ref), v3 (ref), updateSegments (copy), v46 (ref) ]]
					if v37 or v28 then
						return
					end
					local v12 = v38
					local v23 = if v123 then p3.effects.emitOnFinish(v123, v242, p3.depth + 1, p3) else nil
					local function onDissipationComplete() --[[ onDissipationComplete | Line: 961 | Upvalues: v28 (ref), v23 (copy), p12 (ref) ]]
						if v28 then
							return
						end
						v28 = true
						if v23 then
							v23.Finished:finally(function() --[[ Line: 969 | Upvalues: p12 (ref) ]]
								p12()
							end)
						else
							p12()
						end
					end
					if v22.dissipateMode ~= "None" then
						local v4 = math.max(0, v12 - lengthStart)
						local dissipateCurveData = v22.dissipateCurveData
						local dissipateDuration = v22.dissipateDuration
						local dissipateMode = v22.dissipateMode
						v37 = true
						v40 = v4
						widthStart_2 = widthStart
						v2.fromParams(dissipateCurveData, dissipateDuration, function(p13_2_2, p2_2_2, p3_2_2) --[[ Line: 930 | Upvalues: v39 (ref), v1 (ref), p1 (ref), speedStart (ref), v36 (ref), v22 (ref), v26 (ref), v27 (ref), dissipateMode (copy), v3 (ref), v40 (ref), v12 (copy), widthStart_2 (ref), updateSegments (ref) ]]
							v39 = p3_2_2
							local v12_2 = p2_2_2 * v1.getState(p1, "SpeedOverride", speedStart)
							v36 = v36 + v12_2
							if v22.refreshDuringDissipate then
								v26 = (v26 + v12_2 / v22.colorDuration) % 1
								v27 = (v27 + v12_2 / v22.fillColorDuration) % 1
							end
							updateSegments(v12, if dissipateMode == "Retract" then v3.lerp(v40, v12, p13_2_2) else nil, v12_2, v22.refreshDuringDissipate, if dissipateMode == "Scale" then v3.lerp(widthStart_2, 0, p13_2_2) else nil)
							local v4 = v1.getState(p1, "SpeedOverride", speedStart)
							speedStart = v4
							return p2_2_2 * v4
						end, v46, onDissipationComplete, true, v3.RENDER_PRIORITY + p3.depth)
						return
					end
					if v22.fadeOutDuration > 0 then
						local v7 = math.max(0, v12 - lengthStart)
						local fadeOutCurveData = v22.fadeOutCurveData
						local fadeOutDuration = v22.fadeOutDuration
						v37 = true
						v40 = v7
						widthStart_2 = widthStart
						local v9 = "None"
						v2.fromParams(fadeOutCurveData, fadeOutDuration, function(p13_2_2, p2_2_2, p3_2_2) --[[ Line: 930 | Upvalues: v39 (ref), v1 (ref), p1 (ref), speedStart (ref), v36 (ref), v22 (ref), v26 (ref), v27 (ref), v9 (copy), v3 (ref), v40 (ref), v12 (copy), widthStart_2 (ref), updateSegments (ref) ]]
							v39 = p3_2_2
							local v12_2 = p2_2_2 * v1.getState(p1, "SpeedOverride", speedStart)
							v36 = v36 + v12_2
							if v22.refreshDuringDissipate then
								v26 = (v26 + v12_2 / v22.colorDuration) % 1
								v27 = (v27 + v12_2 / v22.fillColorDuration) % 1
							end
							updateSegments(v12, if v9 == "Retract" then v3.lerp(v40, v12, p13_2_2) else nil, v12_2, v22.refreshDuringDissipate, if v9 == "Scale" then v3.lerp(widthStart_2, 0, p13_2_2) else nil)
							local v4 = v1.getState(p1, "SpeedOverride", speedStart)
							speedStart = v4
							return p2_2_2 * v4
						end, v46, onDissipationComplete, true, v3.RENDER_PRIORITY + p3.depth)
						return
					end
					if v28 then
						return
					end
					v28 = true
					if v23 then
						v23.Finished:finally(function() --[[ Line: 969 | Upvalues: p12 (ref) ]]
							p12()
						end)
					else
						p12()
					end
				end
				local v48 = p3
				local fromParams = v2.fromParams
				local v49 = v1.get(p1, "Easing_Curve", v3.linear_bezier)
				local v50 = v222
				local function f51(p12, p2, p3) --[[ Line: 1008 | Upvalues: v1 (ref), p1 (ref), speedStart (ref), v36 (ref), v26 (ref), v22 (ref), v27 (ref), v12 (ref), v3 (ref), v9 (ref), v41 (ref), v25 (ref), updateSegments (copy), v42 (copy), v38 (ref), v21 (ref), startDissipation (copy), v46 (ref), v222 (ref), v23 (ref) ]]
					local v13 = p2 * v1.getState(p1, "SpeedOverride", speedStart)
					v36 = v36 + v13
					v26 = (v26 + v13 / v22.colorDuration) % 1
					v27 = (v27 + v13 / v22.fillColorDuration) % 1
					if v12.syncPosition then
						local v2 = v3.getTransformedOriginExtents(v9)
						local v32 = v2 * v41:Inverse()
						for i = 1, #v25 do
							v25[i] = v32:PointToWorldSpace(v41:PointToObjectSpace(v25[i]))
						end
						v41 = v2
					end
					updateSegments(p12, nil, v13)
					local v4
					if v12.hitboxEnabled then
						local v8 = v42[math.clamp(math.ceil(v38 * v22.segments), 1, v22.segments)]
						v4 = if v8 and (v8.Transparency < 1 and workspace:GetPartsInPart(v8, v21)[1]) then true else false
					else
						v4 = false
					end
					if v4 then
						startDissipation()
						return nil
					end
					local v92 = v1.getState(p1, "SpeedOverride", speedStart)
					speedStart = v92
					local v10 = if v92 > 0 then p2 * v92 elseif if v46 then v46.Connected else v1.getState(p1, "SpeedTweening", false) then p2 * v92 else nil
					if v10 == nil then
						return nil
					end
					if not (v12.projectileEnabled and p12 * v222 < v23) and v12.projectileEnabled then
						startDissipation()
						return nil
					end
					return v10
				end
				local v52 = v46
				local function f53() --[[ Line: 1048 | Upvalues: v37 (ref), v28 (ref), v12 (ref), v2 (ref), v3 (ref), v1 (ref), p1 (ref), speedStart (ref), v36 (ref), v26 (ref), v22 (ref), v27 (ref), updateSegments (copy), v42 (copy), v38 (ref), v21 (ref), startDissipation (copy), v46 (ref), p3 (ref), v122 (ref), v34 (ref), v33 (copy), lengthStart (ref), v25 (ref), v45 (ref), v23 (ref), v43 (ref), v44 (ref), v422 (ref), v29 (ref), refreshPoints (copy), updatePointsBetweenRefreshes (copy) ]]
					if v37 or v28 then
						return
					end
					if v12.projectileEnabled then
						local v13 = if v12.projectileMatchEnd and v122 then v122.WorldCFrame.LookVector else v34.Unit
						local v24 = if v13 == v13 and not (v13.Magnitude < 0.001) then v13.Unit else Vector3.new(0, 0, 1)
						local v32 = v33(1)
						local Magnitude = (v32 - v33((math.max(0, 1 - lengthStart)))).Magnitude
						local v6 = math.max(0, 1 - lengthStart)
						local v7 = table.create(v22.segments + 1)
						local v8 = 1 - v6
						for i = 0, v22.segments do
							v7[i + 1] = v25[i + 1] - v33(v6 + i / v22.segments * v8)
						end
						local t = {
							distanceTraveled = 0,
							curvedTailT = v6,
							curvedLengthT = v8,
							boltLength = Magnitude,
							transitionBuffer = Magnitude * 0.3,
							jaggedOffsets = v7
						}
						v45 = t
						v2.timer(v23, function(p12, p2) --[[ Line: 1132 | Upvalues: v1 (ref), p1 (ref), speedStart (ref), v36 (ref), v26 (ref), v22 (ref), v27 (ref), v12 (ref), t (copy), v32 (copy), v24 (ref), Magnitude (copy), v43 (ref), v44 (ref), v422 (ref), v29 (ref), refreshPoints (ref), updatePointsBetweenRefreshes (ref), updateSegments (ref), v42 (ref), v38 (ref), v21 (ref), startDissipation (ref), v23 (ref) ]]
							local v13 = p12 * v1.getState(p1, "SpeedOverride", speedStart)
							v36 = v36 + v13
							v26 = (v26 + v13 / v22.colorDuration) % 1
							v27 = (v27 + v13 / v22.fillColorDuration) % 1
							local v2 = p2 * v12.projectileSpeed
							t.distanceTraveled = v2
							local v3 = v32 + v24 * v2
							v43 = v3
							v44 = v3 - v24 * Magnitude
							v422 = v24
							if v22.refreshRate > 0 then
								v29 = v29 + v13
								if v29 >= 1 / v22.refreshRate then
									refreshPoints()
									v29 = 0
								else
									updatePointsBetweenRefreshes(p12)
								end
							else
								updatePointsBetweenRefreshes(p12)
							end
							updateSegments(1, nil, v13, false)
							local v6
							if v12.hitboxEnabled then
								local v10 = v42[math.clamp(math.ceil(v38 * v22.segments), 1, v22.segments)]
								v6 = if v10 and (v10.Transparency < 1 and workspace:GetPartsInPart(v10, v21)[1]) then true else false
							else
								v6 = false
							end
							if v6 then
								startDissipation()
								return nil
							end
							if v23 <= p2 then
								return nil
							end
							local v11 = v1.getState(p1, "SpeedOverride", speedStart)
							speedStart = v11
							return p12 * v11
						end, v46, p3, v3.RENDER_PRIORITY + p3.depth)
						startDissipation()
					elseif v12.destroyDelay > 0 then
						v2.fromParams(v3.linear_bezier, v12.destroyDelay, function(p12, p2) --[[ Line: 1059 | Upvalues: v1 (ref), p1 (ref), speedStart (ref), v36 (ref), v26 (ref), v22 (ref), v27 (ref), updateSegments (ref), v12 (ref), v42 (ref), v38 (ref), v21 (ref), startDissipation (ref) ]]
							local v13 = p2 * v1.getState(p1, "SpeedOverride", speedStart)
							v36 = v36 + v13
							v26 = (v26 + v13 / v22.colorDuration) % 1
							v27 = (v27 + v13 / v22.fillColorDuration) % 1
							updateSegments(1, nil, v13, true)
							local v2
							if v12.hitboxEnabled then
								local v6 = v42[math.clamp(math.ceil(v38 * v22.segments), 1, v22.segments)]
								v2 = if v6 and (v6.Transparency < 1 and workspace:GetPartsInPart(v6, v21)[1]) then true else false
							else
								v2 = false
							end
							if v2 then
								startDissipation()
								return nil
							end
							local v7 = v1.getState(p1, "SpeedOverride", speedStart)
							speedStart = v7
							return p2 * v7
						end, v46, function() --[[ Line: 1076 | Upvalues: startDissipation (ref) ]]
							startDissipation()
						end, true, v3.RENDER_PRIORITY + p3.depth)
					else
						startDissipation()
					end
				end
				local v54 = v3.RENDER_PRIORITY + p3.depth
				table.insert(v48, fromParams(v49, v50, f51, v52, f53, true, v54))
			end
			table.insert(t, v6.new(f25))
		end
		v6.all(t):await()
	end
end
return t