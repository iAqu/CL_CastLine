-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local logger = require(script.mod.logger)
local utility = require(script.mod.utility)
local beam = require(script.effects.beam)
local spin = require(script.effects.spin)
local mesh = require(script.effects.mesh)
local bezier = require(script.effects.bezier)
local screen = require(script.effects.screen)
local particle = require(script.effects.particle)
local camera_shake = require(script.effects.camera_shake)
local tween_property = require(script.effects.tween_property)
local shockwave_ring = require(script.effects.shockwave_ring)
local shockwave_line = require(script.effects.shockwave_line)
local shockwave_debris = require(script.effects.shockwave_debris)
local Promise = require(script.pkg.Promise)
local ObjectCache = require(script.obj.ObjectCache)
local v1 = script:FindFirstAncestorOfClass("Plugin")
local v2 = RunService:IsServer() or v1
local t = {
	scope = {},
	setup = false
}
local function assembleMeshVFX(p1, p2) --[[ assembleMeshVFX | Line: 116 | Upvalues: t (copy), logger (copy), utility (copy) ]]
	if not t.setup then
		logger.error("API not initialized")
	end
	local v1 = utility.getRanomId()
	if p1:IsA("Part") then
		local v2 = t.caches.shared_part:get(v1)
		v2.CFrame = p1.CFrame
		local v3 = v2._getReal()
		utility.copyProperties(p1, v3, utility.COPY_PART_PROPERTIES)
		utility.copyProperties(p1, v3, utility.COPY_EXTENDED_PART_PROPERTIES)
		local v4 = p1:Clone()
		for v5, v6 in v4:GetChildren() do
			v6.Parent = v3
		end
		v4:Destroy()
		local function f7() --[[ Line: 140 | Upvalues: t (ref), v1 (copy) ]]
			t.caches.shared_part:free(v1)
		end
		table.insert(p2, f7)
		return v2
	else
		local v8 = p1:Clone()
		v8.Archivable = false
		v8.Locked = true
		v8.Parent = workspace.Terrain
		table.insert(p2, v8)
		return v8
	end
