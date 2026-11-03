-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local v1 = require("../mod/attributes")
require("../types")
local v2 = require("../mod/utility")
local v3 = require("../emitters")
return {
	init = function(p1, p2, p3) --[[ init | Line: 11 | Upvalues: v2 (copy), v3 (copy), v1 (copy), RunService (copy), CollectionService (copy) ]]
		local t = {}
		local t2 = {}
		local function removeEnabledEffect(p1) --[[ removeEnabledEffect | Line: 15 | Upvalues: t (copy), v2 (ref) ]]
			local v1 = t[p1]
			if v1 then
				v2.cleanupScope(v1)
			end
			t[p1] = nil
		end
		local function removeEnabledEffectFull(p1) --[[ removeEnabledEffectFull | Line: 25 | Upvalues: t (copy), v2 (ref), t2 (copy) ]]
			local v1 = t[p1]
			if v1 then
				v2.cleanupScope(v1)
			end
			t[p1] = nil
			local v22 = t2[p1]
			if not v22 then
				return
			end
			v22:Disconnect()
			t2[p1] = nil
		end
		local function v12(p1) --[[ addEnabledEffect | Line: 36 | Upvalues: v3 (ref), t (copy), t2 (copy), v12 (copy), v2 (ref), v1 (ref), RunService (ref), p3 (copy), p2 (copy) ]]
			local v13 = nil
			for v22, v32 in v3.enabled_registry do
				if v32.check(p1) then
					v13 = v32
					break
				end
			end
			if not v13 then
				return
			end
			local t3 = {}
			local t4 = {}
			table.insert(t4, t3)
			t[p1] = t4
			if not t2[p1] then
				t2[p1] = p1.AncestryChanged:Connect(function() --[[ Line: 59 | Upvalues: p1 (copy), t (ref), v12 (ref), v2 (ref) ]]
					if p1:IsDescendantOf(workspace) or p1.Parent and p1.Parent:HasTag("AllowEmitting") then
						if not t[p1] then
							v12(p1)
						end
					else
						local v1 = p1
						local v22 = t[v1]
						if v22 then
							v2.cleanupScope(v22)
						end
						t[v1] = nil
					end
				end)
			end
			local function onEnabled(p12) --[[ onEnabled | Line: 70 | Upvalues: v1 (ref), p1 (copy), v2 (ref), t3 (copy), RunService (ref), p3 (ref), v13 (ref), p2 (ref) ]]
				if p12 == nil then
					p12 = v1.get(p1, "Enabled", true)
				end
				local v22 = v2.isForceEmitting(p1) or (p1:IsDescendantOf(workspace) or p1.Parent and p1.Parent:HasTag("AllowEmitting"))
				if p12 and not v22 then
					return
				end
				if p12 then
					v2.cleanupScope(t3)
					local v3 = 0
					local t = {
						_promises = {},
						_scopes = {}
					}
					v2.setEnabledCancelToken(p1, t)
					local function f5() --[[ Line: 93 | Upvalues: v1 (ref), p1 (ref), v3 (ref), p3 (ref), t (copy), v13 (ref), p2 (ref), v2 (ref) ]]
						local v12 = v1.get(p1, "Rate", 5)
						local v22 = v1.getState(p1, "SpeedOverride", 1)
						if v22 == 0 then
							return
						end
						if os.clock() - v3 <= 1 / v12 / v22 then
							return
						end
						v3 = os.clock()
						local t2 = {
							depth = 0,
							effects = p3,
							_context = t
						}
						table.insert(t._scopes, t2)
						v13.emit(p1, t2, p2)
						local v32 = table.find(t._scopes, t2)
						if not v32 then
							v2.cleanupScope(t2)
							return
						end
						table.remove(t._scopes, v32)
						v2.cleanupScope(t2)
					end
					table.insert(t3, RunService.RenderStepped:Connect(f5))
				else
					v2.cleanupScope(t3)
				end
			end
			local hook = v1.hook
			table.insert(t4, hook(p1, "Enabled", onEnabled))
			onEnabled()
		end
		for v22, v32 in CollectionService:GetTagged(v2.ENABLED_VFX_TAG) do
			v12(v32)
		end
		CollectionService:GetInstanceAddedSignal(v2.ENABLED_VFX_TAG):Connect(v12)
		CollectionService:GetInstanceRemovedSignal(v2.ENABLED_VFX_TAG):Connect(removeEnabledEffectFull)
		local function f4() --[[ Line: 141 | Upvalues: t (copy), v2 (ref), t2 (copy) ]]
			for v1, v22 in t do
				v2.cleanupScope(v22)
			end
			for v3, v4 in t2 do
				v4:Disconnect()
			end
			table.clear(t2)
		end
		table.insert(p1, f4)
	end
}