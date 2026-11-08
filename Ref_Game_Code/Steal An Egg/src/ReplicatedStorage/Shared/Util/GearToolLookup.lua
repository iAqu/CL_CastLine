-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local GearTools = ReplicatedStorage.GearTools
local v1 = table.freeze({})
local v2 = t.strict(t.string)

local function toolNamed(p1, p2) -- line: 16
    return if p1 ~= nil and p1.Name == p2 and p1:IsA("Tool") then p1 else nil
end

return function(p3) -- line: 21
    -- upvalues: GearTools (copy), v1 (copy), v2 (copy)
    v2(p3)

    local v3 = GearTools:FindFirstChild(p3, true)

    if not (v3 ~= nil and v3.Name == p3 and v3:IsA("Tool")) then
        v3 = nil
    end

    local v4 = if v3 == nil then GearTools:GetDescendants() else v1

    for _, v5 in v4 do
        if not v3 then
            v3 = if v5 ~= nil and v5.Name == p3 and v5:IsA("Tool") then v5 else nil
        end
    end

    return v3
end
