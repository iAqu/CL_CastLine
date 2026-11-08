-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local t = {
	Order = { "None", "Basic", "Better", "Premium", "Super", "Magic" },
	Fertilizers = {
		None = {
			displayName = "None",
			mult = 1,
			costMult = 0,
			rebirthReq = 0
		},
		Basic = {
			displayName = "Basic",
			mult = 1.5,
			costMult = 0.25,
			rebirthReq = 1
		},
		Better = {
			displayName = "Better",
			mult = 2,
			costMult = 0.5,
			rebirthReq = 2
		},
		Premium = {
			displayName = "Premium",
			mult = 2.75,
			costMult = 1.375,
			rebirthReq = 3
		},
		Super = {
			displayName = "Super",
			mult = 3.75,
			costMult = 1.875,
			rebirthReq = 4
		},
		Magic = {
			displayName = "Magic",
			mult = 5,
			costMult = 2.5,
			rebirthReq = 5
		}
	}
}

function t.Get(p1) --[[ Get | Line: 25 | Upvalues: t (copy) ]]
	return t.Fertilizers[p1]
end
function t.GetMult(p1) --[[ GetMult | Line: 29 | Upvalues: t (copy) ]]
	local v1 = t.Fertilizers[p1]

	return if v1 then v1.mult or 1 else 1
end
function t.IsUnlocked(p1, p2) --[[ IsUnlocked | Line: 34 | Upvalues: t (copy) ]]
	local v1 = t.Fertilizers[p1]

	if not v1 then
		return false
	end

	return (p2 or 0) >= v1.rebirthReq
end
t.SeedValueOverride = {
	Oak = 5
}
function t.GetSeedValue(p1, p2) --[[ GetSeedValue | Line: 45 | Upvalues: t (copy) ]]
	local v1 = t.SeedValueOverride[p1]

	if v1 then
		return v1
	end

	return p2 or 0
end
function t.GetCost(p1, p2, p3) --[[ GetCost | Line: 53 | Upvalues: t (copy) ]]
	local v1 = t.Fertilizers[p1]

	if not v1 or p1 == "None" then
		return 0
	end

	if p1 == "Basic" and p3 == "Oak" then
		return 0
	end

	return math.floor(v1.costMult * (p2 or 0))
end
function t.ApplyOverrides(p1) --[[ ApplyOverrides | Line: 62 | Upvalues: t (copy) ]]
	if type(p1) ~= "table" then
		return
	end

	for v1, v2 in p1 do
		local v3 = t.Fertilizers[v1]

		if v3 and type(v2) == "table" then
			local v4 = tonumber(v2.mult)

			if v4 and v4 > 0 then
				v3.mult = v4
			end

			local v5 = tonumber(v2.costMult)

			if v5 and v5 >= 0 then
				v3.costMult = v5
			end

			local v6 = tonumber(v2.rebirthReq)

			if v6 and v6 >= 0 then
				v3.rebirthReq = math.floor(v6)
			end
		end
	end
end

return t