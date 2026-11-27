-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local FishFight = require(Modules:WaitForChild("FishFight"))
local FishMotionConfig = require(Modules:WaitForChild("FishMotionConfig"))
local t1 = {}
local t2

local function clamp(p1, p2) -- line: 19
    -- upvalues: FishFight (copy)
    return FishFight.ClampPos(p1, p2, p1.zoneBand)
end

local function step(p3, p4) -- line: 25
    -- upvalues: FishFight (copy), t1 (copy), clamp (copy)
    if p3.model.Parent then
        local v1 = p3.muzzle()

        if not v1 then
            return nil
        end

        local r, spec = p3.r, p3.spec
        local v2

        if r.tug then
            local v3

            v2, v3 = FishFight.TugStep(r, p4, v1)

            if v3 then
                p3.resp = spec.follow
            end
        else
            v2 = FishFight.Struggle(r, p4, v1, p3.rng, clamp)
        end

        local v4 = FishFight.Orient(r.pos, FishFight.Face(FishFight.ClampVertical(v2), spec.noseUp), spec.ainv, spec.roll) * spec.pivotToMesh
        local body = p3.body
        local v6 = body.Position:Lerp(v4.Position, 1 - math.exp(-p3.resp * p4))

        p3.body = body.Rotation:Lerp(v4.Rotation, 1 - math.exp(-FishFight.ROT_RESPONSIVENESS * p4)) + v6

        return p3.body, p4 > 0 and (v6 - body.Position) / p4 or Vector3.new(0, 0, 0)
    end

    t1.Stop()

    return nil
end

function t1.Begin(p5, p6, p7) -- line: 51
    -- upvalues: FishFight (copy), FishMotionConfig (copy), t1 (copy), t2 (ref), step (copy)
    t1.Stop()

    local v8 = p5 and (p5.PrimaryPart or p5:FindFirstChildWhichIsA("BasePart"))
    local v9, t3, v10, v11

    if v8 and type(p6) == "table" then
        if typeof(p6.ainv) == "CFrame" then
            if typeof(p6.pivotToMesh) == "CFrame" then
                local _CFrame = v8.CFrame

                v9 = _CFrame * p6.pivotToMesh:Inverse() * p6.ainv:Inverse() * CFrame.Angles(-(p6.roll or 0), 0, 0)
                t3 = {
                    model = p5,
                    body = _CFrame,
                    spec = p6,
                    muzzle = p7,
                    rng = Random.new()
                }
                v10 = p6.follow or FishFight.FOLLOW_RESPONSIVENESS
                v11 = false
            else
                v11 = true
            end
        else
            v11 = true
        end
    else
        v11 = true
    end

    if v11 then
        return
    end

    t3.resp = v10
    t3.r = {
        hookMode = "struggle",
        pos = v9.Position,
        dir = v9.RightVector,
        fightScale = p6.scale,
        reach = p6.reach,
        zoneBand = {
            yMin = p6.yMin,
            yMax = p6.yMax
        },
        box = p6.box,
        orbit = p6.orbit
    }
    t2 = t3

    FishMotionConfig.override[p5] = function(p8) -- line: 68
        -- upvalues: t3 (ref), step (copy)
        return step(t3, p8)
    end
end

function t1.Tug(p9) -- line: 72
    -- upvalues: FishFight (copy), t2 (ref)
    local t4 = t2

    if t4 then
        local v12 = t4.muzzle()

        if v12 then
            FishFight.Tug(t4.r, p9, (v12 - t4.r.pos).Magnitude)
            t4.resp = FishFight.TUG_RESPONSIVENESS
        end
    end
end

function t1.Landing() -- line: 82
    -- upvalues: t2 (ref)
    if t2 == nil or t2.r.tug == nil then
        return false
    end

    return t2.r.tug.endDist == 0
end

function t1.Stop() -- line: 87
    -- upvalues: FishMotionConfig (copy), t2 (ref)
    if t2 then
        FishMotionConfig.override[t2.model] = nil
        t2 = nil
    end
end

return t1
