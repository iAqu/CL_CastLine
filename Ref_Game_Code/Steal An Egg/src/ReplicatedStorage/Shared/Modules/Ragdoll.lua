-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Ragdoll = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).Ragdoll
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local RagdollJoints = require(ReplicatedStorage.Shared.Modules.RagdollJoints)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local t = require(ReplicatedStorage.Packages.t)
local v1 = if RunService:IsServer() then require(ServerScriptService.Library.Modules.ClientCharacterAction) else nil
local Physics, GettingUp = Enum.HumanoidStateType.Physics, Enum.HumanoidStateType.GettingUp
local v2 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))

local function v3(p1) -- line: 32
    -- upvalues: v2 (copy)
    if typeof(p1) == "Vector3" then
        return v2(p1.X) and v2(p1.Y) and v2(p1.Z)
    end

    return false
end

local t1 = {}
local n1 = 0
local t2

local function heldBody(p2) -- line: 46
    return p2:FindFirstChildOfClass("Humanoid")
end

local function isLimp(p3) -- line: 50
    -- upvalues: Physics (copy)
    return p3:GetState() == Physics
end

local function goLimp(p4, p5) -- line: 54
    -- upvalues: Physics (copy)
    local RootPart = p4.RootPart

    if RootPart then
        p4:ChangeState(Physics)

        if p5 and typeof(p5) == "Vector3" then
            RootPart:ApplyImpulse(p5)
        end
    end
end

local function standUp(p6) -- line: 66
    -- upvalues: GettingUp (copy)
    local RootPart = p6.RootPart

    if RootPart then
        p6:ChangeState(GettingUp)
        RootPart.CanCollide = true
    end
end

local function beginFor(p7, p8, p9, p10) -- line: 77
    -- upvalues: Players (copy), Physics (copy), v1 (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p7)

    if PlayerFromCharacter then
        assert(v1, "ClientCharacterAction is only available on the server").BeginRagdoll(PlayerFromCharacter, p7, p9, p10)
    else
        local RootPart = p8.RootPart

        if RootPart then
            p8:ChangeState(Physics)

            if p10 and typeof(p10) == "Vector3" then
                RootPart:ApplyImpulse(p10)
            end
        end
    end
end

local function endFor(p11, p12) -- line: 87
    -- upvalues: Players (copy), GettingUp (copy), v1 (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p11)

    if PlayerFromCharacter then
        assert(v1, "ClientCharacterAction is only available on the server").EndRagdoll(PlayerFromCharacter, p11)
    elseif p12 then
        local RootPart = p12.RootPart

        if RootPart then
            p12:ChangeState(GettingUp)
            RootPart.CanCollide = true
        end
    end
end

local function captureRig(p13, p14) -- line: 98
    local t3 = {}
    local RootPart = p14.RootPart

    if RootPart ~= nil then
        for _, descendant in p13:GetDescendants() do
            if descendant:IsA("Motor6D") then
                local Part1 = descendant.Part1

                if Part1 ~= nil and Part1.Parent == p13 then
                    t3[Part1] = (Part1.Position - RootPart.Position).Magnitude
                end
            end
        end
    end

    return t3
end

local function reloadIfTorn(p15, p16) -- line: 116
    -- upvalues: Ragdoll (copy), Players (copy), t1 (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p15)

    if PlayerFromCharacter == nil then
        return
    end

    task.delay(Ragdoll.RIG_CHECK_DELAY, function() -- line: 121
        -- upvalues: p15 (copy), p16 (copy), PlayerFromCharacter (copy), Ragdoll (copy), t1 (copy)
        local Humanoid = p15:FindFirstChildOfClass("Humanoid")
        local RootPart = if Humanoid then Humanoid.RootPart else nil

        if PlayerFromCharacter.Character == p15 and Humanoid ~= nil and RootPart ~= nil and not (Humanoid.Health <= 0) and t1[p15] == nil then
            local n2 = 0

            for _, v4 in p16 do
                n2 = math.max(n2, v4)
            end

            for v5 in p16 do
                local v6 = (v5.Position - RootPart.Position).Magnitude > n2 * Ragdoll.RIG_TORN_REACH

                if v5.Parent ~= p15 or v6 then
                    PlayerFromCharacter:LoadCharacterAsync()

                    return
                end
            end
        end
    end)
end

