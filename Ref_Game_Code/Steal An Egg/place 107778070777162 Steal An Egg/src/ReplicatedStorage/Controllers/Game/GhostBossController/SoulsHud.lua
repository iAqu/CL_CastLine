-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Hud = require(ReplicatedStorage.Client.Hud)
local v1 = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1
local t2 = {}
local n1 = 0
local n2 = 0
local v3 = false
local tween
local n3 = 0
local n4 = 0
local connection
local v4 = Random.new()
local t3 = {}

local function sound(...) -- line: 75
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    for _, v5 in { ... } do
        Assets = if Assets then Assets:FindFirstChild(v5) else nil
    end

    return if Assets and Assets:IsA("Sound") then Assets else nil
end

local function child(p1, p2, p3) -- line: 83
    local v6 = p1:FindFirstChild(p2)

    return if v6 and v6:IsA(p3) then v6 else nil
end

local function bind() -- line: 88
    -- upvalues: Hud (copy), t1 (ref)
    if t1 and t1.Slot.Parent then
        return t1
    end

    local Frame = Hud.Frame
    local Game, Game2 = pcall(Frame, "Game")

    if Game then
        local BottomLeft = Game2:FindFirstChild("BottomLeft")

        if BottomLeft then
            BottomLeft = BottomLeft:FindFirstChild("Souls")

            if not (BottomLeft and BottomLeft:IsA("GuiObject")) then
                BottomLeft = nil
            end
        end

        local Row = BottomLeft

        if BottomLeft then
            Row = BottomLeft:FindFirstChild("Row")

            if not (Row and Row:IsA("GuiObject")) then
                Row = nil
            end
        end

        local Icon, Value

        if Row then
            Icon = Row:FindFirstChild("Icon")

            if not (Icon and Icon:IsA("GuiObject")) then
                Icon = nil
            end

            Value = Row:FindFirstChild("Value")

            if not (Value and Value:IsA("TextLabel")) then
                Value = nil
            end
        else
            Value = Row
            Icon = Row
        end

        local FlyIcon = BottomLeft

        if BottomLeft then
            FlyIcon = BottomLeft:FindFirstChild("FlyIcon")

            if not (FlyIcon and FlyIcon:IsA("GuiObject")) then
                FlyIcon = nil
            end
        end

        if BottomLeft ~= nil and Row ~= nil and Icon ~= nil and Value ~= nil and FlyIcon ~= nil then
            local Pulse = Icon:FindFirstChild("Pulse")

            if not Pulse or not Pulse:IsA("UIScale") then
                Pulse = nil
            end

            if Pulse == nil then
                Pulse = Instance.new("UIScale")
                Pulse.Name = "Pulse"
                Pulse.Parent = Icon
            end

            local t4 = {
                Screen = Hud.Screen(),
                Slot = BottomLeft,
                Row = Row,
                Icon = Icon,
                IconScale = Pulse
            }
            local Glow = Row:FindFirstChild("Glow")

            t4.Glow = if not (Glow and Glow:IsA("ImageLabel")) then nil else Glow
            t4.Value = Value

            local Pulse2 = Value:FindFirstChild("Pulse")

            t4.ValueScale = if not (Pulse2 and Pulse2:IsA("UIScale")) then nil else Pulse2
            t4.FlyIcon = FlyIcon
            t1 = t4

            return t1
        end

        warn("HUD.GameHUD.BottomLeft.Souls needs Row.Icon, Row.Value and FlyIcon")
    end

    return nil
end

local function format(p4) -- line: 126
    -- upvalues: Simple (copy)
    local v9 = math.max(math.floor(p4 + 0.5), 0)

    if v9 > 99999 then
        return (Simple.FormatCompact(v9))
    end

    return (Simple.Format(v9))
end

local function setting(p5, p6, p7) -- line: 133
    local Attribute = p5.Slot:GetAttribute(p6)

    if type(Attribute) == "number" then
        return Attribute
    end

    return p7
end

