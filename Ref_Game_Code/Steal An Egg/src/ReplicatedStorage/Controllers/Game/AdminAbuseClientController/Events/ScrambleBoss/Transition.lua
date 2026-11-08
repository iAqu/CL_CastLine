-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Kit = require(script.Parent.Kit)
local v1 = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v3 = Color3.fromRGB(225, 255, 225)
local v4 = Color3.new(0, 0, 0)
local LocalPlayer = Players.LocalPlayer
local v5 = Random.new()
local v6 = Trove.new()
local v7 = v6:Extend()
local clone, Grid, Cell, Fade
local t1 = {}
local n1 = 0
local n2 = 0
local n3 = 1
local v8 = Vector2.zero
local v9 = "clear"
local t2
local v10 = false
local v11 = false
local n4 = 0
local n5 = 0
local n6 = 0
local Position
local v12 = false

local function viewport() -- line: 94
    -- upvalues: Workspace (copy), clone (ref)
    local v13 = if clone then clone.AbsoluteSize else Vector2.zero

    if v13.X >= 1 and v13.Y >= 1 then
        return v13
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.ViewportSize
    end

    return (Vector2.new(1280, 720))
end

local function ensureGui() -- line: 105
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), v6 (copy), v7 (ref), clone (ref), Grid (ref), Cell (ref), Fade (ref), t1 (ref), v8 (ref), v9 (ref), t2 (ref), v10 (ref), v11 (ref)
    if clone and clone.Parent then
        return true
    end

    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local UI = Assets and Assets:FindFirstChild("UI")
    local ScrambleBoss = UI and UI:FindFirstChild("ScrambleBoss")
    local BinaryTransition = ScrambleBoss and ScrambleBoss:FindFirstChild("BinaryTransition")

    if BinaryTransition == nil or not BinaryTransition:IsA("ScreenGui") then
        return false
    end

    v6:Clean()
    v7 = v6:Extend()
    v10 = false
    t1 = {}
    v8 = Vector2.zero
    v9 = "clear"
    t2 = nil
    v11 = false

    local clone2 = v6:Clone(BinaryTransition)
    local Grid2 = clone2:WaitForChild("Grid")
    local Cell2 = Grid2:WaitForChild("Cell")
    local Fade2 = clone2:WaitForChild("Fade")

    clone2.Enabled = false
    Cell2.Visible = false
    Fade2.Visible = false
    clone2.Parent = LocalPlayer:WaitForChild("PlayerGui")
    clone = clone2
    Grid = Grid2
    Cell = Cell2
    Fade = Fade2

    return true
end

local function paint(p1, p2) -- line: 144
    -- upvalues: v3 (copy)
    if p1.Glow ~= p2 then
        p1.Glow = p2
        p1.Digit.TextColor3 = p1.Tone:Lerp(v3, p2)
    end
end

local function apply(p3, p4) -- line: 153
    -- upvalues: n1 (ref), n2 (ref)
    local v14 = math.max(p4, 0)

    if p3.Value ~= v14 then
        p3.Value = v14
        p3.Frame.Size = UDim2.fromScale(n1 * v14, n2 * v14)
    end
end

