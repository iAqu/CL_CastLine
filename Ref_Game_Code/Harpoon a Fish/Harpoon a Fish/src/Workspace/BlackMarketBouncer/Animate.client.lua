-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Parent = script.Parent
local Humanoid = Parent:WaitForChild("Humanoid")
local v1 = "Standing"

local function getRigScale() -- line: 5
    -- upvalues: Parent (copy)
    return Parent:GetScale()
end

local ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent")

local function v2() -- line: 14
    return UserSettings():IsUserFeatureEnabled("UserAnimateRemoveEmoteChatHook")
end

local ok, result = pcall(v2)
local v3 = ok and result
local v4 = ""
local v5, track, v6
local n1 = 1
local track2, v7
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
local connection, connection2, connection3, GroundSensor, v8

local function v9() -- line: 122
    return UserSettings():IsUserFeatureEnabled("UserAnimationAbilityManagerFixed")
end

local ok2, result2 = pcall(v9)
local v10 = ok2 and result2

function resetManagerListeners() -- line: 129
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

function teardownManager() -- line: 145
    -- upvalues: GroundSensor (ref), v8 (ref)
    resetManagerListeners()
    GroundSensor = nil
    v8 = nil
end

function processIfManagerBelongsToCharacter(p1) -- line: 154
    -- upvalues: Parent (copy), connection (ref), connection2 (ref), connection3 (ref), GroundSensor (ref), v8 (ref)
    if p1.RootPart ~= Parent.PrimaryPart then
        return false
    end

    if v8 ~= p1 then
        resetManagerListeners()
        GroundSensor = p1.GroundSensor
        connection = p1:GetPropertyChangedSignal("GroundSensor"):Connect(function() -- line: 159
            -- upvalues: p1 (copy), connection (ref)
            if not processIfManagerBelongsToCharacter(p1) then
                return
            end

            connection:Disconnect()
            connection = nil
        end)
        connection2 = p1:GetPropertyChangedSignal("RootPart"):Connect(function() -- line: 165
            -- upvalues: p1 (copy), connection2 (ref)
            if not processIfManagerBelongsToCharacter(p1) then
                return
            end

            connection2:Disconnect()
            connection2 = nil
        end)
        connection3 = p1.AncestryChanged:Connect(function(_, p3) -- line: 171
            if p3 == nil then
                resetManagerListeners()
                lookForControllerManager()
            end
        end)
        v8 = p1
    end

    return true
end

function setupManager(p4) -- line: 186
    -- upvalues: Parent (copy), connection (ref), connection2 (ref), connection3 (ref), GroundSensor (ref), v8 (ref)
    v8 = p4
    GroundSensor = p4.GroundSensor
    connection = p4:GetPropertyChangedSignal("GroundSensor"):Connect(function() -- line: 190
        -- upvalues: GroundSensor (ref), v8 (ref)
        GroundSensor = v8.GroundSensor
    end)
    connection2 = p4:GetPropertyChangedSignal("RootPart"):Connect(function() -- line: 194
        -- upvalues: p4 (copy), Parent (copy)
        if p4.RootPart ~= Parent.PrimaryPart then
            teardownManager()
            lookForControllerManager()
        end
    end)
    connection3 = p4.AncestryChanged:Connect(function(_, p6) -- line: 201
        if p6 == nil then
            teardownManager()
            lookForControllerManager()
        end
    end)
end

