-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Parent = script.Parent
local Humanoid = Parent:WaitForChild("Humanoid")
local v1 = "Standing"

local function getRigScale() -- line: 7
    -- upvalues: Parent (copy)
    return Parent:GetScale()
end

local ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent")
local v2 = ""
local v3, track, v4
local n1 = 1
local track2, v5
local t1 = {}
local t2 = {}
local t3 = {
    idle = {
        {
            id = "http://www.roblox.com/asset/?id=507766666",
            weight = 1
        },
        {
            id = "http://www.roblox.com/asset/?id=507766951",
            weight = 1
        },
        {
            id = "http://www.roblox.com/asset/?id=507766388",
            weight = 9
        }
    },
    walk = {
        {
            id = "http://www.roblox.com/asset/?id=507777826",
            weight = 10
        }
    },
    run = {
        {
            id = "http://www.roblox.com/asset/?id=507767714",
            weight = 10
        }
    },
    swim = {
        {
            id = "http://www.roblox.com/asset/?id=507784897",
            weight = 10
        }
    },
    swimidle = {
        {
            id = "http://www.roblox.com/asset/?id=507785072",
            weight = 10
        }
    },
    jump = {
        {
            id = "http://www.roblox.com/asset/?id=507765000",
            weight = 10
        }
    },
    fall = {
        {
            id = "http://www.roblox.com/asset/?id=507767968",
            weight = 10
        }
    },
    climb = {
        {
            id = "http://www.roblox.com/asset/?id=507765644",
            weight = 10
        }
    },
    sit = {
        {
            id = "http://www.roblox.com/asset/?id=2506281703",
            weight = 10
        }
    },
    toolnone = {
        {
            id = "http://www.roblox.com/asset/?id=507768375",
            weight = 10
        }
    },
    toolslash = {
        {
            id = "http://www.roblox.com/asset/?id=522635514",
            weight = 10
        }
    },
    toollunge = {
        {
            id = "http://www.roblox.com/asset/?id=522638767",
            weight = 10
        }
    },
    wave = {
        {
            id = "http://www.roblox.com/asset/?id=507770239",
            weight = 10
        }
    },
    point = {
        {
            id = "http://www.roblox.com/asset/?id=507770453",
            weight = 10
        }
    },
    dance = {
        {
            id = "http://www.roblox.com/asset/?id=507771019",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507771955",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507772104",
            weight = 10
        }
    },
    dance2 = {
        {
            id = "http://www.roblox.com/asset/?id=507776043",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507776720",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507776879",
            weight = 10
        }
    },
    dance3 = {
        {
            id = "http://www.roblox.com/asset/?id=507777268",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507777451",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507777623",
            weight = 10
        }
    },
    laugh = {
        {
            id = "http://www.roblox.com/asset/?id=507770818",
            weight = 10
        }
    },
    cheer = {
        {
            id = "http://www.roblox.com/asset/?id=507770677",
            weight = 10
        }
    }
}
local t4 = {
    wave = false,
    point = false,
    dance = true,
    dance2 = true,
    dance3 = true,
    laugh = false,
    cheer = false
}
local connection, connection2, connection3, GroundSensor, v6

