-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Depths = require(script.Parent.Depths)
local Double = require(script.Parent.Double)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Hands = require(script.Parent.Hands)
local Kit = require(script.Parent.Kit)
local Overlay = require(script.Parent.Overlay)
local Score = require(script.Parent.Score)
local Splash = require(script.Parent.Splash)
local Stage = require(script.Parent.Stage)
local v1 = CFrame.new(-6200, 30000, 20900)
local Looks = Kit.Looks
local t1 = {}

local function setLook(p1, p2, p3, p4) -- line: 39
    -- upvalues: Kit (copy)
    Kit.Mix(p1.Grade.Look, p2, p3, p4)
end

local function mouthOf(p5) -- line: 43
    -- upvalues: Kit (copy), Stage (copy)
    local v2 = Stage.OutletFlange()
    local RootPosition = p5.Root.Position

    if v2 == nil then
        local Pipe = p5.Context.Pipe

        if Pipe == nil then
            local v3 = Kit.FlatUnit(p5.Root.CFrame.LookVector, (Vector3.new(0, 0, 1)))

            return RootPosition + v3 * 10, v3
        end

        local v4 = Kit.FlatUnit(Pipe.Position - RootPosition, (Vector3.new(1, 0, 0)))

        return Pipe.Position + v4 * 8, v4
    end

    local RightVector = v2.CFrame.RightVector

    if RightVector:Dot((Kit.FlatUnit(RootPosition - v2.Position, -RightVector))) > 0 then
        RightVector = -RightVector
    end

    return v2.Position, Kit.FlatUnit(RightVector, (Vector3.new(1, 0, 0)))
end

