-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Effects = require(script.Parent.Parent.Fishing.Effects)
local Actors = require(script.Parent.Actors)
local Director = require(script.Parent.Director)
local AnimeFX = require(script.Parent.AnimeFX)
local WorldFX = require(script.Parent.WorldFX)
local Rival = require(script.Parent.Rival)
local Reach = require(script.Parent.Reach)
local t1 = {}
local v1 = Color3.fromRGB(90, 200, 255)
local t2 = {
    "Dock",
    "Snore",
    "Bubbles",
    "Splash",
    "Pop",
    "Whoosh",
    "Clank",
    "Reel",
    "BooWomp",
    "Laugh",
    "Luck1",
    "Luck2",
    "Luck4",
    "Lightning",
    "CastSwing",
    "CastLine",
    "BaitFlight",
    "Tick",
    "AnimeImpact",
    "Flex",
    "Bite",
    "Scream"
}
local new = Vector3.new
local with = Actors.with
local lookAt = CFrame.lookAt
local t3 = {}
local t4 = {}
local t5 = {
    RH = { 108, 0, -16 },
    RK = { -45, 0, 0 },
    LH = { 92, 0, 4 },
    LK = { -92, 0, 0 }
}
local v2 = with(t5, {
    Waist = { 16, 0, 0 },
    Neck = { 26, 0, 20 },
    RS = { 28, 0, 4 },
    RE = { 30, 0, 0 },
    LS = { 6, 0, -6 },
    LE = { 15, 0, 0 }
})
local v3 = with(t5, {
    RS = { 120, 0, 40 },
    LS = { 120, 0, -40 },
    RE = { 30, 0, 0 },
    LE = { 30, 0, 0 },
    Waist = { 8, 0, 0 },
    Neck = { 12, 0, 0 }
})
local t6 = {
    Root = { 12, 0, 0 },
    Waist = { 0, -25, 0 },
    RH = { 32, 0, 10 },
    RK = { -22, 0, 0 },
    LH = { -22, 0, -10 },
    LK = { -30, 0, 0 },
    RS = { 35, 30, 0 },
    RE = { 60, 0, 0 },
    LS = { 45, 0, 35 },
    LE = { 75, 0, 0 },
    Neck = { -10, 0, 0 }
}
local t7 = {
    Root = { 4, 0, 0 },
    Waist = { 0, -20, 0 },
    RH = { 20, 0, 10 },
    RK = { -12, 0, 0 },
    LH = { -12, 0, -10 },
    LK = { -15, 0, 0 },
    RS = { 20, 20, 0 },
    RE = { 85, 0, 0 },
    LS = { 70, 0, 30 },
    LE = { 60, 0, 0 },
    Neck = { 4, 0, 0 }
}
local v4 = with({
    Waist = { -18, 0, 0 },
    Neck = { -28, 0, 0 },
    RS = { 4, 0, 6 },
    RE = { 6, 0, 0 },
    LS = { 4, 0, -6 },
    LE = { 6, 0, 0 },
    RK = { -10, 0, 0 },
    LK = { -10, 0, 0 }
}, {
    RS = { 40, 10, 0 },
    RE = { 25, 0, 0 }
})
local t8 = {
    RS = { 140, 0, 10 },
    RE = { 15, 0, 0 },
    LS = { 70, 0, 25 },
    LE = { 95, 0, 0 },
    Waist = { 6, 0, 0 },
    Neck = { 6, 0, 0 },
    RH = { 18, 0, 6 },
    RK = { -18, 0, 0 },
    LH = { -14, 0, -6 },
    LK = { -10, 0, 0 }
}

local function loop(p1, p2, p3) -- line: 59
    -- upvalues: UIUtil (copy), t3 (copy)
    local v5 = UIUtil.sound(p1, p2, p3, 120)

    if v5 then
        v5.Looped = true
        table.insert(t3, v5)
    end

    return v5
end

local function stopSound(p4) -- line: 68
    if p4 and p4.Parent then
        p4:Destroy()
    end
end

local function connect(p5) -- line: 74
    -- upvalues: t4 (copy)
    table.insert(t4, p5)

    return p5
end