end
function t.init(p1) --[[ init | Line: 157 | Upvalues: t (copy), v2 (copy), utility (copy), logger (copy), RunService (copy), v1 (copy), ObjectCache (copy), camera_shake (copy), bezier (copy), shockwave_ring (copy), shockwave_line (copy), shockwave_debris (copy), CollectionService (copy), mesh (copy), assembleMeshVFX (copy) ]]
	if not t.setup then
		if v2 then
			task.spawn(function() --[[ Line: 163 | Upvalues: utility (ref), logger (ref) ]]
				local count = 0
				local v1, v2
				repeat
					count = count + 1
					v1, v2 = pcall(utility.setCollisionGroups, utility.COLLISION_GROUPS)
					if not v1 then
						task.wait(count)
					end
				until v1 or count >= 5
				if not v1 then
					logger.warn((("couldn\'t register necessary collision groups after %* tries with the last error being: %*"):format(count, v2)))
				end
			end)
		end
		t.setup = true
		if not RunService:IsServer() or v1 then
			shared.vfx = t
			local Part = Instance.new("Part")
			Part.Transparency = 1
			Part.Anchored = true
			Part.CanCollide = false
			Part.CanQuery = false
			Part.Locked = true
			local DO_NOT_REMOVE_ForgeSharedPartCache = Instance.new("Folder")
			DO_NOT_REMOVE_ForgeSharedPartCache.Name = "DO_NOT_REMOVE_ForgeSharedPartCache"
			DO_NOT_REMOVE_ForgeSharedPartCache.Archivable = false
			DO_NOT_REMOVE_ForgeSharedPartCache.Parent = workspace.Terrain
			utility.protectParent(t.scope, DO_NOT_REMOVE_ForgeSharedPartCache)
			local v12 = ObjectCache.new(Part, DO_NOT_REMOVE_ForgeSharedPartCache, {
				size = 150,
				on_free = function(p1) --[[ on_free | Line: 217 ]]
					local value = p1.value
					value.Transparency = 1
					value.Anchored = true
					value.CanQuery = false
					value.CanCollide = false
					value.CollisionGroup = "ForgeMouseIgnore"
					value.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					value.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					value:ClearAllChildren()
				end
			})
			t.caches = {
				shared_part = v12
			}
			local scope = t.scope
			local function f2() --[[ Line: 243 | Upvalues: v12 (ref) ]]
				v12:destroy()
			end
			table.insert(scope, f2)
			camera_shake.init()
			bezier.init(v12)
			shockwave_ring.init(v12)
			shockwave_line.init(v12)
			shockwave_debris.init(v12)
			local Decal = Instance.new("Decal")
			local DO_NOT_REMOVE_ForgeTextureCache = Instance.new("Part")
			DO_NOT_REMOVE_ForgeTextureCache.Name = "DO_NOT_REMOVE_ForgeTextureCache"
			DO_NOT_REMOVE_ForgeTextureCache.Transparency = 1
			DO_NOT_REMOVE_ForgeTextureCache.Size = Vector3.new(0, 0, 0)
			DO_NOT_REMOVE_ForgeTextureCache.Archivable = false
			DO_NOT_REMOVE_ForgeTextureCache.Anchored = true
			DO_NOT_REMOVE_ForgeTextureCache.CanCollide = false
			DO_NOT_REMOVE_ForgeTextureCache.CanQuery = false
			DO_NOT_REMOVE_ForgeTextureCache.Locked = true
			DO_NOT_REMOVE_ForgeTextureCache.Parent = workspace.Terrain
			utility.protectParent(t.scope, DO_NOT_REMOVE_ForgeTextureCache)
			local v3 = ObjectCache.new(Decal, DO_NOT_REMOVE_ForgeTextureCache, {
				size = 360,
				on_free = function(p1) --[[ on_free | Line: 272 ]]
					p1.value.Texture = ""
				end
			})
			local t2 = {}
			local function loadTextures(p1) --[[ loadTextures | Line: 279 | Upvalues: utility (ref), v3 (copy), v1 (ref), CollectionService (ref), t2 (copy) ]]
				if not p1:IsDescendantOf(workspace.Terrain) then
					if utility.isMeshVFX(p1) then
						local Start = p1:FindFirstChild("Start")
						if Start and Start:IsA("BasePart") then
							local t = {}
							local t3 = {}
							table.insert(t, t3)
							local function refresh() --[[ refresh | Line: 296 | Upvalues: utility (ref), t3 (copy), p1 (copy), Start (copy), v3 (ref), v1 (ref), CollectionService (ref) ]]
								utility.cleanupScope(t3)
								local v12, v2 = utility.getMeshDecals(p1, Start)
								local function add(p1) --[[ add | Line: 301 | Upvalues: v3 (ref), t3 (ref) ]]
									local v1 = typeof(p1) == "Instance" and p1.Texture or p1
									if v1 ~= "" then
										v3:get(v1).Texture = v1
										local function f3() --[[ Line: 311 | Upvalues: v3 (ref), v1 (copy) ]]
											v3:free(v1)
										end
										table.insert(t3, f3)
									end
								end
								for v32, v4 in v12 do
									local v5 = typeof(v4) == "Instance" and v4.Texture or v4
									if v5 ~= "" then
										v3:get(v5).Texture = v5
										local function f7() --[[ Line: 311 | Upvalues: v3 (ref), v5 (copy) ]]
											v3:free(v5)
										end
										table.insert(t3, f7)
									end
								end
								for v8, v9 in v2 do
									local v10 = false
									if v1 then
										for v11, v122 in CollectionService:GetTags(v8) do
											if v122:match("^_local_flipbook_") then
												v10 = true
											else
												continue
											end
											break
										end
									end
									for v13, v14 in v9 do
										local v17 = ("%*%*"):format(if v10 then "rbxtemp://" else "rbxassetid://", v14)
										local v18, v20, v21
										if typeof(v17) == "Instance" then
											local v19
											v18 = v17.Texture
											if not v18 then
												v19 = v17
												v18 = v17
											end
											if v18 ~= "" then
												v3:get(v18).Texture = v18
												v20 = t3
												v21 = function() --[[ Line: 311 | Upvalues: v3 (ref), v18 (copy) ]]
													v3:free(v18)
												end
												table.insert(t3, v21)
											end
											continue
										end
										v18 = v17
										if v18 ~= "" then
											v3:get(v18).Texture = v18
											v20 = t3
											v21 = function() --[[ Line: 311 | Upvalues: v3 (ref), v18 (copy) ]]
												v3:free(v18)
											end
											table.insert(t3, v21)
										end
									end
								end
							end
							refresh()
							if v1 then
								local v12 = utility.reboundfn(1, refresh)
								table.insert(t, Start.DescendantAdded:Connect(v12))
								table.insert(t, Start.DescendantRemoving:Connect(v12))
							end
							t2[p1] = t
						end
					else
						local t = {}
						local t3 = {}
						table.insert(t, t3)
						local function refresh() --[[ refresh | Line: 354 | Upvalues: utility (ref), t3 (copy), v3 (ref), p1 (copy) ]]
							utility.cleanupScope(t3)
							local function check(p1) --[[ check | Line: 357 | Upvalues: v3 (ref), t3 (ref) ]]
								if p1:IsA("ParticleEmitter") then
									local Texture = p1.Texture
									if Texture ~= "" then
										v3:get(Texture).Texture = Texture
										local function f2() --[[ Line: 371 | Upvalues: v3 (ref), Texture (copy) ]]
											v3:free(Texture)
										end
										table.insert(t3, f2)
									end
								end
							end
							check(p1)
							for v1, v2 in p1:GetDescendants() do
								check(v2)
							end
						end
						refresh()
						if v1 then
							local v2 = utility.reboundfn(1, refresh)
							table.insert(t, p1.DescendantAdded:Connect(v2))
							table.insert(t, p1.DescendantRemoving:Connect(v2))
						end
						t2[p1] = t
					end
				end
			end
			for v4, v5 in CollectionService:GetTagged(utility.TEXTURE_LOAD_TAG) do
				loadTextures(v5)
			end
			CollectionService:GetInstanceAddedSignal(utility.TEXTURE_LOAD_TAG):Connect(loadTextures)
			CollectionService:GetInstanceRemovedSignal(utility.TEXTURE_LOAD_TAG):Connect(function(p1) --[[ Line: 401 | Upvalues: t2 (copy), utility (ref) ]]
				local v1 = t2[p1]
				if v1 then
					utility.cleanupScope(v1)
					t2[p1] = nil
				end
			end)
			local scope_2 = t.scope
			local function f6() --[[ Line: 410 | Upvalues: v3 (copy), t2 (copy), utility (ref) ]]
				v3:destroy()
				for v1, v2 in t2 do
					utility.cleanupScope(v2)
				end
			end
			table.insert(scope_2, f6)
			local t3 = {}
			local function removeEnabledEffect(p1) --[[ removeEnabledEffect | Line: 422 | Upvalues: t3 (copy), utility (ref) ]]
				local v1 = t3[p1]
				if v1 then
					utility.cleanupScope(v1)
				end
				t3[p1] = nil
			end
			local function v7(p1) --[[ addEnabledEffect | Line: 432 | Upvalues: utility (ref), t3 (copy), v7 (copy), RunService (ref), t (ref), mesh (ref), assembleMeshVFX (ref), bezier (ref) ]]
				local v1 = utility.isMeshVFX(p1)
				local v2 = p1:HasTag(utility.BEZIER_TAG)
				if v1 or v2 then
					local t2 = {}
					local t4 = {}
					table.insert(t2, t4)
					t3[p1] = t2
					local function f3() --[[ Line: 449 | Upvalues: p1 (copy), t3 (ref), v7 (ref), utility (ref) ]]
						if p1:IsDescendantOf(workspace) or p1.Parent and p1.Parent:HasTag("AllowEmitting") then
							if not t3[p1] then
								v7(p1)
							end
						else
							local v1 = p1
							local v2 = t3[v1]
							if v2 then
								utility.cleanupScope(v2)
							end
							t3[v1] = nil
						end
					end
					table.insert(t2, p1.AncestryChanged:Connect(f3))
					if not p1:IsDescendantOf(workspace) and if p1.Parent then not p1.Parent:HasTag("AllowEmitting") else false then
						return
					end
					local function onEnabled() --[[ onEnabled | Line: 466 | Upvalues: utility (ref), p1 (copy), t4 (copy), RunService (ref), t (ref), v1 (copy), mesh (ref), assembleMeshVFX (ref), v2 (copy), bezier (ref) ]]
						if utility.getAttribute(p1, "Enabled", true) then
							local v12 = 0
							local function f3() --[[ Line: 474 | Upvalues: utility (ref), p1 (ref), v12 (ref), t (ref), v1 (ref), mesh (ref), assembleMeshVFX (ref), v2 (ref), bezier (ref) ]]
								local v13 = utility.getAttribute(p1, "Rate", 5)
								local v22 = p1:GetAttribute("SpeedOverride") or 1
								if v22 ~= 0 and not (os.clock() - v12 <= 1 / v13 / v22) then
									local t2 = {
										depth = 0
									}
									local function cleanup() --[[ cleanup | Line: 489 | Upvalues: utility (ref), t2 (copy) ]]
										utility.cleanupScope(t2)
									end
									table.insert(t.scope, cleanup)
									if v1 then
										local Start = p1:FindFirstChild("Start")
										if Start then
											v12 = os.clock()
											for i = 1, utility.getAttribute(p1, "EmitCount", 1) do
												utility.try(("failed to emit mesh \'%*\' with error: %%s"):format((p1:GetFullName())), mesh.emit, p1, assembleMeshVFX(Start, t2), t2, 1, true)
											end
										else
											p1:RemoveTag(utility.ENABLED_VFX_TAG)
											return
										end
									elseif v2 then
										local Part = p1:FindFirstChildOfClass("Part")
										if Part then
											v12 = os.clock()
											local v3 = Part:Clone()
											v3.Locked = true
											table.insert(t2, v3)
											utility.try(("failed to emit bezier \'%*\' with error: %%s"):format((p1:GetFullName())), bezier.emit, p1, v3, t2, true)
										else
											return
										end
									end
									local v4 = table.find(t.scope, cleanup)
									if v4 then
										table.remove(t.scope, v4)
									end
									utility.cleanupScope(t2)
								end
							end
							table.insert(t4, RunService.RenderStepped:Connect(f3))
						else
							utility.cleanupScope(t4)
						end
					end
					table.insert(t2, p1:GetAttributeChangedSignal("Enabled"):Connect(onEnabled))
					onEnabled()
				end
			end
			for v8, v9 in CollectionService:GetTagged(utility.ENABLED_VFX_TAG) do
				v7(v9)
			end
			CollectionService:GetInstanceAddedSignal(utility.ENABLED_VFX_TAG):Connect(v7)
			CollectionService:GetInstanceRemovedSignal(utility.ENABLED_VFX_TAG):Connect(removeEnabledEffect)
			local scope_3 = t.scope
			local function f10() --[[ Line: 566 | Upvalues: t3 (copy), utility (ref) ]]
				for v1, v2 in t3 do
					utility.cleanupScope(v2)
				end
			end
			table.insert(scope_3, f10)
		end
	end
