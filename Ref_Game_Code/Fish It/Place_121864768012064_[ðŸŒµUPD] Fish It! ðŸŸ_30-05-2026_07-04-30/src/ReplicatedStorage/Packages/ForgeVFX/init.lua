-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = require("@self/mod/logger")
local v2 = require("@self/mod/utility")
local v3 = require("@self/mod/attributes")
local v4 = require("@self/effects/sound")
local v5 = require("@self/effects/bezier")
local v6 = require("@self/effects/lightning")
local v7 = require("@self/effects/camera_shake")
local v8 = require("@self/effects/shockwave_ring")
local v9 = require("@self/effects/shockwave_line")
local v10 = require("@self/effects/shockwave_debris")
local v11 = require("@self/services/caches")
local v12 = require("@self/services/effects")
local v13 = require("@self/services/texture_loader")
local v14 = require("@self/services/enabled_effects")
local PLUGIN_CONTEXT = v2.PLUGIN_CONTEXT
local SERVER_CONTEXT = v2.SERVER_CONTEXT
local t = {
	scope = {},
	setup = false
}
function t.init(p1) --[[ init | Line: 32 | Upvalues: t (copy), SERVER_CONTEXT (copy), v2 (copy), v1 (copy), RunService (copy), PLUGIN_CONTEXT (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v4 (copy), v7 (copy), v5 (copy), v6 (copy), v8 (copy), v9 (copy), v10 (copy) ]]
	if t.setup then
		return
	end
	if SERVER_CONTEXT then
		task.spawn(function() --[[ Line: 38 | Upvalues: v2 (ref), v1 (ref) ]]
			local count = 0
			local v12, v22
			repeat
				count = count + 1
				v12, v22 = pcall(v2.setCollisionGroups, v2.COLLISION_GROUPS)
				if not v12 then
					task.wait(count)
				end
			until v12 or count >= 5
			if v12 then
				return
			end
			v1.warn((("couldn\'t register necessary collision groups after %* tries with the last error being: %*"):format(count, v22)))
		end)
	end
	t.setup = true
	if not RunService:IsServer() or PLUGIN_CONTEXT then
		t.caches = v11.init(t.scope)
		shared.vfx = t
		v12.init(t)
		v13.init(t.scope)
		v14.init(t.scope, t.caches.shared_part, v12)
		v4.init()
		v7.init()
		v5.init(t.caches.shared_part)
		v6.init(t.caches.shared_part)
		v8.init(t.caches.shared_part)
		v9.init(t.caches.shared_part)
		v10.init(t.caches.shared_part)
	end
end
function t.deinit() --[[ deinit | Line: 92 | Upvalues: t (copy), RunService (copy), PLUGIN_CONTEXT (copy), v2 (copy), v12 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), CollectionService (copy) ]]
	if not t.setup then
		return
	end
	t.setup = false
	shared.vfx = nil
	if RunService:IsServer() and not PLUGIN_CONTEXT then
		return
	end
	v2.cleanupScope(t.scope)
	v12.deinit()
	v4.deinit()
	v5.deinit()
	v6.deinit()
	v7.deinit()
	v8.deinit()
	v9.deinit()
	v10.deinit()
	for v1, v22 in CollectionService:GetTagged(v2.CLEANUP_TAG) do
		v22:Destroy()
	end
end
local function fullEmit(p1, p2, ...) --[[ fullEmit | Line: 124 | Upvalues: t (copy), v1 (copy), v12 (copy) ]]
	if t.setup then
		return v12.emit(p2, ...)
	end
	v1.error("not initialized")
	return v12.emit(p2, ...)
end
function t.emit(p1, ...) --[[ emit | Line: 132 | Upvalues: fullEmit (copy) ]]
	if typeof(p1) == "number" then
		return fullEmit(p1, 0, ...)
	else
		return fullEmit(1, 0, p1, ...)
	end
end
function t.emitWithDepth(p1, ...) --[[ emitWithDepth | Line: 140 | Upvalues: fullEmit (copy) ]]
	return fullEmit(1, p1, ...)
end
function t.cacheAttributes(p1, p2) --[[ cacheAttributes | Line: 144 | Upvalues: v2 (copy), v1 (copy), ReplicatedStorage (copy), v3 (copy) ]]
	if v2.SERVER_CONTEXT then
		v1.error("attributes can only be cached in a client-side context")
	end
	if not p1:IsDescendantOf(ReplicatedStorage) then
		v1.error("attributes can only be cached for VFX inside ReplicatedStorage")
	end
	v3.cache(p1)
	if p2 then
		return
	end
	for v12, v22 in p1:GetDescendants() do
		v3.cache(v22)
	end
end
function t.restoreAttributes(p1, p2) --[[ restoreAttributes | Line: 164 | Upvalues: v2 (copy), v1 (copy), v3 (copy) ]]
	if v2.SERVER_CONTEXT then
		v1.error("attributes can only be restored in a client-side context")
	end
	v3.restore(p1)
	if p2 then
		return
	end
	for v12, v22 in p1:GetDescendants() do
		v3.restore(v22)
	end
end
local function setEnabled(p1, p2) --[[ setEnabled | Line: 180 | Upvalues: v3 (copy) ]]
	if p1:IsA("ParticleEmitter") then
		p1.Enabled = p2
		return
	end
	if p1:IsA("Beam") then
		p1.Enabled = p2
		return
	end
	if v3.isCached(p1) then
		v3.trigger(p1, "Enabled", p2)
	else
		p1:SetAttribute("Enabled", p2)
	end
end
function t.enable(p1) --[[ enable | Line: 196 | Upvalues: setEnabled (copy) ]]
	setEnabled(p1, true)
	for v1, v2 in p1:GetDescendants() do
		setEnabled(v2, true)
	end
end
function t.disable(p1) --[[ disable | Line: 204 | Upvalues: setEnabled (copy) ]]
	setEnabled(p1, false)
	for v1, v2 in p1:GetDescendants() do
		setEnabled(v2, false)
	end
end
t.retime = require("@self/mod/retime").batch
t.resize = require("@self/mod/resize").batch
t.recolor = require("@self/mod/recolor")
return t