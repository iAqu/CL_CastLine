-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Chain = require(script.Chain)
local Doors = require(script.Doors)
local Key = require(script.Key)
local Kit = require(script.Parent.Parent.SewerCaveController.Transition.Kit)
local Overlay = require(script.Overlay)
local Sfx = require(script.Sfx)
local Shot = require(script.Shot)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Enum.RenderPriority.Camera.Value + 1
local Looks = Shot.Looks
local v2 = table.freeze({ 1.02, 1.16 })
local v3 = table.freeze({
    { 50, 8 },
    { 44, 8 },
    { 56, 10 },
    { 38, 7 }
})
local v4 = table.freeze({
    { 14, 10 },
    { 10, 9 },
    { 20, 10 },
    { 6, 8 }
})
local v5 = table.freeze({
    { 14, 8 },
    { 8, 7 },
    { 22, 9 },
    { 0, 6 }
})
local v6 = Color3.fromRGB(255, 160, 70)
local v7 = Color3.fromRGB(205, 190, 215)
local v8 = Color3.fromRGB(255, 200, 140)
local t1 = {}

local function once(p1, p2, p3, p4) -- line: 132
    if p3 < p4 or p1.Fired[p2] then
        return false
    end

    p1.Fired[p2] = true

    return true
end

local function part(p5, p6) -- line: 140
    if p5 == nil then
        return nil
    end

    local v9 = p5:FindFirstChild(p6, true)

    return if v9 ~= nil and v9:IsA("BasePart") then v9 else nil
end

local function depthAlong(p7, p8) -- line: 148
    local CFrame, Size = p7.CFrame, p7.Size

    return math.abs((CFrame.RightVector:Dot(p8))) * Size.X + math.abs((CFrame.UpVector:Dot(p8))) * Size.Y + math.abs((CFrame.LookVector:Dot(p8))) * Size.Z
end

local function headOf(p9, p10) -- line: 156
    local Head = p9 and p9:FindFirstChild("Head")

    if Head ~= nil and Head:IsA("BasePart") then
        return Head.Position
    end

    return p10
end

local function ignoreList(p11) -- line: 164
    local t2 = {
        p11.Context.Doors
    }
    local Character = p11.Context.Character

    if Character ~= nil then
        table.insert(t2, Character)
    end

    local Burst = p11.Burst

    if Burst ~= nil then
        table.insert(t2, Burst.Folder)
    end

    local Key = p11.Key

    if Key ~= nil then
        table.insert(t2, Key.Model)
    end

    return t2
end

local function place(p12, p13, p14, p15, p16, p17, p18) -- line: 181
    -- upvalues: Kit (copy)
    local v15 = p12 + p13 * p17
    local n1 = -1

    for _, v16 in p16 do
        local v17 = v15
        local v18 = n1

        for _, v19 in { p15, -p15 } do
            local v21 = math.rad(v16[1])
            local v23 = math.rad(v16[2])
            local v24 = p12 + ((p13 * math.cos(v21) + p14 * (v19 * math.sin(v21))) * math.cos(v23) + Vector3.new(0, 1, 0) * math.sin(v23)) * p17
            local v25 = Kit.Clamp(p12, v24, p18)
            local Magnitude = (v25 - p12).Magnitude

            if p17 * 0.97 <= Magnitude then
                return v25
            end

            if v18 < Magnitude then
                v18 = Magnitude
                v17 = v25
            end

            n1 = v18
            v15 = v17
        end
    end

    return v15
end

