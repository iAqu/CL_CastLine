-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Util)

local function unescapeOperators(p1) -- line: 3
    for _, v2 in ipairs({ "%.", "%?", "%*", "%*%*" }) do
        p1 = p1:gsub("\\" .. v2, v2:gsub("%%", ""))
    end

    return p1
end

local t1 = {}

t1.__index = t1

function t1.new(p2, p3, p4) -- line: 15
    -- upvalues: Util (copy), t1 (copy)
    local t2 = {
        Type = nil,
        Prefix = "",
        TextSegmentInProgress = "",
        RawSegmentsAreAutocomplete = false,
        Command = p2,
        Name = p3.Name,
        Object = p3,
        Required = p3.Default == nil and p3.Optional ~= true,
        Executor = p2.Executor,
        RawValue = p4,
        RawSegments = {},
        TransformedValues = {}
    }

    if type(p3.Type) == "table" then
        t2.Type = p3.Type
    else
        local v3, v4, v5 = Util.ParsePrefixedUnionType(p2.Cmdr.Registry:GetTypeName(p3.Type), p4)

        t2.Type = p2.Dispatcher.Registry:GetType(v3)
        t2.RawValue = v4
        t2.Prefix = v5

        if t2.Type == nil then
            error(string.format("%s has an unregistered type %q", t2.Name or "<none>", v3 or "<none>"))
        end
    end

    setmetatable(t2, t1)
    t2:Transform()

    return t2
end

function t1.GetDefaultAutocomplete(p5) -- line: 55
    if not p5.Type.Autocomplete then
        return {}
    end

    local v6, v7 = p5.Type.Autocomplete(p5:TransformSegment(""))

    return v6, v7 or {}
end

function t1.Transform(p6) -- line: 67
    -- upvalues: Util (copy), unescapeOperators (copy)
    if #p6.TransformedValues ~= 0 then
        return
    end

    local RawValue = p6.RawValue

    if p6.Type.ArgumentOperatorAliases then
        RawValue = p6.Type.ArgumentOperatorAliases[RawValue] or RawValue
    end

    if RawValue == "." and p6.Type.Default then
        RawValue = p6.Type.Default(p6.Executor) or ""
        p6.RawSegmentsAreAutocomplete = true
    end

    if RawValue == "?" and p6.Type.Autocomplete then
        local DefaultAutocomplete, DefaultAutocomplete2 = p6:GetDefaultAutocomplete()

        if not DefaultAutocomplete2.IsPartial and #DefaultAutocomplete > 0 then
            RawValue = DefaultAutocomplete[math.random(1, #DefaultAutocomplete)]
            p6.RawSegmentsAreAutocomplete = true
        end
    end

    if not (p6.Type.Listable and #p6.RawValue > 0) then
        local v8 = unescapeOperators(RawValue)

        p6.RawSegments[1] = unescapeOperators(v8)
        p6.TransformedValues[1] = { p6:TransformSegment(v8) }
        p6.TextSegmentInProgress = p6.RawValue
    else
        local v9 = RawValue:match("^%?(%d+)$")

        if v9 then
            local v10 = tonumber(v9)

            if v10 and v10 > 0 then
                local t3 = {}
                local DefaultAutocomplete, DefaultAutocomplete2 = p6:GetDefaultAutocomplete()

                if not DefaultAutocomplete2.IsPartial and #DefaultAutocomplete > 0 then
                    for _ = 1, math.min(v10, #DefaultAutocomplete) do
                        table.insert(t3, table.remove(DefaultAutocomplete, math.random(1, #DefaultAutocomplete)))
                    end

                    RawValue = table.concat(t3, ",")
                    p6.RawSegmentsAreAutocomplete = true
                end
            end
        elseif RawValue == "*" or RawValue == "**" then
            local DefaultAutocomplete, DefaultAutocomplete2 = p6:GetDefaultAutocomplete()

            if not DefaultAutocomplete2.IsPartial and #DefaultAutocomplete > 0 then
                if RawValue == "**" and p6.Type.Default then
                    local v13 = p6.Type.Default(p6.Executor) or ""

                    for v14, v15 in ipairs(DefaultAutocomplete) do
                        if v15 == v13 then
                            table.remove(DefaultAutocomplete, v14)
                        end
                    end
                end

                RawValue = table.concat(DefaultAutocomplete, ",")
                p6.RawSegmentsAreAutocomplete = true
            end
        end

        local v16 = unescapeOperators(RawValue)
        local v17 = Util.SplitStringSimple(v16, ",")

        if #v17 == 0 then
            v17 = { "" }
        end

        if v16:sub(#v16, #v16) == "," then
            v17[#v17 + 1] = ""
        end

        for v18, v19 in ipairs(v17) do
            p6.RawSegments[v18] = v19
            p6.TransformedValues[v18] = { p6:TransformSegment(v19) }
        end

        p6.TextSegmentInProgress = v17[#v17]
    end
end

function t1.TransformSegment(p7, p8) -- line: 159
    if p7.Type.Transform then
        return p7.Type.Transform(p8, p7.Executor)
    end

    return p8
end

function t1.GetTransformedValue(p9, p10) -- line: 168
    return unpack(p9.TransformedValues[p10])
end

function t1.Validate(p11, p12) -- line: 173
    if p11.RawValue == nil or #p11.RawValue == 0 and p11.Required == false then
        return true
    end

    if p11.Required and (p11.RawSegments[1] == nil or #p11.RawSegments[1] == 0) then
        return false, "This argument is required."
    end

    if p11.Type.Validate or p11.Type.ValidateOnce then
        for i = 1, #p11.TransformedValues do
            local Validate = p11.Type.Validate
            local v21, v22

            if Validate then
                v21, v22 = p11.Type.Validate(p11:GetTransformedValue(i))
            end

            if Validate and not v21 then
                return v21, v22 or "Invalid value"
            end

            if p12 and p11.Type.ValidateOnce then
                local v23, v24 = p11.Type.ValidateOnce(p11:GetTransformedValue(i))

                if not v23 then
                    return v23, v24
                end
            end
        end
    end

    return true
end

function t1.GetAutocomplete(p13) -- line: 208
    if p13.Type.Autocomplete then
        return p13.Type.Autocomplete(p13:GetTransformedValue(#p13.TransformedValues))
    end

    return {}
end

function t1.ParseValue(p14, p15) -- line: 216
    if p14.Type.Parse then
        return p14.Type.Parse(p14:GetTransformedValue(p15))
    end

    return p14:GetTransformedValue(p15)
end

function t1.GetValue(p16) -- line: 225
    if #p16.RawValue == 0 and not p16.Required and p16.Object.Default ~= nil then
        return p16.Object.Default
    end

    if not p16.Type.Listable then
        return p16:ParseValue(1)
    end

    local t4 = {}

    for i = 1, #p16.TransformedValues do
        local v25 = p16:ParseValue(i)

        if type(v25) ~= "table" then
            error(("Listable types must return a table from Parse (%s)"):format(p16.Type.Name))
        end

        for _, v26 in pairs(v25) do
            t4[v26] = true
        end
    end

    local t5 = {}

    for v27 in pairs(t4) do
        t5[#t5 + 1] = v27
    end

    return t5
end

return t1
