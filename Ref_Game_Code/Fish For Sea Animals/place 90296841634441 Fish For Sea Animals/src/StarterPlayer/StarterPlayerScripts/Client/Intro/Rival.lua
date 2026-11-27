-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Actors = require(script.Parent.Actors)
local Director = require(script.Parent.Director)
local AnimeFX = require(script.Parent.AnimeFX)
local WorldFX = require(script.Parent.WorldFX)
local v1 = Color3.fromRGB(255, 120, 220)
local v2 = Color3.fromRGB(190, 120, 255)
local v3 = Color3.new(1, 1, 1)
local new = Vector3.new
local with = Actors.with
local lookAt = CFrame.lookAt
local t1 = {}

t1.IDLE = {
    RS = { 35, 0, 0 },
    RE = { 35, 0, 0 },
    LS = { 4, 0, -6 },
    LE = { 12, 0, 0 },
    Root = { 0, 0, 4 },
    Neck = { 6, 0, 0 }
}

local t2 = {
    RS = { 176, 0, 8 },
    RE = { 4, 0, 0 },
    LS = { 4, 0, -6 },
    LE = { 12, 0, 0 },
    Waist = { 8, 0, 0 },
    Neck = { 14, 0, 0 }
}
local t3 = {
    RS = { 176, 0, -12 },
    RE = { 30, 0, 0 },
    LS = { 60, 0, 22 },
    LE = { 30, 0, 0 },
    Waist = { 14, -38, 0 },
    Root = { 10, 0, 0 },
    RH = { -15, 0, 6 },
    LH = { 30, 0, -6 },
    LK = { -25, 0, 0 }
}
local t4 = {
    RS = { 50, 0, 0 },
    RE = { 5, 0, 0 },
    LS = { -35, 0, -22 },
    LE = { 10, 0, 0 },
    Waist = { -16, 28, 0 },
    Root = { -18, 0, 0 },
    RH = { 45, 0, 6 },
    RK = { -35, 0, 0 },
    LH = { -25, 0, -6 },
    Neck = { 12, 0, 0 }
}
local t5 = {
    RS = { 75, 0, 0 },
    RE = { 25, 0, 0 },
    LS = { 4, 0, -6 },
    LE = { 12, 0, 0 },
    Neck = { 4, 0, 0 }
}
local t6 = {
    RS = { 140, 0, 0 },
    RE = { 10, 0, 0 },
    LS = { 4, 0, -6 },
    LE = { 12, 0, 0 },
    Waist = { 6, 0, 0 },
    Neck = { 10, 0, 0 }
}
local t7 = {
    RS = { 150, 0, -15 },
    LS = { 150, 0, 15 },
    RE = { 25, 0, 0 },
    LE = { 25, 0, 0 },
    Waist = { 10, 0, 0 },
    Neck = { 22, 0, 0 }
}
local t8 = {
    RS = { 50, 0, -12 },
    LS = { 50, 0, 12 },
    RE = { 60, 0, 0 },
    LE = { 60, 0, 0 },
    Waist = { 6, 0, 0 },
    Root = { 4, 0, 0 },
    Neck = { 6, 0, 0 }
}
local t9 = {
    RS = { 172, 0, 10 },
    LS = { 172, 0, -10 },
    RE = { 10, 0, 0 },
    LE = { 10, 0, 0 },
    Waist = { 10, 0, 0 },
    Neck = { 18, 0, 0 }
}
local t10 = {
    RS = { 100, 0, -10 },
    LS = { 100, 0, 10 },
    RE = { 10, 0, 0 },
    LE = { 10, 0, 0 },
    Waist = { -14, 0, 0 },
    Neck = { -12, 0, 0 },
    RK = { -20, 0, 0 },
    LK = { -20, 0, 0 }
}
local t11 = {
    RS = { 20, 0, 100 },
    RE = { 10, 0, 0 },
    LS = { 140, 0, -40 },
    LE = { 40, 0, 0 },
    Waist = { -6, 0, 10 },
    Neck = { 22, 0, 0 },
    RK = { -15, 0, 0 },
    LK = { -15, 0, 0 }
}