local function stage() -- line: 80
    -- upvalues: Canyon (copy), Actors (copy), Rival (copy), new (copy), lookAt (copy), loop (copy), stopSound (copy), connect (copy)
    local Deck = workspace.Map.World1.FishingDock.Deck
    local v6 = Deck.Position.Y + Deck.Size.Y / 2
    local v7 = Canyon.surface(0)
    local v9 = new(4, Canyon.surface(790), -790)
    local v10 = Actors.hero()
    local v11 = Actors.rival()

    if not v10 or not v11 then
        return nil
    end

    local v12, v13 = Actors.seat(v10)
    local v14 = v6 + v12
    local v15 = new(0, v6, 2.8)
    local v16 = Actors.chair(v15, Vector3.new(0, 0, -1), v14)
    local v20 = lookAt(new(0, v14 + v13, 2.8), (new(0, v14 + v13, -10)))

    Actors.place(v10, v20)

    local v21, v22 = Actors.giveRod(v10, 1)
    local v23 = Actors.standY(v11, v6)
    local v24 = lookAt(new(18, v23, 3), (new(18, v23, -10)))

    Actors.place(v11, v24)

    local v25, v26 = Actors.giveRod(v11, 10, true)

    Actors.show(v11, false)

    local v27 = Actors.standY(v10, v6) - v20.Position.Y
    local t9 = {
        hero = v10,
        rival = v11,
        chair = v16,
        chairAt = v15,
        deckTop = v6,
        waterY = v7,
        farPos = v9,
        heroPos = v20.Position,
        standUp = v27,
        stand = v20.Position + new(0, v27, 0),
        heroRod = v21,
        heroTip = v22,
        rivalRod = v25,
        rivalTip = v26,
        R = v24.Position,
        loop = loop,
        stopSound = stopSound,
        connect = connect
    }

    Rival.prepare(t9)

    return t9
end

local function tipChair(p6) -- line: 131
    -- upvalues: UIUtil (copy), Director (copy), WorldFX (copy)
    local Pivot = p6.chair:GetPivot()
    local v28 = CFrame.new(p6.chairAt + Vector3.new(0, 0, 1.25))

    Director.during(0.5, function(_, p8) -- line: 134
        -- upvalues: p6 (copy), Pivot (copy), v28 (copy)
        local v29 = 1.6755160819145565 * p8 * p8

        p6.chair:PivotTo(CFrame.new(0, 0, p8 * 1.4) * v28 * CFrame.Angles(v29, 0, 0) * v28:Inverse() * Pivot)
    end)
    UIUtil.sound("Clank", 0.7, 0.8)
    WorldFX.dust(p6.chairAt + Vector3.new(0, 0, 2.4), 0.4)
end

