-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.Types)

local captureDependencies = require(v1.Dependencies.captureDependencies)
local initDependency = require(v1.Dependencies.initDependency)
local useDependency = require(v1.Dependencies.useDependency)
local logErrorNonFatal = require(v1.Logging.logErrorNonFatal)
local logWarn = require(v1.Logging.logWarn)
local isSimilar = require(v1.Utility.isSimilar)
local needsDestruction = require(v1.Utility.needsDestruction)
local t = {}
local t2 = {
	__index = t
}
local t3 = {
	__mode = "k"
}

function t.get(p1, p2) --[[ get | Line: 28 | Upvalues: useDependency (copy) ]]
	if p2 ~= false then
		useDependency(p1)
	end

	return p1._value
end
function t.update(p1) --[[ update | Line: 39 | Upvalues: captureDependencies (copy), needsDestruction (copy), logWarn (copy), isSimilar (copy), logErrorNonFatal (copy) ]]
	for k in pairs(p1.dependencySet) do
		k.dependentSet[p1] = nil
	end

	local _oldDependencySet = p1._oldDependencySet

	p1._oldDependencySet = p1.dependencySet
	p1.dependencySet = _oldDependencySet
	table.clear(p1.dependencySet)

	local v1, v2, v3 = captureDependencies(p1.dependencySet, p1._processor)

	if v1 then
		if p1._destructor == nil and needsDestruction(v2) then
			logWarn("destructorNeededComputed")
		end

		if v3 ~= nil then
			logWarn("multiReturnComputed")
		end

		local _value = p1._value
		local v4 = isSimilar(_value, v2)

		if p1._destructor ~= nil then
			p1._destructor(_value)
		end

		p1._value = v2

		for k in pairs(p1.dependencySet) do
			k.dependentSet[p1] = true
		end

		return not v4
	end

	logErrorNonFatal("computedCallbackError", v2)

	local _oldDependencySet2 = p1._oldDependencySet

	p1._oldDependencySet = p1.dependencySet
	p1.dependencySet = _oldDependencySet2

	for k in pairs(p1.dependencySet) do
		k.dependentSet[p1] = true
	end

	return false
end

return function(p1, p2) --[[ Computed | Line: 93 | Upvalues: t3 (copy), t2 (copy), initDependency (copy) ]]
	local t = {
		type = "State",
		kind = "Computed",
		_value = nil,
		dependencySet = {}
	}

	t.dependentSet = setmetatable({}, t3)
	t._oldDependencySet = {}
	t._processor = p1
	t._destructor = p2

	local v3 = setmetatable(t, t2)

	initDependency(v3)
	v3:update()

	return v3
end