-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Format = require(ReplicatedStorage.Shared.Format)
local LiveOps = require(ReplicatedStorage.Shared.LiveOps)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Trip = require(script.Parent.Trip)
local TripUi = require(script.Parent.TripUi)
local Gate = require(script.Parent.Gate)
local t1 = {}
local LocalPlayer = Players.LocalPlayer

local function v1() -- line: 30
    return false
end

function t1.setBusyCheck(p1) -- line: 35
    -- upvalues: v1 (ref)
    v1 = p1
end

local ScreenGui
local t2 = {}
local n1 = 0

local function caveZone() -- line: 44
    local EventHole = workspace:FindFirstChild("EventHole")
    local Cave = EventHole and EventHole:FindFirstChild("Cave")
    local TripZone = Cave and Cave:FindFirstChild("TripZone")

    return if TripZone and TripZone:IsA("BasePart") then TripZone else nil
end

local function returnZone() -- line: 51
    local v2 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("World2")
    local ReturnZone = v2 and v2:FindFirstChild("ReturnZone")

    return if ReturnZone and ReturnZone:IsA("BasePart") then ReturnZone else nil
end

local function inside(p2, p3) -- line: 57
    local v3 = p2.CFrame:PointToObjectSpace(p3)
    local v4 = p2.Size / 2

    if math.abs(v3.X) <= v4.X then
        if not (math.abs(v3.Y) <= v4.Y + 4) then
            return false
        end

        return math.abs(v3.Z) <= v4.Z
    end

    return false
end

local function short() -- line: 63
    -- upvalues: Gate (copy), LocalPlayer (copy)
    return (math.max(0, Gate.price() - (LocalPlayer:GetAttribute("Money") or 0)))
end

local function opensIn() -- line: 68
    -- upvalues: LiveOps (copy)
    return LiveOps.world2OpensIn(workspace:GetServerTimeNow())
end

local function go(p4) -- line: 72
    -- upvalues: Remotes (copy), LiveOps (copy), UIUtil (copy), Kit (copy), Trip (copy), Gate (copy), LocalPlayer (copy), n1 (ref)
    if not p4.shown or Trip.isPlaying() or os.clock() - n1 < 3 then
        return
    end

    if p4.action ~= "Unlock" or not (LiveOps.world2OpensIn(workspace:GetServerTimeNow()) > 0) and not (math.max(0, Gate.price() - (LocalPlayer:GetAttribute("Money") or 0)) > 0) then
        n1 = os.clock()
        UIUtil.sound("Click", 0.7)
        UIUtil.pop(p4.button, 0.85)

        if p4.action == "Return" then
            task.spawn(Trip.goBack)
        else
            Remotes.World2Trip:FireServer(p4.action)
        end
    else
        UIUtil.sound("Click", 0.6, 0.6)
        Kit.shake(p4.button, 12, 0.3)

        if p4.need then
            UIUtil.pop(p4.need, 1.35)
        end
    end
end

local function show(p5, p6) -- line: 96
    -- upvalues: UIUtil (copy), ScreenGui (ref)
    if p6 == p5.shown then
        return
    end

    p5.shown = p6
    ScreenGui.Enabled = true

    if not p6 then
        p5.holder.Visible = false

        return
    end

    p5.holder.Visible = true
    UIUtil.pop(p5.button, 0.5)
    UIUtil.sound("Pop", 0.5, 1.2)
end

local v8 = Color3.fromRGB(8, 28, 66)