function resetManagerListeners() -- line: 115
    -- upvalues: connection (ref), connection2 (ref), connection3 (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    if connection2 then
        connection2:Disconnect()
        connection2 = nil
    end

    if connection3 then
        connection3:Disconnect()
        connection3 = nil
    end
end

function processIfManagerBelongsToCharacter(p1) -- line: 132
    -- upvalues: Parent (copy), connection (ref), connection2 (ref), connection3 (ref), GroundSensor (ref), v6 (ref)
    if p1.RootPart ~= Parent.PrimaryPart then
        return false
    end

    if v6 ~= p1 then
        resetManagerListeners()
        GroundSensor = p1.GroundSensor
        connection = p1:GetPropertyChangedSignal("GroundSensor"):Connect(function() -- line: 137
            -- upvalues: p1 (copy), connection (ref)
            if not processIfManagerBelongsToCharacter(p1) then
                return
            end

            connection:Disconnect()
            connection = nil
        end)
        connection2 = p1:GetPropertyChangedSignal("RootPart"):Connect(function() -- line: 143
            -- upvalues: p1 (copy), connection2 (ref)
            if not processIfManagerBelongsToCharacter(p1) then
                return
            end

            connection2:Disconnect()
            connection2 = nil
        end)
        connection3 = p1.AncestryChanged:Connect(function(_, p3) -- line: 149
            if p3 == nil then
                resetManagerListeners()
                lookForControllerManager()
            end
        end)
        v6 = p1
    end

    return true
end

function lookForControllerManager() -- line: 165
    -- upvalues: Parent (copy), GroundSensor (ref), v6 (ref)
    GroundSensor = nil
    v6 = nil

    local ControllerManager = Parent:FindFirstChildOfClass("ControllerManager")

    if ControllerManager then
        processIfManagerBelongsToCharacter(ControllerManager)
    end

    if v6 == nil then
        local connection

        connection = Parent.ChildAdded:Connect(function(p4) -- line: 177
            -- upvalues: connection (ref)
            if not (p4:IsA("ControllerManager") and processIfManagerBelongsToCharacter(p4)) then
                return
            end

            connection:Disconnect()
            connection = nil
        end)
    end
end

lookForControllerManager()
math.randomseed(tick())

function findExistingAnimationInSet(p5, p6) -- line: 191
    if p5 == nil or p6 == nil then
        return 0
    end

    for i = 1, p5.count do
        if p5[i].anim.AnimationId == p6.AnimationId then
            return i
        end
    end

    return 0
end

function configureAnimationSet(p7, p8) -- line: 205
    -- upvalues: Humanoid (copy), t1 (copy), t2 (copy)
    if t2[p7] ~= nil then
        for _, v7 in pairs(t2[p7].connections) do
            v7:disconnect()
        end
    end

    t2[p7] = {}
    t2[p7].count = 0
    t2[p7].totalWeight = 0
    t2[p7].connections = {}

    local v8 = true

    local function v9() -- line: 218
        -- upvalues: v8 (ref)
        v8 = game:GetService("StarterPlayer").AllowCustomAnimations
    end

    if not pcall(v9) then
        v8 = true
    end

    local v10 = script:FindFirstChild(p7)

    if v8 and v10 ~= nil then
        table.insert(t2[p7].connections, v10.ChildAdded:connect(function(_) -- line: 226
            -- upvalues: p7 (copy), p8 (copy)
            configureAnimationSet(p7, p8)
        end))
        table.insert(t2[p7].connections, v10.ChildRemoved:connect(function(_) -- line: 227
            -- upvalues: p7 (copy), p8 (copy)
            configureAnimationSet(p7, p8)
        end))

        for _, child in pairs(v10:GetChildren()) do
            if child:IsA("Animation") then
                local Weight = child:FindFirstChild("Weight")
                local v13 = if Weight == nil then 1 else Weight.Value

                t2[p7].count = t2[p7].count + 1

                local count = t2[p7].count

                t2[p7][count] = {}
                t2[p7][count].anim = child
                t2[p7][count].weight = v13
                t2[p7].totalWeight = t2[p7].totalWeight + t2[p7][count].weight
                table.insert(t2[p7].connections, child.Changed:connect(function(_) -- line: 243
                    -- upvalues: p7 (copy), p8 (copy)
                    configureAnimationSet(p7, p8)
                end))
                table.insert(t2[p7].connections, child.ChildAdded:connect(function(_) -- line: 244
                    -- upvalues: p7 (copy), p8 (copy)
                    configureAnimationSet(p7, p8)
                end))
                table.insert(t2[p7].connections, child.ChildRemoved:connect(function(_) -- line: 245
                    -- upvalues: p7 (copy), p8 (copy)
                    configureAnimationSet(p7, p8)
                end))
            end
        end
    end

    if t2[p7].count <= 0 then
        for v17, v18 in pairs(p8) do
            t2[p7][v17] = {}
            t2[p7][v17].anim = Instance.new("Animation")
            t2[p7][v17].anim.Name = p7
            t2[p7][v17].anim.AnimationId = v18.id
            t2[p7][v17].weight = v18.weight
            t2[p7].count = t2[p7].count + 1
            t2[p7].totalWeight = t2[p7].totalWeight + v18.weight
        end
    end

    for _, v19 in pairs(t2) do
        for i = 1, v19.count do
            if t1[v19[i].anim.AnimationId] == nil then
                Humanoid:LoadAnimation(v19[i].anim)
                t1[v19[i].anim.AnimationId] = true
            end
        end
    end
end

function configureAnimationSetOld(p14, p15) -- line: 276
    -- upvalues: Humanoid (copy), t2 (copy)
    if t2[p14] ~= nil then
        for _, v20 in pairs(t2[p14].connections) do
            v20:disconnect()
        end
    end

    t2[p14] = {}
    t2[p14].count = 0
    t2[p14].totalWeight = 0
    t2[p14].connections = {}

    local v21 = true

    local function v22() -- line: 289
        -- upvalues: v21 (ref)
        v21 = game:GetService("StarterPlayer").AllowCustomAnimations
    end

    if not pcall(v22) then
        v21 = true
    end

    local v23 = script:FindFirstChild(p14)

    if v21 and v23 ~= nil then
        table.insert(t2[p14].connections, v23.ChildAdded:connect(function(_) -- line: 297
            -- upvalues: p14 (copy), p15 (copy)
            configureAnimationSet(p14, p15)
        end))
        table.insert(t2[p14].connections, v23.ChildRemoved:connect(function(_) -- line: 298
            -- upvalues: p14 (copy), p15 (copy)
            configureAnimationSet(p14, p15)
        end))

        local n2 = 1

        for _, child in pairs(v23:GetChildren()) do
            if child:IsA("Animation") then
                table.insert(t2[p14].connections, child.Changed:connect(function(_) -- line: 302
                    -- upvalues: p14 (copy), p15 (copy)
                    configureAnimationSet(p14, p15)
                end))
                t2[p14][n2] = {}
                t2[p14][n2].anim = child

                local Weight = child:FindFirstChild("Weight")

                if Weight ~= nil then
                    t2[p14][n2].weight = Weight.Value
                else
                    t2[p14][n2].weight = 1
                end

                t2[p14].count = t2[p14].count + 1
                t2[p14].totalWeight = t2[p14].totalWeight + t2[p14][n2].weight
                n2 += 1
            end
        end
    end

    if t2[p14].count <= 0 then
        for v27, v28 in pairs(p15) do
            t2[p14][v27] = {}
            t2[p14][v27].anim = Instance.new("Animation")
            t2[p14][v27].anim.Name = p14
            t2[p14][v27].anim.AnimationId = v28.id
            t2[p14][v27].weight = v28.weight
            t2[p14].count = t2[p14].count + 1
            t2[p14].totalWeight = t2[p14].totalWeight + v28.weight
        end
    end

    for _, v29 in pairs(t2) do
        for i = 1, v29.count do
            Humanoid:LoadAnimation(v29[i].anim)
        end
    end
end

function scriptChildModified(p19) -- line: 341
    -- upvalues: t3 (copy)
    local v30 = t3[p19.Name]

    if v30 ~= nil then
        configureAnimationSet(p19.Name, v30)
    end
end

script.ChildAdded:connect(scriptChildModified)
script.ChildRemoved:connect(scriptChildModified)

local Animator = if Humanoid then Humanoid:FindFirstChildOfClass("Animator") else nil

if Animator then
    local PlayingAnimationTracks = Animator:GetPlayingAnimationTracks()

    for _, v31 in ipairs(PlayingAnimationTracks) do
        v31:Stop(0)
        v31:Destroy()
    end
end

for v32, v33 in pairs(t3) do
    configureAnimationSet(v32, v33)
end

local v34 = "None"
local n3 = 0
local n4 = 0
local v35 = false

function stopAllAnimations() -- line: 382
    -- upvalues: v2 (ref), v3 (ref), track (ref), v4 (ref), track2 (ref), v5 (ref), t4 (copy), v35 (ref)
    local v36 = v2

    if t4[v36] ~= nil and t4[v36] == false then
        v36 = "idle"
    end

    if v35 then
        v35 = false
        v36 = "idle"
    end

    v2 = ""
    v3 = nil

    if v4 ~= nil then
        v4:disconnect()
    end

    if track ~= nil then
        track:Stop()
        track:Destroy()
        track = nil
    end

    if v5 ~= nil then
        v5:disconnect()
    end

    if track2 ~= nil then
        track2:Stop()
        track2:Destroy()
        track2 = nil
    end

    return v36
end

function getHeightScale() -- line: 421
    -- upvalues: Humanoid (copy), getRigScale (copy), ScaleDampeningPercent (ref)
    if not Humanoid or not Humanoid.AutomaticScalingEnabled then
        return getRigScale()
    end

    local v37 = Humanoid.HipHeight / 2

    if ScaleDampeningPercent == nil then
        ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent")
    end

    if ScaleDampeningPercent ~= nil then
        v37 = 1 + (Humanoid.HipHeight - 2) * ScaleDampeningPercent.Value / 2
    end

    return v37
end

local function rootMotionCompensation(p20) -- line: 441
    return p20 * 1.25 / getHeightScale()
end

local function setRunSpeed(p21) -- line: 449
    -- upvalues: track (ref), track2 (ref)
    local v38 = p21 * 1.25 / getHeightScale()
    local v39, v40, v41

    if v38 <= 0.5 then
        v39 = 1
        v40 = 1E-04
        v41 = v38 / 0.5
    elseif v38 < 1 then
        v40 = (v38 - 0.5) / 0.5
        v39 = 1 - v40
        v41 = 1
    else
        v39 = 1E-04
        v40 = 1
        v41 = v38 / 1
    end

    track:AdjustWeight(v39)
    track2:AdjustWeight(v40)
    track:AdjustSpeed(v41)
    track2:AdjustSpeed(v41)
end

function setAnimationSpeed(p22) -- line: 475
    -- upvalues: v2 (ref), track (ref), n1 (ref), setRunSpeed (copy)
    if v2 == "walk" then
        setRunSpeed(p22)
    elseif p22 ~= n1 then
        n1 = p22
        track:AdjustSpeed(n1)
    end
end

function keyFrameReachedFunc(p23) -- line: 486
    -- upvalues: Humanoid (copy), v2 (ref), track (ref), n1 (ref), track2 (ref), t4 (copy), v35 (ref)
    if p23 ~= "End" then
        return
    end

    if v2 == "walk" then
        if track2.Looped ~= true then
            track2.TimePosition = 0
        end

        if track.Looped ~= true then
            track.TimePosition = 0
        end
    else
        local v43 = v2

        if t4[v43] ~= nil and t4[v43] == false then
            v43 = "idle"
        end

        if v35 then
            if track.Looped then
                return
            end

            v35 = false
            v43 = "idle"
        end

        local v44 = n1

        playAnimation(v43, 0.15, Humanoid)
        setAnimationSpeed(v44)
    end
end

function rollAnimation(p24) -- line: 519
    -- upvalues: t2 (copy)
    local v45 = math.random(1, t2[p24].totalWeight)
    local n5 = 1

    while t2[p24][n5].weight < v45 do
        v45 -= t2[p24][n5].weight
        n5 += 1
    end

    return n5
end

local function switchToAnim(p25, p26, p27, p28) -- line: 530
    -- upvalues: v2 (ref), v3 (ref), track (ref), v4 (ref), n1 (ref), track2 (ref), v5 (ref), t2 (copy)
    if p25 == v3 then
        return
    end

    if track ~= nil then
        track:Stop(p27)
        track:Destroy()
    end

    if track2 ~= nil then
        track2:Stop(p27)
        track2:Destroy()
        track2 = nil
    end

    n1 = 1
    track = p28:LoadAnimation(p25)

    local track3 = track

    track3.Priority = Enum.AnimationPriority.Core
    track:Play(p27)
    v2 = p26
    v3 = p25

    if v4 ~= nil then
        v4:disconnect()
    end

    v4 = track.KeyframeReached:connect(keyFrameReachedFunc)

    if p26 ~= "walk" then
        return
    end

    local run = rollAnimation("run")

    track2 = p28:LoadAnimation(t2.run[run].anim)

    local track4 = track2

    track4.Priority = Enum.AnimationPriority.Core
    track2:Play(p27)

    if v5 ~= nil then
        v5:disconnect()
    end

    v5 = track2.KeyframeReached:connect(keyFrameReachedFunc)
end

function playAnimation(p29, p30, p31) -- line: 579
    -- upvalues: t2 (copy), v35 (ref), switchToAnim (copy)
    local v46 = rollAnimation(p29)

    switchToAnim(t2[p29][v46].anim, p29, p30, p31)
    v35 = false
end

function playEmote(p32, p33, p34) -- line: 587
    -- upvalues: v35 (ref), switchToAnim (copy)
    switchToAnim(p32, p32.Name, p33, p34)
    v35 = true
end

local v47 = ""
local track3, anim, v48

function toolKeyFrameReachedFunc(p35) -- line: 600
    -- upvalues: Humanoid (copy), v47 (ref)
    if p35 == "End" then
        playToolAnimation(v47, 0, Humanoid)
    end
end

function playToolAnimation(p36, p37, p38, p39) -- line: 607
    -- upvalues: t2 (copy), v47 (ref), track3 (ref), anim (ref), v48 (ref)
    local v49 = rollAnimation(p36)
    local anim2 = t2[p36][v49].anim

    if anim == anim2 then
        return
    end

    local v50

    if track3 ~= nil then
        track3:Stop()
        v50 = 0
        track3:Destroy()
    else
        v50 = p37
    end

    track3 = p38:LoadAnimation(anim2)

    if p39 then
        track3.Priority = p39
    end

    track3:Play(v50)
    v47 = p36
    anim = anim2
    v48 = track3.KeyframeReached:connect(toolKeyFrameReachedFunc)
end

function stopToolAnimations() -- line: 634
    -- upvalues: v47 (ref), track3 (ref), anim (ref), v48 (ref)
    local v51 = v47

    if v48 ~= nil then
        v48:disconnect()
    end

    v47 = ""
    anim = nil

    if track3 ~= nil then
        track3:Stop()
        track3:Destroy()
        track3 = nil
    end

    return v51
end

function onRunning(p40) -- line: 656
    -- upvalues: Humanoid (copy), v1 (ref), v2 (ref), t4 (copy), GroundSensor (ref), v6 (ref), v35 (ref)
    local v52 = getHeightScale()
    local Magnitude, Magnitude2
    local v53 = p40

    if GroundSensor ~= nil and Humanoid.EvaluateStateMachine == false then
        local RootPart = Humanoid.RootPart
        local SensedPart = GroundSensor.SensedPart

        if SensedPart then
            local VelocityAtPosition = SensedPart:GetVelocityAtPosition(GroundSensor.HitFrame.Position)
            local AssemblyLinearVelocity = RootPart.AssemblyLinearVelocity

            Magnitude = Vector3.new(AssemblyLinearVelocity.X - VelocityAtPosition.X, 0, AssemblyLinearVelocity.Z - VelocityAtPosition.Z).Magnitude
            Magnitude2 = v6.MovingDirection.Magnitude

            if Magnitude2 < 0.1 then
                Magnitude = 0
                Magnitude2 = 0
            elseif Magnitude2 > 1 then
                Magnitude2 = 1
            end

            v53 = Magnitude * Magnitude2
        end
    end

    if (v35 and Humanoid.MoveDirection == Vector3.new(0, 0, 0) and Humanoid.WalkSpeed / v52 or 0.75) * v52 < v53 then
        playAnimation("walk", 0.2, Humanoid)
        setAnimationSpeed(v53 / 16)
        v1 = "Running"
    elseif t4[v2] == nil and not v35 then
        playAnimation("idle", 0.2, Humanoid)
        v1 = "Standing"
    end
end

function onDied() -- line: 699
    -- upvalues: v1 (ref)
    v1 = "Dead"
end

function onJumping() -- line: 703
    -- upvalues: Humanoid (copy), v1 (ref), n4 (ref)
    playAnimation("jump", 0.1, Humanoid)
    n4 = 0.31
    v1 = "Jumping"
end

function onClimbing(p41) -- line: 709
    -- upvalues: Humanoid (copy), v1 (ref)
    local v56 = p41 / getHeightScale()

    playAnimation("climb", 0.1, Humanoid)
    setAnimationSpeed(v56 / 5)
    v1 = "Climbing"
end

function onGettingUp() -- line: 717
    -- upvalues: v1 (ref)
    v1 = "GettingUp"
end

function onFreeFall() -- line: 721
    -- upvalues: Humanoid (copy), v1 (ref), n4 (ref)
    if n4 <= 0 then
        playAnimation("fall", 0.2, Humanoid)
    end

    v1 = "FreeFall"
end

function onFallingDown() -- line: 728
    -- upvalues: v1 (ref)
    v1 = "FallingDown"
end

function onSeated() -- line: 732
    -- upvalues: v1 (ref)
    v1 = "Seated"
end

function onPlatformStanding() -- line: 736
    -- upvalues: v1 (ref)
    v1 = "PlatformStanding"
end

function onSwimming(p42) -- line: 743
    -- upvalues: Humanoid (copy), v1 (ref)
    local v57 = p42 / getHeightScale()

    if not (v57 > 1) then
        playAnimation("swimidle", 0.4, Humanoid)
        v1 = "Standing"

        return
    end

    playAnimation("swim", 0.4, Humanoid)
    setAnimationSpeed(v57 / 10)
    v1 = "Swimming"
end

function animateTool() -- line: 756
    -- upvalues: Humanoid (copy), v34 (ref)
    if v34 == "None" then
        playToolAnimation("toolnone", 0.1, Humanoid, Enum.AnimationPriority.Idle)
    elseif v34 == "Slash" then
        playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action)
    elseif v34 == "Lunge" then
        playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action)
    end