function lookForControllerManager() -- line: 212
    -- upvalues: Parent (copy), GroundSensor (ref), v8 (ref), v10 (copy)
    if v10 then
        local ControllerManager = Parent:FindFirstChildOfClass("ControllerManager")

        if ControllerManager then
            if ControllerManager.RootPart == Parent.PrimaryPart then
                setupManager(ControllerManager)
            else
                local connection

                connection = ControllerManager:GetPropertyChangedSignal("RootPart"):Connect(function() -- line: 221
                    -- upvalues: ControllerManager (copy), connection (ref), Parent (copy)
                    if ControllerManager.RootPart ~= Parent.PrimaryPart then
                        return
                    end

                    connection:Disconnect()
                    setupManager(ControllerManager)
                end)
            end
        else
            local connection

            connection = Parent.ChildAdded:Connect(function(p7) -- line: 230
                -- upvalues: connection (ref)
                if not p7:IsA("ControllerManager") then
                    return
                end

                connection:Disconnect()
                lookForControllerManager()
            end)
        end
    else
        GroundSensor = nil
        v8 = nil

        local ControllerManager = Parent:FindFirstChildOfClass("ControllerManager")

        if ControllerManager then
            processIfManagerBelongsToCharacter(ControllerManager)
        end

        if v8 == nil then
            local connection

            connection = Parent.ChildAdded:Connect(function(p8) -- line: 249
                -- upvalues: connection (ref)
                if not (p8:IsA("ControllerManager") and processIfManagerBelongsToCharacter(p8)) then
                    return
                end

                connection:Disconnect()
                connection = nil
            end)
        end
    end
end

lookForControllerManager()
math.randomseed(tick())

function findExistingAnimationInSet(p9, p10) -- line: 264
    if p9 == nil or p10 == nil then
        return 0
    end

    for i = 1, p9.count do
        if p9[i].anim.AnimationId == p10.AnimationId then
            return i
        end
    end

    return 0
end

function configureAnimationSet(p11, p12) -- line: 278
    -- upvalues: Humanoid (copy), t1 (copy), t2 (copy)
    if t2[p11] ~= nil then
        for _, v11 in pairs(t2[p11].connections) do
            v11:disconnect()
        end
    end

    t2[p11] = {}
    t2[p11].count = 0
    t2[p11].totalWeight = 0
    t2[p11].connections = {}

    local v12 = true

    local function v13() -- line: 291
        -- upvalues: v12 (ref)
        v12 = game:GetService("StarterPlayer").AllowCustomAnimations
    end

    if not pcall(v13) then
        v12 = true
    end

    local v14 = script:FindFirstChild(p11)

    if v12 and v14 ~= nil then
        table.insert(t2[p11].connections, v14.ChildAdded:connect(function(_) -- line: 299
            -- upvalues: p11 (copy), p12 (copy)
            configureAnimationSet(p11, p12)
        end))
        table.insert(t2[p11].connections, v14.ChildRemoved:connect(function(_) -- line: 300
            -- upvalues: p11 (copy), p12 (copy)
            configureAnimationSet(p11, p12)
        end))

        for _, child in pairs(v14:GetChildren()) do
            if child:IsA("Animation") then
                local Weight = child:FindFirstChild("Weight")
                local v17 = if Weight == nil then 1 else Weight.Value

                t2[p11].count = t2[p11].count + 1

                local count = t2[p11].count

                t2[p11][count] = {}
                t2[p11][count].anim = child
                t2[p11][count].weight = v17
                t2[p11].totalWeight = t2[p11].totalWeight + t2[p11][count].weight
                table.insert(t2[p11].connections, child.Changed:connect(function(_) -- line: 316
                    -- upvalues: p11 (copy), p12 (copy)
                    configureAnimationSet(p11, p12)
                end))
                table.insert(t2[p11].connections, child.ChildAdded:connect(function(_) -- line: 317
                    -- upvalues: p11 (copy), p12 (copy)
                    configureAnimationSet(p11, p12)
                end))
                table.insert(t2[p11].connections, child.ChildRemoved:connect(function(_) -- line: 318
                    -- upvalues: p11 (copy), p12 (copy)
                    configureAnimationSet(p11, p12)
                end))
            end
        end
    end

    if t2[p11].count <= 0 then
        for v21, v22 in pairs(p12) do
            t2[p11][v21] = {}
            t2[p11][v21].anim = Instance.new("Animation")
            t2[p11][v21].anim.Name = p11
            t2[p11][v21].anim.AnimationId = v22.id
            t2[p11][v21].weight = v22.weight
            t2[p11].count = t2[p11].count + 1
            t2[p11].totalWeight = t2[p11].totalWeight + v22.weight
        end
    end

    for _, v23 in pairs(t2) do
        for i = 1, v23.count do
            if t1[v23[i].anim.AnimationId] == nil then
                Humanoid:LoadAnimation(v23[i].anim)
                t1[v23[i].anim.AnimationId] = true
            end
        end
    end