local function rebuild() -- line: 163
    -- upvalues: Workspace (copy), Kit (copy), v4 (copy), v5 (copy), clone (ref), Grid (ref), Cell (ref), t1 (ref), n1 (ref), n2 (ref), n3 (ref), v8 (ref), v9 (ref)
    local v15 = if clone then clone.AbsoluteSize else Vector2.zero

    if not (v15.X >= 1 and v15.Y >= 1) then
        local CurrentCamera = Workspace.CurrentCamera

        v15 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    end

    if v15 == v8 and #t1 > 0 then
        return
    end

    v8 = v15

    for _, v16 in t1 do
        v16.Frame:Destroy()
    end

    table.clear(t1)

    local v17 = math.max(v15.X, v15.Y) / 22
    local v19 = math.ceil(v15.X / v17)
    local v21 = math.ceil(v15.Y / v17)

    n3 = v21

    local v22 = v17 / v15.X
    local v23 = v17 / v15.Y

    n1 = v22 * 1.04
    n2 = v23 * 1.04

    local v26 = math.max(math.floor(v17 * 0.72), 8)
    local v27 = if v9 == "covered" then 1 else 0

    for i = 1, v19 do
        for j = 1, v21 do
            local clone = Cell:Clone()

            clone.Name = ("%*_%*"):format(i, j)
            clone.Position = UDim2.fromScale((i - 0.5) * v22, (j - 0.5) * v23)
            clone.Size = UDim2.fromScale(n1 * v27, n2 * v27)
            clone.Visible = true

            local Digit = clone:WaitForChild("Digit")

            Digit.TextSize = v26
            Digit.Text = v5:NextNumber() < 0.5 and "0" or "1"

            local v28 = Kit.Green:Lerp(v4, 1 - v5:NextNumber(0.3, 1))

            Digit.TextColor3 = v28
            clone.Parent = Grid

            local t3 = t1

            table.insert(t3, {
                Glow = 0,
                Frame = clone,
                Digit = Digit,
                Column = i,
                Row = j,
                Value = v27,
                Tone = v28
            })
        end
    end
end

