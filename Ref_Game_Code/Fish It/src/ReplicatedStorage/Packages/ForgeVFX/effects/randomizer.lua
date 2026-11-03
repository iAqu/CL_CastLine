-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("../mod/attributes")
local v2 = require("../mod/lerp")
local v3 = require("../mod/tween")
require("../types")
local v4 = require("../mod/utility")
local v5 = require("../obj/Bezier")
local v6 = Random.new()
local t = {}
local function getBezier(p1) --[[ getBezier | Line: 14 | Upvalues: v3 (copy), v4 (copy), v5 (copy) ]]
	local v1 = v3.bezier_cache[p1]
	if not v1 then
		local v2, v32 = pcall(function() --[[ Line: 18 | Upvalues: v4 (ref), p1 (copy) ]]
			return v4.deserializePath(p1)
		end)
		if not v2 then
			return nil
		end
		local v42 = v5.new(v32, 0)
		v3.bezier_cache[p1] = v42
		v1 = v42
	end
	return v1
end
local function sampleWeighted(p1) --[[ sampleWeighted | Line: 33 | Upvalues: v6 (copy) ]]
	return 1 - p1:getEase((v6:NextNumber())).y
end
function t.emit(p1, p2, p3) --[[ emit | Line: 40 | Upvalues: v4 (copy), v1 (copy), getBezier (copy), v2 (copy), v6 (copy) ]]
	local v12 = v4.getTarget(p1)
	if not v12 then
		return
	end
	local v22 = p1.Name
	local v3 = v1.get(p1, "_START_VALUE", nil)
	local v42 = v1.get(p1, "_END_VALUE", nil)
	if v3 == nil or v42 == nil then
		return
	end
	local v5 = typeof(v3)
	if v5 ~= typeof(v42) then
		return
	end
	local v62 = getBezier((v1.get(p1, "Weight_Curve", v4.linear_bezier)))
	if not v62 then
		return
	end
	local v7
	if p3 then
		v7 = v1.get(v12, v22, nil)
	else
		local v8, v9 = pcall(function() --[[ Line: 74 | Upvalues: v12 (copy), v22 (copy) ]]
			return v12[v22]
		end)
		if v8 then
			v7 = v9
		end
	end
	local v11 = (v2[v5] or v2.Other)(v3, v42, 1 - v62:getEase((v6:NextNumber())).y)
	local v122 = v1.get(p1, "ResetOnFinish", true)
	if p3 then
		v1.set(v12, v22, v11)
	else
		v12[v22] = v11
	end
	if v122 then
		task.defer(function() --[[ Line: 100 | Upvalues: p3 (copy), v1 (ref), v12 (copy), v22 (copy), v7 (ref) ]]
			if p3 then
				v1.set(v12, v22, v7)
			else
				v12[v22] = v7
			end
		end)
	end
end
return t