local function act1(p9) -- line: 142
    -- upvalues: RunService (copy), UIUtil (copy), Effects (copy), Actors (copy), Director (copy), AnimeFX (copy), WorldFX (copy), Reach (copy), v1 (copy), new (copy), with (copy), lookAt (copy), t3 (copy), t4 (copy), v2 (copy), v3 (copy), t6 (copy), t7 (copy), v4 (copy), tipChair (copy)
    local hero, heroPos, stand, standUp = p9.hero, p9.heroPos, p9.stand, p9.standUp
    local headHeight, head = hero.headHeight, hero.head
    local v30 = new(0, p9.waterY, -22)
    local v31, v32 = Actors.bobber(v30)
    local v33 = Actors.line(p9.heroTip, v32)
    local connection = RunService.RenderStepped:Connect(function() -- line: 152
        -- upvalues: v30 (copy), v31 (copy), Director (copy), new (copy)
        v31.Position = v30 + new(0, math.sin(Director.now() * 2.2) * 0.12, 0)
    end)

    table.insert(t4, connection)
    Actors.pose(hero, v2, 8, 1)
    AnimeFX.logo()
    AnimeFX.letterbox(true)

    local v36 = UIUtil.sound("Dock", 0, nil, 120)

    if v36 then
        v36.Looped = true
        table.insert(t3, v36)
    end

    p9.dock = v36

    if v36 then
        UIUtil.tween(v36, 1.4, {
            Volume = 0.5
        })
    end

    local v37 = UIUtil.sound("Snore", 0.22, nil, 120)

    if v37 then
        v37.Looped = true
        table.insert(t3, v37)
    end

    local v38 = WorldFX.noseBubble(head)
    local v39 = WorldFX.zzz(head)
    local v40 = heroPos + Vector3.new(0, 1, 0)

    Director.move(lookAt(v40 + Vector3.new(-6, 12, 26), v40 + Vector3.new(0, -5, -24)), lookAt(v40 + Vector3.new(-3, 4.5, 12), v40 + Vector3.new(0, -3, -22)), 4.4, {
        fov = 48,
        fov1 = 44
    })
    task.spawn(AnimeFX.cover, false, 1.2)
    Director.wait(3.6)

    local v42 = heroPos + new(0, headHeight - 0.1, 0)

    Director.move(lookAt(heroPos + new(4.4, headHeight + 0.2, -0.3), v42), lookAt(heroPos + new(3.6, headHeight + 0.15, -0.2), v42), 3, {
        fov = 34,
        blend = 1,
        focus = head
    })
    Director.wait(2.6)
    connection:Disconnect()
    Director.move(lookAt(new(3, p9.waterY + 1.6, -15.5), v30), lookAt(new(2.2, p9.waterY + 1.1, -16.8), v30), 2.4, {
        fov = 36,
        focus = v31
    })

    local t10 = {}

    local function once(p10, p11) -- line: 186
        -- upvalues: t10 (copy)
        if not t10[p10] then
            t10[p10] = true
            p11()
        end
    end

    Director.during(2.4, function(p12) -- line: 192
        -- upvalues: v30 (copy), v31 (copy), t10 (copy), UIUtil (copy), Effects (copy), Director (copy), AnimeFX (copy), WorldFX (copy), new (copy)
        local n1 = 0

        if p12 > 0.35 and p12 < 0.6 then
            n1 = math.sin((p12 - 0.35) / 0.25 * 3.141592653589793) * 0.35

            if not t10.a then
                t10.a = true
                Effects.ripple(v30, 4)
                UIUtil.sound("Bubbles", 0.4)
            end
        elseif p12 > 1 and p12 < 1.3 then
            n1 = math.sin((p12 - 1) / 0.3 * 3.141592653589793) * 0.5

            if not t10.b then
                t10.b = true
                Effects.ripple(v30, 5)
                UIUtil.sound("Bubbles", 0.5, 0.9)
            end
        elseif p12 > 1.75 then
            n1 = math.min((p12 - 1.75) * 14, 2.5)

            local function v52() -- line: 208
                -- upvalues: v30 (copy), UIUtil (copy), Director (copy), AnimeFX (copy), WorldFX (copy)
                Director.hitstop(0.07)
                WorldFX.splash(v30, 0.35)
                UIUtil.sound("Splash", 0.9)
                Director.shake(0.35)
                AnimeFX.sfx("PLUNK!", {
                    size = 0.1,
                    world = v30 + Vector3.new(0, 2, 0),
                    color = Color3.fromRGB(150, 220, 255),
                    color2 = Color3.fromRGB(60, 140, 230)
                })
            end

            if not t10.c then
                t10.c = true
                v52()
            end
        end

        v31.Position = v30 - new(0, n1, 0)
    end)

    if v37 and v37.Parent then
        v37:Destroy()
    end

    v39()

    local v53 = head.Position + head.CFrame.LookVector * 0.7

    Director.cut(lookAt(v53 + head.CFrame.LookVector * 2.4 + Vector3.new(-0.9, 0.1, 0), v53), {
        fov = 30,
        handheld = 0.5,
        focus = head
    })
    Director.wait(0.45)
    v38()
    Director.hitstop(0.08)
    UIUtil.sound("Pop", 1, 1.3)
    AnimeFX.sfx("POP!", {
        size = 0.12,
        world = v53 + Vector3.new(0, 0.6, 0),
        color = Color3.fromRGB(200, 240, 255),
        color2 = Color3.fromRGB(110, 190, 255)
    })
    Director.wait(0.35)
    Director.cut(lookAt(heroPos + Vector3.new(3.8, 1.6, -7.5), heroPos + Vector3.new(0, 2.6, 0)), {
        fov = 52,
        focus = hero.root
    })
    Actors.pose(hero, v3, 36, 0.5)
    UIUtil.sound("Whoosh", 0.6, 1.4)
    WorldFX.shock(head, 0.9)
    WorldFX.exclaim(head, "!?", 1.2)
    Director.punch(8)
    Director.shake(0.3)
    Director.wait(0.45)
    Actors.lean(hero, CFrame.new(0, standUp, -0.6), false, 14, 1)
    Actors.pose(hero, t6, 14, 0.8)
    task.spawn(tipChair, p9)
    Director.wait(0.5)
    WorldFX.dust(new(0, p9.deckTop, 2.2), 0.4)
    UIUtil.sound("Clank", 0.5, 1.3)
    Director.shake(0.2)
    Director.wait(0.3)

    local Reel = p9.heroRod:FindFirstChild("Reel")
    local Weld = Reel:FindFirstChildOfClass("Weld")
    local Weld2 = p9.heroRod.ReelKnob:FindFirstChildOfClass("Weld")
    local n2 = 0
    local n3 = 0

    table.insert(t4, (RunService.Heartbeat:Connect(function(p13) -- line: 257
        -- upvalues: Weld (copy), Weld2 (copy), n2 (ref), n3 (ref), Director (copy)
        n3 += p13 * Director.rate() * n2
        Weld2.C0 = Weld.C0 * CFrame.new(-0.3, math.sin(n3) * 0.2, math.cos(n3) * 0.2)
    end)))
    n2 = 14
    Reach.grab(hero, function() -- line: 263
        -- upvalues: Reel (copy), n3 (ref)
        return (Reel.CFrame * CFrame.new(-0.62, math.sin(n3) * 0.2, math.cos(n3) * 0.2)).Position
    end, 0.3)

    local v61 = WorldFX.aura(hero.root, v1)
    local v62 = UIUtil.sound("Reel", 1.6, 2.2, 120)

    if v62 then
        v62.Looped = true
        table.insert(t3, v62)
    end

    Director.rumble(0.16)
    Director.move(lookAt(stand + Vector3.new(-3, -2.2, -6.5), stand + Vector3.new(0, 1.4, 0)), lookAt(stand + Vector3.new(-2.6, -2, -5.8), stand + Vector3.new(0, 1.4, 0)), 2.4, {
        fov = 58,
        fov1 = 52,
        roll = -12,
        roll1 = -9,
        focus = hero.root
    })
    WorldFX.say(hero, "THIS IS IT... THIS IS THE ONE!!", 2.2, true)
    AnimeFX.sfx("WHIRRRR", {
        x = 0.2,
        y = 0.64,
        size = 0.1,
        rotation = 12,
        time = 2.2
    })

    local v63 = new(0, p9.waterY, -16)

    Director.during(2.4, function(p14) -- line: 274
        -- upvalues: p9 (copy), v31 (copy), v63 (copy), new (copy)
        v31.Position = new(0, p9.waterY - 0.4, -22):Lerp(v63, p14 / 2.4)
    end)
    Director.move(lookAt(new(2.6, p9.waterY + 4, -8.5), v63), lookAt(new(2, p9.waterY + 3.4, -9.5), v63), 1.4, {
        fov = 48,
        focus = v31
    })

    local n4 = 0

    Director.during(1.4, function(p15) -- line: 281
        -- upvalues: v31 (copy), v63 (copy), n4 (ref), Effects (copy), WorldFX (copy), new (copy)
        v31.Position = v63 + new(math.sin(p15 * 9) * 1.8, math.sin(p15 * 23) * 0.3 + -0.3, math.cos(p15 * 7) * 0.8)

        if not (n4 <= p15) then
            return
        end

        n4 = p15 + 0.14
        WorldFX.splash(v31.Position, 0.18)
        Effects.ripple(v31.Position, 5)
    end)
    n2 = 0
    Director.rumble(0)

    if v62 and v62.Parent then
        v62:Destroy()
    end

    v61(false)
    Director.cut(lookAt(stand + new(5.5, headHeight - 0.2, -8), stand + new(-1, headHeight - 1.2, -4)), {
        fov = 50,
        radius = 8,
        focus = hero.root
    })
    Actors.lean(hero, CFrame.new(0, standUp, -0.75) * CFrame.Angles(-0.12217304763960307, 0, 0), false, 10, 1)
    Director.wait(0.35)
    Reach.release(hero, 0.15)
    Actors.pose(hero, t7, 24, 0.55)
    Actors.lean(hero, CFrame.new(0, standUp, -0.5) * CFrame.Angles(0.13962634015954636, 0, 0), false, 18, 0.6)
    UIUtil.sound("Whoosh", 0.8, 0.9)

    local Position = v31.Position

    Director.hitstop(0.06)
    Director.shake(0.3)
    WorldFX.splash(Position, 0.45)
    Effects.ripple(Position, 6)
    UIUtil.sound("Splash", 0.6, 1.1)
    v31:Destroy()
    v33:Destroy()

    local v77 = Actors.shoe()
    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, 1.4, 0.55)
    Attachment.Parent = v77.PrimaryPart
    Actors.line(p9.heroTip, Attachment)

    local function bezier(p16, p17, p18, p19) -- line: 317
        return p16:Lerp(p17, p19):Lerp(p17:Lerp(p18, p19), p19)
    end

    Director.follow(function() -- line: 321
        -- upvalues: stand (copy), headHeight (copy), v77 (copy), new (copy), lookAt (copy)
        return lookAt(stand + Vector3.new(20, 4, -14), (stand + new(0, headHeight, 0)):Lerp(v77:GetPivot().Position, 0.5))
    end, 2.2, {
        fov = 58,
        fov1 = 50,
        radius = 14,
        focus = v77.PrimaryPart
    })
    Director.during(2.2, function(p20, p21) -- line: 325
        -- upvalues: p9 (copy), Position (copy), v77 (copy)
        local v79 = p9.heroTip.WorldPosition - Vector3.new(0, 2.6, 0)
        local v80 = Position - Vector3.new(0, 0.8, 0)
        local v81 = Position + Vector3.new(0, 7, 2)
        local v82 = 1 - (1 - p21) ^ 3
        local v83 = v80:Lerp(v81, v82):Lerp(v81:Lerp(v79, v82), v82)

        v77:PivotTo(CFrame.new(v83) * CFrame.Angles(p20 * 5 * (1 - p21), 1.2217304763960306, math.sin(p20 * 1.9) * 0.15))
    end)

    local v87 = v77:GetPivot().Position
    local v88 = Vector3.new(0, 0, 0)

    table.insert(t4, (RunService.RenderStepped:Connect(function(p22) -- line: 334
        -- upvalues: p9 (copy), v77 (copy), v87 (ref), v88 (ref), Director (copy)
        local v89 = math.min(p22, 0.05) * Director.rate()
        local v90 = p9.heroTip.WorldPosition - Vector3.new(0, 2.6, 0)

        v88 += ((v90 - v87) * 40 - v88 * 4) * v89
        v87 += v88 * v89
        v77:PivotTo(CFrame.new(v87) * CFrame.Angles(-v88.Z * 0.04, 1.2217304763960306, v88.X * 0.04))
    end)))
    Actors.pose(hero, v4, 6, 1)
    Actors.lean(hero, CFrame.new(0, standUp, -0.6), false, 6, 1)
    Director.cut(lookAt(stand + new(0.8, headHeight - 1, -6.5), stand + new(0, headHeight - 0.5, 0)), {
        fov = 46,
        handheld = 0,
        focus = head
    })
    AnimeFX.grade({
        Saturation = -0.75,
        Contrast = 0.25,
        Brightness = 0,
        TintColor = Color3.fromRGB(235, 235, 245)
    }, 0.05)

    if v36 then
        UIUtil.tween(v36, 0.2, {
            Volume = 0.12
        })
    end

    Director.wait(0.7)

    local v96 = AnimeFX.banner("Junk", "Soggy Boot", "1 in 1", 0.67)

    UIUtil.sound("BooWomp", 1)
    Actors.pose(hero, with(v4, {
        Neck = { -34, 0, 0 }
    }), 3.5, 1)
    Director.wait(0.5)
    WorldFX.say(hero, "AW MAN!", 1.8, true)
    Director.wait(1.8)
    v96:Destroy()
    AnimeFX.grade(nil, 0.3)

    if v36 then
        UIUtil.tween(v36, 0.6, {
            Volume = 0.5
        })
    end
