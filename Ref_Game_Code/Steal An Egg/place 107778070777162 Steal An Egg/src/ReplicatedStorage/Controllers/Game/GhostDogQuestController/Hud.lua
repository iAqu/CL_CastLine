-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Fx = require(script.Parent.Fx)
local SurfaceButton = require(ReplicatedStorage.Client.UI.VFX.SurfaceButton)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local GhostDogQuest = ReplicatedStorage.Assets.GhostDogQuest
local Notification = ReplicatedStorage.Assets.Sounds.ScrambleBoss.Notification
local t1 = {
    Frame = { "BackgroundTransparency" },
    ImageLabel = { "ImageTransparency" },
    TextLabel = { "TextTransparency" },
    UIStroke = { "Transparency" }
}
local clone, Fade, Ticket, Bubbles, ScreenGui
local v1 = Trove.new()
local v2, v3
local v4 = false
local v5 = false
local t2 = {}
local t3 = {}

local function objectiveHitArea(p1) -- line: 49
    local PressSurface = p1:FindFirstChild("PressSurface")

    return if PressSurface and PressSurface:IsA("GuiObject") then PressSurface else nil
end

local function rememberRest(p2) -- line: 54
    -- upvalues: t1 (copy), t2 (copy)
    local v6 = t1[p2.ClassName]

    if v6 == nil then
        return
    end

    local t4 = {}

    for _, v7 in v6 do
        t4[v7] = p2[v7]
    end

    t2[p2] = t4
end

local function captureObjectiveRest(p3) -- line: 66
    -- upvalues: t1 (copy), t2 (copy)
    table.clear(t2)

    local v8 = t1[p3.ClassName]

    if v8 ~= nil then
        local t5 = {}

        for _, v9 in v8 do
            t5[v9] = p3[v9]
        end

        t2[p3] = t5
    end

    for _, descendant in p3:GetDescendants() do
        local v10 = t1[descendant.ClassName]

        if v10 ~= nil then
            local t6 = {}

            for _, v11 in v10 do
                t6[v11] = descendant[v11]
            end

            t2[descendant] = t6
        end
    end
end

local function fadeObjective(p4) -- line: 74
    -- upvalues: Fx (copy), clone (ref), t2 (copy)
    local clone2 = clone

    if clone2 ~= nil then
        clone2.Objective.Interactable = not p4

        for v12, v13 in t2 do
            local t7 = {}

            for v14, v15 in v13 do
                if p4 then
                    t7[v14] = 1
                else
                    t7[v14] = v15
                end
            end

            Fx.Tween(v12, 0.2, t7, Enum.EasingStyle.Sine)
        end
    end
end

local function watchBanner(p5, p6) -- line: 89
    -- upvalues: v1 (copy), v5 (ref), fadeObjective (copy)
    local function refresh() -- line: 90
        -- upvalues: p5 (copy), p6 (copy), v5 (ref), fadeObjective (copy)
        local v16 = false

        if p5.Enabled then
            for _, child in p6:GetChildren() do
                if child:IsA("GuiObject") then
                    v16 = true
                    break
                end

                v16 = false
            end
        end

        if v16 ~= v5 then
            v5 = v16
            fadeObjective(v16)
        end
    end

    v1:Connect(p6.ChildAdded, refresh)
    v1:Connect(p6.ChildRemoved, refresh)
    v1:Connect(p5:GetPropertyChangedSignal("Enabled"), refresh)
    refresh()
end

local function frameModel(p7, p8, p9, p10) -- line: 112
    p7:ClearAllChildren()

    local clone = p8:Clone()

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("Script") or descendant:IsA("LocalScript") then
            descendant:Destroy()
        end
    end

    local WorldModel = Instance.new("WorldModel")

    WorldModel.Parent = p7
    clone:PivotTo(CFrame.new())
    clone.Parent = WorldModel

    local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 30

    local v17 = BoundingBox2.Magnitude * (p10 or 1.5)
    local v19 = CFrame.Angles(0, math.rad(p9 or 30), 0) * CFrame.Angles(-0.3141592653589793, 0, 0)

    Camera.CFrame = CFrame.new(BoundingBox.Position) * v19 * CFrame.new(0, 0, v17)
    Camera.Parent = p7
    p7.CurrentCamera = Camera
end

function t3.Frame(p11, p12, p13, p14) -- line: 134
    -- upvalues: frameModel (copy)
    frameModel(p11, p12, p13, p14)
