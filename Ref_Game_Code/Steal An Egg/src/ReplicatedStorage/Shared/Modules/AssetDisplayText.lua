-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ["\""] = "&quot;"
}
local t2 = {}

local function escape(p1) -- line: 21
    -- upvalues: t1 (copy)
    return (p1:gsub("[&<>\"]", t1))
end

local function colourRun(p2) -- line: 23
    -- upvalues: Mutations (copy), t1 (copy)
    local v1 = Mutations.Get(p2)

    return v1 and ("<font color=\"#%*\">%*</font>"):format(v1.Tint:ToHex(), (v1.Label:gsub("[&<>\"]", t1)))
end

function t2.IsDroppable(p3) -- line: 28
    -- upvalues: Mutations (copy)
    if typeof(p3) ~= "string" or p3 == "" then
        return false
    end

    return Mutations.RollChanceOf(p3) > 0
end

function t2.FirstDroppable(p4, p5) -- line: 34
    -- upvalues: t2 (copy)
    local v2 = if typeof(p5) == "table" then p5 else {}

    for i = 0, #v2 do
        local v3 = if i == 0 then p4 else v2[i]

        if t2.IsDroppable(v3) then
            return v3
        end
    end

    return nil
end

function t2.Compose(p6, p7, p8) -- line: 49
    -- upvalues: Mutations (copy)
    local v4 = Mutations.Sanitize(p7, p8)
    local v5 = table.create(#v4)

    for v6, v7 in ipairs(v4) do
        v5[v6] = Mutations.LabelOf(v7)
    end

    if #v4 == 0 then
        return p6
    end

    return (("%* %*"):format(table.concat(v5, " + "), p6))
end

function t2.WithMass(p9, p10, p11, p12) -- line: 60
    -- upvalues: t2 (copy)
    return string.format("%s (%.2f kg)", t2.Compose(p9, p10, p11), p12)
end

function t2.ForRecord(p13) -- line: 64
    -- upvalues: Assets (copy), AssetItem (copy), t2 (copy)
    assert(AssetItem.AssetItemData(p13))

    local v8 = Assets.Directory[p13.Category].DisplayName or "Unknown"

    return t2.Compose(v8, p13.Mutations, p13.BaseMutation)
end

function t2.MutationRun(p14, p15) -- line: 73
    -- upvalues: Mutations (copy), t (copy), t1 (copy)
    t.strict(t.table)(p14)
    t.strict(t.optional(t.string))(p15)

    local t3 = {}

    for _, v9 in Mutations.Sanitize(p14, p15) do
        local v10 = #t3 + 1
        local v11 = Mutations.Get(v9)

        t3[v10] = v11 and ("<font color=\"#%*\">%*</font>"):format(v11.Tint:ToHex(), (v11.Label:gsub("[&<>\"]", t1)))
    end

    return if #t3 ~= 0 then table.concat(t3, ", ") else nil
end

return t2