end

local function finale(p23) -- line: 366
    -- upvalues: UIUtil (copy), Actors (copy), Director (copy), AnimeFX (copy), WorldFX (copy), v1 (copy), new (copy), lookAt (copy), t8 (copy)
    local hero, stand = p23.hero, p23.stand
    local headHeight = hero.headHeight

    Actors.lean(hero, CFrame.new(0, p23.standUp, -0.6), false, 6, 0.9)
    Actors.pose(hero, t8, 10, 0.7)

    if p23.dock then
        UIUtil.tween(p23.dock, 0.8, {
            Volume = 0.2
        })
    end

    AnimeFX.grade({
        Brightness = 0.04,
        Contrast = 0.2,
        Saturation = 0.3,
        TintColor = Color3.fromRGB(255, 232, 205)
    }, 0.8)

    local v98 = stand + new(0, headHeight + 1.2, 0)

    Director.move(lookAt(stand + Vector3.new(-3.4, -0.4, -10.5), v98), lookAt(stand + Vector3.new(-2.8, 0, -8.8), v98), 3.4, {
        fov = 50,
        fov1 = 45,
        roll = -4,
        roll1 = 0,
        blend = 0.9,
        focus = hero.head
    })
    Director.wait(0.8)

    local v99 = WorldFX.aura(hero.root, v1, 0.8)

    UIUtil.sound("Luck1", 0.8)
    Director.punch(4)
    WorldFX.say(hero, "...I'M GONNA CATCH THAT SHARK.", 2.6, true)
    Director.wait(2.6)
    v99(false)
    AnimeFX.black()
    AnimeFX.letterbox(false)
