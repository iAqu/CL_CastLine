-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlotState = require(ReplicatedStorage.Client.PlotState)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

local function paintSubtree(p1, p2) -- line: 16
    for _, descendant in ipairs(p1:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p2 and 0 or 1
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = p2
        elseif not descendant:IsA("BillboardGui") or p2 then
            if descendant:IsA("BillboardGui") and descendant.Name ~= "CanUpgrade" then
                descendant.Enabled = true
            end
        else
            descendant.Enabled = false
        end
    end
end

function t1.Apply(p3, p4) -- line: 34
    -- upvalues: PlotState (copy), t (copy), paintSubtree (copy)
    t.strict(t.string)(p3)
    t.strict(t.optional(t.boolean))(p4)

    local v1 = PlotState.ResolveFolder()
    local v2 = PlotState.ResolveLocalSlot()
    local v3 = if v2 == nil then nil else tostring(v2)
    local v4 = if v1 == nil then {} else v1:GetDescendants()

    for _, v5 in v4 do
        local Parent = v5.Parent

        if v5.Name == p3 and Parent ~= nil then
            paintSubtree(v5, v3 ~= nil and Parent.Name == v3 and p4 ~= false)
        end
    end
end

return t1
