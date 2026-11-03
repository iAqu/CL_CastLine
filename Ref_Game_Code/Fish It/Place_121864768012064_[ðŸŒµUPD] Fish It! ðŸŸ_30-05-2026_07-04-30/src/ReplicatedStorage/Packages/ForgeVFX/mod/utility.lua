-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")
local v1 = require("./attributes")
local v2 = require("./logger")
local v3 = require("../pkg/Promise")
local t = {}
t.PLUGIN_CONTEXT = script:FindFirstAncestorOfClass("Plugin") or RunService:IsStudio() and not RunService:IsRunning()
t.SERVER_CONTEXT = RunService:IsServer() or t.PLUGIN_CONTEXT
t.DEG_TO_RAD = math.rad(1)
t.BEZIER_TAG = "BezierParticle"
t.LIGHTNING_TAG = "LightningBolt"
t.SHOCKWAVE_TAG = "Shockwave"
t.SCREENSHAKE_TAG = "CameraShake"
t.PROPERTY_TWEENER_TAG = "PropertyTweener"
t.PROPERTY_RANDOMIZER_TAG = "PropertyRandomizer"
t.ATTRIBUTE_TWEENER_TAG = "AttributeTweener"
t.ATTRIBUTE_RANDOMIZER_TAG = "AttributeRandomizer"
t.ENABLED_VFX_TAG = "ConstantVFX"
t.TEXTURE_LOAD_TAG = "LoadVFXTextures"
t.CLEANUP_TAG = "__forge__cleanupOnExit"
t.EMIT_EXCLUDE_TAG = "__forge_excludeFromEmit"
t.RENDER_PRIORITY = Enum.RenderPriority.Camera.Value + 1
t.COLLISION_GROUPS = {
	StudioSelectable = {},
	ForgeDebris = {
		ForgeDebris = false
	},
	ForgeMouseIgnore = {
		StudioSelectable = false
	}
}
t.COPY_SPECIALMESH_PROPERTIES = { "MeshId", "MeshType", "Offset", "Scale", "TextureId", "VertexColor" }
t.COPY_PART_PROPERTIES = {
	"CastShadow",
	"Color",
	"Material",
	"MaterialVariant",
	"Reflectance",
	"Shape",
	"FrontSurface",
	"BackSurface",
	"LeftSurface",
	"RightSurface",
	"TopSurface",
	"BottomSurface"
}
t.COPY_EXTENDED_PART_PROPERTIES = { "Size", "Transparency", "CustomPhysicalProperties", "CanCollide", "CanQuery", "CanTouch", "CollisionGroup" }
local v6 = setmetatable({}, {
	__mode = "k"
})
function t.lock(p1) --[[ lock | Line: 94 | Upvalues: v6 (copy) ]]
	if v6[p1] then
		return true
	else
		v6[p1] = coroutine.running()
		return false
	end
end
function t.unlock(p1, p2) --[[ unlock | Line: 104 | Upvalues: v6 (copy), v2 (copy) ]]
	local v1 = v6[p1]
	if coroutine.running() ~= v1 and p2 ~= v1 then
		v2.error("attempt to unlock an instance owned by a different thread")
	end
	v6[p1] = nil
end
function t.setCollisionGroups(p1) --[[ setCollisionGroups | Line: 114 | Upvalues: PhysicsService (copy), RunService (copy) ]]
	local t = {}
	for v1, v2 in p1 do
		PhysicsService:RegisterCollisionGroup(v1)
		if not v1:match("Studio") or RunService:IsStudio() then
			t[v1] = v2
		end
	end
	for v3, v4 in t do
		for v5, v6 in v4 do
			if not v5:match("Studio") or RunService:IsStudio() then
				PhysicsService:CollisionGroupSetCollidable(v3, v5, v6)
			end
		end
	end
end
local v7 = 0
function t.getRandomId() --[[ getRandomId | Line: 138 | Upvalues: v7 (ref) ]]
	v7 = v7 + 1
	return tostring(v7)
end
function t.copyProperties(p1, p2, p3) --[[ copyProperties | Line: 143 ]]
	for v1, v2 in p3 do
		p2[v2] = p1[v2]
	end
end
function t.lerp(p1, p2, p3) --[[ lerp | Line: 149 ]]
	return p1 + (p2 - p1) * p3
