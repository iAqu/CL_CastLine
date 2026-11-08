-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

require(ReplicatedStorage.Packages.Trove)

local v1 = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local self = setmetatable({}, {
    __mode = "k"
})
local t3 = {}

local function isWater(p1) -- line: 25
    if not p1:IsA("BasePart") then
        return false
    end

    if p1.Material == Enum.Material.Water then
        return true
    end

    return p1:GetAttribute("TerrainRole") == "Basin"
end

local function propertyOf(p2) -- line: 33
    if p2:IsA("BasePart") then
        if p2:IsA("BasePart") and (p2.Material == Enum.Material.Water or p2:GetAttribute("TerrainRole") == "Basin") then
            return "Color"
        end
    elseif p2:IsA("Decal") then
        local Parent = p2.Parent

        if Parent ~= nil and Parent:IsA("BasePart") and (Parent.Material == Enum.Material.Water or Parent:GetAttribute("TerrainRole") == "Basin") then
            return "Color3"
        end
    end

    return nil
end

local function originalOf(p3, p4) -- line: 44
    -- upvalues: self (copy)
    local v3 = self[p3]

    if v3 == nil then
        v3 = p3[p4]
        self[p3] = v3
    end

    return v3
end

local function shade(p5, p6) -- line: 53
    local v4, v5, v6 = p6:ToHSV()
    local _, _, v7 = p5:ToHSV()

    return Color3.fromHSV(v4, v5, (math.min(v6 * v7 / 0.5, 1)))
end

function t3.Bind(p7, p8, p9, p10) -- line: 63
    -- upvalues: TweenService (copy), v1 (copy), self (copy)
    local t4 = {}

    local function apply(p11) -- line: 66
        -- upvalues: p9 (copy), p10 (copy), t4 (copy), TweenService (copy), v1 (copy), self (copy)
        if t4[p11] ~= nil then
            return
        end

        local v9

        if p11:IsA("BasePart") then
            if p11:IsA("BasePart") and (p11.Material == Enum.Material.Water or p11:GetAttribute("TerrainRole") == "Basin") then
                v9 = "Color"
            end
        elseif p11:IsA("Decal") then
            local Parent = p11.Parent

            if Parent ~= nil and not not (Parent:IsA("BasePart") and (Parent.Material == Enum.Material.Water or Parent:GetAttribute("TerrainRole") == "Basin")) then
                v9 = "Color3"
            end
        end

        if v9 ~= nil then
            local v10 = self[p11]

            if v10 == nil then
                v10 = p11[v9]
                self[p11] = v10
            end

            local v11

            if v9 == "Color" then
                local v12, v13, v14 = p9:ToHSV()
                local _, _, v15 = v10:ToHSV()

                v11 = Color3.fromHSV(v12, v13, (math.min(v14 * v15 / 0.5, 1)))
            else
                v11 = p10
            end

            t4[p11] = v9
            TweenService:Create(p11, v1, {
                [v9] = v11
            }):Play()
        end
    end

    for _, descendant in p7:GetDescendants() do
        apply(descendant)
    end

    p8:Connect(p7.DescendantAdded, apply)
    p8:Add(function() -- line: 84
        -- upvalues: t4 (copy), TweenService (copy), v1 (copy), self (copy)
        for v17, v18 in t4 do
            if v17.Parent ~= nil then
                TweenService:Create(v17, v1, {
                    [v18] = self[v17]
                }):Play()
            end
        end
    end)
end

return t3