local function suction(p6, p7) -- line: 62
    -- upvalues: Double (copy), Kit (copy), Splash (copy), Looks (copy)
    local State, Double2 = p6.State, p6.Double
    local Mouth, Inward, Start = State.Mouth, State.Inward, State.Start
    local v5 = Kit.Span(p7, 0, 0.55)
    local v6 = Kit.Ease(v5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v7 = Mouth + Inward * 8
    local v12 = Start.Position:Lerp(v7, v6) + Vector3.new(0, math.sin(math.min(v5 * 2, 1) * 3.141592653589793 / 2) * -1.2, 0)
    local v13 = Kit.Smooth(Kit.Span(p7, 0, 0.35))
    local v14 = Kit.FlatUnit(v7 - Start.Position, Inward)
    local v15 = CFrame.lookAt(v12, v12 + v14) * CFrame.Angles(-1.4835298641951802 * v13, 0, 0)

    if Double2 then
        Double.Pose(Double2, Double.Blend(Double.Poses.Rest, Double.Poses.Slide, v13))
        Double.Place(Double2, v15)
    end

    Splash.Jet(p6.Splash, Start.Position - v14 * 4 + Vector3.new(0, -2, 0), Mouth + Inward * 4, 1 - Kit.Span(p7, 0.35, 0.55))

    local Clear, MoonTeal = Looks.Clear, Looks.MoonTeal
    local v16 = Kit.Smooth(p7 / 0.3)

    Kit.Mix(p6.Grade.Look, Clear, MoonTeal, v16)

    if p7 >= 0.49000000000000005 then
        local MoonTeal, Flash = Looks.MoonTeal, Looks.Flash
        local v17 = Kit.Span(p7, 0.49000000000000005, 0.55)

        Kit.Mix(p6.Grade.Look, MoonTeal, Flash, v17)
    end

    Kit.Apply(p6.Grade, 0)

    if p6.OwnsCamera then
        local StartCamera = State.StartCamera
        local v18 = Start.Position - v14 * 11 + Vector3.new(0, 3.5, 0)
        local v19 = StartCamera.Position:Lerp(v18, Kit.Smooth(p7 / 0.3))
        local v20 = Kit.Ease(Kit.Span(p7, 0.35, 0.55), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v21 = v19:Lerp(Mouth - Inward * 3, v20 * 0.7)
        local v22 = Kit.Clamp(v12 + Vector3.new(0, 2, 0), v21, {
            p6.Character,
            p6.Folder
        })

        p6.Camera.CFrame = CFrame.lookAt(v22, v12:Lerp(Mouth + Inward * 6, 0.5 + 0.5 * v20))

        local v25 = math.lerp(p6.FieldOfView, p6.FieldOfView + 10, Kit.Smooth(p7 / 0.35))

        p6.Camera.FieldOfView = math.lerp(v25, 40, v20)
    end
end

local function enterPipe(p8) -- line: 110
    -- upvalues: Depths (copy), Flash (copy), Score (copy), Splash (copy), Stage (copy)
    local State = p8.State
    local Depths2 = State.Depths

    Stage.Phase(p8, "Ride")
    Splash.Jet(p8.Splash, Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), 0)
    Flash.Play({
        Attack = 0.03,
        Decay = 0.14,
        Opacity = 0.9,
        Tint = Color3.fromRGB(215, 255, 225)
    })
    Stage.Arrive(p8)
    Score.Under(p8.Score, true, 0.05)
    Score.Stop(p8.Score, "Pour")
    Score.Play(p8.Score, "Swoosh", 0.6, 0.9)
    Score.Loop(p8.Score, "Hole", 0.45, 0.8)
    Depths2.Model.Parent = p8.Folder
    Depths.Light(Depths2, 3)
    State.Clanked = false
    State.Waved = false
end

local function ride(p9, p10, p11) -- line: 127
    -- upvalues: Depths (copy), Double (copy), Hands (copy), Kit (copy), Overlay (copy), Score (copy), Stage (copy), Looks (copy)
    local State = p9.State
    local Depths2 = State.Depths
    local Origin = Depths2.Origin
    local v27 = (1 - math.exp(-p10 / 0.7)) * 52
    local v28 = Depths2.Floor - 4 - v27
    local v29 = v28 - 9
    local Double2 = p9.Double
    local v30 = Kit.Ease(p10 / 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    Depths.Step(Depths2, Stage.Elapsed(p9), p11, 0.4)

    local v31 = Kit.Span(p10, 0.4, 1.2)

    Depths2.EndCap.Color = Kit.CaveGreen:Lerp(Kit.Moon, v31)
    Depths2.Glow.Color = Depths2.EndCap.Color

    if Double2 then
        local v33 = math.sin(p10 * 9) * 0.17453292519943295

        Double.Pose(Double2, Double.Poses.Slide)
        Double.Place(Double2, Origin * CFrame.new(0, v29, 0) * CFrame.Angles(3.141592653589793, p10 * 2, v33))
    end

    local Crew = State.Crew

    if Crew ~= nil and p10 >= 0.4 then
        local v34 = Crew.Hands[1]

        if not State.Waved then
            State.Waved = true
            Hands.Visible(v34, true)
            Hands.Show(v34, "Wave")
            Hands.Puff(v34, 5)
            Score.Play(p9.Score, "Giggle", 0.3, 1.1)
        end

        local v35 = Depths2.Floor - 30
        local v36 = Kit.Ease((p10 - 0.4) / 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local v38 = Origin * Vector3.new(Depths2.PipeRadius - 3.2 * v36, v35, 0)
        local v40 = math.sin(p10 * 22) * 0.4886921905584123
        local v41 = CFrame.lookAt(v38, p9.Camera.CFrame.Position, (Vector3.new(0, 1, 0)))

        Hands.Place(v34, v41 * CFrame.Angles(0, 0, v40))
        Crew.LightPart.CFrame = CFrame.new(v38)
    end

    if not State.Clanked and p10 >= 0.3 then
        State.Clanked = true
        Score.Play(p9.Score, "Clank", 0.5, 0.9)
    end

    local Flash, Pipe = Looks.Flash, Looks.Pipe

    Kit.Mix(p9.Grade.Look, Flash, Pipe, v30)

    if v31 > 0 then
        local Pipe, Haze = Looks.Pipe, Looks.Haze
        local v42 = v31 * 0.5

        Kit.Mix(p9.Grade.Look, Pipe, Haze, v42)
    end

    Kit.Apply(p9.Grade, 0)
    Overlay.Vignette(p9.Overlay, 0.5 * v30)

    if p9.OwnsCamera then
        local v43 = Kit.Ease((p10 - 0.3) / 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local v44 = Origin * Vector3.new(0, v28, 1.5)

        p9.Camera.CFrame = CFrame.lookAt(v44, Origin * Vector3.new(0, v28 - 30, 0)) * CFrame.Angles(0, 0, 0.6981317007977318 * v43 + math.sin(p10 * 1.3) * 0.06981317007977318)
        p9.Camera.FieldOfView = math.lerp(40, 100, v30)
    end
end

local function enterSpit(p12) -- line: 186
    -- upvalues: Kit (copy), Overlay (copy), Score (copy), Splash (copy), Stage (copy)
    local State = p12.State

    Stage.Phase(p12, "Spit")
    State.Depths.Model.Parent = nil

    local Crew = State.Crew

    if Crew ~= nil then
        Crew.Model.Parent = nil
    end

    local CFrame = p12.Root.CFrame
    local v49 = Kit.FlatUnit(CFrame.LookVector, (Vector3.new(0, 0, 1)))
    local v50 = Stage.Ground(CFrame.Position - v49 * 7, {
        p12.Character,
        p12.Folder
    })

    State.Geyser = v50

    local v52 = Vector3.new(v49.Z, 0, -v49.X)
    local v53 = CFrame.Position + (v49 * 0.85 + v52 * 0.5).Unit * 15 + Vector3.new(0, 4, 0)

    State.SpitCamera = Kit.Clamp(CFrame.Position + Vector3.new(0, 2, 0), v53, {
        p12.Character,
        p12.Folder
    })
    Score.StopAll(p12.Score)
    Score.Under(p12.Score, false, 0.05)
    Score.Play(p12.Score, "Whoosh", 0.55, 1.15)
    Score.Play(p12.Score, "Crash", 0.45, 1.2)
    Splash.Big(p12.Splash, v50)
    Overlay.Vignette(p12.Overlay, 0)
end

local function spit(p13, p14) -- line: 212
    -- upvalues: Double (copy), Kit (copy), Splash (copy), Looks (copy)
    local State, Double2 = p13.State, p13.Double
    local Geyser = State.Geyser
    local _CFrame = p13.Root.CFrame
    local CFramePosition = _CFrame.Position
    local v55 = math.clamp(p14 / 0.45, 0, 1)
    local v56 = if v55 < 0.5 then Kit.Smooth(v55 / 0.3) else math.max(1 - (v55 - 0.5) / 0.4, 0)

    Splash.Jet(p13.Splash, Geyser, Geyser + Vector3.new(0, 12, 0), v56)

    if Double2 then
        local v60 = (Geyser + Vector3.new(0, Double2.Stance, 0)):Lerp(CFramePosition, v55) + Vector3.new(0, v55 * 36 * (1 - v55), 0)
        local v61 = Kit.FlatUnit(_CFrame.LookVector, (Vector3.new(0, 0, 1)))
        local v62 = CFrame.Angles(-6.283185307179586 * Kit.Ease(v55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 0, 0)

        Double.Pose(Double2, Double.Blend(Double.Poses.Cannonball, Double.Poses.Squash, Kit.Span(v55, 0.55, 1)))
        Double.Place(Double2, CFrame.lookAt(v60, v60 + v61) * v62)
    end

    local Haze, Clear = Looks.Haze, Looks.Clear
    local v63 = Kit.Smooth(v55)

    Kit.Mix(p13.Grade.Look, Haze, Clear, v63)
    Kit.Apply(p13.Grade, 0)

    if p13.OwnsCamera then
        local SpitCamera = State.SpitCamera
        local v64 = Geyser:Lerp(CFramePosition, 0.5) + Vector3.new(0, 2, 0)

        p13.Camera.CFrame = CFrame.lookAt(SpitCamera, v64)
        p13.Camera.FieldOfView = 80
    end
end

local function land(p15) -- line: 248
    -- upvalues: Overlay (copy), Score (copy), Splash (copy), Stage (copy)
    local State = p15.State

    Stage.Phase(p15, "Settle")
    Stage.Swap(p15)
    Splash.Jet(p15.Splash, Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), 0)
    Splash.Land(p15.Splash, p15.Root.Position - Vector3.new(0, 2.5, 0))
    Score.Play(p15.Score, "Pop", 0.55, 0.9)
    Score.Play(p15.Score, "ScoopShort", 0.4, 1.2)

    local Head = p15.Character:FindFirstChild("Head")

    if Head ~= nil and Head:IsA("BasePart") then
        Splash.Drips(p15.ScoreTrove, Head, 2)
    end

    Overlay.Drops(p15.Overlay, p15.Scenery, p15.Low and 2 or 4)
    State.SettleFrom = p15.Camera.CFrame
end

local function settle(p16, p17) -- line: 264
    -- upvalues: Kit (copy), Stage (copy), Looks (copy)
    local State = p16.State
    local v66 = math.clamp(p17 / 0.85, 0, 1)
    local v67 = Stage.Landing(p16, p16.Zoom)
    local Haze, Clear = Looks.Haze, Looks.Clear

    Kit.Mix(p16.Grade.Look, Haze, Clear, 1)
    Kit.Apply(p16.Grade, 0)

    if v66 >= 1 then
        Stage.HandBack(p16, v67)
    elseif p16.OwnsCamera then
        local SettleFrom = State.SettleFrom
        local v68 = Kit.Ease(v66, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        p16.Camera.CFrame = Stage.SwingFrame(p16, SettleFrom, v67, (math.clamp(v68, 0, 1.05)))
        p16.Camera.FieldOfView = math.lerp(80, p16.FieldOfView, Kit.Smooth(v66))
    end
end

local function calm(p18, p19) -- line: 283
    -- upvalues: Kit (copy), Overlay (copy), Score (copy), Stage (copy), Looks (copy)
    local State, Camera = p18.State, p18.Camera
    local Mouth = State.Mouth

    if p18.Phase == "Calm" then
        Overlay.Waterline(p18.Overlay, Kit.Smooth(p19 / 0.7))
        Overlay.Iris(p18.Overlay, Kit.Projected(Camera, Mouth), 1 - Kit.Smooth((p19 - 0.5) / 0.5))

        local Clear, Haze = Looks.Clear, Looks.Haze
        local v69 = Kit.Smooth(p19 / 0.8)

        Kit.Mix(p18.Grade.Look, Clear, Haze, v69)
        Kit.Apply(p18.Grade, 0)

        if p19 >= 1 then
            Stage.Phase(p18, "CalmHold")
            Stage.Scriptable(p18)
            Stage.Arrive(p18)
            Score.Play(p18.Score, "Flush", 0.5)
        end
    elseif p18.Phase == "CalmHold" then
        Overlay.Iris(p18.Overlay, Vector2.new(0.5, 0.5), 0)

        local v70 = p18.ArriveState == "Failed"

        if v70 or p19 >= 0.5 and Stage.Settled(p18) or Stage.Elapsed(p18) > 8 then
            State.Failed = v70
            Stage.Phase(p18, "CalmBack")

            if not v70 then
                Stage.Swap(p18)
            end
        end
    else
        local v72 = math.clamp(p19 / 0.9, 0, 1)
        local v73 = Stage.Landing(p18, p18.Zoom)

        if p18.OwnsCamera then
            Camera.CFrame = v73
            Camera.FieldOfView = p18.FieldOfView
        end

        Overlay.Iris(p18.Overlay, Kit.Projected(Camera, p18.Root.Position), Kit.Smooth(v72))
        Overlay.Waterline(p18.Overlay, 1 - Kit.Smooth(v72 * 1.4))

        local Haze, Clear = Looks.Haze, Looks.Clear
        local v74 = Kit.Smooth(v72)

        Kit.Mix(p18.Grade.Look, Haze, Clear, v74)
        Kit.Apply(p18.Grade, 0)

        if v72 >= 1 then
            if State.Failed then
                Stage.Finish(p18, false)
            else
                Stage.HandBack(p18, v73)
            end
        end
    end
end

local function step(p20, p21) -- line: 331
    -- upvalues: Double (copy), Score (copy), Stage (copy), suction (copy), enterPipe (copy), ride (copy), enterSpit (copy), spit (copy), land (copy), settle (copy), calm (copy)
    local v75 = Stage.Since(p20)

    if p20.Calm then
        calm(p20, v75)
    elseif p20.Phase == "Suction" then
        suction(p20, v75)

        if v75 >= 0.55 then
            enterPipe(p20)
            ride(p20, 0, p21)
        end
    elseif p20.Phase == "Ride" then
        if p20.ArriveState == "Failed" then
            Stage.Bail(p20)
        else
            ride(p20, v75, p21)

            if v75 >= 0.85 and Stage.Settled(p20) then
                enterSpit(p20)
                spit(p20, 0)
            elseif Stage.Elapsed(p20) > 6.55 then
                p20.State.Failed = p20.ArriveState ~= "Arrived"
                p20.Calm = true
                Stage.Phase(p20, "CalmBack")
                Score.StopAll(p20.Score)
                p20.State.Depths.Model.Parent = nil

                if p20.Double then
                    Double.Visible(p20.Double, false)
                end
            end
        end
    elseif p20.Phase == "Spit" then
        spit(p20, v75)

        if v75 >= 0.45 then
            land(p20)
            settle(p20, 0)
        end
    elseif p20.Phase == "Settle" then
        settle(p20, v75)
    end
end

local function prepare(p22) -- line: 380
    -- upvalues: Depths (copy), Hands (copy), Stage (copy), v1 (copy), mouthOf (copy)
    local State = p22.State
    local v76, v77 = mouthOf(p22)

    State.Mouth = v76
    State.Inward = v77
    State.StartCamera = p22.Camera.CFrame

    local Double = p22.Double

    if Double then
        State.Start = Double.Root.CFrame
    else
        State.Start = p22.Root.CFrame
    end

    State.Crew = Hands.Build(p22.Scenery, p22.Folder, 1, 4.6)

    if p22.Calm then
        return
    end

    local v78 = Depths.Build(p22.Scenery, p22.Folder, v1, true)

    v78.Model.Parent = nil
    State.Depths = v78
    Stage.Scriptable(p22)
end

function t1.Run(p23) -- line: 401
    -- upvalues: Score (copy), Stage (copy), step (copy), prepare (copy)
    local v79 = Stage.Begin("Exit", p23)

    if v79 == nil or not Stage.Prepare(v79, prepare) then
        return Stage.Fallback(p23)
    end

    Stage.Phase(v79, v79.Calm and "Calm" or "Suction")
    Score.Duck(v79.Score, true, 0.3)
    Score.Play(v79.Score, "Flush", 0.55)
    Score.Play(v79.Score, "Suck", 0.3, 1.1)

    if not v79.Calm then
        Score.Loop(v79.Score, "Pour", 0.4, 0.7)
    end

    Stage.Bind(v79, step)

    return Stage.Wait(v79)
end

return table.freeze(t1)
