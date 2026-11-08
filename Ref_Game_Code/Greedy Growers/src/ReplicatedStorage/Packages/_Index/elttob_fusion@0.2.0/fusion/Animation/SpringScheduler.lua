-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = script.Parent.Parent

require(v1.Types)

local packType = require(v1.Animation.packType)
local springCoefficients = require(v1.Animation.springCoefficients)
local updateAll = require(v1.Dependencies.updateAll)
local t = {}
local t2 = {}
local v2 = os.clock()

function t.add(p1) --[[ add | Line: 24 | Upvalues: v2 (ref), t2 (copy) ]]
	p1._lastSchedule = v2
	p1._startDisplacements = {}
	p1._startVelocities = {}

	for i, v in ipairs(p1._springGoals) do
		p1._startDisplacements[i] = p1._springPositions[i] - v
		p1._startVelocities[i] = p1._springVelocities[i]
	end

	t2[p1] = true
end
function t.remove(p1) --[[ remove | Line: 39 | Upvalues: t2 (copy) ]]
	t2[p1] = nil
end

local function updateAllSprings() --[[ updateAllSprings | Line: 44 | Upvalues: v2 (ref), t2 (copy), springCoefficients (copy), packType (copy), updateAll (copy) ]]
	local tbl = {}

	v2 = os.clock()

	for k in pairs(t2) do
		local v1, v22, v3, v4 = springCoefficients(v2 - k._lastSchedule, k._currentDamping, k._currentSpeed)
		local _springPositions = k._springPositions
		local _springVelocities = k._springVelocities
		local _startDisplacements = k._startDisplacements
		local _startVelocities = k._startVelocities
		local v5 = false

		for i, v in ipairs(k._springGoals) do
			local v6 = _startDisplacements[i]
			local v7 = _startVelocities[i]
			local v8 = v6 * v1 + v7 * v22
			local v9 = v6 * v3 + v7 * v4

			if math.abs(v8) > 0.0001 or math.abs(v9) > 0.0001 then
				v5 = true
			end

			_springPositions[i] = v8 + v
			_springVelocities[i] = v9
		end

		if not v5 then
			tbl[k] = true
		end
	end

	for k in pairs(t2) do
		k._currentValue = packType(k._springPositions, k._currentType)
		updateAll(k)
	end

	for k in pairs(tbl) do
		t2[k] = nil
	end
end

RunService:BindToRenderStep("__FusionSpringScheduler", Enum.RenderPriority.First.Value, updateAllSprings)

return t