local function buildButton(p7, p8, p9) -- line: 117
    -- upvalues: UserInputService (copy), Kit (copy), v8 (copy)
    local t3 = {}
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Rays"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://86205314584043"
    ImageLabel.ImageColor3 = Color3.fromRGB(190, 240, 255)
    ImageLabel.ImageTransparency = 0.35
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromOffset(520, 520)
    ImageLabel.ZIndex = 0
    ImageLabel.Parent = p7
    t3.rays = ImageLabel

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Teleport"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.fromScale(0.5, 0.5)
    TextButton.Size = UDim2.fromOffset(500, 130)
    TextButton.ZIndex = 2
    Kit.corner(TextButton, 26)
    Kit.stroke(TextButton, 6, v8)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 230, 255)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(30, 150, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 70, 190))
    })
    UIGradient.Parent = TextButton
    TextButton.Parent = p7

    local v9 = Kit.frame(TextButton, {
        Name = "Inside",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 2,
        Interactable = false,
        Position = UDim2.fromScale(0.04, 0.08),
        Size = UDim2.fromScale(0.92, 0.84)
    })

    t3.bubbles = {}

    for i = 1, 9 do
        local v10 = math.random(8, 20)
        local v11 = Kit.frame(v9, {
            Name = "Bubble",
            BackgroundTransparency = 0.75,
            ZIndex = 2,
            Interactable = false,
            BackgroundColor3 = Color3.fromRGB(200, 245, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(v10, v10)
        })
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = v11
        Kit.stroke(v11, 1.5, Color3.fromRGB(230, 252, 255)).Transparency = 0.4
        table.insert(t3.bubbles, {
            frame = v11,
            x = (i - 0.5) / 9 + (math.random() - 0.5) * 0.06,
            rise = 0.18 + math.random() * 0.2,
            start = math.random()
        })
    end

    local v12 = Kit.frame(TextButton, {
        Name = "Gloss",
        BackgroundTransparency = 0.72,
        ZIndex = 3,
        Interactable = false,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.new(0.05, 0, 0, 7),
        Size = UDim2.new(0.9, 0, 0.32, 0)
    })

    Kit.corner(v12, 16)

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Rotation = 90
    UIGradient2.Transparency = NumberSequence.new(0, 1)
    UIGradient2.Parent = v12

    local v13 = Kit.frame(TextButton, {
        Name = "Shine",
        ZIndex = 3,
        Interactable = false,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.fromScale(1, 1)
    })

    Kit.corner(v13, 26)

    local UIGradient3 = Instance.new("UIGradient")

    UIGradient3.Rotation = 20
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.42, 1),
        NumberSequenceKeypoint.new(0.5, 0.45),
        NumberSequenceKeypoint.new(0.58, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient3.Offset = Vector2.new(-1, 0)
    UIGradient3.Parent = v13
    t3.band = UIGradient3
    t3.small = Kit.text(TextButton, p8, {
        Name = "Small",
        ZIndex = 4,
        StrokeThickness = 3,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.1),
        Size = UDim2.fromScale(0.6, 0.27),
        TextColor3 = Color3.fromRGB(225, 248, 255)
    })

    local v14 = Kit.text(TextButton, p9, {
        Name = "Big",
        ZIndex = 4,
        StrokeThickness = 5,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.34),
        Size = UDim2.fromScale(0.86, 0.56)
    })

    v14.UIStroke.Color = v8

    local UIGradient4 = Instance.new("UIGradient")

    UIGradient4.Rotation = 90
    UIGradient4.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 225, 90))
    UIGradient4.Parent = v14
    t3.sparkles = {}

    for i = 1, 5 do
        local v15 = Kit.frame(p7, {
            Name = "Sparkle",
            BackgroundTransparency = 1,
            ZIndex = 5,
            Interactable = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(0, 0)
        })

        for _, v16 in { true, false } do
            local v17 = Kit.frame(v15, {
                ZIndex = 5,
                BackgroundColor3 = Color3.new(1, 1, 1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = if v16 then UDim2.fromScale(1, 0.12) else UDim2.fromScale(0.12, 1)
            })

            Kit.corner(v17, 4)
        end

        table.insert(t3.sparkles, {
            last = -1,
            frame = v15,
            life = 1 + math.random() * 0.7,
            offset = i * 0.41
        })
    end

    Kit.text(p7, "[E]", {
        Name = "Key",
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.5, 74),
        Size = UDim2.fromOffset(110, 36),
        TextColor3 = Color3.fromRGB(210, 235, 255)
    }).Visible = not UserInputService.TouchEnabled

    return TextButton, t3
end

local function step(p10, p11) -- line: 213
    -- upvalues: Format (copy), LiveOps (copy), Gate (copy), LocalPlayer (copy)
    local anim, button = p10.anim, p10.button

    anim.rays.Rotation = p11 * 22 % 360
    anim.rays.ImageTransparency = math.sin(p11 * 2) * 0.1 + 0.35

    local v19 = p11 % 2.6 / 0.7

    anim.band.Offset = Vector2.new(if v19 <= 1 then v19 * 2 + -1 else 1, 0)

    for _, v20 in anim.bubbles do
        local v21 = 1.15 - (v20.start + p11 * v20.rise) % 1.3

        v20.frame.Position = UDim2.fromScale(v20.x + math.sin(p11 * 2 + v20.start * 6) * 0.01, v21)
    end

    for _, v23 in anim.sparkles do
        local v25 = math.floor((p11 + v23.offset) / v23.life)

        if v25 ~= v23.last then
            v23.last = v25

            local v26 = math.random() * 3.141592653589793 * 2

            v23.frame.Position = UDim2.new(0.5, math.cos(v26) * 270, 0.5, math.sin(v26) * 82)
        end

        local v27 = (p11 + v23.offset) % v23.life / v23.life
        local v29 = math.sin(v27 * 3.141592653589793) * 30

        v23.frame.Size = UDim2.fromOffset(v29, v29)
        v23.frame.Rotation = v27 * 45
    end

    if p10.need then
        local v30 = LiveOps.world2OpensIn(workspace:GetServerTimeNow())
        local v32 = math.max(0, Gate.price() - (LocalPlayer:GetAttribute("Money") or 0))
        local small = anim.small

        if v30 > 0 then
            small.Text = "OPENS WITH THE EVENT"
        else
            small.Text = ("UNLOCK FOR %*"):format((Format.money(Gate.price())))
        end

        local need = p10.need

        if v30 > 0 then
            need.Text = ("Opens in %*!"):format((LiveOps.clock(v30)))
        elseif v32 > 0 then
            need.Text = ("You need %* more!"):format((Format.money(v32)))
        else
            need.Text = ""
        end

        local need2 = p10.need

        if v30 > 0 then
            need2.Visible = true
        else
            need2.Visible = v32 > 0
        end
    end

    local v34 = (math.sin(p11 * 4) + 1) / 2

    button.Size = UDim2.fromOffset(v34 * 14 + 500, v34 * 4 + 130)
    button.Rotation = math.sin(p11 * 2) * 1.5