end

local function setAmbience(p24) -- line: 390
    -- upvalues: SoundService (copy), UIUtil (copy)
    local Ambience = SoundService:FindFirstChild("Ambience")

    if not Ambience then
        return
    end

    UIUtil.tween(Ambience, if p24 then 1 else 0.6, {
        Volume = if p24 then Ambience:GetAttribute("FullVolume") or 0.35 else 0
    })
end

local function run() -- line: 397
    -- upvalues: SoundService (copy), UIUtil (copy), Director (copy), Rival (copy), stage (copy), act1 (copy), finale (copy)
    local Ambience = SoundService:FindFirstChild("Ambience")

    if Ambience then
        UIUtil.tween(Ambience, 0.6, {
            Volume = 0
        })
    end

    Director.start()

    local v101 = stage()

    if not v101 then
        return
    end

    act1(v101)
    Rival.play(v101)
    finale(v101)
end

local BindableEvent

function t1.play() -- line: 412
    -- upvalues: t1 (copy), run (copy), BindableEvent (ref)
    local BindableEvent2 = Instance.new("BindableEvent")

    BindableEvent = BindableEvent2

    local ok = true
    local result
    local v102 = task.spawn(function() -- line: 416
        -- upvalues: BindableEvent2 (copy), ok (ref), result (ref), run (copy)
        ok, result = pcall(run)
        BindableEvent2:Fire()
    end)

    if coroutine.status(v102) ~= "dead" then
        BindableEvent2.Event:Wait()
    end

    BindableEvent = nil
    BindableEvent2:Destroy()

    if coroutine.status(v102) ~= "dead" then
        task.cancel(v102)
    end

    t1.finish()

    if not ok then
        error(result, 0)
    end
