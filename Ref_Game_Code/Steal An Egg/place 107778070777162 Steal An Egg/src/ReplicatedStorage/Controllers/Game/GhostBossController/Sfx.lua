-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)
local GhostBoss = require(ReplicatedStorage.Shared.Util.GhostBoss)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Attributes, Phases = GhostBoss.Attributes, GhostBoss.Phases
local t1 = {
    "Moan1",
    "Moan2",
    "Moan3"
}
local t2 = {
    "Hurt1",
    "Hurt2",
    "Hurt3"
}
local v1 = Random.new()
local t3 = {}

t3.__index = t3

local function template(p1) -- line: 61
    -- upvalues: ReplicatedStorage (copy), GhostBoss (copy)
    local v2 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local Sounds = if v2 then v2:FindFirstChild("Sounds") else nil
    local v3 = if Sounds then Sounds:FindFirstChild(p1) else nil

    return if v3 and v3:IsA("Sound") then v3 else nil
end

local function play(p2, p3, p4) -- line: 68
    -- upvalues: ReplicatedStorage (copy), Audio (copy), GhostBoss (copy)
    local v4 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local Sounds = if v4 then v4:FindFirstChild("Sounds") else nil
    local v5 = if Sounds then Sounds:FindFirstChild(p2) else nil

    if not (v5 and v5:IsA("Sound")) then
        v5 = nil
    end

    if v5 == nil then
        return nil
    end

    return Audio.Play(v5, p3, {
        SoundGroup = "Gameplay",
        Looped = p4,
        MaxDistance = v5.RollOffMaxDistance
    })
end

local function fadeOut(p5, p6) -- line: 80
    -- upvalues: Audio (copy)
    if p5 ~= nil and p5.Parent ~= nil then
        Audio.FadeTo(p5, {
            Volume = 0,
            Seconds = p6
        }).Completed:Once(function() -- line: 84
            -- upvalues: p5 (copy)
            p5:Destroy()
        end)
    end
end

