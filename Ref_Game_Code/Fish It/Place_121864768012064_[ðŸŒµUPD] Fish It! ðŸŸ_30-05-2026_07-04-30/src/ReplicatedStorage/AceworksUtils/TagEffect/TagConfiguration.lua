-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Disk = require(ReplicatedStorage:WaitForChild("AceworksUtils"):WaitForChild("Disk"))
local Teardown = require(ReplicatedStorage:WaitForChild("AceworksUtils"):WaitForChild("Teardown"))
local createTagEffect = require(script.Parent:WaitForChild("createTagEffect"))
local validation = require(script.Parent:WaitForChild("validation"))
local Array = Disk.Array
local Map = Disk.Map
local t = {}
local t2 = {
	__index = t
}
local function new(p1) --[[ new | Line: 49 | Upvalues: t2 (copy) ]]
	return setmetatable(p1, t2)
end
function t.new() --[[ new | Line: 53 | Upvalues: t2 (copy) ]]
	return setmetatable({
		_useParent = false,
		_defaultConfig = nil,
		_validClasses = {},
		_ignoreDescendantOf = {},
		_includeDescendantOf = {}
	}, t2)
end
function t.targetParent(p1) --[[ targetParent | Line: 65 | Upvalues: t2 (copy) ]]
	if p1._useParent then
		return p1
	else
		local v1 = table.clone(p1)
		v1._useParent = true
		return setmetatable(v1, t2)
	end
end
function t.withDefaultConfig(p1, p2, p3) --[[ withDefaultConfig | Line: 76 | Upvalues: t2 (copy) ]]
	local v1 = table.clone(p1)
	v1._defaultConfig = p2
	v1._configSchema = p3
	return setmetatable(v1, t2)
end
function t.withValidClass(p1, ...) --[[ withValidClass | Line: 87 | Upvalues: Array (copy), t2 (copy) ]]
	local v1 = table.clone(p1)
	v1._validClasses = Array.push(v1._validClasses, ...)
	return setmetatable(v1, t2)
end
function t.ignoreDescendantOf(p1, ...) --[[ ignoreDescendantOf | Line: 94 | Upvalues: Array (copy), t2 (copy) ]]
	local v1 = table.clone(p1)
	v1._ignoreDescendantOf = Array.push(v1._ignoreDescendantOf, ...)
	return setmetatable(v1, t2)
end
function t.includeDescendantOf(p1, ...) --[[ includeDescendantOf | Line: 101 | Upvalues: Array (copy), t2 (copy) ]]
	local v1 = table.clone(p1)
	v1._includeDescendantOf = Array.push(v1._includeDescendantOf, ...)
	return setmetatable(v1, t2)
end
function t.effect(p1, p2, p3) --[[ effect | Line: 108 | Upvalues: Array (copy), validation (copy), createTagEffect (copy), Teardown (copy), Map (copy) ]]
	local _useParent = p1._useParent
	local _defaultConfig = p1._defaultConfig
	local _configSchema = p1._configSchema
	local v1 = Array.deduplicate(p1._validClasses)
	local v2 = Array.deduplicate(p1._ignoreDescendantOf)
	local v3 = Array.deduplicate(p1._includeDescendantOf)
	local v4 = if #v3 > 0 then true else false
	local v5 = if #v1 > 0 then function(p1) --[[ validateClasses | Line: 121 | Upvalues: validation (ref), v1 (copy), p2 (copy) ]]
	if validation.verifyInstanceClass(p1, v1) then
		return true
	end
	if not _G.DEV then
		return false
	end
	warn(validation.formatInvalidTagClassMessage(p2, p1, v1))
	return false
