-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local v1 = require("../attributes")
local v2 = require("../shape")
local v3 = require("../tween")
local v4 = require("../utility")
local v5 = require("../color/Oklab")
local v6 = require("../../obj/Bezier")
local t = {
	drawFuncMap = {
		Box = {
			Volume = v2.getPointWithinBox,
			Surface = v2.getPointOnBox
		},
		Cylinder = {
			Volume = function(p1, p2, p3, p4, p5) --[[ Volume | Line: 21 | Upvalues: v2 (copy) ]]
				return v2.getPointWithinCylinder(p1, 0, p5, p2, p3, p4)
			end,
			Surface = function(p1, p2, p3, p4, p5) --[[ Surface | Line: 25 | Upvalues: v2 (copy) ]]
				return v2.getPointWithinCylinder(p1, 1, p5, p2, p3, p4)
			end
		},
		Sphere = {
			Volume = function(p1, p2, p3, p4, p5) --[[ Volume | Line: 31 | Upvalues: v2 (copy) ]]
				return v2.getPointWithinSphere(p1, 0, p5, p2, p3, p4)
			end,
			Surface = function(p1, p2, p3, p4, p5) --[[ Surface | Line: 35 | Upvalues: v2 (copy) ]]
				return v2.getPointWithinSphere(p1, 1, p5, p2, p3, p4)
			end
		},
		Disc = {
			Volume = function(p1, p2, p3, p4, p5) --[[ Volume | Line: 41 | Upvalues: v2 (copy) ]]
				return v2.getPointWithinDisc(p1, 0, p5, p2, p3, p4)
			end,
			Surface = function(p1, p2, p3, p4, p5) --[[ Surface | Line: 45 | Upvalues: v2 (copy) ]]
				return v2.getPointWithinDisc(p1, 1, p5, p2, p3, p4)
			end
		}
	},
	getColorAtTime = function(p1, p2) --[[ getColorAtTime | Line: 51 ]]
		local Keypoints = p1.Keypoints
		if p2 <= Keypoints[1].Time then
			return Keypoints[1].Value
		end
		if Keypoints[#Keypoints].Time <= p2 then
			return Keypoints[#Keypoints].Value
		end
		local v1 = nil
		local v2 = nil
		for i = 1, #Keypoints do
			local v3 = Keypoints[i]
			if v3.Time == p2 then
				return v3.Value
			end
			if v3.Time < p2 then
				v1 = v3
				continue
			end
			if p2 < v3.Time then
				v2 = v3
				break
			end
		end
		if v1 and v2 then
			return v1.Value:Lerp(v2.Value, (p2 - v1.Time) / (v2.Time - v1.Time))
		else
			return Keypoints[1].Value
		end
	end,
	getColorAtTimeOklab = function(p1, p2) --[[ getColorAtTimeOklab | Line: 85 | Upvalues: v5 (copy) ]]
		local Keypoints = p1.Keypoints
		if p2 <= Keypoints[1].Time then
			return Keypoints[1].Value
		end
		if Keypoints[#Keypoints].Time <= p2 then
			return Keypoints[#Keypoints].Value
		end
		local v1 = nil
		local v2 = nil
		for i = 1, #Keypoints do
			local v3 = Keypoints[i]
			if v3.Time == p2 then
				return v3.Value
			end
			if v3.Time < p2 then
				v1 = v3
				continue
			end
			if p2 < v3.Time then
				v2 = v3
				break
			end
		end
		if v1 and v2 then
			return v5.toSRGB((v5.fromSRGB(v1.Value):Lerp(v5.fromSRGB(v2.Value), (p2 - v1.Time) / (v2.Time - v1.Time))))
		else
			return Keypoints[1].Value
		end
	end
}
function t.getColorWithEasingOklab(p1, p2, p3) --[[ getColorWithEasingOklab | Line: 125 | Upvalues: t (copy) ]]
	return t.getColorAtTimeOklab(p1, (math.clamp(1 - p3:getEase((math.clamp(p2, 0, 1))).y, 0, 1)))
end
function t.createHitboxParams(p1, p2, p3) --[[ createHitboxParams | Line: 138 | Upvalues: CollectionService (copy) ]]
	local v1 = OverlapParams.new()
	v1.MaxParts = 1
	v1.FilterType = Enum.RaycastFilterType[p1.filterType]
	v1.CollisionGroup = p1.collisionGroup
	v1.RespectCanCollide = not p1.ignoreCanCollide
	v1:AddToFilter(CollectionService:GetTagged(p1.filterTag))
	if p1.filterType == "Exclude" then
		v1:AddToFilter({ workspace.Terrain, p2, if p3 then p3:FindFirstAncestorOfClass("Part") else p3 })
	end
	return v1
end
function t.calculateEmissionCFrame(p1, p2, p3, p4, p5, p6, p7) --[[ calculateEmissionCFrame | Line: 164 | Upvalues: v4 (copy) ]]
	local v1 = if p7 then p1 * CFrame.new(Vector3.new(0, 0, 0), Vector3.FromNormalId(p3.emissionDirection)).Rotation elseif p4 then p4(nil, p1, p2, p3.emissionDirection, p3.partial) else p1
	local v3 = Vector3.FromNormalId(p3.emissionDirection)
	local v42 = v3:Cross(p1.LookVector)
	if v42.Magnitude < 0.001 then
		v42 = v3:Cross(p1.UpVector)
	end
	local v7 = CFrame.fromAxisAngle(v3, (math.rad((p5:NextNumber(-p3.spreadAngle.X, p3.spreadAngle.X)))))
	local v9 = v1 * (v7 * CFrame.fromAxisAngle(v42, (math.rad((p5:NextNumber(-p3.spreadAngle.Y, p3.spreadAngle.Y))))))
	if p3.face == "Inward" or p3.face == "InAndOut" and p5:NextInteger(0, 1) == 1 then
		v9 = v9 * CFrame.fromOrientation(0, math.pi, 0)
	end
	if p6 and (p3.mirror and (v9.Position - p6.WorldPosition).Unit:Dot(v9.RightVector) >= 0) then
		local v10 = p3.mirrorRot * v4.DEG_TO_RAD
		v9 = v9 * CFrame.fromOrientation(v10.X, v10.Y, v10.Z)
	end
	return v9
end
function t.createBezierWithEndpoint(p1, p2, p3, p4) --[[ createBezierWithEndpoint | Line: 207 | Upvalues: v6 (copy) ]]
	if not p3 then
		return v6.new(p1)
	end
	local t = {}
	for v1, v2 in p1 do
		table.insert(t, if v1 == #p1 - 1 then p4 and p4.WorldPosition or p3.WorldPosition elseif v1 == #p1 then p3.WorldPosition else p2 * (v2 - p1[1]))
	end
	return v6.new(t)
end
function t.createPosGetter(p1, p2, p3, p4, p5) --[[ createPosGetter | Line: 226 ]]
	return function(p12) --[[ Line: 233 | Upvalues: p5 (copy), p1 (copy), p4 (copy), p3 (copy), p2 (copy) ]]
		local v1 = if p5 == false then p1:getPosition(p12) else p1:getPositionArcSpace(p12)
		if p4 then
			return v1
		else
			return p3 * (v1 - p2[1])
		end
	end
end
function t.readCommonAttributes(p1) --[[ readCommonAttributes | Line: 244 | Upvalues: v1 (copy) ]]
	return {
		emitDelay = v1.get(p1, "EmitDelay", 0),
		emitCount = v1.get(p1, "EmitCount", 1),
		emitDuration = v1.get(p1, "EmitDuration", 0),
		destroyDelay = v1.get(p1, "DestroyDelay", 0),
		duration = v1.getRange(p1, "Duration", NumberRange.new(1, 1), NumberRange.new(0, (1 / 0))),
		shapeType = v1.getEnum(p1, "Shape", "Box", { "Box", "Cylinder", "Sphere", "Disc" }),
		shapeStyle = v1.getEnum(p1, "ShapeStyle", "Volume", { "Volume", "Surface" }),
		emissionDirection = Enum.NormalId[v1.getEnum(p1, "EmissionDirection", "Top", { "Top", "Bottom", "Left", "Right", "Front", "Back" })],
		face = v1.getEnum(p1, "ShapeFace", "Outward", { "InAndOut", "Inward", "Outward" }),
		spreadAngle = v1.get(p1, "SpreadAngle", Vector3.new(0, 0, 0)),
		partial = v1.get(p1, "ShapePartial", 1),
		syncPosition = v1.get(p1, "SyncPosition", false),
		mirror = v1.get(p1, "MirrorPaths", true),
		mirrorRot = v1.get(p1, "MirrorRotation", Vector3.new(0, 0, 180)),
		projectileEnabled = v1.get(p1, "ProjectileEnabled", false),
		projectileMatchEnd = v1.get(p1, "MatchEndDirection", false),
		projectileSpeed = v1.get(p1, "ProjectileSpeed", 30),
		projectileLifetime = v1.getRange(p1, "ProjectileLifetime", NumberRange.new(1, 1), NumberRange.new(0, (1 / 0))),
		hitboxEnabled = v1.get(p1, "HitboxEnabled", false),
		hitboxCollisionGroup = v1.get(p1, "HitboxCollisionGroup", "Default"),
		hitboxFilterTag = v1.get(p1, "HitboxFilterTag", ""),
		hitboxFilterType = v1.get(p1, "HitboxFilterType", "Exclude"),
		hitboxIgnoreCanCollide = v1.get(p1, "HitboxIgnoreCanCollide", false),
		speedStart = v1.get(p1, "Speed_Start", 1),
		speedEnd = v1.get(p1, "Speed_End", 1)
	}
end
function t.getCurrentOriginCFrame(p1, p2) --[[ getCurrentOriginCFrame | Line: 290 ]]
	if p1:IsA("BasePart") then
		return p1.CFrame
	end
	if p1:IsA("Attachment") then
		return p1.WorldCFrame
	else
		return p2
	end
end
function t.findEndAttachments(p1) --[[ findEndAttachments | Line: 300 ]]
	local End = p1:FindFirstChild("End")
	local v1 = if End then End:FindFirstChild("T1") else End
	if End and not End:IsA("Attachment") then
		End = nil
	end
	if v1 and not v1:IsA("Attachment") then
		v1 = nil
	end
	return End, v1
end
function t.validateParent(p1) --[[ validateParent | Line: 315 ]]
	local v1 = p1.Parent
	if not v1 then
		return nil
	end
	if not (v1:IsA("BasePart") or v1:IsA("Attachment")) then
		v1 = p1
	end
	return v1
end
function t.getPerpendicularVectors(p1) --[[ getPerpendicularVectors | Line: 329 ]]
	local v1 = p1:Cross(Vector3.new(0, 1, 0))
	if v1.Magnitude < 0.001 then
		v1 = p1:Cross(Vector3.new(0, 0, 1))
	end
	local Unit = v1.Unit
	return Unit, p1:Cross(Unit).Unit
end
function t.createPropertyTween(p1, p2, p3, p4, p5, p6, p7, p8, p9) --[[ createPropertyTween | Line: 343 | Upvalues: v3 (copy), v1 (copy), v4 (copy) ]]
	if p5 ~= p6 then
		local v12 = v1.get(p2, p3 .. "_Curve", v4.default_bezier)
		local function f2(p1, p2) --[[ Line: 363 | Upvalues: p7 (copy), v4 (ref), p5 (copy), p6 (copy), p8 (copy) ]]
			p7(v4.lerp(p5, p6, p1))
			return p2 * p8()
		end
		table.insert(p1, v3.fromParams(v12, p4, f2, p9))
	end
end
return t