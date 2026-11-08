-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Cine = require(script.Parent.Cine)
local Fx = require(script.Parent.Fx)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local Hud = require(script.Parent.Hud)
local Swim = require(script.Parent.Swim)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Sounds = ReplicatedStorage.Assets.Sounds
local Bobber = ReplicatedStorage.Assets.GhostDogQuest.Bobber
local Swoosh = Sounds.ScrambleBoss.Swoosh
local Ghost = Fx.Ghost
local v1 = Color3.fromRGB(14, 52, 64)
local t1 = {}

local function controls() -- line: 50
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")

    if PlayerModule ~= nil then
        local _require = require
        local ok, result = pcall(_require, PlayerModule)

        if ok then
            return result:GetControls()
        end
    end

    return nil
end

function t1.LockControls(p1) -- line: 63
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
    local v2

    if PlayerModule ~= nil then
        local _require = require
        local ok, result = pcall(_require, PlayerModule)

        if ok then
            v2 = result:GetControls()
        end
    end

    if v2 then
        v2:Disable()
        p1:Add(function() -- line: 67
            -- upvalues: v2 (ref)
            v2:Enable()
        end)
    end
end

local function rodTip(p2) -- line: 73
    -- upvalues: GhostDogQuest (copy)
    for _, child in p2:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute(GhostDogQuest.RodAttribute) == true then
            local v3 = child:FindFirstChild("RodTip", true)

            if v3 and v3:IsA("Attachment") then
                return v3
            end
        end
    end

    return nil
end

function t1.EquipRod(p3) -- line: 85
    -- upvalues: GhostDogQuest (copy), LocalPlayer (copy), rodTip (copy)
    local Humanoid = p3:FindFirstChildOfClass("Humanoid")
    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if Humanoid and Backpack then
        for _, child in Backpack:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute(GhostDogQuest.RodAttribute) == true then
                Humanoid:EquipTool(child)
                break
            end
        end
    end

    local elapsed = os.clock()
    local v4

    while true do
        if not (os.clock() - elapsed < 1) then
            return (rodTip(p3))
        end

        v4 = rodTip(p3)

        if v4 then
            break
        end

        task.wait()
    end

    return v4
end

local function hide(p4) -- line: 107
    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1
        elseif descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false
        end
    end
end

local function exclaim(p5, p6) -- line: 117
    -- upvalues: Fx (copy), LocalPlayer (copy)
    local v5 = p5:Add(Instance.new("BillboardGui"))

    v5.Size = UDim2.fromScale(3, 3)
    v5.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
    v5.AlwaysOnTop = true
    v5.Adornee = p6

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.Text = "!"
    TextLabel.TextScaled = true
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
    TextLabel.TextColor3 = Color3.fromRGB(255, 225, 90)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 4
    UIStroke.Parent = TextLabel

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = TextLabel
    TextLabel.Parent = v5
    v5.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    Fx.Punch(UIScale, 2.2, 0.35)
end

