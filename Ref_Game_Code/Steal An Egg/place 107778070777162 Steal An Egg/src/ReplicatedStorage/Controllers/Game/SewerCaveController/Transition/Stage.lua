-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Double = require(script.Parent.Double)
local Transition = require(script.Parent.Parent.Parent.HalloweenDimensionController.Transition)
local Kit = require(script.Parent.Kit)
local Overlay = require(script.Parent.Overlay)
local Score = require(script.Parent.Score)
local SewerCave = require(ReplicatedStorage.Shared.Util.SewerCave)
local Splash = require(script.Parent.Splash)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Enum.RenderPriority.Camera.Value + 1
local t1 = {
    Core = Color3.fromRGB(6, 70, 74),
    Edge = Color3.fromRGB(2, 16, 20),
    Shade = Color3.fromRGB(64, 196, 186),
    Embers = {
        Color3.fromRGB(120, 230, 214),
        Color3.fromRGB(60, 170, 190),
        Color3.fromRGB(200, 250, 240)
    },
    Veil = Color3.fromRGB(2, 16, 20),
    VeilTint = ColorSequence.new(Color3.fromRGB(12, 120, 120), Color3.new(1, 1, 1)),
    PuffTint = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(150, 180, 178))
}
local t2
local t3 = {
    Palette = t1,
    CoverTimeout = 20
}

local function restoreCamera(p1) -- line: 104
    if p1.OwnsCamera then
        local Camera = p1.Camera

        Camera.FieldOfView = p1.FieldOfView

        local HandBack = p1.HandBack

        if HandBack ~= nil then
            Camera.CFrame = HandBack
        end

        Camera.CameraType = Enum.CameraType.Custom
    end
end

local function report(p2) -- line: 117
    warn((("[SewerCave] transition stopped: %*"):format((debug.traceback((tostring(p2)))))))
end

function t3.Active() -- line: 125
    -- upvalues: t2 (ref)
    return t2
end