end

function t1.init() -- line: 248
    -- upvalues: RunService (copy), UserInputService (copy), Remotes (copy), UIUtil (copy), Kit (copy), Trip (copy), TripUi (copy), Gate (copy), LocalPlayer (copy), v1 (ref), ScreenGui (ref), t2 (copy), caveZone (copy), returnZone (copy), go (copy), buildButton (copy), step (copy)
    TripUi.init()
    Gate.init()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SubDock"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 5
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    for _, v36 in {
            { "WORLD 2", caveZone, "Start" },
            { "WORLD 1", returnZone, "Return" },
            {
                "WORLD 2",
                Gate.zone,
                "Unlock"
            }
        } do
        local v37 = Kit.frame(ScreenGui, {
            Name = "Holder",
            BackgroundTransparency = 1,
            Visible = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.58),
            Size = UDim2.fromOffset(600, 200)
        })
        local UIScale = Instance.new("UIScale")

        UIScale.Name = "Scale"
        UIScale.Parent = v37

        local v38 = v36[3] == "Unlock"
        local v40, v41 = buildButton(v37, if v38 then "UNLOCK" else "TELEPORT TO", v36[1])
        local t7 = {
            shown = false,
            holder = v37,
            button = v40,
            anim = v41,
            zone = v36[2],
            action = v36[3]
        }

        if v38 then
            v41.small.Size = UDim2.fromScale(0.86, 0.27)
            t7.need = Kit.text(v37, "", {
                Name = "Need",
                ZIndex = 5,
                StrokeThickness = 4,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.new(0.5, 0, 0.5, 110),
                Size = UDim2.fromOffset(560, 46),
                TextColor3 = Color3.fromRGB(255, 90, 90)
            })
        end

        UIUtil.bindButton(v40, function() -- line: 269
            -- upvalues: t7 (copy), go (copy)
            go(t7)
        end)
        table.insert(t2, t7)
    end

    RunService.RenderStepped:Connect(function() -- line: 274
        -- upvalues: t2 (copy), step (copy)
        for _, v42 in t2 do
            if v42.shown then
                step(v42, os.clock())
            end
        end
    end)
    UserInputService.InputBegan:Connect(function(p12, p13) -- line: 281
        -- upvalues: t2 (copy), go (copy)
        if not p13 and (p12.KeyCode == Enum.KeyCode.E or p12.KeyCode == Enum.KeyCode.ButtonX) then
            for _, v43 in t2 do
                go(v43)
            end
        end
    end)
    Remotes.World2Trip.OnClientEvent:Connect(function(p14, p15) -- line: 291
        -- upvalues: Trip (copy), ScreenGui (ref), t2 (copy)
        if p14 ~= "Go" then
            return
        end

        for _, v44 in t2 do
            if v44.shown ~= false then
                v44.shown = false
                ScreenGui.Enabled = true
                v44.holder.Visible = false
            end
        end

        task.spawn(Trip.play, p15)
    end)

    local n2 = 0

    RunService.Heartbeat:Connect(function(p16) -- line: 300
        -- upvalues: n2 (ref), UIUtil (copy), Trip (copy), LocalPlayer (copy), v1 (ref), ScreenGui (ref), t2 (copy)
        n2 += p16

        if n2 < 0.1 then
            return
        end

        n2 = 0

        local Character = LocalPlayer.Character
        local v45 = Character

        if Character then
            v45 = Character:FindFirstChild("HumanoidRootPart")
            Character = Character:FindFirstChildOfClass("Humanoid")
        end

        local v46 = v45 ~= nil and Character ~= nil and Character.Health > 0 and not Trip.isPlaying() and not v1()

        for _, v47 in t2 do
            local v48 = v47.zone()
            local v49

            if v46 then
                if v48 ~= nil then
                    local Position = v45.Position
                    local v50 = v48.CFrame:PointToObjectSpace(Position)
                    local v51 = v48.Size / 2

                    v49 = false

                    if math.abs(v50.X) <= v51.X and math.abs(v50.Y) <= v51.Y + 4 then
                        v49 = math.abs(v50.Z) <= v51.Z
                    end
                else
                    v49 = false
                end
            else
                v49 = v46
            end

            if v49 ~= v47.shown then
                v47.shown = v49
                ScreenGui.Enabled = true

                if v49 then
                    v47.holder.Visible = true
                    UIUtil.pop(v47.button, 0.5)
                    UIUtil.sound("Pop", 0.5, 1.2)
                else
                    v47.holder.Visible = false
                end
            end
        end
    end)
end

t1.isPlaying = Trip.isPlaying

return t1
