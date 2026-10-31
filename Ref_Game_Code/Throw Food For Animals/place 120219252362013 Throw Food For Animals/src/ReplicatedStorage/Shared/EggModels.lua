-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local EggsConfig = require(ReplicatedStorage.Config.EggsConfig)
local t1 = {}

function t1.GetTemplate(p1) -- line: 24
    -- upvalues: ReplicatedStorage (copy), EggsConfig (copy)
    local v1 = EggsConfig.Get(p1)
    local Eggs = ReplicatedStorage:FindFirstChild("Eggs")
    local v2, v3

    if v1 and Eggs then
        local v4 = Eggs:FindFirstChild(v1.Model)

        if v4 then
            v2 = v4
            v3 = true
        else
            v3 = false
        end
    else
        v3 = false
    end

    if not v3 then
        v2 = nil
    end

    return v2
end

function t1.Make(p2, p3) -- line: 30
    -- upvalues: CollectionService (copy), EggsConfig (copy), t1 (copy)
    local v5 = EggsConfig.Get(p2)
    local v6 = t1.GetTemplate(p2)

    if v6 then
        local clone = v6:Clone()

        clone.Name = v5.Model

        local _, BoundingBox = clone:GetBoundingBox()

        if p3 and BoundingBox.Y > 0 then
            clone:ScaleTo(clone:GetScale() * (p3 / BoundingBox.Y))
        end

        for _, descendant in ipairs(clone:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
                descendant.Massless = true
            elseif descendant:IsA("Texture") and (v5.ScrollSpeed or 0) > 0 then
                descendant:SetAttribute("ScrollV", descendant.StudsPerTileV * v5.ScrollSpeed)
                CollectionService:AddTag(descendant, "ScrollingTexture")
            end
        end

        if not clone.PrimaryPart then
            clone.PrimaryPart = clone:FindFirstChildWhichIsA("BasePart", true)
        end

        clone:SetAttribute("EggKey", p2)

        return clone
    end

    warn("[EggModels] Missing egg model for " .. tostring(p2))

    return nil
end

return t1