local function delays() -- line: 217
    -- upvalues: v5 (copy), t1 (ref), n3 (ref)
    local t5 = {}
    local v29 = table.create(#t1, 0)

    for v30, v31 in t1 do
        if t5[v31.Column] == nil then
            t5[v31.Column] = v5:NextNumber(0, 0.16)
        end

        local v32 = if n3 > 1 then (v31.Row - 1) / (n3 - 1) else 0

        v29[v30] = t5[v31.Column] + v32 * 0.26
    end

    return v29
end

local function setFade(p5) -- line: 232
    -- upvalues: Fade (ref), n4 (ref)
    n4 = math.clamp(p5, 0, 1)

    local Fade2 = Fade

    Fade2.BackgroundTransparency = 1 - n4
    Fade2.Visible = n4 > 0
end

local function flicker(p6) -- line: 239
    -- upvalues: v5 (copy), t1 (ref), n5 (ref)
    n5 += p6

    if not (n5 < 0.06) then
        n5 = 0

        for _, v33 in t1 do
            if v33.Value > 0 and v5:NextNumber() < 0.14 then
                v33.Digit.Text = v33.Digit.Text == "0" and "1" or "0"
            end
        end
    end
end

local v34

local function finish(p7) -- line: 255
    -- upvalues: v3 (copy), v7 (ref), clone (ref), Fade (ref), t1 (ref), n1 (ref), n2 (ref), v9 (ref), t2 (ref), v10 (ref), v11 (ref), n4 (ref), v34 (ref)
    t2 = nil

    if p7.Target == 1 then
        v9 = "covered"

        if v11 then
            v11 = false
            v34(0)
        end
    else
        v9 = "clear"
        v7:Clean()
        v10 = false

        for _, v35 in t1 do
            local v36 = math.max(0, 0)

            if v35.Value ~= v36 then
                v35.Value = v36
                v35.Frame.Size = UDim2.fromScale(n1 * v36, n2 * v36)
            end

            if v35.Glow ~= 0 then
                v35.Glow = 0
                v35.Digit.TextColor3 = v35.Tone:Lerp(v3, 0)
            end
        end

        n4 = 0

        local Fade2 = Fade

        Fade2.BackgroundTransparency = 1 - n4
        Fade2.Visible = n4 > 0

        if clone then
            clone.Enabled = false
        end
    end
end

local function step(p8) -- line: 280
    -- upvalues: TweenService (copy), v3 (copy), Fade (ref), t1 (ref), n1 (ref), n2 (ref), t2 (ref), n4 (ref), flicker (copy), finish (copy)
    flicker(p8)

    local t6 = t2

    if t6 ~= nil then
        local v37 = os.clock() - t6.Start

        if t6.Fade then
            local v39 = math.clamp(v37 / 0.15, 0, 1)

            n4 = math.clamp(t6.FadeFrom + (t6.Target - t6.FadeFrom) * v39, 0, 1)

            local Fade2 = Fade

            Fade2.BackgroundTransparency = 1 - n4
            Fade2.Visible = n4 > 0

            if v39 >= 1 then
                finish(t6)
            end
        else
            local v41 = math.max(t6.Info.Time, 0.001)
            local v42 = true

            for v43, v44 in t1 do
                local v45 = t6.From[v43] or 1 - t6.Target
                local v46 = (v37 - (t6.Delays[v43] or 0)) / v41
                local Target = t6.Target
                local n7 = 0

                if v45 == t6.Target then
                elseif v46 < 1 then
                    if v46 <= 0 then
                        v42 = false
                        Target = v45
                    else
                        local Value = TweenService:GetValue(v46, t6.Info.EasingStyle, t6.Info.EasingDirection)

                        v42 = false
                        Target = v45 + (t6.Target - v45) * Value
                        n7 = 1 - v46
                    end
                end

                local v47 = math.max(Target, 0)

                if v44.Value ~= v47 then
                    v44.Value = v47
                    v44.Frame.Size = UDim2.fromScale(n1 * v47, n2 * v47)
                end

                if v44.Glow ~= n7 then
                    v44.Glow = n7
                    v44.Digit.TextColor3 = v44.Tone:Lerp(v3, n7)
                end
            end

            if v42 then
                finish(t6)
            end
        end
    end
end

v34 = function(p9) -- line: 327
    -- upvalues: GuiService (copy), RunService (copy), Kit (copy), v1 (copy), v2 (copy), v3 (copy), v7 (ref), clone (ref), Fade (ref), t1 (ref), n1 (ref), n2 (ref), v9 (ref), t2 (ref), v10 (ref), n4 (ref), rebuild (copy), delays (copy), step (copy)
    local clone2 = clone
    local ReducedMotionEnabled = GuiService.ReducedMotionEnabled

    if ReducedMotionEnabled then
        local v48 = n4

        for _, v49 in t1 do
            v48 = math.max(v48, v49.Value)

            local v50 = math.max(0, 0)

            if v49.Value ~= v50 then
                v49.Value = v50
                v49.Frame.Size = UDim2.fromScale(n1 * v50, n2 * v50)
            end

            if v49.Glow ~= 0 then
                v49.Glow = 0
                v49.Digit.TextColor3 = v49.Tone:Lerp(v3, 0)
            end
        end

        n4 = math.clamp(math.min(v48, 1), 0, 1)

        local Fade2 = Fade

        Fade2.BackgroundTransparency = 1 - n4
        Fade2.Visible = n4 > 0
    else
        rebuild()

        if n4 > 0 then
            for _, v52 in t1 do
                local v54 = math.max(n4, 0)

                if v52.Value ~= v54 then
                    v52.Value = v54
                    v52.Frame.Size = UDim2.fromScale(n1 * v54, n2 * v54)
                end
            end

            n4 = 0

            local Fade2 = Fade

            Fade2.BackgroundTransparency = 1 - n4
            Fade2.Visible = n4 > 0
        end
    end

    local v55 = table.create(#t1, 0)

    for v56, v57 in t1 do
        v55[v56] = v57.Value
    end

    t2 = {
        Target = p9,
        Start = os.clock(),
        Info = if p9 == 1 then v1 else v2,
        From = v55,
        Delays = if ReducedMotionEnabled then {} else delays(),
        Fade = ReducedMotionEnabled,
        FadeFrom = n4
    }
    v9 = p9 == 1 and "covering" or "revealing"
    clone2.Enabled = true

    if p9 == 1 then
        Kit.Sound("Swoosh", nil, 0.5, 1.35)
    else
        Kit.Sound("Zap", nil, 0.25, 1.6)
    end

    if v10 then
        return
    end

    v10 = true
    v7:Connect(RunService.RenderStepped, step)
end

local function rootPosition() -- line: 377
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v59 = Player.FindRootPart(LocalPlayer)

    return if v59 then v59.Position else nil
end

local function cameraModule() -- line: 383
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = if PlayerScripts then PlayerScripts:FindFirstChild("PlayerModule") else nil

    if PlayerModule == nil or not PlayerModule:IsA("ModuleScript") then
        return nil
    end

    return require(PlayerModule):GetCameras()
end

local function faceCharacter() -- line: 393
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), cameraModule (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v60 = Player.FindRootPart(LocalPlayer)

    if CurrentCamera == nil or v60 == nil or CurrentCamera.CameraType ~= Enum.CameraType.Custom then
        return
    end

    local LookVector = v60.CFrame.LookVector
    local v61 = Vector3.new(LookVector.X, 0, LookVector.Z)

    if v61.Magnitude < 0.01 then
        return
    end

    local v62 = cameraModule()
    local v63 = (if v62 then v62:GetCameraSubjectPosition() else nil) or v60.Position + Vector3.new(0, 1.5, 0)
    local v65 = math.max((if v62 then v62:GetCameraToSubjectDistance() else nil) or (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude, 0.5)
    local v68 = math.clamp(math.asin((math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1))), -0.6981317007977318, -0.13962634015954636)
    local v69 = v61.Unit * math.cos(v68) + Vector3.new(0, 1, 0) * math.sin(v68)
    local v70 = CFrame.lookAt(v63 - v69 * v65, v63)

    CurrentCamera.CFrame = v70

    if v62 then
        v62:CommitCameraCFrame(v70, Enum.CameraType.Custom)
    end
end

local t8 = {}

function t8.Cover(p10, p11) -- line: 430
    -- upvalues: Player (copy), LocalPlayer (copy), v9 (ref), t2 (ref), v11 (ref), n6 (ref), Position (ref), ensureGui (copy), v34 (ref), t8 (copy)
    if not ensureGui() then
        return
    end

    n6 += 1

    local v71 = n6
    local v72 = Player.FindRootPart(LocalPlayer)

    Position = if v72 then v72.Position else nil
    v11 = false
    task.delay(math.max(p11 or 0, 5), function() -- line: 440
        -- upvalues: v71 (copy), v9 (ref), n6 (ref), t8 (copy)
        if n6 == v71 and v9 ~= "clear" and v9 ~= "revealing" then
            t8.Reveal()
        end
    end)

    if v9 ~= "covered" and v9 ~= "covering" then
        v34(1)

        if p10 and t2 then
            t2.Start -= 10
        end
    end
end

function t8.Reveal() -- line: 457
    -- upvalues: clone (ref), v9 (ref), v11 (ref), v34 (ref)
    if clone ~= nil and v9 ~= "clear" and v9 ~= "revealing" then
        if v9 == "covering" then
            v11 = true
        else
            v34(0)
        end
    end
end

function t8.RevealAfterMove() -- line: 470
    -- upvalues: Player (copy), LocalPlayer (copy), n6 (ref), Position (ref), faceCharacter (copy), t8 (copy)
    local v74 = n6
    local Position2 = Position
    local elapsed = os.clock()

    task.spawn(function() -- line: 475
        -- upvalues: v74 (copy), Position2 (copy), elapsed (copy), Player (copy), LocalPlayer (copy), n6 (ref), faceCharacter (copy), t8 (copy)
        while true do
            if os.clock() - elapsed < 0.75 then
                if n6 == v74 then
                    local v75 = Player.FindRootPart(LocalPlayer)
                    local Position = if v75 then v75.Position else nil

                    if Position2 == nil or Position and (Position - Position2).Magnitude > 12 then
                        break
                    end

                    task.wait()
                    continue
                end

                return
            end

            break
        end

        task.wait(0.08)

        if n6 == v74 then
            faceCharacter()
            t8.Reveal()
        end
    end)
end

function t8.Listen() -- line: 497
    -- upvalues: Remotes (copy), v12 (ref), t8 (copy)
    if not v12 then
        v12 = true
        Remotes.ScrambleBoss.Transition.OnClientEvent:Connect(function(p12, p13, p14) -- line: 504
            -- upvalues: t8 (copy)
            if p12 == "Cover" then
                t8.Cover(p13 == true, if type(p14) == "number" then p14 else nil)
            elseif p12 == "Reveal" then
                t8.RevealAfterMove()
            end
        end)
    end
end

return t8