end

function t3.Get() -- line: 138
    -- upvalues: clone (ref)
    return clone
end

function t3.FadeFrame() -- line: 142
    -- upvalues: Fade (ref)
    return Fade
end

function t3.Ticket() -- line: 146
    -- upvalues: Ticket (ref)
    return Ticket
end

function t3.Mount() -- line: 150
    -- upvalues: SurfaceButton (copy), LocalPlayer (copy), GhostDogQuest (copy), clone (ref), Fade (ref), Ticket (ref), Bubbles (ref), ScreenGui (ref), v1 (copy), v3 (ref), v4 (ref), v5 (ref), captureObjectiveRest (copy), watchBanner (copy), frameModel (copy)
    if clone and clone.Parent then
        return clone
    end

    local clone2 = GhostDogQuest.GhostDogQuestUI:Clone()

    clone2.Enabled = not v4

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui2 = Instance.new("ScreenGui")

    ScreenGui2.Name = "GhostDogQuestOverlay"
    ScreenGui2.IgnoreGuiInset = true
    ScreenGui2.ResetOnSpawn = clone2.ResetOnSpawn
    ScreenGui2.ZIndexBehavior = clone2.ZIndexBehavior
    ScreenGui2.DisplayOrder = clone2.DisplayOrder + 1
    Fade = clone2.Fade
    Ticket = clone2.Ticket
    Bubbles = clone2.Bubbles
    ScreenGui = ScreenGui2
    clone2.Bubbles.Parent = ScreenGui2
    clone2.Ticket.Parent = ScreenGui2
    clone2.Fade.Parent = ScreenGui2
    clone2.Parent = PlayerGui
    ScreenGui2.Parent = PlayerGui
    clone = clone2
    v1:Add(clone2)
    v1:Add(ScreenGui2)
    clone2.Memories.Visible = false
    v1:Add(SurfaceButton(clone2.Objective, nil, function() -- line: 176
        -- upvalues: v3 (ref)
        local v20 = v3

        if v20 then
            v20()
        end
    end))

    local PressSurface = clone2.Objective:FindFirstChild("PressSurface")

    if not (PressSurface and PressSurface:IsA("GuiObject")) then
        PressSurface = nil
    end

    if PressSurface then
        PressSurface.Visible = v3 ~= nil
    end

    captureObjectiveRest(clone2.Objective)
    v5 = false
    v1:Add(task.spawn(function() -- line: 188
        -- upvalues: PlayerGui (copy), watchBanner (copy)
        local Notifications = PlayerGui:WaitForChild("Notifications")

        watchBanner(Notifications, Notifications:WaitForChild("Banner"))
    end))
    frameModel(clone2.Chase.Progress.Fish, GhostDogQuest.GhostFish, 90, 1.1)
    frameModel(clone2.Chase.Progress.Goal, GhostDogQuest.SunkenChest, 30, 1.3)

    return clone2
end

function t3.Unmount() -- line: 197
    -- upvalues: clone (ref), Fade (ref), Ticket (ref), Bubbles (ref), ScreenGui (ref), v1 (copy), v2 (ref), v3 (ref), v5 (ref), t2 (copy)
    v1:Clean()
    clone = nil
    ScreenGui = nil
    Fade = nil
    Ticket = nil
    Bubbles = nil
    v2 = nil
    v3 = nil
    v5 = false
    table.clear(t2)
end

function t3.SetHidden(p15) -- line: 210
    -- upvalues: clone (ref), v4 (ref)
    v4 = p15

    local clone2 = clone

    if clone2 then
        clone2.Enabled = not p15
    end
end

function t3.SetObjective(p16, p17) -- line: 218
    -- upvalues: Fx (copy), Notification (copy), clone (ref), v2 (ref), v3 (ref)
    v3 = if p16 then p17 else nil

    local clone2 = clone

    if clone2 == nil then
        return
    end

    local Objective = clone2.Objective
    local PressSurface = Objective:FindFirstChild("PressSurface")

    if not (PressSurface and PressSurface:IsA("GuiObject")) then
        PressSurface = nil
    end

    if PressSurface then
        PressSurface.Visible = v3 ~= nil
    end

    if p16 ~= nil then
        Objective.Visible = true

        if v2 ~= p16 then
            local v21 = v2 == nil

            v2 = p16
            Objective.Text.Text = p16

            local UIScale = Objective:FindFirstChildOfClass("UIScale")

            if UIScale then
                UIScale.Scale = v21 and 0.2 or 0.85
                Fx.Tween(UIScale, 0.45, {
                    Scale = 1
                }, Enum.EasingStyle.Back)
            end

            Fx.Play(Notification, {
                Volume = 0.35
            })
        end
    else
        Objective.Visible = false
        v2 = nil
    end