local function pick(p7, p8) -- line: 89
    -- upvalues: v1 (copy)
    local v6 = p7[v1:NextInteger(1, #p7)]

    if v6 == p8 and #p7 > 1 then
        v6 = p7[table.find(p7, v6) % #p7 + 1]
    end

    return v6
end

local function numberAttribute(p9, p10, p11) -- line: 98
    local Attribute = p9:GetAttribute(p10)

    if type(Attribute) == "number" then
        return Attribute
    end

    return p11
end

local function moanDelay() -- line: 103
    -- upvalues: v1 (copy)
    return v1:NextNumber(7, 12)
end

function t3.Swing(p12) -- line: 111
    -- upvalues: play (copy)
    return play("Swing", p12)
end

function t3.Charge(p13) -- line: 115
    -- upvalues: play (copy)
    return play("Charge", p13)
end

function t3.new(p14, p15, p16) -- line: 119
    -- upvalues: ReplicatedStorage (copy), Audio (copy), GhostBoss (copy), Trove (copy), Attributes (copy), Phases (copy), v1 (copy), t3 (copy)
    local v7 = Trove.new()
    local t4 = {
        Ambience = nil,
        Voiced = nil,
        Struggling = false,
        StruggleAt = (-1e999),
        VoiceAt = (-1e999),
        LastMoan = nil,
        LastHurt = nil,
        Destroyed = false,
        State = p14,
        Trove = v7,
        Emitter = p15,
        Phase = p16
    }
    local Attribute = p14:GetAttribute(Attributes.Health)

    t4.CryHealth = if type(Attribute) ~= "number" then 0 else Attribute

    local Attribute2 = p14:GetAttribute(Attributes.AttackSerial)

    t4.AttackSerial = if type(Attribute2) ~= "number" then 0 else Attribute2
    t4.AttackPhase = p14:GetAttribute(Attributes.AttackPhase)
    t4.NextMoanAt = os.clock() + v1:NextNumber(7, 12)

    local v8 = setmetatable(t4, t3)

    v7:Connect(p15.Destroying, function() -- line: 141
        -- upvalues: v8 (copy)
        v8:Destroy()
    end)

    if p16 == Phases.Spawning or p16 == Phases.Alive then
        local v9 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
        local Sounds = if v9 then v9:FindFirstChild("Sounds") else nil
        local Ambience = if Sounds then Sounds:FindFirstChild("Ambience") else nil

        if not (Ambience and Ambience:IsA("Sound")) then
            Ambience = nil
        end

        local v10 = if Ambience == nil then nil else Audio.Play(Ambience, p15, {
            Looped = true,
            SoundGroup = "Gameplay",
            MaxDistance = Ambience.RollOffMaxDistance
        })

        if v10 then
            local Volume = v10.Volume

            v10.Volume = 0
            Audio.FadeTo(v10, {
                Seconds = 2.5,
                Volume = Volume
            })
            v7:Add(v10)
            v8.Ambience = v10
        end
    end

    return v8
end

function t3.Voice(p17, p18) -- line: 159
    -- upvalues: ReplicatedStorage (copy), Audio (copy), GhostBoss (copy), fadeOut (copy)
    fadeOut(p17.Voiced, 0.25)
    p17.VoiceAt = os.clock()

    local Emitter = p17.Emitter
    local v11 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local Sounds = if v11 then v11:FindFirstChild("Sounds") else nil
    local v12 = if Sounds then Sounds:FindFirstChild(p18) else nil

    if not (v12 and v12:IsA("Sound")) then
        v12 = nil
    end

    if v12 ~= nil then
        p17.Voiced = Audio.Play(v12, Emitter, {
            Looped = nil,
            SoundGroup = "Gameplay",
            MaxDistance = v12.RollOffMaxDistance
        })
    else
        p17.Voiced = nil
    end
end

function t3.Spawn(p19) -- line: 165
    -- upvalues: v1 (copy)
    p19:Voice("Spawn")
    p19.NextMoanAt = os.clock() + v1:NextNumber(7, 12)
end

function t3.Hush(p20, p21) -- line: 170
    -- upvalues: fadeOut (copy)
    fadeOut(p20.Ambience, p21)
    fadeOut(p20.Voiced, p21)
    p20.Ambience = nil
    p20.Voiced = nil
end

function t3.Step(p22, p23) -- line: 177
    -- upvalues: GhostBoss (copy), Attributes (copy), Phases (copy), t1 (copy), t2 (copy), v1 (copy), t3 (copy)
    if p22.Destroyed then
        return
    end

    if p23 ~= p22.Phase then
        p22.Phase = p23

        if p23 == Phases.Capturing or p23 == Phases.Defeated then
            p22:Hush(0.8)
        elseif p23 == Phases.Escaped then
            p22:Hush(1.6)
        end
    end

    if p23 == Phases.Alive then
        local State = p22.State
        local elapsed = os.clock()
        local AttackSerial = Attributes.AttackSerial
        local AttackSerial2 = p22.AttackSerial
        local Attribute = State:GetAttribute(AttackSerial)

        if type(Attribute) ~= "number" then
            Attribute = AttackSerial2
        end

        if p22.AttackSerial < Attribute then
            p22.AttackSerial = Attribute
            t3.Swing(p22.Emitter)
        end

        local Attribute2 = State:GetAttribute(Attributes.AttackPhase)

        if Attribute2 ~= p22.AttackPhase then
            p22.AttackPhase = Attribute2

            if Attribute2 == GhostBoss.AttackPhases.Windup then
                t3.Charge(p22.Emitter)
            end
        end

        local Attribute3 = State:GetAttribute(Attributes.Suckers)
        local v13 = type(Attribute3) == "string" and Attribute3 ~= ""

        if v13 and not p22.Struggling and elapsed - p22.StruggleAt >= 6 then
            p22.StruggleAt = elapsed
            p22:Voice("Struggle")
        end

        p22.Struggling = v13

        local Attribute4 = State:GetAttribute(Attributes.MaxHealth)

        if type(Attribute4) ~= "number" then
            Attribute4 = 1
        end

        local v14 = math.max(Attribute4, 1)
        local Attribute5 = State:GetAttribute(Attributes.Health)

        if type(Attribute5) ~= "number" then
            Attribute5 = v14
        end

        if p22.CryHealth < Attribute5 then
            p22.CryHealth = Attribute5
        elseif (p22.CryHealth - Attribute5) / v14 >= 0.12 and elapsed - p22.VoiceAt >= 2.5 then
            p22.CryHealth = Attribute5

            local LastHurt = p22.LastHurt
            local v15 = t2[v1:NextInteger(1, #t2)]

            if v15 == LastHurt and #t2 > 1 then
                v15 = t2[table.find(t2, v15) % #t2 + 1]
            end

            p22.LastHurt = v15
            p22:Voice(v15)
        end

        local Voiced = p22.Voiced
        local v16 = Voiced == nil or Voiced.Parent == nil or not Voiced.IsPlaying

        if not v13 and v16 and p22.NextMoanAt <= elapsed then
            local LastMoan = p22.LastMoan
            local v17 = t1[v1:NextInteger(1, #t1)]

            if v17 == LastMoan and #t1 > 1 then
                v17 = t1[table.find(t1, v17) % #t1 + 1]
            end

            p22.LastMoan = v17
            p22.NextMoanAt = elapsed + v1:NextNumber(7, 12)
            p22:Voice(v17)
        end
    end
end

function t3.Destroy(p24) -- line: 240
    if p24.Destroyed then
        return
    end

    p24.Destroyed = true

    local Voiced = p24.Voiced

    p24.Voiced = nil
    p24.Ambience = nil

    if Voiced then
        Voiced:Destroy()
    end

    p24.Trove:Destroy()
end

return t3