local function frames(p19) -- line: 213
    -- upvalues: Players (copy), Doors (copy), Shot (copy), v3 (copy), v4 (copy), v5 (copy), ignoreList (copy), place (copy)
    local Rig = p19.Rig
    local v26 = ignoreList(p19)

    for _, player in Players:GetPlayers() do
        if player.Character ~= nil then
            table.insert(v26, player.Character)
        end
    end

    local v27 = -p19.Inward
    local Character = p19.Context.Character
    local v28 = p19.Keyhole + v27 * 12
    local Head = Character and Character:FindFirstChild("Head")

    if Head ~= nil and Head:IsA("BasePart") then
        v28 = Head.Position
    end

    local v29 = if (v28 - p19.Keyhole):Dot(p19.Across) >= 0 then 1 else -1

    p19.Side = v29

    local v30 = p19.Keyhole + v27 * 2.5 + Vector3.new(0, 1, 0)
    local v31 = place(v30, v27, p19.Across, v29, v3, 22, v26)
    local v32 = if (v31 - v30):Dot(p19.Across) >= 0 then 1 else -1
    local v33 = place(v30, v27, p19.Across, v32, v4, 22, v26)
    local v34 = math.max((v33 - v30).Magnitude, 1)

    p19.CloseLook = v30
    p19.Close = CFrame.lookAt(v31, v30)
    p19.Front = CFrame.lookAt(v33, v30)
    p19.CloseFov = math.clamp(math.deg((math.atan(10.5 / v34))) * 2, 30, p19.Shot.FieldOfView)

    local v38 = Doors.Point(Rig, 0, Rig.Height * 0.3, -6)

    p19.WideLook = v38
    p19.Wide = CFrame.lookAt(place(v38, v27, p19.Across, v29, v5, 40, v26), v38)
    p19.Start = p19.Shot.Camera.CFrame
    p19.StartLook = p19.Start.Position + p19.Start.LookVector * 20
    p19.Aim = p19.Start.LookVector
    p19.Reach = Shot.Reach()
end

local function kick(p20, p21, p22, p23, p24, p25) -- line: 248
    table.insert(p20.Kicks, {
        At = p20.Clock,
        Strength = p21,
        Seconds = p22,
        Push = p23,
        Roll = p24 or 0,
        Punch = p25 or 0
    })
end

local function shake(p26, p27) -- line: 266
    if p26.Shot.Calm then
        return CFrame.identity, 0
    end

    local n2 = 0
    local n3 = 0
    local n4 = 0
    local n5 = 0
    local n6 = 0

    for _, v39 in p26.Kicks do
        local v40 = p27 - v39.At

        if v40 >= 0 and v40 < v39.Seconds then
            local v41 = (1 - v40 / v39.Seconds) ^ 2
            local v42 = v39.At * 13.1

            n2 += math.noise(p27 * 38, v42, 0.3) * 2 * v39.Strength * v41
            n3 += math.noise(p27 * 38, v42, 5.7) * 2 * v39.Strength * v41
            n5 += math.noise(p27 * 38 * 0.5, v42, 9.1) * 2 * v39.Roll * v41
            n4 += v39.Push * v41
            n6 += v39.Punch * v41
        end
    end

    return CFrame.new(n2, n3, -n4) * CFrame.Angles(0, 0, n5), n6
end

local function handBack(p28) -- line: 286
    -- upvalues: Kit (copy), Shot (copy), ignoreList (copy)
    local Root = p28.Root

    if Root == nil or Root.Parent == nil then
        return p28.Start, p28.Start
    end

    local v43 = Shot.Pose(Root, p28.Aim, p28.Reach)
    local v44 = v43.Position + v43.LookVector * p28.Reach
    local v45 = ignoreList(p28)

    return CFrame.lookAt(Kit.Clamp(v44, v43.Position, v45), v44), v43
end

local function blend(p29, p30, p31, p32, p33) -- line: 297
    return CFrame.lookAt(p29.Position:Lerp(p31.Position, p33), p30:Lerp(p32, p33))
end

