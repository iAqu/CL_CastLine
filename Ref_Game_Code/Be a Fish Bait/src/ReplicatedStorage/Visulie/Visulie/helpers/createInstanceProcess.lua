-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.data.__typeHeader)

local v1 = table.freeze({
    dynamic = {},
    static = {}
})
local v2 = table.freeze({})

local function getNonGhostedStrips(p1) -- line: 29
    -- upvalues: v2 (copy)
    if not p1 then
        return v2
    end

    local t1 = {}

    for v3, v4 in p1 do
        if not v4.ghosted then
            t1[v3] = v4.data
        end
    end

    return t1
end

local function filterDynamicAndStatic(p2) -- line: 50
    -- upvalues: v1 (copy)
    if not p2 then
        return v1
    end

    local t2 = {
        dynamic = {},
        static = {}
    }

    for v5, v6 in p2 do
        if not v6.ghosted then
            if v6.data[2] then
                t2.dynamic[v5] = v6.data
            else
                t2.static[v5] = v6.data[1]
            end
        end
    end

    return t2
end

return function(p3, p4, p5, p6) -- line: 81
    -- upvalues: getNonGhostedStrips (copy), filterDynamicAndStatic (copy)
    return {
        id = p3,
        TargetInstance = p4,
        Parent = p5,
        isTargetPVI = p4:IsA("PVInstance"),
        isParentPVI = if p5 then p5:IsA("PVInstance") else false,
        properties = filterDynamicAndStatic(p6.properties[p3]),
        attributes = filterDynamicAndStatic(p6.attributes[p3]),
        tags = filterDynamicAndStatic(p6.tags[p3]),
        methods = getNonGhostedStrips(p6.methods[p3])
    }
end