end
function t.try(p1, p2, ...) --[[ try | Line: 153 | Upvalues: v2 (copy) ]]
	local t = { xpcall(p2, function(p12) --[[ Line: 154 | Upvalues: v2 (ref), p1 (copy) ]]
			v2.warn(string.format(p1, p12))
		end, ...) }
	return t[1], table.unpack(t, 2)
end
function t.reboundfn(p1, p2) --[[ reboundfn | Line: 161 ]]
	local v1 = nil
	return function(...) --[[ Line: 164 | Upvalues: v1 (ref), p1 (copy), p2 (copy) ]]
		local v12
		if not v1 then
			v12 = { ... }
			v1 = task.delay(p1, function() --[[ Line: 171 | Upvalues: v1 (ref), p2 (ref), v12 (copy) ]]
				v1 = nil
				p2(table.unpack(v12))
			end)
			return
		end
		task.cancel(v1)
		v12 = { ... }
		v1 = task.delay(p1, function() --[[ Line: 171 | Upvalues: v1 (ref), p2 (ref), v12 (copy) ]]
			v1 = nil
			p2(table.unpack(v12))
		end)
	end
end
function t.randomUnitVector(p1, p2, p3) --[[ randomUnitVector | Line: 178 ]]
	local v1 = if p3 then p3 else Random.new()
	return Vector3.new(v1:NextNumber(p1.X, p2.X), v1:NextNumber(p1.Y, p2.Y), v1:NextNumber(p1.Z, p2.Z))
end
function t.getImpulseForce(p1, p2, p3) --[[ getImpulseForce | Line: 183 ]]
	return (p2 - p1) / p3 + Vector3.new(0, workspace.Gravity * p3 * 0.5, 0)
end
function t.isMeshVFX(p1) --[[ isMeshVFX | Line: 187 ]]
	return if p1 then p1:IsA("Model") and (p1:FindFirstChild("Start") and (p1.Start:IsA("BasePart") and (p1:FindFirstChild("End") and p1.End:IsA("BasePart")))) else p1
end
function t.isSpinModelStatic(p1) --[[ isSpinModelStatic | Line: 196 | Upvalues: v1 (copy) ]]
	return if v1.get(p1, "SpinRotation", Vector3.new(0, 0, 0), true) == Vector3.new(0, 0, 0) and (v1.get(p1, "Scale_Start", 1, true) == 1 and v1.get(p1, "Scale_End", 1, true) == 1) then v1.get(p1, "SyncPosition", false, true) == false else false
end
function t.shouldSkipNested(p1) --[[ shouldSkipNested | Line: 203 | Upvalues: t (copy) ]]
	return p1:IsA("Beam") or (p1:HasTag(t.BEZIER_TAG) or (p1:HasTag(t.LIGHTNING_TAG) or (t.isMeshVFX(p1) or p1:IsA("BasePart") and t.findFirstClassWithTag(p1, "Attachment", t.SHOCKWAVE_TAG) ~= nil)))
end
function t.getTarget(p1) --[[ getTarget | Line: 211 ]]
	local ObjectValue = p1:FindFirstChildOfClass("ObjectValue")
	if ObjectValue and ObjectValue.Value then
		return ObjectValue.Value
	end
	local v1 = p1.Parent
	if not v1 then
		return nil
	end
	repeat
		if not v1:IsA("Folder") then
			return v1
		end
		v1 = v1.Parent
	until not v1
	return nil
end
function t.createEmitPromise(p1, p2, p3, p4, p5) --[[ createEmitPromise | Line: 235 | Upvalues: v3 (copy), t (copy) ]]
	local v1 = v3.new(function(p12, p2, p32) --[[ Line: 242 | Upvalues: p3 (copy), p1 (copy), p5 (copy), t (ref), p4 (copy) ]]
		local t2 = {
			depth = p3,
			effects = p1,
			_context = p5
		}
		p32(function() --[[ Line: 248 | Upvalues: t2 (copy), t (ref) ]]
			if t2._onCancel then
				for v1, v2 in t2._onCancel do
					v2()
				end
			end
			t.cleanupScope(t2)
		end)
		p4(t2)
		t.cleanupScope(t2)
		p12()
	end)
	if p5 then
		table.insert(p5._promises, v1)
	end
	return v1
end
function t.onCancel(p1, p2) --[[ onCancel | Line: 272 ]]
	if not p1._onCancel then
		p1._onCancel = {}
	end
	table.insert(p1._onCancel, p2)