local function cameraStep(p34, p35) -- line: 307
    -- upvalues: Kit (copy), Shot (copy), shake (copy), handBack (copy)
    local Shot2 = p34.Shot
    local FieldOfView = Shot2.FieldOfView
    local v46 = p34.Close.Position - p34.CloseLook
    local v47 = p34.Front.Position - p34.CloseLook
    local v48 = Kit.Ease(Kit.Span(p35, 0.86, 1.3), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local v49 = v46.Unit:Lerp(v47.Unit, v48).Unit * math.lerp(v46.Magnitude, v47.Magnitude, v48)
    local v50 = CFrame.lookAt(p34.CloseLook + v49 - v49.Unit * (1.4 * Kit.Smooth(Kit.Span(p35, 0.5, 1.58))), p34.CloseLook)
    local Unit2 = (p34.WideLook - p34.Wide.Position).Unit
    local v51 = CFrame.lookAt(p34.Wide.Position + Unit2 * (3 * Kit.Smooth(Kit.Span(p35, 1.58, 2.88))), p34.WideLook)

    if p35 < 0.5 then
        local v52 = Kit.Ease(p35 / 0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
        local Start, StartLook, Close, CloseLook = p34.Start, p34.StartLook, p34.Close, p34.CloseLook

        v50 = CFrame.lookAt(Start.Position:Lerp(Close.Position, v52), StartLook:Lerp(CloseLook, v52))
        FieldOfView = math.lerp(Shot2.FieldOfView, p34.CloseFov, v52)
    elseif p35 < 1.58 then
        FieldOfView = p34.CloseFov
    elseif p35 < 2.45 then
        local v53 = Kit.Ease(Kit.Span(p35, 1.58, 2.45), Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
        local CloseLook, WideLook = p34.CloseLook, p34.WideLook

        v50 = CFrame.lookAt(v50.Position:Lerp(v51.Position, v53), CloseLook:Lerp(WideLook, v53))
        FieldOfView = math.lerp(p34.CloseFov, Shot2.FieldOfView, v53)
    elseif p35 < 2.88 then
        v50 = v51
    else
        local v54 = Kit.Ease(Kit.Span(p35, 2.88, 3.45), Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
        local v55 = handBack(p34)
        local v56 = v55.Position + v55.LookVector * p34.Reach
        local WideLook = p34.WideLook

        v50 = CFrame.lookAt(v51.Position:Lerp(v55.Position, v54), WideLook:Lerp(v56, v54))
    end

    local v57, v58 = shake(p34, p35)

    Shot.Place(Shot2, v50 * v57, FieldOfView + v58)
end

local function lookStep(p36, p37) -- line: 363
    -- upvalues: Kit (copy), Overlay (copy), Shot (copy), Looks (copy)
    local Shot2, Overlay2 = p36.Shot, p36.Overlay

    if p37 < 1.46 then
        Shot.Look(Shot2, Looks.Clear, Looks.Keyhole, Kit.Span(p37, 0, 0.5))
        Overlay.Vignette(Overlay2, 0.55 * Kit.Span(p37, 0, 0.5))
    elseif p37 < 1.88 then
        Shot.Look(Shot2, Looks.Keyhole, Looks.Clear, Kit.Span(p37, 1.53, 1.88))
        Overlay.Vignette(Overlay2, 0.55 * (1 - Kit.Span(p37, 1.46, 2.45)))
    elseif p37 < 2.88 then
        Shot.Look(Shot2, Looks.Clear, Looks.Spill, Kit.Span(p37, 1.88, 2.6799999999999997))
        Overlay.Vignette(Overlay2, 0.55 * (1 - Kit.Span(p37, 1.46, 2.45)))
    else
        Shot.Look(Shot2, Looks.Spill, Looks.Clear, Kit.Span(p37, 2.88, 3.45))
        Overlay.Vignette(Overlay2, 0)
    end

    if Shot2.Calm then
        Overlay.Ring(Overlay2, Vector2.new(0.5, 0.5), 0)
        Overlay.Wash(Overlay2, Shot.White, 0)
    else
        local v59 = Kit.Projected(Shot2.Camera, p36.Keyhole)

        Overlay.Ring(Overlay2, v59, Kit.Span(p37, 1.46, 1.76))

        local v60 = not (p37 >= 1.46 and p37 < 1.49) and 0 or 0.12

        Overlay.Wash(Overlay2, Color3.fromRGB(255, 240, 220), v60)
    end
end

local function keyStep(p38, p39) -- line: 395
    -- upvalues: Key (copy), Kit (copy), v2 (copy)
    local Key2 = p38.Key

    if Key2 ~= nil and not (p39 >= 1.46) then
        local v61 = Key.Seat(Key2, p38.Keyhole, p38.Inward, 0.3)
        local v62 = -p38.Inward

        Key.Show(Key2, Kit.Span(p39, 0.3, 0.42))

        if p39 < 0.9 then
            local v63 = Kit.Ease(Kit.Span(p39, 0.56, 0.9), Enum.EasingStyle.Cubic, Enum.EasingDirection.In)

            Key.Place(Key2, v61 + v62 * (5.5 * (1 - v63)))
        else
            local n7 = 0

            for _, v64 in v2 do
                n7 += Kit.Ease(Kit.Span(p39, v64, v64 + 0.1), Enum.EasingStyle.Back, Enum.EasingDirection.Out) * 0.7853981633974483
            end

            local v65 = if p39 < 0.98 then (1 - Kit.Span(p39, 0.9, 0.98)) * 0.25 else 0

            Key.Place(Key2, (v61 + p38.Inward * v65) * CFrame.Angles(0, n7, 0))
        end
    end
end

local function lockStep(p40, p41) -- line: 426
    -- upvalues: Chain (copy), Kit (copy), v2 (copy)
    local Burst = p40.Burst

    if Burst == nil or Burst.Snapped then
        return
    end

    local Inward = p40.Inward

    if p41 >= 0.9 and p41 < 1 then
        local v66 = (1 - Kit.Span(p41, 0.9, 1)) * 0.3

        Chain.Nudge(Burst, Burst.PadlockSource, Inward * v66)
        Chain.Nudge(Burst, Burst.ShackleSource, Inward * v66)
    elseif p41 >= 1 then
        Chain.Nudge(Burst, Burst.PadlockSource, (Vector3.new(0, 0, 0)))
    end

    local n8 = 0

    for _, v67 in v2 do
        if v67 <= p41 and p41 < v67 + 0.12 then
            n8 = 1 - Kit.Span(p41, v67, v67 + 0.12)
        end
    end

    local Rattle = Chain.Rattle

    if p40.Shot.Calm then
        n8 = 0
    end

    Rattle(Burst, n8, p41)

    local ShackleSource = Burst.ShackleSource

    if ShackleSource ~= nil and p41 >= 1.36 then
        local v68 = Burst.Rest[ShackleSource]

        if v68 ~= nil then
            local v69 = Kit.Ease(Kit.Span(p41, 1.36, 1.4400000000000002), Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local v70 = v68.Position - p40.Across * (ShackleSource.Size.X * 0.3) - Vector3.new(0, 1, 0) * (ShackleSource.Size.Y * 0.15)

            ShackleSource.CFrame = CFrame.new(v70) * CFrame.fromAxisAngle(Inward, 0.4188790204786391 * v69) * CFrame.new(-v70) * v68 + Vector3.new(0, 1, 0) * (1.4 * v69)
        end
    end

    local Glow = p40.Glow

    if p41 < v2[1] then
        Glow.Brightness = 0
    else
        Glow.Brightness = 4 * Kit.Span(p41, v2[1], 1.36)
    end
end

local function swing(p42) -- line: 468
    if p42 <= 0.68 then
        local v71 = p42 / 0.68

        return v71 * 0.3 + v71 * 0.7 * v71
    end

    local v72 = (p42 - 0.68) / 0.31999999999999995

    return 1 - math.sin(v72 * 3.141592653589793) * 0.1 * (1 - v72)
end

local function doorStep(p43, p44) -- line: 477
    -- upvalues: Chain (copy), Doors (copy), Kit (copy)
    if p44 < 1.88 then
        return
    end

    local Calm = p43.Shot.Calm

    for v74 in p43.Rig.Swings do
        local v75 = 1.88 + (v74 - 1) * 0.09

        if v75 <= p44 then
            local v76 = Kit.Span(p44, v75, v75 + 0.8)
            local v77

            if Calm then
                v77 = Kit.Ease(v76, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            elseif v76 <= 0.68 then
                local v78 = v76 / 0.68

                v77 = v78 * 0.3 + v78 * 0.7 * v78
            else
                local v79 = (v76 - 0.68) / 0.31999999999999995

                v77 = 1 - math.sin(v79 * 3.141592653589793) * 0.1 * (1 - v79)
            end

            Doors.PoseSwing(p43.Rig, v74, v77)
        end
    end

    local Burst = p43.Burst

    if Burst ~= nil and Burst.Snapped then
        local t4 = {}

        for v81 in p43.Rig.Swings do
            local v82, v83, v84 = Doors.Leaf(p43.Rig, v81)

            if v82 ~= nil and v83 ~= nil then
                table.insert(t4, {
                    Hinge = v82,
                    Along = v83,
                    Reach = v84
                })
            end
        end

        Chain.Plow(Burst, t4, -p43.Inward)
    end

    local Foyer = p43.Foyer

    if Foyer ~= nil then
        Foyer.Lit = Kit.Smooth(Kit.Span(p44, 1.88, 2.6799999999999997))
    end
end

local function cues(p45, p46) -- line: 509
    -- upvalues: Chain (copy), Doors (copy), Key (copy), Sfx (copy), v2 (copy)
    local Calm = p45.Shot.Calm
    local Burst, Key2 = p45.Burst, p45.Key

    if not (p46 < 0.3 or p45.Fired.Glint) then
        p45.Fired.Glint = true
        Sfx.Play("Shimmer", 0.4, 1.2)

        if Key2 ~= nil then
            Key2.Sparkle:Emit(10)
        end
    end

    if not (p46 < 0.9 or p45.Fired.Thunk) then
        p45.Fired.Thunk = true
        Sfx.At("KeyThunk", p45.Keyhole, 1)
        table.insert(p45.Kicks, {
            Strength = 0.12,
            Seconds = 0.22,
            Push = 0.35,
            Roll = 0,
            Punch = 0,
            At = p45.Clock
        })

        if Burst ~= nil then
            Burst.Sparks.WorldPosition = p45.Keyhole - p45.Inward * 0.5
            Burst.Dust:Emit(4)
        end
    end

    for v85, v86 in v2 do
        local v87 = ("Turn%*"):format(v85)

        if not (p46 < v86 or p45.Fired[v87]) then
            p45.Fired[v87] = true

            if v85 < #v2 then
                Sfx.At("Ratchet", p45.Keyhole, 0.9, 1 + v85 * 0.08)
                Sfx.At("ChainRattle", p45.Keyhole, 0.35, 1.1)
                table.insert(p45.Kicks, {
                    Strength = 0.04,
                    Seconds = 0.1,
                    Push = 0.08,
                    Roll = 0,
                    Punch = 0,
                    At = p45.Clock
                })
            else
                Sfx.At("KeyThunk", p45.Keyhole, 1, 0.72)
                Sfx.At("PadlockClunk", p45.Keyhole, 0.9, 0.85)
                table.insert(p45.Kicks, {
                    Strength = 0.16,
                    Seconds = 0.25,
                    Push = 0.3,
                    Roll = 0,
                    Punch = 0,
                    At = p45.Clock
                })
            end
        end
    end

    if not (p46 < 1.36 or p45.Fired.Pop) then
        p45.Fired.Pop = true
        Sfx.At("KeyTurn", p45.Keyhole, 0.8, 0.75)
        table.insert(p45.Kicks, {
            Strength = 0.08,
            Seconds = 0.15,
            Push = 0,
            Roll = 0,
            Punch = 0,
            At = p45.Clock
        })
    end

    if not (p46 < 1.46 or p45.Fired.Snap) then
        p45.Fired.Snap = true
        p45.Frozen = 0.07

        if Burst ~= nil then
            Chain.Snap(Burst, -p45.Inward, Calm, 0.07, p45.Across * -p45.Side)

            if Key2 ~= nil and Burst.Padlock ~= nil then
                Key.Weld(Key2, Burst.Padlock)
            end
        end

        if Key2 ~= nil then
            Key.Fade(Key2)
        end

        Sfx.Play("ChainSnap", 0.85)
        Sfx.At("ChainSnap", p45.Keyhole, 0.6, 0.9)

        if not Calm then
            Sfx.Play("Boom", 0.22)
        end

        table.insert(p45.Kicks, {
            Strength = 0.4,
            Seconds = 0.4,
            Push = 0.6,
            Roll = 0,
            Punch = 4,
            At = p45.Clock
        })
    end

    if not (p46 < 1.8299999999999998 or p45.Fired.Foyer) then
        p45.Fired.Foyer = true

        local v88 = Doors.SetFoyer(p45.Rig, true)

        if v88 ~= nil then
            v88.Lit = 0
        end

        p45.Foyer = v88
    end

    if not (p46 < 1.88 or p45.Fired.Creak) then
        p45.Fired.Creak = true
        Sfx.At("Creak", Doors.Point(p45.Rig, 0, p45.Rig.Height * 0.3, 0), 1, 0.85)
    end

    for v89 in p45.Rig.Swings do
        local v90 = 1.88 + (v89 - 1) * 0.09 + 0.544
        local v91 = ("Stop%*"):format(v89)

        if not (p46 < v90 or p45.Fired[v91]) then
            p45.Fired[v91] = true

            local v92 = Doors.Tip(p45.Rig, v89)

            if v92 ~= nil then
                Sfx.At("DoorSlam", v92, 0.55, 0.7 + v89 * 0.06)

                if not Calm then
                    local v93 = Doors.Point(p45.Rig, 0, 1, 0)

                    p45.Thud.Parent.WorldPosition = Vector3.new(v92.X, v93.Y, v92.Z)
                    p45.Thud:Emit(10)
                end
            end

            table.insert(p45.Kicks, {
                Strength = 0.3,
                Seconds = 0.32,
                Push = -0.25,
                Roll = 0.015,
                Punch = 2,
                At = p45.Clock
            })
        end
    end

    if not (p46 < 2.88 or p45.Fired.Tidy) then
        p45.Fired.Tidy = true

        if Burst ~= nil and Burst.Snapped then
            Chain.Tidy(Burst, p45.Keyhole, p45.Across, 5)
        end
    end

    if p46 < 2.13 or p45.Fired.Breath then
        return
    end

    p45.Fired.Breath = true
    Sfx.Play("Draft", 0.3, 1.1)

    if not Calm then
        p45.Puff:Emit(14)
        p45.Wisps:Emit(6)
    end
end

local function finish(p47) -- line: 601
    -- upvalues: Chain (copy), Doors (copy), Key (copy)
    if p47.Done then
        return
    end

    p47.Done = true
    Doors.Pose(p47.Rig, 1)

    local v94 = Doors.SetFoyer(p47.Rig, true)

    if v94 ~= nil then
        v94.Lit = 1
    end

    local Burst = p47.Burst

    if Burst ~= nil then
        if not Burst.Snapped then
            Chain.Snap(Burst, -p47.Inward, true, 0)

            if p47.Key ~= nil then
                Key.Fade(p47.Key)
            end
        end

        Chain.Tidy(Burst, p47.Keyhole, p47.Across, 5)
        Chain.Keep(Burst)
    elseif p47.Context.Lock ~= nil then
        Chain.Hide(p47.Context.Lock, true)
    end

    p47.Trove:Destroy()
end

local function step(p48, p49) -- line: 627
    -- upvalues: cameraStep (copy), lookStep (copy), keyStep (copy), lockStep (copy), doorStep (copy), cues (copy)
    if p48.Frozen > 0 then
        p48.Frozen -= p49
        cameraStep(p48, p48.Clock)
    else
        p48.Clock += p49

        local Clock = p48.Clock

        cues(p48, Clock)
        keyStep(p48, Clock)
        lockStep(p48, Clock)
        doorStep(p48, Clock)
        lookStep(p48, Clock)
        cameraStep(p48, Clock)
    end
end

local function stepAside(p50) -- line: 643
    -- upvalues: Doors (copy)
    local Root, Humanoid = p50.Root, p50.Humanoid

    if Root ~= nil and Humanoid ~= nil and not (Humanoid.Health <= 0) then
        local v95 = Doors.Clearing(p50.Rig, Root.Position, 2.5)

        if v95 == nil then
            return
        end

        local AutoRotate = Humanoid.AutoRotate

        Humanoid.AutoRotate = false
        Humanoid:MoveTo(v95)
        p50.Trove:Add(function() -- line: 656
            -- upvalues: Humanoid (copy), AutoRotate (copy)
            if Humanoid.Parent ~= nil then
                Humanoid.AutoRotate = AutoRotate
            end
        end)
    end
end

local function thud(p51) -- line: 663
    -- upvalues: Workspace (copy), v7 (copy)
    local v96 = p51:Add(Instance.new("Attachment"))

    v96.Name = "ManorDoorThud"
    v96.Parent = Workspace.Terrain

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Dust"
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Rate = 0
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Sphere
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.LightInfluence = 0.6
    ParticleEmitter.Color = ColorSequence.new(v7)
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0.55),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(1, 7)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.1)
    ParticleEmitter.Speed = NumberRange.new(4, 9)
    ParticleEmitter.SpreadAngle = Vector2.new(70, 70)
    ParticleEmitter.Drag = 3
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-60, 60)
    ParticleEmitter.Acceleration = Vector3.new(0, -1, 0)
    ParticleEmitter.Parent = v96

    return ParticleEmitter
end

local function breath(p52, p53) -- line: 696
    -- upvalues: Workspace (copy), Doors (copy), v7 (copy), v8 (copy)
    local v97 = p52:Add(Instance.new("Attachment"))

    v97.Name = "ManorDoorBreath"
    v97.WorldCFrame = CFrame.lookAt(Doors.Point(p53, 0, p53.Height * 0.2, 2), Doors.Point(p53, 0, p53.Height * 0.2, -10))
    v97.Parent = Workspace.Terrain

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Mist"
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Rate = 0
    ParticleEmitter.EmissionDirection = Enum.NormalId.Front
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.LightInfluence = 0.5
    ParticleEmitter.Color = ColorSequence.new(v7)
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.6),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 5),
        NumberSequenceKeypoint.new(1, 14)
    })
    ParticleEmitter.Lifetime = NumberRange.new(1, 1.6)
    ParticleEmitter.Speed = NumberRange.new(10, 18)
    ParticleEmitter.SpreadAngle = Vector2.new(35, 15)
    ParticleEmitter.Drag = 2.5
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-40, 40)
    ParticleEmitter.Acceleration = Vector3.new(0, -2, 0)
    ParticleEmitter.Parent = v97

    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Name = "Wisps"
    ParticleEmitter2.Texture = "rbxassetid://84182473776460"
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.EmissionDirection = Enum.NormalId.Front
    ParticleEmitter2.LightEmission = 1
    ParticleEmitter2.LightInfluence = 0
    ParticleEmitter2.Color = ColorSequence.new(v8, Color3.new(1, 1, 1))
    ParticleEmitter2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0.25),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter2.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.6),
        NumberSequenceKeypoint.new(1, 3.4)
    })
    ParticleEmitter2.Lifetime = NumberRange.new(0.9, 1.4)
    ParticleEmitter2.Speed = NumberRange.new(14, 22)
    ParticleEmitter2.SpreadAngle = Vector2.new(40, 25)
    ParticleEmitter2.Drag = 1.5
    ParticleEmitter2.Rotation = NumberRange.new(0, 360)
    ParticleEmitter2.RotSpeed = NumberRange.new(-120, 120)
    ParticleEmitter2.Acceleration = Vector3.new(0, 6, 0)
    ParticleEmitter2.Parent = v97

    return ParticleEmitter, ParticleEmitter2