end

function t1.skip() -- line: 434
    -- upvalues: BindableEvent (ref)
    if BindableEvent then
        BindableEvent:Fire()
    end
end

function t1.finish() -- line: 440
    -- upvalues: SoundService (copy), UIUtil (copy), Actors (copy), Director (copy), AnimeFX (copy), WorldFX (copy), t3 (copy), t4 (copy)
    AnimeFX.black()
    AnimeFX.speedLines(false)
    AnimeFX.letterbox(false)
    Director.stop()

    for _, v103 in t4 do
        v103:Disconnect()
    end

    table.clear(t4)

    for _, v104 in t3 do
        if v104 and v104.Parent then
            v104:Destroy()
        end
    end

    table.clear(t3)

    local Ambience = SoundService:FindFirstChild("Ambience")

    if Ambience then
        UIUtil.tween(Ambience, 1, {
            Volume = Ambience:GetAttribute("FullVolume") or 0.35
        })
    end

    WorldFX.cleanup()
    Actors.cleanup()
end

function t1.setup() -- line: 459
    -- upvalues: ContentProvider (copy), Config (copy), AnimeFX (copy), t2 (copy)
    AnimeFX.init()
    task.spawn(function() -- line: 461
        -- upvalues: ContentProvider (copy), Config (copy), t2 (copy)
        local t12 = {}

        for _, v105 in t2 do
            local Sound = Instance.new("Sound")

            Sound.SoundId = Config.Sounds[v105]
            table.insert(t12, Sound)
        end

        local PreloadAsync = ContentProvider.PreloadAsync

        pcall(PreloadAsync, ContentProvider, t12)
    end)
end

function t1.cleanup() -- line: 472
    -- upvalues: AnimeFX (copy)
    AnimeFX.cleanup()
end

return t1
