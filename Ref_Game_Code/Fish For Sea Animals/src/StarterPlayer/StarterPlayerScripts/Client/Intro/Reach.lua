-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Director = require(script.Parent.Director)
local t1 = {}

local function ease(p1) -- line: 8
    local v1 = math.clamp(p1, 0, 1)

    return v1 * v1 * (3 - v1 * 2)
end

local function frames(p2) -- line: 14
    if p2:IsA("Motor6D") then
        return p2.Part0, p2.C0, p2.Part1, p2.C1
    end

    return p2.Attachment0.Parent, p2.Attachment0.CFrame, p2.Attachment1.Parent, p2.Attachment1.CFrame
end

local function swing(p3, p4, p5, p6) -- line: 22
    local v2 = p5:Cross(p6)

    if v2.Magnitude < 1E-06 then
        return p3
    end

    local v5 = math.acos((math.clamp(p5.Unit:Dot(p6.Unit), -1, 1)))

    return CFrame.new(p4) * CFrame.fromAxisAngle(v2.Unit, v5) * CFrame.new(-p4) * p3
end

local function torso(p7) -- line: 32
    local v6 = p7.root.CFrame

    for _, v7 in { "Root", "Waist" } do
        local v8 = p7.joints[v7]

        if v8 then
            local v9, v10

            if v8:IsA("Motor6D") then
                local _ = v8.Part0

                v9 = v8.C0

                local _ = v8.Part1

                v10 = v8.C1
            else
                local _ = v8.Attachment0.Parent

                v9 = v8.Attachment0.CFrame

                local _ = v8.Attachment1.Parent

                v10 = v8.Attachment1.CFrame
            end

            v6 = v6 * v9 * v8.Transform * v10:Inverse()
        end
    end

    return v6
end

local function weight(p8, p9) -- line: 44
    local w0 = p8.w0
    local v11 = p8.w1 - p8.w0
    local v13 = math.clamp((p9 - p8.wStart) / p8.wTime, 0, 1)

    return w0 + v11 * (v13 * v13 * (3 - v13 * 2))
end

local function solve(p10) -- line: 49
    -- upvalues: Director (copy), swing (copy), torso (copy)
    local reach = p10.reach
    local v14 = Director.now()
    local w0 = reach.w0
    local v15 = reach.w1 - reach.w0
    local v17 = math.clamp((v14 - reach.wStart) / reach.wTime, 0, 1)
    local v18 = w0 + v15 * (v17 * v17 * (3 - v17 * 2))

    if v18 <= 0 and reach.w1 <= 0 then
        p10.reach = nil
        p10.after = nil

        return
    end

    local LS, LE = p10.joints.LS, p10.joints.LE
    local from = reach.from
    local v19 = reach.goal()
    local v21 = math.clamp((v14 - reach.start) / reach.time, 0, 1)

    reach.at = from:Lerp(v19, v21 * v21 * (3 - v21 * 2))

    local v22, v23

    if LS:IsA("Motor6D") then
        local _ = LS.Part0

        v22 = LS.C0

        local _ = LS.Part1

        v23 = LS.C1
    else
        local _ = LS.Attachment0.Parent

        v22 = LS.Attachment0.CFrame

        local _ = LS.Attachment1.Parent

        v23 = LS.Attachment1.CFrame
    end

    local v24 = torso(p10) * v22
    local Position = v24.Position
    local v25 = v24 * v23:Inverse()
    local v26

    if LE then
        local v27, v28

        if LE:IsA("Motor6D") then
            local _ = LE.Part0

            v27 = LE.C0

            local _ = LE.Part1

            v28 = LE.C1
        else
            local _ = LE.Attachment0.Parent

            v27 = LE.Attachment0.CFrame

            local _ = LE.Attachment1.Parent

            v28 = LE.Attachment1.CFrame
        end

        local Position2 = (v25 * v27).Position
        local v29 = v25 * v27 * v28:Inverse() * reach.handLocal
        local Magnitude = (Position2 - Position).Magnitude
        local Magnitude2 = (v29 - Position2).Magnitude
        local v30 = reach.at - Position
        local Unit = v30.Unit
        local v34 = math.clamp(v30.Magnitude, math.abs(Magnitude - Magnitude2) + 0.01, Magnitude + Magnitude2 - 0.001)
        local CFrame = p10.root.CFrame
        local v35 = -CFrame.UpVector - CFrame.RightVector * 0.6
        local v36 = v35 - Unit * v35:Dot(Unit)
        local v37 = if v36.Magnitude > 1E-04 then v36.Unit else -CFrame.UpVector
        local v38 = (Magnitude * Magnitude + v34 * v34 - Magnitude2 * Magnitude2) / (v34 * 2)
        local v42 = Position + Unit * v38 + v37 * math.sqrt((math.max(Magnitude * Magnitude - v38 * v38, 0)))

        v26 = swing(v25, Position, Position2 - Position, v42 - Position)

        local v43 = v26 * v27 * v28:Inverse()
        local v44 = swing(v43, v42, v43 * reach.handLocal - v42, Position + Unit * v34 - v42)

        LE.Transform = LE.Transform:Lerp((v26 * v27):Inverse() * v44 * v28, v18)
    else
        v26 = swing(v25, Position, v25 * reach.handLocal - Position, reach.at - Position)
    end

    LS.Transform = LS.Transform:Lerp(v24:Inverse() * v26 * v23, v18)