t2 = {
    ClientRagdollRemote = Remotes.Limpness.WriteLimpness,
    IsRagdolled = function(p17) -- IsRagdolled | line: 150
        -- upvalues: t (copy), Physics (copy), t1 (copy)
        t.strict(t.instanceIsA("Model"))(p17)

        local Humanoid = p17:FindFirstChildOfClass("Humanoid")

        if t1[p17] ~= nil then
            return true
        end

        return Humanoid ~= nil and Humanoid:GetState() == Physics
    end,
    Ragdoll = function(p18) -- Ragdoll | line: 158
        -- upvalues: Ragdoll (copy), Players (copy), RagdollJoints (copy), Physics (copy), v1 (copy)
        local Humanoid = p18:WaitForChild("Humanoid")

        if Humanoid:GetState() == Physics then
            return
        end

        Humanoid.BreakJointsOnDeath = false

        local PLAYER_RAGDOLL_SECONDS = Ragdoll.PLAYER_RAGDOLL_SECONDS
        local PlayerFromCharacter = Players:GetPlayerFromCharacter(p18)

        if PlayerFromCharacter then
            assert(v1, "ClientCharacterAction is only available on the server").BeginRagdoll(PlayerFromCharacter, p18, PLAYER_RAGDOLL_SECONDS, nil)
        elseif Humanoid.RootPart then
            Humanoid:ChangeState(Physics)
        end

        RagdollJoints.Bind(p18)
    end,
    NpcRagdoll = function(p19, p20) -- NpcRagdoll | line: 169
        -- upvalues: RagdollJoints (copy), Physics (copy), GettingUp (copy)
        local Humanoid = p19:FindFirstChild("Humanoid")

        if not Humanoid then
            return
        end

        Humanoid.BreakJointsOnDeath = false

        if Humanoid:GetState() == Physics then
            return
        end

        Humanoid.PlatformStand = true
        Humanoid:ChangeState(Physics)
        RagdollJoints.Bind(p19)
        task.wait(p20)

        if p19 and p19.Parent then
            Humanoid.PlatformStand = false
            Humanoid:ChangeState(GettingUp)
            RagdollJoints.Release(p19)
        end
    end,
    TimedRagdoll = function(p21, p22, p23) -- TimedRagdoll | line: 194
        -- upvalues: Ragdoll (copy), Players (copy), RagdollJoints (copy), t (copy), Physics (copy), GettingUp (copy), v2 (copy), v3 (copy), t1 (copy), n1 (ref), v1 (copy), captureRig (copy)
        t.strict(v2)(p22)
        assert(p22 >= 0, "Ragdoll duration must be non-negative")
        t.strict(t.optional(v3))(p23)

        local Humanoid = p21:WaitForChild("Humanoid")

        Humanoid.BreakJointsOnDeath = false

        local v8 = Humanoid:GetState() == Physics
        local v9 = t1[p21]

        n1 += 1

        local v10 = n1

        t1[p21] = {
            Token = v10,
            OwnsConstraints = if v9 then v9.OwnsConstraints else not v8,
            Bound = if v9 then v9.Bound else v8,
            Rig = if v9 then v9.Rig else captureRig(p21, Humanoid)
        }

        local PlayerFromCharacter = Players:GetPlayerFromCharacter(p21)

        if PlayerFromCharacter then
            assert(v1, "ClientCharacterAction is only available on the server").BeginRagdoll(PlayerFromCharacter, p21, p22, p23)
        else
            local RootPart = Humanoid.RootPart

            if RootPart then
                Humanoid:ChangeState(Physics)

                if p23 and typeof(p23) == "Vector3" then
                    RootPart:ApplyImpulse(p23)
                end
            end
        end

        local v11 = math.min(Ragdoll.IMPULSE_LEAD, p22)

        task.wait(v11)

        local v12 = t1[p21]

        if v12 and v12.Token == v10 and v12.OwnsConstraints and not v12.Bound then
            v12.Bound = true
            RagdollJoints.Bind(p21)
        end

        task.wait(p22 - v11)

        local v13 = t1[p21]

        if not v13 or v13.Token ~= v10 then
            return
        end

        t1[p21] = nil

        local PlayerFromCharacter2 = Players:GetPlayerFromCharacter(p21)

        if PlayerFromCharacter2 then
            assert(v1, "ClientCharacterAction is only available on the server").EndRagdoll(PlayerFromCharacter2, p21)
        elseif Humanoid then
            local RootPart = Humanoid.RootPart

            if RootPart then
                Humanoid:ChangeState(GettingUp)
                RootPart.CanCollide = true
            end
        end

        if v13.OwnsConstraints then
            RagdollJoints.Release(p21)
        end

        local Rig = v13.Rig
        local PlayerFromCharacter3 = Players:GetPlayerFromCharacter(p21)

        if PlayerFromCharacter3 ~= nil then
            task.delay(Ragdoll.RIG_CHECK_DELAY, function() -- line: 121
                -- upvalues: p21 (copy), Rig (copy), PlayerFromCharacter3 (copy), Ragdoll (copy), t1 (copy)
                local Humanoid = p21:FindFirstChildOfClass("Humanoid")
                local RootPart = if Humanoid then Humanoid.RootPart else nil

                if PlayerFromCharacter3.Character == p21 and Humanoid ~= nil and RootPart ~= nil and not (Humanoid.Health <= 0) and t1[p21] == nil then
                    local n3 = 0

                    for _, v14 in Rig do
                        n3 = math.max(n3, v14)
                    end

                    for v15 in Rig do
                        local v16 = (v15.Position - RootPart.Position).Magnitude > n3 * Ragdoll.RIG_TORN_REACH

                        if v15.Parent ~= p21 or v16 then
                            PlayerFromCharacter3:LoadCharacterAsync()

                            return
                        end
                    end
                end
            end)
        end
    end,
    TimedRagdollAsync = function(p24, p25, p26) -- TimedRagdollAsync | line: 251
        -- upvalues: t2 (ref)
        task.spawn(t2.TimedRagdoll, p24, p25, p26)
    end,
    ApplyClientRagdoll = function(p27, p28) -- ApplyClientRagdoll | line: 255
        -- upvalues: RagdollJoints (copy), Physics (copy)
        local Humanoid = p27:FindFirstChildOfClass("Humanoid")

        assert(Humanoid ~= nil, (("%* has no Humanoid to ragdoll"):format((p27:GetFullName()))))
        Humanoid.BreakJointsOnDeath = false

        local v19 = Humanoid:GetState() == Physics
        local RootPart = Humanoid.RootPart

        if RootPart then
            Humanoid:ChangeState(Physics)

            if p28 and typeof(p28) == "Vector3" then
                RootPart:ApplyImpulse(p28)
            end
        end

        if not v19 then
            RagdollJoints.Bind(p27)
        end
    end,
    ClearClientRagdoll = function(p29) -- ClearClientRagdoll | line: 270
        -- upvalues: RagdollJoints (copy), GettingUp (copy)
        local Humanoid = p29:FindFirstChildOfClass("Humanoid")

        assert(Humanoid ~= nil, (("%* has no Humanoid to stand up"):format((p29:GetFullName()))))

        local RootPart = Humanoid.RootPart

        if RootPart then
            Humanoid:ChangeState(GettingUp)
            RootPart.CanCollide = true
        end

        RagdollJoints.Release(p29)
    end,
    Unragdoll = function(p30) -- Unragdoll | line: 278
        -- upvalues: Ragdoll (copy), Players (copy), RagdollJoints (copy), GettingUp (copy), t1 (copy), v1 (copy)
        local v22 = t1[p30]

        t1[p30] = nil

        local Humanoid = p30:FindFirstChildOfClass("Humanoid")
        local PlayerFromCharacter = Players:GetPlayerFromCharacter(p30)

        if PlayerFromCharacter then
            assert(v1, "ClientCharacterAction is only available on the server").EndRagdoll(PlayerFromCharacter, p30)
        elseif Humanoid then
            local RootPart = Humanoid.RootPart

            if RootPart then
                Humanoid:ChangeState(GettingUp)
                RootPart.CanCollide = true
            end
        end

        RagdollJoints.Release(p30)

        if not v22 then
            return
        end

        local Rig = v22.Rig
        local PlayerFromCharacter2 = Players:GetPlayerFromCharacter(p30)

        if PlayerFromCharacter2 == nil then
            return
        end

        task.delay(Ragdoll.RIG_CHECK_DELAY, function() -- line: 121
            -- upvalues: p30 (copy), Rig (copy), PlayerFromCharacter2 (copy), Ragdoll (copy), t1 (copy)
            local Humanoid = p30:FindFirstChildOfClass("Humanoid")
            local RootPart = if Humanoid then Humanoid.RootPart else nil

            if PlayerFromCharacter2.Character == p30 and Humanoid ~= nil and RootPart ~= nil and not (Humanoid.Health <= 0) and t1[p30] == nil then
                local n4 = 0

                for _, v23 in Rig do
                    n4 = math.max(n4, v23)
                end

                for v24 in Rig do
                    local v25 = (v24.Position - RootPart.Position).Magnitude > n4 * Ragdoll.RIG_TORN_REACH

                    if v24.Parent ~= p30 or v25 then
                        PlayerFromCharacter2:LoadCharacterAsync()

                        return
                    end
                end
            end
        end)
    end
}

return t2