end

local function begin(p54) -- line: 758
    -- upvalues: Workspace (copy), Chain (copy), Doors (copy), Key (copy), Overlay (copy), Shot (copy), Trove (copy), LocalPlayer (copy), v6 (copy), depthAlong (copy), frames (copy), stepAside (copy), thud (copy), breath (copy)
    local v98 = Doors.Rig(p54.Doors, p54.Lock)

    if v98 == nil then
        return nil
    end

    local v99 = Shot.Take()

    if v99 == nil then
        return nil
    end

    local v100 = Trove.new()
    local v101 = Doors.Inward(v98)
    local Unit = (Vector3.new(0, 1, 0)):Cross(v101).Unit
    local Lock = p54.Lock
    local v102

    if Lock ~= nil then
        v102 = Lock:FindFirstChild("Cube.003", true)

        if v102 == nil or not v102:IsA("BasePart") then
            v102 = nil
        end
    end

    local v103 = if v102 == nil then Doors.Point(v98, 0, v98.Height * 0.23, -v98.Depth) else v102.Position - v101 * (depthAlong(v102, v101) / 2) - Vector3.new(0, 0.4, 0)
    local v104

    if Lock ~= nil then
        v104 = Chain.Prepare(Trove.new(), Lock)
        v104.Ground = Doors.Point(v98, 0, 0, 0).Y
    end

    local v105 = v100:Add(Instance.new("Attachment"))

    v105.Name = "ManorKeyhole"
    v105.WorldPosition = v103 - v101 * 0.8
    v105.Parent = Workspace.Terrain

    local PointLight = Instance.new("PointLight")

    PointLight.Brightness = 0
    PointLight.Range = 10
    PointLight.Color = v6
    PointLight.Shadows = false
    PointLight.Parent = v105

    local v106, v107 = breath(v100, v98)
    local t12 = {
        Context = p54,
        Trove = v100,
        Rig = v98,
        Shot = v99,
        Overlay = Overlay.Build(v100),
        Burst = v104,
        Key = nil,
        Foyer = nil,
        Keyhole = v103,
        Inward = v101,
        Across = Unit,
        Side = 1,
        Start = v99.Camera.CFrame,
        StartLook = v103,
        Close = v99.Camera.CFrame,
        Front = v99.Camera.CFrame,
        CloseLook = v103,
        CloseFov = v99.FieldOfView,
        Wide = v99.Camera.CFrame,
        WideLook = v103,
        Aim = v99.Camera.CFrame.LookVector,
        Reach = 12,
        Root = nil,
        Humanoid = nil,
        Glow = PointLight,
        Puff = v106,
        Wisps = v107,
        Thud = thud(v100),
        Kicks = {},
        Clock = 0,
        Frozen = 0,
        Done = false,
        Fired = {}
    }

    t12.Key = if v104 == nil then Key.Build(v100, Workspace) else Key.Build(v104.Trove, v104.Folder)

    local v108 = p54.Character or LocalPlayer.Character
    local v109 = v108

    if v108 then
        v109 = v108:FindFirstChild("HumanoidRootPart")
        v108 = v108:FindFirstChildOfClass("Humanoid")
    end

    t12.Root = if v109 == nil or not v109:IsA("BasePart") then nil else v109
    t12.Humanoid = v108
    frames(t12)
    stepAside(t12)

    return t12