end

function t1.grab(p11, p12, p13) -- line: 90
    -- upvalues: Director (copy), solve (copy)
    local LS = p11.joints.LS

    if not LS then
        return
    end

    local v46 = math.max(p13 or 0.4, 0.01)
    local v47 = Director.now()
    local reach = p11.reach
    local v48

    if reach then
        v48 = reach
    else
        local v49 = p11.model:FindFirstChild("LeftHand") or p11.model:FindFirstChild("Left Arm")
        local v50 = p11.joints.LE or LS
        local v51

        if v50:IsA("Motor6D") then
            local _, _ = v50.Part0, v50.C0

            v51 = v50.Part1

            local _ = v50.C1
        else
            local _, _ = v50.Attachment0.Parent, v50.Attachment0.CFrame

            v51 = v50.Attachment1.Parent

            local _ = v50.Attachment1.CFrame
        end

        v48 = {
            w0 = 0,
            w1 = 0,
            wTime = 1,
            handLocal = if v51 == v49 then Vector3.new(0, 0.3 - v51.Size.Y / 2, 0) else v51.CFrame:PointToObjectSpace(v49.Position),
            at = v49.Position,
            wStart = v47
        }
        p11.reach = v48
        p11.after = solve
    end

    v48.from = v48.at
    v48.start = v47
    v48.time = v46

    if typeof(p12) == "Vector3" then
        v48.goal = function() -- line: 107
            -- upvalues: p12 (copy)
            return p12
        end
    else
        v48.goal = p12
    end

    local w0 = v48.w0
    local v54 = v48.w1 - v48.w0
    local v56 = math.clamp((v47 - v48.wStart) / v48.wTime, 0, 1)

    v48.w0 = w0 + v54 * (v56 * v56 * (3 - v56 * 2))
    v48.w1 = 1
    v48.wStart = v47
    v48.wTime = v46
end

function t1.release(p14, p15) -- line: 114
    -- upvalues: Director (copy)
    local reach = p14.reach

    if not reach then
        return
    end

    local v57 = Director.now()
    local w0 = reach.w0
    local v58 = reach.w1 - reach.w0
    local v60 = math.clamp((v57 - reach.wStart) / reach.wTime, 0, 1)
    local v61 = w0 + v58 * (v60 * v60 * (3 - v60 * 2))
    local v63 = math.max(p15 or 0.4, 0.01)

    reach.w0 = v61
    reach.w1 = 0
    reach.wStart = v57
    reach.wTime = v63
end

return t1