local function throw(p7, p8, p9, p10, p11, p12) -- line: 140
    -- upvalues: Workspace (copy), Fx (copy), GhostDogQuest (copy), Bobber (copy), Swoosh (copy), Ghost (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v6 = p7:Add(Bobber:Clone())
    local v7 = v6:FindFirstChild("Line", true)
    local v8 = if p8 then p8.WorldPosition else p9.Position + Vector3.new(0, 4, 0)

    v6:PivotTo(CFrame.new(v8))
    v6.Parent = Workspace

    if p8 then
        local v9 = p7:Add(Instance.new("Beam"))

        v9.Attachment0 = p8
        v9.Attachment1 = v7
        v9.Width0 = 0.08
        v9.Width1 = 0.08
        v9.LightEmission = 1
        v9.FaceCamera = true
        v9.Color = ColorSequence.new(Ghost)
        v9.CurveSize0 = 2
        v9.Parent = v6
    end

    Fx.Play(Swoosh, {
        Volume = 0.6,
        PlaybackSpeed = 0.8
    })

    local elapsed = os.clock()

    while true do
        local v11 = math.min((os.clock() - elapsed) / 0.85, 1)
        local v12 = v8:Lerp(p10, v11)
        local v14 = math.sin(v11 * 3.141592653589793) * 9

        v6:PivotTo(CFrame.new(v12 + Vector3.new(0, v14, 0)))
        CurrentCamera.CFrame = CFrame.lookAt(p11, p12:Lerp(v6:GetPivot().Position, 0.35))

        if v11 >= 1 then
            break
        end

        task.wait()
    end

    Fx.Splash(p10 + Vector3.new(0, 0.3, 0), 0.5)
    Fx.Play(GhostDogQuest.Sounds.Splash, {
        Volume = 0.5
    })

    for i = 1, 2 do
        local elapsed = os.clock()

        while os.clock() - elapsed < 0.8 do
            local v15 = os.clock() - elapsed

            v6:PivotTo(CFrame.new(p10 + Vector3.new(0, math.sin(v15 * 6) * 0.15 + 0.3, 0)))
            task.wait()
        end

        v6:PivotTo(CFrame.new(p10 + Vector3.new(0, -0.3, 0)))
        Fx.Ripple(p10 + Vector3.new(0, 0.3, 0), i * 0.15 + 0.4)
        Fx.Play(GhostDogQuest.Sounds.Nibble[i], {
            Volume = i * 0.15 + 0.55
        })
        Fx.Shake(i * 0.4, 0.2)
        task.wait(0.15)
    end

    return v6
end

function t1.Play(p13, p14, p15) -- line: 197
    -- upvalues: Workspace (copy), Cine (copy), Fx (copy), GhostDogQuest (copy), LocalPlayer (copy), t1 (copy), hide (copy), exclaim (copy), throw (copy)
    local Character = LocalPlayer.Character
    local v18, v19, v20

    if Character then
        v18 = Character:FindFirstChild("HumanoidRootPart")
        v19 = Character:FindFirstChildOfClass("Humanoid")
        v20 = Character:FindFirstChild("Head")
    else
        v20 = Character
        v18 = Character
        v19 = Character
    end

    local v21, v22, v23

    if Character == nil or v18 == nil then
        v23 = true
    elseif not v18:IsA("BasePart") or v19 == nil then
        v23 = true
    else
        if p15 then
            v22 = p15.Target
            v21 = CFrame.lookAt(v18.Position, (Vector3.new(v22.X, v18.Position.Y, v22.Z)))
        else
            local _CFrame = p14:FindFirstChild("CastSpot").CFrame

            v22 = p14:FindFirstChild("CastTarget").Position
            v21 = CFrame.lookAt(_CFrame.Position + Vector3.new(0, 3, 0), (Vector3.new(v22.X, _CFrame.Position.Y + 3, v22.Z)))
        end

        v23 = false
    end

    if v23 then
        return false
    end

    t1.LockControls(p13)
    v18.CFrame = v21
    v18.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    local v26 = t1.EquipRod(Character)
    local CurrentCamera = Workspace.CurrentCamera

    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    p13:Add(function() -- line: 225
        -- upvalues: CurrentCamera (copy), v19 (ref)
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.CameraSubject = v19
    end)

    local RightVector = v21.RightVector
    local v27 = Cine.Unclip(v21.Position + Vector3.new(0, 2, 0), v21.Position - v21.LookVector * 10 - RightVector * 6 + Vector3.new(0, 6, 0))
    local v28 = v21.Position:Lerp(v22, 0.45)

    CurrentCamera.CFrame = CFrame.lookAt(v27, v28)

    local v29 = if p15 then p13:Add(p15.Bobber) else throw(p13, v26, v18, v22, v27, v28)

    if v20 and v20:IsA("BasePart") then
        exclaim(p13, v20)
    end

    Fx.Play(GhostDogQuest.Sounds.GrowlShort, {
        Volume = 0.9
    })
    Fx.Flash(Color3.new(1, 1, 1), 0.45, 0.02, 0.4)
    Fx.Shake(2.6, 0.6)
    Fx.Splash(v22 + Vector3.new(0, 0.3, 0), 1.6)
    hide(v29)
    t1.Tug(p13, v18, v29, v21, v22, v27)
    Fx.Play(GhostDogQuest.Sounds.PulledUnder, {
        Volume = 1
    })
    t1.Plunge(p13, v18, v19, v22)

    return true
end

function t1.Tug(_, p17, p18, p19, p20, p21) -- line: 257
    -- upvalues: Workspace (copy), Fx (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v30 = p18:FindFirstChildWhichIsA("Beam", true)
    local v31 = p20 - Vector3.new(0, 3.5, 0)
    local v32 = p19.Position:Lerp(p20, 0.45)
    local v33 = p21:Lerp(p19.Position + Vector3.new(0, 1.5, 0), 0.35)
    local Unit = (p20 - p19.Position).Unit

    for i = 1, 3 do
        local v34 = i / 3

        Fx.Shake(v34 * 1.6 + 0.8, 0.22)
        Fx.Ripple(p20 + Vector3.new(0, 0.3, 0), v34 + 0.5)

        local elapsed = os.clock()

        while true do
            local v36 = math.min((os.clock() - elapsed) / 0.36, 1)
            local v37 = (i - 1 + Fx.Ease(v36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)) / 3
            local v42 = math.sin(math.min(v36 / 0.35, 1) * 3.141592653589793 * 0.5) * (1 - Fx.Ease(math.max(v36 - 0.35, 0) / 0.65, Enum.EasingStyle.Quad)) * (v34 * 0.6 + 0.6)

            p18:PivotTo(CFrame.new(v31 - Vector3.new(0, v42 * 1.5, 0)))

            if v30 then
                v30.CurveSize0 = 0
                v30.CurveSize1 = 0
                v30.Width0 = 0.08 + v42 * 0.1
                v30.Width1 = v30.Width0
            end

            p17.CFrame = p19 * CFrame.new(0, 0, v37 * 0.8 - v42 * 1.1) * CFrame.Angles(math.rad(14 * v37 - 16 * v42), 0, (math.rad(v42 * 4)))
            p17.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            CurrentCamera.CFrame = CFrame.lookAt(p21:Lerp(v33, v37) + Unit * v42 * 0.6, v32:Lerp(p20, v37 * 0.3))

            if math.random() < 0.3 then
                Fx.Ripple(p20 + Vector3.new(0, 0.3, 0), v34 + 0.4)
            end

            if v36 >= 1 then
                break
            end

            task.wait()
        end

        if i < 3 then
            local elapsed = os.clock()

            while os.clock() - elapsed < 0.2 do
                local v48 = os.clock() - elapsed

                p18:PivotTo(CFrame.new(v31 + Vector3.new(math.sin(v48 * 30) * 0.15, 0, 0)))
                task.wait()
            end
        end
    end
end

local function bezier(p22, p23, p24, p25, p26) -- line: 317
    local v51 = 1 - p26

    return p22 * (v51 * v51 * v51) + p23 * (v51 * 3 * v51 * p26) + p24 * (v51 * 3 * p26 * p26) + p25 * (p26 * p26 * p26)
end

function t1.Plunge(p27, p28, p29, p30) -- line: 322
    -- upvalues: Lighting (copy), Workspace (copy), Cine (copy), Fx (copy), GhostDogQuest (copy), Hud (copy), Swim (copy), v1 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local v52 = p30.Y + 0.3
    local v53 = Vector3.new(p30.X, v52, p30.Z)
    local Position = p28.Position
    local v56 = Vector3.new(p30.X - Position.X, 0, p30.Z - Position.Z)
    local v57 = if v56.Magnitude > 0.1 then v56.Unit else Vector3.new(-1, 0, 0)
    local v58 = p30 + v57 * 10 - Vector3.new(0, 16, 0)

    p29.PlatformStand = true
    p27:Add(function() -- line: 332
        -- upvalues: p29 (copy)
        p29.PlatformStand = false
    end)

    local v59 = p27:Add(Instance.new("ColorCorrectionEffect"))

    v59.Name = "GhostDogPlunge"
    v59.Parent = Lighting

    local v60 = p27:Add(Instance.new("BlurEffect"))

    v60.Name = "GhostDogPlungeBlur"
    v60.Size = 0
    v60.Parent = Lighting

    local v61 = Cine.RestingFov()

    p27:Add(function() -- line: 343
        -- upvalues: CurrentCamera (copy), v61 (copy)
        CurrentCamera.FieldOfView = v61
    end)

    local v62 = Hud.FadeFrame()

    if v62 then
        v62.BackgroundColor3 = v1
        v62.BackgroundTransparency = 1
    end

    local v63 = Cine.SpeedLens(0.3, 30)
    local CFramePosition = CurrentCamera.CFrame.Position
    local v64 = CFramePosition + CurrentCamera.CFrame.LookVector * 14
    local v65 = v53 - v57 * 5 + Vector3.new(0, 22, 0)
    local v66 = CFramePosition + Vector3.new(0, 9.9, 0) - v57 * 2
    local v67 = v65 - v57 * 7 + Vector3.new(0, 2, 0)
    local v68 = v65 - Vector3.new(0, 0.5, 0)
    local v69 = v53 + Vector3.new(0, 1.4, 0) - v57 * 0.6
    local Parent = p28.Parent
    local v70 = p27:Add(Instance.new("Attachment"))

    v70.Parent = p28

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = Fx.Sparkle
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(220, 255, 250))
    ParticleEmitter.LightEmission = 0.5
    ParticleEmitter.Size = NumberSequence.new(0.5, 0.15)
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.1)
    ParticleEmitter.Speed = NumberRange.new(4, 9)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.SpreadAngle = Vector2.new(40, 40)
    ParticleEmitter.Acceleration = Vector3.new(0, 12, 0)
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = v70

    local elapsed = os.clock()
    local elapsed2 = elapsed
    local v71 = false
    local v72 = false

    while true do
        local elapsed3 = os.clock()
        local v74 = math.min(elapsed3 - elapsed, 1.7)
        local v75 = elapsed3 - elapsed2
        local v77 = math.min(v74 / 1, 1)
        local v78 = Fx.Ease(v77, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v79

        if v77 < 0.6 then
            local v80 = v77 / 0.6

            v79 = Position:Lerp(p30, Fx.Ease(v80, Enum.EasingStyle.Back, Enum.EasingDirection.In)) + Vector3.new(0, math.sin(v80 * 3.141592653589793) * 4, 0)
        else
            v79 = p30:Lerp(v58, Fx.Ease((v77 - 0.6) / 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
        end

        p28.CFrame = CFrame.lookAt(v79, v79 + v57) * CFrame.Angles(math.rad(-80 * v78), 0, math.sin(v74 * 15) * 0.15)
        p28.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

        if not v71 and v77 >= 0.6 then
            Fx.Splash(v53, 2.2)
            Fx.Play(GhostDogQuest.Sounds.Splash, {
                Volume = 1,
                PlaybackSpeed = 0.75
            })
            Fx.Shake(1.4, 0.35)
            ParticleEmitter.Rate = 60
            ParticleEmitter:Emit(40)
            v71 = true
            Swim.Start(p27, Parent, "Swim")
        end

        local v88, v89, v90, v91

        if v74 < 1.05 then
            local v92 = v74 / 1.05
            local v93 = Fx.Ease(v92, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local v94 = 1 - v93

            v88 = CFramePosition * (v94 * v94 * v94) + v66 * (v94 * 3 * v94 * v93) + v67 * (v94 * 3 * v93 * v93) + v65 * (v93 * v93 * v93)

            local v96 = Fx.Ease(math.min(v92 / 0.3, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local v98 = Fx.Ease(math.clamp((v92 - 0.35) / 0.65, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

            v91 = 0
            v90 = 0
            v89 = v64:Lerp(v79, v96):Lerp(v53, v98)
        elseif v74 < 1.2 then
            local v99 = (v74 - 1.05) / 0.15

            v91 = 0
            v90 = 0
            v88 = v65:Lerp(v68, Fx.Ease(v99, Enum.EasingStyle.Sine, Enum.EasingDirection.In))
            v89 = v53
        else
            local v101 = math.min((v74 - 1.05 - 0.15) / 0.5, 1)
            local v102 = Fx.Ease(v101, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

            v88 = v68:Lerp(v69, v102)
            v89 = v53:Lerp(v53 - Vector3.new(0, 2, 0), v102)
            v90 = v102 * 0.14
            v91 = Fx.Ease(math.clamp((v101 - 0.35) / 0.55, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            v60.Size = v102 * 10
            v59.TintColor = Color3.new(1, 1, 1):Lerp(Color3.fromRGB(120, 210, 255), v91)
        end

        local v106 = Vector3.new(v88.X, math.max(v88.Y, v52 + 1.4), v88.Z)

        CurrentCamera.CFrame = CFrame.lookAt(v106, v89) * CFrame.Angles(0, 0, v90)
        CurrentCamera.FieldOfView = v63(v106, v75, v61)

        if v62 then
            v62.BackgroundTransparency = 1 - v91
        end

        if not v72 and v91 >= 0.7 then
            v72 = true
            Hud.Bubbles(1.2, 70)
        end

        if v74 >= 1.7 then
            break
        end

        elapsed2 = elapsed3
        task.wait()
    end

    if v62 then
        v62.BackgroundTransparency = 0
    end

    p28.CFrame = CFrame.lookAt(v58, v58 + v57) * CFrame.Angles(-1.3962634015954636, 0, 0)
    p28.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end

return table.freeze(t1)
