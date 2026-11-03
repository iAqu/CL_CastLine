-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("./effects/beam")
local v2 = require("./effects/spin")
local v3 = require("./effects/mesh")
local v4 = require("./effects/sound")
local v5 = require("./effects/bezier")
local v6 = require("./effects/screen")
local v7 = require("./effects/particle")
local v8 = require("./effects/lightning")
local v9 = require("./effects/camera_shake")
local v10 = require("./effects/tweener")
local v11 = require("./effects/randomizer")
local v12 = require("./effects/shockwave_ring")
local v13 = require("./effects/shockwave_line")
local v14 = require("./effects/shockwave_debris")
local v15 = require("./mod/attributes")
require("./types")
local v16 = require("./mod/utility")
local v17 = require("./pkg/Promise")
local t = {}
local function processRandomizers(p1, p2) --[[ processRandomizers | Line: 24 | Upvalues: v16 (copy), v11 (copy) ]]
	local v1 = p1:QueryDescendants((("> RayValue.%*"):format(v16.PROPERTY_RANDOMIZER_TAG)))
	local v2 = p1:QueryDescendants((("> RayValue.%*"):format(v16.ATTRIBUTE_RANDOMIZER_TAG)))
	if p1:IsA("RayValue") then
		if p1:HasTag(v16.PROPERTY_RANDOMIZER_TAG) then
			table.insert(v1, p1)
		elseif p1:HasTag(v16.ATTRIBUTE_RANDOMIZER_TAG) then
			table.insert(v2, p1)
		end
	end
	for v3, v4 in v1 do
		v16.try("failed to emit property randomizer with error: %s", v11.emit, v4, p2, false)
	end
	for v5, v6 in v2 do
		v16.try("failed to emit attribute randomizer with error: %s", v11.emit, v6, p2, true)
	end
end
function t.particle(p1, p2, p3, p4, p5) --[[ particle | Line: 46 | Upvalues: v15 (copy), v16 (copy), v7 (copy) ]]
	local v3 = v15.get(p1, "EmitCount", if v16.PLUGIN_CONTEXT then 1 else nil)
	if not v3 or v3 <= 0 and v15.get(p1, "EmitDuration", 0, true) <= 0 then
		return
	end
	if p1:IsDescendantOf(workspace) then
		v16.try("failed to emit particle with error: %s", v7.emit, p1, p1, p2, p5)
		return
	end
	local v4, v5 = v16.cloneParticleAncestry(p1, p4)
	if not v4 then
		return
	end
	local v6 = p1:Clone()
	v6.Archivable = false
	v6.Parent = v4
	if p3[v5] then
		p3[v5] = p3[v5] + 1
	else
		v5.Parent = workspace.Terrain
		p3[v5] = 1
	end
	table.insert(p2, function() --[[ Line: 78 | Upvalues: p3 (copy), v5 (copy) ]]
		local v1 = p3
		local v2 = v5
		v1[v2] = v1[v2] - 1
		if not (p3[v5] <= 0) then
			return
		end
		v5:Destroy()
	end)
	v16.try("failed to emit particle with error: %s", v7.emit, p1, v6, p2, p5)
end
function t.beam(p1, p2, p3) --[[ beam | Line: 92 | Upvalues: v15 (copy), v16 (copy), v1 (copy) ]]
	local Attachment0 = p1.Attachment0
	local Attachment1 = p1.Attachment1
	if not (Attachment0 and Attachment1) then
		return
	end
	local v12 = p1:Clone()
	v12.Archivable = false
	v12.Parent = workspace.Terrain
	local v2 = NumberRange.new(1, 1)
	if v15.get(p1, "Length_Scale_Start", v2, true) ~= v2 or v15.get(p1, "Length_Scale_End", v2, true) ~= v2 then
		local _ForgeTempAttachment = Attachment0:Clone()
		local _ForgeTempAttachment_2 = Attachment1:Clone()
		table.insert(p2, _ForgeTempAttachment)
		table.insert(p2, _ForgeTempAttachment_2)
		_ForgeTempAttachment.Name = "_ForgeTempAttachment"
		_ForgeTempAttachment_2.Name = "_ForgeTempAttachment"
		_ForgeTempAttachment:AddTag(v16.EMIT_EXCLUDE_TAG)
		_ForgeTempAttachment_2:AddTag(v16.EMIT_EXCLUDE_TAG)
		v12.Attachment0 = _ForgeTempAttachment
		v12.Attachment1 = _ForgeTempAttachment_2
		_ForgeTempAttachment.Parent = Attachment0.Parent
		_ForgeTempAttachment_2.Parent = Attachment1.Parent
	end
	table.insert(p2, v12)
	v16.try("failed to emit beam with error: %s", v1.emit, p1, v12, p2, p3)