function t3.Begin(p3, p4) -- line: 129
    -- upvalues: GuiService (copy), Workspace (copy), Double (copy), Kit (copy), Overlay (copy), Score (copy), Splash (copy), Trove (copy), LocalPlayer (copy), t2 (ref), t3 (copy)
    local t4 = t2

    if t4 ~= nil then
        t3.Finish(t4, false)
    end

    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v4, v5

    if Character then
        v4 = Character:FindFirstChildOfClass("Humanoid")
        v5 = Character:FindFirstChild("HumanoidRootPart")
    else
        v5 = Character
        v4 = Character
    end

    local v6, v7, v8, v9, v10, v11, t5, v12, v13

    if CurrentCamera == nil or Character == nil or v4 == nil or v4.Health <= 0 or v5 == nil then
        v13 = true
    elseif v5:IsA("BasePart") then
        v6 = Trove.new()
        v7 = v6:Extend()
        v8 = Trove.new()
        v9 = v7:Add(Instance.new("Folder"))
        v9.Name = "SewerDrain"
        v9.Parent = CurrentCamera
        v10 = Kit.LowQuality()
        v11 = CurrentCamera.Focus.Position - v5.Position
        t5 = {
            Clock = 0,
            Phase = "Start",
            PhaseAt = 0,
            ArriveState = "Idle",
            Moved = false,
            Done = false,
            Result = false,
            Double = nil,
            Name = p3,
            Context = p4,
            Trove = v6,
            Scenery = v7,
            Folder = v9,
            Camera = CurrentCamera,
            Character = Character,
            Root = v5,
            Humanoid = v4,
            Calm = GuiService.ReducedMotionEnabled,
            Low = v10
        }
        v12 = CurrentCamera.CameraType == Enum.CameraType.Custom
        v13 = false
    else
        v13 = true
    end

    if v13 then
        return nil
    end

    t5.OwnsCamera = v12
    t5.FieldOfView = CurrentCamera.FieldOfView

    local Magnitude = (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude

    t5.Zoom = math.clamp(Magnitude, 6, 22)

    if not (v11.Magnitude < 4) then
        v11 = Vector3.new(0, 1.5, 0)
    end

    t5.SubjectOffset = v11
    t5.StartedAt = os.clock()
    t5.StartRoot = v5.Position
    t5.Grade = Kit.Grade(v7, CurrentCamera)
    t5.Overlay = Overlay.Build(v7)
    t5.Score = Score.Build(v8)
    t5.ScoreTrove = v8
    t5.Splash = Splash.Build(v7, v9, v10)
    t5.Cloak = Double.Cloak(v6, Character)
    t5.State = {}
    v7:Add(function() -- line: 190
        -- upvalues: t5 (ref)
        if t5.OwnsCamera then
            local Camera = t5.Camera

            Camera.FieldOfView = t5.FieldOfView

            local HandBack = t5.HandBack

            if HandBack ~= nil then
                Camera.CFrame = HandBack
            end

            Camera.CameraType = Enum.CameraType.Custom
        end
    end)
    t5.Double = Double.Build(v7, Character, v9)
    t2 = t5
    v6:Connect(v4.Died, function() -- line: 195
        -- upvalues: t5 (ref), t3 (copy)
        t3.Finish(t5, false)
    end)
    v6:Connect(LocalPlayer.CharacterAdded, function() -- line: 198
        -- upvalues: t5 (ref), t3 (copy)
        t3.Finish(t5, false)
    end)

    return t5
end

function t3.Bind(p5, p6) -- line: 204
    -- upvalues: v1 (copy), t3 (copy), report (copy)
    p5.Scenery:BindToRenderStep("SewerDrain", v1, function(p7) -- line: 205
        -- upvalues: p5 (copy), p6 (copy), t3 (copy), report (copy)
        if p5.Done then
            return
        end

        p5.Cloak.Step()

        local RootPosition = p5.Root.Position

        if not p5.Moved and (RootPosition - p5.StartRoot).Magnitude > 12 then
            p5.Moved = true
        end

        p5.Clock += p7

        if not xpcall(p6, report, p5, p7) then
            t3.Bail(p5)
        end
    end)
end

function t3.Phase(p8, p9) -- line: 221
    p8.Phase = p9
    p8.PhaseAt = p8.Clock
end

function t3.Since(p10) -- line: 226
    return p10.Clock - p10.PhaseAt
end

function t3.Elapsed(p11) -- line: 230
    return p11.Clock
end

function t3.Scriptable(p12) -- line: 234
    if p12.OwnsCamera then
        p12.Camera.CameraType = Enum.CameraType.Scriptable
    end
end

function t3.Arrive(p13) -- line: 240
    if p13.ArriveState == "Idle" then
        p13.ArriveState = "Waiting"
        p13.ArriveAt = os.clock()
        p13.Trove:Add(task.spawn(function() -- line: 246
            -- upvalues: p13 (copy)
            local Arrive = p13.Context.Arrive
            local ok, result = pcall(Arrive)

            if not p13.Done then
                p13.ArriveState = not (ok and result == true) and "Failed" or "Arrived"
            end
        end))
    end
end

function t3.Settled(p14) -- line: 255
    if p14.ArriveState ~= "Arrived" then
        return false
    end

    if p14.Moved then
        return true
    end

    local ArriveAt = p14.ArriveAt

    return ArriveAt ~= nil and os.clock() - ArriveAt > 2.5
end

function t3.Landing(p15, p16) -- line: 266
    -- upvalues: Kit (copy)
    local Root = p15.Root
    local v15 = Kit.FlatUnit(Root.CFrame.LookVector, (Vector3.new(0, 0, 1))) * 0.9781476007338057 + Vector3.new(-0, -0.20791169, -0)
    local v16 = Root.Position + p15.SubjectOffset
    local t6 = {
        p15.Character,
        p15.Folder
    }
    local v17 = v16 - v15 * p16
    local v18 = Kit.Clamp(v16, v17, t6, true)

    return CFrame.lookAt(v18, v16)
end

function t3.SwingFrame(p17, p18, p19, p20) -- line: 277
    -- upvalues: Kit (copy)
    local v19 = p17.Root.Position + p17.SubjectOffset
    local t7 = {
        p17.Character,
        p17.Folder
    }
    local v20 = Kit.Swing(v19, p18.Position, p19.Position, p20, t7)
    local Magnitude = (p18.Position - v19).Magnitude
    local v21 = (p18.Position + p18.LookVector * Magnitude):Lerp(v19, Kit.Smooth(p20))

    return CFrame.lookAt(v20, v21)
end

function t3.Swap(p21) -- line: 287
    -- upvalues: Double (copy)
    local Double2 = p21.Double

    if Double2 ~= nil then
        Double.Visible(Double2, false)
    end

    p21.Cloak.Lift()
end

function t3.HandBack(p22, p23) -- line: 295
    -- upvalues: t3 (copy)
    p22.HandBack = p23
    p22.Result = true
    t3.Finish(p22, true)
end

function t3.Finish(p24, p25) -- line: 301
    -- upvalues: Score (copy), t2 (ref)
    if p24.Done then
        return
    end

    p24.Done = true
    p24.Result = p25

    if t2 == p24 then
        t2 = nil
    end

    p24.Trove:Destroy()

    local ScoreTrove = p24.ScoreTrove

    if p25 then
        Score.Duck(p24.Score, false, 1.6)
        task.delay(2.6, function() -- line: 314
            -- upvalues: ScoreTrove (copy)
            ScoreTrove:Destroy()
        end)
    else
        Score.StopAll(p24.Score)
        ScoreTrove:Destroy()
    end
end

function t3.Bail(p26) -- line: 323
    -- upvalues: Transition (copy), t1 (copy), t3 (copy)
    if p26.Done then
        return
    end

    Transition.Cover(t1, 20)
    t3.Finish(p26, false)
    task.delay(0.35, Transition.Reveal)
end

function t3.Fallback(p27) -- line: 332
    -- upvalues: Transition (copy), t1 (copy)
    Transition.Cover(t1, 20)
    task.wait(0.75)

    local Arrive = p27.Arrive
    local ok, result = pcall(Arrive)

    task.wait(0.35)
    Transition.Reveal()

    return ok and result == true
end

function t3.Prepare(p28, p29) -- line: 341
    -- upvalues: t3 (copy)
    local ok, result = pcall(p29, p28)

    if ok then
        return true
    end

    warn((("[SewerCave] transition stopped: %*"):format((debug.traceback((tostring(result)))))))
    t3.Finish(p28, false)

    return false
end

function t3.Wait(p30) -- line: 351
    while not p30.Done do
        task.wait()
    end

    return p30.Result
end

function t3.CaveFlange() -- line: 358
    -- upvalues: SewerCave (copy)
    local v22 = SewerCave.Cave()
    local Structures = v22 and v22:FindFirstChild("Structures")
    local v23 = Structures and Structures:FindFirstChild("vertical pipe")
    local v24 = v23 and v23:FindFirstChild("Bolted Outlet Flange", true)

    return if v24 ~= nil and v24:IsA("BasePart") then v24 else nil
end

function t3.OutletFlange() -- line: 366
    -- upvalues: SewerCave (copy)
    local v25 = SewerCave.Cave()
    local Structures = v25 and v25:FindFirstChild("Structures")
    local v26 = Structures and Structures:FindFirstChild("Sewer Outlet")
    local v27 = v26 and v26:FindFirstChild("Bolted Outlet Flange", true)

    return if v27 ~= nil and v27:IsA("BasePart") then v27 else nil
end

function t3.Axis(p31) -- line: 374
    local CFrame = p31.CFrame
    local t8 = {
        {
            CFrame.RightVector,
            p31.Size.X
        },
        {
            CFrame.UpVector,
            p31.Size.Y
        },
        {
            CFrame.LookVector,
            p31.Size.Z
        }
    }
    local v28 = t8[1]

    for _, v29 in t8 do
        if math.abs(v29[1].Y) > math.abs(v28[1].Y) then
            v28 = v29
        end
    end

    return v28[1], v28[2]
end

function t3.Ground(p32, p33) -- line: 390
    -- upvalues: Workspace (copy)
    local v31 = RaycastParams.new()

    v31.FilterType = Enum.RaycastFilterType.Exclude
    v31.FilterDescendantsInstances = p33
    v31.RespectCanCollide = true

    local v32 = Workspace:Raycast(p32 + Vector3.new(0, 6, 0), Vector3.new(0, -30, 0), v31)

    if v32 then
        return v32.Position
    end

    return p32 - Vector3.new(0, 3, 0)
end

return table.freeze(t3)
