-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Util = require(script.Parent.Util)
local function unescapeOperators(p1) --[[ unescapeOperators | Line: 3 ]]
	for i, v in ipairs({ "%.", "%?", "%*", "%*%*" }) do
		p1 = p1:gsub("\\" .. v, v:gsub("%%", ""))
	end
	return p1
end
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 15 | Upvalues: Util (copy), t (copy) ]]
	local t2 = {
		Type = nil,
		Prefix = "",
		TextSegmentInProgress = "",
		RawSegmentsAreAutocomplete = false,
		Command = p1,
		Name = p2.Name,
		Object = p2
	}
	t2.Required = if p2.Default == nil then if p2.Optional == true then false else true else false
	t2.Executor = p1.Executor
	t2.RawValue = p3
	t2.RawSegments = {}
	t2.TransformedValues = {}
	if type(p2.Type) == "table" then
		t2.Type = p2.Type
	else
		local v2, v3, v4 = Util.ParsePrefixedUnionType(p1.Cmdr.Registry:GetTypeName(p2.Type), p3)
		t2.Type = p1.Dispatcher.Registry:GetType(v2)
		t2.RawValue = v3
		t2.Prefix = v4
		if t2.Type == nil then
			error(string.format("%s has an unregistered type %q", t2.Name or "<none>", v2 or "<none>"))
		end
	end
	setmetatable(t2, t)
	t2:Transform()
	return t2
end
function t.GetDefaultAutocomplete(p1) --[[ GetDefaultAutocomplete | Line: 55 ]]
	if p1.Type.Autocomplete then
		local v1, v2 = p1.Type.Autocomplete(p1:TransformSegment(""))
		return v1, if v2 then v2 else {}
	else
		return {}
	end
end
function t.Transform(p1) --[[ Transform | Line: 67 | Upvalues: unescapeOperators (copy), Util (copy) ]]
	if #p1.TransformedValues == 0 then
		local v1 = p1.RawValue and (p1.Type.ArgumentOperatorAliases[v1] or v1)
		if v1 == "." and p1.Type.Default then
			v1 = p1.Type.Default(p1.Executor) or ""
			p1.RawSegmentsAreAutocomplete = true
		end
		if v1 == "?" and p1.Type.Autocomplete then
			local v2, v3 = p1:GetDefaultAutocomplete()
			if not v3.IsPartial and #v2 > 0 then
				v1 = v2[math.random(1, #v2)]
				p1.RawSegmentsAreAutocomplete = true
			end
		end
		if p1.Type.Listable and #p1.RawValue > 0 then
			local v4 = v1:match("^%?(%d+)$")
			if v4 then
				local v5 = tonumber(v4)
				if v5 and v5 > 0 then
					local t = {}
					local v6, v7 = p1:GetDefaultAutocomplete()
					if not v7.IsPartial and #v6 > 0 then
						for i = 1, math.min(v5, #v6) do
							local remove = table.remove
							table.insert(t, remove(v6, math.random(1, #v6)))
						end
						local v8 = table.concat(t, ",")
						p1.RawSegmentsAreAutocomplete = true
						v1 = v8
					end
				end
			elseif v1 == "*" or v1 == "**" then
				local v9, v10 = p1:GetDefaultAutocomplete()
				if not v10.IsPartial and #v9 > 0 then
					if v1 == "**" and p1.Type.Default then
						local v11 = p1.Type.Default(p1.Executor) or ""
						for i, v in ipairs(v9) do
							if v == v11 then
								table.remove(v9, i)
							end
						end
					end
					local v12 = table.concat(v9, ",")
					p1.RawSegmentsAreAutocomplete = true
					v1 = v12
				end
			end
			local v13 = unescapeOperators(v1)
			local v14 = Util.SplitStringSimple(v13, ",")
			if #v14 == 0 then
				v14 = { "" }
			end
			if v13:sub(#v13, #v13) == "," then
				v14[#v14 + 1] = ""
			end
			for i, v in ipairs(v14) do
				p1.RawSegments[i] = v
				p1.TransformedValues[i] = { p1:TransformSegment(v) }
			end
			p1.TextSegmentInProgress = v14[#v14]
		else
			local v15 = unescapeOperators(v1)
			p1.RawSegments[1] = unescapeOperators(v15)
			p1.TransformedValues[1] = { p1:TransformSegment(v15) }
			p1.TextSegmentInProgress = p1.RawValue
		end
	end
end
function t.TransformSegment(p1, p2) --[[ TransformSegment | Line: 159 ]]
	if p1.Type.Transform then
		return p1.Type.Transform(p2, p1.Executor)
	else
		return p2
	end
end
function t.GetTransformedValue(p1, p2) --[[ GetTransformedValue | Line: 168 ]]
	return unpack(p1.TransformedValues[p2])
end
function t.Validate(p1, p2) --[[ Validate | Line: 173 ]]
	if p1.RawValue == nil or #p1.RawValue == 0 and p1.Required == false then
		return true
	elseif p1.Required and (p1.RawSegments[1] == nil or #p1.RawSegments[1] == 0) then
		return false, "This argument is required."
	else
		if p1.Type.Validate or p1.Type.ValidateOnce then
			for i = 1, #p1.TransformedValues do
				if p1.Type.Validate then
					local v1, v2 = p1.Type.Validate(p1:GetTransformedValue(i))
					if not v1 then
						return v1, v2 or "Invalid value"
					end
				end
				if p2 and p1.Type.ValidateOnce then
					local v3, v4 = p1.Type.ValidateOnce(p1:GetTransformedValue(i))
					if not v3 then
						return v3, v4
					end
				end
			end
		end
		return true
	end
end
function t.GetAutocomplete(p1) --[[ GetAutocomplete | Line: 208 ]]
	if p1.Type.Autocomplete then
		return p1.Type.Autocomplete(p1:GetTransformedValue(#p1.TransformedValues))
	else
		return {}
	end
end
function t.ParseValue(p1, p2) --[[ ParseValue | Line: 216 ]]
	if p1.Type.Parse then
		return p1.Type.Parse(p1:GetTransformedValue(p2))
	else
		return p1:GetTransformedValue(p2)
	end
end
function t.GetValue(p1) --[[ GetValue | Line: 225 ]]
	if #p1.RawValue == 0 and (not p1.Required and p1.Object.Default ~= nil) then
		return p1.Object.Default
	elseif p1.Type.Listable then
		local tbl = {}
		for i = 1, #p1.TransformedValues do
			local v1 = p1:ParseValue(i)
			if type(v1) ~= "table" then
				error(("Listable types must return a table from Parse (%s)"):format(p1.Type.Name))
			end
			for k, v in pairs(v1) do
				tbl[v] = true
			end
		end
		local t = {}
		for k in pairs(tbl) do
			t[#t + 1] = k
		end
		return t
	else
		return p1:ParseValue(1)
	end
end
return t