end

function configureAnimationSetOld(p18, p19) -- line: 349
    -- upvalues: Humanoid (copy), t2 (copy)
    if t2[p18] ~= nil then
        for _, v24 in pairs(t2[p18].connections) do
            v24:disconnect()
        end
    end

    t2[p18] = {}
    t2[p18].count = 0
    t2[p18].totalWeight = 0
    t2[p18].connections = {}

    local v25 = true

    local function v26() -- line: 362
        -- upvalues: v25 (ref)
        v25 = game:GetService("StarterPlayer").AllowCustomAnimations
    end

    if not pcall(v26) then
        v25 = true
    end

    local v27 = script:FindFirstChild(p18)

    if v25 and v27 ~= nil then
        table.insert(t2[p18].connections, v27.ChildAdded:connect(function(_) -- line: 370
            -- upvalues: p18 (copy), p19 (copy)
            configureAnimationSet(p18, p19)
        end))
        table.insert(t2[p18].connections, v27.ChildRemoved:connect(function(_) -- line: 371
            -- upvalues: p18 (copy), p19 (copy)
            configureAnimationSet(p18, p19)
        end))

        local n2 = 1

        for _, child in pairs(v27:GetChildren()) do
            if child:IsA("Animation") then
                table.insert(t2[p18].connections, child.Changed:connect(function(_) -- line: 375
                    -- upvalues: p18 (copy), p19 (copy)
                    configureAnimationSet(p18, p19)
                end))
                t2[p18][n2] = {}
                t2[p18][n2].anim = child

                local Weight = child:FindFirstChild("Weight")

                if Weight ~= nil then
                    t2[p18][n2].weight = Weight.Value
                else
                    t2[p18][n2].weight = 1
                end

                t2[p18].count = t2[p18].count + 1
                t2[p18].totalWeight = t2[p18].totalWeight + t2[p18][n2].weight
                n2 += 1
            end
        end
    end

    if t2[p18].count <= 0 then
        for v31, v32 in pairs(p19) do
            t2[p18][v31] = {}
            t2[p18][v31].anim = Instance.new("Animation")
            t2[p18][v31].anim.Name = p18
            t2[p18][v31].anim.AnimationId = v32.id
            t2[p18][v31].weight = v32.weight
            t2[p18].count = t2[p18].count + 1
            t2[p18].totalWeight = t2[p18].totalWeight + v32.weight
        end
    end

    for _, v33 in pairs(t2) do
        for i = 1, v33.count do
            Humanoid:LoadAnimation(v33[i].anim)
        end
    end
end

function scriptChildModified(p23) -- line: 414
    -- upvalues: t3 (copy)
    local v34 = t3[p23.Name]

    if v34 ~= nil then
        configureAnimationSet(p23.Name, v34)
    end
end

script.ChildAdded:connect(scriptChildModified)
script.ChildRemoved:connect(scriptChildModified)

local Animator = if Humanoid then Humanoid:FindFirstChildOfClass("Animator") else nil

if Animator then
    local PlayingAnimationTracks = Animator:GetPlayingAnimationTracks()

    for _, v35 in ipairs(PlayingAnimationTracks) do
        v35:Stop(0)
        v35:Destroy()
    end
end

for v36, v37 in pairs(t3) do
    configureAnimationSet(v36, v37)
end

local v38 = "None"
local n3 = 0
local n4 = 0
local v39 = false

function stopAllAnimations() -- line: 455
    -- upvalues: v4 (ref), v5 (ref), track (ref), v6 (ref), track2 (ref), v7 (ref), t4 (copy), v39 (ref)
    local v40 = v4

    if t4[v40] ~= nil and t4[v40] == false then
        v40 = "idle"
    end

    if v39 then
        v39 = false
        v40 = "idle"
    end

    v4 = ""
    v5 = nil

    if v6 ~= nil then
        v6:disconnect()
    end

    if track ~= nil then
        track:Stop()
        track:Destroy()
        track = nil
    end

    if v7 ~= nil then
        v7:disconnect()
    end

    if track2 ~= nil then
        track2:Stop()
        track2:Destroy()
        track2 = nil
    end

    return v40
