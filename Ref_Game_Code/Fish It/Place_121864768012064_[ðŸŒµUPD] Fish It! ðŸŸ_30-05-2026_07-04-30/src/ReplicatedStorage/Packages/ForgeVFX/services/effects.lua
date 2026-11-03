-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
require("../types")
local v1 = require("../mod/logger")
local v2 = require("../mod/utility")
local v3 = require("../emitters")
local v4 = require("../pkg/Promise")
local v5 = table.concat({
	"Beam",
	"Trail",
	"Sound",
	"ParticleEmitter",
	(".%*"):format(v2.BEZIER_TAG),
	(".%*"):format(v2.LIGHTNING_TAG),
	"Model",
	"RayValue",
	"BasePart[$Enabled=true]",
	"#Rings > Part",
	"#Lines > Part",
	"#Debris > Part"
}, ",")
local t = {}
local v6 = nil
local function f7() --[[ Line: 39 ]] end
local t2 = {
	Finished = v4.resolve(),
	Clear = f7
}
function t.init(p1) --[[ init | Line: 46 | Upvalues: v6 (ref) ]]
	v6 = p1
end
function t.deinit() --[[ deinit | Line: 50 | Upvalues: v6 (ref) ]]
	v6 = nil
end
local function emitWithContext(p1, p2, ...) --[[ emitWithContext | Line: 54 | Upvalues: v6 (ref), v1 (copy), t2 (copy), v5 (copy), v2 (copy), t (copy), v3 (copy), v4 (copy), f7 (copy) ]]
	if not (v6 and v6.setup) then
		v1.error("effects service not initialized")
		return t2
	end
	local t3 = {}
	local t4 = {}
	local function queryAndEmitDescendants(p1, p22) --[[ queryAndEmitDescendants | Line: 68 | Upvalues: v5 (ref), v2 (ref), t (ref), v3 (ref), t3 (copy), t4 (copy), v6 (ref), p2 (copy) ]]
		local v1 = p1:QueryDescendants(v5)
		local v22 = #v1
		if v22 == 0 then
			return {}
		end
		local v32 = table.create(v22)
		local t2 = {}
		local t5 = {}
		t2[p1] = false
		t5[p1] = p22
		for v4, v52 in v1 do
			local v62 = v52.Parent
			local t6 = {}
			while t5[v62] == nil do
				table.insert(t6, v62)
				v62 = v62.Parent
			end
			local v7 = t2[v62]
			local count = t5[v62]
			for i = #t6, 1, -1 do
				local v8 = t6[i]
				count = count + 1
				t5[v8] = count
				if not v7 then
					v7 = v2.shouldSkipNested(v8) or v8:HasTag(v2.EMIT_EXCLUDE_TAG)
				end
				t2[v8] = v7
			end
			if not v7 then
				local function f12(p1) --[[ Line: 112 | Upvalues: v3 (ref), v52 (copy), t3 (ref), t4 (ref), v6 (ref) ]]
					v3.dispatch(v52, p1, t3, t4, v6.caches.shared_part, 1)
				end
				table.insert(v32, v2.createEmitPromise(t, v52, t5[v52.Parent], f12, p2))
			end
		end
		return v32
	end
	local t5 = {}
	for v12, v22 in { ... } do
		if v22:IsA("BasePart") and (v22:GetAttribute("Enabled") and not v2.findFirstClassWithTag(v22, "Attachment", v2.SHOCKWAVE_TAG)) then
			if not v2.lock(v22) then
				local v32 = v22:FindFirstAncestorOfClass("Model")
				if not v32 or v2.isSpinModelStatic(v32) then
					local v42 = coroutine.running()
					local t6 = {
						depth = p1,
						effects = t,
						_context = p2
					}
					if v3.screen(v22, t6) then
						local v52 = queryAndEmitDescendants(v22, p1 + 1)
						if #v52 > 0 then
							local function f72() --[[ Line: 154 | Upvalues: v2 (ref), v22 (copy), v42 (copy), t6 (copy) ]]
								v2.unlock(v22, v42)
								v2.cleanupScope(t6)
							end
							table.insert(t5, v4.all(v52):finally(f72))
							continue
						end
						v2.unlock(v22, v42)
						v2.cleanupScope(t6)
					end
				end
			end
			continue
		end
		local createEmitPromise = v2.createEmitPromise
		local function f9(p1) --[[ Line: 168 | Upvalues: v3 (ref), v22 (copy), t3 (copy), t4 (copy), v6 (ref) ]]
			v3.dispatch(v22, p1, t3, t4, v6.caches.shared_part, 1)
		end
		table.insert(t5, createEmitPromise(t, v22, p1, f9, p2))
		if not v2.shouldSkipNested(v22) then
			for v10, v11 in queryAndEmitDescendants(v22, p1 + 1) do
				table.insert(t5, v11)
			end
		end
	end
	local t6 = {
		Finished = v4.all(t5)
	}
	t6.Clear = if p2 then function() --[[ Line: 187 | Upvalues: p2 (copy), t6 (copy) ]]
	for v1, v2 in p2._promises do
		v2:cancel()
	end
	t6.Finished:cancel()
end else f7
	return t6
end
function t.emit(p1, ...) --[[ emit | Line: 198 | Upvalues: emitWithContext (copy) ]]
	return emitWithContext(p1, {
		_promises = {}
	}, ...)
end
function t.prepareEmitFolder(p1, p2, p3) --[[ prepareEmitFolder | Line: 203 ]]
	local v1 = p1:FindFirstChild(p2)
	if v1 and v1:IsA("Folder") then
		v1.Parent = nil
		table.insert(p3, v1)
		return v1
	else
		return nil
	end
end
function t.prepareEmitOnFinish(p1, p2) --[[ prepareEmitOnFinish | Line: 215 | Upvalues: t (copy) ]]
	return t.prepareEmitFolder(p1, "EmitOnFinish", p2)
end
function t.emitNested(p1, p2, p3) --[[ emitNested | Line: 219 | Upvalues: v6 (ref), t2 (copy), emitWithContext (copy) ]]
	if not (v6 and v6.setup) then
		return t2
	end
	local v1 = p1:GetChildren()
	if #v1 == 0 then
		return t2
	end
	return emitWithContext(p2, if p3 then p3._context else nil, table.unpack(v1))
end
function t.emitFromFolder(p1, p2, p3, p4) --[[ emitFromFolder | Line: 234 | Upvalues: t2 (copy), emitWithContext (copy) ]]
	if not p1 then
		return t2
	end
	local v1 = p1:GetChildren()
	if #v1 == 0 then
		return t2
	end
	for v2, v3 in v1 do
		v3.Parent = p2
	end
	return emitWithContext(p3, if p4 then p4._context else nil, table.unpack(v1))
end
function t.emitOnFinish(p1, p2, p3, p4) --[[ emitOnFinish | Line: 258 | Upvalues: t (copy) ]]
	return t.emitFromFolder(p1, p2, p3, p4)
end
return t