end
function t.deinit() --[[ deinit | Line: 574 | Upvalues: t (copy), RunService (copy), v1 (copy), utility (copy), bezier (copy), camera_shake (copy), shockwave_ring (copy), shockwave_line (copy), shockwave_debris (copy) ]]
	if t.setup then
		t.setup = false
		shared.vfx = nil
		if not RunService:IsServer() or v1 then
			utility.cleanupScope(t.scope)
			bezier.deinit()
			camera_shake.deinit()
			shockwave_ring.deinit()
			shockwave_line.deinit()
			shockwave_debris.deinit()
		end
	end
end
function t.emit(p1, ...) --[[ emit | Line: 596 | Upvalues: t (copy), logger (copy), Promise (copy), utility (copy), particle (copy), beam (copy), bezier (copy), mesh (copy), assembleMeshVFX (copy), spin (copy), camera_shake (copy), tween_property (copy), shockwave_ring (copy), shockwave_debris (copy), shockwave_line (copy), screen (copy) ]]
	if not t.setup then
		logger.error("not initialized")
	end
	local t2 = {}
	local t3 = {}
	local v1 = 1
	local function emit(p1, p2) --[[ emit | Line: 606 | Upvalues: Promise (ref), utility (ref), t3 (copy), t2 (copy), particle (ref), v1 (ref), beam (ref), bezier (ref), mesh (ref), assembleMeshVFX (ref), spin (ref), camera_shake (ref), tween_property (ref), shockwave_ring (ref), shockwave_debris (ref), shockwave_line (ref) ]]
		return Promise.new(function(p12) --[[ Line: 607 | Upvalues: p2 (copy), p1 (copy), utility (ref), t3 (ref), t2 (ref), particle (ref), v1 (ref), beam (ref), bezier (ref), Promise (ref), mesh (ref), assembleMeshVFX (ref), spin (ref), camera_shake (ref), tween_property (ref), shockwave_ring (ref), shockwave_debris (ref), shockwave_line (ref) ]]
			(function() --[[ run | Line: 608 | Upvalues: p2 (ref), p1 (ref), utility (ref), t3 (ref), t2 (ref), particle (ref), v1 (ref), beam (ref), bezier (ref), Promise (ref), mesh (ref), assembleMeshVFX (ref), spin (ref), camera_shake (ref), tween_property (ref), shockwave_ring (ref), shockwave_debris (ref), shockwave_line (ref) ]]
				local t = {
					depth = p2
				}
				if p1:IsA("ParticleEmitter") then
					if p1:IsDescendantOf(workspace) then
						utility.try(("failed to emit particle \'%*\' with error: %%s"):format((p1:GetFullName())), particle.emit, p1, p1, t, v1)
						utility.cleanupScope(t)
					else
						local v12, v2 = utility.cloneParticleAncestry(p1, t3)
						if v12 then
							table.insert(t, v2)
							local v3 = p1:Clone()
							v3.Archivable = false
							v3.Parent = v12
							if not t2[v2] then
								v2.Parent = workspace.Terrain
							end
							if t2[v2] then
								local v4 = t2
								v4[v2] = v4[v2] + 1
							else
								t2[v2] = 1
							end
							utility.try(("failed to emit particle \'%*\' with error: %%s"):format((p1:GetFullName())), particle.emit, p1, v3, t, v1)
							local v5 = t2
							v5[v2] = v5[v2] - 1
							if t2[v2] <= 0 then
								utility.cleanupScope(t)
							end
						else
							return
						end
					end
				elseif p1:IsA("Beam") then
					local v6 = p1:Clone()
					v6.Archivable = false
					v6.Parent = workspace.Terrain
					table.insert(t, v6)
					utility.try(("failed to emit beam \'%*\' with error: %%s"):format((p1:GetFullName())), beam.emit, p1, v6, t, v1)
					utility.cleanupScope(t)
				elseif p1:IsA("Trail") then
					p1.Enabled = true
				elseif p1:HasTag(utility.BEZIER_TAG) then
					local Part = p1:FindFirstChildOfClass("Part")
					if Part then
						if p1:GetAttribute("Enabled") then
							p1:SetAttribute("Enabled", false)
						end
						local v7 = Part:Clone()
						v7.Locked = true
						table.insert(t, v7)
						utility.try(("failed to emit bezier \'%*\' with error: %%s"):format((p1:GetFullName())), bezier.emit, p1, v7, t)
						utility.cleanupScope(t)
					else
						return
					end
				elseif utility.isMeshVFX(p1) then
					local Start = p1:FindFirstChild("Start")
					if Start then
						if p1:GetAttribute("Enabled") then
							p1:SetAttribute("Enabled", false)
						end
						local t4 = {}
						for i = 1, utility.getAttribute(p1, "EmitCount", 1) do
							local function f9(p12) --[[ Line: 714 | Upvalues: utility (ref), p1 (ref), mesh (ref), assembleMeshVFX (ref), Start (copy), t (copy), v1 (ref) ]]
								utility.try(("failed to emit mesh \'%*\' with error: %%s"):format((p1:GetFullName())), mesh.emit, p1, assembleMeshVFX(Start, t), t, v1)
								p12()
							end
							table.insert(t4, Promise.new(f9))
						end
						Promise.all(t4):await()
						utility.cleanupScope(t)
					else
						return
					end
				elseif p1:IsA("Model") then
					if utility.lock(p1) then
						return
					end
					utility.try(("failed to emit spinning model \'%*\' with error: %%s"):format((p1:GetFullName())), spin.emit, p1, t)
					utility.cleanupScope(t)
					utility.unlock(p1)
				elseif p1:IsA("RayValue") then
					if p1:HasTag(utility.SCREENSHAKE_TAG) then
						utility.try(("failed to emit camera shake \'%*\' with error: %%s"):format((p1:GetFullName())), camera_shake.emit, p1, t)
						utility.cleanupScope(t)
					elseif p1.Parent and not utility.lock(p1) then
						utility.try(("failed to emit tween property \'%*\' with error: %%s"):format((p1:GetFullName())), tween_property.emit, p1.Parent, p1, t)
						utility.unlock(p1)
						utility.cleanupScope(t)
					else
						return
					end
				end
				if p1:IsA("Part") then
					local v10 = utility.findFirstClassWithTag(p1, "Attachment", utility.SHOCKWAVE_TAG)
					if not v10 then
						return
					end
					local v11 = p1.Parent.Name
					if v11 == "Rings" then
						utility.try(("failed to emit shockwave ring \'%*\' with error: %%s"):format((p1:GetFullName())), shockwave_ring.emit, v10, p1, t)
						return
					end
					if v11 == "Debris" then
						utility.try(("failed to emit shockwave debris \'%*\' with error: %%s"):format((p1:GetFullName())), shockwave_debris.emit, v10, p1, t)
						return
					end
					if v11 ~= "Lines" then
						return
					end
					utility.try(("failed to emit shockwave line \'%*\' with error: %%s"):format((p1:GetFullName())), shockwave_line.emit, v10, p1, t)
					utility.cleanupScope(t)
				end
			end)()
			p12()
		end)
	end
	local t4 = { ... }
	if typeof(p1) == "number" then
		v1 = p1
	else
		table.insert(t4, p1)
	end
	local t5 = {}
	local function v2(p1, p2, p3) --[[ emitAll | Line: 827 | Upvalues: utility (ref), screen (ref), v2 (copy), t5 (copy), Promise (ref), emit (copy) ]]
		for v1, v22 in p2 do
			if v22:IsA("BasePart") and (v22:GetAttribute("Enabled") and not utility.findFirstClassWithTag(v22, "Attachment", utility.SHOCKWAVE_TAG)) then
				if not utility.lock(v22) then
					local v3 = v22:FindFirstAncestorOfClass("Model")
					if not v3 or v3:GetAttribute("SpinRotation") == Vector3.new(0, 0, 0) and (v3:GetAttribute("Scale_Start") == 1 and v3:GetAttribute("Scale_End") == 1) then
						local v4 = coroutine.running()
						local t = {
							depth = p1
						}
						if utility.try(("failed to emit screen effect \'%*\' with error: %%s"):format((v22:GetFullName())), screen.emit, v22, t) then
							if #v22:GetDescendants() == 0 then
								utility.cleanupScope(t)
								return
							end
							local t2 = {}
							v2(p1 + 1, v22:GetChildren(), t2)
							local function f7() --[[ Line: 873 | Upvalues: utility (ref), v22 (copy), v4 (copy), t (copy) ]]
								utility.unlock(v22, v4)
								utility.cleanupScope(t)
							end
							table.insert(t5, Promise.all(t2):finally(f7))
						end
					end
				end
				continue
			end
			table.insert(p3, emit(v22, p1))
			if not (v22:HasTag(utility.BEZIER_TAG) or (utility.isMeshVFX(v22) or v22:IsA("BasePart") and utility.findFirstClassWithTag(v22, "Attachment", utility.SHOCKWAVE_TAG))) then
				v2(p1 + 1, v22:GetChildren(), p3)
			end
		end
	end
	v2(0, t4, t5)
	return {
		Finished = Promise.all(t5)
	}
end
return t