local function slide(p8, p9) -- line: 138
    -- upvalues: TweenService (copy), v3 (ref), tween (ref)
    local tween2 = tween

    if tween2 then
        tween2:Cancel()
    end

    local SlideSeconds = p8.Slot:GetAttribute("SlideSeconds")

    if type(SlideSeconds) ~= "number" then
        SlideSeconds = 0.45
    end

    local ShownX, v10

    if p9 then
        ShownX = p8.Slot:GetAttribute("ShownX")

        if type(ShownX) ~= "number" then
            ShownX = 0.5
        end

        v10 = TweenInfo.new(SlideSeconds, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        ShownX = p8.Slot:GetAttribute("HiddenX")

        if type(ShownX) ~= "number" then
            ShownX = -0.8
        end

        v10 = TweenInfo.new(SlideSeconds * 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    end

    local RowPosition = p8.Row.Position

    if p9 then
        p8.Slot.Visible = true
    end

    local tween3 = TweenService:Create(p8.Row, v10, {
        Position = UDim2.new(ShownX, 0, RowPosition.Y.Scale, 0)
    })

    tween = tween3
    tween3.Completed:Connect(function(p10) -- line: 156
        -- upvalues: p8 (copy), p9 (copy), v3 (ref)
        if p10 == Enum.PlaybackState.Completed and not p9 and not v3 then
            p8.Slot.Visible = false
        end
    end)
    tween3:Play()
end

local function hide(p11) -- line: 175
    -- upvalues: v3 (ref), slide (copy)
    if v3 then
        v3 = false
        slide(p11, false)
    end
end

local function screenPoint(p12, p13) -- line: 183
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local AbsoluteSize = p12.Screen.AbsoluteSize

    if CurrentCamera == nil then
        return AbsoluteSize / 2
    end

    local v11, v12 = CurrentCamera:WorldToViewportPoint(p13)
    local v13 = Vector2.new(v11.X, v11.Y) - p12.Screen.AbsolutePosition

    if v11.Z < 0 then
        return (Vector2.new(AbsoluteSize.X - v13.X, AbsoluteSize.Y))
    end

    if not v12 then
        v13 = Vector2.new(math.clamp(v13.X, 0, AbsoluteSize.X), (math.clamp(v13.Y, 0, AbsoluteSize.Y)))
    end

    return v13
end

local function bezier(p14, p15, p16, p17) -- line: 199
    local v15 = 1 - p17

    return p14 * (v15 * v15) + p15 * (v15 * 2 * p17) + p16 * (p17 * p17)
end

local function pulse(p18) -- line: 204
    -- upvalues: GuiService (copy), TweenService (copy), v1 (copy), v2 (copy)
    if GuiService.ReducedMotionEnabled then
        return
    end

    p18.IconScale.Scale = 1.45
    TweenService:Create(p18.IconScale, v1, {
        Scale = 1
    }):Play()

    local ValueScale = p18.ValueScale

    if ValueScale then
        ValueScale.Scale = 1.18
        TweenService:Create(ValueScale, v1, {
            Scale = 1
        }):Play()
    end

    local Glow = p18.Glow

    if Glow then
        Glow.ImageTransparency = 0.15
        TweenService:Create(Glow, v2, {
            ImageTransparency = 1
        }):Play()
    end
end

local function arrive(p19, p20) -- line: 222
    -- upvalues: Audio (copy), n1 (ref), n3 (ref), n4 (ref), sound (copy), pulse (copy)
    local v16 = n1

    n1 = v16 + p20.Value
    n3 = os.clock()
    n4 += 1
    pulse(p19)

    local CollectNormalRing = sound("Sounds", "LightVsDarknessSounds", "CollectNormalRing")

    if not CollectNormalRing then
        return
    end

    Audio.Play(CollectNormalRing, script, {
        Volume = 0.45,
        PlaybackSpeed = math.min(n4 * 0.025 + 1, 1.6)
    })
end

local function step(p21) -- line: 236
    -- upvalues: Simple (copy), t1 (ref), t2 (copy), n1 (ref), n2 (ref), v3 (ref), n3 (ref), slide (copy), arrive (copy)
    local t6 = t1

    if t6 == nil then
        return
    end

    local elapsed = os.clock()
    local AbsoluteSize = t6.Screen.AbsoluteSize
    local v18 = t6.Icon.AbsolutePosition + t6.Icon.AbsoluteSize / 2 - t6.Screen.AbsolutePosition

    for i = #t2, 1, -1 do
        local v19 = t2[i]
        local v21 = math.clamp((elapsed - v19.Born) / v19.Duration, 0, 1)
        local v22 = if v21 < 0.5 then v21 ^ 3 * 4 else 1 - (v21 * -2 + 2) ^ 3 / 2
        local From = v19.From
        local v23 = v18 - From
        local v24 = Vector2.new(-v23.Y, v23.X)
        local v25 = (From + v18) / 2 + v24 * v19.Bend - Vector2.new(0, v23.Magnitude * 0.2)
        local v26 = 1 - v22
        local v27 = From * (v26 * v26) + v25 * (v26 * 2 * v22) + v18 * (v22 * v22)

        v19.Icon.Position = UDim2.fromScale(v27.X / AbsoluteSize.X, v27.Y / AbsoluteSize.Y)
        v19.Icon.Rotation = v19.Spin * (1 - v21)

        local Pop = v19.Pop

        if Pop then
            if v21 < 0.3 then
                Pop.Scale = v21 / 0.3 * 0.9000000000000001 + 0.45
            else
                Pop.Scale = (v21 - 0.3) / 0.7 * -0.7500000000000001 + 1.35
            end
        end

        if v21 >= 1 then
            v19.Icon:Destroy()
            table.remove(t2, i)
            arrive(t6, v19)
        end
    end

    if math.abs(n1 - n2) > 0.01 then
        n2 += (n1 - n2) * (1 - math.exp(p21 * -14))

        if math.abs(n1 - n2) < 0.5 then
            n2 = n1
        end

        local Value = t6.Value
        local v35 = math.max(math.floor(n2 + 0.5), 0)

        if v35 > 99999 then
            Value.Text = Simple.FormatCompact(v35)
        else
            Value.Text = Simple.Format(v35)
        end
    end

    local HoldSeconds = t6.Slot:GetAttribute("HoldSeconds")

    if type(HoldSeconds) ~= "number" then
        HoldSeconds = 3
    end

    if v3 and #t2 == 0 and HoldSeconds <= elapsed - n3 then
        if not v3 then
            return
        end

        v3 = false
        slide(t6, false)
    end
end

local function ensureStepping() -- line: 282
    -- upvalues: RunService (copy), connection (ref), step (copy)
    if connection == nil then
        connection = RunService.RenderStepped:Connect(step)
    end
end

function t3.Prime(p22) -- line: 292
    -- upvalues: t2 (copy), n1 (ref), n2 (ref), v3 (ref)
    if not (v3 or #t2 > 0) then
        n1 = math.max(p22, 0)
        n2 = n1
    end
end

function t3.Collect(p23, p24) -- line: 300
    -- upvalues: RunService (copy), Audio (copy), Simple (copy), t2 (copy), n1 (ref), n2 (ref), v3 (ref), n3 (ref), n4 (ref), connection (ref), v4 (copy), sound (copy), bind (copy), slide (copy), screenPoint (copy), step (copy)
    local v36 = bind()

    if v36 == nil then
        return
    end

    if connection == nil then
        connection = RunService.RenderStepped:Connect(step)
    end

    if not v3 then
        v3 = true
        n4 = 0
        n2 = n1

        local Value = v36.Value
        local v39 = math.max(math.floor(n2 + 0.5), 0)

        if v39 > 99999 then
            Value.Text = Simple.FormatCompact(v39)
        else
            Value.Text = Simple.Format(v39)
        end

        slide(v36, true)
    end

    n3 = os.clock()

    local v40 = t2[#t2]
    local v41 = v40

    v41 = v41 and n3 - v40.Born < 0.05

    if not v41 then
        local clone = v36.FlyIcon:Clone()

        clone.Name = "SoulFlyIcon"
        clone.Visible = true
        clone.AnchorPoint = Vector2.new(0.5, 0.5)

        local v43 = screenPoint(v36, p23)
        local AbsoluteSize = v36.Screen.AbsoluteSize

        clone.Position = UDim2.fromScale(v43.X / AbsoluteSize.X, v43.Y / AbsoluteSize.Y)
        clone.ZIndex = 50
        clone.Parent = v36.Screen

        local t7 = {
            Icon = clone
        }
        local Pop = clone:FindFirstChild("Pop")

        t7.Pop = if not (Pop and Pop:IsA("UIScale")) then nil else Pop
        t7.From = v43
        t7.Born = os.clock()
        t7.Duration = v4:NextNumber(0.5, 0.78)
        t7.Bend = v4:NextNumber(0.18, 0.42) * (v4:NextNumber() < 0.5 and -1 or 1)
        t7.Spin = v4:NextNumber(-90, 90)
        t7.Value = p24
        table.insert(t2, t7)

        local StarCollect = sound("ShootingStar", "Sounds", "StarCollect")

        if StarCollect then
            Audio.Play(StarCollect, script, {
                Volume = 0.3,
                PlaybackSpeed = { 1.15, 1.35 }
            })
        end
    else
        v40.Value += p24
    end
end

function t3.IconViewportPoint() -- line: 338
    -- upvalues: GuiService (copy), bind (copy)
    local v44 = bind()

    if v44 == nil then
        return nil
    end

    local v45 = v44.Icon.AbsolutePosition + v44.Icon.AbsoluteSize / 2

    if v44.Screen.IgnoreGuiInset then
        return v45
    end

    return v45 + GuiService:GetGuiInset()
end

function t3.Reset() -- line: 351
    -- upvalues: t1 (ref), t2 (copy), v3 (ref)
    for _, v46 in t2 do
        v46.Icon:Destroy()
    end

    table.clear(t2)

    local t8 = t1

    if not t8 then
        return
    end

    v3 = false
    t8.Slot.Visible = false

    local Row = t8.Row
    local new = UDim2.new
    local HiddenX = t8.Slot:GetAttribute("HiddenX")

    if type(HiddenX) ~= "number" then
        HiddenX = -0.8
    end

    Row.Position = new(HiddenX, 0, t8.Row.Position.Y.Scale, 0)
end

return t3
