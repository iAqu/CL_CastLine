-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-vfx-utils")
local applyBaitAuraVfx, clearBaitAuraVfx = v1.applyBaitAuraVfx, v1.clearBaitAuraVfx
local v2 = Color3.fromRGB(255, 255, 255)

local function setSingleRollVfxInstanceVisible(p1, p2, p3) -- line: 12
    local v3 = NumberSequence.new(if p2 then 0 else 1)

    if p1:IsA("ParticleEmitter") or p1:IsA("Beam") or p1:IsA("Trail") then
        p1.Enabled = p2
        p1.Transparency = v3

        if p3 ~= nil then
            p1.Color = ColorSequence.new(p3)
        end
    elseif p1:IsA("Light") then
        p1.Enabled = p2

        if p3 ~= nil then
            p1.Color = p3
        end
    end
end

local function setSceneBackgroundVfxVisible(_, p5, p6) -- line: 33
    -- upvalues: Workspace (copy), setSingleRollVfxInstanceVisible (copy)
    local Map = Workspace:FindFirstChild("Map")

    if Map ~= nil then
        Map = Map:FindFirstChild("BaitAuraArea")

        if Map ~= nil then
            Map = Map:FindFirstChild("BGVFXPart")

            if Map ~= nil then
                Map = Map:FindFirstChild("BGVFXAttachment")

                if Map ~= nil then
                    Map = Map:FindFirstChild("BGVFX")
                end
            end
        end
    end

    if Map ~= nil and (Map:IsA("ParticleEmitter") or Map:IsA("Beam") or Map:IsA("Trail") or Map:IsA("Light")) then
        setSingleRollVfxInstanceVisible(Map, p5, p6)
    end
end

local function getRigRoot(p7) -- line: 52
    return p7:FindFirstChild("HumanoidRootPart", true) or p7.PrimaryPart or p7:FindFirstChildWhichIsA("BasePart", true)
end

local function getRigAnimator(p8) -- line: 55
    local Humanoid = p8:FindFirstChildOfClass("Humanoid")

    if Humanoid == nil then
        return nil
    end

    local Animator = Humanoid:FindFirstChildOfClass("Animator")

    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    return Animator
end

