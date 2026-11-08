-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    CameraIn = 0.75,
    DoorStart = 0.5,
    DoorSeconds = 1.3,
    RevealAt = 1.8,
    DisplayScale = 0.35,
    FlyAt = 2.5,
    Duration = 4.2,
    Assets = function(p1) -- Assets | line: 12
        local Door = p1:FindFirstChild("Door")
        local Prompt = p1:FindFirstChild("Prompt")
        local BatSpawn = p1:FindFirstChild("BatSpawn")

        if Door and Door:IsA("Model") and Door:FindFirstChildWhichIsA("BasePart", true) and Prompt and Prompt:IsA("BasePart") and BatSpawn and BatSpawn:IsA("BasePart") then
            return Door, Prompt, BatSpawn
        end

        return nil, nil, nil
    end
}

function t1.DoorPose(p2, p3, p4) -- line: 23
    local v1 = if type(p4) ~= "number" or p4 ~= p4 then 105 else math.clamp(p4, -170, 170)

    return CFrame.new(p2.Position) * CFrame.Angles(0, math.rad(v1) * math.clamp(p3, 0, 1), 0) * p2.Rotation
end

return table.freeze(t1)