end

function getHeightScale() -- line: 494
    -- upvalues: Humanoid (copy), getRigScale (copy), ScaleDampeningPercent (ref)
    if not Humanoid or not Humanoid.AutomaticScalingEnabled then
        return getRigScale()
    end

    local v41 = Humanoid.HipHeight / 2

    if ScaleDampeningPercent == nil then
        ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent")
    end

    if ScaleDampeningPercent ~= nil then
        v41 = 1 + (Humanoid.HipHeight - 2) * ScaleDampeningPercent.Value / 2
    end

    return v41
end

local function rootMotionCompensation(p24) -- line: 514
    return p24 * 1.25 / getHeightScale()
end

local function setRunSpeed(p25) -- line: 522
    -- upvalues: track (ref), track2 (ref)
    local v42 = p25 * 1.25 / getHeightScale()
    local v43, v44, v45

    if v42 <= 0.5 then
        v43 = 1
        v44 = 1E-04
        v45 = v42 / 0.5
    elseif v42 < 1 then
        v44 = (v42 - 0.5) / 0.5
        v43 = 1 - v44
        v45 = 1
    else
        v43 = 1E-04
        v44 = 1
        v45 = v42 / 1
    end

    track:AdjustWeight(v43)
    track2:AdjustWeight(v44)
    track:AdjustSpeed(v45)
    track2:AdjustSpeed(v45)
end

function setAnimationSpeed(p26) -- line: 548
    -- upvalues: v4 (ref), track (ref), n1 (ref), setRunSpeed (copy)
    if v4 == "walk" then
        setRunSpeed(p26)
    elseif p26 ~= n1 then
        n1 = p26
        track:AdjustSpeed(n1)
    end
end

function keyFrameReachedFunc(p27) -- line: 559
    -- upvalues: Humanoid (copy), v4 (ref), track (ref), n1 (ref), track2 (ref), t4 (copy), v39 (ref)
    if p27 ~= "End" then
        return
    end

    if v4 == "walk" then
        if track2.Looped ~= true then
            track2.TimePosition = 0
        end

        if track.Looped ~= true then
            track.TimePosition = 0
        end
    else
        local v47 = v4

        if t4[v47] ~= nil and t4[v47] == false then
            v47 = "idle"
        end

        if v39 then
            if track.Looped then
                return
            end

            v39 = false
            v47 = "idle"
        end

        local v48 = n1

        playAnimation(v47, 0.15, Humanoid)
        setAnimationSpeed(v48)
    end
end

function rollAnimation(p28) -- line: 592
    -- upvalues: t2 (copy)
    local v49 = math.random(1, t2[p28].totalWeight)
    local n5 = 1

    while t2[p28][n5].weight < v49 do
        v49 -= t2[p28][n5].weight
        n5 += 1
    end

    return n5
end

local function switchToAnim(p29, p30, p31, p32) -- line: 603
    -- upvalues: v4 (ref), v5 (ref), track (ref), v6 (ref), n1 (ref), track2 (ref), v7 (ref), t2 (copy)
    if p29 == v5 then
        return
    end

    if track ~= nil then
        track:Stop(p31)
        track:Destroy()
    end

    if track2 ~= nil then
        track2:Stop(p31)
        track2:Destroy()
        track2 = nil
    end

    n1 = 1
    track = p32:LoadAnimation(p29)

    local track3 = track

    track3.Priority = Enum.AnimationPriority.Core
    track:Play(p31)
    v4 = p30
    v5 = p29

    if v6 ~= nil then
        v6:disconnect()
    end

    v6 = track.KeyframeReached:connect(keyFrameReachedFunc)

    if p30 ~= "walk" then
        return
    end

    local run = rollAnimation("run")

    track2 = p32:LoadAnimation(t2.run[run].anim)

    local track4 = track2

    track4.Priority = Enum.AnimationPriority.Core
    track2:Play(p31)

    if v7 ~= nil then
        v7:disconnect()
    end

    v7 = track2.KeyframeReached:connect(keyFrameReachedFunc)
end

