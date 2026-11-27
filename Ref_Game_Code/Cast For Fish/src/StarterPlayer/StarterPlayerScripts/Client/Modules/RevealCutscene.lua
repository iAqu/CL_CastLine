-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared.GameConfig)
local Fish = require(Shared.Data.Fish)
local Rarities = require(Shared.Data.Rarities)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local NumberFormat = require(Shared.NumberFormat)
local FishModels = require(Shared.FishModels)

require(Shared.Style)

local Roll = require(Shared.Roll)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local ScreenFx = require(script.Parent.ScreenFx)
local Pad = require(script.Parent.Pad)
local DeepSea = require(script.Parent.DeepSea)
local RevealStage = require(script.Parent.RevealStage)
local v1 = Font.fromEnum(Enum.Font.LuckiestGuy)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local v3 = Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Heavy)

local function jit(p1) -- line: 51
    return (math.clamp(math.noise(os.clock() * 24, p1 * 7.31, 0.5) * 0.9, -0.5, 0.5))
end

local function smoother(p2) -- line: 55
    local v5 = math.clamp(p2, 0, 1)

    return v5 * v5 * v5 * (v5 * (v5 * 6 - 15) + 10)
end

local CurrentCamera, fromRGB, new = workspace.CurrentCamera, Color3.fromRGB, Vector3.new
local t1 = {
    PauseAt = nil,
    PausedAt = nil,
    Waiting = false,
    AUTO_CONTINUE = 3,
    AutoHold = nil
}
local CutsceneFx = require(script.Parent.CutsceneFx)
local t2 = {
    pov = 1,
    hunt = 1.25,
    bobber = 1.2,
    dive = 0.78,
    eyes = 0.88,
    chase = 1.35,
    sonar = 1.6,
    drag = 1.1,
    whirl = 0.7
}

local function sfx(p3, p4) -- line: 77
    -- upvalues: UIKit (copy), t1 (copy), CutsceneFx (copy), t2 (copy)
    if p3 == "Splash" then
        CutsceneFx.Strike(t1.Intro)
    else
        local v6 = if p3 == "PovPulse" or p3 == "CastRelease" then (p4 or 1) * (t2[t1.Intro] or 1) else p4

        UIKit.sound(p3, v6)
    end
end

local t3 = {
    fromRGB(60, 170, 215),
    fromRGB(45, 110, 205),
    fromRGB(14, 22, 70)
}
local v7, t4, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, UIGradient, v21, v22
local v23 = false
local v24, v25, v26, v27
local t5 = {
    {
        at = 20,
        text = "Lucky Chance",
        color = fromRGB(255, 225, 100)
    },
    {
        at = 60,
        text = "Super Chance",
        color = fromRGB(255, 95, 105)
    },
    {
        at = 150,
        text = "Crazy Chance",
        color = fromRGB(100, 240, 130)
    },
    {
        at = 1000,
        text = "Legendary Chance",
        color = fromRGB(205, 135, 255)
    },
    {
        at = 10000,
        text = "Mythic Chance",
        color = fromRGB(255, 200, 70)
    },
    {
        at = 1E+05,
        text = "Impossible Chance",
        rainbow = true
    },
    {
        at = 1E+07,
        text = "Beyond Impossible Chance",
        rainbow = true
    }
}
local t6 = {
    tier = 0,
    final = 1,
    shown = 1
}
local t7 = {}
local t8
local t9 = {}
local t10 = {
    "pov",
    "hunt",
    "eyes",
    "chase",
    "drag",
    "whirl"
}
local ForceIntro
local t11 = {
    pov = 1.5
}

t1.ForceIntro = nil
t1.ForceLegend = nil
t1.ForceFull = nil

local t12 = {
    {
        dur = 10,
        c1 = fromRGB(80, 220, 255),
        c2 = fromRGB(255, 215, 110),
        ink = fromRGB(200, 246, 255),
        text = { "THE TIDE TURNS...", "SOMETHING ANCIENT WAKES" }
    },
    {
        dur = 12,
        c1 = fromRGB(255, 236, 170),
        c2 = fromRGB(255, 196, 70),
        ink = fromRGB(255, 247, 220),
        text = { "THE HEAVENS OPEN...", "A HYMN RISES FROM THE DEEP", "IT IS EXALTED" }
    },
    {
        dur = 14,
        c1 = fromRGB(70, 230, 240),
        c2 = fromRGB(60, 110, 230),
        ink = fromRGB(180, 250, 255),
        text = { "THE SEA BEGINS TO TURN...", "EVERYTHING IS PULLED DOWN", "THE MAW OPENS" }
    },
    {
        dur = 17,
        c1 = fromRGB(255, 120, 40),
        c2 = fromRGB(255, 222, 110),
        ink = fromRGB(255, 218, 160),
        text = { "TIME STANDS STILL...", "THE MOUNTAINS MOVE", "THE FIRST TITAN WAKES" }
    },
    {
        dur = 22,
        c1 = fromRGB(170, 90, 255),
        c2 = fromRGB(255, 95, 210),
        ink = fromRGB(228, 196, 255),
        text = { "REALITY BREAKS...", "THE STARS GO OUT", "NOTHING IS LEFT", "IT HAS ALWAYS BEEN HERE" }
    },
    {
        dur = 22,
        c1 = fromRGB(255, 140, 220),
        c2 = fromRGB(80, 230, 255),
        ink = fromRGB(255, 228, 245),
        text = { "THE SEA TURNS SWEET...", "THE COVE HOLDS ITS BREATH", "SUGAR CRACKS OPEN", "THE WARDEN AWAKENS" }
    }
}

t1.Intro = nil

