-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(255, 225, 90)
local v2 = Color3.fromRGB(20, 20, 30)
local Model, v3, v4, v5
local t2 = {}
local n1 = 0
local v6 = false

local function part(p1) -- line: 31
    -- upvalues: Model (ref)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Material = Enum.Material.SmoothPlastic

    for v7, v8 in p1 do
        Part[v7] = v8
    end

    Part.Parent = Model

    return Part
end

local function buoy(p2) -- line: 49
    -- upvalues: v1 (copy), t2 (copy), part (copy)
    for i = 0, 2 do
        part({
            Name = "Buoy",
            Size = Vector3.new(1.4, 1.6, 1.6),
            Shape = Enum.PartType.Cylinder,
            Color = if i % 2 == 0 then Color3.fromRGB(235, 55, 60) else Color3.new(1, 1, 1),
            CFrame = CFrame.new(p2, i * 1.4 + 0.7, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
        })
    end

    part({
        Name = "Pole",
        Size = Vector3.new(0.25, 4, 0.25),
        Color = Color3.fromRGB(230, 230, 235),
        CFrame = CFrame.new(p2, 6, 0)
    })

    local v9 = CFrame.new(p2, 7.2, 1.25)

    table.insert(t2, {
        part = part({
            Name = "Flag",
            Size = Vector3.new(0.1, 1.6, 2.4),
            Color = v1,
            CFrame = v9
        }),
        offset = v9
    })
end

local function build() -- line: 64
    -- upvalues: RunService (copy), Config (copy), v1 (copy), v2 (copy), Model (ref), v3 (ref), v4 (ref), v5 (ref), t2 (copy), n1 (ref), part (copy), buoy (copy)
    Model = Instance.new("Model")
    Model.Name = "BestMarker"
    v3 = part({
        Name = "Line",
        Size = Vector3.new(72, 0.12, 0.7),
        Transparency = 0.25,
        Color = v1,
        Material = Enum.Material.Neon,
        CFrame = CFrame.new(0, 0.06, 0)
    })
    buoy(-36)
    buoy(36)

    local v10 = part({
        Name = "LabelAnchor",
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1,
        CFrame = CFrame.new(0, 7, 0)
    })
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "BestLabel"
    BillboardGui.Size = UDim2.fromScale(26, 9)
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 2000
    BillboardGui.Adornee = v10

    local function text(p3, p4, p5, p6, p7) -- line: 78
        -- upvalues: BillboardGui (copy), Config (copy), v2 (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p3
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.fromScale(0, p6)
        TextLabel.Size = UDim2.fromScale(1, p7)
        TextLabel.FontFace = Config.Font
        TextLabel.TextScaled = true
        TextLabel.Text = p4
        TextLabel.TextColor3 = p5

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 3
        UIStroke.Color = v2
        UIStroke.Parent = TextLabel
        TextLabel.Parent = BillboardGui

        return TextLabel
    end

    v4 = text("Title", "BEST", Color3.fromRGB(200, 210, 230), 0, 0.38)
    v5 = text("Meters", "", v1, 0.36, 0.64)
    BillboardGui.Parent = v10

    local Model2 = Model

    Model2.WorldPivot = CFrame.identity
    RunService.Heartbeat:Connect(function() -- line: 101
        -- upvalues: Model (ref), v3 (ref), t2 (copy), n1 (ref)
        if Model.Parent and not (n1 <= 0) then
            local elapsed = os.clock()

            v3.Transparency = math.sin(elapsed * 2.4) * 0.12 + 0.2

            local Pivot = Model:GetPivot()

            for _, v13 in t2 do
                v13.part.CFrame = Pivot * v13.offset * CFrame.new(0, 0, -1.2) * CFrame.Angles(0, math.sin(elapsed * 6 + v13.offset.X) * 0.35, 0) * CFrame.new(0, 0, 1.2)
            end
        end
    end)
end

local function place(p8) -- line: 116
    -- upvalues: Config (copy), Canyon (copy), Format (copy), Model (ref), v5 (ref), n1 (ref)
    n1 = p8

    local Model2 = Model

    if p8 > 0 then
        Model2.Parent = workspace
    else
        Model2.Parent = nil
    end

    if p8 <= 0 then
        return
    end

    local v16 = Config.toStuds(p8)
    local Model3 = Model

    Model3:PivotTo(CFrame.new(0, Canyon.surface(v16), -v16))

    local v17 = v5

    v17.Text = ("%*m"):format((Format.short((math.floor(p8)))))
end

local function target() -- line: 127
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("BestThrow") or 0
end

local function moveTo(p9) -- line: 132
    -- upvalues: RunService (copy), UIUtil (copy), v5 (ref), n1 (ref), place (copy)
    local v18 = n1

    if v18 <= 0 or p9 < v18 then
        place(p9)
    else
        local elapsed = os.clock()

        task.spawn(function() -- line: 139
            -- upvalues: p9 (copy), v18 (copy), elapsed (copy), RunService (copy), UIUtil (copy), v5 (ref), place (copy)
            while os.clock() - elapsed < 0.8 do
                local v19 = (os.clock() - elapsed) / 0.8

                place(v18 + (p9 - v18) * (1 - (1 - v19) ^ 3))
                RunService.Heartbeat:Wait()
            end

            place(p9)
            UIUtil.pop(v5, 1.5)
        end)
    end
end

function t1.current() -- line: 151
    -- upvalues: n1 (ref)
    return n1
end

function t1.freeze() -- line: 156
    -- upvalues: v6 (ref)
    v6 = true
end

function t1.release() -- line: 161
    -- upvalues: LocalPlayer (copy), n1 (ref), v6 (ref), moveTo (copy)
    v6 = false

    if (LocalPlayer:GetAttribute("BestThrow") or 0) ~= n1 then
        moveTo(LocalPlayer:GetAttribute("BestThrow") or 0)
    end
end

function t1.burst() -- line: 169
    -- upvalues: UIUtil (copy), v1 (copy), Model (ref), v3 (ref), v4 (ref), v5 (ref)
    if not (Model and Model.Parent) then
        return
    end

    v3.Color = Color3.new(1, 1, 1)
    v3.Size = Vector3.new(72, 0.3, 2.4)
    UIUtil.tween(v3, 0.6, {
        Size = Vector3.new(72, 0.12, 0.7),
        Color = v1
    })
    UIUtil.pop(v4, 1.6)
    UIUtil.pop(v5, 1.6)
end

function t1.init() -- line: 180
    -- upvalues: LocalPlayer (copy), v6 (ref), build (copy), place (copy), moveTo (copy)
    build()
    place(LocalPlayer:GetAttribute("BestThrow") or 0)
    LocalPlayer:GetAttributeChangedSignal("BestThrow"):Connect(function() -- line: 183
        -- upvalues: LocalPlayer (copy), v6 (ref), moveTo (copy)
        if not v6 then
            moveTo(LocalPlayer:GetAttribute("BestThrow") or 0)
        end
    end)
end

return t1