end
local v8 = setmetatable({}, {
	__mode = "k"
})
local v9 = setmetatable({}, {
	__mode = "k"
})
function t.forceEmit(p1, p2) --[[ forceEmit | Line: 287 | Upvalues: v9 (copy) ]]
	v9[p1] = if p2 then true else nil
end
function t.isForceEmitting(p1) --[[ isForceEmitting | Line: 291 | Upvalues: v9 (copy) ]]
	return v9[p1] == true
end
function t.setEnabledCancelToken(p1, p2) --[[ setEnabledCancelToken | Line: 295 | Upvalues: v8 (copy) ]]
	v8[p1] = p2
end
function t.getEnabledCancelToken(p1) --[[ getEnabledCancelToken | Line: 299 | Upvalues: v8 (copy) ]]
	return v8[p1]
end
function t.cancelToken(p1) --[[ cancelToken | Line: 303 | Upvalues: t (copy) ]]
	for v1, v2 in p1._promises do
		v2:cancel()
	end
	for v3, v4 in p1._scopes do
		t.cleanupScope(v4, true)
	end
	table.clear(p1._promises)
	table.clear(p1._scopes)
end
function t.stopEmitDuration(p1) --[[ stopEmitDuration | Line: 316 | Upvalues: t (copy), v1 (copy) ]]
	local v12 = t.getEnabledCancelToken(p1)
	v1.trigger(p1, "Enabled", false)
	v1.clearState(p1)
	t.forceEmit(p1, false)
	return v12
