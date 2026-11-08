-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.interface({
    Name = t.string,
    DisplayName = t.string,
    Desc = t.string,
    Icon = t.string,
    ProductId = t.intersection(t.integer, t.numberPositive),
    Precheck = t.optional(t.callback)
})
local t1 = {}
local t2 = {}

for _, child in script.Configs:GetChildren() do
    if child:IsA("ModuleScript") then
        local v2 = require(child)
        local v3, v4 = v1(v2)

        if not v3 then
            error((("gamepass config %* is malformed: %*"):format(child.Name, v4)))
        end

        if v2.Name ~= child.Name then
            error((("gamepass config %* calls itself \"%*\""):format(child.Name, v2.Name)))
        end

        local v5 = t2[v2.ProductId]

        if v5 ~= nil then
            error((("gamepasses \"%*\" and \"%*\" share ProductId %*"):format(v5.Name, v2.Name, v2.ProductId)))
        end

        t1[v2.Name] = v2
        t2[v2.ProductId] = v2
    end
end

table.freeze(t1)
table.freeze(t2)

local t3 = {
    Directory = t1
}

function t3.FromProductId(p1) -- line: 59
    -- upvalues: t2 (copy)
    return t2[p1]
end

return table.freeze(t3)
