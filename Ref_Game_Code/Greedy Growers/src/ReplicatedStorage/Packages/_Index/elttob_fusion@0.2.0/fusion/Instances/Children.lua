-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local logWarn = require(v1.Logging.logWarn)
local Observer = require(v1.State.Observer)
local xtypeof = require(v1.Utility.xtypeof)

return {
	type = "SpecialKey",
	kind = "Children",
	stage = "descendants",
	apply = function(p1, p2, p3, p4) --[[ apply | Line: 24 | Upvalues: xtypeof (copy), Observer (copy), logWarn (copy) ]]
		local t = {}
		local t2 = {}
		local t3 = {}
		local t4 = {}
		local v1 = false
		local v2 = nil

		local function updateChildren() --[[ updateChildren | Line: 38 | Upvalues: v1 (ref), t2 (ref), t (ref), t4 (ref), t3 (ref), xtypeof (ref), p3 (copy), Observer (ref), v2 (ref), logWarn (ref), p2 (ref) ]]
			if not v1 then
				return
			end

			v1 = false

			local v12 = t2

			t2 = t
			t = v12

			local v22 = t4

			t4 = t3
			t3 = v22
			table.clear(t)
			table.clear(t3)

			local function v3(p1, p2) --[[ processChild | Line: 49 | Upvalues: xtypeof (ref), t (ref), t2 (ref), p3 (ref), v3 (copy), t4 (ref), Observer (ref), v2 (ref), t3 (ref), logWarn (ref) ]]
				local v1 = xtypeof(p1)

				if v1 == "Instance" then
					t[p1] = true

					if t2[p1] == nil then
						p1.Parent = p3
					else
						t2[p1] = nil
					end
				elseif v1 == "State" then
					local v22 = p1:get(false)

					if v22 ~= nil then
						v3(v22, p2)
					end

					local v32 = t4[p1]

					if v32 == nil then
						v32 = Observer(p1):onChange(v2)
					else
						t4[p1] = nil
					end

					t3[p1] = v32
				else
					if v1 ~= "table" then
						logWarn("unrecognisedChildType", v1)

						return
					end

					for k, v in pairs(p1) do
						local v5 = typeof(k)
						local v6 = nil

						if v5 == "string" then
							v6 = k
						elseif v5 == "number" and p2 ~= nil then
							v6 = p2 .. "_" .. k
						end

						v3(v, v6)
					end
				end
			end

			if p2 ~= nil then
				v3(p2)
			end

			for k in pairs(t2) do
				k.Parent = nil
			end

			for k, v in pairs(t4) do
				v()
			end
		end

		v2 = function() --[[ Line: 130 | Upvalues: v1 (ref), updateChildren (copy) ]]
			if v1 then
				return
			end

			v1 = true
			task.defer(updateChildren)
		end

		local function f3() --[[ Line: 137 | Upvalues: p2 (ref), v1 (ref), updateChildren (copy) ]]
			p2 = nil
			v1 = true
			updateChildren()
		end

		table.insert(p4, f3)
		v1 = true
		updateChildren()
	end
}