end

function getToolAnim(p43) -- line: 773
    for _, child in ipairs(p43:GetChildren()) do
        if child.Name == "toolanim" and child.className == "StringValue" then
            return child
        end
    end

    return nil
end

local n6 = 0

function stepAnimate(p44) -- line: 784
    -- upvalues: Parent (copy), Humanoid (copy), v1 (ref), v34 (ref), n3 (ref), n4 (ref), anim (ref), n6 (ref)
    local v58 = p44 - n6

    n6 = p44

    if n4 > 0 then
        n4 -= v58
    end

    if v1 == "FreeFall" and n4 <= 0 then
        playAnimation("fall", 0.2, Humanoid)

        local Tool = Parent:FindFirstChildOfClass("Tool")

        if Tool and Tool:FindFirstChild("Handle") then
            local v59 = getToolAnim(Tool)

            if v59 then
                v34 = v59.Value
                v59.Parent = nil
                n3 = p44 + 0.3
            end

            if n3 < p44 then
                n3 = 0
                v34 = "None"
            end

            animateTool()
        else
            stopToolAnimations()
            v34 = "None"
            anim = nil
            n3 = 0
        end
    elseif v1 == "Seated" then
        playAnimation("sit", 0.5, Humanoid)
    else
        if v1 == "Running" then
            playAnimation("walk", 0.2, Humanoid)
        elseif v1 == "Dead" or v1 == "GettingUp" or v1 == "FallingDown" or v1 == "Seated" or v1 == "PlatformStanding" then
            stopAllAnimations()
        end

        local Tool = Parent:FindFirstChildOfClass("Tool")

        if Tool and Tool:FindFirstChild("Handle") then
            local v61 = getToolAnim(Tool)

            if v61 then
                v34 = v61.Value
                v61.Parent = nil
                n3 = p44 + 0.3
            end

            if n3 < p44 then
                n3 = 0
                v34 = "None"
            end

            animateTool()
        else
            stopToolAnimations()
            v34 = "None"
            anim = nil
            n3 = 0
        end
    end