function playAnimation(p33, p34, p35) -- line: 652
    -- upvalues: t2 (copy), v39 (ref), switchToAnim (copy)
    local v50 = rollAnimation(p33)

    switchToAnim(t2[p33][v50].anim, p33, p34, p35)
    v39 = false
end

function playEmote(p36, p37, p38) -- line: 660
    -- upvalues: v39 (ref), switchToAnim (copy)
    switchToAnim(p36, p36.Name, p37, p38)
    v39 = true
end

local v51 = ""
local track3, anim, v52

function toolKeyFrameReachedFunc(p39) -- line: 673
    -- upvalues: Humanoid (copy), v51 (ref)
    if p39 == "End" then
        playToolAnimation(v51, 0, Humanoid)
    end
end

function playToolAnimation(p40, p41, p42, p43) -- line: 680
    -- upvalues: t2 (copy), v51 (ref), track3 (ref), anim (ref), v52 (ref)
    local v53 = rollAnimation(p40)
    local anim2 = t2[p40][v53].anim

    if anim == anim2 then
        return
    end

    local v54

    if track3 ~= nil then
        track3:Stop()
        v54 = 0
        track3:Destroy()
    else
        v54 = p41
    end

    track3 = p42:LoadAnimation(anim2)

    if p43 then
        track3.Priority = p43
    end

    track3:Play(v54)
    v51 = p40
    anim = anim2
    v52 = track3.KeyframeReached:connect(toolKeyFrameReachedFunc)
end

function stopToolAnimations() -- line: 707
    -- upvalues: v51 (ref), track3 (ref), anim (ref), v52 (ref)
    local v55 = v51

    if v52 ~= nil then
        v52:disconnect()
    end

    v51 = ""
    anim = nil

    if track3 ~= nil then
        track3:Stop()
        track3:Destroy()
        track3 = nil
    end

    return v55
end

function onRunning(p44) -- line: 729
    -- upvalues: Humanoid (copy), v1 (ref), v4 (ref), t4 (copy), GroundSensor (ref), v8 (ref), v39 (ref)
    local v56 = getHeightScale()
    local Magnitude, Magnitude2
    local v57 = p44

    if GroundSensor ~= nil and Humanoid.EvaluateStateMachine == false then
        local RootPart = Humanoid.RootPart
        local SensedPart = GroundSensor.SensedPart

        if SensedPart then
            local VelocityAtPosition = SensedPart:GetVelocityAtPosition(GroundSensor.HitFrame.Position)
            local AssemblyLinearVelocity = RootPart.AssemblyLinearVelocity

            Magnitude = Vector3.new(AssemblyLinearVelocity.X - VelocityAtPosition.X, 0, AssemblyLinearVelocity.Z - VelocityAtPosition.Z).Magnitude
            Magnitude2 = v8.MovingDirection.Magnitude

            if Magnitude2 < 0.1 then
                Magnitude = 0
                Magnitude2 = 0
            elseif Magnitude2 > 1 then
                Magnitude2 = 1
            end

            v57 = Magnitude * Magnitude2
        end
    end

    if (v39 and Humanoid.MoveDirection == Vector3.new(0, 0, 0) and Humanoid.WalkSpeed / v56 or 0.75) * v56 < v57 then
        playAnimation("walk", 0.2, Humanoid)
        setAnimationSpeed(v57 / 16)
        v1 = "Running"
    elseif t4[v4] == nil and not v39 then
        playAnimation("idle", 0.2, Humanoid)
        v1 = "Standing"
    end
end

function onDied() -- line: 772
    -- upvalues: v1 (ref)
    v1 = "Dead"
end

function onJumping() -- line: 776
    -- upvalues: Humanoid (copy), v1 (ref), n4 (ref)
    playAnimation("jump", 0.1, Humanoid)
    n4 = 0.31
    v1 = "Jumping"
end

function onClimbing(p45) -- line: 782
    -- upvalues: Humanoid (copy), v1 (ref)
    local v60 = p45 / getHeightScale()

    playAnimation("climb", 0.1, Humanoid)
    setAnimationSpeed(v60 / 5)
    v1 = "Climbing"
end