end
function t.trail(p1) --[[ trail | Line: 133 ]]
	p1.Enabled = true
end
function t.bezier(p1, p2, p3) --[[ bezier | Line: 137 | Upvalues: v16 (copy), v5 (copy) ]]
	local Part = p1:FindFirstChildOfClass("Part")
	if not Part then
		return
	end
	if not p3 and p1:GetAttribute("Enabled") then
		p1:SetAttribute("Enabled", false)
	end
	local v1 = Part:Clone()
	v1.Locked = true
	table.insert(p2, v1)
	v16.try("failed to emit bezier with error: %s", v5.emit, p1, v1, p2, p3)
end
function t.lightning(p1, p2, p3) --[[ lightning | Line: 156 | Upvalues: v16 (copy), v8 (copy) ]]
	local Part = p1:FindFirstChildOfClass("Part")
	if not Part then
		return
	end
	if not p3 and p1:GetAttribute("Enabled") then
		p1:SetAttribute("Enabled", false)
	end
	local v1 = Part:Clone()
	v1.Locked = true
	table.insert(p2, v1)
	v16.try("failed to emit lightning with error: %s", v8.emit, p1, v1, p2, p3)
end
function t.mesh(p1, p2, p3, p4, p5) --[[ mesh | Line: 175 | Upvalues: v16 (copy), v15 (copy), v17 (copy), v3 (copy) ]]
	local Start = p1:FindFirstChild("Start")
	if not Start then
		return
	end
	if not p5 and p1:GetAttribute("Enabled") then
		p1:SetAttribute("Enabled", false)
	end
	local t = {}
	local _context = p2._context
	local v1 = p1:HasTag(v16.ENABLED_VFX_TAG) and (if v15.get(p1, "EmitDuration", 0) > 0 then true else false)
	for i = 1, if v1 and not p5 then 1 else v15.get(p1, "EmitCount", 1) do
		local v32 = v17.new(function(p12) --[[ Line: 199 | Upvalues: v16 (ref), v3 (ref), p1 (copy), Start (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy) ]]
			v16.try("failed to emit mesh with error: %s", v3.emit, p1, v16.assembleMeshVFX(Start, p2, p3), p2, p4, p5)
			p12()
		end)
		table.insert(t, v32)
		if _context then
			table.insert(_context._promises, v32)
		end
	end
	v17.all(t):await()
end
function t.spin(p1, p2) --[[ spin | Line: 223 | Upvalues: v16 (copy), v2 (copy) ]]
	if not v16.lock(p1) then
		v16.try("failed to emit spinning model with error: %s", v2.emit, p1, p2)
		v16.unlock(p1)
	end
end
function t.camera_shake(p1, p2) --[[ camera_shake | Line: 232 | Upvalues: v16 (copy), v9 (copy) ]]
	v16.try("failed to emit camera shake with error: %s", v9.emit, p1, p2)
end
function t.property_tweener(p1, p2) --[[ property_tweener | Line: 236 | Upvalues: v16 (copy), v10 (copy) ]]
	if p1.Parent and not v16.lock(p1) then
		v16.try("failed to emit property tweener with error: %s", v10.emit, p1, p2, false)
		v16.unlock(p1)
	end
end
function t.attribute_tweener(p1, p2) --[[ attribute_tweener | Line: 245 | Upvalues: v16 (copy), v10 (copy) ]]
	if p1.Parent and not v16.lock(p1) then
		v16.try("failed to emit attribute tweener with error: %s", v10.emit, p1.Parent, p1, p2, true)
		v16.unlock(p1)
	end
end
function t.screen(p1, p2) --[[ screen | Line: 254 | Upvalues: v16 (copy), v6 (copy) ]]
	local v1, v2 = v16.try("failed to emit screen effect with error: %s", v6.emit, p1, p2)
	if v1 then
		return v2
	else
		return false
	end
