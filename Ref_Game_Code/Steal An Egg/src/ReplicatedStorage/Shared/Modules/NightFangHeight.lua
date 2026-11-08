-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {}
local t2 = {
    ["rbxassetid://138755573007016"] = 0.2715822764466176,
    ["rbxassetid://133536318506183"] = 0.629364013671875 * ReplicatedStorage.AssetModels["Halloween Terrorbird"].Model:GetScale() / (2.7933807373046875 * ReplicatedStorage.AssetModels["Zombified Halloween Terrorbird"].Model:GetScale())
}

function t1.New(p1) -- line: 11
    if p1.Name ~= "Zombified Halloween Terrorbird" and p1:GetAttribute("PreparedSourceName") ~= "Zombified Bat" then
        return nil
    end

    local v1 = p1:FindFirstChild("Control", true)

    return if v1 and v1:IsA("Bone") then {
        Applied = 0,
        Ratio = 0.2715822764466176,
        Model = p1,
        Control = v1
    } else nil
end

function t1.Reset(p2) -- line: 17
    if not p2 then
        return
    end

    if p2.Control.Parent then
        local Control = p2.Control

        Control.Transform = Control.Transform + Vector3.new(0, p2.Applied, 0)
    end

    p2.Applied = 0
end

function t1.Apply(p3) -- line: 22
    -- upvalues: t1 (copy), t2 (copy)
    if p3 and p3.Control.Parent then
        t1.Reset(p3)

        local v2 = p3.Model:FindFirstChildWhichIsA("Animator", true)
        local v3, v4

        if v2 then
            local n1 = 0
            local n2 = 0

            v4 = 0
            v3 = 0

            for _, v5 in v2:GetPlayingAnimationTracks() do
                local v6 = t2[v5.Animation.AnimationId]

                if v6 then
                    n1 += v6 * v5.WeightCurrent
                    n2 += v5.WeightCurrent
                end

                v3 = n2
                v4 = n1
            end
        else
            v4 = 0
            v3 = 0
        end

        if v3 > 0 then
            p3.Ratio = v4 / v3
        end

        p3.Applied = math.max(0, p3.Control.Transform.Position.Y) * (1 - p3.Ratio)

        local Control = p3.Control

        Control.Transform = Control.Transform - Vector3.new(0, p3.Applied, 0)
    end
end

return t1