end

function t3.Fade(p18, p19) -- line: 249
    -- upvalues: Fx (copy), Fade (ref)
    local Fade2 = Fade

    if Fade2 ~= nil then
        local v22 = Fx.Tween(Fade2, p19, {
            BackgroundTransparency = 1 - p18
        }, Enum.EasingStyle.Sine)

        if p19 > 0 then
            v22.Completed:Wait()
        end
    end
end

function t3.Bubbles(p20, p21) -- line: 261
    -- upvalues: Fx (copy), Bubbles (ref)
    local Bubbles2 = Bubbles

    if Bubbles2 == nil then
        return
    end

    local Bubble = Bubbles2.Bubble
    local v23 = Random.new()

    for _ = 1, p21 do
        local clone = Bubble:Clone()

        clone.Visible = true

        local v24 = v23:NextNumber(0.025, 0.11)

        clone.Size = UDim2.fromScale(v24, v24)
        clone.Position = UDim2.fromScale(v23:NextNumber(0, 1), 1.1 + v23:NextNumber(0, 0.25))
        clone.Parent = Bubbles2

        local v25 = p20 * v23:NextNumber(0.6, 1)

        Fx.Tween(clone, v25, {
            BackgroundTransparency = 0.85,
            Position = UDim2.fromScale(clone.Position.X.Scale + v23:NextNumber(-0.08, 0.08), -0.15)
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(v25, function() -- line: 283
            -- upvalues: clone (copy)
            clone:Destroy()
        end)
    end
end

function t3.Cinematic(p22) -- line: 289
    -- upvalues: clone (ref)
    local clone2 = clone

    if clone2 ~= nil and p22 then
        clone2.Objective.Visible = false
    end
end

function t3.Caption(p23, p24) -- line: 299
    -- upvalues: Fx (copy), ScreenGui (ref), t3 (copy)
    local ScreenGui2 = ScreenGui

    if ScreenGui2 == nil then
        return
    end

    local Caption = ScreenGui2:FindFirstChild("Caption")

    if Caption == nil then
        Caption = Instance.new("TextLabel")
        Caption.Name = "Caption"
        Caption.BackgroundTransparency = 1
        Caption.AnchorPoint = Vector2.new(0.5, 0.5)
        Caption.Position = UDim2.fromScale(0.5, 0.8)
        Caption.Size = UDim2.fromScale(0.7, 0.065)
        Caption.TextScaled = true
        Caption.TextColor3 = Color3.new(1, 1, 1)
        Caption.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
        Caption.ZIndex = 60
        Caption.TextTransparency = 1

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 3
        UIStroke.Transparency = 1
        UIStroke.Parent = Caption
        Instance.new("UIScale").Parent = Caption
        Caption.Parent = ScreenGui2
    end

    local UIStroke = Caption:FindFirstChildOfClass("UIStroke")

    if p23 ~= nil then
        Caption.Text = p23
        Fx.Tween(Caption, 0.25, {
            TextTransparency = 0
        })
        Fx.Tween(UIStroke, 0.25, {
            Transparency = 0
        })

        local UIScale = Caption:FindFirstChildOfClass("UIScale")

        if UIScale then
            Fx.Punch(UIScale, 1.25, 0.35)
        end

        if p24 then
            local delay = task.delay
            local Caption2 = Caption

            delay(p24, function() -- line: 342
                -- upvalues: p23 (copy), Caption2 (copy), t3 (copy)
                if Caption2.Text == p23 then
                    t3.Caption(nil)
                end
            end)
        end
    else
        Fx.Tween(Caption, 0.3, {
            TextTransparency = 1
        })
        Fx.Tween(UIStroke, 0.3, {
            Transparency = 1
        })
    end
end

function t3.WorldToScreen(p25) -- line: 350
    -- upvalues: Workspace (copy)
    local v26, v27 = Workspace.CurrentCamera:WorldToViewportPoint(p25)

    if v27 then
        return Vector2.new(v26.X, v26.Y)
    end

    return nil
end

return table.freeze(t3)