end
function t.awaitEmitDuration(p1) --[[ awaitEmitDuration | Line: 326 | Upvalues: v3 (copy) ]]
	if not p1 then
		return
	end
	local t = {}
	for v1, v2 in p1._promises do
		table.insert(t, v2)
	end
	if not (#t > 0) then
		return
	end
	v3.all(t):await()
end
function t.cleanupScope(p1, p2) --[[ cleanupScope | Line: 342 | Upvalues: t (copy) ]]
	local effects = p1.effects
	local _context = p1._context
	local _onCancel = p1._onCancel
	for v1, v2 in p1 do
		if v1 ~= "depth" and (v1 ~= "effects" and (v1 ~= "_context" and v1 ~= "_onCancel")) then
			local v3 = typeof(v2)
			if v3 == "Instance" then
				v2:Destroy()
				continue
			end
			if v3 == "RBXScriptConnection" then
				v2:Disconnect()
				continue
			end
			if v3 == "thread" then
				if coroutine.status(v2) ~= "dead" then
					task.cancel(v2)
				end
				continue
			end
			if v3 == "function" then
				if p2 then
					v2()
					continue
				end
				task.spawn(v2)
				continue
			end
			if v3 == "table" then
				t.cleanupScope(v2)
			end
		end
	end
	table.clear(p1)
	p1.depth = p1.depth
	p1.effects = effects
	p1._context = _context
	p1._onCancel = _onCancel
end
function t.protectParent(p1, p2) --[[ protectParent | Line: 385 ]]
	table.insert(p1, p2.AncestryChanged:Connect(function(p1, p22) --[[ Line: 388 | Upvalues: p2 (copy) ]]
		if p2.Parent ~= workspace.Terrain then
			p2.Parent = workspace.Terrain
		end
	end))
end
function t.findFirstClassWithTag(p1, p2, p3) --[[ findFirstClassWithTag | Line: 398 | Upvalues: t (copy) ]]
	if not p1 or p1.Parent == game then
		return
	end
	if p1.ClassName == p2 and p1:HasTag(p3) then
		return p1
	end
	return t.findFirstClassWithTag(p1.Parent, p2, p3)
end
function t.cloneParticleAncestry(p1, p2) --[[ cloneParticleAncestry | Line: 410 ]]
	if not (p1:FindFirstAncestorWhichIsA("BasePart") or p1:FindFirstAncestorOfClass("Attachment")) then
		return
	end
	local function v1(p1) --[[ findAncestor | Line: 418 | Upvalues: v1 (copy) ]]
		if not p1 then
			return
		end
		return if p1.Parent and (p1.Parent:IsA("BasePart") or p1.Parent:IsA("Attachment")) then v1(p1.Parent) else p1
	end
	local function v2(p12) --[[ recurse | Line: 432 | Upvalues: p2 (copy), p1 (copy), v1 (copy), v2 (copy) ]]
		if not p12 then
			return
		end
		local v12 = p2[p12]
		if v12 then
			if p12 == p1 then
				return v12, p2[p12.Parent]
			end
			local v3 = p12.Parent
			local v4, v5
			if v3 then
				local v6
				if v3.Parent and (v3.Parent:IsA("BasePart") or v3.Parent:IsA("Attachment")) then
					v6, v4 = v1(v3.Parent), v12
				else
					v6 = v3
					v4 = v12
				end
				v5 = v6
			else
				v5 = nil
				v4 = v12
			end
			return v4, p2[v5] or p2[p12]
		else
			local v9 = Instance.fromExisting(p12)
			v9.Archivable = false
			if v9:IsA("BasePart") then
				v9.Locked = true
			end
			if p2 then
				p2[p12] = v9
			end
			local v10
			if p12.Parent and (p12.Parent:IsA("BasePart") or p12.Parent:IsA("Attachment")) then
				local v11, v122 = v2(p12.Parent)
				v10 = if v122 then v122 else v9
				if v11 then
					v9.Parent = v11
				end
			else
				v10 = v9
			end
			return v9, v10
		end
	end
	return v2(p1.Parent)
end
function t.getTransformedOriginExtents(p1) --[[ getTransformedOriginExtents | Line: 474 | Upvalues: v1 (copy), t (copy) ]]
	local identity = CFrame.identity
	if p1:IsA("BasePart") then
		return p1.CFrame, p1.Size
	end
	if p1:IsA("Attachment") then
		identity = p1.WorldCFrame
		local v2 = p1.Parent
		local v3 = v1.get(p1, "PositionScale", Vector3.new(0, 0, 0), true)
		if v2 and (v2:IsA("BasePart") and v3 ~= Vector3.new(0, 0, 0)) then
			identity = identity + v2.Size / 2 * v3
		end
		local v4 = v1.get(p1, "OverrideWorldRotation", false, true)
		local v5 = v1.get(p1, "WorldRotation", Vector3.new(0, 0, 0), true)
		if v4 then
			local v6 = v5 * t.DEG_TO_RAD
			identity = CFrame.new(identity.Position) * CFrame.fromOrientation(v6.X, v6.Y, v6.Z)
		end
	end
	return identity, Vector3.new(0, 0, 0)
end
function t.getMeshDecals(p1, p2) --[[ getMeshDecals | Line: 510 | Upvalues: v1 (copy), t (copy) ]]
	local v12 = v1.get(p1, "Flipbook", false, true)
	local t2 = {}
	local t3 = {}
	local t4 = {}
	local function filter(p1) --[[ filter | Line: 517 ]]
		local t = {}
		for v1, v2 in p1 do
			if v2:IsA("Decal") then
				table.insert(t, v2)
			end
		end
		return t
	end
	if v12 then
		return filter(p2:GetChildren()), t3, t4
	end
	local End = p1:FindFirstChild("End")
	local Start = p1:FindFirstChild("Start")
	if End then
		for v2, v3 in p2:GetChildren() do
			if v3:IsA("Decal") then
				local v4 = End:FindFirstChild(v3.Name)
				if v4 and v4:IsA("Decal") then
					table.insert(t2, v3)
					t4[v3] = v4
					if v1.get(v3, "FlipbookEnabled", nil) then
						local v5 = v1.get(v3, "FlipbookTextures", nil)
						if v5 then
							t3[v3] = t.deserializeFlipbook(v5)
						end
						continue
					end
					table.insert(t2, v3)
				end
			end
		end
		for v6, v7 in Start:GetChildren() do
			if v7:IsA("Decal") then
				local v8 = v7:GetChildren()
				local count = 0
				for i = 1, #v8 do
					local v9 = i - count
					if not v8[v9]:IsA("Decal") then
						table.remove(v8, v9)
						count = count + 1
					end
				end
				if #v8 ~= 0 then
					local function idx(p1) --[[ idx | Line: 588 ]]
						return tonumber(p1:match("%d+")) or 0
					end
					table.sort(v8, function(p1, p2) --[[ Line: 592 ]]
						local v2 = tonumber(p1.Name:match("%d+")) or 0
						return v2 < (tonumber(p2.Name:match("%d+")) or 0)
					end)
					local t5 = {}
					for v10, v11 in v8 do
						table.insert(t5, tonumber(v11.Texture:match("%d+")) or 0)
						v11:Destroy()
					end
					local v13 = t.serializeFlipbook(t5)
					v1.set(v7, "FlipbookEnabled", true)
					v1.set(v7, "FlipbookTextures", buffer.tostring(v13))
				end
			end
		end
	end
	return t2, t3, t4
end
function t.assembleMeshVFX(p1, p2, p3) --[[ assembleMeshVFX | Line: 615 | Upvalues: t (copy) ]]
	local v1 = t.getRandomId()
	if not p1:IsA("Part") then
		local v2 = p1:Clone()
		v2.Archivable = false
		v2.Locked = true
		v2.Parent = workspace.Terrain
		v2:AddTag(t.CLEANUP_TAG)
		table.insert(p2, v2)
		return v2
	end
	local v3 = p3:get(v1)
	v3.CFrame = p1.CFrame
	local v4 = v3._getReal()
	t.copyProperties(p1, v4, t.COPY_PART_PROPERTIES)
	t.copyProperties(p1, v4, t.COPY_EXTENDED_PART_PROPERTIES)
	local v5 = p1:Clone()
	for v6, v7 in v5:GetChildren() do
		v7.Parent = v4
	end
	v5:Destroy()
	table.insert(p2, function() --[[ Line: 635 | Upvalues: p3 (copy), v1 (copy) ]]
		p3:free(v1)
	end)
	return v3
end
function t.getBezierPoints(p1, p2) --[[ getBezierPoints | Line: 654 ]]
	local v1 = p1:GetChildren()
	table.sort(v1, function(p1, p2) --[[ Line: 657 ]]
		local v2 = tonumber(p1.Name)
		return v2 < tonumber(p2.Name)
	end)
	local t = {}
	local t2 = {}
	local t3 = {}
	local function vec(p12) --[[ vec | Line: 665 | Upvalues: p1 (copy), t (copy), p2 (copy), t3 (copy), t2 (copy) ]]
		local v1 = p1.WorldCFrame:PointToObjectSpace(p12.WorldPosition)
		local v2 = vector.create(v1.X, v1.Y, v1.Z)
		table.insert(t, v2)
		if p2 then
			t3[p12] = v2
			table.insert(t2, p12)
		end
		return v2
	end
	for v2, v3 in v1 do
		local T0 = v3:FindFirstChild("T0")
		local T1 = v3:FindFirstChild("T1")
		if v2 == 1 then
			local v4 = p1.WorldCFrame:PointToObjectSpace(v3.WorldPosition)
			local v5 = vector.create(v4.X, v4.Y, v4.Z)
			table.insert(t, v5)
			if p2 then
				t3[v3] = v5
				table.insert(t2, v3)
			end
		end
		if v2 ~= 1 and T1 then
			local v6 = p1.WorldCFrame:PointToObjectSpace(T1.WorldPosition)
			local v7 = vector.create(v6.X, v6.Y, v6.Z)
			table.insert(t, v7)
			if p2 then
				t3[T1] = v7
				table.insert(t2, T1)
			end
		elseif v2 ~= 1 then
			local v8 = p1.WorldCFrame:PointToObjectSpace(v3.WorldPosition)
			local v9 = vector.create(v8.X, v8.Y, v8.Z)
			table.insert(t, v9)
			if p2 then
				t3[v3] = v9
				table.insert(t2, v3)
			end
		end
		if v2 ~= 1 and v2 ~= #v1 then
			local v10 = p1.WorldCFrame:PointToObjectSpace(v3.WorldPosition)
			local v11 = vector.create(v10.X, v10.Y, v10.Z)
			table.insert(t, v11)
			if p2 then
				t3[v3] = v11
				table.insert(t2, v3)
			end
		end
		if v2 ~= #v1 and T0 then
			local v12 = p1.WorldCFrame:PointToObjectSpace(T0.WorldPosition)
			local v13 = vector.create(v12.X, v12.Y, v12.Z)
			table.insert(t, v13)
			if p2 then
				t3[T0] = v13
				table.insert(t2, T0)
			end
		elseif v2 ~= #v1 then
			local v14 = p1.WorldCFrame:PointToObjectSpace(v3.WorldPosition)
			local v15 = vector.create(v14.X, v14.Y, v14.Z)
			table.insert(t, v15)
			if p2 then
				t3[v3] = v15
				table.insert(t2, v3)
			end
		end
		if v2 == #v1 then
			local v16 = p1.WorldCFrame:PointToObjectSpace(v3.WorldPosition)
			local v17 = vector.create(v16.X, v16.Y, v16.Z)
			table.insert(t, v17)
			if p2 then
				t3[v3] = v17
				table.insert(t2, v3)
			end
		end
	end
	return t, t2, t3
end
function t.scaleNumberSequence(p1, p2) --[[ scaleNumberSequence | Line: 717 ]]
	if p2 == 1 then
		return p1
	end
	local t = {}
	for v3, v4 in p1.Keypoints do
		local v1, v2
		if typeof(p2) == "function" then
			local v5, v6 = p2(v4.Value, v4.Envelope)
			v1 = v5
			v2 = v6
		else
			v1 = v4.Value * p2
			v2 = v4.Envelope * p2
		end
		local v7 = NumberSequenceKeypoint.new
		table.insert(t, v7(v4.Time, v1, v2))
	end
	return NumberSequence.new(t)
end
function t.serializePath(p1) --[[ serializePath | Line: 742 ]]
	local v1 = buffer.create(#p1 * 4 * 6)
	local sum = 0
	for v2, v3 in p1 do
		local Scale = v3.Position.X.Scale
		local Scale_2 = v3.Position.Y.Scale
		if v2 ~= 1 then
			buffer.writef32(v1, sum, Scale + v3.LeftTangent.X.Scale)
			buffer.writef32(v1, sum + 4, Scale_2 + v3.LeftTangent.Y.Scale)
			sum = sum + 8
		end
		buffer.writef32(v1, sum, Scale)
		buffer.writef32(v1, sum + 4, Scale_2)
		sum = sum + 8
		if v2 ~= #p1 then
			buffer.writef32(v1, sum, Scale + v3.RightTangent.X.Scale)
			buffer.writef32(v1, sum + 4, Scale_2 + v3.RightTangent.Y.Scale)
			sum = sum + 8
		end
	end
	return v1
end
function t.deserializePath(p1) --[[ deserializePath | Line: 774 ]]
	local v1 = typeof(p1) == "string" and buffer.fromstring(p1) or p1
	local v2 = buffer.len(v1) / 24
	local t = {}
	for i = 0, v2 - 1 do
		local v3 = i * 4 * 6
		table.insert(t, (vector.create(buffer.readf32(v1, v3), (buffer.readf32(v1, v3 + 4)))))
		if i ~= v2 - 1 then
			local v7 = buffer.readf32(v1, v3 + 8)
			local v8 = buffer.readf32(v1, v3 + 12)
			local v9 = buffer.readf32(v1, v3 + 16)
			local v10 = buffer.readf32(v1, v3 + 20)
			table.insert(t, (vector.create(v7, v8)))
			table.insert(t, (vector.create(v9, v10)))
		end
	end
	return t
end
local v10 = require("./common/flipbook")
t.serializeFlipbook = v10.serialize
t.deserializeFlipbook = v10.deserialize
t.default_bezier = buffer.tostring(t.serializePath({ Path2DControlPoint.new(UDim2.fromScale(0, 1), UDim2.new(), UDim2.fromScale(0.215, -0.61)), Path2DControlPoint.new(UDim2.fromScale(1, 0), UDim2.fromScale(-0.645, 0), UDim2.new()) }))
t.linear_bezier = buffer.tostring(t.serializePath({ Path2DControlPoint.new(UDim2.fromScale(0, 1)), Path2DControlPoint.new(UDim2.fromScale(1, 0)) }))
function t.scaleAttribute(p1, p2, p3) --[[ scaleAttribute | Line: 820 | Upvalues: v1 (copy) ]]
	local v12 = v1.get(p1, p3, nil)
	if v12 == nil then
		return
	end
	if typeof(v12) == "number" then
		v1.set(p1, p3, v12 * p2)
		return
	end
	if typeof(v12) == "Vector3" then
		v1.set(p1, p3, v12 * p2)
		return
	end
	if typeof(v12) ~= "NumberRange" then
		return
	end
	v1.set(p1, p3, NumberRange.new(v12.Min * p2, v12.Max * p2))
end
function t.scaleAttachmentDistance(p1, p2, p3) --[[ scaleAttachmentDistance | Line: 834 ]]
	if p1 and p2 then
		local v1 = (p1.Position + p2.Position) / 2
		p1.Position = v1 + (p1.Position - v1) * p3
		p2.Position = v1 + (p2.Position - v1) * p3
	end
end
return t