function t1.prepare(p1) -- line: 47
    -- upvalues: AnimalModel (copy), Actors (copy)
    local v4 = AnimalModel.clone("CosmicGreatWhite", 5.5)

    if v4 then
        v4:PivotTo(CFrame.new(0, -500, 0))
        v4.Parent = Actors.folder()
        p1.star = v4
        p1.starRig = AnimalModel.rig(v4)
    end
end

local function trophyAt(p2) -- line: 59
    return CFrame.new(p2.R + Vector3.new(0, -0.4, -1.5)) * CFrame.Angles(0, 1.5707963267948966, 0)
end

function t1.play(p3) -- line: 63
    -- upvalues: Animals (copy), AnimalModel (copy), Format (copy), UIUtil (copy), Actors (copy), Director (copy), AnimeFX (copy), WorldFX (copy), t1 (copy), v1 (copy), v2 (copy), v3 (copy), new (copy), with (copy), lookAt (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), t11 (copy)
    local hero, rival, R, stand = p3.hero, p3.rival, p3.R, p3.stand
    local standUp = p3.standUp
    local headHeight = hero.headHeight
    local headHeight2 = rival.headHeight
    local v7 = new(R.X, p3.deckTop + 0.15, R.Z)
    local v5 = CFrame.new(0, standUp, -0.6) * CFrame.Angles(0, -1.3962634015954636, 0)

    Actors.show(rival, true)

    local v8 = R + Vector3.new(16, 0, 2)
    local Unit = (R - v8).Unit
    local v9 = v8

    Actors.at(rival, lookAt(v8, v8 + Unit))
    Actors.lean(hero, v5, false, 4, 1)
    Director.follow(function() -- line: 78
        -- upvalues: stand (copy), headHeight (copy), headHeight2 (copy), v9 (ref), new (copy), lookAt (copy)
        return lookAt(stand + new(-4, headHeight + 0.8, 3.5), v9 + new(0, headHeight2 * 0.6, 0))
    end, 2.8, {
        fov = 40,
        fov1 = 34,
        radius = 6,
        blend = 0.5,
        focus = rival.head
    })
    task.delay(0.2, UIUtil.sound, "Laugh", 1)
    Director.during(2.8, function(p4, p5) -- line: 82
        -- upvalues: rival (copy), R (copy), v8 (copy), Unit (copy), v9 (ref), Actors (copy), new (copy), with (copy), lookAt (copy), t5 (copy)
        local v17 = math.sin(p4 * 8)

        v9 = v8:Lerp(R, 1 - (1 - p5) ^ 1.5) + new(0, math.abs(v17) * 0.18, 0)
        Actors.at(rival, lookAt(v9, v9 + Unit))
        Actors.pose(rival, with(t5, {
            LS = {
                -v17 * 28,
                0, -6
            },
            RH = {
                v17 * 32,
                0, 0
            },
            LH = {
                -v17 * 32,
                0, 0
            },
            RK = {
                -math.max(0, -v17) * 45,
                0, 0
            },
            LK = {
                -math.max(0, v17) * 45,
                0, 0
            }
        }), 40, 0.7)
    end)
    Actors.pose(rival, t1.IDLE, 12)
    Actors.at(rival, lookAt(R, (new(stand.X, R.Y, stand.Z))))
    v5 = R + new(0, headHeight2 - 0.3, 0)
    Director.move(lookAt(R + Vector3.new(-5.4, -1.2, -2.6), v5), lookAt(R + Vector3.new(-4.6, -1, -2.2), v5), 2.2, {
        fov = 44,
        blend = 0.5,
        focus = rival.head
    })
    WorldFX.say(rival, "Pfft. Nice catch, rookie.", 2)
    Director.wait(2.2)
    WorldFX.say(rival, "Watch how a PRO does it.", 1.8)
    Actors.lean(rival, CFrame.identity, false, 8, 0.9)
    Actors.pose(rival, t2, 16, 0.55)
    Director.follow(function(p6) -- line: 107
        -- upvalues: R (copy), new (copy), lookAt (copy)
        local v24 = math.rad(150 + p6 * 32)

        return lookAt(R + new(math.sin(v24), 0, (math.cos(v24))) * 10 + Vector3.new(0, -0.8, 0), R + Vector3.new(0, 1.8, 0))
    end, 2.6, {
        fov = 48,
        fov1 = 42,
        roll = 8,
        roll1 = -4,
        focus = rival.root
    })
    Director.wait(0.6)
    UIUtil.sound("Luck1", 0.9)
    UIUtil.sound("Lightning", 0.4)
    AnimeFX.flash(Color3.fromRGB(255, 210, 255), 0.3)

    local v10 = WorldFX.aura(p3.rivalRod.PrimaryPart, v1, 0.7)
    local v27 = WorldFX.aura(rival.root, v1, 1.1)

    WorldFX.pillar(v7, v1, 40, 1.2)
    AnimeFX.sfx("SHING!", {
        x = 0.72,
        y = 0.3,
        size = 0.15,
        color = Color3.fromRGB(255, 180, 240),
        color2 = Color3.fromRGB(140, 110, 255)
    })
    Director.wait(1.9)
    Actors.pose(rival, t3, 14, 0.8)
    Director.move(lookAt(R + Vector3.new(5.2, 1.2, -1.6), R + Vector3.new(0, 2.2, 0)), lookAt(R + Vector3.new(4.4, 1.3, -1.3), R + Vector3.new(0, 2.2, 0)), 1, {
        fov = 44,
        fov1 = 36,
        focus = rival.root
    })
    AnimeFX.grade({
        Brightness = -0.14,
        Contrast = 0.4,
        Saturation = 0.1,
        TintColor = Color3.fromRGB(230, 215, 255)
    }, 0.4)
    Director.rumble(0.25)
    UIUtil.sound("CastSwing", 0.9)
    Director.slowmo(0.4, 0.2)
    Director.wait(0.5)
    Director.slowmo(1)
    AnimeFX.impact("white", 0.1)
    AnimeFX.grade(nil, 0.2)
    Director.rumble(0)
    Director.shake(0.9)
    Director.punch(16)
    UIUtil.sound("Lightning", 0.6)
    UIUtil.sound("CastLine", 0.9)
    Actors.pose(rival, t4, 45, 0.45)
    WorldFX.shockwave(v7, v1, 40)
    WorldFX.dust(v7, 1)

    local WorldPosition = p3.rivalTip.WorldPosition
    local v28, v29 = Actors.bobber(WorldPosition, v3)

    v28.Material = Enum.Material.Neon
    WorldFX.rainbowTrail(v28, 1)

    local v11 = Actors.line(p3.rivalTip, v29)
    local v21 = p3.loop("BaitFlight", 0.5)
    local farPos = p3.farPos

    local function arc(p7) -- line: 150
        -- upvalues: WorldPosition (copy), farPos (copy), new (copy)
        return WorldPosition:Lerp(farPos, p7) + new(0, math.sin(p7 * 3.141592653589793) * 130, 0)
    end

    local function flown(p8) -- line: 153
        return 1 - (1 - math.min(p8 / 2.6, 1)) ^ 1.8
    end

    Director.follow(function(p9) -- line: 156
        -- upvalues: WorldPosition (copy), farPos (copy), new (copy), lookAt (copy)
        local v35 = 1 - (1 - math.min(p9 / 2.6, 1)) ^ 1.8
        local v39 = WorldPosition:Lerp(farPos, v35) + new(0, math.sin(v35 * 3.141592653589793) * 130, 0) + Vector3.new(4, 5, 16)
        local v41 = math.min(v35 + 0.03, 1)

        return lookAt(v39, WorldPosition:Lerp(farPos, v41) + new(0, math.sin(v41 * 3.141592653589793) * 130, 0))
    end, 2.6, {
        fov = 75
    })

    local v45 = math.floor((WorldPosition - farPos).Magnitude)
    local v46 = AnimeFX.counter(0.8)
    local n1 = 0

    Director.during(2.6, function(p10) -- line: 163
        -- upvalues: WorldPosition (copy), v28 (copy), farPos (copy), v45 (copy), v46 (copy), n1 (ref), UIUtil (copy), new (copy)
        local v48 = 1 - (1 - math.min(p10 / 2.6, 1)) ^ 1.8

        v28.Position = WorldPosition:Lerp(farPos, v48) + new(0, math.sin(v48 * 3.141592653589793) * 130, 0)

        local v53 = math.floor(v48 * v45)

        v46.Text = ("%*m"):format(v53)

        if v53 // 100 > n1 then
            n1 = v53 // 100
            UIUtil.sound("Tick", 0.5, n1 * 0.06 + 1)
        end
    end)
    p3.stopSound(v21)
    v46.Text = ("%*m!!"):format(v45)
    task.delay(1.2, v46.Destroy, v46)
    Director.hitstop(0.06)
    WorldFX.splash(farPos, 2.2)
    WorldFX.pillar(farPos, v1, 220, 1.4)
    WorldFX.shockwave(farPos + Vector3.new(0, 0.3, 0), v3, 80, 0.9)
    UIUtil.sound("Luck2", 0.8)
    Director.shake(0.4)
    Director.move(lookAt(farPos + Vector3.new(14, 50, 44), farPos + Vector3.new(0, 10, 0)), lookAt(farPos + Vector3.new(12, 44, 38), farPos + Vector3.new(0, 10, 0)), 1.3, {
        fov = 60
    })
    Director.wait(1.2)
    Actors.pose(rival, t5, 14)

    local star = Director.cut
    local v54 = R + Vector3.new(-3.4, 1, -4.6)

    star(lookAt(v54, R + new(0, headHeight2 - 0.4, 0)), {
        fov = 40,
        focus = rival.head
    })
    WorldFX.say(rival, "...and, got one.", 1.2)
    Director.wait(0.6)
    Actors.pose(rival, t6, 50, 0.4)
    UIUtil.sound("Whoosh", 0.7, 1.3)
    Director.shake(0.2)
    Director.wait(0.5)
    star = p3.star

    local starRig = p3.starRig

    if not star then
        return
    end

    v11:Destroy()
    v28:Destroy()

    local v55 = farPos - Vector3.new(0, 6, 0)
    local v56 = farPos + Vector3.new(0, 22, 0)

    AnimalModel.pose(starRig, lookAt(v55, v55 + Vector3.new(0.3, 1, 0.2)) * CFrame.Angles(0, 3.141592653589793, 0), Director.now(), 1)
    v11 = AnimalModel.body(star) or star.PrimaryPart

    if v11 then
        WorldFX.rainbowTrail(v11, 2)
    end

    Director.move(lookAt(farPos + Vector3.new(16, 3, 22), farPos + Vector3.new(0, 12, 0)), lookAt(farPos + Vector3.new(14, 2, 19), farPos + Vector3.new(0, 14, 0)), 0.8, {
        fov = 55,
        focus = v11
    })
    WorldFX.splash(farPos, 2.6)
    UIUtil.sound("Splash", 1, 0.7)
    AnimeFX.sfx("SPLOOSH!!", {
        x = 0.3,
        y = 0.7,
        size = 0.14,
        rotation = -8,
        color = Color3.fromRGB(150, 220, 255),
        color2 = Color3.fromRGB(50, 120, 230)
    })
    Director.slowmo(0.3, 0.15)
    Director.during(0.7, function(_, p12) -- line: 214
        -- upvalues: starRig (copy), v55 (copy), v56 (copy), AnimalModel (copy), Director (copy), lookAt (copy)
        local v57 = v55:Lerp(v56, 1 - (1 - p12) ^ 2)

        AnimalModel.pose(starRig, lookAt(v57, v57 + Vector3.new(0.3, 1, 0.2)) * CFrame.Angles(0, 3.141592653589793, 0), Director.now(), 1)
    end)
    Director.slowmo(1)
    UIUtil.sound("Whoosh", 1, 0.6)
    Actors.pose(rival, t7, 12)

    local v58 = CFrame.new(p3.R + Vector3.new(0, -0.4, -1.5)) * CFrame.Angles(0, 1.5707963267948966, 0)

    local function back(p13) -- line: 225
        -- upvalues: v56 (copy), v58 (copy), new (copy)
        return v56:Lerp(v58.Position, p13) + new(0, math.sin(p13 * 3.141592653589793) * 70, 0)
    end

    local v62 = v56

    Director.follow(function() -- line: 230
        -- upvalues: v62 (ref), lookAt (copy)
        return lookAt(v62 + Vector3.new(6, 1.5, 7), v62)
    end, 2, {
        fov = 52
    })

    local v63 = false

    Director.during(2, function(_, p15) -- line: 234
        -- upvalues: rival (copy), R (copy), starRig (copy), v56 (copy), v58 (copy), v62 (ref), v63 (ref), AnimalModel (copy), Director (copy), new (copy), lookAt (copy)
        local v64 = p15 ^ 1.3

        v62 = v56:Lerp(v58.Position, v64) + new(0, math.sin(v64 * 3.141592653589793) * 70, 0)

        local pose = AnimalModel.pose
        local v68 = v62
        local v70 = math.min(v64 + 0.02, 1)

        pose(starRig, lookAt(v68, v56:Lerp(v58.Position, v70) + new(0, math.sin(v70 * 3.141592653589793) * 70, 0)) * CFrame.Angles(0, 3.141592653589793, 0), Director.now(), 1)

        if v64 > 0.82 and not v63 then
            v63 = true
            Director.cut(lookAt(R + Vector3.new(2.5, 1.5, -12), R + Vector3.new(0, 1.4, 0)), {
                fov = 46,
                focus = rival.root
            })
        end
    end)
    AnimeFX.impact("white", 0.08)
    AnimeFX.flash(v3, 0.5)
    UIUtil.sound("Luck4", 0.9)
    WorldFX.shockwave(v7, v2, 30)
    v10(false)
    v27(false)
    Actors.pose(rival, t8, 30, 0.5)

    local during = Animals.get("CosmicGreatWhite")
    local move = Animals.displayName({
        Id = "CosmicGreatWhite",
        Size = "Titanic"
    })

    during = AnimeFX.banner(during.Rarity, move, (("1 in %*"):format((Format.short(Animals.odds("CosmicGreatWhite"))))))
    Actors.pose(rival, t9, 18, 0.6)
    task.delay(0.4, UIUtil.sound, "Flex", 2)
    WorldFX.say(rival, "Cosmic. Great. White.", 2.4)

    local v75 = CFrame.new(R + new(0, headHeight2 + 2.6, -0.4)) * CFrame.Angles(0, 1.5707963267948966, 0)

    Director.move(lookAt(R + Vector3.new(-3, -1.4, -6.5), R + new(0, headHeight2 + 1.2, 0)), lookAt(R + Vector3.new(-2.6, -1.2, -5.6), R + new(0, headHeight2 + 1.4, 0)), 2.6, {
        fov = 50,
        fov1 = 46,
        roll = -6,
        radius = 6,
        blend = 0.4,
        focus = rival.head
    })
    WorldFX.sparkles(rival.head, 2.4)
    Director.during(2.6, function(p16) -- line: 264
        -- upvalues: starRig (copy), v58 (copy), v75 (copy), AnimalModel (copy), Director (copy)
        local v82 = math.min(p16 / 0.45, 1)
        local v85 = math.abs((math.sin(p16 * 4))) * 0.6 * v82
        local v86 = v58:Lerp(v75, 1 - (1 - v82) ^ 2) * CFrame.new(0, v85, 0)

        AnimalModel.pose(starRig, v86, Director.now(), 0.2)
    end)
    during:Destroy()
    v5 = stand + new(0, headHeight + 0.1, 0)
    Director.move(lookAt(stand + new(4.2, headHeight + 0.5, -3.2), v5), lookAt(stand + new(3.7, headHeight + 0.4, -2.8), v5), 1.5, {
        fov = 40,
        focus = hero.head
    })
    WorldFX.sparkles(hero.head, 1.4)
    WorldFX.say(hero, "SO COOL...", 1.3)
    Director.wait(1.5)
    Actors.pose(rival, with(t8, {
        Neck = { 14, 25, 0 }
    }), 14)
    Director.cut(lookAt(R + new(-2.4, headHeight2 + 0.3, -5.2), R + new(0.4, headHeight2 - 0.4, 0)), {
        fov = 40,
        handheld = 0,
        focus = rival.head
    })
    Director.during(0.35, function(_, p18) -- line: 282
        -- upvalues: starRig (copy), v58 (copy), v75 (copy), AnimalModel (copy), Director (copy)
        AnimalModel.pose(starRig, v75:Lerp(v58, p18), Director.now(), 0.1)
    end)
    Director.wait(0.4)

    local v88 = v58 * CFrame.Angles(0.3, -0.6, 0)

    Director.during(0.45, function(_, p20) -- line: 287
        -- upvalues: starRig (copy), v58 (copy), v88 (copy), AnimalModel (copy), Director (copy)
        AnimalModel.pose(starRig, v58:Lerp(v88, p20 * p20), Director.now(), 0)
    end)
    Director.wait(0.25)
    during = rival.model:FindFirstChild("RightLowerArm") or rival.model:FindFirstChild("Right Arm") or rival.root

    local function biting(p21) -- line: 293
        -- upvalues: rival (copy), during (ref), new (copy), lookAt (copy)
        local duringPosition = during.Position
        local _CFrame = rival.root.CFrame
        local v90 = math.sin(p21 * 19)

        return lookAt(duringPosition + (_CFrame.RightVector + new(0, v90 * 0.25 + -0.9, 0) + _CFrame.LookVector * v90 * 0.35).Unit * 2.3, duringPosition) * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.Angles(0, 0, math.sin(p21 * 27) * 0.45)
    end

    Actors.pose(rival, t11, 45, 0.4)
    Director.during(0.1, function(_, p23) -- line: 301
        -- upvalues: rival (copy), starRig (copy), during (ref), v88 (copy), AnimalModel (copy), Director (copy), lookAt (copy)
        local pose = AnimalModel.pose
        local duringPosition = during.Position
        local _CFrame = rival.root.CFrame

        pose(starRig, v88:Lerp(lookAt(duringPosition + (_CFrame.RightVector + Vector3.new(0, -0.9, 0) + _CFrame.LookVector * 0 * 0.35).Unit * 2.3, duringPosition) * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.Angles(0, 0, 0), p23), Director.now(), 0)
    end)
    AnimeFX.impact("red", 0.2, true)
    UIUtil.sound("Bite", 1.2)
    AnimeFX.sfx("CHOMP!!", {
        y = 0.42,
        size = 0.24,
        rotation = -6,
        time = 1.2,
        shake = 14,
        color = Color3.fromRGB(255, 90, 60),
        color2 = Color3.fromRGB(150, 0, 0)
    })
    Director.shake(1)
    Director.punch(18)
    task.delay(0.3, UIUtil.sound, "Scream", 1)
    Director.cut(lookAt(R + Vector3.new(6, 1.8, -11), R + Vector3.new(1.5, 1.2, 0)), {
        fov = 46,
        radius = 6,
        handheld = 0.6,
        focus = rival.root
    })
    WorldFX.say(rival, "OWWW!! GET IT OFF!! GET IT OFF!!", 2.2, true)

    local v94 = R

    Director.during(2.2, function(p24) -- line: 315
        -- upvalues: rival (copy), R (copy), starRig (copy), biting (copy), v94 (ref), AnimalModel (copy), Actors (copy), Director (copy), new (copy), lookAt (copy)
        local v96 = math.sin(p24 * 16)

        v94 = R + new(math.sin(p24 * 2.2) * 1.6, math.abs((math.sin(p24 * 9))) * 0.6, math.sin(p24 * 3.1) * 0.6)
        Actors.at(rival, lookAt(v94, v94 + new(math.sin(p24 * 3) * 0.6, 0, -1)))
        Actors.pose(rival, {
            RS = {
                v96 * 50 + 30,
                0,
                v96 * 25 + 100
            },
            RE = { 15, 0, 0 },
            LS = {
                v96 * 30 + 140,
                0, -40
            },
            LE = { 40, 0, 0 },
            RH = {
                v96 * 40,
                0, 0
            },
            LH = {
                -v96 * 40,
                0, 0
            },
            RK = {
                -30 - v96 * 25,
                0, 0
            },
            LK = {
                v96 * 25 + -30,
                0, 0
            },
            Waist = {
                -4, 0,
                v96 * 8
            },
            Neck = {
                20,
                math.sin(p24 * 7) * 20,
                0
            }
        }, 40, 0.6)
        AnimalModel.pose(starRig, biting(p24), Director.now(), 1)
    end)

    local v78 = R + new(v94.X - R.X, 0, 0)

    Actors.at(rival, lookAt(v78, v78 + Vector3.new(0, 0, -1)))
    Actors.pose(rival, t10, 20, 0.6)

    local v76 = during.Position
    local v79 = rival.root.CFrame
    local v109 = lookAt(v76 + (v79.RightVector + Vector3.new(0, -1.1046969, 0) + v79.LookVector * -0.8187873221268477 * 0.35).Unit * 2.3, v76) * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.Angles(0, 0, 0.12879079180053604)
    local v110 = new(R.X + 2, p3.waterY, R.Z - 14)

    Director.move(lookAt(R + Vector3.new(-3, 3, -21), R + Vector3.new(0.5, 0.8, -5)), lookAt(R + Vector3.new(-2.6, 2.6, -19.5), R + Vector3.new(0.5, 0.6, -6)), 1.8, {
        fov = 50,
        radius = 12,
        focus = rival.root
    })
    WorldFX.say(rival, "NOOO!! MY SHARK!!", 1.6, true)
    UIUtil.sound("Whoosh", 0.8, 0.8)
    Director.during(0.8, function(p25, p26) -- line: 344
        -- upvalues: starRig (copy), v109 (copy), v110 (copy), AnimalModel (copy), Director (copy), new (copy)
        local v114 = v109.Position:Lerp(v110, p26) + new(0, math.sin(p26 * 3.141592653589793) * 4, 0)

        AnimalModel.pose(starRig, CFrame.new(v114) * v109.Rotation * CFrame.Angles(p25 * 9, 0, 0), Director.now(), 1)
    end)

    for _, descendant in star:GetDescendants() do
        if descendant:IsA("Trail") then
            descendant.Enabled = false
        end
    end

    star:PivotTo(CFrame.new(0, -500, 0))
    WorldFX.splash(v110, 0.9)
    UIUtil.sound("Splash", 1, 0.8)
    Director.shake(0.25)
    Director.wait(1.3)
end

return t1