end

function t1.Play(p55) -- line: 848
    -- upvalues: Sfx (copy), Shot (copy), LocalPlayer (copy), v1 (copy), t1 (copy), handBack (copy), finish (copy), step (copy), begin (copy)
    Sfx.Warm()

    local v110 = begin(p55)

    if v110 ~= nil then
        local v111 = p55.Character or LocalPlayer.Character
        local Humanoid = v111 and v111:FindFirstChildOfClass("Humanoid")
        local v112 = false

        if Humanoid ~= nil then
            v110.Trove:Connect(Humanoid.Died, function() -- line: 859
                -- upvalues: v112 (ref)
                v112 = true
            end)
        end

        v110.Trove:Connect(LocalPlayer.CharacterAdded, function() -- line: 863
            -- upvalues: v112 (ref)
            v112 = true
        end)

        local v113 = false

        v110.Trove:BindToRenderStep("ManorDoorUnlock", v1, function(p56) -- line: 867
            -- upvalues: v110 (copy), v112 (ref), v113 (ref), step (copy)
            if not v110.Done and not v113 and not v112 then
                local ok, result = pcall(step, v110, p56)

                if not ok then
                    v113 = true
                    warn((("[ManorInterior] unlock step stopped: %*"):format(result)))
                end
            end
        end)

        while not v110.Done and not v113 and not v112 and not v110.Shot.Done and v110.Clock < 3.45 do
            task.wait()
        end

        local v114, v115

        if not v112 and not v113 and not v110.Shot.Done then
            v114, v115 = handBack(v110)
        end

        finish(v110)
        Shot.Release(v110.Shot, v114, v115)
    else
        t1.SetOpen(p55, true)
    end
end

function t1.SetOpen(p57, p58) -- line: 894
    -- upvalues: Chain (copy), Doors (copy)
    local v116 = Doors.Rig(p57.Doors, p57.Lock)
    local Lock = p57.Lock

    if p58 then
        if Lock ~= nil then
            Chain.Hide(Lock, true)
        end

        if v116 ~= nil then
            Doors.Pose(v116, 1)
            Doors.SetFoyer(v116, true)
        end
    else
        Chain.Clear()

        if Lock ~= nil then
            Chain.Hide(Lock, false)
        end

        if v116 ~= nil then
            Doors.Pose(v116, 0)
            Doors.SetFoyer(v116, false)
        end
    end
end

return t1
