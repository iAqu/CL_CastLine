-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.instanceIsA("BasePart"))
local v2 = t.strict(t.string)
local t1 = {}

local function buttonWithin(p1, p2) -- line: 12
    local v3 = p1:FindFirstChild(p2, true)

    return if v3 and v3:IsA("GuiButton") then v3 else nil
end

function t1.Find(p3, p4) -- line: 17
    -- upvalues: v1 (copy), v2 (copy)
    v1(p3)
    v2(p4)

    local Children = p3:GetChildren()
    local n1 = 1
    local v4

    while v4 == nil and n1 <= #Children do
        local v5 = Children[n1]
        local v6

        if v5:IsA("SurfaceGui") then
            v6 = v5:FindFirstChild(p4, true)

            if not v6 or not v6:IsA("GuiButton") then
                v6 = nil
            end
        end

        v4 = v6
        n1 += 1
    end

    return v4
end

return t1
