-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
    Tint = function(p1, p2) -- Tint | line: 9
        local SurfaceAppearance = p1:FindFirstChildOfClass("SurfaceAppearance")

        if SurfaceAppearance then
            SurfaceAppearance:Destroy()
        end

        if p1:IsA("MeshPart") then
            p1.TextureID = ""
        end

        p1.Color = Color3.new(1, 1, 1):Lerp(p2.color, p2.tintLerp or 0.6)

        if p2.material then
            p1.Material = p2.material
        end
    end,
    Alpha = function(p3) -- Alpha | line: 19
        -- upvalues: ReplicatedStorage (copy)
        local v1 = p3 and require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MutationDisplay"))[p3]

        return v1 and v1.transparency or 0
    end,
    Aura = function(p4, p5) -- Aura | line: 26
        -- upvalues: ReplicatedStorage (copy)
        local v2 = ReplicatedStorage:WaitForChild("VFX"):WaitForChild("MutationAura"):FindFirstChild(p5)

        if v2 then
            for _, child in ipairs(v2:GetChildren()) do
                child:Clone().Parent = p4
            end
        end
    end
}
