-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local v1 = require("../obj/ObjectCache")
require("../types")
local v2 = require("../mod/utility")
local v3 = require("../mod/common/flipbook")
return {
	init = function(p1) --[[ init | Line: 11 | Upvalues: v2 (copy), v1 (copy), v3 (copy), CollectionService (copy) ]]
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
		v2.protectParent(p1, DO_NOT_REMOVE_ForgeTextureCache)
		local v12 = v1.new(Decal, DO_NOT_REMOVE_ForgeTextureCache, {
			size = 360,
			on_free = function(p1) --[[ on_free | Line: 29 ]]
				p1.value.Texture = ""
			end
		})
		local t = {}
		local function createLoader(p1, p2, p3) --[[ createLoader | Line: 36 | Upvalues: v2 (ref), v12 (copy), t (copy) ]]
			local t2 = {}
			local t3 = {}
			table.insert(t2, t3)
			local function refresh() --[[ refresh | Line: 46 | Upvalues: v2 (ref), t3 (copy), v12 (ref), p2 (copy) ]]
				v2.cleanupScope(t3)
				p2(function(p1_2) --[[ add | Line: 49 | Upvalues: v12 (ref), t3 (ref) ]]
					if p1_2 ~= "" then
						v12:get(p1_2).Texture = p1_2
						local function f22() --[[ Line: 57 | Upvalues: v12 (ref), p1_2 (copy) ]]
							v12:free(p1_2)
						end
						table.insert(t3, f22)
					end
				end)
			end
			v2.cleanupScope(t3)
			p2(function(p1_2) --[[ add | Line: 49 | Upvalues: v12 (ref), t3 (copy) ]]
				if p1_2 ~= "" then
					v12:get(p1_2).Texture = p1_2
					local function f22() --[[ Line: 57 | Upvalues: v12 (ref), p1_2 (copy) ]]
						v12:free(p1_2)
					end
					table.insert(t3, f22)
				end
			end)
			if v2.PLUGIN_CONTEXT and p3 then
				for v1, v22 in p3((v2.reboundfn(1, refresh))) do
					table.insert(t2, v22)
				end
			end
			t[p1] = t2
		end
		local function loadTextures(p1) --[[ loadTextures | Line: 78 | Upvalues: v2 (ref), createLoader (copy), v3 (ref) ]]
			if p1:IsDescendantOf(workspace.Terrain) then
				return
			end
			if v2.isMeshVFX(p1) then
				local Start = p1:FindFirstChild("Start")
				if Start and Start:IsA("BasePart") then
					createLoader(p1, function(p12) --[[ Line: 90 | Upvalues: v2 (ref), p1 (copy), Start (copy), v3 (ref) ]]
						local v1, v22 = v2.getMeshDecals(p1, Start)
						for v5, v6 in v1 do
							local v32, v4
							if typeof(v6) == "string" then
								v32 = p12
								v4 = v6
							else
								v4 = v6.Texture
								if v4 then
									v32 = p12
								else
									v32 = p12
									v4 = v6
								end
							end
							v32(v4)
						end
						for v7, v8 in v22 do
							local v9 = v3.getTexturePrefix(p1)
							for v10, v11 in v8 do
								p12((("%*%*"):format(v9, v11)))
							end
						end
					end, function(p1) --[[ Line: 104 | Upvalues: Start (copy) ]]
						return { Start.DescendantAdded:Connect(p1), Start.DescendantRemoving:Connect(p1) }
					end)
				end
			elseif p1:IsA("Beam") then
				createLoader(p1, function(p12) --[[ Line: 111 | Upvalues: p1 (copy), v3 (ref) ]]
					p12(p1.Texture)
					local v1 = v3.getFlipbookData(p1)
					if not v1 then
						return
					end
					local v2 = v3.getTexturePrefix(p1)
					for v32, v4 in v1 do
						p12((("%*%*"):format(v2, v4)))
					end
				end, function(p12) --[[ Line: 123 | Upvalues: p1 (copy) ]]
					return { p1:GetPropertyChangedSignal("Texture"):Connect(p12), p1.AttributeChanged:Connect(p12) }
				end)
			else
				createLoader(p1, function(p12) --[[ Line: 130 | Upvalues: p1 (copy) ]]
					local function check(p1) --[[ check | Line: 131 | Upvalues: p12 (copy) ]]
						if not p1:IsA("ParticleEmitter") then
							return
						end
						p12(p1.Texture)
					end
					local v1 = p1
					if v1:IsA("ParticleEmitter") then
						p12(v1.Texture)
					end
					for v2, v3 in p1:GetDescendants() do
						if v3:IsA("ParticleEmitter") then
							p12(v3.Texture)
						end
					end
				end, function(p12) --[[ Line: 142 | Upvalues: p1 (copy) ]]
					return { p1.DescendantAdded:Connect(p12), p1.DescendantRemoving:Connect(p12) }
				end)
			end
		end
		for v22, v32 in CollectionService:GetTagged(v2.TEXTURE_LOAD_TAG) do
			loadTextures(v32)
		end
		CollectionService:GetInstanceAddedSignal(v2.TEXTURE_LOAD_TAG):Connect(loadTextures)
		CollectionService:GetInstanceRemovedSignal(v2.TEXTURE_LOAD_TAG):Connect(function(p1) --[[ Line: 156 | Upvalues: t (copy), v2 (ref) ]]
			local v1 = t[p1]
			if not v1 then
				return
			end
			v2.cleanupScope(v1)
			t[p1] = nil
		end)
		local function f4() --[[ Line: 165 | Upvalues: v12 (copy), t (copy), v2 (ref) ]]
			v12:destroy()
			for v1, v22 in t do
				v2.cleanupScope(v22)
			end
		end
		table.insert(p1, f4)
	end
}