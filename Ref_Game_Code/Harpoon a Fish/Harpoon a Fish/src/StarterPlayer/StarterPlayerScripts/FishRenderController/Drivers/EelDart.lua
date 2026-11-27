-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.EelDart = {
        AMP = 0.5,
        STEP = 1,
        JUMP = 30,
        STRAIGHT_V = 10,
        S_EASE = 6,
        V_TAU = 0.1,
        K_TAU = 0.15,
        REF_L = 150,
        JAW_GAPE = 0.2,
        JAW_EVERY = { 1.6, 3.2 },
        JAW_SNAP = 0.12,
        JAW_HOOK = 2.5,
        KINDS = {
            Petalmaw = {
                lam = 1.1,
                alpha = 3.2,
                tail = 0.12,
                alphaB = 3.6,
                tailB = 0.13,
                stride = 1.15,
                finAmp = 0.05,
                finRate = 0.5,
                jawGape = 0.25,
                jawSync = true,
                jawStagger = 0.6,
                jawEvery = { 1.6, 2.6 }
            },
            Rosemaw = {
                lam = 1.1,
                alpha = 3.2,
                tail = 0.12,
                alphaB = 3.6,
                tailB = 0.13,
                stride = 0.5,
                finAmp = 0.05,
                finRate = 0.5,
                jawGape = 0.25,
                jawSync = true,
                jawStagger = 0.6,
                jawEvery = { 1.6, 2.6 }
            },
            Thousandmouth = {
                lam = 0.7,
                alpha = 1.2,
                tail = 0.07,
                alphaB = 1.6,
                tailB = 0.09,
                stride = 0.35,
                jawGape = 0.18,
                jawSync = true,
                jawStagger = 0.9,
                jawEvery = { 1.2, 1.8 }
            },
            Endling = {
                lam = 0.8,
                alpha = 3.4,
                tail = 0.075,
                alphaB = 4.2,
                tailB = 0.095,
                stride = 0.3,
                finAmp = 0.06,
                finRate = 0.5
            },
            AuroraSerpent = {
                lam = 0.8,
                alpha = 3.4,
                tail = 0.075,
                alphaB = 4.2,
                tailB = 0.095,
                stride = 0.38
            },
            MeteoriteMeg = {
                lam = 1.1,
                alpha = 3.2,
                tail = 0.12,
                alphaB = 3.6,
                tailB = 0.13,
                stride = 0.45,
                finAmp = 0.05,
                finRate = 0.5,
                bite = {
                    gape = 0.16,
                    lift = 0.07,
                    shut = 0.3,
                    snap = 0.11,
                    hold = 0.14,
                    reopen = 0.55,
                    every = { 2.4, 4.2 }
                }
            },
            LavaPlesiosaur = {
                lam = 1.1,
                alpha = 1.8,
                tail = 0.05,
                alphaB = 2.2,
                tailB = 0.06,
                stride = 0.8,
                stroke = {
                    rate = 1.5,
                    maxHz = 3,
                    amp = 0.62,
                    bias = 0.12,
                    sweep = 0.22,
                    sweepLag = 0.5,
                    feather = 0.3,
                    lagR = 1.5707963267948966,
                    ampR = 0.85
                }
            },
            Pilgrimosaur = {
                lam = 1.1,
                alpha = 1.8,
                tail = 0.05,
                alphaB = 2.2,
                tailB = 0.06,
                stride = 0.7,
                stroke = {
                    rate = 1.5,
                    maxHz = 3,
                    amp = 0.62,
                    bias = 0.12,
                    sweep = 0.22,
                    sweepLag = 0.5,
                    feather = 0.3,
                    lagR = 1.5707963267948966,
                    ampR = 0.85
                }
            },
            LavaMosasaur = {
                lam = 1,
                alpha = 2.8,
                tail = 0.11,
                alphaB = 3.2,
                tailB = 0.12,
                stride = 0.7,
                finAmp = 0.1,
                finRate = 0.5,
                bite = {
                    gape = 0.12,
                    lift = 0.03,
                    shut = 0.48,
                    snap = 0.09,
                    hold = 0.12,
                    reopen = 0.5,
                    every = { 2.8, 4.6 }
                }
            },
            Basilo = {
                lam = 0.9,
                alpha = 2,
                tail = 0.07,
                alphaB = 2.4,
                tailB = 0.09,
                stride = 1,
                sway = 0,
                heave = {
                    amp = 1,
                    lag = 0
                }
            },
            Drillwyrm = {
                lam = 0.95,
                alpha = 2.6,
                tail = 0.1,
                alphaB = 2.6,
                tailB = 0.11,
                stride = 0.6,
                finAmp = 0.16,
                finRate = 1,
                drill = {
                    idle = 0.6,
                    gain = 1.2,
                    max = 5,
                    ease = 4
                }
            },
            Starphax = {
                lam = 0.9,
                alpha = 2,
                tail = 0.06,
                alphaB = 2.4,
                tailB = 0.075,
                stride = 0.35,
                minHz = 0.35,
                wing = {
                    beatHz = 0.55,
                    chargeHz = 0.45,
                    chargeAmp = 0.15,
                    hookHz = 1.3,
                    hookAmp = 1.15,
                    down = 0.58,
                    top = 0.25,
                    span = 1.45,
                    lag = { 0, 0.5, 1 },
                    gain = { 1, 1, 1.06 },
                    glide = { 1.12, 1.06, 0.98 },
                    glideE = { 0.8, 1.3 },
                    bouts = { 4, 3, 5, 3 },
                    glides = { 2.2, 1.6, 2.8, 2 },
                    glideEase = 3,
                    mantle = { 0.62, 0.86, 1.18 },
                    mantleHz = 0.7,
                    mantlePulse = 0.08,
                    mantleEase = 4,
                    fold = { 0, 0, 0 },
                    foldE = 1.5,
                    arriveT = 6,
                    foldEase = 5,
                    unfurlAmp = 0.25,
                    sweep = { 0, 0.25, 0.15 },
                    sweepGlide = 1,
                    sweepMantle = 0.6,
                    flutter = 0.035,
                    turnAsym = 0.25,
                    turnRef = 0.25,
                    bob = 0.006,
                    surge = 0.004,
                    headStill = 0.3,
                    cruiseBL = 0.2,
                    eTau = 0.3
                },
                fan = {
                    stream = 0.1,
                    flick = 0.045,
                    base = 0.6,
                    tip = 1.8,
                    lick = 0.05,
                    lickRate = 2.1,
                    side = 0.8,
                    pulse = 0.05
                }
            },
            Primordrax = {
                lam = 0.8,
                alpha = 3.4,
                tail = 0.075,
                alphaB = 4.2,
                tailB = 0.095,
                stride = 0.55,
                wing = {
                    beatHz = 1,
                    chargeHz = 0.45,
                    chargeAmp = 0.15,
                    hookHz = 1.3,
                    hookAmp = 1.15,
                    down = 0.58,
                    top = -1.3,
                    span = 1.4,
                    lag = { 0, 0.5, 1 },
                    gain = { 1, 1, 1.06 },
                    glide = { -0.95, -0.95, -0.9 },
                    glideE = { 0.8, 1.2 },
                    bouts = { 4, 3, 5, 3 },
                    glides = { 2.2, 1.6, 2.8, 2 },
                    glideEase = 3,
                    mantle = { -1.35, -1.45, -1.55 },
                    mantleHz = 0.7,
                    mantlePulse = 0.08,
                    mantleEase = 4,
                    fold = { 0, 0, 0 },
                    foldE = 1.5,
                    arriveT = 6,
                    foldEase = 5,
                    unfurlAmp = 0.25,
                    sweep = { 0, 0.25, 0.15 },
                    sweepGlide = 1,
                    sweepMantle = 0.6,
                    flutter = 0.035,
                    turnAsym = 0.25,
                    turnRef = 0.25,
                    bob = 0.006,
                    surge = 0.004,
                    headStill = 0.3,
                    cruiseBL = 0.2,
                    eTau = 0.3
                }
            },
            Leviathan = {
                lam = 0.65,
                alpha = 2.8,
                tail = 0.1,
                alphaB = 2.6,
                tailB = 0.11,
                stride = 0.6,
                minHz = 0.45,
                roar = {
                    open = 0.9,
                    hold = 1.2,
                    close = 0.8,
                    gape = 0.32,
                    lift = 0.07,
                    breath = 0.03,
                    breathHz = 0.3,
                    every = { 7, 11 }
                },
                tendril = {
                    drag = 0.6,
                    dragV = 1.2,
                    sway = 0.22,
                    rate = 0.9,
                    lag = 0.9
                },
                crest = {
                    fold = 0.3,
                    foldV = 1.2,
                    flare = 0.22,
                    turn = 0.5,
                    turnMax = 0.12,
                    breath = 0.03,
                    breathHz = 0.25,
                    ease = 2.5
                },
                ridge = {
                    stream = 0.25,
                    streamV = 1.2,
                    ripple = 0.09,
                    lam = 0.5,
                    flex = 0.06,
                    ease = 3
                }
            },
            Voidspine = {
                lam = 0.65,
                alpha = 2.8,
                tail = 0.1,
                alphaB = 2.6,
                tailB = 0.11,
                stride = 0.6,
                minHz = 0.45,
                roar = {
                    lead = 0.1,
                    open = 0.1,
                    hold = 0.9,
                    close = 0.3,
                    gape = 0.3,
                    lift = 0.1,
                    rest = -0.1,
                    breath = 0.035,
                    breathHz = 0.3,
                    shake = 0.05,
                    attrs = { "NcScare" },
                    shakeHz = { 11, 17 }
                },
                look = {
                    attr = "NcStare",
                    turn = 0.08,
                    pitch = 0.6,
                    yaw = 1.2,
                    lookEase = 30,
                    anchor = 0.42,
                    neck = { 0.03, 0.42 },
                    twitch = {
                        amp = 0.18,
                        every = { 0.12, 0.3 }
                    }
                }
            }
        },
        TENDRIL = {
            drag = 0.55,
            dragV = 1,
            sway = 0.16,
            rate = 1.4,
            lag = 0.8
        },
        tendril = function(p3, p4, p5, p6, p7) -- tendril | line: 272
            -- upvalues: p1 (copy)
            p7 = p7 or p1.EelDart.TENDRIL

            local v3 = math.clamp(p6 / p7.dragV, 0, 1)

            return p7.drag * v3 / p4, p7.sway * p3 / p4 * math.sin(p5 * p7.rate - p7.lag * (p3 - 1))
        end,
        turnJaw = function(p8, p9) -- turnJaw | line: 281
            -- upvalues: p1 (copy)
            local HydraSwim = p1.HydraSwim
            local STRIKE_TIME = HydraSwim.STRIKE_TIME
            local v7 = HydraSwim.STRIKE_UP * STRIKE_TIME
            local v8 = HydraSwim.STRIKE_HIT * STRIKE_TIME

            if p8 < 0 or STRIKE_TIME <= p8 then
                return 0, 0
            end

            if p8 < v7 then
                local v10 = math.clamp(p8 / v7, 0, 1)

                return v10 * v10 * (3 - v10 * 2), 0
            end

            local v11 = p8 - v7

            if v11 < v8 then
                local v12 = v11 / v8
                local v13 = v12 * v12

                return 1 - v13, v13
            end

            local v14 = v11 - v8

            if v14 < p9.hold then
                return 0, 1
            end

            local v18 = math.clamp((v14 - p9.hold) / math.max(STRIKE_TIME - v7 - v8 - p9.hold, 0.001), 0, 1)

            return 0, 1 - v18 * v18 * (3 - v18 * 2)
        end,
        bite = function(p10, p11, p12) -- bite | line: 302
            local v19 = p11 - p12.snap - p12.hold - p12.reopen

            if p10 < v19 then
                local v21 = math.clamp(p10 / v19, 0, 1)

                return v21 * v21 * (3 - v21 * 2), 0
            end

            local v22 = p10 - v19

            if v22 < p12.snap then
                local v23 = v22 / p12.snap
                local v24 = v23 * v23

                return 1 - v24, v24
            end

            local v25 = v22 - p12.snap

            if v25 < p12.hold then
                return 0, 1
            end

            local v27 = math.clamp((v25 - p12.hold) / p12.reopen, 0, 1)

            return 0, 1 - v27 * v27 * (3 - v27 * 2)
        end,
        roar = function(p13, p14, p15) -- roar | line: 322
            -- upvalues: p1 (copy)
            local v28 = p14 - p15.open - p15.hold - p15.close

            if p13 < v28 then
                return 0
            end

            local v29 = p13 - v28

            if v29 < p15.open then
                return p1.EelDart.smooth01(v29 / p15.open)
            end

            local v30 = v29 - p15.open

            if v30 < p15.hold then
                return 1
            end

            local v31 = v30 - p15.hold

            return 1 - p1.EelDart.smooth01(v31 / p15.close)
        end,
        jawAngle = function(p16, p17, p18) -- jawAngle | line: 333
            return p18.gape * p16 + p18.breath * (1 - p16) * math.sin(6.283185307179586 * p18.breathHz * p17)
        end,
        scream = function(p19, p20) -- scream | line: 338
            -- upvalues: p1 (copy)
            local v35 = p19 + p20.lead

            if v35 < 0 then
                return 0
            end

            if v35 < p20.open then
                return p1.EelDart.smooth01(v35 / p20.open)
            end

            local v36 = v35 - p20.open

            if v36 < p20.hold then
                return 1
            end

            local v37 = v36 - p20.hold

            return 1 - p1.EelDart.smooth01(v37 / p20.close)
        end,
        screamAngle = function(p21, p22, p23) -- screamAngle | line: 349
            local v42 = p23.shake * p21 * (math.sin(6.283185307179586 * p23.shakeHz[1] * p22) * 0.6 + math.sin(6.283185307179586 * p23.shakeHz[2] * p22 + 1.3) * 0.4)

            return p23.rest + (p23.gape - p23.rest) * p21 + p23.breath * (1 - p21) * math.sin(6.283185307179586 * p23.breathHz * p22) + v42
        end,
        nlerp = function(p24, p25, p26) -- nlerp | line: 354
            local v46 = p24 + (p25 - p24) * p26

            return v46.Magnitude > 1E-06 and v46.Unit or p24
        end,
        lookDir = function(p27, p28, p29, p30) -- lookDir | line: 359
            -- upvalues: p1 (copy)
            local EelDart = p1.EelDart

            return EelDart.nlerp(-p28, -p29, EelDart.smooth01((p27 - p30.neck[1]) / (p30.neck[2] - p30.neck[1])))
        end,
        turnToward = function(p31, p32, p33) -- turnToward | line: 364
            local v49 = math.acos((math.clamp(p31:Dot(p32), -1, 1)))

            if v49 < 1E-06 then
                return p32
            end

            local v50 = p31:Cross(p32)

            if v50.Magnitude < 1E-06 then
                v50 = p31:Cross((Vector3.new(0, 1, 0)))

                if v50.Magnitude < 1E-06 then
                    v50 = p31:Cross((Vector3.new(1, 0, 0)))
                end
            end

            return CFrame.fromAxisAngle(v50.Unit, v49 * p33):VectorToWorldSpace(p31)
        end,
        crestPose = function(p34, p35, p36, p37, p38, p39) -- crestPose | line: 376
            return p39.fold * p35 + p39.breath * math.sin(6.283185307179586 * p39.breathHz * p38 + (if p34 > 0 then 0 else 1.3)), p34 * p39.flare * p37, p36
        end,
        ridgePose = function(p40, p41, p42, p43, p44, p45) -- ridgePose | line: 382
            return p45.stream * p42 + p45.ripple * math.sin(p41 - 6.283185307179586 * p40 / p45.lam), p45.flex * math.exp(p43 * (p40 - 1)) * math.cos(p41 - 6.283185307179586 * p40 / p44)
        end,
        smooth01 = function(p46) -- smooth01 | line: 389
            local v59 = math.clamp(p46, 0, 1)

            return v59 * v59 * (3 - 2 * v59)
        end,
        warp = function(p47, p48) -- warp | line: 393
            local v60 = p47 % 6.283185307179586

            if v60 < 6.283185307179586 * p48 then
                return 3.141592653589793 * v60 / (6.283185307179586 * p48)
            end

            return 3.141592653589793 + 3.141592653589793 * (v60 - 6.283185307179586 * p48) / (6.283185307179586 * (1 - p48))
        end,
        wingStep = function(p49, p50, p51, p52, p53, p54, p55) -- wingStep | line: 402
            local wing = p50.wing

            p49.t += p51
            p49.e = p49.e + (p52 - p49.e) * math.min(1, p51 / wing.eTau)

            local e2 = p49.e

            if p49.t > 0.5 and e2 < wing.glideE[2] then
                p49.cruised = true
            end

            local v63 = if p55 and not p54 and not p49.cruised and p49.t < wing.arriveT and wing.foldE < e2 then 1 else 0

            if v63 > 0 then
                p49.folded = true
            elseif p49.folded then
                p49.folded = false
                p49.psi = 0
                p49.big = 1
            end

            p49.fold = p49.fold + (v63 - p49.fold) * math.min(1, p51 * wing.foldEase * (if p49.fold < v63 then 2 else 1))
            p49.mantle = p49.mantle + ((if not p53 or p54 then 0 else 1) - p49.mantle) * math.min(1, p51 * wing.mantleEase)

            local v68, v69

            if p54 then
                v68 = wing.hookHz
                v69 = wing.hookAmp
            else
                local v71 = math.clamp(e2 - 1, 0, 1.5)

                v68 = wing.beatHz * (math.clamp(e2, 0, 1) * 0.2 + 0.8) * (1 + wing.chargeHz * v71)
                v69 = (math.clamp(e2, 0, 1) * 0.15 + 0.85) * (1 + wing.chargeAmp * v71)
            end

            p49.big = math.max(0, p49.big - p51 * v68 * 0.8)
            p49.amp = v69 * (1 + wing.unfurlAmp * p49.big)

            local v73 = not p54 and wing.glideE[1] < e2 and e2 < wing.glideE[2] and p49.mantle < 0.1 and p49.fold < 0.1

            if p49.gliding then
                p49.glideT -= p51

                if p49.glideT <= 0 or not v73 then
                    p49.gliding = false
                    p49.beats = 0
                end
            else
                local v74 = 3.141592653589793 * wing.down
                local v75 = p49.psi % 6.283185307179586

                p49.psi += p51 * 2 * 3.141592653589793 * v68

                local v76 = p49.psi % 6.283185307179586

                if v75 < v74 and v74 <= v76 or v76 < v75 and (v75 < v74 or v74 <= v76) then
                    p49.beats += 1

                    local v77 = p49.n % #wing.bouts + 1

                    if v73 and p49.beats >= wing.bouts[v77] then
                        p49.gliding = true
                        p49.glideT = wing.glides[v77]
                        p49.n += 1
                        p49.psi = v74
                    end
                end
            end

            p49.glide = p49.glide + ((if p49.gliding then 1 else 0) - p49.glide) * math.min(1, p51 * wing.glideEase)
            p49.fire += p51 * (math.clamp(e2, 0, 1.3) * 0.5 + 1) * (p54 and 2 or 1)
        end,
        wingAngles = function(p56, p57, p58, p59) -- wingAngles | line: 466
            -- upvalues: p1 (copy)
            local wing = p57.wing
            local v80 = 1 + wing.turnAsym * p59 * (if p58 > 0 then -1 else 1)
            local v82 = wing.mantlePulse * math.sin(6.283185307179586 * wing.mantleHz * p56.t)
            local t2 = {}
            local n1 = 0
            local n2 = 0

            for i = 1, 3 do
                local v84 = (1 - math.cos((p1.EelDart.warp(p56.psi - wing.lag[i], wing.down)))) / 2
                local v85 = wing.top + wing.span * p56.amp * v80 * wing.gain[i] * v84
                local v86 = v85 + (wing.glide[i] - v85) * p56.glide
                local v87 = v86 + (wing.mantle[i] + v82 * i / 3 - v86) * p56.mantle
                local v88 = v87 + (wing.fold[i] - v87) * p56.fold

                if i == 3 then
                    v88 += wing.flutter * p1.FlameFlick.flick(p56.fire, if p58 > 0 then 0.7 else 2.1) * (0.4 + p56.glide + p56.mantle)
                end

                local v89 = wing.sweep[i] * v84
                local v90 = v89 + (wing.sweep[i] * wing.sweepGlide - v89) * p56.glide
                local v91 = v90 + (wing.sweep[i] * wing.sweepMantle - v90) * p56.mantle
                local v92 = v91 - v91 * p56.fold

                t2[i] = {
                    v88 - n1,
                    v92 - n2
                }
                n2 = v92
                n1 = v88
            end

            return t2
        end,
        wingHeave = function(p60, p61) -- wingHeave | line: 491
            -- upvalues: p1 (copy)
            local wing = p61.wing
            local v94 = -math.cos((p1.EelDart.warp(p60.psi, wing.down))) * ((1 - p60.glide) * (1 - p60.mantle) * (1 - p60.fold) * p60.amp)

            return wing.bob * v94, wing.surge * v94
        end,
        fanPose = function(p62, p63, p64, p65) -- fanPose | line: 498
            -- upvalues: p1 (copy)
            local fan = p63.fan
            local flick = p1.FlameFlick.flick
            local v95 = math.clamp(p62.e, 0, 1.5)
            local base = p64 == 1 and fan.base or fan.tip
            local v96 = if p65 then 2.2 else math.min(1, v95) * 0.6 + 1
            local fire = p62.fire
            local v98 = fan.lick * math.sin(fan.lickRate * fire + 1.7 * p64)
            local v99 = fan.flick * base * v96 * flick(fire - 0.12 * p64, 1.7)
            local v100 = fan.flick * base * v96 * fan.side * flick(fire * 0.93 - 0.12 * p64, 3)
            local v101 = fan.stream * v95 / 1.5 * (if p64 == 1 then 1 else 0.6)
            local v102

            if p64 ~= 1 then
                v102 = 0

                return v101 + v98 * base + v99 - v102, v100
            end

            v102 = fan.pulse * (1 - p62.glide) * (1 - p62.fold) * -math.cos((p1.EelDart.warp(p62.psi, p63.wing.down))) or 0

            return v101 + v98 * base + v99 - v102, v100
        end,
        register = function(p66) -- register | line: 512
            -- upvalues: p1 (copy), attr (copy)
            local MeshPart = p66:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p66, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local _CFrame = MeshPart.CFrame
            local v105 = p66:GetPivot() * AnatomyInverse:Inverse()
            local v106 = _CFrame:VectorToObjectSpace(v105.RightVector)
            local v107 = _CFrame:VectorToObjectSpace(v105.UpVector)
            local v108 = v106:Cross(v107)
            local t3 = {}

            for i = 1, 99 do
                local v109 = MeshPart:FindFirstChild(string.format("Spine_%02d", i), true)

                if not v109 then
                    break
                end

                t3[i] = v109
            end

            if #t3 < 3 then
                return nil
            end

            local t4 = {}
            local n3 = 0

            for v110, v111 in ipairs(t3) do
                local v112 = _CFrame:ToObjectSpace(v111.WorldCFrame)
                local Magnitude = t3[v110 + 1] and (t3[v110 + 1].WorldPosition - v111.WorldPosition).Magnitude or t4[v110 - 1].len
                local v113 = if v110 == 1 and v106 then v106 else -v112.UpVector

                t4[v110] = {
                    bone = v111,
                    len = Magnitude,
                    x = n3,
                    off = CFrame.fromMatrix(Vector3.new(0, 0, 0), v113, if v110 == 1 and v107 then v107 else v108:Cross(v113)):Inverse() * v112.Rotation
                }
                n3 += Magnitude
            end

            for _, v114 in ipairs(t4) do
                v114.x /= n3
            end

            local t5 = {}

            for _, v115 in ipairs({ "Fin_FL", "Fin_FR", "Fin_ML", "Fin_MR", "Fin_RL", "Fin_RR" }) do
                local v116 = MeshPart:FindFirstChild(v115, true)

                if v116 then
                    local v117 = _CFrame:ToObjectSpace(v116.WorldCFrame)

                    t5[#t5 + 1] = {
                        bone = v116,
                        axis = v117:VectorToObjectSpace(v106),
                        upAxis = v117:VectorToObjectSpace(v107),
                        side = v115:sub(-1) == "L" and 1 or -1,
                        lag = v115:sub(5, 5) == "F" and 0 or 1.5,
                        pair = v115:sub(5, 5)
                    }
                end
            end

            local t7 = {}
            local t8 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                local v119, v120

                if descendant:IsA("Bone") then
                    v119, v120 = descendant.Name:match("^(Tendril_.+)_(%d+)$")
                end

                if v119 then
                    t8[v119] = t8[v119] or {}

                    local v121 = _CFrame:ToObjectSpace(descendant.WorldCFrame)

                    table.insert(t8[v119], {
                        bone = descendant,
                        k = tonumber(v120),
                        right = v121:VectorToObjectSpace(v108),
                        nose = v121:VectorToObjectSpace(v106)
                    })
                end
            end

            for _, v123 in pairs(t8) do
                for _, v124 in ipairs(v123) do
                    v124.n = #v123
                    t7[#t7 + 1] = v124
                end
            end

            local t10 = {}
            local t11 = {}
            local t12 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                local v125, v126

                if descendant:IsA("Bone") then
                    v125, v126 = descendant.Name:match("^(Head%w*)_(%d+)$")
                end

                if v125 then
                    if not t11[v125] then
                        t11[v125] = {}
                        t12[#t12 + 1] = v125
                    end

                    t11[v125][tonumber(v126)] = descendant
                end
            end

            table.sort(t12)

            local n4 = 0

            for v127, v128 in ipairs(t12) do
                local t13 = {}

                for v129, v130 in ipairs(t11[v128]) do
                    local v131 = _CFrame:ToObjectSpace(v130.WorldCFrame)

                    t13[v129] = {
                        bone = v130,
                        up = v131:VectorToObjectSpace(v107),
                        right = v131:VectorToObjectSpace(v108)
                    }
                end

                local v132 = _CFrame:PointToObjectSpace(t11[v128][#t11[v128]].WorldPosition):Dot(v107)

                t10[v127] = {
                    k = v127,
                    bones = t13,
                    z = v132
                }
                n4 += v132 / #t12
            end

            for _, v133 in ipairs(t10) do
                v133.side = n4 < v133.z and 1 or -1
            end

            local t14 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") and descendant.Name:match("^Jaw%w*_1$") then
                    local v134 = _CFrame:ToObjectSpace(descendant.WorldCFrame)
                    local OpenAxis = descendant:GetAttribute("OpenAxis")
                    local v135, v136

                    if typeof(OpenAxis) == "Vector3" and OpenAxis.Magnitude > 0.001 then
                        v135 = OpenAxis.Unit
                        v136 = 1
                    else
                        v135 = v108
                        v136 = -1
                    end

                    t14[#t14 + 1] = {
                        bone = descendant,
                        right = v134:VectorToObjectSpace(v135),
                        sign = v136,
                        t = math.random() * 2,
                        period = 1.6 + math.random() * 1.6
                    }
                end
            end

            local t15 = {}

            for _, v137 in ipairs(t14) do
                t15[#t15 + 1] = v137.bone.Name
            end

            table.sort(t15)

            for _, v138 in ipairs(t14) do
                v138.rank = table.find(t15, v138.bone.Name)
                v138.head = table.find(t12, "Head" .. (v138.bone.Name:match("^Jaw(%w*)_1$") or ""))
            end

            local EelSwim = p1.EelSwim
            local v139 = attr(p66, "EelKind") or "Eel"
            local v140 = p1.EelDart.KINDS[v139] or EelSwim.KINDS[v139] or EelSwim.KINDS.Eel
            local v141 = v140.drill and MeshPart:FindFirstChild("Drill", true)
            local v142 = t4[2] and t4[2].bone.CFrame.Position
            local v143 = t4[1].off:VectorToObjectSpace((Vector3.new(0, 0, 1)))
            local t16 = {}
            local t17 = {}

            if v140.wing or v140.fan then
                for _, descendant in ipairs(MeshPart:GetDescendants()) do
                    if descendant:IsA("Bone") then
                        local v144, v145 = descendant.Name:match("^Wing_([LR])(%d)$")
                        local v146 = descendant.Name:match("^Flame_(%d)$")
                        local v147 = _CFrame:ToObjectSpace(descendant.WorldCFrame)

                        if v144 and v140.wing then
                            t16[#t16 + 1] = {
                                bone = descendant,
                                nose = v147:VectorToObjectSpace(v106),
                                left = v147:VectorToObjectSpace(-v108),
                                side = v144 == "L" and 1 or -1,
                                k = tonumber(v145)
                            }
                        elseif v146 and v140.fan then
                            t17[#t17 + 1] = {
                                bone = descendant,
                                right = v147:VectorToObjectSpace(v108),
                                up = v147:VectorToObjectSpace(v107),
                                k = tonumber(v146)
                            }
                        end
                    end
                end
            end

            local t20 = {}
            local t21 = {}

            if v140.crest or v140.ridge then
                local Position = _CFrame:ToObjectSpace(t3[1].WorldCFrame).Position

                for _, descendant in ipairs(MeshPart:GetDescendants()) do
                    if descendant:IsA("Bone") then
                        local v150 = _CFrame:ToObjectSpace(descendant.WorldCFrame)
                        local v151 = descendant.Name:match("^Crest_([LR])$")

                        if v151 and v140.crest then
                            t20[#t20 + 1] = {
                                bone = descendant,
                                right = v150:VectorToObjectSpace(v108),
                                nose = v150:VectorToObjectSpace(v106),
                                up = v150:VectorToObjectSpace(v107),
                                side = v151 == "L" and 1 or -1
                            }
                        elseif v140.ridge and descendant.Name:match("^Blade_D%d+$") then
                            t21[#t21 + 1] = {
                                bone = descendant,
                                right = v150:VectorToObjectSpace(v108),
                                nose = v150:VectorToObjectSpace(v106),
                                x = math.clamp((Position - v150.Position):Dot(v106) / n3, 0, 1)
                            }
                        end
                    end
                end
            end

            local t24 = {
                liftPivot = v142,
                liftAxis = v143,
                model = p66,
                mesh = MeshPart,
                segs = t4,
                L = n3,
                nose = v106,
                up = v107,
                fins = t5,
                tendrils = t7,
                heads = t10,
                jaws = t14,
                clock = math.random() * 10,
                P = v140
            }

            t24.amp = attr(p66, "WaveAmp") or p1.EelDart.AMP
            t24.drill = v141 and {
                angle = 0,
                rate = 0,
                bone = v141
            } or nil
            t24.wings = t16
            t24.flames = t17

            local t25, v155

            if v140.wing and #t16 > 0 then
                local t26 = {
                    psi = 0,
                    e = 1,
                    t = 0,
                    glide = 0,
                    gliding = false,
                    glideT = 0,
                    beats = 0,
                    n = 0,
                    mantle = 0,
                    fold = 0,
                    folded = false,
                    cruised = false,
                    big = 0,
                    fire = 0,
                    amp = 1
                }

                if t26 then
                    t25 = t26
                    v155 = true
                else
                    v155 = false
                end
            else
                v155 = false
            end

            t24.wing = if not v155 then nil else t25
            t24.crests = t20
            t24.blades = t21
            t24.crestFold = 0
            t24.crestTurn = 0
            t24.ridgeStream = 0
            t24.trail = {}
            t24.target = {}
            t24.v = 0
            t24.s = 0
            t24.phase = math.random() * 6.283185307179586
            t24.kappa = Vector3.new(0, 0, 0)
            t24.lookLin = 0
            t24.lookK = 0
            t24.look = nil
            t24.twitchT = 0
            t24.twitch = Vector2.zero
            t24.regScale = p66:GetScale()

            return t24
        end,
        update = function(p67, p68) -- update | line: 678
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local EelDart, EelSwim = p1.EelDart, p1.EelSwim
            local _CFrame = p67.mesh.CFrame
            local v156 = _CFrame:VectorToWorldSpace(p67.nose)
            local v157 = _CFrame:VectorToWorldSpace(p67.up)
            local v158 = p67.L * (p67.model:GetScale() / p67.regScale)
            local v160 = math.max(1, v158 / EelDart.REF_L)
            local P = EelDart.STEP * v160
            local v159 = EelDart.JUMP * v160
            local segs, trail, target = p67.segs, p67.trail, p67.target
            local v161 = #segs
            local CFramePosition = _CFrame.Position
            local v162, v163, Magnitude, v164

            if p67.lastMid and p68 > 1E-04 then
                v163 = (CFramePosition - p67.lastMid).Magnitude
                v162 = v163 / p68

                local v

                if v162 < 2000 then
                    v = p67.v
                    Magnitude = v162 - p67.v
                    v164 = p68 / EelDart.V_TAU
                    p67.v = v + Magnitude * math.min(1, v164)
                end

                if v163 > 0.001 and v163 < v159 then
                    v162 = (v156 - p67.lastNose) / v163
                    v = p67.kappa
                    Magnitude = v162 - p67.kappa
                    v164 = p68 / EelDart.K_TAU
                    p67.kappa = v + Magnitude * math.min(1, v164)
                end
            end

            p67.lastMid = CFramePosition
            p67.lastNose = v156
            v163 = trail[1]

            local wing

            if not v163 or v159 < (CFramePosition - trail[1]).Magnitude then
                table.clear(trail)
                trail[1] = CFramePosition
                p67.kappa = Vector3.new(0, 0, 0)
            elseif P <= (CFramePosition - trail[1]).Magnitude then
                table.insert(trail, 1, CFramePosition)
                v162 = #trail
                v163 = 0

                for i = 2, v162 do
                    v163 += (trail[i] - trail[i - 1]).Magnitude

                    if v158 / 2 + 2 * P < v163 then
                        wing = #trail
                        Magnitude = i + 1

                        for j = wing, Magnitude, -1 do
                            trail[j] = nil
                        end

                        break
                    end
                end
            end

            v163 = fightHooked(p67.model)
            P = p67.P

            local v165, minHz, v166, v167

            if v163 then
                local HOOK_HZ = EelSwim.HOOK_HZ

                if HOOK_HZ then
                    v166 = HOOK_HZ
                    v167 = true
                else
                    v165 = p67.v / v158 / P.stride
                    minHz = P.minHz or EelSwim.MIN_HZ
                    v167 = false
                end
            else
                v165 = p67.v / v158 / P.stride
                minHz = P.minHz or EelSwim.MIN_HZ
                v167 = false
            end

            local kappa

            if not v167 then
                kappa = EelSwim.MAX_HZ
                v166 = math.clamp(v165, minHz, kappa)
            end

            p67.phase += p68 * 2 * 3.141592653589793 * v166

            local HOOK_TAIL, HOOK_ALPHA

            if v163 then
                HOOK_TAIL = EelSwim.HOOK_TAIL or P.tail * p67.amp
                HOOK_ALPHA = EelSwim.HOOK_ALPHA or P.alpha
            else
                HOOK_TAIL = P.tail * p67.amp
                HOOK_ALPHA = P.alpha
            end

            kappa = p67.kappa
            Magnitude = kappa.Magnitude

            local v168 = Magnitude > 1E-04 and kappa / Magnitude or Vector3.new(0, 0, 0)

            wing = p67.wing

            local v169, v170, v171, v172, v173

            if wing then
                v172 = attr(p67.model, "PassCruise")
                v171 = typeof(v172) == "number"

                if v171 then
                    v169 = p67.v / math.max(v172, 0.001)
                end

                if not v171 or not v169 then
                    v169 = p67.v / v158 / P.wing.cruiseBL
                end

                EelDart.wingStep(wing, P, p68, math.min(3, v169), not not attr(p67.model, "Display"), v163, v171)
                v173, v170 = EelDart.wingHeave(wing, P)
                v164 = (v157 * v173 + v156 * v170) * v158
            else
                v164 = nil
            end

            v173 = -v156
            v170 = v161 + 1
            v172 = CFramePosition
            v171 = 1
            v169 = 0

            local x, v174, Magnitude2, v175, Magnitude3, v176, v177, v178

            for i = 1, v170 do
                local v179 = i <= v161

                if v179 then
                    x = segs[i].x
                end

                local v180 = if not v179 or not x then 1 else x

                v174 = (v180 - 0.5) * v158
                v177 = trail[v171]

                while v174 > 0 and v177 and v169 + (v177 - v172).Magnitude < v174 do
                    Magnitude2 = (v177 - v172).Magnitude
                    v178 = if Magnitude2 > 1E-04 then (v177 - v172) / Magnitude2 else v173
                    v169 += Magnitude2
                    v171 += 1
                    v172 = v177
                    v173 = v178
                    v177 = trail[v171]
                end

                local v181

                if v174 <= 0 then
                    Magnitude3 = -v174

                    if Magnitude > 1E-04 then
                        v175 = Magnitude * Magnitude3
                        v181 = CFramePosition + v156 * (math.sin(v175) / Magnitude) + v168 * ((1 - math.cos(v175)) / Magnitude)
                        v176 = -(v156 * math.cos(v175) + v168 * math.sin(v175))
                    else
                        v181 = CFramePosition + v156 * Magnitude3
                        v176 = -v156
                    end
                else
                    local v182 = if v177 then (v177 - v172).Magnitude > 1E-04 else nil

                    if not v177 or not v182 then
                        v176 = v173
                        v181 = v172 + v173 * (v174 - v169)
                    else
                        Magnitude3 = (v177 - v172).Magnitude
                        v173 = (v177 - v172) / Magnitude3
                        v176 = v173
                        v181 = v172:Lerp(v177, (v174 - v169) / Magnitude3)
                    end
                end

                Magnitude3 = v176:Cross(v157)

                if Magnitude3.Magnitude > 0.001 then
                    v181 += Magnitude3.Unit * ((P.sway or 1) * EelSwim.h(v180, p67.phase, HOOK_TAIL, HOOK_ALPHA, P.lam) * v158)
                end

                v176 = P.heave

                if v176 then
                    v181 += v157 * (v176.amp * EelSwim.h(v180, p67.phase + v176.lag, HOOK_TAIL, HOOK_ALPHA, P.lam) * v158)
                end

                if v164 then
                    v181 += v164 * EelDart.smooth01(v180 / P.wing.headStill)
                end

                target[i] = v181
            end

            v178 = P.look

            local n5 = 0
            local x2, Unit, Unit2, Unit3, x3, Unit4, bite

            if v178 then
                local v183 = if not attr(p67.model, v178.attr) then 0 elseif v163 then 0 else 1
                local lookLin = p67.lookLin

                x = v183 - p67.lookLin
                v174 = -p68 / v178.turn
                v177 = p68 / v178.turn
                p67.lookLin = lookLin + math.clamp(x, v174, v177)

                local v184 = EelDart.smooth01(p67.lookLin)

                n5 = v184
                p67.lookK = v184

                local function xs(p69) -- line: 801
                    -- upvalues: segs (copy), v161 (copy)
                    return p69 <= v161 and segs[p69].x or 1
                end

                lookLin = v161 + 1
                v171 = 1

                local x4

                for i = 1, lookLin do
                    local v185 = i <= v161

                    if v185 then
                        x4 = segs[i].x
                    end

                    v174 = if not v185 or not x4 then 1 else x4

                    if v174 <= v178.anchor then
                        v171 = i
                    end
                end

                lookLin = v178.anchor - (v171 <= v161 and segs[v171].x or 1)
                x4 = v171 + 1

                local x5 = x4 <= v161 and segs[x4].x or 1

                x2 = v171 <= v161 and segs[v171].x or 1
                v172 = lookLin / (x5 - x2)
                v164 = workspace.CurrentCamera

                local v187

                if v184 > 0.001 and v164 then
                    local v188 = CFramePosition + v156 * ((0.5 - segs[2].x) * v158)

                    Magnitude = v156 - Vector3.new(0, 1, 0) * v156:Dot((Vector3.new(0, 1, 0)))
                    Unit = Magnitude.Magnitude > 0.001 and Magnitude.Unit or v157:Cross(v156).Unit
                    HOOK_TAIL = v164.CFrame.Position - v188
                    Unit2 = HOOK_TAIL.Magnitude > 0.001 and HOOK_TAIL.Unit or Unit
                    v188 = Unit2 - Vector3.new(0, 1, 0) * Unit2:Dot((Vector3.new(0, 1, 0)))

                    local Unit4 = v188.Magnitude > 0.001 and v188.Unit or Unit

                    x5 = Unit:Cross(Unit4):Dot((Vector3.new(0, 1, 0)))
                    x2 = Unit:Dot(Unit4)
                    bite = math.atan2(x5, x2)
                    x5 = -v178.yaw
                    x2 = v178.yaw
                    Unit4 = math.clamp(bite, x5, x2)
                    x2 = Unit2:Dot((Vector3.new(0, 1, 0)))
                    x5 = math.clamp(x2, -1, 1)
                    bite = math.asin(x5)
                    x5 = -v178.pitch
                    x2 = v178.pitch
                    Unit2 = math.clamp(bite, x5, x2)
                    bite = v178.twitch
                    p67.twitchT -= p68

                    if p67.twitchT <= 0 then
                        p67.twitchT = bite.every[1] + math.random() * (bite.every[2] - bite.every[1])
                        p67.twitch = Vector2.new((math.random() * 2 - 1) * bite.amp, (math.random() * 2 - 1) * bite.amp)
                    end

                    trail = Unit4 + p67.twitch.X
                    Unit2 += p67.twitch.Y
                    HOOK_TAIL = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), trail):VectorToWorldSpace(Unit) * math.cos(Unit2) + Vector3.new(0, 1, 0) * math.sin(Unit2)
                    x2 = p67.look

                    if x2 then
                        Unit3 = EelDart.turnToward
                        x4 = p67.look
                        Magnitude3 = p68 * v178.lookEase
                        Unit3 = Unit3(x4, HOOK_TAIL, (math.min(1, Magnitude3))).Unit
                    end

                    if x2 and Unit3 then
                        HOOK_TAIL = Unit3
                    end

                    p67.look = HOOK_TAIL
                    bite = p67.look
                    Unit = {
                        (Vector3.new(0, 0, 0))
                    }

                    for i = 1, v161 do
                        v176 = segs[i].x

                        local v190 = i < v161

                        if v190 then
                            x3 = segs[i + 1].x
                        end

                        Magnitude3 = if not v190 or not x3 then 1 else x3
                        v188 = (v176 + Magnitude3) / 2
                        Unit[i + 1] = Unit[i] + EelDart.lookDir(v188, bite, v156, v178) * segs[i].len
                    end

                    bite = CFramePosition + v156 * ((0.5 - v178.anchor) * v158) - Unit[v171]:Lerp(Unit[v171 + 1], v172)
                    v187 = {}
                    Unit3 = v161 + 1

                    for i = 1, Unit3 do
                        v187[i] = Unit[i] + bite
                    end
                end

                v164 = {
                    (Vector3.new(0, 0, 0))
                }

                for i = 1, v161 do
                    x2 = target[i + 1] - target[i]

                    local v191 = x2.Magnitude > 1E-06

                    if v191 then
                        Unit4 = x2.Unit
                    end

                    v177 = if not v191 or not Unit4 then -v156 else Unit4

                    if v187 then
                        v177 = EelDart.turnToward(v177, (v187[i + 1] - v187[i]).Unit, v184)
                    end

                    v164[i + 1] = v164[i] + v177 * segs[i].len
                end

                Unit = target[v171]:Lerp(target[v171 + 1], v172)

                if v187 then
                    Unit = Unit:Lerp(v187[v171]:Lerp(v187[v171 + 1], v172), v184)
                end

                v187 = Unit - v164[v171]:Lerp(v164[v171 + 1], v172)
                bite = v161 + 1

                for i = 1, bite do
                    target[i] = v164[i] + v187
                end
            end

            local function frame(p70) -- line: 859
                -- upvalues: _CFrame (copy), v156 (copy), v157 (copy), n5 (ref)
                local v192 = v157

                if n5 > 0.001 then
                    local v193 = v156:Cross(p70)
                    local Magnitude = v193.Magnitude

                    if Magnitude > 1E-06 then
                        v192 = v157 + (CFrame.fromAxisAngle(v193 / Magnitude, (math.atan2(Magnitude, (v156:Dot(p70))))):VectorToWorldSpace(v157) - v157) * n5
                    end
                end

                local v196 = v192 - p70 * v192:Dot(p70)

                if v196.Magnitude < 0.001 then
                    v196 = p70:Cross(_CFrame.RightVector)
                end

                return CFrame.fromMatrix(Vector3.new(0, 0, 0), p70, v196.Unit)
            end

            if v163 then
                CFramePosition = 1
            else
                bite = (p67.v - 1 / v160) / ((EelDart.STRAIGHT_V - 1) / v160)
                CFramePosition = math.clamp(bite, 0, 1)
            end

            Unit2 = math.max(CFramePosition, n5)
            Unit = p67.s
            Unit3 = Unit2 - p67.s
            Magnitude2 = p68 * EelDart.S_EASE
            p67.s = Unit + Unit3 * math.min(1, Magnitude2)
            CFramePosition = p67.s
            v160 = target[1] - target[2]

            local Unit5 = v160.Magnitude > 0.001 and v160.Unit or v156

            Unit = CFrame.new(target[1]) * frame(Unit5) * segs[1].off
            bite = P.bite
            Unit3 = bite or P.roar

            if Unit3 and p67.jaws[1] and p67.liftPivot then
                x2 = Unit3.lift * (p67.jaws[1].open or 0)

                if x2 > 1E-06 then
                    Unit4 = p67.liftPivot
                    Unit *= CFrame.new(Unit4) * CFrame.fromAxisAngle(p67.liftAxis, x2) * CFrame.new(-Unit4)
                end
            end

            Unit3 = segs[1].bone
            Unit3.Transform = CFrame.identity:Lerp((_CFrame * Unit3.CFrame):Inverse() * Unit, CFramePosition)

            for i = 2, v161 do
                Unit3 = segs[i]
                v176 = (Unit * Unit3.bone.CFrame).Position
                x3 = target[i + 1] - v176

                if x3.Magnitude > 0.001 then
                    Unit5 = -x3.Unit
                end

                x3 = CFrame.new(v176) * frame(Unit5) * Unit3.off
                Unit3.bone.Transform = CFrame.identity:Lerp((Unit * Unit3.bone.CFrame):Inverse() * x3, CFramePosition)
                Unit = x3
            end

            local bone, fromAxisAngle

            if wing then
                Unit4 = kappa:Dot((v157:Cross(v156))) * v158 * P.wing.turnRef
                x2 = math.clamp(Unit4, -1, 1)
                Magnitude2 = EelDart.wingAngles(wing, P, 1, x2)
                Unit4 = EelDart.wingAngles(wing, P, -1, x2)

                for _, v197 in ipairs(p67.wings) do
                    Unit5 = (v197.side > 0 and Magnitude2 or Unit4)[v197.k]
                    v197.bone.Transform = CFrame.fromAxisAngle(v197.nose, -v197.side * Unit5[1]) * CFrame.fromAxisAngle(v197.left, Unit5[2])
                end

                for _, v198 in ipairs(p67.flames) do
                    bone, fromAxisAngle = EelDart.fanPose(wing, P, v198.k, v163)
                    v198.bone.Transform = CFrame.fromAxisAngle(v198.right, bone) * CFrame.fromAxisAngle(v198.up, fromAxisAngle)
                end
            end

            x2 = P.stroke
            Unit4 = P.row

            local v199, v200, fromAxisAngle2, upAxis, axis

            if Unit4 then
                local v201 = p67.finPhase or p67.phase

                v175 = p68 * 2 * 3.141592653589793
                bone = v166 * Unit4.rate
                fromAxisAngle = Unit4.maxHz
                p67.finPhase = v201 + v175 * math.min(bone, fromAxisAngle)

                for _, v202 in ipairs(p67.fins) do
                    wing = p67.finPhase - 6.283185307179586 * (Unit4.lag[v202.pair] or 0)
                    wing += Unit4.skew * math.sin(wing)
                    CFramePosition = (1 - math.cos(wing)) / 2
                    v202.bone.Transform = CFrame.fromAxisAngle(v202.axis, v202.side * (Unit4.bias + Unit4.lift * CFramePosition)) * CFrame.fromAxisAngle(v202.upAxis, v202.side * Unit4.sweep * math.sin(wing)) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v202.side * -Unit4.feather * CFramePosition)
                end
            elseif x2 then
                v199 = p67.finPhase or p67.phase
                v175 = p68 * 2 * 3.141592653589793
                bone = v166 * x2.rate
                fromAxisAngle = x2.maxHz
                p67.finPhase = v199 + v175 * math.min(bone, fromAxisAngle)

                for _, v203 in ipairs(p67.fins) do
                    target = v203.lag ~= 0
                    v160 = target and p67.finPhase - x2.lagR or p67.finPhase
                    bone = v203.side * (target and x2.ampR or 1)
                    fromAxisAngle = v203.bone
                    v200 = CFrame.fromAxisAngle(v203.axis, bone * (x2.bias + x2.amp * math.sin(v160)))
                    fromAxisAngle2 = CFrame.fromAxisAngle
                    upAxis = v203.upAxis
                    fromAxisAngle.Transform = v200 * fromAxisAngle2(upAxis, bone * (-x2.sweep * math.sin(v160 - x2.sweepLag))) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), bone * (-x2.feather * math.cos(v160)))
                end
            else
                for _, v206 in ipairs(p67.fins) do
                    bone = v206.bone
                    fromAxisAngle = CFrame.fromAxisAngle
                    axis = v206.axis
                    v200 = v206.side * (P.finAmp or EelSwim.FIN_AMP)
                    upAxis = p67.phase * (P.finRate or EelSwim.FIN_RATE) + v206.lag
                    bone.Transform = fromAxisAngle(axis, v200 * math.sin(upAxis))
                end
            end

            Unit4 = p67.drill

            if Unit4 then
                x2 = P.drill
                v166 = p67.drillSpin

                local v207, v208

                if v166 then
                    v207 = v166
                    v208 = true
                elseif v163 then
                    v166 = x2.max

                    if v166 then
                        v207 = v166
                        v208 = true
                    else
                        v208 = false
                    end
                else
                    v208 = false
                end

                if not v208 then
                    v199 = x2.max
                    x3 = x2.idle + x2.gain * p67.v / v158
                    v207 = math.min(v199, x3)
                end

                Magnitude2 = Unit4.rate
                x3 = v207 - Unit4.rate
                bone = p68 * x2.ease
                Unit4.rate = Magnitude2 + x3 * math.min(1, bone)
                Unit4.angle = (Unit4.angle + p68 * 2 * 3.141592653589793 * Unit4.rate) % 6.283185307179586
                Unit4.bone.Transform = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), Unit4.angle)
            end

            p67.clock += p68
            Unit4 = if v163 then 0 else p67.v / v158

            for _, v209 in ipairs(p67.tendrils) do
                bone, fromAxisAngle = EelDart.tendril(v209.k, v209.n, p67.clock, Unit4, P.tendril)
                v209.bone.Transform = CFrame.fromAxisAngle(v209.right, -bone) * CFrame.fromAxisAngle(v209.nose, fromAxisAngle)
            end

            v158 = P.crest

            local turnMax

            if v158 and #p67.crests > 0 then
                local v210 = p67.jaws[1] and p67.jaws[1].open or 0

                Magnitude2 = kappa:Dot(v157:Cross(v156)) * p67.v
                v175 = p68 * v158.ease
                v199 = math.min(1, v175)
                x3 = p67.crestFold
                axis = Unit4 / v158.foldV
                p67.crestFold = x3 + (math.min(1, axis) - p67.crestFold) * v199
                x3 = p67.crestTurn
                fromAxisAngle = -v158.turn * Magnitude2
                axis = -v158.turnMax
                turnMax = v158.turnMax
                p67.crestTurn = x3 + (math.clamp(fromAxisAngle, axis, turnMax) - p67.crestTurn) * v199

                for _, v211 in ipairs(p67.crests) do
                    axis, turnMax, v200 = EelDart.crestPose(v211.side, p67.crestFold, p67.crestTurn, v210, p67.clock, v158)
                    v211.bone.Transform = CFrame.fromAxisAngle(v211.right, axis) * CFrame.fromAxisAngle(v211.nose, turnMax) * CFrame.fromAxisAngle(v211.up, v200)
                end
            end

            kappa = P.ridge

            if kappa and #p67.blades > 0 then
                Magnitude2 = p67.ridgeStream
                bone = Unit4 / kappa.streamV
                x3 = math.min(1, bone) - p67.ridgeStream
                bone = p68 * kappa.ease
                p67.ridgeStream = Magnitude2 + x3 * math.min(1, bone)

                for _, v212 in ipairs(p67.blades) do
                    bone, fromAxisAngle = EelDart.ridgePose(v212.x, p67.phase, p67.ridgeStream, HOOK_ALPHA, P.lam, kappa)
                    v212.bone.Transform = CFrame.fromAxisAngle(v212.right, bone) * CFrame.fromAxisAngle(v212.nose, fromAxisAngle)
                end
            end

            local v213, v214

            if v163 then
                v214 = false
            elseif #p67.heads > 0 then
                Unit4 = P.turns

                if Unit4 then
                    v213 = Unit4
                    v214 = true
                else
                    v214 = false
                end
            else
                v214 = false
            end

            if not v214 then
                v213 = nil
            end

            if v213 then
                kappa = p1.HydraSwim

                if p67.turnT ~= nil then
                    p67.turnT += p68

                    if p67.turnT >= kappa.STRIKE_TIME then
                        p67.turnT = nil
                        p67.turnI = (p67.turnI or 1) % #p67.heads + 1
                        p67.turnWait = v213.gap[1] + math.random() * (v213.gap[2] - v213.gap[1])
                    end
                else
                    p67.turnWait = (p67.turnWait or 0.5) - p68

                    if p67.turnWait <= 0 then
                        p67.turnT = 0
                    end
                end
            end

            for v215, v216 in ipairs(p67.heads) do
                HOOK_ALPHA = if v213 and p67.turnT and v215 == (p67.turnI or 1) then p1.HydraSwim.strikePitch(p67.turnT / p1.HydraSwim.STRIKE_TIME) else 0
                bone = p1.HydraSwim.pose(v216.k, #v216.bones, v216.side, p67.clock, 0, v163, 1, HOOK_ALPHA)

                for v217, v218 in ipairs(v216.bones) do
                    v218.bone.Transform = CFrame.fromAxisAngle(v218.up, bone[v217][1]) * CFrame.fromAxisAngle(v218.right, bone[v217][2])
                end
            end

            if v213 then
                for _, v219 in ipairs(p67.jaws) do
                    if p67.turnT and v219.head == (p67.turnI or 1) then
                        fromAxisAngle, axis = EelDart.turnJaw(p67.turnT, v213)
                        bone = v213.gape * fromAxisAngle - v213.shut * axis
                    else
                        fromAxisAngle = v213.breath
                        turnMax = v213.breathRate * p67.clock + p1.HydraSwim.GOLD * v219.rank
                        bone = fromAxisAngle * math.sin(turnMax)
                    end

                    v219.bone.Transform = CFrame.fromAxisAngle(v219.right, v219.sign * bone)
                end
            else
                v213 = P.roar

                if v213 and v213.attrs then
                    Magnitude2 = workspace:GetServerTimeNow()
                    v199 = 0

                    for _, v220 in ipairs(v213.attrs) do
                        axis = attr(p67.model, v220)

                        if type(axis) == "number" then
                            fromAxisAngle2 = EelDart.scream
                            upAxis = Magnitude2 - axis
                            v199 = math.max(v199, fromAxisAngle2(upAxis, v213))
                        end
                    end

                    for _, v221 in ipairs(p67.jaws) do
                        v221.open = v199
                        v221.bone.Transform = CFrame.fromAxisAngle(v221.right, v221.sign * EelDart.screamAngle(v199, p67.clock, v213))
                    end
                elseif v213 then
                    Magnitude2 = v213.every

                    for _, v222 in ipairs(p67.jaws) do
                        v222.t += p68 * (v163 and EelDart.JAW_HOOK or 1)

                        if v222.t >= v222.period then
                            v222.t -= v222.period
                            v222.period = Magnitude2[1] + math.random() * (Magnitude2[2] - Magnitude2[1])
                        end

                        if v222.period < v213.open + v213.hold + v213.close then
                            v222.period = Magnitude2[1]
                        end

                        v222.open = EelDart.roar(v222.t, v222.period, v213)
                        v222.bone.Transform = CFrame.fromAxisAngle(v222.right, v222.sign * EelDart.jawAngle(v222.open, p67.clock, v213))
                    end
                elseif bite then
                    v213 = bite.every

                    for _, v223 in ipairs(p67.jaws) do
                        v223.t += p68 * (v163 and EelDart.JAW_HOOK or 1)

                        if v223.t >= v223.period then
                            v223.t -= v223.period
                            v223.period = v213[1] + math.random() * (v213[2] - v213[1])
                        end

                        bone, fromAxisAngle = EelDart.bite(v223.t, v223.period, bite)
                        v223.open = bone
                        v223.bone.Transform = CFrame.fromAxisAngle(v223.right, v223.sign * (bite.gape * bone - bite.shut * fromAxisAngle))
                    end
                else
                    for v224, v225 in ipairs(p67.jaws) do
                        if P.jawSync and v224 > 1 then
                            bone = p67.jaws[1].t
                            fromAxisAngle = p67.jaws[1].period
                            v225.t = bone
                            v225.period = fromAxisAngle
                        else
                            v225.t += p68 * (v163 and EelDart.JAW_HOOK or 1)

                            if v225.t >= v225.period then
                                v225.t -= v225.period
                                bite = P.jawEvery or EelDart.JAW_EVERY
                                v225.period = bite[1] + math.random() * (bite[2] - bite[1])
                            end
                        end

                        bone = v225.period - EelDart.JAW_SNAP
                        axis = v225.t / bone
                        fromAxisAngle = math.clamp(axis, 0, 1)

                        if P.jawStagger then
                            axis = P.jawStagger * bone * (v225.rank - 1) / #p67.jaws
                            fromAxisAngle2 = v225.t - axis
                            v200 = fromAxisAngle2 / math.max(bone - axis, 0.001)
                            fromAxisAngle = math.clamp(v200, 0, 1)
                        end

                        axis = v225.t < bone and fromAxisAngle * fromAxisAngle * (3 - fromAxisAngle * 2) or 1 - (v225.t - bone) / EelDart.JAW_SNAP
                        v225.bone.Transform = CFrame.fromAxisAngle(v225.right, v225.sign * (P.jawGape or EelDart.JAW_GAPE) * axis)
                    end
                end
            end
        end
    }
end