end

Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)
Humanoid.Jumping:connect(onJumping)
Humanoid.Climbing:connect(onClimbing)
Humanoid.GettingUp:connect(onGettingUp)
Humanoid.FreeFalling:connect(onFreeFall)
Humanoid.FallingDown:connect(onFallingDown)
Humanoid.Seated:connect(onSeated)
Humanoid.PlatformStanding:connect(onPlatformStanding)
Humanoid.Swimming:connect(onSwimming)
game:GetService("Players").LocalPlayer.Chatted:connect(function(p45) -- line: 850
    -- upvalues: Humanoid (copy), v1 (ref), t4 (copy)
    local v63 = if string.sub(p45, 1, 3) == "/e " then string.sub(p45, 4) elseif string.sub(p45, 1, 7) == "/emote " then string.sub(p45, 8) else ""

    if v1 == "Standing" and t4[v63] ~= nil then
        playAnimation(v63, 0.1, Humanoid)
    end
end)

script:WaitForChild("PlayEmote").OnInvoke = function(p46) -- line: 864
    -- upvalues: Humanoid (copy), v1 (ref), track (ref), t4 (copy)
    if v1 == "Standing" then
        if t4[p46] ~= nil then
            playAnimation(p46, 0.1, Humanoid)
        else
            if typeof(p46) ~= "Instance" or not p46:IsA("Animation") then
                return false
            end

            playEmote(p46, 0.1, Humanoid)
        end

        return true, track
    end
end

if Parent.Parent ~= nil then
    playAnimation("idle", 0.1, Humanoid)
    v1 = "Standing"
end

while Parent.Parent ~= nil do
    local _, v64 = wait(0.1)

    stepAnimate(v64)
end