end
function t.shockwave_ring(p1, p2, p3) --[[ shockwave_ring | Line: 260 | Upvalues: v16 (copy), v12 (copy) ]]
	v16.try("failed to emit shockwave ring with error: %s", v12.emit, p1, p2, p3)
end
function t.shockwave_debris(p1, p2, p3) --[[ shockwave_debris | Line: 264 | Upvalues: v16 (copy), v14 (copy) ]]
	v16.try("failed to emit shockwave debris with error: %s", v14.emit, p1, p2, p3)
end
function t.shockwave_line(p1, p2, p3) --[[ shockwave_line | Line: 268 | Upvalues: v16 (copy), v13 (copy) ]]
	v16.try("failed to emit shockwave line with error: %s", v13.emit, p1, p2, p3)
end
function t.sound(p1, p2) --[[ sound | Line: 272 | Upvalues: v15 (copy), v16 (copy), v4 (copy) ]]
	if not (v15.get(p1, "EmitCount", 1, true) <= 0) then
		v16.try("failed to emit sound with error: %s", v4.emit, p1, p2)
	end
end
function t.dispatch(p1, p2, p3, p4, p5, p6) --[[ dispatch | Line: 283 | Upvalues: processRandomizers (copy), t (copy), v16 (copy) ]]
	local ClassName = p1.ClassName
	processRandomizers(p1, p2)
	if ClassName == "ParticleEmitter" then
		t.particle(p1, p2, p3, p4, p6)
		return
	end
	if ClassName == "Beam" then
		t.beam(p1, p2, p6)
		return
	end
	if ClassName == "Trail" then
		t.trail(p1)
		return
	end
	if ClassName == "Sound" then
		t.sound(p1, p2)
		return
	end
	if ClassName == "RayValue" then
		if p1:HasTag(v16.SCREENSHAKE_TAG) then
			t.camera_shake(p1, p2)
			return
		end
		if p1:HasTag(v16.ATTRIBUTE_TWEENER_TAG) then
			t.attribute_tweener(p1, p2)
			return
		end
		if p1:HasTag(v16.PROPERTY_RANDOMIZER_TAG) then
			return
		end
		if p1:HasTag(v16.ATTRIBUTE_RANDOMIZER_TAG) then
			return
		end
		t.property_tweener(p1, p2)
	else
		if p1:HasTag(v16.BEZIER_TAG) then
			t.bezier(p1, p2)
			return
		end
		if p1:HasTag(v16.LIGHTNING_TAG) then
			t.lightning(p1, p2)
			return
		end
		if ClassName == "Model" then
			if v16.isMeshVFX(p1) then
				t.mesh(p1, p2, p5, p6)
			else
				t.spin(p1, p2)
			end
		else
			if ClassName ~= "Part" then
				return
			end
			local v1 = v16.findFirstClassWithTag(p1, "Attachment", v16.SHOCKWAVE_TAG)
			if not v1 then
				return
			end
			local v2 = p1.Parent and p1.Parent.Name or ""
			if v2 == "Rings" then
				t.shockwave_ring(v1, p1, p2)
				return
			end
			if v2 == "Debris" then
				t.shockwave_debris(v1, p1, p2)
				return
			end
			if v2 ~= "Lines" then
				return
			end
			t.shockwave_line(v1, p1, p2)
		end
	end
end
t.enabled_registry = {
	mesh = {
		check = function(p1) --[[ check | Line: 367 | Upvalues: v16 (copy) ]]
			return v16.isMeshVFX(p1)
		end,
		emit = function(p1, p2, p3) --[[ emit | Line: 370 | Upvalues: t (copy) ]]
			t.mesh(p1, p2, p3, 1, true)
		end
	},
	bezier = {
		check = function(p1) --[[ check | Line: 376 | Upvalues: v16 (copy) ]]
			return p1:HasTag(v16.BEZIER_TAG)
		end,
		emit = function(p1, p2, p3) --[[ emit | Line: 379 | Upvalues: t (copy) ]]
			t.bezier(p1, p2, true)
		end
	},
	lightning = {
		check = function(p1) --[[ check | Line: 385 | Upvalues: v16 (copy) ]]
			return p1:HasTag(v16.LIGHTNING_TAG)
		end,
		emit = function(p1, p2, p3) --[[ emit | Line: 388 | Upvalues: t (copy) ]]
			t.lightning(p1, p2, true)
		end
	}
}
return t