return {
    default = function(p9) -- BaitAuraPreviewRig | line: 67
        -- upvalues: useEffect (copy), RunService (copy), applyBaitAuraVfx (copy), clearBaitAuraVfx (copy), v2 (copy), setSceneBackgroundVfxVisible (copy)
        useEffect(function() -- line: 68
            -- upvalues: p9 (copy), RunService (copy)
            local rigInstance, Humanoid, v4

            if not p9.active or p9.rigInstance == nil then
                return nil
            else
                rigInstance = p9.rigInstance
                Humanoid = rigInstance:FindFirstChildOfClass("Humanoid")
                v4 = rigInstance:FindFirstChild("HumanoidRootPart", true) or rigInstance.PrimaryPart or rigInstance:FindFirstChildWhichIsA("BasePart", true)
            end

            local v6 = if Humanoid == nil then Humanoid else Humanoid.AutoRotate
            local v7 = if v4 == nil then v4 else v4.Anchored
            local Pivot = rigInstance:GetPivot()

            if Humanoid ~= nil then
                Humanoid.AutoRotate = false
            end

            if v4 ~= nil then
                v4.Anchored = true
            end

            local connection = RunService.RenderStepped:Connect(function() -- line: 98
                -- upvalues: rigInstance (ref), Pivot (copy)
                rigInstance:PivotTo(Pivot)
            end)

            return function() -- line: 101
                -- upvalues: Humanoid (ref), v4 (ref), v6 (copy), v7 (copy), connection (copy)
                connection:Disconnect()

                if Humanoid ~= nil and v6 ~= nil then
                    Humanoid.AutoRotate = v6
                end

                if v4 ~= nil and v7 ~= nil then
                    v4.Anchored = v7
                end
            end
        end, {
            p9.active,
            p9.rigInstance
        })
        useEffect(function() -- line: 111
            -- upvalues: p9 (copy)
            local Humanoid, Animation, t1

            if not p9.active or p9.rigInstance == nil then
                return nil
            else
                local rigInstance = p9.rigInstance

                Humanoid = rigInstance:FindFirstChildOfClass("Humanoid")
                Animation = Instance.new("Animation")
                Animation.AnimationId = "rbxassetid://507766388"
                t1 = {}
                t1[1] = nil

                local Animation2 = Animation
                local v9 = (function(p10)
                    return function() -- line: 120
                        -- upvalues: p10 (copy), rigInstance (copy), Animation2 (copy)
                        local v10 = p10[1]

                        if v10 ~= nil then
                            v10:Stop(0.1)
                        end

                        local v11 = p10[1]

                        if v11 ~= nil then
                            v11:Destroy()
                        end

                        local Humanoid = rigInstance:FindFirstChildOfClass("Humanoid")
                        local Animator

                        if Humanoid ~= nil then
                            Animator = Humanoid:FindFirstChildOfClass("Animator")

                            if Animator == nil then
                                Animator = Instance.new("Animator")
                                Animator.Parent = Humanoid
                            end
                        end

                        if Animator == nil then
                            return nil
                        end

                        p10[1] = Animator:LoadAnimation(Animation2)
                        p10[1].Looped = true
                        p10[1].Priority = Enum.AnimationPriority.Idle
                        p10[1]:Play(0.2)
                    end
                end)(t1)

                v9()

                if Humanoid ~= nil then
                    Humanoid = Humanoid.ApplyDescriptionFinished:Connect(function() -- line: 144
                        -- upvalues: v9 (copy)
                        return v9()
                    end)
                end
            end

            return ((function(p11)
                return function() -- line: 149
                    -- upvalues: p11 (copy), Humanoid (ref), Animation (ref)
                    if Humanoid ~= nil then
                        Humanoid:Disconnect()
                    end

                    local v15 = p11[1]

                    if v15 ~= nil then
                        v15:Stop(0.15)
                    end

                    local v16 = p11[1]

                    if v16 ~= nil then
                        v16:Destroy()
                    end

                    Animation:Destroy()
                end
            end)(t1))
        end, {
            p9.active,
            p9.rigInstance
        })
        useEffect(function() -- line: 165
            -- upvalues: p9 (copy), RunService (copy), v2 (copy), setSceneBackgroundVfxVisible (copy)
            local t2, t3, v17

            if not p9.active or p9.rigInstance == nil then
                return nil
            else
                t2 = {}
                t2[1] = 0
                t3 = {}
                t3[1] = nil
                v17 = p9.rollingColor or v2
            end

            if p9.isRolling == true then
                setSceneBackgroundVfxVisible(p9.rigInstance, true, v17)
            else
                setSceneBackgroundVfxVisible(p9.rigInstance, false)
            end

            t3[1] = RunService.RenderStepped:Connect(((function(p12, p13)
                return function() -- line: 180
                    -- upvalues: p12 (copy), p13 (copy), p9 (copy), v2 (copy), setSceneBackgroundVfxVisible (copy)
                    p12[1] += 1

                    local v19 = p9.rollingColor or v2

                    if p9.isRolling == true then
                        setSceneBackgroundVfxVisible(p9.rigInstance, true, v19)
                    else
                        setSceneBackgroundVfxVisible(p9.rigInstance, false)
                    end

                    if p12[1] >= 8 and p9.isRolling ~= true then
                        local v20 = p13[1]

                        if v20 ~= nil then
                            v20:Disconnect()
                        end

                        p13[1] = nil
                    end
                end
            end)(t2, t3)))

            return ((function(p14)
                return function() -- line: 191
                    -- upvalues: p14 (copy)
                    local v21 = p14[1]

                    if v21 ~= nil then
                        v21:Disconnect()
                    end
                end
            end)(t3))
        end, {
            p9.active,
            p9.rigInstance,
            p9.isRolling,
            p9.rollingColor
        })
        useEffect(function() -- line: 198
            -- upvalues: p9 (copy), applyBaitAuraVfx (copy), clearBaitAuraVfx (copy)
            local rigInstance, Humanoid

            if not p9.active or p9.rigInstance == nil then
                return nil
            else
                rigInstance = p9.rigInstance
                Humanoid = rigInstance:FindFirstChildOfClass("Humanoid")
                applyBaitAuraVfx(rigInstance, p9.auraName, 1, false)

                if Humanoid ~= nil then
                    local ApplyDescriptionFinished = Humanoid.ApplyDescriptionFinished
                    local rigInstance2 = rigInstance

                    Humanoid = ApplyDescriptionFinished:Connect(function() -- line: 210
                        -- upvalues: rigInstance2 (copy), p9 (copy), applyBaitAuraVfx (copy)
                        applyBaitAuraVfx(rigInstance2, p9.auraName, 1, false)
                    end)
                end
            end

            return function() -- line: 215
                -- upvalues: rigInstance (ref), Humanoid (ref), clearBaitAuraVfx (copy)
                if Humanoid ~= nil then
                    Humanoid:Disconnect()
                end

                clearBaitAuraVfx(rigInstance)
            end
        end, {
            p9.active,
            p9.rigInstance,
            p9.auraName
        })

        return nil
    end
}
