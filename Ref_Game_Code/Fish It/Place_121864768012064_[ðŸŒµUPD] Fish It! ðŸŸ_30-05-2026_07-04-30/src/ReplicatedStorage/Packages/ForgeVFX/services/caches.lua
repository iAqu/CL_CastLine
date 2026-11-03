-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("../obj/ObjectCache")
local v2 = require("../mod/utility")
return {
	init = function(p1) --[[ init | Line: 7 | Upvalues: v2 (copy), v1 (copy) ]]
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
		v2.protectParent(p1, DO_NOT_REMOVE_ForgeSharedPartCache)
		local v12 = v1.new(Part, DO_NOT_REMOVE_ForgeSharedPartCache, {
			size = 150,
			on_free = function(p1) --[[ on_free | Line: 27 | Upvalues: DO_NOT_REMOVE_ForgeSharedPartCache (copy) ]]
				local value = p1.value
				value.Transparency = 1
				value.Anchored = true
				value.CanQuery = false
				value.CanCollide = false
				value.CollisionGroup = "ForgeMouseIgnore"
				value.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				value.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				value.Parent = DO_NOT_REMOVE_ForgeSharedPartCache
				value:ClearAllChildren()
			end
		})
		local t = {
			shared_part = v12
		}
		local function f2() --[[ Line: 55 | Upvalues: v12 (ref) ]]
			v12:destroy()
		end
		table.insert(p1, f2)
		return t
	end
}