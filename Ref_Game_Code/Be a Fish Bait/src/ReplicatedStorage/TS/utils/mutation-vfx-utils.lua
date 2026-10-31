-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local VFX = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage:FindFirstChild("VFX")

if VFX ~= nil then
    VFX = VFX:FindFirstChild("MutationVFX")
end

local function getMutationVfxTemplateName(p1) -- line: 12
    if p1 == "hoola1" then
        return "Hoola1VFX"
    end

    if p1 == "hoola2" then
        return "Hoola2VFX"
    end

    if p1 == "hoola3" then
        return "Hoola3VFX"
    end

    return p1
end

return {
    applyMutationVfx = function(p2, p3) -- applyMutationVfx | line: 24
        -- upvalues: VFX (ref)
        if table.find(p3, "Delulu") ~= nil then
            for _, descendant in p2:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                    descendant.Transparency = 0.7
                end
            end
        end

        local PrimaryPart = p2.PrimaryPart

        if not PrimaryPart or not VFX or #p3 == 0 then
            return nil
        end

        local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
        local v2 = math.clamp((BoundingBox2.X * BoundingBox2.Y * BoundingBox2.Z / 17942.504228730002) ^ 0.47, 0, 1)

        for _, v3 in p3 do
            local v4 = if v3 == "hoola1" then "Hoola1VFX"
                elseif v3 == "hoola2" then "Hoola2VFX"
                elseif v3 == "hoola3" then "Hoola3VFX"
                else v3
            local v5 = VFX:FindFirstChild(v4)

            if v5 and v5:IsA("BasePart") then
                local clone = v5:Clone()

                clone:PivotTo(BoundingBox)
                clone.Size = Vector3.new(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)
                clone.Anchored = false
                clone.CanCollide = false
                clone.CanQuery = false
                clone.CanTouch = false
                clone.Parent = p2

                for _, descendant in clone:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Rate *= v2
                    end
                end

                local WeldConstraint = Instance.new("WeldConstraint")

                WeldConstraint.Part0 = PrimaryPart
                WeldConstraint.Part1 = clone
                WeldConstraint.Parent = clone
            end
        end
    end
}