function onGettingUp() -- line: 790
    -- upvalues: v1 (ref)
    v1 = "GettingUp"
end

function onFreeFall() -- line: 794
    -- upvalues: Humanoid (copy), v1 (ref), n4 (ref)
    if n4 <= 0 then
        playAnimation("fall", 0.2, Humanoid)
    end

    v1 = "FreeFall"
end

function onFallingDown() -- line: 801
    -- upvalues: v1 (ref)
    v1 = "FallingDown"
end

function onSeated() -- line: 805
    -- upvalues: v1 (ref)
    v1 = "Seated"
end

function onPlatformStanding() -- line: 809
    -- upvalues: v1 (ref)
    v1 = "PlatformStanding"
end

function onSwimming(p46) -- line: 816
    -- upvalues: Humanoid (copy), v1 (ref)
    local v61 = p46 / getHeightScale()

    if not (v61 > 1) then
        playAnimation("swimidle", 0.4, Humanoid)
        v1 = "Standing"

        return
    end

    playAnimation("swim", 0.4, Humanoid)
    setAnimationSpeed(v61 / 10)
    v1 = "Swimming"
end

function animateTool() -- line: 829
    -- upvalues: Humanoid (copy), v38 (ref)
    if v38 == "None" then
        playToolAnimation("toolnone", 0.1, Humanoid, Enum.AnimationPriority.Idle)
    elseif v38 == "Slash" then
        playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action)
    elseif v38 == "Lunge" then
        playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action)
    end
end

function getToolAnim(p47) -- line: 846
    for _, child in ipairs(p47:GetChildren()) do
        if child.Name == "toolanim" and child.className == "StringValue" then
            return child
        end
    end

    return nil
end

local n6 = 0

function stepAnimate(p48) -- line: 857
    -- upvalues: Parent (copy), Humanoid (copy), v1 (ref), v38 (ref), n3 (ref), n4 (ref), anim (ref), n6 (ref)
    local v62 = p48 - n6

    n6 = p48

    if n4 > 0 then
        n4 -= v62
    end

    if v1 == "FreeFall" and n4 <= 0 then
        playAnimation("fall", 0.2, Humanoid)

        local Tool = Parent:FindFirstChildOfClass("Tool")

        if Tool and Tool:FindFirstChild("Handle") then
            local v63 = getToolAnim(Tool)

            if v63 then
                v38 = v63.Value
                v63.Parent = nil
                n3 = p48 + 0.3
            end

            if n3 < p48 then
                n3 = 0
                v38 = "None"
            end

            animateTool()
        else
            stopToolAnimations()
            v38 = "None"
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
            local v65 = getToolAnim(Tool)

            if v65 then
                v38 = v65.Value
                v65.Parent = nil
                n3 = p48 + 0.3
            end

            if n3 < p48 then
                n3 = 0
                v38 = "None"
            end

            animateTool()
        else
            stopToolAnimations()
            v38 = "None"
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

if not v3 then
    game:GetService("Players").LocalPlayer.Chatted:connect(function(p49) -- line: 924
        -- upvalues: Humanoid (copy), v1 (ref), t4 (copy)
        local v67 = if string.sub(p49, 1, 3) == "/e " then string.sub(p49, 4) elseif string.sub(p49, 1, 7) == "/emote " then string.sub(p49, 8) else ""

        if v1 == "Standing" and t4[v67] ~= nil then
            playAnimation(v67, 0.1, Humanoid)
        end
    end)
end

script:WaitForChild("PlayEmote").OnInvoke = function(p50) -- line: 939
    -- upvalues: Humanoid (copy), v1 (ref), track (ref), t4 (copy)
    if v1 == "Standing" then
        if t4[p50] ~= nil then
            playAnimation(p50, 0.1, Humanoid)
        else
            if typeof(p50) ~= "Instance" or not p50:IsA("Animation") then
                return false
            end

            playEmote(p50, 0.1, Humanoid)
        end

        return true, track
    end
end

if Parent.Parent ~= nil then
    playAnimation("idle", 0.1, Humanoid)
    v1 = "Standing"
end

while Parent.Parent ~= nil do
    local _, v68 = wait(0.1)

    stepAnimate(v68)
end