end else nil
	return createTagEffect(p2, function(p1) --[[ Line: 132 | Upvalues: Array (ref), v2 (copy), v4 (copy), v3 (copy), _defaultConfig (copy), _useParent (copy), Teardown (ref), v5 (ref), p3 (copy), Map (ref), _configSchema (copy), validation (ref), p2 (copy) ]]
		if Array.any(v2, function(p12) --[[ Line: 134 | Upvalues: p1 (copy) ]]
			return p1:IsDescendantOf(p12)
		end) then
			return nil
		end
		if v4 and not Array.any(v3, function(p12) --[[ Line: 142 | Upvalues: p1 (copy) ]]
			return p1:IsDescendantOf(p12)
		end) then
			return nil
		end
		if _defaultConfig ~= nil then
			local v1 = nil
			local function v22() --[[ refresh | Line: 185 | Upvalues: Teardown (ref), v1 (ref), _useParent (ref), p1 (copy), v5 (ref), v22 (copy), Array (ref), Map (ref), _defaultConfig (ref), _configSchema (ref), validation (ref), p2 (ref), p3 (ref) ]]
				Teardown.teardown(v1)
				v1 = nil
				local v12 = if _useParent then p1.Parent else p1
				if v12 == nil or (not v5 or v5(v12)) then
					local v2 = p1:GetAttributes()
					local v4 = Array.filter(p1:GetChildren(), function(p1) --[[ Line: 201 ]]
						return if p1.ClassName == "ObjectValue" then p1:HasTag("ObjectAttribute") else false
					end)
					for v52, v6 in v4 do
						v2[v6.Name] = v6.Value
					end
					local v7 = Map.merge(_defaultConfig, v2)
					if _G.DEV and _configSchema ~= nil then
						for v8, v9 in _configSchema do
							local v10 = v7[v8]
							if not validation.validateType(v10, v9) then
								if v10 == nil then
									warn(("missing \'%*\' configuration on \'%*\'"):format(v8, (p1:GetFullName())) .. (" for \'%*\' tag"):format(p2))
								else
									warn(("invalid \'%*\' configuration on \'%*\' for"):format(v8, (p1:GetFullName())) .. (" \'%*\' tag, %* value expected but received "):format(p2, v9) .. ("%* value (%*)"):format(validation.getDisplayType(v10), (tostring(v10))))
								end
								return
							end
						end
					end
					local t = {}
					local v11 = p1.AttributeChanged:Connect(v22)
					local v122 = p1.ChildAdded:Connect(function(p1) --[[ Line: 237 | Upvalues: v22 (ref), t (ref) ]]
						if p1.ClassName ~= "ObjectValue" then
							return
						end
						if p1:HasTag("ObjectAttribute") then
							v22()
							return
						end
						t[p1] = p1:GetAttributeChangedSignal("ObjectAttribute"):Connect(v22)
					end)
					local v13 = p1.ChildRemoved:Connect(function(p1) --[[ Line: 248 | Upvalues: t (ref) ]]
						local v1 = t[p1]
						if not v1 then
							return
						end
						t[p1] = nil
						v1:Disconnect()
					end)
					local function f14() --[[ Line: 255 | Upvalues: t (ref) ]]
						for v1, v2 in t do
							v2:Disconnect()
						end
						t = {}
					end
					local v15 = Array.map(v4, function(p1) --[[ Line: 261 | Upvalues: v22 (ref) ]]
						return p1.Changed:Connect(v22)
					end)
					local v16 = if _useParent then p1:GetPropertyChangedSignal("Parent"):Connect(v22) else nil
					v1 = Teardown.join(v11, v122, v13, f14, v15, v16, if v12 == nil then nil else p3(v12, v7, p1))
				else
					if not _useParent then
						return
					end
					v1 = p1:GetPropertyChangedSignal("Parent"):Connect(v22)
				end
			end
			v22()
			return function() --[[ Line: 273 | Upvalues: Teardown (ref), v1 (ref) ]]
				Teardown.teardown(v1)
			end
		end
		if _useParent then
			local v32 = nil
			local function v42() --[[ refresh | Line: 153 | Upvalues: Teardown (ref), v32 (ref), _useParent (ref), p1 (copy), v5 (ref), v42 (copy), p3 (ref) ]]
				Teardown.teardown(v32)
				v32 = nil
				local v1 = if _useParent then p1.Parent else p1
				if v1 == nil or (not v5 or v5(v1)) then
					local v2 = p1:GetPropertyChangedSignal("Parent"):Connect(v42)
					v32 = Teardown.join(v2, if v1 == nil then nil else p3(v1, nil, p1))
				else
					if not _useParent then
						return
					end
					v32 = p1:GetPropertyChangedSignal("Parent"):Connect(v42)
				end
			end
			v42()
			return function() --[[ Line: 175 | Upvalues: Teardown (ref), v32 (ref) ]]
				Teardown.teardown(v32)
			end
		else
			return p3(p1)
		end
	end)
end
return t