local function hideNearbyProps(p5, p6, p7) -- line: 130
    -- upvalues: GameConfig (copy), t9 (copy)
    local World = workspace:FindFirstChild("World")
    local Props = World and World:FindFirstChild("Props")

    if not Props then
        return
    end

    local t13 = {}

    for _, child in ipairs(Props:GetChildren()) do
        table.insert(t13, child)

        for _, child in ipairs(child:GetChildren()) do
            if child:IsA("Folder") then
                table.insert(t13, child)
            end
        end
    end

    for _, v28 in ipairs(t13) do
        for _, child in ipairs(v28:GetChildren()) do
            local BoundingBox, Position

            if child:IsA("Model") then
                local BoundingBox2

                BoundingBox2, BoundingBox = child:GetBoundingBox()
                Position = BoundingBox2.Position
            elseif child:IsA("BasePart") then
                Position = child.Position
                BoundingBox = child.Size
            end

            if Position and (p7 or Position.Y < GameConfig.WATER_Y and BoundingBox.Y > 2.5) and math.max(math.max(math.abs(Position.X - p5.X) - BoundingBox.X / 2, 0), (math.max(math.abs(Position.Z - p5.Z) - BoundingBox.Z / 2, 0))) < p6 then
                for _, descendant in ipairs(child:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = 1
                        table.insert(t9, descendant)
                    end
                end

                if child:IsA("BasePart") then
                    child.LocalTransparencyModifier = 1
                    table.insert(t9, child)
                end
            end
        end
    end
end

local function hidePropsInBox(p8, p9, p10, p11) -- line: 176
    -- upvalues: t9 (copy)
    local World = workspace:FindFirstChild("World")
    local Props = World and World:FindFirstChild("Props")

    if not Props then
        return
    end

    local t14 = {}

    for _, child in ipairs(Props:GetChildren()) do
        table.insert(t14, child)

        for _, child in ipairs(child:GetChildren()) do
            if child:IsA("Folder") then
                table.insert(t14, child)
            end
        end
    end

    for _, v35 in ipairs(t14) do
        for _, child in ipairs(v35:GetChildren()) do
            local Position = if child:IsA("Model") then child:GetBoundingBox().Position elseif child:IsA("BasePart") then child.Position else nil

            if Position and math.abs(Position.X - p8) < p9 and p10 < Position.Z and Position.Z < p11 then
                for _, descendant in ipairs(child:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = 1
                        table.insert(t9, descendant)
                    end
                end

                if child:IsA("BasePart") then
                    child.LocalTransparencyModifier = 1
                    table.insert(t9, child)
                end
            end
        end
    end
end

local t15 = {}

t15.__index = t15
t15.EVERY = 3
t15.MAX_PROP = 90

function t15.new() -- line: 220
    -- upvalues: t15 (copy)
    return (setmetatable({
        Frame = 0,
        Stage = nil
    }, t15))
end

function t15.Step(p12, p13) -- line: 224
    -- upvalues: t9 (copy), t15 (copy)
    p12.Frame += 1

    local Stage = p12.Stage

    if Stage and p12.Frame % t15.EVERY == 0 then
        local v37 = Stage:Center()
        local World = workspace:FindFirstChild("World")
        local Props = World and World:FindFirstChild("Props")

        if v37 and Props then
            local v38 = RaycastParams.new()

            v38.FilterType = Enum.RaycastFilterType.Include
            v38.FilterDescendantsInstances = { Props }

            local v39 = p13

            for _ = 1, 4 do
                local v40 = v37 - v39

                if v40.Magnitude < 0.5 then
                    return
                end

                local v41 = workspace:Raycast(v39, v40, v38)

                if not v41 then
                    return
                end

                local v42 = v41.Instance

                while v42.Parent and v42.Parent ~= Props do
                    if v42.Parent:IsA("Folder") then
                        break
                    end

                    v42 = v42.Parent
                end

                local v43 = if v42:IsA("Model") then select(2, v42:GetBoundingBox()) elseif v42:IsA("BasePart") then v42.Size else Vector3.new(0, 0, 0)

                if math.max(v43.X, v43.Y, v43.Z) <= t15.MAX_PROP then
                    local Descendants = v42:GetDescendants()

                    table.insert(Descendants, v42)

                    for _, v44 in ipairs(Descendants) do
                        if v44:IsA("BasePart") and v44.LocalTransparencyModifier < 1 then
                            v44.LocalTransparencyModifier = 1
                            table.insert(t9, v44)
                        end
                    end
                end

                v39 = v41.Position + v40.Unit * 0.1
            end
        end
    end
end

local v45 = t15.new()

function t1.Cleanup() -- line: 269
    -- upvalues: Lighting (copy), DeepSea (copy), RevealStage (copy), t1 (copy), CutsceneFx (copy), v7 (ref), t4 (ref), t7 (copy), t8 (ref), t9 (copy), v45 (copy)
    v45.Stage = nil
    CutsceneFx.End()
    DeepSea.End()
    RevealStage.Restore()
    t1.Waiting = false
    CutsceneFx.Rush = false

    if not CutsceneFx.SkipNext then
        local SkipButton = require(script.Parent.SkipButton)

        SkipButton.Hide("reveal")
        SkipButton.Cover(false, 0.2)
    end

    if v7 then
        v7.Enabled = false
    end

    for _, v46 in ipairs(t7) do
        v46:Destroy()
    end

    table.clear(t7)

    for _, v47 in ipairs(t9) do
        v47.LocalTransparencyModifier = 0
    end

    table.clear(t9)

    if t8 then
        local v48 = t8[1]
        local v49 = t8[2]
        local v50 = t8[3]

        Lighting.FogStart = v48
        Lighting.FogEnd = v49
        Lighting.FogColor = v50
        t8 = nil
    end

    if t4 then
        for _, v51 in ipairs(t4) do
            v51.BackgroundTransparency = 1
        end
    end
end

local function checkpoint(p14) -- line: 303
    -- upvalues: CurrentCamera (copy), t1 (copy)
    if t1.PauseAt ~= p14 then
        return
    end

    t1.PausedAt = p14

    local CFrame, FieldOfView = CurrentCamera.CFrame, CurrentCamera.FieldOfView

    while t1.PauseAt == p14 do
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = CFrame
        CurrentCamera.FieldOfView = FieldOfView
        task.wait()
    end

    t1.PausedAt = nil
end

local function run(p15, p16) -- line: 321
    -- upvalues: RunService (copy), DeepSea (copy), CurrentCamera (copy), CutsceneFx (copy), v45 (copy)
    local elapsed = os.clock()
    local v52 = 0
    local v53 = nil
    local v54 = CFrame.identity

    while true do
        local elapsed2 = os.clock()

        v52 += (elapsed2 - elapsed) * CutsceneFx.Speed()

        local v56 = math.min(v52 / p15, 1)

        p16(v56, v52)
        v45:Step(CurrentCamera.CFrame.Position)
        DeepSea.Step()

        local v57 = CutsceneFx.ShakeCF()
        local v58, v59

        if v57 == CFrame.identity and v54 == CFrame.identity then
            v58 = v54
            v59 = v53
        else
            v58 = v57
            CurrentCamera.CFrame = (if v53 and CurrentCamera.CFrame == v53 then v53 * v54:Inverse() else CurrentCamera.CFrame) * v57
            v59 = CurrentCamera.CFrame
        end

        if v56 >= 1 then
            break
        end

        v54 = v58
        RunService.RenderStepped:Wait()
        elapsed = elapsed2
        v53 = v59
    end
end

local function hex(p17) -- line: 347
    return string.format("#%02X%02X%02X", math.floor(p17.R * 255 + 0.5), math.floor(p17.G * 255 + 0.5), (math.floor(p17.B * 255 + 0.5)))
end

local function setVignette(p18, p19, p20) -- line: 352
    -- upvalues: UIKit (copy), t4 (ref)
    for _, v65 in ipairs(t4) do
        if p18 then
            v65.BackgroundColor3 = p18
        end

        UIKit.tween(v65, p20 or 0.3, {
            BackgroundTransparency = 1 - p19
        })
    end
end

local function buildGui() -- line: 361
    -- upvalues: UIKit (copy), Pad (copy), v1 (copy), v2 (copy), fromRGB (copy), v7 (ref), t4 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), v16 (ref), v17 (ref), v18 (ref), v19 (ref), v20 (ref), UIGradient (ref), v21 (ref), v22 (ref), v24 (ref), v25 (ref), v26 (ref), v27 (ref)
    v7 = UIKit.screenGui("Reveal", 30)

    local v66 = v7

    v66.ScreenInsets = Enum.ScreenInsets.None
    v7.Enabled = false

    local new, new2 = NumberSequence.new, NumberSequenceKeypoint.new

    local function edge(p21, p22, p23, p24, p25, p26) -- line: 366
        -- upvalues: new (copy), new2 (copy), UIKit (copy), fromRGB (copy), v7 (ref)
        local v67 = UIKit.frame(v7, {
            Transparency = 1,
            Name = p21,
            Size = p22,
            Position = p23,
            AnchorPoint = p24,
            Color = fromRGB(0, 0, 0)
        })
        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = p25

        if p26 then
            UIGradient.Transparency = new({
                new2(0, 1),
                new2(0.55, 0.75),
                new2(1, 0.05)
            })
        else
            UIGradient.Transparency = new({
                new2(0, 0.05),
                new2(0.45, 0.75),
                new2(1, 1)
            })
        end

        UIGradient.Parent = v67

        return v67
    end

    t4 = {
        edge("VTop", UDim2.fromScale(1, 0.36), UDim2.fromScale(0, 0), Vector2.zero, 90, false),
        edge("VBottom", UDim2.fromScale(1, 0.36), UDim2.fromScale(0, 1), Vector2.new(0, 1), 90, true),
        edge("VLeft", UDim2.fromScale(0.3, 1), UDim2.fromScale(0, 0), Vector2.zero, 0, false),
        (edge("VRight", UDim2.fromScale(0.3, 1), UDim2.fromScale(1, 0), Vector2.new(1, 0), 0, true))
    }
    v17 = UIKit.frame(v7, {
        Name = "Rays",
        Transparency = 1,
        Size = UDim2.fromOffset(4, 4),
        Position = UDim2.fromScale(0.5, 0.42),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    for i = 0, 11 do
        local v69 = UIKit.frame(v17, {
            Name = "Ray",
            Transparency = 0.86,
            Size = UDim2.fromOffset(i % 2 == 0 and 60 or 28, 2600),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = fromRGB(255, 255, 255)
        })

        v69.Rotation = i * 15

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.36, 0.35),
            NumberSequenceKeypoint.new(0.45, 1),
            NumberSequenceKeypoint.new(0.55, 1),
            NumberSequenceKeypoint.new(0.64, 0.35),
            NumberSequenceKeypoint.new(1, 0)
        })
        UIGradient.Parent = v69
    end

    v17.Visible = false
    v18 = UIKit.frame(v7, {
        Name = "Ring",
        Transparency = 1,
        Size = UDim2.fromOffset(300, 300),
        Position = UDim2.fromScale(0.5, 0.42),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = v18

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 16
    UIStroke.Color = fromRGB(255, 255, 255)
    UIStroke.Parent = v18
    v18.Visible = false
    v21 = UIKit.frame(v7, {
        Name = "LowShade",
        Transparency = 0,
        Size = UDim2.fromScale(1, 0.52),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        Color = fromRGB(2, 6, 18)
    })

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Rotation = 90
    UIGradient2.Transparency = new({
        new2(0, 1),
        new2(0.45, 0.62),
        new2(1, 0.3)
    })
    UIGradient2.Parent = v21
    v21.Visible = false
    v9 = UIKit.frame(v7, {
        Name = "Swoosh",
        Transparency = 0.55,
        Size = UDim2.fromOffset(1500, 150),
        Position = UDim2.fromScale(-0.6, 0.79),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(8, 14, 36)
    })
    v9.Rotation = -3

    local UIGradient3 = Instance.new("UIGradient")

    UIGradient3.Transparency = new({
        new2(0, 1),
        new2(0.2, 0),
        new2(0.8, 0),
        new2(1, 1)
    })
    UIGradient3.Parent = v9
    v9.Visible = false
    v8 = UIKit.frame(v7, {
        Name = "Letters",
        Transparency = 1,
        ZIndex = 3,
        Size = UDim2.new(1, 0, 0, 130),
        Position = UDim2.fromScale(0.5, 0.79),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.Parent = v8
    v10 = UIKit.frame(v7, {
        Name = "Result",
        Transparency = 1,
        ZIndex = 3,
        Size = UDim2.fromOffset(1700, 330),
        Position = UDim2.fromScale(0.5, 0.76),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    v22 = UIKit.image(v10, "Glow", {
        Transparency = 0.7,
        ZIndex = 3,
        Size = UDim2.fromOffset(1100, 300),
        Position = UDim2.new(0.5, 0, 0, 122),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local v70 = v22

    v70.ScaleType = Enum.ScaleType.Stretch
    v11 = UIKit.text(v10, {
        Name = "Tags",
        TextSize = 54,
        Stroke = 6,
        ZIndex = 4,
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.fromOffset(0, 0)
    })
    v11.RichText = true
    v11.FontFace = v1
    v12 = UIKit.text(v10, {
        Name = "FishName",
        TextSize = 118,
        Stroke = 10,
        ZIndex = 4,
        Size = UDim2.new(1, 0, 0, 130),
        Position = UDim2.fromOffset(0, 58)
    })
    v12.FontFace = v1
    v13 = UIKit.text(v10, {
        Name = "Rate",
        TextSize = 72,
        Stroke = 7,
        ZIndex = 4,
        Size = UDim2.new(1, 0, 0, 76),
        Position = UDim2.fromOffset(0, 186),
        Color = UIKit.Colors.Cash,
        StrokeColor = UIKit.Colors.CashStroke
    })
    v13.FontFace = v1
    v14 = UIKit.text(v10, {
        Name = "Details",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 4,
        Size = UDim2.new(1, 0, 0, 38),
        Position = UDim2.fromOffset(0, 266),
        Color = fromRGB(214, 228, 255)
    })
    v14.FontFace = v2
    v15 = UIKit.frame(v10, {
        Name = "New",
        Corner = 16,
        Stroke = 6,
        ZIndex = 5,
        Size = UDim2.fromOffset(190, 76),
        Position = UDim2.new(0.5, 400, 0, 90),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = UIKit.Colors.Orange,
        Color2 = UIKit.Colors.OrangeDark
    })
    v15.Rotation = 10
    UIKit.dress(v15, 16, nil, 5)
    UIKit.text(v15, {
        Text = "NEW!",
        TextSize = 50,
        Stroke = 5,
        ZIndex = 6
    }).FontFace = v1
    v19 = UIKit.frame(v10, {
        Name = "Rarity",
        Corner = 12,
        Stroke = 4,
        ZIndex = 5,
        Size = UDim2.fromOffset(200, 34),
        Position = UDim2.new(0.5, 0, 0, 26),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(255, 255, 255),
        Color2 = fromRGB(200, 200, 200)
    })
    v19.Rotation = -3
    UIKit.dress(v19, 12, nil, 5)
    v20 = UIKit.text(v19, {
        Name = "Label",
        Text = "",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 6,
        Size = UDim2.new(1, 0, 1, 2)
    })
    v20.FontFace = v1
    UIGradient = Instance.new("UIGradient")
    UIGradient.Name = "Shine"
    UIGradient.Rotation = 20
    UIGradient.Parent = v12
    v10.Visible = false
    v24 = UIKit.frame(v7, {
        Name = "Odds",
        Transparency = 1,
        ZIndex = 3,
        Size = UDim2.fromOffset(1100, 170),
        Position = UDim2.new(0.5, 0, 0, 26),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    v27 = UIKit.text(v24, {
        Name = "Tier",
        Text = "",
        TextSize = 56,
        Stroke = 7,
        ZIndex = 5,
        Size = UDim2.new(1, 0, 0, 64),
        Position = UDim2.fromOffset(0, 0)
    })
    v27.Rotation = -2
    v27.FontFace = v1
    v25 = UIKit.frame(v24, {
        Name = "Pill",
        Transparency = 0.6,
        Corner = 48,
        Stroke = 4,
        ZIndex = 3,
        Size = UDim2.fromOffset(620, 98),
        Position = UDim2.new(0.5, 0, 0, 66),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(30, 34, 50)
    })

    local UIStroke2 = v25:FindFirstChildOfClass("UIStroke")

    UIStroke2.Color = fromRGB(255, 255, 255)
    UIStroke2.Transparency = 0.8
    v26 = UIKit.text(v25, {
        Name = "Number",
        Text = "1 in 1",
        TextSize = 76,
        Stroke = 8,
        ZIndex = 5,
        Size = UDim2.new(1, 0, 1, 6)
    })
    v26.FontFace = v1
    v24.Visible = false
    v16 = UIKit.text(v7, {
        Name = "Tap",
        Text = "TAP TO CONTINUE",
        TextSize = 26,
        Stroke = 4,
        ZIndex = 4,
        Size = UDim2.fromOffset(600, 40),
        Position = UDim2.fromScale(0.5, 0.955),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    Pad.IconBeside(v16, Enum.KeyCode.ButtonA, 40)
    v16.FontFace = v2
    v16.Visible = false
end

local function makeLetters(p27) -- line: 480
    -- upvalues: UIKit (copy), v1 (copy), fromRGB (copy), v8 (ref)
    for _, child in ipairs(v8:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    local t18 = {}
    local t19 = {}
    local v74 = math.clamp(math.floor(1500 / math.max(#p27, 1)), 54, 104)

    for i = 1, #p27 do
        local v75 = string.upper((string.sub(p27, i, i)))
        local v76 = v75 == " "
        local v78 = UIKit.frame(v8, {
            Transparency = 1,
            ZIndex = 4,
            Name = "L" .. i,
            Size = UDim2.fromOffset(if v76 then v74 * 0.42 else v74 * 0.84, 130)
        })

        v78.LayoutOrder = i

        local t21 = {
            slot = v78,
            char = v75
        }

        if v76 then
            t21.label = UIKit.text(v78, {
                Name = "Letter",
                Text = "",
                TextSize = 10,
                Stroke = 0,
                ZIndex = 5
            })
        else
            t21.bar = UIKit.frame(v78, {
                Name = "Bar",
                Transparency = 0.15,
                Corner = 6,
                Stroke = 3,
                ZIndex = 4,
                Size = UDim2.new(1, -10, 0, (math.max(8, (math.floor(v74 * 0.13))))),
                Position = UDim2.new(0.5, 0, 0.5, (math.floor(v74 * 0.5))),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Color = fromRGB(255, 255, 255)
            })
            t21.glow = UIKit.image(v78, "Glow", {
                Transparency = 1,
                ZIndex = 4,
                Size = UDim2.fromScale(1.2, 1.2),
                Position = UDim2.fromScale(0.5, 0.45),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })
            t21.label = UIKit.text(v78, {
                Name = "Letter",
                Stroke = 8,
                ZIndex = 5,
                Text = v75,
                TextSize = v74 * 1.02,
                Size = UDim2.fromScale(1.4, 1),
                Position = UDim2.fromScale(0.5, 0.45),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })
            t21.label.FontFace = v1
            t21.label.TextTransparency = 1
            t21.label:FindFirstChildOfClass("UIStroke").Transparency = 1
            table.insert(t19, i)
        end

        t18[i] = t21
    end

    for i = #t19, 2, -1 do
        local v82 = math.random(i)
        local v83 = t19[v82]
        local v84 = t19[i]

        t19[i] = v83
        t19[v82] = v84
    end

    return t18, t19
end

local function landLetter(p28, p29, p30) -- line: 518
    -- upvalues: UIKit (copy)
    local label = p28.label

    label.Text = p28.char
    label.TextTransparency = 0

    local UIStroke = label:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Transparency = 0
    end

    label.Position = UDim2.new(0.5, 0, 0.45, -44)
    label.Rotation = math.random(-16, 16)
    UIKit.tween(label, 0.3, {
        Rotation = 0,
        Position = UDim2.fromScale(0.5, 0.45)
    }, Enum.EasingStyle.Back)

    local v85 = UIKit.scaleOf(label)

    v85.Scale = 1.8
    UIKit.tween(v85, 0.34, {
        Scale = 1
    }, Enum.EasingStyle.Back)

    if p28.bar then
        local v86 = UIKit.scaleOf(p28.bar)

        v86.Scale = 1.3
        UIKit.tween(v86, 0.32, {
            Scale = 1
        }, Enum.EasingStyle.Back)
        p28.bar.Position = UDim2.new(0.5, 0, 0.5, p28.bar.Position.Y.Offset + 6)
        UIKit.tween(p28.bar, 0.3, {
            Position = UDim2.new(0.5, 0, 0.5, p28.bar.Position.Y.Offset - 6)
        }, Enum.EasingStyle.Back)
    end

    if p28.glow then
        p28.glow.ImageTransparency = 0.15
        p28.glow.Size = UDim2.fromScale(1.1, 1.1)
        UIKit.tween(p28.glow, 0.5, {
            ImageTransparency = 1,
            Size = UDim2.fromScale(2.8, 2.8)
        })
    end

    UIKit.sound("LetterPop", p29 * 0.55 / math.max(p30, 1) + 0.9)
end

local function burst2D(p31, p32) -- line: 547
    -- upvalues: Debris (copy), UIKit (copy), fromRGB (copy), v7 (ref)
    for i = 1, p32 do
        local v87 = i / p32 * 3.141592653589793 * 2 + math.random() * 0.4
        local v88 = 380 + math.random() * 520
        local v89 = 16 + math.random() * 26
        local v91 = UIKit.frame(v7, {
            Name = "Spark",
            ZIndex = 2,
            Size = UDim2.fromOffset(v89, v89),
            Position = UDim2.fromScale(0.5, 0.42),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = if i % 3 == 0 then p31 else fromRGB(255, 255, 255)
        })

        v91.Rotation = 45
        UIKit.tween(v91, 0.7 + math.random() * 0.5, {
            BackgroundTransparency = 1,
            Rotation = 225,
            Position = UDim2.new(0.5, math.cos(v87) * v88, 0.42, math.sin(v87) * v88),
            Size = UDim2.fromOffset(v89 * 0.3, v89 * 0.3)
        })
        Debris:AddItem(v91, 1.4)
    end
end

task.spawn(function() -- line: 559
    -- upvalues: UIKit (copy)
    local function v92() -- line: 560
        -- upvalues: UIKit (copy)
        game:GetService("ContentProvider"):PreloadAsync({
            UIKit.Art.Bubbles
        })
    end

    pcall(v92)
end)

local function burst3D(p33, p34, p35) -- line: 564
    -- upvalues: Debris (copy), GameConfig (copy), UIKit (copy), fromRGB (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(p33)
    Part.Parent = workspace

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Color = ColorSequence.new(fromRGB(255, 255, 255), p34)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.3)
    ParticleEmitter.Speed = NumberRange.new(10, 26)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 3
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.Rate = 0

    if p33.Y < GameConfig.WATER_Y - 0.5 then
        ParticleEmitter.Texture = UIKit.Art.Bubbles
        ParticleEmitter.Color = ColorSequence.new(fromRGB(235, 250, 255))
        ParticleEmitter.LightEmission = 0.35
        ParticleEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1.3)
        })
        ParticleEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.7, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })
        ParticleEmitter.Lifetime = NumberRange.new(0.7, 1.5)
        ParticleEmitter.Speed = NumberRange.new(4, 13)
        ParticleEmitter.Drag = 2.5
        ParticleEmitter.Acceleration = Vector3.new(0, 10, 0)
        ParticleEmitter.RotSpeed = NumberRange.new(-40, 40)
    end

    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(p35)
    Debris:AddItem(Part, 2)
end

local function confetti(p36, p37, p38) -- line: 602
    -- upvalues: Debris (copy), UIKit (copy), fromRGB (copy), v7 (ref)
    local t24 = {
        p37,
        p38,
        fromRGB(255, 255, 255),
        fromRGB(255, 226, 90)
    }

    for i = 1, p36 do
        local v93 = math.random()
        local v94 = 12 + math.random() * 12
        local v95 = UIKit.frame(v7, {
            Name = "Confetti",
            Corner = 3,
            ZIndex = 2,
            Size = UDim2.fromOffset(v94, v94 * (1.2 + math.random())),
            Position = UDim2.fromScale(v93, -0.06 - math.random() * 0.25),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = t24[i % #t24 + 1]
        })

        v95.Rotation = math.random(0, 360)

        local v96 = 1.7 + math.random() * 1.5

        UIKit.tween(v95, v96, {
            Position = UDim2.fromScale(v93 + (math.random() - 0.5) * 0.16, 1.08),
            Rotation = v95.Rotation + (i % 2 == 0 and 540 or -540)
        }, Enum.EasingStyle.Linear)
        Debris:AddItem(v95, v96 + 0.1)
    end
end

local function oddsColor(p39) -- line: 617
    -- upvalues: fromRGB (copy), t5 (copy)
    local v97 = t5[p39]

    if not v97 then
        return fromRGB(255, 255, 255)
    end

    if v97.rainbow then
        return (Color3.fromHSV(os.clock() * 0.55 % 1, 0.6, 1))
    end

    return v97.color
end

local n1 = 0

local function oddsSet(p40) -- line: 627
    -- upvalues: NumberFormat (copy), UIKit (copy), fromRGB (copy), v25 (ref), v26 (ref), v27 (ref), t5 (copy), t6 (copy), burst2D (copy), n1 (ref)
    local v99 = math.clamp(math.floor(p40), 1, t6.final)

    if v99 ~= t6.shown and v99 < t6.final and os.clock() - n1 > 0.075 then
        n1 = os.clock()

        local v102 = math.log(v99) / math.max(math.log(t6.final), 0.01)

        UIKit.sound("LuckTick", v102 * 0.7 + 0.85)
    end

    t6.shown = v99

    local v103 = v26

    v103.Text = NumberFormat.odds(v99)

    local n2 = 0

    for v104, v105 in ipairs(t5) do
        if v105.at <= v99 then
            n2 = v104
        end
    end

    if n2 ~= t6.tier then
        t6.tier = n2

        local v106 = t5[n2]
        local v107 = v27

        if v106 then
            v107.Text = v106.text
            UIKit.pop(v27, 1.7)
            UIKit.pop(v26, 1.3)

            local v108 = n2 * 0.14 + 0.9

            UIKit.sound("ZoneChange", v108)

            local v109 = t5[n2]

            burst2D(if not v109 then fromRGB(255, 255, 255) elseif v109.rainbow then Color3.fromHSV(os.clock() * 0.55 % 1, 0.6, 1) else v109.color, n2 * 3 + 6)
        else
            v107.Text = ""
        end
    end

    local v111 = t5[n2]
    local v112 = if not v111 then fromRGB(255, 255, 255) elseif v111.rainbow then Color3.fromHSV(os.clock() * 0.55 % 1, 0.6, 1) else v111.color

    v27.TextColor3 = v112

    local v113 = v26

    if n2 >= 1 then
        v113.TextColor3 = v112:Lerp(Color3.new(1, 1, 1), 0.55)
    else
        v113.TextColor3 = Color3.new(1, 1, 1)
    end

    local v114 = v25

    if n2 >= 1 then
        v114.BackgroundColor3 = v112:Lerp(Color3.new(0, 0, 0), 0.35)
    else
        v114.BackgroundColor3 = fromRGB(30, 34, 50)
    end

    local v115 = v25

    v115.BackgroundTransparency = n2 >= 1 and 0.35 or 0.6
end

local function oddsStart(p41) -- line: 661
    -- upvalues: UIKit (copy), v24 (ref), v27 (ref), t6 (copy), oddsSet (copy)
    t6.final = math.max(1, (math.floor(p41 or 1)))
    t6.tier = 0
    v27.Text = ""
    v24.Visible = true
    oddsSet(1)
    UIKit.pop(v24, 0.7)
end

local function oddsProgress(p42) -- line: 671
    -- upvalues: t6 (copy), oddsSet (copy)
    oddsSet(t6.final ^ (math.clamp(p42, 0, 1) * 0.96))
end

function t1.Play(p43, p44) -- line: 675
    -- upvalues: RunService (copy), Lighting (copy), Debris (copy), ReplicatedStorage (copy), GameConfig (copy), Fish (copy), Rarities (copy), Variants (copy), Sizes (copy), NumberFormat (copy), FishModels (copy), Roll (copy), UIKit (copy), DataClient (copy), ScreenFx (copy), Pad (copy), DeepSea (copy), RevealStage (copy), v1 (copy), v3 (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy), t3 (copy), v7 (ref), t4 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), v16 (ref), v17 (ref), v18 (ref), v19 (ref), v20 (ref), UIGradient (ref), v21 (ref), v22 (ref), v23 (ref), v24 (ref), v27 (ref), t6 (copy), t7 (copy), t8 (ref), t9 (copy), t10 (copy), ForceIntro (ref), t11 (copy), t12 (copy), hideNearbyProps (copy), hidePropsInBox (copy), v45 (copy), checkpoint (copy), run (copy), setVignette (copy), makeLetters (copy), landLetter (copy), burst2D (copy), burst3D (copy), confetti (copy), oddsSet (copy)
    local v118 = Fish.ById[p43.fishId]
    local v119 = Rarities.ById[v118.rarity]
    local v120 = Variants.List[p43.variant] or Variants.List[1]
    local v121 = Sizes.List[p43.size] or Sizes.List[Sizes.NORMAL_INDEX]
    local n3 = 0
    local n4 = 0

    if v119.order >= 3 or v120.index >= 2 or v121.index >= 3 then
        n3 = 1
        n4 = 1
    end

    if v119.order >= 5 or (v120.odds or 1) >= 35 or v121.index >= 5 then
        n3 = 2
        n4 = 2
    end

    local v122 = if v120.index >= 2 then v120.Color elseif v119.order >= 3 then v119.Color else fromRGB(255, 255, 255)
    local v123 = if n4 == 0 then fromRGB(4, 10, 26) elseif n4 == 1 then fromRGB(255, 165, 40) else v122
    local Settings = require(script.Parent.DataClient).Get("Settings")
    local v124 = false
    local v125

    if game:GetService("Players").LocalPlayer:GetAttribute("OwnsSkipCutscene") == true then
        v125 = not (Settings and Settings.SkipCutscenes == false)
        v124 = v125
    else
        v125 = false
    end

    if v125 and ((t1.ForceLegend or Roll.legend(p43.fishId)) > 0 or t1.ForceFull) then
        v124 = false
        v125 = false
    end

    t1.Skipped = v125

    local v127 = p43.thrill or CutsceneFx.Thrill(p43.fishId, p43.variant, p43.size)

    t1.Level = v127

    local v128 = ({
        [0] = 0.75,
        0.85, 0.95, 1.12, 1.3
    })[v127] or 1
    local SEABED_Y = GameConfig.SEABED_Y
    local World = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Cliffs")
    local v129 = World and World:FindFirstChild("EndWall")

    World = v129 and v129:FindFirstChild("End")

    local X, Y, v131
    local v130 = p44

    if World and World:IsA("BasePart") then
        v129 = World.Position.Z + World.Size.Z / 2

        if p44.Z < v129 + 170 then
            X = p44.X
            Y = p44.Y
            v131 = v129 + 170
            v130 = new(X, Y, v131)
        end
    end

    local v133 = new(v130.X, SEABED_Y + 2.6, v130.Z)

    t1.Cleanup()
    hideNearbyProps(v133, 13)
    CutsceneFx.Begin(v127, v125)

    local v134 = RevealStage.new(v119, v120)

    v45.Stage = v134
    t1.Stage = v134.Tier
    table.insert(t7, v134.Folder)

    local SkipButton = require(script.Parent.SkipButton)

    local function rushToEnd() -- line: 733
        -- upvalues: SkipButton (copy), t1 (copy), CutsceneFx (copy)
        if CutsceneFx.Rush then
            return
        end

        CutsceneFx.Rush = true
        t1.Rushed = (t1.Rushed or 0) + 1
        SkipButton.Cover(true, 0.12)
    end

    if CutsceneFx.SkipNext then
        CutsceneFx.SkipNext = false

        if not CutsceneFx.Rush then
            CutsceneFx.Rush = true
            t1.Rushed = (t1.Rushed or 0) + 1
            SkipButton.Cover(true, 0.12)
        end
    else
        SkipButton.Show("reveal", rushToEnd)
    end

    local Model = Instance.new("Model")

    Model.Name = "Bait"

    local function bp(p45, p46, p47, p48) -- line: 752
        -- upvalues: v133 (copy), Model (copy)
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.Size = p45
        Part.CFrame = CFrame.new(v133 + p46)
        Part.Color = p47

        if p48 then
            Part.Material = Enum.Material.Neon
        else
            Part.Material = Enum.Material.SmoothPlastic
        end

        Part:SetAttribute("NoStuds", true)
        Part.Parent = Model

        return Part
    end

    v131 = new(0.1, GameConfig.WATER_Y - v133.Y, 0.1)

    local v136 = new(0, (GameConfig.WATER_Y - v133.Y) / 2 + 0.9, 0)
    local v135 = fromRGB(255, 255, 255)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Size = v131
    Part.CFrame = CFrame.new(v133 + v136)
    Part.Color = v135
    Part.Material = Enum.Material.Neon
    Part:SetAttribute("NoStuds", true)
    Part.Parent = Model
    Part.Transparency = 0.4
    bp(Vector3.new(0.22, 1.1, 0.22), Vector3.new(0, 0.45, 0), fromRGB(200, 205, 215))
    bp(Vector3.new(0.22, 0.22, 0.7), Vector3.new(0, -0.1, -0.24), fromRGB(200, 205, 215))
    bp(Vector3.new(0.22, 0.5, 0.22), Vector3.new(0, 0.1, -0.5), fromRGB(200, 205, 215))
    v131 = bp(Vector3.new(0.5, 1, 0.5), Vector3.new(0, -0.35, 0), fromRGB(255, 140, 165))
    v136 = bp(Vector3.new(0.5, 0.5, 0.9), Vector3.new(0, -0.85, 0.25), fromRGB(255, 120, 150))
    v135 = ReplicatedStorage:FindFirstChild("Assets")
    v135 = v135 and v135:FindFirstChild("Baits")

    local v137

    if v135 then
        v137 = DataClient.Get
        v135 = v135:FindFirstChild((tostring(v137("EquippedBait"))))
    end

    local v138

    if v135 then
        v131.Transparency = 1
        v136.Transparency = 1
        v135 = v135:Clone()

        for _, descendant in ipairs(v135:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CastShadow = false
                v138 = descendant.MaterialVariant

                if string.sub(v138, 1, 4) == "Stud" then
                    descendant.MaterialVariant = ""
                end
            end
        end

        v135:ScaleTo(v135:GetScale() * 0.5)
        v135:PivotTo(CFrame.new(v133 + Vector3.new(0, -0.6, 0.05)) * CFrame.Angles(0, 1.5707963267948966, 0))
        v135.Parent = Model
    end

    local PointLight = Instance.new("PointLight")

    PointLight.Range = 46
    PointLight.Brightness = 1.6
    PointLight.Color = fromRGB(255, 250, 235)
    PointLight.Parent = v131
    Model.Parent = workspace
    table.insert(t7, Model)
    t8 = {
        Lighting.FogStart,
        Lighting.FogEnd,
        Lighting.FogColor
    }
    X = require(game:GetService("ReplicatedStorage").Shared.Data.Zones).List[p43.zoneIndex]

    local v139, v140

    if X and X.world and X.world.fog then
        local v141 = X.world.fog:Lerp(Color3.new(0, 0, 0), 0.3)

        if v141 then
            v139 = v141
            v140 = true
        else
            v140 = false
        end
    else
        v140 = false
    end

    if not v140 then
        v139 = t3[p43.zoneIndex] or t3[1]
    end

    Lighting.FogColor = DeepSea.DeepColor(v139)
    Lighting.FogStart = 30
    Lighting.FogEnd = 300
    DeepSea.Begin(v133, v139)

    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Name = "RevealTint"
    ColorCorrectionEffect.TintColor = fromRGB(228, 238, 255)
    ColorCorrectionEffect.Parent = Lighting
    table.insert(t7, ColorCorrectionEffect)
    v7.Enabled = true
    v24.Visible = false
    v8.Visible = false
    v21.Visible = false
    v10.Visible = false
    v16.Visible = false
    v17.Visible = false
    v9.Visible = false
    v18.Visible = false

    local ForceIntro2 = t1.ForceIntro

    if not ForceIntro2 then
        local t26 = {}

        for _, v143 in ipairs(t10) do
            if not Settings or Settings["Cut_" .. v143] ~= false then
                table.insert(t26, v143)
            end
        end

        if #t26 == 0 then
            t26 = t10
        end

        v137 = if #t26 > 1 then ForceIntro else nil

        local n5 = 0

        for _, v144 in ipairs(t26) do
            if v144 ~= v137 then
                n5 += t11[v144] or 1
            end
        end

        local v145 = math.random() * n5
        local v146 = ForceIntro2

        for _, v147 in ipairs(t26) do
            if v147 ~= v137 then
                v145 -= t11[v147] or 1

                if v145 <= 0 then
                    ForceIntro2 = v147
                    break
                end

                v146 = v147
            end

            ForceIntro2 = v146
        end
    end

    Settings = t1.ForceLegend or Roll.legend(p43.fishId)

    if Settings > 0 and (t1.ForceIntro == nil or t1.ForceLegend) then
        ForceIntro2 = "legend"
    end

    if p43.zoneId == "candy_cove" and ForceIntro2 ~= "legend" and t1.ForceIntro == nil then
        ForceIntro2 = "bobber"
    end

    ForceIntro = ForceIntro2
    t1.Intro = ForceIntro2

    if not v125 then
        CutsceneFx.IntroBegin(ForceIntro2, v127)
    end

    v138 = if n4 == 2 then 0.6 else 0

    local v148 = (v138 + 5) / 1 * v128
    local v149 = fromRGB(0, 0, 0)
    local v150 = FishModels.Base(p43.fishId)
    local v151 = false

    task.spawn(function() -- line: 887
        -- upvalues: p43 (copy), v150 (copy), v151 (ref), FishModels (copy)
        local v152 = v150
        local v153 = v150

        if not v150 then
            v152 = FishModels.Base(p43.fishId)
            v153 = v152
        end

        local elapsed = os.clock()

        while not v152 and os.clock() - elapsed < 8 do
            task.wait(0.1)
            v152 = FishModels.Base(p43.fishId)
            v153 = v152
        end

        if v152 then
            local function v154() -- line: 895
                -- upvalues: v153 (ref)
                game:GetService("ContentProvider"):PreloadAsync({
                    v153
                })
            end

            pcall(v154)
        end

        v151 = true
    end)

    local v155

    if v150 then
        local v156 = v150:GetAttribute("SizeX") or 1
        local v157 = v150:GetAttribute("SizeY") or 1

        v155 = v150:GetAttribute("SizeZ") or 6
        v138 = math.max(v156, v157, v155) * v121.scale
    else
        v138 = 6
    end

    local n6 = 0

    local function mood(p49) -- line: 908
        -- upvalues: n3 (ref), v127 (copy), v148 (copy), n6 (ref), UIKit (copy), t1 (copy), CutsceneFx (copy), t2 (copy), t4 (ref)
        local v159 = math.sin(p49 * (if n3 == 0 then 5 else 9)) * 0.5 + 0.5

        for _, v160 in ipairs(t4) do
            v160.BackgroundTransparency = (n3 == 0 and 0.2 or 0.28) + v159 * 0.1
        end

        if n6 <= p49 then
            n6 = p49 + 0.3

            local v161 = 1 * (t2[t1.Intro] or 1)

            UIKit.sound("PovPulse", v161)
        end

        local v162, Bend, v163, v164

        if v127 >= 3 and not CutsceneFx.Struck then
            v162 = math.clamp(p49 / math.max(v148, 0.1), 0, 1)
            Bend = CutsceneFx.Bend
            v163 = v162 ^ 1.6 * 0.8 + 0.85
            v164 = if v127 >= 4 then 0.8 else 0.55
            Bend("Heartbeat", v163, v164 + v162 * 0.35)
        end
    end

    local function underwaterLook(p50) -- line: 923
        -- upvalues: v139 (ref), ColorCorrectionEffect (copy), Lighting (copy), DeepSea (copy), t8 (ref)
        if p50 then
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
        elseif t8 then
            local v166 = t8[1]
            local v167 = t8[2]
            local v168 = t8[3]

            Lighting.FogStart = v166
            Lighting.FogEnd = v167
            Lighting.FogColor = v168
        end

        ColorCorrectionEffect.Enabled = p50
    end

    local function shadowFish(p51, p52) -- line: 934
        -- upvalues: p43 (copy), v121 (copy), FishModels (copy), fromRGB (copy), CutsceneFx (copy), t7 (copy)
        local v169 = FishModels.Take(p43.fishId, 1, 1)
        local v170 = CutsceneFx.Shade(v169, fromRGB(5, 9, 16))

        for _, descendant in ipairs(v169:GetDescendants()) do
            if descendant:IsA("BasePart") then
                if descendant.Transparency < 1 then
                    descendant.Transparency = 0
                end

                if not descendant:IsA("UnionOperation") then
                    descendant.Color = fromRGB(5, 9, 16)
                    descendant.Material = Enum.Material.SmoothPlastic
                    descendant.MaterialVariant = ""
                    descendant.Reflectance = 0
                end

                descendant.CastShadow = false
            elseif descendant:IsA("Texture")
                or descendant:IsA("Decal")
                or descendant:IsA("ParticleEmitter")
                or descendant:IsA("Light")
                or descendant:IsA("Beam")
                or descendant:IsA("Trail") then
                descendant:Destroy()
            end
        end

        local v171 = math.max(v169:GetAttribute("Length"), v169:GetAttribute("Height"), v169:GetAttribute("Width"))
        local v173 = math.clamp(v171 * v121.scale, p51, p52)

        v169:ScaleTo(v169:GetScale() * v173 / v171)
        v169:PivotTo(CFrame.new())

        local _, BoundingBox = v169:GetBoundingBox()
        local v174 = FishModels.CenterOffset(v169)

        v169.Parent = workspace
        table.insert(t7, v169)

        return v169, BoundingBox, function(p53, p54) -- place | line: 963
            -- upvalues: v169 (copy), v174 (copy)
            v169:PivotTo(CFrame.lookAt(p53, p53 + p54) * CFrame.new(-v174))
        end, v170
    end

    local function mysteryMark(p55, p56, p57) -- line: 968
        -- upvalues: n3 (ref), v149 (copy), v123 (copy), v1 (copy), fromRGB (copy), new (copy)
        local BillboardGui = Instance.new("BillboardGui")

        BillboardGui.Name = "Mystery"
        BillboardGui.Size = UDim2.fromScale(p56, p56)
        BillboardGui.StudsOffsetWorldSpace = new(0, p57, 0)
        BillboardGui.AlwaysOnTop = false
        BillboardGui.LightInfluence = 0
        BillboardGui.Adornee = p55

        local TextLabel = Instance.new("TextLabel")

        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.fromScale(1, 1)
        TextLabel.Text = "?"
        TextLabel.TextScaled = true
        TextLabel.FontFace = v1

        if n3 == 0 then
            TextLabel.TextColor3 = fromRGB(255, 255, 255)
        else
            TextLabel.TextColor3 = v123:Lerp(fromRGB(255, 255, 255), 0.35)
        end

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 4
        UIStroke.Color = v149
        UIStroke.Parent = TextLabel
        TextLabel.Parent = BillboardGui
        BillboardGui.Parent = p55

        return BillboardGui, TextLabel
    end

    local function ringAt(p58, p59) -- line: 991
        -- upvalues: Debris (copy), GameConfig (copy), UIKit (copy), fromRGB (copy), new (copy)
        local Part = Instance.new("Part")

        Part.Shape = Enum.PartType.Cylinder
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.Material = Enum.Material.SmoothPlastic
        Part.Color = fromRGB(255, 255, 255)
        Part.Transparency = 0.35
        Part.Size = Vector3.new(0.12, 2, 2)
        Part.CFrame = CFrame.new(p58.X, GameConfig.WATER_Y + 0.12, p58.Z) * CFrame.Angles(0, 0, 1.5707963267948966)
        Part.Parent = workspace
        UIKit.tween(Part, 0.9, {
            Transparency = 1,
            Size = new(0.12, p59, p59)
        })
        Debris:AddItem(Part, 1)
    end

    local function floatAt(p60, p61) -- line: 1007
        -- upvalues: fromRGB (copy), new (copy), t7 (copy)
        local Model = Instance.new("Model")

        Model.Name = "RevealBobber"

        local function ball(p62, p63, p64) -- line: 1010
            -- upvalues: p60 (copy), Model (copy), new (copy)
            local Part = Instance.new("Part")

            Part.Shape = Enum.PartType.Ball
            Part.Size = new(p62, p62, p62)
            Part.CFrame = CFrame.new(p60 + new(0, p63, 0))
            Part.Color = p64
            Part.Material = Enum.Material.SmoothPlastic
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.Parent = Model

            return Part
        end

        local v175 = fromRGB(235, 60, 60)
        local Part = Instance.new("Part")

        Part.Shape = Enum.PartType.Ball
        Part.Size = Vector3.new(1.7, 1.7, 1.7)
        Part.CFrame = CFrame.new(p60 + Vector3.new(0, 0.3, 0))
        Part.Color = v175
        Part.Material = Enum.Material.SmoothPlastic
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.Parent = Model

        local v176 = fromRGB(250, 250, 250)
        local Part2 = Instance.new("Part")

        Part2.Shape = Enum.PartType.Ball
        Part2.Size = Vector3.new(1.7, 1.7, 1.7)
        Part2.CFrame = CFrame.new(p60 + Vector3.new(0, -0.3, 0))
        Part2.Color = v176
        Part2.Material = Enum.Material.SmoothPlastic
        Part2.Anchored = true
        Part2.CanCollide = false
        Part2.CanQuery = false
        Part2.Parent = Model

        local v177 = fromRGB(250, 250, 250)
        local Part3 = Instance.new("Part")

        Part3.Shape = Enum.PartType.Ball
        Part3.Size = Vector3.new(0.5, 0.5, 0.5)
        Part3.CFrame = CFrame.new(p60 + Vector3.new(0, 1.25, 0))
        Part3.Color = v177
        Part3.Material = Enum.Material.SmoothPlastic
        Part3.Anchored = true
        Part3.CanCollide = false
        Part3.CanQuery = false
        Part3.Parent = Model
        Model.Parent = workspace
        Model:ScaleTo(p61)
        table.insert(t7, Model)

        return Model, Part
    end

    local function clearSea(p65) -- line: 1031
        -- upvalues: t9 (copy)
        local t27 = {}
        local v178 = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Lane")
        local _ipairs = ipairs
        local v179 = if v178 then v178:GetDescendants() else {}

        for _, v180 in _ipairs(v179) do
            if v180:IsA("BasePart") and v180.Name == "Water" and math.abs(v180.Position.Z - p65) < v180.Size.Z / 2 + 40 then
                v180.LocalTransparencyModifier = 0.6
                table.insert(t27, v180)
                table.insert(t9, v180)
            end
        end

        return t27
    end

    local function addEyes(p66) -- line: 1044
        -- upvalues: n3 (ref), v123 (copy), UIKit (copy), fromRGB (copy), new (copy), CutsceneFx (copy)
        local v182 = if n3 == 0 then fromRGB(255, 240, 130) else v123:Lerp(fromRGB(255, 255, 255), 0.3)
        local t28 = {}

        for _, descendant in ipairs(p66:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Transparency < 1 and descendant:GetAttribute("Eye") then
                table.insert(t28, descendant)
            end
        end

        if #t28 == 0 then
            local BoundingBox, BoundingBox2 = p66:GetBoundingBox()
            local v184 = math.clamp(math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z) * 0.045, 0.4, 7)

            for _, v185 in ipairs({ -1, 1 }) do
                local Part = Instance.new("Part")

                Part.Shape = Enum.PartType.Ball
                Part.Size = new(v184, v184, v184)
                Part.CFrame = BoundingBox * CFrame.new(v185 * BoundingBox2.X * 0.22, BoundingBox2.Y * 0.12, -BoundingBox2.Z * 0.46)
                Part.CanCollide = false
                Part.CanQuery = false
                Part.Massless = true

                local WeldConstraint = Instance.new("WeldConstraint")

                WeldConstraint.Part0 = p66.PrimaryPart
                WeldConstraint.Part1 = Part
                WeldConstraint.Parent = Part
                Part.Parent = p66
                table.insert(t28, Part)
            end
        end

        for v186, v187 in ipairs(t28) do
            local v188 = CutsceneFx.EyeLight(v187, v182)

            t28[v186] = v188

            if v186 <= 6 then
                local BillboardGui = Instance.new("BillboardGui")
                local v189 = math.max(v188.Size.X, v188.Size.Y, v188.Size.Z) * 4

                BillboardGui.Size = UDim2.fromScale(v189, v189)
                BillboardGui.LightInfluence = 0
                BillboardGui.Adornee = v188

                local ImageLabel = Instance.new("ImageLabel")

                ImageLabel.BackgroundTransparency = 1
                ImageLabel.Size = UDim2.fromScale(1, 1)
                ImageLabel.Image = UIKit.Art.Glow
                ImageLabel.ImageColor3 = v182
                ImageLabel.ImageTransparency = 0.35
                ImageLabel.Parent = BillboardGui
                BillboardGui.Parent = v188
            end
        end

        return t28
    end

    local v190 = if n3 == 0 then fromRGB(255, 255, 255) else v123
    local n7 = -10

    local function jolt(p67, p68, p69, _) -- line: 1095
        -- upvalues: n7 (ref), UIKit (copy), t1 (copy), CutsceneFx (copy), t2 (copy)
        n7 = p67
        CutsceneFx.Shake(p68 * 1.25, 0.35)
        CutsceneFx.Haptic(2)

        local v191 = (p69 or 1.2 or 1) * (t2[t1.Intro] or 1)

        UIKit.sound("CastRelease", v191)

        local v192 = 0.6 * (t2[t1.Intro] or 1)

        UIKit.sound("PovPulse", v192)
    end

    local function punch(p71) -- line: 1102
        -- upvalues: n7 (ref)
        return (math.max(0, 1 - (p71 - n7) * 2.5))
    end

    local function bumpAt(p72, p73, p74) -- line: 1105
        local v195 = math.abs(p72 - p73) / p74

        if not (v195 < 1) then
            return 0
        end

        return math.cos(v195 * 3.141592653589793 / 2) ^ 2
    end

    setVignette(v123, n3 == 0 and 0.8 or 0.7, 0)

    local X2, Y2, v197, v198, v199, v200, Part2, v201, v202, v203, v204, v205, v206, v207, v208, v209, v210, v211, v212, v213, v214, v215, v216, v217, Unit, v218, v219, v220, v221, v222, v223
    local v142

    if v125 then
        t1.Intro = "skipped"
        ScreenFx.Fade(1, 0, v149)
        Lighting.FogColor = DeepSea.DeepColor(v139)
        Lighting.FogStart = 30
        Lighting.FogEnd = 300
        v142 = true
        ColorCorrectionEffect.Enabled = true
    else
        if ForceIntro2 == "legend" then
            v203 = #t12

            local v224 = math.clamp(Settings, 1, v203)
            local v225 = t12[v224]
            local dur, c1, c2 = v225.dur, v225.c1, v225.c2
            local WATER_Y = GameConfig.WATER_Y
            local v227 = new(v133.X, WATER_Y + 0.55, v133.Z)
            local v228, v229, v230 = shadowFish(8, 260)

            X2 = v229.X
            Y2 = v229.Y
            v223 = v229.Z

            local v231 = math.max(X2, Y2, v223)

            addEyes(v228)
            hideNearbyProps(v133, v231 * 0.4 + 30)
            Y2 = v231 / 30

            local v232 = math.clamp(Y2, 1, 5)
            local v233 = floatAt(v227, v232)
            local Pivot = v233:GetPivot()

            v197 = clearSea(v227.Z)
            v199 = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Lane")

            local t29 = {}

            v216 = ipairs

            if v199 then
                v207 = v199:GetDescendants()
            else
                v207 = {}
            end

            for _, v234 in v216(v207) do
                if v234:IsA("BasePart") and v234.Name:match("^Deep%d") then
                    Part2 = v234.Position.Z - v227.Z

                    if math.abs(Part2) < v234.Size.Z / 2 + 300 then
                        v234.LocalTransparencyModifier = 1
                        table.insert(t9, v234)
                        table.insert(t29, v234)
                    end
                end
            end

            local v235 = WATER_Y - 40 - v231 * 0.75

            v200 = v231 * 0.5 + 40

            local v236 = math.min(150, v200)

            hideNearbyProps(v133, v236 + 24)

            local function glowPart(p75, p76, p77) -- line: 1151
                -- upvalues: t7 (copy)
                local Part = Instance.new("Part")

                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                Part.Material = Enum.Material.Neon
                Part.Color = p76
                Part.Transparency = p77
                Part.Size = p75
                Part.Parent = workspace
                table.insert(t7, Part)

                return Part
            end

            v200 = WATER_Y - v235 + 80
            v217 = v231 * 0.25 + 10
            v201 = new(v200, v217, v217)

            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Material = Enum.Material.Neon
            Part.Color = c1
            Part.Transparency = 0.9
            Part.Size = v201
            Part.Parent = workspace
            table.insert(t7, Part)
            Part.Shape = Enum.PartType.Cylinder
            Part.CFrame = CFrame.new(v133.X, WATER_Y - v200 / 2, v133.Z) * CFrame.Angles(0, 0, 1.5707963267948966)

            local t30 = {}

            for i = 1, 5 do
                v208 = Instance.new("Part")
                v208.Anchored = true
                v208.CanCollide = false
                v208.CanQuery = false
                v208.CanTouch = false
                v208.CastShadow = false
                v208.Material = Enum.Material.Neon
                v208.Color = c2
                v208.Transparency = 0.86
                v208.Size = Vector3.new(2, 2, 10)
                v208.Parent = workspace
                table.insert(t7, v208)
                t30[i] = v208
            end

            Part2 = v231 * 0.5 + 10
            v208 = v231 * 0.6 + 10
            v201 = new(Part2, 1, v208)
            Part2 = Instance.new("Part")
            Part2.Anchored = true
            Part2.CanCollide = false
            Part2.CanQuery = false
            Part2.CanTouch = false
            Part2.CastShadow = false
            Part2.Material = Enum.Material.Neon
            Part2.Color = c1
            Part2.Transparency = 1
            Part2.Size = v201
            Part2.Parent = workspace
            table.insert(t7, Part2)
            Part2.CFrame = CFrame.new(v133.X, v235 - 12, v133.Z)

            local ParticleEmitter = Instance.new("ParticleEmitter")

            v201 = math.clamp(v231 / 40, 1, 4)
            ParticleEmitter.Texture = UIKit.Art.Glow
            ParticleEmitter.Color = ColorSequence.new(c1, c2)
            ParticleEmitter.LightEmission = 1
            ParticleEmitter.LightInfluence = 0

            local new2 = NumberSequence.new

            v208 = NumberSequenceKeypoint.new(0, 0)
            v220 = NumberSequenceKeypoint.new(0.2, v201 * 2.2)
            v218 = NumberSequenceKeypoint.new
            ParticleEmitter.Size = new2({
                v208,
                v220,
                v218(1, 0)
            })
            ParticleEmitter.Transparency = NumberSequence.new(0.15, 1)
            ParticleEmitter.Speed = NumberRange.new(14, 30)
            ParticleEmitter.Lifetime = NumberRange.new(5, 8)
            ParticleEmitter.Acceleration = Vector3.new(0, 3, 0)
            ParticleEmitter.SpreadAngle = Vector2.new(12, 12)
            ParticleEmitter.EmissionDirection = Enum.NormalId.Top
            ParticleEmitter.Rate = 25
            ParticleEmitter.Parent = Part2

            local TextLabel = Instance.new("TextLabel")

            TextLabel.BackgroundTransparency = 1
            TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel.Position = UDim2.fromScale(0.5, 0.24)
            TextLabel.Size = UDim2.fromScale(0.86, 0.085)
            TextLabel.FontFace = v3
            TextLabel.TextScaled = true
            TextLabel.TextColor3 = v225.ink
            TextLabel.TextTransparency = 1
            TextLabel.Text = ""
            TextLabel.ZIndex = 20

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Thickness = 3
            UIStroke.Color = v149
            UIStroke.Transparency = 1
            UIStroke.Parent = TextLabel
            TextLabel.Parent = v7
            table.insert(t7, TextLabel)

            local ColorCorrectionEffect2

            if v224 >= 5 then
                local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

                ColorCorrectionEffect2 = ColorCorrectionEffect
                ColorCorrectionEffect.Name = "LegendGlitch"
                ColorCorrectionEffect.Enabled = false
                ColorCorrectionEffect.Parent = Lighting
                table.insert(t7, ColorCorrectionEffect)
            end

            local v237 = #v225.text
            local v238 = 0.84 / v237
            local n8 = 0
            local n9 = 0
            local n10 = 0
            local n11 = 0
            local n12 = 0
            local n13 = 0
            local v239 = false
            local n14 = 0
            local n15 = 0
            local n16 = 0
            local t31 = {}

            t31[1] = nil

            local v240 = false

            CutsceneFx.Grade(c1, 0.3, 1.2)
            CutsceneFx.Duck(dur + 2)
            CutsceneFx.Hold("Heartbeat", 0.75)
            CutsceneFx.Bend("Heartbeat", 0.75, 0.5)

            local v241 = v139

            local function frame(p78, p79) -- line: 1233
                -- upvalues: v133 (copy), ColorCorrectionEffect (copy), v149 (copy), ringAt (copy), v224 (copy), v225 (copy), dur (copy), c1 (copy), c2 (copy), WATER_Y (copy), v227 (copy), v228 (copy), v229 (copy), v230 (copy), v231 (copy), v232 (copy), v233 (copy), Pivot (copy), v235 (copy), v236 (copy), Part (copy), t30 (copy), ParticleEmitter (copy), TextLabel (copy), UIStroke (copy), ColorCorrectionEffect2 (ref), v237 (copy), v238 (copy), n8 (ref), n9 (ref), n10 (ref), n11 (ref), n12 (ref), n13 (ref), v239 (ref), n14 (ref), n15 (ref), n16 (ref), t31 (copy), v240 (ref), v241 (copy), Lighting (copy), FishModels (copy), UIKit (copy), ScreenFx (copy), DeepSea (copy), CurrentCamera (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy)
                local v242 = p79 - n15

                n15 = p79

                local v243 = p78 / v238
                local v244 = math.floor(v243) + 1
                local v245

                if v244 <= v237 and v244 ~= n9 then
                    n9 = v244
                    TextLabel.Text = v225.text[v244]
                    TextLabel.TextTransparency = 1
                    UIStroke.Transparency = 1
                    v245 = 1.05 - (v244 - 1) * 0.09 - v224 * 0.04
                    UIKit.sound("OmenHit", v245)

                    if v244 == v237 then
                        UIKit.sound("SubBoom", 1.2)
                    end

                    UIKit.tween(TextLabel, 0.6, {
                        TextTransparency = 0.05
                    })
                    UIKit.tween(UIStroke, 0.6, {
                        Transparency = 0.2
                    })
                end

                if n9 > n10 and (p78 - (n9 - 1) * v238) / v238 > 0.84 then
                    n10 = n9
                    UIKit.tween(TextLabel, 0.35, {
                        TextTransparency = 1
                    })
                    UIKit.tween(UIStroke, 0.35, {
                        Transparency = 1
                    })
                end

                local v246

                if n11 <= p79 then
                    v243 = p79 + 0.95
                    v246 = (p78 - 0.2) / 0.66
                    n11 = v243 - math.clamp(v246, 0, 1) * 0.7
                    v245 = (0.6 + 0.5 * p78 or 1) * (t2[t1.Intro] or 1)
                    UIKit.sound("PovPulse", v245)
                end

                if not t31[1] then
                    v245 = (p78 - 0.1) / 0.76
                    v244 = math.clamp(v245, 0, 1)
                    CutsceneFx.Bend("Heartbeat", v244 ^ 1.5 * 1.05 + 0.75, v244 * 0.6 + 0.5)
                end

                local v247, v248, v249, v250, Z, v251, v252, v253, v254

                for v255, v256 in ipairs(t30) do
                    v247 = v255 / #t30 * 2 * 3.141592653589793 + p79 * 0.08
                    v249 = v133.X + math.cos(v247) * 50
                    v253 = math.clamp(v249, -54, 54)
                    v249 = WATER_Y - 2
                    v250 = v133.Z + math.sin(v247) * v236 * 0.8
                    v248 = new(v253, v249, v250)
                    v250 = v133.X
                    v254 = v247 + 0.6
                    v249 = v250 + math.cos(v254) * 10
                    v250 = v235 - 20
                    Z = v133.Z
                    v251 = v247 + 0.6
                    v252 = Z + math.sin(v251) * v236 * 0.25
                    v253 = new(v249, v250, v252)
                    v250 = v231 * 0.008 + 1
                    v252 = v231 * 0.008 + 1
                    Z = (v248 - v253).Magnitude
                    v256.Size = new(v250, v252, Z)
                    v256.CFrame = CFrame.lookAt((v248 + v253) / 2, v253)
                end

                if p78 < 0.22 then
                    v245 = p78 / 0.22
                    v243 = 0.5 + v245 * 0.8

                    local v257 = v231 * 0.1 + 18

                    v253 = math.sin(v243) * v236
                    v248 = math.clamp(v253, -44, 44)
                    v253 = v257 * (1 - 0.35 * v245)
                    v249 = math.cos(v243) * v236

                    local v258 = v227 + new(v248, v253, v249)

                    CurrentCamera.CFrame = CFrame.lookAt(v258, v227 + Vector3.new(0, -1, 0))
                    CurrentCamera.FieldOfView = 70
                    v258 = 0.3 + v245
                    v250 = CFrame.new
                    v253 = Pivot * v250(0, math.sin(p79 * 3) * 0.08 * v232, 0)
                    v249 = CFrame.Angles
                    v254 = p79 * 31
                    v250 = math.sin(v254) * 0.05 * v258
                    v233:PivotTo(v253 * v249(v250, 0, math.sin(p79 * 27) * 0.05 * v258))

                    if n12 <= p79 then
                        n12 = p79 + 0.75
                        ringAt(v227, (14 + 26 * v245) * v232)
                    end

                    if n8 ~= 0 or not (p78 >= 0.055) then
                        if n8 == 1 and p78 >= 0.154 then
                            n8 = 2
                            ScreenFx.Flash(0.22)
                            UIKit.sound("Thunder", 0.85)
                            CutsceneFx.Shake(1, 0.6)
                            CutsceneFx.Haptic(2)
                        end
                    else
                        n8 = 1
                        ScreenFx.Flash(0.18)
                        UIKit.sound("Thunder", 1)
                        CutsceneFx.Shake(0.7, 0.5)
                        CutsceneFx.Haptic(2)
                    end

                    v230(new(v133.X, v235, v133.Z), (Vector3.new(0, 0, 1)))
                else
                    local v260

                    if n8 < 3 then
                        n8 = 3
                        Lighting.FogColor = DeepSea.DeepColor(v241)
                        Lighting.FogStart = 30
                        Lighting.FogEnd = 300
                        ColorCorrectionEffect.Enabled = true
                        Lighting.FogStart = 120
                        Lighting.FogEnd = v231 * 2 + 900
                        Lighting.FogColor = c1:Lerp(v149, 0.82)
                        v233:PivotTo(Pivot * CFrame.new(0, -900, 0))
                        UIKit.sound("DeepWhoosh", 0.8)
                        UIKit.sound("DeepRumble", 0.7)
                        CutsceneFx.Hold("WaterSurge", 0.85)
                        UIKit.sound("SubBoom", 0.95)
                        CutsceneFx.Shake(1.2, 0.5)

                        if v224 == 2 then
                            UIKit.sound("StingChoir", 0.8)
                        elseif v224 >= 4 then
                            v260 = v224 >= 5 and 0.8 or 0.9
                            UIKit.sound("BraamCosmic", v260)
                        end
                    end

                    v243 = (p78 - 0.22) / 0.30000000000000004
                    v260 = math.clamp(v243, 0, 1)
                    v243 = math.clamp((p78 - 0.52) / 0.33999999999999997, 0, 1)

                    local v261 = math.clamp((p78 - 0.86) / 0.14, 0, 1)
                    local Hold, v263, v264

                    if v243 > 0 and not v240 then
                        v240 = true
                        Hold = CutsceneFx.Hold
                        v263 = (0.86 - p78) * dur
                        v264 = if v224 == 4 then 1.2 else 0
                        Hold("TensionRiser", 1, v263 + v264)
                        CutsceneFx.Release("WaterSurge", 2)
                    end

                    v246 = v243 ^ 2 * 0.3 + 0.14
                    v247 = if v224 == 3 then v243 ^ 2 * 1.5 else 0
                    Hold = v246 + v247

                    local v265 = n14

                    n14 = v265 + v242 * Hold
                    Hold = WATER_Y - 12 - v260 * 18 - v243 * 10
                    v263 = v133.X
                    v252 = n14
                    v248 = v263 + math.sin(v252) * 44
                    v247 = math.clamp(v248, -50, 50)
                    v264 = v133.Z
                    v254 = n14
                    v246 = new(v247, Hold, v264 + math.cos(v254) * v236 * (v243 * 0.15 + 1))
                    v247 = v243 ^ 1.7
                    v264 = v133.X
                    Z = p79 * 0.21
                    v263 = v264 + math.sin(Z) * 6
                    v250 = v235 + (Hold - 8 - v229.Y * 0.3 - v235) * v247
                    v264 = v250 + math.sin(p79 * 0.4) * 5 * (1 - v247)
                    v252 = v133.Z
                    v251 = p79 * 0.17
                    v250 = v252 + math.sin(v251) * v231 * 0.12 * (1 - v247)
                    v248 = new(v263, v264, v250)
                    v252 = p79 * 0.3
                    v247 = new(math.sin(v252) * 0.5, 0, 1).Unit
                    Hold = v246 - v248
                    v263 = math.clamp((v243 - 0.45) / 0.45, 0, 1)
                    v264 = v247:Lerp(Hold.Unit, v263)

                    if v264.Magnitude < 0.1 then
                        v264 = Hold.Unit
                    end

                    local v267, v268

                    if v261 > 0 then
                        if not t31[1] then
                            t31[1] = v248
                            CutsceneFx.HitStop(0.25)
                            ScreenFx.Flash(0.3)
                            CutsceneFx.Release("Heartbeat", 0.05)
                            CutsceneFx.Release("TensionRiser", 0.1)
                            UIKit.sound("StingChoir", 0.7)
                            UIKit.sound("Thunder", 0.7)
                            UIKit.sound("DeepRumble", 0.6)
                            v250 = 1 - v224 * 0.05
                            UIKit.sound("Braam", v250)
                            UIKit.sound("SubBoom", 0.8)
                            v250 = 0.6 - v224 * 0.03
                            UIKit.sound("DeepRoar", v250)
                            UIKit.sound("SonicBoom", 0.9)
                            CutsceneFx.Shake(2.4, 1.4)
                            CutsceneFx.Haptic(3)

                            if v224 >= 5 then
                                CutsceneFx.Drain(0.6)
                            else
                                CutsceneFx.Grade(c2, 0.6, 0.4)
                            end
                        end

                        v263 = v246 + (t31[1] - v246).Unit * (v231 * 0.3 + 4)
                        v267 = t31[1]:Lerp(v263, v261 ^ 2.2)
                        v268 = (v246 - v267).Unit
                    else
                        v268 = v264
                        v267 = v248
                    end

                    v230(v267, v268)
                    FishModels.Animate(v228, p79, v243 * 9 + 3 + v261 * 14, 0.36)
                    v250 = v133.X
                    v252 = v267.Y
                    Z = v133.Z
                    v268 = new(v250, v252, Z):Lerp(v267, v243 * 0.45 + 0.55)
                    v250 = CFrame.lookAt(v246, v268)

                    local Angles

                    if v224 >= 3 then
                        Angles = CFrame.Angles
                        v251 = p79 * 0.8
                        v250 *= Angles(0, 0, math.sin(v251) * 0.08 * v243)
                    end

                    local v269
                    local v270 = v250

                    if ColorCorrectionEffect2 then
                        local v271 = v260 > 0.4 and math.random() < v243 * 0.2 + 0.03 + v261 * 0.3

                        if v271 and not ColorCorrectionEffect2.Enabled then
                            Angles = 0.6 + math.random() * 0.9
                            UIKit.sound("Zap", Angles)
                        end

                        Angles = ColorCorrectionEffect2
                        Angles.Enabled = v271

                        if v271 then
                            v269 = ColorCorrectionEffect2
                            v269.Saturation = -1
                            v269 = ColorCorrectionEffect2
                            v269.Contrast = 0.4 + math.random() * 0.6
                            v269 = ColorCorrectionEffect2

                            if math.random() < 0.5 then
                                v269.TintColor = c1
                            else
                                v269.TintColor = c2
                            end

                            v270 = v250 * CFrame.new((math.random() - 0.5) * 3, (math.random() - 0.5) * 3, 0)
                        end
                    end

                    CurrentCamera.CFrame = v270
                    CurrentCamera.FieldOfView = v243 * 12 + 70 + v261 * 10
                    Part.Transparency = 0.9 - v243 * 0.12 - v261 * 0.2

                    for _, v272 in ipairs(t30) do
                        v272.Transparency = 0.9 - v243 * 0.12
                    end

                    ParticleEmitter.Rate = v243 * 110 + 25

                    if v243 > 0 and v261 == 0 and n13 <= p79 then
                        n13 = p79 + 0.25
                        CutsceneFx.Shake(v243 * 1.1 + 0.15, 0.3)
                    end

                    if v224 == 4 and n16 < 2 and (if n16 == 0 then 0.35 else 0.68) <= v243 then
                        n16 += 1
                        CutsceneFx.HitStop(0.6)
                        UIKit.sound("MeterTick", 0.55)
                        UIKit.sound("WindChime", 0.7)
                        v269 = 0.6 - n16 * 0.08
                        UIKit.sound("EventStart", v269)
                        UIKit.sound("SubBoom", 1.3)
                        ScreenFx.Flash(0.12)
                    end
                end

                if not (p78 >= 0.965) or v239 then
                    return
                end

                v239 = true
                ScreenFx.Fade(1, 0.12, v149)
                CutsceneFx.ReleaseAll(0.12)
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.5)
            run(dur, function(p80, p81) -- line: 1425
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p80, p81)

                if p80 >= 0.6 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            v228:Destroy()
            v233:Destroy()

            for _, v273 in ipairs(v197) do
                v273.LocalTransparencyModifier = 0
            end

            if ColorCorrectionEffect2 then
                ColorCorrectionEffect2:Destroy()
            end

            TextLabel:Destroy()
            Part:Destroy()
            Part2:Destroy()

            for _, v274 in ipairs(t29) do
                v274.LocalTransparencyModifier = 0
            end

            for _, v275 in ipairs(t30) do
                v275:Destroy()
            end

            CutsceneFx.GradeOff(0.2)
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            UIKit.sound("PovStart", nil)
            v142 = true
            task.wait(0.15)
        elseif ForceIntro2 == "rise" then
            if t8 then
                v203 = t8[1]
                v204 = t8[2]

                local v276 = t8[3]

                Lighting.FogStart = v203
                Lighting.FogEnd = v204
                Lighting.FogColor = v276
            end

            ColorCorrectionEffect.Enabled = false
            v202 = v133.X
            v214 = GameConfig.WATER_Y + 0.55
            v203 = v133.Z

            local v277 = new(v202, v214, v203)
            local v278, v279, v280 = shadowFish(5, 260)

            v205 = v279.X
            v221 = v279.Y
            v206 = v279.Z
            v204 = math.max(v205, v221, v206)
            v221 = v279.X
            v206 = v279.Z
            v205 = math.max(v221, v206)
            v206 = v205 / 26

            local v281 = math.clamp(v206, 1, 6)
            local v282

            v282, v215 = floatAt(v277, v281)

            local Pivot = v282:GetPivot()
            local v283, v284 = mysteryMark(v215, 3.2 * v281, 0)

            v199 = -3.4 * v281
            v283.StudsOffsetWorldSpace = new(0, 2, v199)
            v283.Enabled = false
            Y2 = clearSea(v277.Z)
            v223 = v205 * 1.2

            local v285 = math.clamp(v223, 30, 320)
            local v286 = v204 * 1.4 + 80
            local v287 = GameConfig.WATER_Y - 1.5 - v279.Y / 2
            local n17 = 0
            local v288 = false

            local function frame(p82, p83) -- line: 1472
                -- upvalues: v149 (copy), mood (copy), ringAt (copy), v277 (copy), v278 (copy), v279 (copy), v280 (copy), v281 (copy), v282 (ref), Pivot (copy), v283 (copy), v284 (copy), v285 (copy), v286 (copy), v287 (copy), n17 (ref), v288 (ref), FishModels (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy), burst3D (copy)
                local v290 = 1 - (1 - math.min(p82 / 0.84, 1)) ^ 2.2
                local v292 = math.clamp((p82 - 0.88) / 0.08, 0, 1)
                local v293 = v287 - v286 * (1 - v290) + v292 ^ 2 * (v279.Y + 16)
                local v294 = p83 * 0.45

                v280(new(v277.X, v293, v277.Z), (new(math.sin(v294), 0, (math.cos(v294)))))
                FishModels.Animate(v278, p83, v292 * 14 + 6, 0.36)

                local v298 = v292 >= 0.45
                local v300 = math.clamp((p82 - 0.55) / 0.3, 0, 1)
                local v301 = if v298 then Pivot * CFrame.new(0, -900, 0) else Pivot * CFrame.new(0, math.sin(p83 * 3) * 0.06 * v281, 0) * CFrame.Angles(math.sin(p83 * 34) * 0.06 * v300, 0, math.sin(p83 * 29) * 0.06 * v300)

                v282:PivotTo(v301)

                if n17 == 0 and p82 >= 0.4 then
                    n17 = 1
                    v283.Enabled = true
                    ringAt(v277, v281 * 10)

                    local v307 = 1.3 * (t2[t1.Intro] or 1)

                    UIKit.sound("PovPulse", v307)
                elseif n17 ~= 1 or not (p82 >= 0.78) then
                    if n17 == 2 and v298 then
                        n17 = 3
                        v283.Enabled = false
                        ringAt(v277, v281 * 24)
                        ringAt(v277, v281 * 44)
                        burst3D(v277, fromRGB(235, 245, 255), 100)
                        CutsceneFx.Strike(t1.Intro)
                    end
                else
                    n17 = 2
                    v284.Text = "!"
                    v284.TextColor3 = fromRGB(255, 70, 70)

                    local v308 = 0.6 * (t2[t1.Intro] or 1)

                    UIKit.sound("PovPulse", v308)
                end

                local v309 = if n17 == 3 then v285 * 0.03 else 0
                local v315 = v277 + new(math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v309, v285 * (1 - 0.14 * p82), math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v309)

                CurrentCamera.CFrame = CFrame.new(v315) * CFrame.Angles(0, 0.3 * p82, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
                CurrentCamera.FieldOfView = v292 * 10 + 60
                mood(p83)

                if p82 >= 0.955 and not v288 then
                    v288 = true
                    ScreenFx.Fade(1, 0.1, v149)
                end
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.4)
            run(v148, function(p84, p85) -- line: 1513
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p84, p85)

                if p84 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            v278:Destroy()
            v282:Destroy()

            for _, v316 in ipairs(Y2) do
                v316.LocalTransparencyModifier = 0
            end

            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            UIKit.sound("PovStart", nil)
            v142 = true
            task.wait(0.12)
        elseif ForceIntro2 == "eyes" then
            local v317 = v148 * 0.85
            local v318, v319, v320, v321 = shadowFish(4, 260)

            v221 = v319.X

            local v322 = math.max(v221, v319.Y, v319.Z)

            v221 = if n3 == 0 then fromRGB(255, 240, 130) else v123:Lerp(fromRGB(255, 255, 255), 0.3)

            local t32 = {}
            local t33 = {}

            for _, descendant in ipairs(v318:GetDescendants()) do
                if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                    v199 = if descendant:GetAttribute("Eye") then t32 else t33
                    table.insert(v199, descendant)
                end
            end

            if #t32 == 0 then
                v211, v222 = v318:GetBoundingBox()
                Y2 = v322 * 0.045
                X2 = math.clamp(Y2, 0.4, 7)

                for _, v323 in ipairs({ -1, 1 }) do
                    v216 = Instance.new("Part")
                    v216.Shape = Enum.PartType.Ball
                    v216.Size = new(X2, X2, X2)
                    v216.CFrame = v211 * CFrame.new(v323 * v222.X * 0.22, v222.Y * 0.12, -v222.Z * 0.46)
                    v216.CanCollide = false
                    v216.CanQuery = false
                    v216.Massless = true
                    v207 = Instance.new("WeldConstraint")
                    v207.Part0 = v318.PrimaryPart
                    v207.Part1 = v216
                    v207.Parent = v216
                    v216.Parent = v318
                    table.insert(t32, v216)
                end
            end

            for v324, v325 in ipairs(t32) do
                v197 = CutsceneFx.EyeLight(v325, v221)
                t32[v324] = v197

                if v324 <= 6 then
                    v199 = Instance.new("BillboardGui")
                    v207 = v197.Size.X
                    v200 = v197.Size.Y
                    v217 = v197.Size.Z
                    v198 = math.max(v207, v200, v217) * 4
                    v199.Size = UDim2.fromScale(v198, v198)
                    v199.LightInfluence = 0
                    v199.Adornee = v197
                    v198 = Instance.new("ImageLabel")
                    v198.BackgroundTransparency = 1
                    v198.Size = UDim2.fromScale(1, 1)
                    v198.Image = UIKit.Art.Glow
                    v198.ImageColor3 = v221
                    v198.ImageTransparency = 0.35
                    v198.Parent = v199
                    v199.Parent = v197
                end
            end

            local n18 = -1

            local function setBody(p86) -- line: 1580
                -- upvalues: v321 (copy), t33 (copy), n18 (ref)
                local v327 = math.floor(p86 * 10 + 0.5) / 10

                if v327 == n18 then
                    return
                end

                n18 = v327

                for _, v328 in ipairs(t33) do
                    v328.Transparency = v327
                end

                v321.FillTransparency = v327
            end

            local v329 = true

            local function setEyes(p87) -- line: 1591
                -- upvalues: t32 (copy), v329 (ref), CutsceneFx (copy)
                if p87 == v329 then
                    return
                end

                v329 = p87

                for _, v330 in ipairs(t32) do
                    CutsceneFx.EyeShow(v330, p87)

                    local BillboardGui = v330:FindFirstChildOfClass("BillboardGui")

                    if BillboardGui then
                        BillboardGui.Enabled = p87
                    end
                end
            end

            Model.Parent = nil
            ColorCorrectionEffect.Brightness = -0.12

            local v331 = v319.Z * 0.5 + 6

            v199 = v322 * 6
            v198 = v331 + 16
            v200 = v331 + 16
            v216 = math.max(130, v200)

            local v332 = math.clamp(v199, v198, v216)

            v198 = v332 * 1.8
            v216 = v322 * 1.6

            local v333 = math.max(v198, v216)

            v216 = v332 * 0.35

            local v334 = math.clamp(v216, 6, 45)

            v207 = v322 * 0.3

            local v335 = math.min(v207, 80)

            Lighting.FogColor = Lighting.FogColor:Lerp(v149, 0.3)
            Unit = v333 * 3
            Lighting.FogEnd = math.max(340, Unit)

            local v336 = v133 + Vector3.new(0, 0.1, 0)

            v217 = v317 * 0.14
            v207 = math.min(0.3, v217)
            Unit = v317 * 0.18
            v200 = math.min(0.4, Unit)

            local v337 = 1 - v207 / v317
            local v338 = v337 - v200 / v317
            local v339 = false
            local v340 = false
            local v341 = false
            local n19 = 0
            local n20 = 0
            local v342 = v336 + new(0, 0, v333)
            local v343
            local v344 = CFrame.lookAt(v336, v336 + Vector3.new(0, 0, 1))
            local v345 = v221

            local function frame(p88, p89) -- line: 1624
                -- upvalues: v149 (copy), mood (copy), n7 (ref), v318 (copy), v319 (copy), v320 (copy), v321 (copy), t32 (copy), t33 (copy), n18 (ref), setEyes (copy), v331 (copy), v332 (copy), v333 (copy), v334 (copy), v335 (copy), v336 (copy), v337 (copy), v338 (copy), v339 (ref), v340 (ref), v341 (ref), n19 (ref), n20 (ref), v342 (ref), v343 (ref), v344 (ref), v345 (copy), FishModels (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy)
                n20 = 0

                local v346, v347, Unit

                if p88 < v338 then
                    local v348 = p88 / v338
                    local v349 = v348 * v348 * (3 - 2 * v348)
                    local v351 = math.abs(v348 - 0.38) / 0.13
                    local v352 = if v351 < 1 then math.cos(v351 * 3.141592653589793 / 2) ^ 2 else 0
                    local v355 = math.abs(v348 - 0.74) / 0.13
                    local v358 = math.max(v352, if v355 < 1 then math.cos(v355 * 3.141592653589793 / 2) ^ 2 else 0)

                    while true and n19 < 2 and (if n19 == 0 then 0.3 else 0.66) <= v348 do
                        n19 += 1

                        local v359 = n19 * 0.4 + 1
                        local v360 = n19 * 0.2 + 0.8

                        n7 = p89
                        CutsceneFx.Shake(v359 * 1.25, 0.35)
                        CutsceneFx.Haptic(2)

                        local v361 = (v360 or 1.2 or 1) * (t2[t1.Intro] or 1)

                        UIKit.sound("CastRelease", v361)

                        local v362 = 0.6 * (t2[t1.Intro] or 1)

                        UIKit.sound("PovPulse", v362)
                    end

                    n20 = v358

                    local v363 = v333 - (v333 - v332) * v349
                    local v364 = v363 - (v363 - v331 * 1.6) * 0.85 * v358

                    v347 = v336 + new(math.sin(p89 * 2.3) * v334 * (1 - v358 * 0.5), -v335 * (1 - v349) ^ 1.6 * (1 - v358) + math.sin(p89 * 1.9) * 1.2, v364)
                    Unit = ((v336 - v347).Unit * (v358 * 2 + 0.45) + new(math.cos(p89 * 2.3), 0, 0)).Unit
                    v346 = 0
                elseif p88 < v337 then
                    if not v341 then
                        v341 = true
                        v343 = v342

                        local v373 = 0.7 * (t2[t1.Intro] or 1)

                        UIKit.sound("PovPulse", v373)
                        CutsceneFx.Shake(0.6, 0.2)

                        for _, v374 in ipairs(t32) do
                            CutsceneFx.EyeColor(v374, fromRGB(255, 60, 40))

                            local BillboardGui = v374:FindFirstChildOfClass("BillboardGui")
                            local ImageLabel = BillboardGui and BillboardGui:FindFirstChildOfClass("ImageLabel")

                            if ImageLabel then
                                ImageLabel.ImageColor3 = fromRGB(255, 60, 40)
                            end
                        end
                    end

                    v347 = v343
                    Unit = (v336 - v347).Unit
                    v346 = 0
                else
                    v343 = v343 or v342
                    v346 = math.clamp((p88 - v337) / (1 - v337), 0, 1)

                    if not v340 then
                        v340 = true

                        local v376 = 0.5 * (t2[t1.Intro] or 1)

                        UIKit.sound("CastRelease", v376)
                        UIKit.sound("ReelBurst", 0.8)
                        CutsceneFx.Haptic(3)
                    end

                    local v377 = v343

                    v347 = v377:Lerp(v336 - new(0, 0, v331 * 0.3), v346 * v346)
                    Unit = (v336 - v343).Unit
                end

                v342 = v347
                v320(v347, Unit)
                FishModels.Animate(v318, p89, if v346 > 0 then 30 elseif v341 then 3 else n20 * 14 + 11, 0.36)

                local v382 = math.floor((1 - math.clamp(p88 / 0.1, 0, 1)) * 10 + 0.5) / 10

                if v382 ~= n18 then
                    n18 = v382

                    for _, v383 in ipairs(t33) do
                        v383.Transparency = v382
                    end

                    v321.FillTransparency = v382
                end

                setEyes(v341 or p89 % 1.7 > 0.13)

                local v385 = v347 - v336

                if v385.Magnitude > v319.Z * 0.5 + 2 and v385.Z > 1 then
                    v344 = CFrame.lookAt(v336, v336 + new(v385.X * 0.7, v385.Y * 0.8, v385.Z))
                end

                local v389 = math.clamp((p88 - v338) / (v337 - v338), 0, 1)
                local v390 = v346 * 1.3 + n20 * 0.35
                local v391 = v344

                CurrentCamera.CFrame = v391 * CFrame.Angles(math.sin(p89 * 1.1) * 0.014, math.sin(p89 * 0.8) * 0.022, math.sin(p89 * 1.3) * 0.02) * CFrame.new(math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v390, math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v390, 0)
                CurrentCamera.FieldOfView = 74 - v389 * 9 + v346 * 50 * v346 + n20 * 16 + math.max(0, 1 - (p89 - n7) * 2.5) * 10
                ScreenFx.SpeedLines(math.max(v346, n20 * 0.8), v345)
                mood(p89)

                if v346 > 0 and v385.Magnitude < v319.Z * 0.5 + 5 and not v339 then
                    v339 = true
                    ScreenFx.Fade(1, 0.05, v149)
                    CutsceneFx.Strike(t1.Intro)
                end
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.4)
            UIKit.sound("PovStart", nil)
            run(v317, function(p90, p91) -- line: 1700
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p90, p91)

                if p90 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            v318:Destroy()
            ScreenFx.SpeedLines(0)
            Model.Parent = workspace
            ColorCorrectionEffect.Brightness = 0
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            v142 = true
            task.wait(0.12)
        elseif ForceIntro2 == "chase" then
            v213 = v148 * 0.85

            local v404, v405, v406 = shadowFish(5, 260)

            v205 = v405.X
            v221 = v405.Y
            v206 = v405.Z
            v204 = math.max(v205, v221, v206)
            v221 = v405.Y * 0.5
            v205 = math.clamp(v221, 2.6, 60)

            local v407 = mysteryMark(v404.PrimaryPart, v205, v405.Y / 2 + v205 * 0.65)

            addEyes(v404)
            v205 = {
                fromRGB(255, 170, 60),
                fromRGB(120, 220, 255),
                fromRGB(255, 255, 255),
                fromRGB(255, 120, 160)
            }

            local t34 = {}

            v215 = Random.new()

            for i = 1, 16 do
                Y2 = Instance.new("Part")
                Y2.Size = Vector3.new(0.3, 0.5, 1.2)
                Y2.Color = v205[i % #v205 + 1]
                Y2.Material = Enum.Material.SmoothPlastic
                Y2.Anchored = true
                Y2.CanCollide = false
                Y2.CanQuery = false
                Y2.CastShadow = false
                Y2.Parent = workspace
                table.insert(t7, Y2)
                v223 = {
                    part = Y2,
                    ang = v215:NextNumber(0, 6.28),
                    r = v215:NextNumber(2.2, 5.5),
                    h = v215:NextNumber(-0.8, 2.6),
                    sp = v215:NextNumber(0.9, 1.7)
                }
                v199 = v215:NextNumber(-9, 9)
                v198 = v215:NextNumber(-1, 4)
                v216 = -v215:NextNumber(26, 60)
                v223.flee = new(v199, v198, v216)
                t34[i] = v223
            end

            v222 = v204 * 1.5

            local v408 = math.max(110, v222)
            local v409 = v405.Z * 0.5 + 9

            v222 = v204 * 0.25

            local v410 = math.clamp(v222, 5, 26)

            X2 = v204 * 0.5

            local v411 = math.min(X2, 150)

            v197 = v408 * 2.5
            Lighting.FogEnd = math.max(300, v197)

            local v412 = v133 + Vector3.new(7, 2.2, -6)
            local n21 = 0
            local v413
            local v414 = false
            local v415 = false

            local function frame(p92, p93) -- line: 1748
                -- upvalues: SEABED_Y (copy), v133 (copy), ColorCorrectionEffect (copy), v149 (copy), mood (copy), n7 (ref), v404 (copy), v405 (copy), v406 (copy), v407 (copy), t34 (copy), v408 (copy), v409 (copy), v410 (copy), v411 (copy), v412 (copy), n21 (ref), v413 (ref), v414 (ref), v415 (ref), v190 (copy), FishModels (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy), burst3D (copy)
                if p92 >= 0.2 and not v413 then
                    v413 = p93
                    n7 = p93
                    CutsceneFx.Shake(1.5, 0.35)
                    CutsceneFx.Haptic(2)

                    local v416 = 1.5 * (t2[t1.Intro] or 1)

                    UIKit.sound("CastRelease", v416)

                    local v417 = 0.6 * (t2[t1.Intro] or 1)

                    UIKit.sound("PovPulse", v417)
                    UIKit.tween(ColorCorrectionEffect, 0.9, {
                        Brightness = -0.2
                    })
                end

                for v418, v419 in ipairs(t34) do
                    local v420 = v413 or p93
                    local v421 = v419.ang + v420 * v419.sp
                    local v427 = v133 + new(math.cos(v421) * v419.r, 1 + v419.h + math.sin(v420 * 2 + v418) * 0.3, math.sin(v421) * v419.r)

                    if v413 then
                        local v429 = math.min((p93 - v413) / 0.45, 1.4)
                        local v433 = v427 + v419.flee * v429 ^ 0.6 + new(math.sin(p93 * 22 + v418) * 0.15, 0, 0)

                        v419.part.CFrame = CFrame.lookAt(v433, v433 + v419.flee)
                    else
                        v419.part.CFrame = CFrame.lookAt(v427, v427 + new(-math.sin(v421), 0, (math.cos(v421)))) * CFrame.Angles(0, math.sin(p93 * 14 + v418) * 0.25, 0)
                    end
                end

                local v439 = new(v133.X, SEABED_Y - 900, v133.Z)
                local v440

                if p92 >= 0.2 then
                    local v442 = math.clamp((p92 - 0.2) / 0.6599999999999999, 0, 1)
                    local v443 = v442 * v442 * (3 - v442 * 2)

                    v439 = v133 + new(math.sin(p93 * 3.4) * v410 * 1.5 * (1 - v443), 0.5 - v411 * (1 - v443) ^ 1.5, v409 + v408 * (1 - v443))

                    while true and n21 < 2 and (if n21 == 0 then 0.45 else 0.75) <= v442 do
                        n21 += 1

                        local v448 = n21 * 0.3 + 1

                        n7 = p93
                        CutsceneFx.Shake(v448 * 1.25, 0.35)
                        CutsceneFx.Haptic(2)

                        local v449 = 0.7 * (t2[t1.Intro] or 1)

                        UIKit.sound("CastRelease", v449)

                        local v450 = 0.6 * (t2[t1.Intro] or 1)

                        UIKit.sound("PovPulse", v450)
                        burst3D(v439 + new(0, 0, -v405.Z * 0.5), fromRGB(225, 245, 255), 50)
                    end

                    v440 = math.clamp((p92 - 0.86) / 0.12, 0, 1)

                    if v440 > 0 then
                        v439 = v133 + new(0, 0.5, v409 * (1 - v440 * v440 * 1.5))
                        v407.Enabled = false

                        if not v415 then
                            v415 = true

                            local v454 = 0.5 * (t2[t1.Intro] or 1)

                            UIKit.sound("CastRelease", v454)
                            UIKit.sound("ReelBurst", 0.8)
                            CutsceneFx.Haptic(3)
                        end
                    end
                else
                    v440 = 0
                end

                v406(v439, (v133 - v439 + Vector3.new(0, 0, -0.01)).Unit)
                FishModels.Animate(v404, p93, v440 > 0 and 28 or 15, 0.36)

                local v455 = if v413 then math.min((p93 - v413) / 0.8, 1) else 0
                local v457 = v440 * 1.1 + v455 * 0.12

                CurrentCamera.CFrame = CFrame.lookAt(v412, (v133 + Vector3.new(0, 0.8, 0)):Lerp(v133 + new(0, 0.5, (math.min(v408 * 0.5, 60))), v455 * 0.5)) * CFrame.new(math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v457, math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v457, 0)
                CurrentCamera.FieldOfView = 66 - math.min(p92 / 0.2, 1) * 7 * (1 - v455) + v455 * 8 + v440 * 24 + math.max(0, 1 - (p93 - n7) * 2.5) * 12
                ScreenFx.SpeedLines(math.max(v440, v455 * 0.4), v190)
                mood(p93)

                if not (p92 >= 0.955) or v414 then
                    return
                end

                v414 = true
                ScreenFx.Fade(1, 0.08, v149)
                CutsceneFx.Strike(t1.Intro)
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.4)
            UIKit.sound("PovStart", nil)
            run(v213, function(p94, p95) -- line: 1807
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p94, p95)

                if p94 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            ScreenFx.SpeedLines(0)
            v404:Destroy()

            for _, v469 in ipairs(t34) do
                v469.part:Destroy()
            end

            ColorCorrectionEffect.Brightness = 0
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            v142 = true
            task.wait(0.12)
        elseif ForceIntro2 == "bait" then
            Model.Parent = nil

            local v470, v471

            v470, v202, v471 = shadowFish(4, 260)
            v204 = v202.X
            v205 = v202.Y
            v221 = v202.Z
            v203 = math.max(v204, v205, v221)
            v221 = v203 * 1.6

            local v472 = math.max(115, v221)

            v221 = v203 * 0.6

            local v473 = math.min(v221, 200)

            v206 = v203 * 0.5

            local v474 = math.clamp(v206, 10, 45)

            v222 = v472 * 1.4
            Lighting.FogEnd = math.max(300, v222)
            v215 = v202.Y * 0.5
            v206 = math.clamp(v215, 2.6, 60)

            local v475 = mysteryMark(v470.PrimaryPart, v206, v202.Y / 2 + v206 * 0.65)
            local v476 = v133 + Vector3.new(0, 0.1, 0)
            local v477 = v202.Z * 0.5 + 7
            local v478 = false
            local v479 = CFrame.lookAt(v476, v476 + Vector3.new(0, 0, 1))

            local function frame(p96, p97) -- line: 1838
                -- upvalues: v149 (copy), mood (copy), v470 (ref), v471 (ref), v472 (copy), v473 (copy), v474 (copy), v475 (copy), v476 (copy), v477 (copy), v478 (ref), v479 (ref), FishModels (copy), ScreenFx (copy), CurrentCamera (copy), new (copy), t1 (copy), CutsceneFx (copy)
                local v480, v481, v482

                if p96 < 0.8 then
                    local v483 = p96 / 0.8
                    local v484 = v483 * v483 * (3 - 2 * v483)
                    local v485 = v472 - (v472 - v477) * v484

                    v481 = v476 + new(math.sin(p97 * 1.5) * v474 * (1 - v484) + math.sin(p97 * 0.7 + 1) * 1.5, math.sin(p97 * 1.1) * 1.3 * (1 - v484) - v473 * (1 - v484) ^ 1.6, v485)
                    v482 = (v476 - v481).Unit + new(math.cos(p97 * 1.5) * 0.55 * (1 - v484), 0, 0)
                    v480 = 0
                else
                    v480 = (p96 - 0.8) / 0.2

                    local v495 = math.max(v480 - 0.25, 0) / 0.75
                    local v496 = v477 * (1 - v495 * v495 * v495 * 1.3)

                    v481 = v476 + new(math.sin(p97 * 0.7 + 1) * 1.5 * (1 - v495), (1 - v495) * 0, v496)
                    v475.Enabled = v480 < 0.25
                    v482 = Vector3.new(0, 0, -1)
                end

                v471(v481, v482)
                FishModels.Animate(v470, p97, v480 > 0.25 and 16 or 8, 0.36)

                local v501 = v481 - v476

                if v501.Z > 1.5 then
                    v479 = CFrame.lookAt(v476, v476 + new(v501.X * 0.6, v501.Y * 0.9, v501.Z))
                end

                local v504 = v479

                CurrentCamera.CFrame = v504 * CFrame.Angles(math.sin(p97 * 1.3) * 0.02, math.sin(p97 * 0.9) * 0.03, math.sin(p97 * 1.1) * 0.035)
                CurrentCamera.FieldOfView = math.max(v480 - 0.25, 0) ^ 2 * 16 + 78
                mood(p97)

                if not (p96 >= 0.95) or v478 then
                    return
                end

                v478 = true
                ScreenFx.Fade(1, 0.1, v149)
                CutsceneFx.Strike(t1.Intro)
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.4)
            UIKit.sound("PovStart", nil)
            run(v148, function(p98, p99) -- line: 1877
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p98, p99)

                if p98 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            v470:Destroy()
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            Model.Parent = workspace
            v142 = true
            task.wait(0.12)
        elseif ForceIntro2 == "bobber" then
            local v511 = v148 * 0.9
            local v512 = v133 + Vector3.new(0, 0.3, 0)
            local Pivot = Model:GetPivot()
            local v513 = Pivot - Pivot.Position
            local v514, v515

            v514, v205, v515 = shadowFish(5, 48)
            v215 = v205.X

            local Z = v205.Y

            v222 = v205.Z
            v206 = math.max(v215, Z, v222)
            addEyes(v514)
            v222 = v206 / 18
            v215 = math.clamp(v222, 1, 9) ^ 0.75
            v197 = v206 / 18

            local v516 = 2.4 / math.max(1, v197) ^ 0.5

            if v206 > 20 then
                X2 = v206 * 0.8
                v222 = math.min(X2, 220)
            else
                v222 = 0
            end

            local v517 = v215 ^ 0.6 * 2.6
            local v518, v519 = mysteryMark(v131, v517, 2.4 * v215 ^ 0.6)

            v518.Enabled = false

            local n22 = -10
            local v520 = v512.Y - 0.3
            local v521 = v205.Z * 0.5 + 9
            local v522 = v205.Z * 0.5 + 4.5

            v207 = v205.Z * 0.55 + 5
            v217 = (Vector3.new(10, 3, -14)).Unit
            v201 = (Vector3.new(10, 3, -14)).Magnitude * v215
            Part2 = v521 * 0.75 + v207

            local v523 = v217 * math.max(v201, Part2)

            Unit = (Vector3.new(6.5, 1.9, -9.5)).Unit
            Part2 = (Vector3.new(6.5, 1.9, -9.5)).Magnitude * v215
            v219 = v522 * 0.6 + v207

            local v524 = Unit * math.max(Part2, v219)

            v219 = v206 * 6
            v208 = v523.Magnitude * 2.5
            Lighting.FogEnd = math.max(300, v219, v208)
            v219 = 20 * v215 + 10
            v208 = v521 + v205.Z * 0.6
            hideNearbyProps(v133, (math.max(v219, v208)))

            local Part = Instance.new("Part")

            Part.Name = "BobberBubbles"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.Transparency = 1
            Part.Size = Vector3.new(1, 1, 1)
            Part.CFrame = CFrame.new(v512)

            local ParticleEmitter = Instance.new("ParticleEmitter")

            ParticleEmitter.Texture = UIKit.Art.Bubbles
            Unit = ColorSequence.new
            Part2 = ColorSequenceKeypoint.new

            local t35 = {}

            ParticleEmitter.Color = Unit({
                Part2(0, fromRGB(255, 214, 236)),
                ColorSequenceKeypoint.new(0.5, fromRGB(240, 250, 255)),
                ColorSequenceKeypoint.new(1, fromRGB(200, 255, 236))
            })
            ParticleEmitter.LightEmission = 0.35
            ParticleEmitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.45),
                NumberSequenceKeypoint.new(1, 1.15)
            })
            ParticleEmitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(0.7, 0.35),
                NumberSequenceKeypoint.new(1, 1)
            })
            ParticleEmitter.Lifetime = NumberRange.new(0.7, 1.4)
            ParticleEmitter.Speed = NumberRange.new(4, 12)
            ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
            ParticleEmitter.Drag = 2.5
            ParticleEmitter.Acceleration = Vector3.new(0, 10, 0)
            ParticleEmitter.Rotation = NumberRange.new(0, 360)
            ParticleEmitter.RotSpeed = NumberRange.new(-40, 40)
            ParticleEmitter.Rate = 0
            ParticleEmitter.Parent = Part

            local ParticleEmitter2 = Instance.new("ParticleEmitter")

            ParticleEmitter2.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            ParticleEmitter2.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, fromRGB(255, 120, 190)),
                ColorSequenceKeypoint.new(0.33, fromRGB(110, 240, 210)),
                ColorSequenceKeypoint.new(0.66, fromRGB(255, 230, 120)),
                ColorSequenceKeypoint.new(1, fromRGB(255, 150, 220))
            })
            ParticleEmitter2.LightEmission = 0.7
            ParticleEmitter2.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.15, 0.7),
                NumberSequenceKeypoint.new(1, 0.15)
            })
            ParticleEmitter2.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.8, 0.2),
                NumberSequenceKeypoint.new(1, 1)
            })
            ParticleEmitter2.Lifetime = NumberRange.new(0.5, 1.1)
            ParticleEmitter2.Speed = NumberRange.new(8, 18)
            ParticleEmitter2.SpreadAngle = Vector2.new(180, 180)
            ParticleEmitter2.Drag = 3
            ParticleEmitter2.Acceleration = Vector3.new(0, -6, 0)
            ParticleEmitter2.Rotation = NumberRange.new(0, 360)
            ParticleEmitter2.RotSpeed = NumberRange.new(-200, 200)
            ParticleEmitter2.Rate = 0
            ParticleEmitter2.Parent = Part
            Part.Parent = workspace
            table.insert(t7, Part)

            local function puff(p100, p101, p102) -- line: 1954
                -- upvalues: Part (copy), ParticleEmitter (copy), ParticleEmitter2 (copy)
                Part.CFrame = CFrame.new(p100)
                ParticleEmitter:Emit(p101)

                if p102 then
                    ParticleEmitter2:Emit(p102)
                end
            end

            local function bump(p103, p104, p105) -- line: 1961
                local v526 = math.abs(p103 - p104) / p105

                if not (v526 < 1) then
                    return 0
                end

                return math.cos(v526 * 3.141592653589793 / 2) ^ 2
            end

            local function follow(p106, p107) -- line: 1965
                return 1 - math.exp(-p106 * p107)
            end

            local t36 = {
                0.24, 0.42, 0.6
            }
            local n23 = 0
            local n24 = 0
            local n25 = 10
            local n26 = 0
            local v529, v530, v531, Unit2
            local n27 = 62

            t35[1] = 0

            local v532 = false
            local v533 = false
            local v534 = false
            local v535 = false

            local function nibble(p108) -- line: 1975
                -- upvalues: t36 (copy)
                local n28 = 0

                for _, v536 in t36 do
                    local v538 = math.abs(p108 - v536) / 0.055

                    n28 = math.max(n28, if v538 < 1 then math.cos(v538 * 3.141592653589793 / 2) ^ 2 else 0)
                end

                return n28
            end

            local v541 = v205.Z * 0.47

            v210 = v520 - v512.Y

            local v542 = new(0, v210, 0)

            local function inward(p109) -- line: 1985
                -- upvalues: v512 (copy)
                local v543 = (v512 - p109) * Vector3.new(1, 0.25, 1)

                if v543.Magnitude > 0.001 then
                    return v543.Unit
                end

                return (Vector3.new(0, 0, -1))
            end

            v209 = v206 * 0.5

            local v544 = v512 + Vector3.new(-0.83, 0, -0.55) * (v541 + math.clamp(v209, 8, 30)) + v542

            v210 = (v512 - v544) * Vector3.new(1, 0.25, 1)
            v206 = if v210.Magnitude > 0.001 then v210.Unit else Vector3.new(0, 0, -1)

            local v545 = v512 - v206 * v541
            local Unit3 = (v206 * 0.55 + Vector3.new(0, -0.5, 0) + Vector3.new(0.2475, 0, -0.3735)).Unit
            local v546 = nil
            local v547 = v222
            local v548 = v206

            local function frame(p110, p111) -- line: 1994
                -- upvalues: Model (copy), v149 (copy), mood (copy), n7 (ref), v512 (copy), Pivot (copy), v513 (copy), v514 (ref), v515 (ref), v516 (copy), v517 (copy), v518 (copy), v519 (copy), n22 (ref), v520 (copy), v521 (copy), v522 (copy), v523 (copy), v524 (copy), Part (copy), ParticleEmitter (copy), ParticleEmitter2 (copy), t36 (copy), n23 (ref), n24 (ref), n25 (ref), n26 (ref), v529 (ref), v530 (ref), v531 (ref), Unit2 (ref), n27 (ref), t35 (copy), v532 (ref), v533 (ref), v534 (ref), v535 (ref), v541 (copy), v542 (copy), v544 (copy), v545 (copy), Unit3 (copy), v546 (ref), v547 (copy), v548 (copy), v190 (copy), FishModels (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy)
                local v550 = math.clamp(p111 - n26, 0, 0.1)

                n26 = p111

                local v552 = math.clamp(p110 / 0.7, 0, 1)
                local v549 = v552 * v552 * v552 * (v552 * (v552 * 6 - 15) + 10)
                local v553 = math.clamp((p110 - 0.7) / 0.16000000000000003, 0, 1)
                local v551 = v553 * v553 * v553 * (v553 * (v553 * 6 - 15) + 10)

                v552 = math.clamp((p110 - 0.86) / 0.1, 0, 1)
                v553 = 0

                local v554, v555, v556

                for _, v557 in t36 do
                    v554 = p110 - v557
                    v555 = math.abs(v554) / 0.055

                    if v555 < 1 then
                        v554 = v555 * 3.141592653589793 / 2
                        v556 = math.cos(v554) ^ 2
                    else
                        v556 = 0
                    end

                    v553 = math.max(v553, v556)
                end

                local v558 = n23

                n23 = v558 + v516 * (v549 * 0.45 + 0.65) * (1 - v551) * (1 - v553 * 0.85) * v550

                local v559 = v521 + (v522 - v521) * v549
                local v562 = v512.X + math.cos(n23) * v559
                local v563 = p110 / 0.62

                v554 = math.clamp(v563, 0, 1)

                local v560 = v520 - v547 * (1 - v554 * v554 * v554 * (v554 * (v554 * 6 - 15) + 10))
                local Z = v512.Z
                local v565 = new(v562, v560, Z + math.sin(n23) * v559)
                local v566 = (v512 - v565) * Vector3.new(1, 0.25, 1)

                v559 = if v566.Magnitude > 0.001 then v566.Unit else Vector3.new(0, 0, -1)
                v560 = math.clamp(v553, 0, 1)
                v566 = v560 * v560 * v560 * (v560 * (v560 * 6 - 15) + 10)
                v560 = v565:Lerp(v512 - v559 * v541 + v542 * 0.5, v566):Lerp(v544, v551)

                local v564 = -math.sin(n23)

                v556 = n23

                local v561 = math.cos(v556)
                local v567 = new(v564, 0, v561):Lerp(v559, v566):Lerp(v548, v551)

                if v552 > 0 then
                    v564 = v552 / 0.4
                    v560 = math.min(v564, 1)
                    v564 = math.clamp(v560, 0, 1)
                    v566 = v564 * v564 * v564 * (v564 * (v564 * 6 - 15) + 10)
                    v560 = v544:Lerp(v545, v566 ^ 1.4)
                    v567 = v548

                    if v552 > 0.4 then
                        v560 = (v552 - 0.4) / 0.6
                        v564 = math.clamp(v560, 0, 1)
                        v566 = v564 * v564 * v564 * (v564 * (v564 * 6 - 15) + 10)
                        v560 = v545 + Unit3 * (v541 * 1.4 + 10) * v566
                        v556 = v566 * 1.6
                        v567 = v548:Lerp(Unit3, (math.min(v556, 1)))
                    end
                end

                if v567.Magnitude < 0.001 then
                    v567 = Vector3.new(0, 0, -1)
                end

                local v568, Unit, v569

                if v546 then
                    v568 = v546
                    Unit = v567.Unit
                    v569 = if v552 > 0 then 22 else 12
                    v563 = -v569 * v550
                    v568 = v568:Lerp(Unit, 1 - math.exp(v563))
                else
                    v568 = v567.Unit
                end

                v546 = v568

                if v546.Magnitude < 0.001 then
                    v546 = v567.Unit
                end

                v546 = v546.Unit
                v530 = v560
                v529 = v546
                v515(v560, v546)
                v559 = if v552 > 0 then 32 elseif v551 > 0 then (1 - v551) * 7 + 4 else v553 * 12 + 11
                v568 = n25
                Unit = v559 - n25
                v555 = v550 * -8
                n25 = v568 + Unit * (1 - math.exp(v555))

                local v570 = n24

                n24 = v570 + n25 * v550
                v559 = 0
                FishModels.Animate(v514, p111, nil, v552 * 0.12 + 0.34, n24)

                local v571

                for v572, v573 in t36 do
                    v571 = p110 - v573
                    v549 = math.abs(v571) / 0.045

                    if v549 < 1 then
                        v571 = v549 * 3.141592653589793 / 2
                        v563 = math.cos(v571) ^ 2
                    else
                        v563 = 0
                    end

                    v559 += v563 * (1.2 + 0.45 * v572)
                end

                v569 = p111 * 1.9
                v564 = math.sin(v569) * 0.05 + v553 * 0.55
                v563 = p111 * 34
                v568 = v564 + math.sin(v563) * 0.04 * v551 * (1 - v552)

                if v534 then
                    v569 = CFrame.new(v560 + v546 * v541) * v513
                    v555 = CFrame.Angles
                    Model:PivotTo(v569 * v555(0, 0, math.sin(p111 * 22) * 0.25))
                else
                    v563 = CFrame.new
                    Model:PivotTo(Pivot * v563(0, math.sin(p111 * 2.4) * 0.07 - v559, 0) * CFrame.Angles(v568, 0, v568 * 0.6))
                end

                while t35[1] < #t36 and t36[t35[1] + 1] <= p110 do
                    t35[1] += 1
                    Unit = t35[1] * 4 + 8
                    v561 = t35[1] * 6 + 10
                    Part.CFrame = CFrame.new(v512)
                    ParticleEmitter:Emit(Unit)

                    if v561 then
                        ParticleEmitter2:Emit(v561)
                    end

                    v564 = t35[1] * 0.2 + 0.5
                    Unit = t35[1] * 0.15 + 1
                    n7 = p111
                    CutsceneFx.Shake(v564 * 1.25, 0.35)
                    CutsceneFx.Haptic(2)
                    v561 = (Unit or 1.2 or 1) * (t2[t1.Intro] or 1)
                    UIKit.sound("CastRelease", v561)
                    v561 = 0.6 * (t2[t1.Intro] or 1)
                    UIKit.sound("PovPulse", v561)

                    if t35[1] == 1 then
                        v518.Enabled = true
                        v519.TextTransparency = 0
                    end

                    n22 = p111
                end

                if v551 > 0.05 and not v532 then
                    v532 = true
                    v519.Text = "!"
                    v519.TextColor3 = fromRGB(255, 70, 70)
                    n22 = p111
                    v564 = 0.6 * (t2[t1.Intro] or 1)
                    UIKit.sound("PovPulse", v564)
                end

                if v518.Enabled then
                    v568 = p111 - n22
                    v569 = -v568 * 7
                    Unit = math.exp(v569) * 0.45
                    v569 = v568 * 18
                    v559 = Unit * math.cos(v569) + 1
                    v518.Size = UDim2.fromScale(v517 * v559, v517 * v559)
                end

                if v552 > 0 and not v533 then
                    v533 = true
                    v564 = 0.5 * (t2[t1.Intro] or 1)
                    UIKit.sound("CastRelease", v564)
                    UIKit.sound("ReelBurst", 0.8)
                    CutsceneFx.Haptic(3)
                end

                if v552 >= 0.4 and not v534 then
                    v534 = true
                    v518.Enabled = false
                    Part.CFrame = CFrame.new(v512)
                    ParticleEmitter:Emit(60)
                    ParticleEmitter2:Emit(90)
                    CutsceneFx.Shake(2, 0.4)
                    CutsceneFx.Strike(t1.Intro)
                end

                if v534 then
                    v564 = (v552 - 0.4) / 0.6
                    Unit = math.clamp(v564, 0, 1)
                    v553 = Unit * Unit * Unit * (Unit * (Unit * 6 - 15) + 10)
                else
                    v553 = 0
                end

                local v576 = math.clamp(p110, 0, 1)

                v564 = v512 + v523:Lerp(v524, v576 * v576 * v576 * (v576 * (v576 * 6 - 15) + 10)) + (v560 - v545) * 0.45 * v553
                Unit = v512:Lerp(v560 + v546 * v541 * 0.5, v553 * 0.5 + 0.2) + Vector3.new(0, 0.3, 0)

                if v531 then
                    v561 = v531
                    v571 = v550 * -5
                    v564 = v561:Lerp(v564, 1 - math.exp(v571))
                end

                v531 = v564

                if Unit2 then
                    v561 = Unit2
                    v571 = v550 * -7
                    Unit = v561:Lerp(Unit, 1 - math.exp(v571))
                end

                Unit2 = Unit
                CurrentCamera.CFrame = CFrame.lookAt(v531, Unit2)
                Unit = 62 - v551 * 6 + v552 * 22 * v552 + math.max(0, 1 - (p111 - n7) * 2.5) * 8
                v561 = n27
                v555 = Unit - n27

                if v550 > 0 then
                    v571 = v550 * -12
                    v563 = 1 - math.exp(v571)
                else
                    v563 = 1
                end

                n27 = v561 + v555 * v563
                CurrentCamera.FieldOfView = n27
                ScreenFx.SpeedLines(v552, v190)
                mood(p111)

                if p110 >= 0.965 and not v535 then
                    v535 = true
                    ScreenFx.Fade(1, 0.1, v149)
                end
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.4)
            UIKit.sound("PovStart", nil)
            run(v511, function(p112, p113) -- line: 2098
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p112, p113)

                if p112 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            ScreenFx.SpeedLines(0)
            v514:Destroy()
            v518:Destroy()
            Part:Destroy()
            Model:PivotTo(Pivot)
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            v142 = true
            task.wait(0.12)
        elseif ForceIntro2 == "sonar" then
            local v577 = v148 * 0.85

            if t8 then
                v204 = t8[1]
                v205 = t8[2]
                v221 = t8[3]
                Lighting.FogStart = v204
                Lighting.FogEnd = v205
                Lighting.FogColor = v221
            end

            ColorCorrectionEffect.Enabled = false
            v214 = v133.X
            v203 = GameConfig.WATER_Y + 0.55
            v204 = v133.Z

            local v578 = new(v214, v203, v204)
            local v579, v580, v581 = shadowFish(5, 260)

            v221 = v580.X
            v206 = v580.Y
            v215 = v580.Z
            v205 = math.max(v221, v206, v215)
            addEyes(v579)
            clearSea(v578.Z)
            v215 = v205 / 18

            local v582 = math.clamp(v215, 1, 9) ^ 0.75

            X2 = v582 * 0.8

            local v583 = floatAt(v578, (math.max(1, X2)))

            hideNearbyProps(v133, v582 * 40 + 10, true)
            v215 = fromRGB(90, 255, 150)

            local Frame = Instance.new("Frame")

            Frame.Name = "SonarWash"
            Frame.Size = UDim2.fromScale(1, 1)
            Frame.BackgroundColor3 = fromRGB(0, 60, 30)
            Frame.BackgroundTransparency = 0.72
            Frame.BorderSizePixel = 0
            Frame.ZIndex = 1
            Frame.Parent = v7
            table.insert(t7, Frame)
            v222 = Instance.new("Frame")
            v222.Name = "Sonar"
            v222.AnchorPoint = Vector2.new(0.5, 0.5)
            v222.Position = UDim2.fromScale(0.5, 0.5)
            v222.Size = UDim2.fromScale(0.86, 0.86)
            v222.SizeConstraint = Enum.SizeConstraint.RelativeYY
            v222.BackgroundTransparency = 1
            v222.ZIndex = 2
            v222.Parent = Frame

            for i = 1, 3 do
                v197 = Instance.new("Frame")
                v197.AnchorPoint = Vector2.new(0.5, 0.5)
                v197.Position = UDim2.fromScale(0.5, 0.5)
                v197.Size = UDim2.fromScale(i / 3, i / 3)
                v197.BackgroundTransparency = 1
                v197.ZIndex = 2
                v199 = Instance.new("UICorner")
                v199.CornerRadius = UDim.new(0.5, 0)
                v199.Parent = v197
                v199 = Instance.new("UIStroke")
                v199.Color = v215
                v199.Thickness = i == 3 and 4 or 2
                v199.Transparency = 0.35
                v199.Parent = v197
                v197.Parent = v222
            end

            for i = 0, 1 do
                v197 = Instance.new("Frame")
                v197.AnchorPoint = Vector2.new(0.5, 0.5)
                v197.Position = UDim2.fromScale(0.5, 0.5)

                if i == 0 then
                    v197.Size = UDim2.new(1, 0, 0, 2)
                else
                    v197.Size = UDim2.new(0, 2, 1, 0)
                end

                v197.BackgroundColor3 = v215
                v197.BackgroundTransparency = 0.7
                v197.BorderSizePixel = 0
                v197.ZIndex = 2
                v197.Parent = v222
            end

            local Frame2 = Instance.new("Frame")

            Frame2.AnchorPoint = Vector2.new(0, 0.5)
            Frame2.Position = UDim2.fromScale(0.5, 0.5)
            Frame2.Size = UDim2.new(0.5, 0, 0, 5)
            Frame2.BackgroundColor3 = v215
            Frame2.BorderSizePixel = 0
            Frame2.ZIndex = 3
            Frame2.Parent = v222
            Y2 = Instance.new("UIGradient")
            Y2.Transparency = NumberSequence.new(0.8, 0)
            Y2.Parent = Frame2

            local Frame3 = Instance.new("Frame")

            Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame3.Size = UDim2.fromScale(0.045, 0.045)
            Frame3.BackgroundColor3 = fromRGB(220, 255, 230)
            Frame3.BorderSizePixel = 0
            Frame3.ZIndex = 4
            v223 = Instance.new("UICorner")
            v223.CornerRadius = UDim.new(0.5, 0)
            v223.Parent = Frame3
            Frame3.Parent = v222

            local v584 = UIKit.text(Frame, {
                Name = "Readout",
                Text = "",
                TextSize = 34,
                Stroke = 4,
                ZIndex = 4,
                Size = UDim2.new(1, 0, 0, 40),
                Position = UDim2.new(0, 0, 0.9, 0),
                Color = v215
            })
            local v585 = 55 * v582

            v199 = v205 * 1.2 + 30

            local v586 = math.min(v199, 240)
            local n29 = -1
            local v587 = false
            local v588 = false
            local n30 = -10

            local function frame(p114, p115) -- line: 2199
                -- upvalues: v149 (copy), mood (copy), ringAt (copy), n7 (ref), v578 (copy), v579 (copy), v580 (copy), v581 (copy), v582 (copy), v583 (copy), Frame (copy), Frame2 (copy), Frame3 (copy), v584 (copy), v585 (copy), v586 (copy), n29 (ref), v587 (ref), v588 (ref), n30 (ref), FishModels (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy), burst3D (copy)
                local v589 = p115 * 2.6
                local v590 = (1 - p114) ^ 1.2 * v585
                local v592 = (1 - math.min(p114 / 0.86, 1)) ^ 1.3 * v586
                local v594 = math.clamp((p114 - 0.9) / 0.085, 0, 1)
                local v598 = new(v578.X + math.cos(v589) * v590, v578.Y - v580.Y * 0.6 - 1.5 - v592, v578.Z + math.sin(v589) * v590)
                local v601 = new(-math.sin(v589) - math.cos(v589) * 0.4, 0, math.cos(v589) - math.sin(v589) * 0.4)

                if v594 > 0 then
                    v598 = v598:Lerp(v578 + new(0, v580.Z * 0.2, 0), v594 ^ 2)
                    v601 = v601:Lerp(Vector3.new(0, 1, 0.02), (math.min(v594 * 2, 1)))
                end

                v581(v598, v601.Unit)
                FishModels.Animate(v579, p115, v594 * 16 + 14, 0.36)
                Frame2.Rotation = p115 / 0.62 * 360 % 360

                local v605 = math.floor(p115 / 0.62)

                if n29 < v605 then
                    n29 = v605
                    n30 = p115

                    local v607 = math.min(v590 / v585, 1) * 0.47

                    Frame3.Position = UDim2.fromScale(math.cos(v589) * v607 + 0.5, math.sin(v589) * v607 + 0.5)

                    local v608 = (0.8 + 1.1 * p114 or 1) * (t2[t1.Intro] or 1)

                    UIKit.sound("PovPulse", v608)

                    local v609 = 0.7 + 0.9 * p114

                    UIKit.sound("Twinkle", v609)
                    CutsceneFx.Shake(0.3 + 1.3 * p114, 0.2)
                    CutsceneFx.Haptic(1)
                    n7 = p115
                    ringAt(v578, 10 + 16 * p114)
                    v584.Text = (if p114 >= 0.55 then "CLOSING FAST   %d m" else "CONTACT   %d m"):format((math.floor(v592 + v590 + 0.5)))
                end

                local v612 = (p115 - n30) / 0.62

                Frame3.BackgroundTransparency = math.clamp(v612 * 1.3, 0, 1)
                Frame3.Size = UDim2.fromScale(math.max(0, 1 - v612 * 5) * 0.05 + 0.045, math.max(0, 1 - v612 * 5) * 0.05 + 0.045)

                if p114 >= 0.55 then
                    Frame.BackgroundColor3 = fromRGB(90, 0, 0):Lerp(fromRGB(0, 60, 30), math.sin(p115 * 18) * 0.5 + 0.5)
                    v584.TextColor3 = fromRGB(255, 170, 60)
                end

                if v594 > 0 then
                    v584.Text = "!!!  RIGHT BELOW  !!!"
                    v584.TextColor3 = fromRGB(255, 80, 80)
                end

                v583:PivotTo(CFrame.new(v578 + new(0, math.sin(p115 * 3) * 0.08 - (if v594 >= 0.65 then 900 else 0), 0)))

                local v622 = v582 * 46 * (1 - 0.5 * p114)

                CurrentCamera.CFrame = CFrame.lookAt(v578 + new(0, v622, 0.01), v578, (Vector3.new(0, 0, -1))) * CFrame.Angles(0, 0, p114 * p114 * 2.2 + math.sin(p115 * 3) * 0.03)
                CurrentCamera.FieldOfView = 60 - 8 * p114 + v594 * 30 + math.max(0, 1 - (p115 - n7) * 2.5) * 9
                mood(p115)

                if v594 >= 0.65 and not v587 then
                    v587 = true
                    Frame.Visible = false
                    burst3D(v578, fromRGB(235, 245, 255), 180)
                    ringAt(v578, 60)
                    ringAt(v578, 100)
                    ringAt(v578, 140)
                    CutsceneFx.Shake(2.2, 0.4)
                    CutsceneFx.Haptic(3)
                    CutsceneFx.Strike(t1.Intro)
                end

                if p114 >= 0.965 and not v588 then
                    v588 = true
                    ScreenFx.Fade(1, 0.1, v149)
                end
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.4)
            UIKit.sound("PovStart", nil)
            run(v577, function(p116, p117) -- line: 2264
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p116, p117)

                if p116 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            v579:Destroy()
            v583:Destroy()
            Frame:Destroy()
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            v142 = true
            task.wait(0.12)
        elseif ForceIntro2 == "drag" then
            if t8 then
                v203 = t8[1]
                v204 = t8[2]
                v205 = t8[3]
                Lighting.FogStart = v203
                Lighting.FogEnd = v204
                Lighting.FogColor = v205
            end

            ColorCorrectionEffect.Enabled = false

            local v628, v629, v630 = shadowFish(5, 260)

            v204 = v629.X
            v205 = v629.Y
            v221 = v629.Z
            v203 = math.max(v204, v205, v221)
            addEyes(v628)
            v221 = v203 / 18

            local v631 = math.clamp(v221, 1, 9) ^ 0.75

            v211 = 150 * v631 ^ 0.5
            v215 = math.clamp(v211, 150, 300)
            v211 = GameConfig.DOCK_Z - 25 - v133.Z
            v206 = math.min(v215, v211)

            local v632 = math.max(24, v206)

            clearSea(v133.Z + v632 / 2)
            hidePropsInBox(v133.X, 26 + v629.X / 2, v133.Z - 14 - v629.Z, v133.Z + v632 + 14)

            local v633 = GameConfig.WATER_Y + 4.4

            v221 = CutsceneFx.Buddy(CFrame.new(v133.X, v633, v133.Z + v632), true)

            local v634 = v221

            if v221 then
                table.insert(t7, v221)
            else
                v211 = v133.X
                v222 = GameConfig.WATER_Y + 0.55
                X2 = v133.Z + v632
                v634 = floatAt(new(v211, v222, X2), 1.4)
            end

            local Part = Instance.new("Part")

            Part.Name = "TowLine"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.Material = Enum.Material.Neon
            Part.Color = fromRGB(255, 255, 255)
            Part.Transparency = 0.25
            Part.Parent = workspace
            table.insert(t7, Part)

            local v635 = false
            local v636 = false
            local n31 = 0
            local t37 = {
                0.14, 0.3, 0.45, 0.58, 0.7, 0.79
            }
            local t38 = {}

            t38[1] = 0

            local n32 = -10
            local n33 = 1
            local n34 = 0
            local v637 = if n3 == 0 then fromRGB(255, 255, 255) else v123

            local function frame(p118, p119) -- line: 2313
                -- upvalues: v133 (copy), v149 (copy), mood (copy), ringAt (copy), v628 (copy), v629 (copy), v630 (copy), v631 (copy), v632 (copy), v633 (copy), v634 (ref), Part (copy), v635 (ref), v636 (ref), n31 (ref), t37 (copy), t38 (copy), n32 (ref), n33 (ref), n34 (ref), v637 (copy), GameConfig (copy), FishModels (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy), burst3D (copy)
                local v639 = math.min(p118 / 0.86, 1)
                local v640 = v639 ^ 1.35
                local v641 = v639 ^ 0.6 * 1.3 + 0.5
                local v643 = math.clamp((p118 - 0.86) / 0.11, 0, 1)

                while t38[1] < #t37 and t37[t38[1] + 1] <= p118 do
                    t38[1] += 1
                    n32 = p119
                    n34 = n33
                    n33 = -n33
                    CutsceneFx.Shake(t38[1] * 0.25 + 1.1, 0.3)
                    CutsceneFx.Haptic(2)

                    local v644 = (t38[1] * 0.12 + 1.2 or 1) * (t2[t1.Intro] or 1)

                    UIKit.sound("CastRelease", v644)

                    local v645 = t38[1] * 0.15 + 1.3

                    UIKit.sound("ReelBurst", v645)
                end

                local v646 = p119 - n32
                local v648 = 1 - math.exp(-v646 * 9)
                local X = v133.X
                local v650 = n34
                local v651 = n33
                local v649 = X + (v650 + (v651 - n34) * v648) * 11 * (1 - v643)
                local v652 = if t38[1] > 0 then math.sin(math.clamp(v646 / 0.5, 0, 1) * 3.141592653589793) * (t38[1] * 0.6 + 3.5) else 0
                local v660 = new(v649, v633 + v652 + math.abs((math.sin(p119 * 13))) * 0.35 * v641, v133.Z + v632 * (1 - v640))
                local v661 = 9 + v629.Z * 0.5
                local v663 = math.sin(p119 * 7) * 0.35
                local X2 = v133.X
                local v664 = n34
                local v666 = n33
                local v671 = new(X2 + (v664 + (v666 - n34) * math.min(v648 * 1.6, 1)) * 11 * 1.25, GameConfig.WATER_Y - v629.Y * 0.28, v660.Z - v661)
                local v673 = new(n33 * 0.5 * (1 - v648) + v663, 0, -1)

                if v643 > 0 then
                    v671 = v671:Lerp(v660 + new(0, -v629.Y * 0.4 - v652, -v629.Z * 0.08), v643 ^ 1.5)
                    v673 = new(0, v643 * 1.2 + 0.2, v643 * 2.2 + -1)
                end

                v630(v671, v673.Unit)
                FishModels.Animate(v628, p119, v643 * 8 + 20, 0.5)

                local v680 = math.sin(math.min(v643 / 0.7, 1) * 3.141592653589793) * (v631 * 6 + 18)
                local v681 = if v643 >= 0.72 then (v643 - 0.72) * 200 else 0
                local v683 = n33
                local v682 = (v683 - n34) * 0.45 * (1 - v648)
                local v684 = v634

                v684:PivotTo(CFrame.new(v660 + new(0, v680 - v681, 0)) * CFrame.Angles(math.rad(-10 - v641 * 8) + v643 * 2.2, n33 * -0.25 * (1 - v643), v682 + math.sin(p119 * 6) * 0.08 + v643 * 3))

                local v692 = v660 + new(0, v680 + 1.2, -1.6)
                local v695 = v671 + new(0, v629.Y * 0.3, -v629.Z * 0.3)

                Part.Size = new(0.18, 0.18, (v695 - v692).Magnitude)
                Part.CFrame = CFrame.lookAt((v692 + v695) / 2, v695)
                Part.Color = fromRGB(255, 255, 255):Lerp(fromRGB(255, 80, 50), (math.max(0, 1 - v646 * 3)))
                Part.Transparency = v643 * 0.9 + 0.1

                if p119 - n31 > 0.05 and v643 < 0.7 then
                    n31 = p119
                    ringAt(v660, v641 * 12 + 8)
                    burst3D(new(v660.X, GameConfig.WATER_Y + 0.3, v660.Z + 3.5), fromRGB(235, 248, 255), (math.floor(v641 * 9 + 6)))
                    burst3D(new(v671.X, GameConfig.WATER_Y + 0.3, v671.Z + v629.Z * 0.3), fromRGB(235, 248, 255), (math.floor(v641 * 8 + 4)))
                end

                ScreenFx.SpeedLines(math.min(1, v641 * 0.5 + 0.55) * (1 - v643), v637)

                local v711 = math.max(0, 1 - v646 * 2.5)
                local v712 = (v631 ^ 0.5 * 5 + 9) * (1 - 0.2 * p118)
                local v714 = n34
                local v715 = n33
                local v717 = v660 + new((v714 + (v715 - n34) * v648) * -6 + 8 * (1 - p118), v631 ^ 0.5 * 1.6 + 3.2 - v652 * 0.5, v712)
                local v720 = new(v717.X, math.max(v717.Y, GameConfig.WATER_Y + 1.6), v717.Z)
                local v721 = if v635 then v631 * 1.2 else v641 * 0.22

                CurrentCamera.CFrame = CFrame.lookAt(v720 + new(math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v721, math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v721, 0), v660 + new(0, v680 * 0.6, v643 * 6 + -8)) * CFrame.Angles(0, 0, n33 * 0.14 * (1 - v648) * (1 - v643))
                CurrentCamera.FieldOfView = v641 * 14 * (1 - v643) + 66 + v711 * 12 + v643 * 14
                mood(p119)

                if v643 >= 0.72 and not v635 then
                    v635 = true
                    CutsceneFx.Shake(2.4, 0.45)
                    burst3D(v660, fromRGB(235, 245, 255), 160)
                    ringAt(v660, 30)
                    ringAt(v660, 70)
                    ringAt(v660, 110)
                    CutsceneFx.Strike(t1.Intro)
                end

                if p118 >= 0.965 and not v636 then
                    v636 = true
                    ScreenFx.Fade(1, 0.1, v149)
                end
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.4)
            UIKit.sound("PovStart", nil)
            v200 = v148 * 0.85
            run(v200, function(p120, p121) -- line: 2389
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p120, p121)

                if p120 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            ScreenFx.SpeedLines(0)
            v628:Destroy()
            Part:Destroy()
            v634:Destroy()
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            v142 = true
            task.wait(0.12)
        elseif ForceIntro2 == "hunt" then
            local v729, v730, v731 = shadowFish(5, 260)

            v204 = v730.X
            v205 = v730.Y
            v221 = v730.Z
            v203 = math.max(v204, v205, v221)
            addEyes(v729)
            v221 = v203 / 18

            local v732 = math.clamp(v221, 1, 9) ^ 0.75

            v211 = 190 * v732 ^ 0.5
            v215 = math.clamp(v211, 190, 330)
            v211 = GameConfig.DOCK_Z - 25 - v133.Z
            v206 = math.min(v215, v211)

            local v733 = math.max(40, v206)

            hidePropsInBox(v133.X, 30 + v730.X / 2, v133.Z - 14 - v730.Z, v133.Z + v733 + 14)
            v211 = v203 * 6
            Lighting.FogEnd = math.max(320, v211)
            Model.Parent = nil
            v206 = 10 + v730.X * 0.3

            local v734 = math.clamp(v206, 12, 24)
            local v735 = GameConfig.WATER_Y - 3

            local function path(p122) -- line: 2416
                -- upvalues: v133 (copy), v733 (copy), v734 (copy), v735 (copy), new (copy)
                local v737 = math.sin(p122 * 3.141592653589793 * 5.5)
                local v738 = math.sign(v737) * math.abs(v737) ^ 0.7
                local v740 = 1 - math.clamp((p122 - 0.86) / 0.14, 0, 1)
                local v743 = math.min(v133.Y + math.sin(p122 * 3.141592653589793 * 3.7 + 1) * 3 * v740, v735)

                return (new(v133.X + v738 * v734 * v740, v743, v133.Z + v733 * (1 - p122)))
            end

            local function heading(p123) -- line: 2423
                -- upvalues: path (copy)
                local v746 = path(p123 + 0.004) - path(p123 - 0.004)

                if v746.Magnitude > 0.001 then
                    return v746.Unit
                end

                return (Vector3.new(0, 0, -1))
            end

            v211 = CutsceneFx.Buddy
            v222 = CFrame.new
            Y2 = math.sign(0) * math.abs(0) ^ 0.7
            v197 = v133.Y + 2.5244129544236893
            v223 = math.min(v197, v735)
            v199 = v133.X + Y2 * v734 * 1
            v216 = v133.Z + v733 * 1
            v211 = v211(v222((new(v199, v223, v216))), false)

            local v747 = v211

            if not v211 then
                v211 = Instance.new("Model")
                v747 = v211
                v222 = Instance.new("Part")
                v222.Name = "HumanoidRootPart"
                v222.Size = Vector3.new(2, 5, 1)
                v222.Color = fromRGB(255, 220, 120)
                v222.Anchored = true
                v222.CanCollide = false
                v222.CanQuery = false
                v222.Parent = v211
                v211.PrimaryPart = v222
                v211.Parent = workspace
            end

            table.insert(t7, v211)

            for _, descendant in ipairs(v211:GetDescendants()) do
                if descendant:IsA("Tool") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("RopeConstraint") or descendant.Name == "FishingRod" then
                    descendant:Destroy()
                end
            end

            local v748 = v211:FindFirstChild("HumanoidRootPart") or v211.PrimaryPart
            local t39 = {}

            if v748 then
                for _, child in ipairs(v211:GetChildren()) do
                    if child:IsA("BasePart") and child ~= v748 then
                        v216 = child.Name
                        v207 = if v216:find("Left") then "L" elseif v216:find("Right") then "R" else nil
                        v200 = if v216:find("Arm") or v216:find("Hand") then "A" elseif v216:find("Leg") or v216:find("Foot") then "G" else nil

                        if v207 and v200 then
                            local v749 = v207 .. v200

                            v217 = t39[v749]

                            if not v217 then
                                v217 = {
                                    top = (-1e999),
                                    pivot = Vector3.new(0, 0, 0),
                                    parts = {},
                                    side = v207,
                                    kind = v200
                                }
                                t39[v749] = v217
                            end

                            Unit = v748.CFrame:ToObjectSpace(child.CFrame)
                            v201 = v217.parts
                            Part2 = {
                                child,
                                Unit
                            }
                            table.insert(v201, Part2)
                            v212 = Unit.Position.Y + child.Size.Y / 2

                            if v217.top < v212 then
                                v217.top = v212
                                Part2 = Unit.Position.X
                                v219 = v212 - 0.25
                                v208 = Unit.Position.Z
                                v217.pivot = new(Part2, v219, v208)
                            end
                        end
                    end
                end
            end

            local function pose(p124, p125, p126) -- line: 2474
                -- upvalues: v747 (ref), t39 (copy), v748 (copy)
                v747:PivotTo(p124)

                if v748 then
                    local _CFrame = v748.CFrame

                    for _, v750 in pairs(t39) do
                        local v751

                        if v750.kind == "A" then
                            local v752 = p125 * 15 + (if v750.side == "L" then 0 else 3.141592653589793)

                            v751 = v752 + (3.141592653589793 - v752 % 6.283185307179586) * p126
                        else
                            v751 = math.sin(p125 * 24 + (if v750.side == "L" then 0 else 3.141592653589793)) * 0.55
                        end

                        local v754 = CFrame.new(v750.pivot) * CFrame.Angles(v751, 0, 0) * CFrame.new(-v750.pivot)

                        for _, v755 in ipairs(v750.parts) do
                            v755[1].CFrame = _CFrame * v754 * v755[2]
                        end
                    end
                end
            end

            local v756 = v730.Z * 0.5 + 12 + v732 * 6

            v199 = v756 / v733

            local v757 = math.min(v199, 0.6)
            local t40 = {
                0.14, 0.32, 0.5, 0.66, 0.79
            }
            local t41 = {}

            t41[1] = 0

            local n35 = 0
            local v758 = false
            local v759 = false
            local v760 = false

            local function frame(p127, p128) -- line: 2500
                -- upvalues: v149 (copy), mood (copy), n7 (ref), v729 (copy), v730 (copy), v731 (copy), v732 (copy), v733 (copy), path (copy), pose (copy), v756 (copy), v757 (copy), t40 (copy), t41 (copy), n35 (ref), v758 (ref), v759 (ref), v760 (ref), v190 (copy), GameConfig (copy), FishModels (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy), burst3D (copy)
                local v762 = math.min(p127 / 0.9, 1) ^ 1.15
                local v764 = math.clamp((p127 - 0.9) / 0.08, 0, 1)

                while t41[1] < #t40 and t40[t41[1] + 1] <= p127 do
                    t41[1] += 1

                    local v765 = t41[1] * 0.2 + 0.9
                    local v766 = t41[1] * 0.1 + 1.2

                    n7 = p128
                    CutsceneFx.Shake(v765 * 1.25, 0.35)
                    CutsceneFx.Haptic(2)

                    local v767 = (v766 or 1.2 or 1) * (t2[t1.Intro] or 1)

                    UIKit.sound("CastRelease", v767)

                    local v768 = 0.6 * (t2[t1.Intro] or 1)

                    UIKit.sound("PovPulse", v768)
                    UIKit.sound("DeepWhoosh", 1.3)
                end

                local v770 = math.max(0, 1 - (p128 - n7) * 2.5)
                local v771 = v757 + (1 - v757) * v762
                local v772 = path(v771)
                local v773 = v756 * (1 - v762 * 0.35) + v770 * 7
                local v774 = v771 - (v773 + (v730.Z * 0.42 - v773) * v764 * v764) / v733
                local v775 = path(v774)
                local v776 = path(v774 + 0.004) - path(v774 - 0.004)
                local v777 = if v776.Magnitude > 0.001 then v776.Unit else Vector3.new(0, 0, -1)
                local v779 = v772 - new(0, v730.Y * 0.1, 0)
                local v780 = path(v771 + 0.004) - path(v771 - 0.004)

                v731(v779, ((if v780.Magnitude > 0.001 then v780.Unit else Vector3.new(0, 0, -1)) + new(math.sin(p128 * 9) * 0.25, 0, 0)).Unit)
                FishModels.Animate(v729, p128, v770 * 10 + 24, 0.5)

                if v764 > 0 and not v760 then
                    v760 = true

                    local v784 = 0.6 * (t2[t1.Intro] or 1)

                    UIKit.sound("CastRelease", v784)
                    UIKit.sound("ReelBurst", 0.9)
                    CutsceneFx.Haptic(2)
                end

                pose(CFrame.lookAt(v775, v775 + v777) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.Angles(math.sin(p128 * 15) * 0.07, v777.X * 1.1 + math.sin(p128 * 7.5) * 0.18, 0), p128, v764)

                local burst3D2, v791

                if p128 - n35 > 0.05 then
                    n35 = p128
                    burst3D(v775 - v777 * 3, fromRGB(225, 245, 255), math.floor(v770 * 6) + 5)

                    if v770 > 0.5 then
                        burst3D2 = burst3D

                        local v795 = path(v771 + 0.004) - path(v771 - 0.004)

                        v791 = if v795.Magnitude > 0.001 then v795.Unit else Vector3.new(0, 0, -1)
                        burst3D2(v772 - v791 * v730.Z * 0.45, fromRGB(225, 245, 255), 14)
                    end
                end

                local v800 = path(v774 - (v732 * 0.4 + 5.5) * (1 - v764 * 0.2) / v733) + new(-v777.X * 1.2, v732 * 0.15 + 1.5, 0)
                local v803 = new(v800.X, math.min(v800.Y, GameConfig.WATER_Y - 1), v800.Z)
                local v804 = if v758 then v732 * 1.3 else v770 * 0.2 + 0.14

                CurrentCamera.CFrame = CFrame.lookAt(v803 + new(math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v804, math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v804, 0), v775 + (v772 - v775).Unit * 4 + Vector3.new(0, 0.5, 0)) * CFrame.Angles(0, 0, -v777.X * 0.28)
                CurrentCamera.FieldOfView = math.min(120, v762 * 8 + 80 + v770 * 13 + v764 * 16)
                ScreenFx.SpeedLines(math.min(1, v762 * 0.3 + 0.45 + v770 * 0.4 + v764 * 0.5), v190)
                mood(p128)

                if v764 >= 0.8 and not v758 then
                    v758 = true
                    burst3D(v775 + v777 * 3, fromRGB(235, 245, 255), 200)
                    CutsceneFx.Shake(2.6, 0.5)
                    CutsceneFx.Haptic(3)
                    CutsceneFx.Strike(t1.Intro)
                end

                if p127 >= 0.965 and not v759 then
                    v759 = true
                    ScreenFx.Fade(1, 0.1, v149)
                end
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.3)
            UIKit.sound("PovStart", nil)
            Part2 = v148 * 0.9
            run(Part2, function(p129, p130) -- line: 2558
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p129, p130)

                if p129 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            ScreenFx.SpeedLines(0)
            v729:Destroy()
            v747:Destroy()
            Model.Parent = workspace
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            v142 = true
            task.wait(0.12)
        elseif ForceIntro2 == "whirl" then
            v213 = v148 * 0.85

            if t8 then
                v204 = t8[1]
                v205 = t8[2]
                v221 = t8[3]
                Lighting.FogStart = v204
                Lighting.FogEnd = v205
                Lighting.FogColor = v221
            end

            ColorCorrectionEffect.Enabled = false
            v214 = v133.X
            v203 = GameConfig.WATER_Y + 0.55
            v204 = v133.Z

            local v811 = new(v214, v203, v204)
            local v812, v813, v814 = shadowFish(5, 260)

            v221 = v813.X
            v206 = v813.Y
            v215 = v813.Z
            v205 = math.max(v221, v206, v215)
            addEyes(v812)
            clearSea(v811.Z)
            v215 = v205 / 18

            local v815 = math.clamp(v215, 1, 9) ^ 0.75
            local v816 = v815 ^ 0.5

            Y2 = v815 * 0.7

            local v817 = floatAt(v811, (math.max(1, Y2)))

            hideNearbyProps(v133, v815 * 40 + 10, true)
            v222 = v815 ^ 0.6 * 30

            local v818 = math.min(v222, 50)

            v222 = Instance.new("Model")
            v222.Name = "Whirlpool"

            local t42 = {}

            for i = 0, 2 do
                for j = 1, 15 do
                    v207 = Instance.new("Part")
                    v207.Anchored = true
                    v207.CanCollide = false
                    v207.CanQuery = false
                    v207.CastShadow = false
                    v207.Material = Enum.Material.SmoothPlastic

                    if j % 2 == 0 then
                        v207.Color = fromRGB(255, 255, 255)
                    else
                        v207.Color = fromRGB(190, 235, 255)
                    end

                    v207.Transparency = (1 - j / 15) * 0.4 + 0.15
                    Part2 = 3 + j * 0.22
                    v207.Size = new(1.2, 0.3, Part2) * v816
                    v207.Parent = v222
                    t42[#t42 + 1] = { v207, i, j }
                end
            end

            local Part = Instance.new("Part")

            Part.Shape = Enum.PartType.Cylinder
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.Material = Enum.Material.SmoothPlastic
            Part.Color = fromRGB(4, 14, 34)
            Part.Parent = v222
            v222.Parent = workspace
            table.insert(t7, v222)
            v197 = v205 * 1.1 + 25

            local v819 = math.min(v197, 200)
            local v820 = false
            local v821 = false
            local n36 = 0
            local n37 = 0
            local n38 = 0

            local function frame(p131, p132) -- line: 2621
                -- upvalues: v149 (copy), mood (copy), ringAt (copy), n7 (ref), v811 (copy), v812 (copy), v813 (copy), v814 (copy), v815 (copy), v816 (copy), v817 (copy), v818 (copy), t42 (copy), Part (copy), v819 (copy), v820 (ref), v821 (ref), n36 (ref), n37 (ref), n38 (ref), v190 (copy), GameConfig (copy), FishModels (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy), burst3D (copy)
                local v822 = n36

                n36 = v822 + (p132 - n38) * (2 + 7.5 * p131)
                n38 = p132

                while n37 < 3 and n37 * 0.23 + 0.3 <= p131 do
                    n37 += 1

                    local v823 = n37 * 0.4 + 1
                    local v824 = n37 * 0.1 + 0.6

                    n7 = p132
                    CutsceneFx.Shake(v823 * 1.25, 0.35)
                    CutsceneFx.Haptic(2)

                    local v825 = (v824 or 1.2 or 1) * (t2[t1.Intro] or 1)

                    UIKit.sound("CastRelease", v825)

                    local v826 = 0.6 * (t2[t1.Intro] or 1)

                    UIKit.sound("PovPulse", v826)
                    UIKit.sound("DeepRumble", 1)

                    for i = 0, 5 do
                        local v828 = n36
                        local v827 = v828 + i * 3.141592653589793 / 3

                        burst3D(new(v811.X + math.cos(v827) * v818 * 0.6, GameConfig.WATER_Y + 0.4, v811.Z + math.sin(v827) * v818 * 0.6), fromRGB(235, 248, 255), 24)
                    end
                end

                local v834 = (7 * p131 + math.max(0, 1 - (p132 - n7) * 2.5) * 2.5) * v816

                for _, v835 in ipairs(t42) do
                    local v836 = v835[3] / 15
                    local v837 = v818 * (0.1 + 0.9 * v836)
                    local v839 = n36
                    local v838 = v839 + v835[2] * 2.0943951023931953 + v836 * 3.3

                    v835[1].CFrame = CFrame.new(v811.X + math.cos(v838) * v837, GameConfig.WATER_Y + 0.25 - (1 - v836) ^ 2 * v834, v811.Z + math.sin(v838) * v837) * CFrame.Angles(0, -v838, 0) * CFrame.Angles(0, 0, -0.5 * (1 - v836) * p131)
                end

                local v840 = v818 * 0.22 * (0.2 + 0.8 * p131)

                Part.Size = new(0.3, v840 * 2, v840 * 2)
                Part.CFrame = CFrame.new(v811.X, GameConfig.WATER_Y + 0.2 - v834 * 0.9, v811.Z) * CFrame.Angles(0, 0, 1.5707963267948966)

                local v844 = math.clamp((p131 - 0.88) / 0.095, 0, 1)
                local v845 = v818 * 0.82 * (1 - p131) ^ 1.3 + 0.6
                local v846 = n36 * 0.8
                local v849 = GameConfig.WATER_Y + 0.6 - (1 - math.min(v845 / v818, 1)) ^ 2 * v834

                v817:PivotTo(if v844 >= 0.7 then CFrame.new(v811 + Vector3.new(0, -900, 0)) else CFrame.new(v811.X + math.cos(v846) * v845, v849, v811.Z + math.sin(v846) * v845) * CFrame.Angles(0.5 * p131, v846, 0.3 * p131))

                local v852 = (1 - math.min(p131 / 0.86, 1)) ^ 1.4 * v819
                local v854 = new(v811.X, v811.Y - v813.Z * 0.5 - 3 - v834 - v852, v811.Z)

                if v844 > 0 then
                    v854 = v854:Lerp(v811 + new(0, v813.Z * 0.22, 0), v844 ^ 2)
                end

                v814(v854, new(math.cos(n36 * 0.5) * 0.05, 1, math.sin(n36 * 0.5) * 0.05).Unit)
                FishModels.Animate(v812, p132, v844 * 18 + 12, 0.3)

                local v860 = p132 * 1.5 + 0.6
                local v862 = math.min((27 - 13 * p131) * v815, 54)
                local v865 = math.min((19 - 10 * p131) * v815, 70 - 30 * p131)
                local v866 = if v820 then v815 * 1.4 else 0.35 * p131

                CurrentCamera.CFrame = CFrame.lookAt(v811 + new(math.cos(v860) * v862 + math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v866, v865 + math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v866, math.sin(v860) * v862), v811 + new(0, -v834 * 0.6, 0)) * CFrame.Angles(0, 0, 0.3 * p131)
                CurrentCamera.FieldOfView = 62 + 12 * p131 + v844 * 26 + math.max(0, 1 - (p132 - n7) * 2.5) * 10
                ScreenFx.SpeedLines(math.max(v844, (p131 - 0.5) * 0.9), v190)
                mood(p132)

                if v844 >= 0.7 and not v820 then
                    v820 = true
                    burst3D(v811, fromRGB(235, 245, 255), 220)
                    CutsceneFx.Shake(2.4, 0.45)
                    CutsceneFx.Haptic(3)
                    ringAt(v811, 120)
                    ringAt(v811, 40)
                    ringAt(v811, 80)
                    CutsceneFx.Strike(t1.Intro)
                end

                if p131 >= 0.965 and not v821 then
                    v821 = true
                    ScreenFx.Fade(1, 0.1, v149)
                end
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.4)
            UIKit.sound("PovStart", nil)
            run(v213, function(p133, p134) -- line: 2685
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p133, p134)

                if p133 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            ScreenFx.SpeedLines(0)
            v812:Destroy()
            v817:Destroy()
            v222:Destroy()
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            v142 = true
            task.wait(0.12)
        elseif ForceIntro2 == "dive" then
            local Pivot = Model:GetPivot()
            local v878 = GameConfig.WATER_Y - v133.Y - 3
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.Transparency = 1
            Part.Size = Vector3.new(1, 1, 1)
            Part.Parent = workspace
            table.insert(t7, Part)

            local ParticleEmitter = Instance.new("ParticleEmitter")

            ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
            v204 = ColorSequence.new
            ParticleEmitter.Color = v204(fromRGB(225, 245, 255))
            ParticleEmitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.12),
                NumberSequenceKeypoint.new(1, 0.34)
            })
            ParticleEmitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.35),
                NumberSequenceKeypoint.new(1, 1)
            })
            ParticleEmitter.Lifetime = NumberRange.new(0.9, 1.5)
            ParticleEmitter.Speed = NumberRange.new(1, 2.5)
            ParticleEmitter.SpreadAngle = Vector2.new(30, 30)
            ParticleEmitter.Acceleration = Vector3.new(0, 7, 0)
            ParticleEmitter.Rate = 26
            ParticleEmitter.LightEmission = 0.5
            ParticleEmitter.Parent = Part

            local v879, v880, v881 = shadowFish(6, 260)

            v215 = v880.X
            v211 = v880.Y
            v222 = v880.Z

            local v882 = math.max(v215, v211, v222)
            local v883 = 75 + v882 * 0.9

            addEyes(v879)
            Y2 = v882 * 9
            Lighting.FogEnd = math.max(300, Y2)
            v222 = v880.Y * 0.5
            v211 = math.clamp(v222, 2.6, 60)

            local v884 = mysteryMark(v879.PrimaryPart, v211, v880.Y / 2 + v211 * 0.65)
            local v885 = v133.Y + 0.8
            local v886 = false
            local n39 = 0

            v199 = v882 * 0.9

            local v887 = math.max(60, v199)
            local v888 = false

            local function frame(p135, p136) -- line: 2735
                -- upvalues: SEABED_Y (copy), v133 (copy), Model (copy), ColorCorrectionEffect (copy), v149 (copy), mood (copy), Pivot (copy), v878 (copy), Part (copy), ParticleEmitter (copy), v879 (copy), v880 (copy), v881 (copy), v882 (copy), v883 (copy), v884 (copy), v885 (copy), v886 (ref), n39 (ref), v887 (copy), v888 (ref), FishModels (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy), burst3D (copy)
                local v890 = math.min(p135 / 0.33, 1)
                local v891 = v878 * (1 - v890) ^ 2.2
                local v892 = v133 + new(0, v891, 0)

                Model:PivotTo(Pivot + new(0, v891, 0))
                Part.Position = v892

                if v890 >= 1 and not v886 then
                    v886 = true
                    ParticleEmitter.Rate = 0
                    burst3D(new(v133.X, SEABED_Y + 0.3, v133.Z), fromRGB(214, 196, 150), 16)

                    local v894 = 0.7 * (t2[t1.Intro] or 1)

                    UIKit.sound("PovPulse", v894)
                end

                local v897 = v892 + CFrame.Angles(0, math.min(p135, 0.78) * 0.45, 0) * new(3.6, (1 - v890) * 0.6 + 1.5, -5.2)
                local v898 = (p135 - 0.38) / 0.15
                local v899 = (p135 - 0.56) / 0.16
                local v900 = (p135 - 0.78) / 0.22
                local v901 = v892 + Vector3.new(0, 0.25, 0)
                local v902, v903

                if v898 > 0 and v898 < 1 then
                    if n39 == 0 then
                        n39 = 1

                        local v904 = 0.6 * (t2[t1.Intro] or 1)

                        UIKit.sound("CastRelease", v904)
                        UIKit.tween(ColorCorrectionEffect, 0.6, {
                            Brightness = -0.06
                        })
                    end

                    v881(new(v133.X - v883 + v883 * 2 * v898, v885 - v882 * 0.25, v133.Z + v880.X / 2 + math.max(13, v882 * 0.9)), (Vector3.new(1, 0, 0)))
                    v903 = (v898 - 0.5) * 0.16
                    v902 = 0
                elseif v899 > 0 and v899 < 1 then
                    if n39 == 1 then
                        n39 = 2

                        local v910 = 0.5 * (t2[t1.Intro] or 1)

                        UIKit.sound("CastRelease", v910)
                        UIKit.tween(ColorCorrectionEffect, 0.6, {
                            Brightness = -0.12
                        })
                    end

                    v881(new(v133.X + v883 - v883 * 2 * v899, v885, v133.Z + v880.X / 2 + math.max(5.5, v882 * 0.4)), (Vector3.new(-1, 0, 0)))
                    v903 = -(v899 - 0.5) * 0.3
                    v902 = 0
                else
                    if v900 > 0 then
                        if n39 == 2 then
                            n39 = 3

                            local v915 = 0.5 * (t2[t1.Intro] or 1)

                            UIKit.sound("PovPulse", v915)
                        end

                        local Unit = new(v892.X - v897.X, 0, v892.Z - v897.Z).Unit
                        local v921 = math.min(0.6981317007977318, (math.asin((math.clamp(24 / v887, 0, 1)))))
                        local Unit2 = (CFrame.Angles(0, -v921, 0) * Unit + new(0, math.min(0.34, 14 / v887), 0)).Unit

                        v902 = math.clamp((v900 - 0.3) / 0.7, 0, 1) ^ 2.5

                        if v902 > 0 and n39 == 3 then
                            n39 = 4

                            local v926 = 0.45 * (t2[t1.Intro] or 1)

                            UIKit.sound("CastRelease", v926)
                        end

                        local v928 = v892 + Unit2 * (v887 * (1 - math.min(v900 / 0.3, 1) * 0.12) * (1 - v902) + v880.Z * 0.5 * (1 - v902))

                        v881(v928, -Unit2)
                        v901 = (v892 + Vector3.new(0, 0.25, 0)):Lerp(v928, math.min(v900 / 0.25, 1) * 0.6 * (1 - v902))
                        v884.Enabled = v902 < 0.05

                        if p135 >= 0.972 and not v888 then
                            v888 = true
                            ScreenFx.Fade(1, 0.08, v149)
                            CutsceneFx.Strike(t1.Intro)
                        end
                    else
                        local X = v133.X
                        local v931 = SEABED_Y - 900
                        local Z = v133.Z

                        v902 = 0
                        v881(new(X, v931, Z), (Vector3.new(1, 0, 0)))
                    end

                    v903 = 0
                end

                FishModels.Animate(v879, p136, v902 > 0 and 18 or 11, 0.38)

                local v932 = (if not (v886 and p135 < 0.38) then 0 else (1 - (p135 - 0.33) / 0.05) * 0.12) + v902 * 0.35

                CurrentCamera.CFrame = CFrame.lookAt(v897, v901) * CFrame.Angles(0, v903, 0) * CFrame.new(math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v932, math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v932, 0)
                CurrentCamera.FieldOfView = v902 * 14 + 72
                mood(p136)
            end

            frame(0, 0)
            ScreenFx.Fade(0, 0.4)
            UIKit.sound("PovStart", nil)
            v216 = v148 * 1.3
            run(v216, function(p137, p138) -- line: 2809
                -- upvalues: frame (copy), t1 (copy), checkpoint (copy)
                frame(p137, p138)

                if p137 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.Fade(1, 0, v149)
            v884:Destroy()
            v879:Destroy()
            ColorCorrectionEffect.Brightness = 0
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            ColorCorrectionEffect.Enabled = true
            Model:PivotTo(Pivot)
            v142 = true
            task.wait(0.12)
        else
            v213 = v148 * 0.85
            v202 = math.min(v138, 260)
            v205 = v202 * 0.45

            local v937 = 11 + math.min(v205, 120)

            v204 = v202 * 0.1

            local v938 = math.min(v204, 14)

            v205 = v202 * 0.7

            local v939 = math.min(v205, 180)

            v221 = v133.Z + 135 + v202
            v206 = GameConfig.DOCK_Z - 16

            local v940 = math.min(v221, v206)

            v206 = v940 - (v133.Z + v937)

            local v941 = math.max(v206, 20)

            v222 = (135 + v202) * 1.5
            Lighting.FogEnd = math.max(300, v222)
            CurrentCamera.FieldOfView = 92

            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.Transparency = 1
            Part.Size = Vector3.new(12, 7, 4)
            Part.Parent = workspace
            table.insert(t7, Part)
            v206 = Instance.new("ParticleEmitter")
            v206.Texture = "rbxasset://textures/particles/smoke_main.dds"
            v206.Color = ColorSequence.new(fromRGB(230, 245, 255))
            v206.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(1, 0.28)
            })
            v206.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.45),
                NumberSequenceKeypoint.new(1, 1)
            })
            v206.Lifetime = NumberRange.new(1, 1.6)
            v206.Speed = NumberRange.new(0, 0.6)
            v206.Acceleration = Vector3.new(0, 2.5, 0)
            v206.Rate = 34
            v206.Shape = Enum.ParticleEmitterShape.Box
            v206.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
            v206.LightEmission = 0.4
            v206.Parent = Part

            local v942 = false
            local n40 = 0
            local v943 = false

            v206 = {
                fromRGB(255, 170, 60),
                fromRGB(120, 220, 255),
                fromRGB(255, 255, 255),
                fromRGB(255, 120, 160),
                fromRGB(170, 255, 120)
            }

            local t43 = {}

            Y2 = Random.new()

            for i = 1, 14 do
                v198 = Instance.new("Part")
                v198.Size = Vector3.new(0.3, 0.5, 1.2)
                v198.Color = v206[i % #v206 + 1]
                v198.Material = Enum.Material.SmoothPlastic
                v198.Anchored = true
                v198.CanCollide = false
                v198.CanQuery = false
                v198.CastShadow = false
                v198.Parent = workspace
                table.insert(t7, v198)
                v216 = if i % 2 == 0 then 1 else -1
                v207 = {
                    at = nil,
                    part = v198,
                    side = v216
                }
                v217 = v133.X + v216 * Y2:NextNumber(0.6, 3.2)
                Unit = SEABED_Y + 3.3 + v938 + Y2:NextNumber(-1.4, 1.6)
                v201 = v940 - v941 * (0.058 * i + 0.12)
                v207.base = new(v217, Unit, v201)
                t43[i] = v207
            end

            local function povFrame(p139, p140) -- line: 2877
                -- upvalues: SEABED_Y (copy), v133 (copy), mood (copy), n7 (ref), v937 (copy), v938 (copy), v939 (copy), v940 (copy), v941 (copy), Part (copy), v942 (ref), n40 (ref), v943 (ref), t43 (copy), v190 (copy), UIKit (copy), ScreenFx (copy), CurrentCamera (copy), new (copy), t1 (copy), CutsceneFx (copy), t2 (copy)
                local v945 = math.min(p139 / 0.74, 1)
                local v946 = (v945 * 0.85 + v945 * 0.15 * v945) * 0.66
                local v948 = math.clamp((p139 - 0.82) / 0.18000000000000005, 0, 1)
                local v949 = v948 ^ 2.6

                while n40 < 3 and n40 * 0.2 + 0.18 <= p139 do
                    n40 += 1

                    local v950 = n40 * 0.25 + 0.7

                    n7 = p140
                    CutsceneFx.Shake(v950 * 1.25, 0.35)
                    CutsceneFx.Haptic(2)

                    local v951 = 1.4 * (t2[t1.Intro] or 1)

                    UIKit.sound("CastRelease", v951)

                    local v952 = 0.6 * (t2[t1.Intro] or 1)

                    UIKit.sound("PovPulse", v952)
                    UIKit.sound("DeepWhoosh", 1.2)
                end

                local v953 = v946 + v949 * (v937 * 0.72 / v941 + 0.34)
                local v954 = p140 * 3.3
                local v956 = 1 - math.clamp((p139 - 0.592) / 0.148, 0, 1)
                local v960 = (math.sin(v954 * 0.55) * 4.6 + math.sin(v954 * 1.25 + 1.3) * 1.6) * v956
                local v962 = math.sin(v954 * 0.8 + 0.6) * 1.3 * v956
                local v963 = v949 * 1.8 + (if v948 > 0 then 0.2 else 0) + 0.08
                local v971 = new(v133.X + v960, SEABED_Y + 3.3 + v938 - v939 * (1 - math.min(v953 / 0.66, 1)) ^ 1.5 + v962 + math.sin(v954 * 1.4) * 0.3, v940 - v941 * v953)
                local v974 = new(math.cos(v954 * 0.55) * 4.6 * 0.55 * 2.3 * v956, 0, -18)
                local v975 = (v133 + Vector3.new(0, 0.2, 0)):Lerp(v971 + v974, v956 * 0.3)

                CurrentCamera.CFrame = CFrame.lookAt(v971, v975) * CFrame.Angles(0, 0, (math.rad(math.cos(v954 * 0.55) * 9 * v956 + math.sin(v954) * 2))) * CFrame.new(math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v963, math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v963, 0) * CFrame.Angles(0, 0, math.clamp(math.noise(os.clock() * 24, 21.93, 0.5) * 0.9, -0.5, 0.5) * 0.09 * v949)
                CurrentCamera.FieldOfView = math.min(120, 94 - (1 - v956) * 6 * (1 - v948) + v949 * 34 + math.max(0, 1 - (p140 - n7) * 2.5) * 12)
                ScreenFx.SpeedLines(math.max(v949, math.max(0, 1 - (p140 - n7) * 2.5) * 0.5 + 0.3), v190)

                if v948 > 0 and not v942 then
                    v942 = true

                    local v990 = 0.45 * (t2[t1.Intro] or 1)

                    UIKit.sound("CastRelease", v990)
                    UIKit.sound("ReelBurst", 0.8)
                    CutsceneFx.Haptic(3)

                    local v991 = 0.5 * (t2[t1.Intro] or 1)

                    UIKit.sound("PovPulse", v991)
                end

                Part.CFrame = CFrame.new(v971 + Vector3.new(0, 0, -15))

                for v992, v993 in ipairs(t43) do
                    local v995 = new(v993.base.X, v971.Y + (v993.base.Y - (SEABED_Y + 3.3 + v938)), v993.base.Z)

                    if not v993.at and v971.Z - v993.base.Z < 24 then
                        v993.at = p140
                    end

                    if v993.at then
                        local v997 = math.min((p140 - v993.at) / 0.45, 1.6)
                        local v999 = new(v993.side * 13, 2.5, -4) * v997 ^ 0.6

                        v993.part.CFrame = CFrame.lookAt(v995 + v999, v995 + v999 + new(v993.side, 0.2, -0.3)) * CFrame.Angles(0, math.sin(p140 * 24 + v992) * 0.3, 0)
                    else
                        v993.part.CFrame = CFrame.lookAt(v995, v995 + new(v993.side * 0.3, 0, 1)) * CFrame.Angles(0, math.sin(p140 * 9 + v992) * 0.25, 0)
                    end
                end

                mood(p140)

                if p139 >= 0.97 and not v943 then
                    v943 = true
                    CutsceneFx.Shake(2.4, 0.45)
                end
            end

            povFrame(0, 0)
            ScreenFx.Fade(0, 0.4)
            UIKit.sound("PovStart", nil)
            run(v213, function(p141, p142) -- line: 2935
                -- upvalues: povFrame (copy), t1 (copy), checkpoint (copy)
                povFrame(p141, p142)

                if p141 >= 0.5 and t1.PauseAt == "pov" then
                    checkpoint("pov")
                end
            end)
            ScreenFx.SpeedLines(0)
            Lighting.FogColor = DeepSea.DeepColor(v139)
            Lighting.FogStart = 30
            Lighting.FogEnd = 300
            v142 = false
            ColorCorrectionEffect.Enabled = true
        end

        if not CutsceneFx.Struck then
            CutsceneFx.Strike(ForceIntro2)
        end
    end

    local v1007 = os.clock() + 4

    while not v151 and os.clock() < v1007 do
        task.wait(0.05)
    end

    local v1008 = FishModels.Take(p43.fishId, p43.variant, p43.size)

    v213, v202 = v1008:GetBoundingBox()
    v213 = 0.5 * v202.Magnitude

    if v213 > 400 then
        v1008:ScaleTo(v1008:GetScale() * 400 / v213)
        v214, v203 = v1008:GetBoundingBox()
        v1008:SetAttribute("Length", v203.Z)
        v1008:SetAttribute("Height", v203.Y)
        v1008:SetAttribute("Width", v203.X)
    end

    local Length = v1008:GetAttribute("Length")
    local Height = v1008:GetAttribute("Height")

    v1008:PivotTo(CFrame.new(0, 0, 0))
    v214 = FishModels.CenterOffset(v1008)

    local v1009 = v214.Z - Length / 2

    v203 = v133.Y + 0.1 - v214.Y
    v204 = SEABED_Y + 0.4 + Height / 2 - v214.Y

    local v1010 = math.max(v203, v204)

    if GameConfig.WATER_Y - SEABED_Y - 6 < Height then
        v155 = true
    else
        v204 = v1008:GetAttribute("Width") or 0
        v155 = math.max(Length, v204) > 70
    end

    if v155 then
        v138 = v1008:GetAttribute("Width") or 0
        ForceIntro2 = if v138 > 216 then 112 elseif v138 > 104 then 52 else GameConfig.WATER_Y + 1.5
        v1010 = ForceIntro2 + Height / 2 - v214.Y
    end

    local v1011 = CFrame.new

    v203 = v133.X
    v206 = v133.Z

    local v1012 = v1011(v203, v1010, v206 - math.clamp(Length * 0.04, 0.5, 3) - v1009)
    local v1013 = not v125 and Length >= 20

    v221 = if v1013 then Length * 1.2 + 40 else Length * 0.75 + 4
    v1011 = v1012 + new(0, 0, v221)

    local v1014 = v1011

    if v155 then
        v205 = -Height * 1.05 - 6
        v221 = Length * 0.25 + 10
        v1011 = v1012 + new(0, v205, v221)
        v1014 = v1011
    elseif v1013 then
        v206 = Length * 0.5
        v205 = -math.min(v206, 60)
        v1011 += new(0, v205, 0)
        v1014 = v1011
    end

    local Pivot = Model:GetPivot()
    local v1015 = new(v214.X, v214.Y - 0.1, v1009 + math.clamp(Length * 0.04, 0.5, 3))

    local function moveFish(p143) -- line: 2996
        -- upvalues: v133 (copy), Model (copy), Part (copy), v1008 (copy), v155 (ref), Pivot (copy), v1015 (copy), GameConfig (copy), new (copy)
        v1008:PivotTo(p143)

        if not v155 then
            return
        end

        local v1016 = p143 * v1015
        local v1018 = math.max(v1016.Y - v133.Y, 0)
        local v1020 = math.clamp(v1018 / 10, 0, 1)
        local v1024 = new(v133.X + (v1016.X - v133.X) * v1020, v133.Y + v1018, v133.Z + (v1016.Z - v133.Z) * v1020)

        Model:PivotTo(Pivot + (v1024 - v133))

        local v1025 = v1024.Y + 0.9
        local v1028 = math.max(GameConfig.WATER_Y + 0.9, v1025 + v1020 * 400)

        Part.Size = new(0.1, v1028 - v1025, 0.1)
        Part.CFrame = CFrame.new(v1024.X, (v1028 + v1025) / 2, v1024.Z)
    end

    moveFish(v1011)
    v1008.Parent = workspace
    table.insert(t7, v1008)
    v221 = if v125 then nil elseif v127 >= 2 then CutsceneFx.Silhouette(v1008) else nil
    CutsceneFx.ZoneStart(p43.zoneId, v127)
    CutsceneFx.Grade(v122, 0.15 + 0.06 * v127, 0.6)
    v206 = v1010 + v214.Y
    v215 = new(v133.X, v206, v133.Z + 0.4)

    local v1030 = math.max(4.6, Length * 0.5, Height * 0.9)

    v211 = CFrame.lookAt
    v211 = v211(v215 + new(v1030, Height * 0.1 + 0.5, -v1030 * 0.28), v215)
    v222 = new(v133.X, v206 + Height * 0.12, v1012.Z + v214.Z)

    local v1031 = CurrentCamera.ViewportSize.X / math.max(CurrentCamera.ViewportSize.Y, 1)

    v199 = Length * 0.6 / (0.4663076581549986 * math.clamp(v1031, 1, 2.2))
    v198 = Height * 2
    v223 = math.max(v199, v198) + 2
    v222 -= new(0, v223 * 0.15, 0)

    local v1032 = v222

    if v223 + 6 > 13 and not v155 then
        hideNearbyProps(v133, v223 + 6)
    end

    v197 = CFrame.lookAt
    v207 = Height * 0.22 + 0.8
    v200 = -v223 * 0.32

    local v1033 = v197(v222 + new(v223, v207, v200), v222)
    local n41 = 55

    if v1013 then
        if v155 then
            v199 = v206 + Height * 0.45 + 8
        else
            v198 = v206 + Height * 0.5 + 8
            v216 = GameConfig.WATER_Y - 2.5
            v199 = math.min(v198, v216)
        end

        v198 = CFrame.lookAt
        v200 = v133.X
        Unit = v223 * 1.1
        v207 = v200 + math.min(Unit, 54)
        v217 = v133.Z - v223 * 0.8 - 8
        v211 = v198(new(v207, v199, v217), v222)
        n41 = 70

        if not v155 then
            hideNearbyProps(v133, v223 * 1.8 + 20)
        end

        v197 = 70
    else
        v197 = 55
    end

    if v155 then
        if t8 then
            v207 = t8[1]
            v200 = t8[2]
            v217 = t8[3]
            Lighting.FogStart = v207
            Lighting.FogEnd = v200
            Lighting.FogColor = v217
        end

        Lighting.FogStart = 0
        Lighting.FogEnd = 1E+05
        ColorCorrectionEffect.Enabled = false
    end

    v223 = v1008:GetAttribute("Width") or Length * 0.3

    local n42 = 50
    local v1034 = false
    local v1035 = GameConfig.LANE_HALF_WIDTH - 10
    local v1036 = GameConfig.DOCK_Z - GameConfig.MAX_DISTANCE + 15
    local X3, v1037, v1038, v1039, v1040, X4, Y3, v1041, v1042, X5, Y4, Z, v1043, v1044, v1045, v1046, v1047, v1048

    if v155 then
        v200 = v1012.Z + v1009

        if v223 <= 104 then
            hidePropsInBox(v133.X, v223 / 2 + 4, v200 - 4, v200 + Length + 4)
        end

        v217 = v133.X
        v201 = v1012.Z + v214.Z

        local v1049 = new(v217, v206, v201)

        v201 = Length * Length + Height * Height + v223 * v223
        v217 = math.sqrt(v201) * 0.5
        Unit = (Vector3.new(0.64278764, 0.28, -0.76604444)).Unit
        Part2 = v223 / 2
        v219 = Height / 2
        v208 = Length / 2

        local v1050 = new(Part2, v219, v208)

        Part2 = v217 / 0.42261826174069944 * 0.5

        for _ = 1, 60 do
            v218 = v1049 + Unit * Part2
            X3 = v218.X
            X5 = v218.Y
            v1037 = math.max(X5, 34)
            X5 = v218.Z
            v1043 = new(X3, v1037, X5)
            v1037 = Part2 * 0.09
            v222 = v1049 - new(0, v1037, 0)
            v1032 = v222
            v1033 = CFrame.lookAt(v1043, v222)
            v218 = true

            for i = -1, 1, 2 do
                for j = -1, 1, 2 do
                    for k = -1, 1, 2 do
                        v1038 = v1050.X * i
                        v1039 = v1050.Y * j
                        X4 = v1050.Z * k
                        v1040 = v1049 + new(v1038, v1039, X4)
                        X4 = v1040.X
                        Y3 = v1040.Y
                        v210 = GameConfig.WATER_Y - 4
                        v1041 = math.max(Y3, v210)
                        Y3 = v1040.Z
                        v1042 = v1033:PointToObjectSpace((new(X4, v1041, Y3)))
                        v1040 = -v1042.Z

                        local v1051 = true

                        if v1040 < 1 then
                            v1051 = false
                        else
                            v1039 = v1042.X

                            if math.abs(v1039) > v1040 * 0.4663076581549986 * v1031 * 0.9 or v1042.Y > v1040 * 0.4663076581549986 * 0.62 or v1042.Y < -v1040 * 0.4663076581549986 * 0.6 then
                                v1051 = false
                            else
                                v1048 = v218
                            end
                        end

                        if not v1051 then
                            v1048 = false
                        end

                        v218 = v1048
                    end
                end
            end

            if v218 then
                break
            end

            Part2 *= 1.05
        end

        local v1052 = RaycastParams.new()

        v1052.FilterType = Enum.RaycastFilterType.Exclude
        Unit = {
            v1008,
            Model
        }

        for _, v1053 in ipairs(t9) do
            table.insert(Unit, v1053)
        end

        v1052.FilterDescendantsInstances = Unit

        local function blocked(p144) -- line: 3116
            -- upvalues: Length (copy), v1049 (copy), v1052 (copy), new (copy)
            local _ipairs = ipairs
            local v1055 = v1049 + new(0, 0, Length * 0.35)
            local v1056 = Length * 0.35

            for _, v1057 in _ipairs({
                    v1049,
                    v1055,
                    v1049 - new(0, 0, v1056)
                }) do
                local v1058 = workspace:Raycast(v1057, p144 - v1057, v1052)

                if v1058 and v1058.Instance.Transparency < 0.5 and v1058.Instance.LocalTransparencyModifier < 0.5 then
                    return true
                end
            end

            return false
        end

        v219 = 0

        while v219 < 30 and blocked(v1033.Position) do
            v219 += 1
            v1033 = CFrame.lookAt(v1033.Position + Vector3.new(0, 14, 0) + (new(v133.X, v1033.Position.Y, v1033.Position.Z) - v1033.Position) * 0.06, v222)
        end

        t1.CameraRose = v219
        v219 = v1033.Position
        v220 = v219.X

        if math.abs(v220) > 150 or v219.Z < v1036 or v219.Y > 200 then
            v1034 = true

            local function fits(p145, p146) -- line: 3134
                -- upvalues: v1031 (copy), v1049 (copy), v1050 (copy), GameConfig (copy), new (copy)
                local v1061 = math.tan((math.rad(p146 / 2)))

                for i = -1, 1, 2 do
                    for j = -1, 1, 2 do
                        for k = -1, 1, 2 do
                            local v1065 = v1049 + new(v1050.X * i, v1050.Y * j, v1050.Z * k) * 0.75
                            local v1068 = p145:PointToObjectSpace((new(v1065.X, math.max(v1065.Y, GameConfig.WATER_Y - 4), v1065.Z)))
                            local v1069 = -v1068.Z

                            if v1069 < 1 or math.abs(v1068.X) > v1069 * v1061 * v1031 * 0.9 or v1068.Y > v1069 * v1061 * 0.62 or v1068.Y < -v1069 * v1061 * 0.6 then
                                return false
                            end
                        end
                    end
                end

                return true
            end

            v208 = if v133.X > 0 then -1 else 1
            v1048 = v206 - Height * 0.15
            v1043 = GameConfig.WATER_Y + 6
            v220 = math.clamp(v1048, v1043, 64)

            local function aims(p147, p148) -- line: 3152
                -- upvalues: Height (copy), v1049 (copy), fits (copy), new (copy)
                for i = 0, 16 do
                    local v1071 = v1049 + new(0, Height * (i / 16 - 0.6), 0)

                    if fits(CFrame.lookAt(p147, v1071), p148) then
                        return v1071
                    end
                end

                return nil
            end

            v1043 = v217 * 0.6
            v199 = 50
            v1046 = v1049

            local v1072 = nil

            for _ = 1, 160 do
                v1044 = v1049.Z - v1043 * 0.9
                v1040 = v1049.X + v208 * v1043 * 0.42
                v1042 = -v1035
                v1045 = math.clamp(v1040, v1042, v1035)
                v1042 = math.max(v1044, v1036)
                v1046 = new(v1045, v220, v1042)
                v1072 = aims(v1046, 50)

                if v1072 or v1044 <= v1036 or (v1046 - v1049).Magnitude >= 400 then
                    v199 = 50
                    break
                end

                v1043 *= 1.04
                v199 = 50
            end

            while not v1072 and v199 < 100 do
                local v1073 = v199 + 1

                n42 = v1073
                v199 = v1073
                v1072 = aims(v1046, v1073)
            end

            local v1074 = v1072 or v1049

            v1032 = v1074
            v1047 = CFrame.lookAt(v1046, v1074)
            v1037 = require(script.Parent.ZoneAmbience).Looks[p43.zoneId]

            if v1037 and v1037.fog then
                Lighting.FogColor = v1037.fog[1]
            end

            Lighting.FogStart = (v1046 - v1049).Magnitude + v217
            Lighting.FogEnd = Lighting.FogStart + 1500
        else
            v1047 = v1033
        end
    else
        v1047 = v1033
    end

    if Length > 110 and not v155 then
        local v1075 = GameConfig.DOCK_Z - GameConfig.MAX_DISTANCE - 10
        local v1076 = v1012.Z + v1009

        Part2 = v223 * 1.5
        v219 = Height * 2.1

        local v1077 = math.max(Part2, v219, 90) + Length * 0.12

        Part2 = v206 + Height * 0.3
        v219 = GameConfig.WATER_Y - 2.5

        local v1078 = math.min(Part2, v219)

        v219 = v133.X
        v208 = v206 - v1077 * 0.06
        v1043 = Length * 0.3
        X3 = v1077 * 0.6
        v220 = v1076 + math.min(v1043, X3)
        v1032 = new(v219, v208, v220)

        local function front(p149, p150) -- line: 3193
            -- upvalues: v133 (copy), Height (copy), v1032 (ref), v1075 (copy), v1076 (copy), v1077 (copy), v1078 (copy), new (copy)
            return CFrame.lookAt(new(v133.X + p150, v1078 + (p149 - 1) * Height * 0.3, (math.max(v1076 - v1077 * p149, v1075))), v1032)
        end

        v219 = CFrame.lookAt
        v220 = v133.X + 52
        v1048 = v1078 + 0 * Height * 0.3
        X3 = v1076 - v1077 * 1
        v1043 = math.max(X3, v1075)
        v1047 = v219(new(v220, v1048, v1043), v1032)

        if v1013 then
            v219 = CFrame.lookAt
            v220 = v133.X + 54
            v1048 = v1078 + 0.5 * Height * 0.3
            X3 = v1076 - v1077 * 1.5
            v1043 = math.max(X3, v1075)
            v211 = v219(new(v220, v1048, v1043), v1032)
        end

        hideNearbyProps(v133, v1077 * 1.6 + Length, v155)
        v1048 = v1077 * 2 + Length
        Lighting.FogEnd = math.max(300, v1048)
    end

    if v1013 then
        v211 = CFrame.lookAt(v133 + Vector3.new(4.6, 1.8, -7.5), v133 + Vector3.new(0, 0.4, 0))
        n41 = 58
        v197 = 58
    end

    if v155 then
        DeepSea.Surface()
    else
        v217 = Length * Length + Height * Height + v223 * v223
        v206 = math.sqrt(v217) * 0.5
        v200 = DeepSea.Track
        v208 = (v1047.Position - v1032).Magnitude * 0.9 + v206 + 26
        v200(v1008, v214, v206, (math.max(64, v208)))
    end

    CurrentCamera.FieldOfView = v197
    CurrentCamera.CFrame = v211

    if v155 then
        CutsceneFx.Muffle(false, 0.2)
    end

    if not v125 and v155 and (v1013 and v127 >= 2 or v121.index >= 7) then
        v200 = CutsceneFx.Buddy(CFrame.new(v133.X + 9, GameConfig.WATER_Y + 4.4, v1012.Z + v1009 - 14) * CFrame.Angles(0, 3.141592653589793, 0), true)

        if v200 then
            table.insert(t7, v200)
        end
    end

    setVignette(v123, n3 == 0 and 0.45 or 0.55, 0.2)

    if v125 or v142 then
        ScreenFx.Fade(0, 0.3)
    end

    local v1083, v1084 = makeLetters(v118.name)

    v8.Visible = true
    v21.Visible = true
    UIKit.pop(v8, 0.7)
    UIKit.sound("CloseUp", nil)

    local elapsed = os.clock()

    v201 = (math.log10((math.max(p43.odds or 1, 1))) - 2) / 6
    v212 = math.clamp(v201, 0, 1)

    if v1013 then
        v212 = math.max(v212, 0.4)
    end

    if v155 then
        v212 = math.max(v212, 0.7)
    end

    t1.Drama = v212

    local v1085, v1086, v1087

    if v125 then
        Unit = 0.25
        v201 = 0.5
        v1087 = true
    else
        Unit = if v1013 then (v212 * 0.9 + 1) * 2 / 1 else (v212 * 0.9 + 1) * 0.6 / 1
        v1085 = if n3 == 2 then 0.5 else 0
        v201 = (1.5 + v1085) * (v212 * 1.3 + 1) / 1

        if v127 == 0 then
            v1086 = if v1013 then 0.45 else 0.8
            v1087 = false
        else
            v1087 = true
        end
    end

    local v1088, v1089, v1090

    if v1087 then
        v1089 = Unit
        v1090 = v201

        if v125 then
        elseif v127 == 1 then
            v1088 = if v1013 then 0.6 else 0.9
            v1089 = Unit * v1088
            v1090 = v201 * 0.9
        end
    else
        v1089 = Unit * v1086
        v1090 = v201 * 0.75
    end

    local v1091, v1092 = v134:Pace(v1089, v1090)
    local v1093 = v1091 + v1092

    v1048 = math.floor(p43.odds or 1)
    t6.final = math.max(1, v1048)
    t6.tier = 0
    v27.Text = ""
    v24.Visible = true
    oddsSet(1)
    UIKit.pop(v24, 0.7)

    if v1013 then
        UIKit.sound("Riser", 0.7)
    end

    if v125 or not v155 then
        if not v125 and v1013 and v127 >= 3 then
            CutsceneFx.Hold("WaterSurge", 1)
        end
    else
        CutsceneFx.Hold("WaterSurge", 0.75)
        UIKit.sound("SubBoom", 0.85)
        UIKit.sound("DeepRumble", 0.55)
    end

    run(v1091, function(p151) -- line: 3279
        -- upvalues: v211 (ref), v1008 (copy), v1012 (copy), v1013 (copy), v1014 (ref), moveFish (copy), v1030 (copy), elapsed (copy), v1091 (copy), v1093 (copy), FishModels (copy), CurrentCamera (copy), t6 (copy), oddsSet (copy)
        local v1094 = if v1013 then p151 * p151 * (3 - 2 * p151) else 1 - (1 - p151) ^ 3
        local v1095 = os.clock() - elapsed

        moveFish(v1014:Lerp(v1012, v1094) * CFrame.Angles(0, math.sin(v1095 * 12 + 1.2) * -0.035 * (1 - v1094), math.sin(v1095 * 6) * 0.03 * (1 - v1094)))
        FishModels.Animate(v1008, v1095, 12 - 5 * v1094, 0.42 - 0.08 * v1094)

        local v1100 = p151 * v1091 / v1093

        oddsSet(t6.final ^ (math.clamp(v1100, 0, 1) * 0.96))

        if v1013 then
            local v1101 = 0.15 + 0.5 * p151
            local v1102 = v211

            CurrentCamera.CFrame = v1102 * CFrame.new(math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v1101, math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v1101, 0)
        else
            local v1106 = v211
            local new = CFrame.new
            local v1107 = v1030 * -0.06
            local v1108 = math.clamp(p151, 0, 1)

            CurrentCamera.CFrame = v1106 * new(0, 0, v1107 * (v1108 * v1108 * v1108 * (v1108 * (v1108 * 6 - 15) + 10)))
        end
    end)
    v1088 = CurrentCamera.CFrame

    if v221 then
        v221()
    end

    v134:Light(v1008, v214, math.sqrt(Length * Length + Height * Height + (v1008:GetAttribute("Width") or 0) ^ 2) * 0.5, PointLight)

    if not v155 then
        v134:DarkenSea(DeepSea)
    end

    checkpoint("closeup")
    v219 = v9
    v219.Position = UDim2.fromScale(-0.6, 0.79)
    v9.Visible = true
    UIKit.tween(v9, 0.5, {
        Position = UDim2.fromScale(0.5, 0.79)
    })
    UIKit.sound("Riser", nil)

    if v120.id == "Void" then
        CutsceneFx.Drain(v1092)
    end

    if v127 >= 4 and not v125 then
        UIKit.sound("StingSweep", nil)
    end

    local v1109 = not v125 and v127 >= 4 and not t1.NoBreath

    if not v125 and v127 >= 3 then
        CutsceneFx.Release("WaterSurge", 0.8)
        CutsceneFx.Hold("DrumRoll", v127 >= 4 and 1.08 or 1)
        CutsceneFx.Bend("DrumRoll", nil, 0.25)
        CutsceneFx.Hold("TensionRiser", 1, v1092)

        if v1109 then
            CutsceneFx.Hold("NoiseBuild", 1, v1092)
        end

        CutsceneFx.Duck(v1092 + 3)
    end

    local n43 = 0
    local v1111 = math.max(#v1084 - 1, 0)
    local v1110 = v1088.Position

    v1043 = v1088.LookVector
    v1037 = (v1088.Position - v1032).Magnitude
    v208 = v1110 + v1043 * math.max(v1037, 1)

    local v1112 = v208

    if not v1013 then
        v208 = v215
        v1112 = v215
    end

    local v1113 = v1088.Position - v208
    local v1114 = v1047.Position - v1032

    run(v1092, function(p152) -- line: 3341
        -- upvalues: v124 (ref), v127 (copy), v134 (copy), v1008 (copy), Height (copy), v1012 (copy), moveFish (copy), v1032 (ref), n41 (ref), n42 (ref), v1034 (ref), v1035 (copy), v1036 (copy), v1083 (copy), v1084 (copy), elapsed (copy), v1091 (copy), v1092 (copy), v1093 (copy), n43 (ref), v1111 (copy), v1112 (ref), v1113 (copy), v1114 (copy), FishModels (copy), CurrentCamera (copy), new (copy), t1 (copy), CutsceneFx (copy), t6 (copy), checkpoint (copy), landLetter (copy), oddsSet (copy)
        local v1115 = math.clamp(p152, 0, 1)
        local v1116 = v1115 * v1115 * v1115 * (v1115 * (v1115 * 6 - 15) + 10)
        local v1117 = v1112:Lerp(v1032, v1116)
        local v1118 = v1113.Unit:Lerp(v1114.Unit, v1116)

        if v1118.Magnitude < 0.05 then
            v1118 = v1114.Unit
        end

        local v1119 = v1113.Magnitude + (v1114.Magnitude - v1113.Magnitude) * v1116
        local v1120 = v1117 + v1118.Unit * v1119

        if v1034 then
            v1120 = new(math.clamp(v1120.X, -v1035, v1035), math.min(v1120.Y, 56), (math.max(v1120.Z, v1036)))
        end

        CurrentCamera.CFrame = CFrame.lookAt(v1120, v1117)
        CurrentCamera.FieldOfView = n41 - (n41 - n42) * v1116

        local v1125 = (v1091 + p152 * v1092) / v1093

        oddsSet(t6.final ^ (math.clamp(v1125, 0, 1) * 0.96))

        local v1126 = os.clock() - elapsed

        FishModels.Animate(v1008, v1126, 7, 0.34)
        moveFish(v1012 * CFrame.Angles(math.sin(v1126 * 1.1) * 0.02, math.sin(v1126 * 1.6) * 0.035, math.sin(v1126 * 1.3) * 0.02) + new(0, math.sin(v1126 * 2.4) * math.max(0.12, Height * 0.008), 0))
        v134:Step(v1126)

        local Bend, v1137

        if not v124 and v127 >= 3 then
            Bend = CutsceneFx.Bend
            v1137 = if v127 >= 4 then 1.08 else 1
            Bend("DrumRoll", v1137 + 0.18 * p152, 0.25 + 0.85 * p152 ^ 1.4)
        end

        local v1139 = math.floor(p152 * v1111 + 0.001)

        while n43 < v1139 do
            n43 += 1
            landLetter(v1083[v1084[n43]], n43, #v1084)
        end

        local v1140 = n43

        if math.ceil(v1111 / 2) <= v1140 and t1.PauseAt == "letters" then
            checkpoint("letters")
        end
    end)
    CutsceneFx.Muffle(false, 0.06)
    CutsceneFx.HoldOff()
    CutsceneFx.Release("DrumRoll", 0.04)
    CutsceneFx.Release("TensionRiser", 0.06)
    CutsceneFx.Release("NoiseBuild", 0.04)
    CutsceneFx.Release("WaterSurge", 0.3)
    t1.FakedOut = false
    t1.Breathed = false

    if not v124 and v127 >= 4 and CutsceneFx.FakeOutRoll() then
        t1.FakedOut = true
        v1110 = fromRGB(190, 195, 205)
        v1085 = v8
        v1085.Visible = false
        v1085 = v9
        v1085.Visible = false
        v1085 = v11
        v1085.Text = ""
        v1085 = v13
        v1085.Text = "$?/s"
        v1085 = v14
        v1085.Text = "Common"
        v1085 = v15
        v1085.Visible = false
        v1085 = v12
        v1085.Text = string.upper(v118.name)
        v1085 = v12
        v1085.TextColor3 = fromRGB(255, 255, 255)
        v1085 = UIGradient
        v1085.Color = ColorSequence.new(v1110)
        v1085 = v22
        v1085.ImageColor3 = v1110
        v1085 = v20
        v1085.Text = "COMMON"
        v1085 = v19
        v1085.Position = UDim2.new(0.5, 0, 0, 26)
        v1085 = v19:FindFirstChildOfClass("UIGradient")

        if v1085 then
            v1085.Color = ColorSequence.new(v1110, fromRGB(150, 155, 168))
        end

        v1048 = v10
        v1048.Visible = true
        v1048 = v24
        v1048.Visible = false
        CutsceneFx.GradeOff(0.2)
        checkpoint("fake")
        UIKit.sound("Reveal", 0.8)
        CutsceneFx.Hold("ReverseSwell", 1, 0.95)
        run(0.95, function() -- line: 3412
            -- upvalues: v1008 (copy), v1012 (copy), moveFish (copy), elapsed (copy), FishModels (copy)
            local v1142 = os.clock() - elapsed

            FishModels.Animate(v1008, v1142, 7, 0.34)
            moveFish(v1012 * CFrame.Angles(0, math.sin(v1142 * 1.6) * 0.035, 0))
        end)
        CutsceneFx.Release("ReverseSwell", 0.03)
        CutsceneFx.Crack()
        UIKit.sound("SubBoom", 1.15)
        CutsceneFx.HitStop(0.16)
        run(0.22, function() -- line: 3421
            -- upvalues: v10 (ref)
            local v1144 = (math.random() - 0.5) * 16

            v10.Rotation = v1144 * 0.2
        end)
        v1048 = v10
        v1048.Rotation = 0
        v1048 = v24
        v1048.Visible = true
    elseif v1109 then
        t1.Breathed = true

        local FieldOfView = CurrentCamera.FieldOfView

        setVignette(v149, 0.35, 0.30400000000000005)
        run(0.38, function(p153) -- line: 3432
            -- upvalues: v1008 (copy), elapsed (copy), FieldOfView (copy), FishModels (copy), CurrentCamera (copy)
            local v1146 = os.clock() - elapsed

            FishModels.Animate(v1008, v1146, 4, 0.3)
            CurrentCamera.FieldOfView = FieldOfView - 4 * p153 * p153
        end)
    end

    v8.Visible = false
    v9.Visible = false

    for _, child in ipairs(v8:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    RunService.RenderStepped:Wait()
    ScreenFx.Flash(n3 == 2 and 0.6 or 0.4)
    v134:Reveal(Length, Height)
    v1110 = if n3 == 2 then "RevealRare" elseif n3 == 1 then "RevealGood" else "Reveal"

    local v1147

    if v1110 == "Splash" then
        CutsceneFx.Strike(t1.Intro)
    else
        if v1110 == "PovPulse" or v1110 == "CastRelease" then
            v1147 = 1 * (t2[t1.Intro] or 1)
        end

        UIKit.sound(v1110, v1147)
    end

    CutsceneFx.Sting(v127)
    CutsceneFx.Grade(v122, 0.3 + 0.1 * v127, 0.25)
    CutsceneFx.Mutation(v120.id)
    CutsceneFx.Haptic(1 + v127)
    v8.Visible = false
    v9.Visible = false
    oddsSet(t6.final)
    UIKit.pop(v24, 1.35)
    setVignette(nil, n3 == 0 and 0.15 or 0.4, 0.3)

    local t44 = {}

    if v120.index >= 2 then
        X5 = v120.Color
        Y4 = string.format
        v1046 = X5.R * 255 + 0.5
        v1044 = math.floor(v1046)
        v1045 = X5.G * 255 + 0.5
        v1046 = math.floor(v1045)
        v1040 = X5.B * 255 + 0.5
        Y4 = Y4("#%02X%02X%02X", v1044, v1046, (math.floor(v1040)))
        X5 = string.upper
        table.insert(t44, ("<font color=\"%s\">%s</font>"):format(Y4, X5(v120.id)))
    end

    if v121.index ~= Sizes.NORMAL_INDEX then
        v1043 = string.upper
        X3 = v121.id
        table.insert(t44, v1043(X3))
    end

    v1110 = v11
    v1110.Text = table.concat(t44, "  ")
    v1110 = v12
    v1110.Text = string.upper(v118.name)

    local function brightness(p154) -- line: 3472
        return 0.3 * p154.R + 0.59 * p154.G + 0.11 * p154.B
    end

    v118 = if v119.order >= 3 then v119.Color else fromRGB(255, 255, 255)

    if brightness(v118) < 0.45 then
        v1147 = v119.Color2
        v118 = if brightness(v1147) >= 0.45 then v119.Color2 else v118:Lerp(fromRGB(255, 255, 255), 0.72)
    end

    v12.TextColor3 = v118
    v1110 = v12:FindFirstChildOfClass("UIStroke")

    if v1110 and v1110:GetAttribute("Normal") then
        v1110.Color = v1110:GetAttribute("Normal")
    end

    v120 = v12.TextColor3
    v1110 = v22

    if v119.order >= 3 then
        v1110.ImageColor3 = v120
    else
        v1110.ImageColor3 = v122
    end

    v1110 = UIGradient
    v1110.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v120),
        ColorSequenceKeypoint.new(0.38, v120),
        ColorSequenceKeypoint.new(0.5, v120:Lerp(fromRGB(255, 255, 255), 0.8)),
        ColorSequenceKeypoint.new(0.62, v120),
        ColorSequenceKeypoint.new(1, v120)
    })
    v1110 = UIGradient
    v1110.Offset = Vector2.new(-1, 0)
    v1110 = v12
    v1110.TextColor3 = fromRGB(255, 255, 255)
    v1110 = v13
    v1110.Text = NumberFormat.rate(p43.income)
    v1110 = v14
    v1110.Text = ("%s   •   %s   •   %s"):format(v119.name, NumberFormat.weight(p43.kg), NumberFormat.odds(p43.odds))

    if (p43.trainXp or 0) > 0 then
        v1110 = v14
        v1110.Text ..= "   •   +" .. NumberFormat.abbr(p43.trainXp) .. " XP"
    end

    v1110 = v15
    v1110.Visible = p43.isNew == true
    v10.Visible = true
    v1110 = v20
    v1110.Text = string.upper(v119.name)

    if #t44 > 0 then
        v118 = v10.AbsoluteSize.X
        v1043 = if v118 > 0 then v11.TextBounds.X * v10.Size.X.Offset / v118 else 500
        v118 = v19.Size.X.Offset + 28 + v1043
        v1110 = -v118 / 2 + v19.Size.X.Offset / 2
        v1147 = v118 / 2 - v1043 / 2
    else
        v1110 = 0
        v1147 = 0
    end

    v1043 = v19
    v1043.Position = UDim2.new(0.5, v1110, 0, 26)
    v1043 = v11
    v1043.Position = UDim2.fromOffset(v1147, 0)
    v1147 = v19:FindFirstChildOfClass("UIGradient")

    if v1147 then
        v1147.Color = ColorSequence.new(v119.Color, v119.Color2)
    end

    v1147 = UIKit.scaleOf(v19)
    v1147.Scale = 2.8
    UIKit.tween(v1147, 0.24, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    UIKit.pop(v12, 1.7)
    UIKit.pop(v13, 1.4)
    v1110 = UIKit.scaleOf(v22)
    v1110.Scale = 0.3
    UIKit.tween(v1110, 0.45, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    v1147 = v14
    v1147.Position = UDim2.fromOffset(0, 292)
    v14.TextTransparency = 1

    local UIStroke = v14:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Transparency = 1
    end

    task.delay(0.2, function() -- line: 3534
        -- upvalues: UIStroke (copy), UIKit (copy), v14 (ref)
        UIKit.tween(v14, 0.35, {
            TextTransparency = 0,
            Position = UDim2.fromOffset(0, 266)
        }, Enum.EasingStyle.Back)

        if UIStroke then
            UIKit.tween(UIStroke, 0.35, {
                Transparency = 0
            })
        end
    end)

    if #t44 > 0 then
        UIKit.pop(v11, 1.6)
    end

    task.defer(function() -- line: 3544
        -- upvalues: UIKit (copy), v7 (ref), v12 (ref), v15 (ref)
        v15.Position = UDim2.new(0.5, v12.TextBounds.X / 2 / math.max(v7.FitScale.Scale, 0.01) + 120, 0, 84)

        if v15.Visible then
            UIKit.pop(v15, 2)
        end
    end)
    v18.Visible = true
    v1110 = v18
    v1110.Size = UDim2.fromOffset(200, 200)
    v1110 = v18:FindFirstChildOfClass("UIStroke")
    v1110.Transparency = 0
    v1110.Color = v122
    UIKit.tween(v18, 0.7, {
        Size = UDim2.fromOffset(2200, 2200)
    })
    UIKit.tween(v1110, 0.7, {
        Transparency = 1
    })
    burst2D(v122, n3 == 2 and 34 or 18)
    burst3D(v1032, v122, n3 == 2 and 90 or 40)
    v1110 = Instance.new("Part")
    v1110.Anchored = true
    v1110.CanCollide = false
    v1110.CanQuery = false
    v1110.CanTouch = false
    v1110.Transparency = 1
    v1110.Size = Vector3.new(1, 1, 1)
    v1147 = CurrentCamera.CFrame.Position
    v1085 = (v1032 - v1147).Unit
    v1147 = CFrame.new
    X3 = v1085 * math.max(Length, Height) * 0.6
    v1110.CFrame = v1147(v1032 + X3)
    v1110.Parent = workspace
    v1085 = Instance.new("BillboardGui")
    v1085.LightInfluence = 0
    v1085.AlwaysOnTop = false
    v1147 = math.max(Length, Height) * 2.4 + 6
    v1085.Size = UDim2.fromScale(v1147, v1147)
    v1085.Parent = v1110
    v1147 = Instance.new("ImageLabel")
    v1147.BackgroundTransparency = 1
    v1147.Image = UIKit.Art.Glow
    v1147.ImageColor3 = v122:Lerp(fromRGB(255, 255, 255), 0.35)
    v1147.ImageTransparency = 0.05
    v1147.AnchorPoint = Vector2.new(0.5, 0.5)
    v1147.Position = UDim2.fromScale(0.5, 0.5)
    v1147.Size = UDim2.fromScale(0.4, 0.4)
    v1147.Parent = v1085
    UIKit.tween(v1147, 0.7, {
        ImageTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })
    Debris:AddItem(v1110, 0.8)

    if n3 >= 1 then
        task.delay(0.16, function() -- line: 3590
            -- upvalues: Debris (copy), UIKit (copy), fromRGB (copy), v7 (ref), v18 (ref)
            local clone = v18:Clone()

            clone.Name = "Ring2"
            clone.Size = UDim2.fromOffset(160, 160)
            clone.Visible = true
            clone.Parent = v7

            local UIStroke = clone:FindFirstChildOfClass("UIStroke")

            UIStroke.Transparency = 0.2
            UIStroke.Color = fromRGB(255, 255, 255)
            UIKit.tween(clone, 0.8, {
                Size = UDim2.fromOffset(2500, 2500)
            })
            UIKit.tween(UIStroke, 0.8, {
                Transparency = 1
            })
            Debris:AddItem(clone, 0.9)
        end)
    end

    if n3 == 2 then
        confetti(70, v122, v119.Color)
    elseif p43.isNew == true then
        confetti(34, v122, v119.Color)
    end

    if n3 >= 1 then
        v1110 = v17
        v1110.Visible = true

        for _, child in ipairs(v17:GetChildren()) do
            child.BackgroundColor3 = v122
            child.BackgroundTransparency = n3 == 2 and 0.78 or 0.88
        end
    end

    v1110 = require(script.Parent.SkipButton)
    v1110.Hide("reveal")

    local v1150

    if CutsceneFx.Rush then
        CutsceneFx.Rush = false
        v1110.Cover(false, 0.35)
        v1110 = if n3 >= 1 then "RevealRare" else "RevealGood"

        if v1110 == "Splash" then
            CutsceneFx.Strike(t1.Intro)
        else
            if v1110 == "PovPulse" or v1110 == "CastRelease" then
                v1150 = 1 * (t2[t1.Intro] or 1)
            end

            UIKit.sound(v1110, v1150)
        end
    end

    checkpoint("revealed")
    v1043 = if n3 == 2 then 1.3 else 0.6
    v1110 = v134:MinHold(v1043)
    v23 = false
    t1.Waiting = true
    v1085 = os.clock()
    v1150 = if n3 == 2 then 0.6 elseif n3 == 1 then 0.3 else 0.16
    X3, v1037 = v134:Shake(v1150, 0.4)

    local v1151 = tonumber(p43.income) or 0
    local v1152 = if math.random() < 0.5 then -1 else 1

    X5 = false
    Y4 = 0

    while true do
        Z = os.clock() - v1085
        v1044 = os.clock() - elapsed
        FishModels.Animate(v1008, v1044, 7, 0.34)
        v1038 = v1044 * 1.6
        v1040 = math.sin(v1038) * 0.035
        X4 = Z * 1.3
        v1038 = math.sin(X4) * 0.09
        X4 = Z / 0.8
        v1045 = v1040 + v1038 * math.min(X4, 1)
        v1039 = Z * 22
        v1042 = math.sin(v1039) * 0.2
        X4 = 1 - Z / 0.45
        v1046 = v1045 + v1042 * math.max(0, X4)
        v1038 = CFrame.Angles
        v1041 = v1044 * 1.1
        v1039 = math.sin(v1041) * 0.02
        v210 = v1044 * 1.3
        v1042 = v1012 * v1038(v1039, v1046, math.sin(v210) * 0.02)
        Y3 = v1044 * 2.4
        v1041 = math.sin(Y3)
        X4 = v1041 * math.max(0.12, Height * 0.008)
        moveFish(v1042 + new(0, X4, 0))
        v1046 = if Z < X3 then (1 - Z / X3) ^ 2 * v1037 else 0
        v134:Step(v1044)
        v1040 = Z / 7
        v1045 = math.min(v1040, 1)
        v1040 = math.clamp(v1045, 0, 1)
        v1044 = v1040 * v1040 * v1040 * (v1040 * (v1040 * 6 - 15) + 10)
        v1042 = v1044 * 0.2
        v1041 = Z * 0.4
        v1045 = v1152 * (v1042 + 0.03 * math.sin(v1041))
        v1040 = v1047.Position - v1032
        Y3 = Z * 0.85
        v1039 = math.sin(Y3) * v1040.Magnitude * 0.008
        v1042 = new(0, v1039, 0)
        X4 = CFrame.Angles(0, v1045, 0) * v1040 * (1 - 0.06 * v1044)
        v1038 = v1032 + X4 + v1042

        if v1034 then
            v1041 = v1038.X
            Y3 = -v1035
            X4 = math.clamp(v1041, Y3, v1035)
            v1041 = v1038.Y
            v210 = v1038.Z
            Y3 = math.max(v210, v1036)
            v1038 = new(X4, v1041, Y3)
        end

        Y3 = CFrame.lookAt(v1038, v1032)
        v210 = CFrame.new
        v1041 = Y3 * v210(math.clamp(math.noise(os.clock() * 24, 7.31, 0.5) * 0.9, -0.5, 0.5) * v1046, math.clamp(math.noise(os.clock() * 24, 14.62, 0.5) * 0.9, -0.5, 0.5) * v1046, 0)
        Y3 = CFrame.Angles
        v209 = math.noise(os.clock() * 24, 21.93, 0.5) * 0.9
        CurrentCamera.CFrame = v1041 * Y3(0, 0, math.clamp(v209, -0.5, 0.5) * v1046 * 0.06)
        DeepSea.Step()
        v1039 = v17
        v1039.Rotation = Z * 22
        X4 = 1 - Z / 0.45
        v1038 = math.max(0, X4)
        v1041 = 7 * v1038 * v1038
        CurrentCamera.FieldOfView = n42 - v1041
        v1039 = v22
        v1039.ImageTransparency = 0.62 + math.sin(Z * 2.2) * 0.12
        v1039 = UIGradient
        v1039.Offset = Vector2.new(Z * 0.55 % 1.9 - 0.95, 0)

        local v1156 = X5
        local v1157 = Y4

        if not X5 then
            local v1159 = math.min(Z / 0.75, 1)
            local v1160 = v1151 * (1 - (1 - v1159) ^ 3)
            local v1158 = v13
            local rate = NumberFormat.rate

            if v1160 < 1E+15 then
                Y3 = v1160 + 0.5
                v1160 = math.floor(Y3)
            end

            v1158.Text = rate(v1160)

            if Z - Y4 > 0.07 and v1159 < 1 then
                v1157 = Z
                v1039 = v1159 + 1
                UIKit.sound("LuckTick", v1039)
            end

            if v1159 >= 1 then
                v1039 = v13
                v1039.Text = NumberFormat.rate(p43.income)
                UIKit.pop(v13, 1.35)
                v1156 = true
                UIKit.sound("Cash", nil)
            end
        end

        oddsSet(t6.final)

        if not (v1110 <= Z) then
            v23 = false
            RunService.RenderStepped:Wait()
            X5 = v1156
            Y4 = v1157
            continue
        end

        v1039 = v16
        v1039.Text = Pad.Using() and "PRESS TO CONTINUE" or "TAP TO CONTINUE"
        v1039 = v16
        v1039.Visible = true
        v1039 = v16
        v210 = Z * 5
        v1039.TextTransparency = math.sin(v210) * 0.25 + 0.25

        if v23 or t1.AUTO_CONTINUE <= Z or v1110 + 1.6 <= Z and t1.AutoHold ~= nil and t1.AutoHold() then
            break
        end

        Y4 = v1157
        RunService.RenderStepped:Wait()
        X5 = v1156
    end

    t1.Waiting = false
    Z = v13
    Z.Text = NumberFormat.rate(p43.income)
    UIKit.sound("Continue", nil)
    ScreenFx.Fade(1, 0.5, fromRGB(255, 255, 255))
    task.wait(0.5)
    t1.Cleanup()
    FishModels.ClearWarm()
end

function t1.Tap() -- line: 3708
    -- upvalues: v23 (ref)
    v23 = true
end

function t1.Init() -- line: 3712
    -- upvalues: UserInputService (copy), t1 (copy), v23 (ref), buildGui (copy)
    buildGui()
    UserInputService.InputBegan:Connect(function(p155) -- line: 3714
        -- upvalues: t1 (copy), v23 (ref)
        if t1.Waiting then
            local UserInputType = p155.UserInputType

            if UserInputType == Enum.UserInputType.MouseButton1
                or UserInputType == Enum.UserInputType.Touch
                or p155.KeyCode == Enum.KeyCode.Space
                or p155.KeyCode == Enum.KeyCode.Return
                or p155.KeyCode == Enum.KeyCode.ButtonA
                or p155.KeyCode == Enum.KeyCode.E then
                v23 = true
            end
        end
    end)
end

return t1
