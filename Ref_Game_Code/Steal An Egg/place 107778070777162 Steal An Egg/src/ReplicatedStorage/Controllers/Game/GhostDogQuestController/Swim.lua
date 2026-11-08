-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Packages.Trove)

local t1 = {
    Swim = "swim",
    Idle = "swimidle"
}
local t2 = {
    Swim = "rbxassetid://507784897",
    Idle = "rbxassetid://507785072"
}
local t3 = nil
local t4 = {}

local function animationId(p1, p2) -- line: 34
    -- upvalues: t1 (copy), t2 (copy)
    local Animate = p1:FindFirstChild("Animate")
    local v1 = Animate and Animate:FindFirstChild(t1[p2])
    local Animation = v1 and v1:FindFirstChildWhichIsA("Animation")

    if not Animation or Animation.AnimationId == "" then
        return t2[p2]
    end

    return Animation.AnimationId
end

function t4.Start(p3, p4, p5) -- line: 44
    -- upvalues: t1 (copy), t2 (copy), t3 (ref), t4 (copy)
    t4.Stop()

    local Humanoid = p4:FindFirstChildOfClass("Humanoid")
    local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

    if Humanoid == nil or Animator == nil or Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
        return nil
    end

    local t5 = {}

    for v2 in t1 do
        local Animation = Instance.new("Animation")
        local Animate = p4:FindFirstChild("Animate")
        local v3 = Animate and Animate:FindFirstChild(t1[v2])
        local Animation2 = v3 and v3:FindFirstChildWhichIsA("Animation")

        if not Animation2 or Animation2.AnimationId == "" then
            Animation.AnimationId = t2[v2]
        else
            Animation.AnimationId = Animation2.AnimationId
        end

        local LoadAnimation = Animator.LoadAnimation
        local ok, result = pcall(LoadAnimation, Animator, Animation)

        if ok and result then
            result.Priority = Enum.AnimationPriority.Action
            result.Looped = true
            t5[v2] = result
        end
    end

    local v4
    local v5 = false
    local t6

    t6 = {
        Set = function(p6, p7) -- Set | line: 66
            -- upvalues: t5 (copy), v4 (ref), v5 (ref)
            if v5 then
                return
            end

            local v6 = t5[p6]

            if v6 ~= nil then
                if v4 == v6 then
                    if p7 then
                        v6:AdjustSpeed(p7)
                    end
                else
                    if v4 then
                        v4:Stop(0.25)
                    end

                    v6:Play(0.25, 1, p7 or 1)
                    v4 = v6
                end
            end
        end,
        Stop = function() -- Stop | line: 84
            -- upvalues: t5 (copy), v5 (ref), t6 (ref), t3 (ref)
            if v5 then
                return
            end

            v5 = true

            for _, v7 in t5 do
                v7:Stop(0.25)
            end

            if t3 == t6 then
                t3 = nil
            end
        end
    }
    t3 = t6
    p3:Add(t6.Stop)
    t6.Set(p5)

    return t6
end

function t4.Stop() -- line: 103
    -- upvalues: t3 (ref)
    local t8 = t3

    t3 = nil

    if t8 then
        t8.Stop()
    end
end

return table.freeze(t4)
