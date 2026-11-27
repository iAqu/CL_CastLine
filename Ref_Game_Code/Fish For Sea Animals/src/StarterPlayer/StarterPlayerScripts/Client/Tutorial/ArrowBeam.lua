-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local Folder, Attachment, Attachment2
local t2 = {}
local v1, BillboardGui
local v2 = false

local function beam(p1) -- line: 31
    -- upvalues: Folder (ref), Attachment (ref), Attachment2 (ref)
    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment2
    Beam.Attachment1 = Attachment
    Beam.FaceCamera = true
    Beam.Segments = 1
    Beam.LightEmission = 0
    Beam.LightInfluence = 0
    Beam.Brightness = 10
    Beam.Enabled = false

    for v3, v4 in p1 do
        Beam[v3] = v4
    end

    Beam.Parent = Folder

    return Beam
end

local function setVisible(p2) -- line: 50
    -- upvalues: t2 (copy), BillboardGui (ref), v2 (ref)
    for _, v5 in t2 do
        v5.Enabled = p2
    end

    local BillboardGui2 = BillboardGui

    BillboardGui2.Enabled = p2 and v2
end

local function update() -- line: 57
    -- upvalues: LocalPlayer (copy), Attachment (ref), Attachment2 (ref), t2 (copy), v1 (ref), BillboardGui (ref), v2 (ref)
    local v6 = v1 and v1()
    local v7 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if v6 and v7 then
        if Attachment.Parent ~= v7 then
            Attachment.Parent = v7
        end

        local Attachment3 = Attachment2

        Attachment3.WorldPosition = v6 + Vector3.new(0, 0.6, 0)

        local BillboardGui2 = BillboardGui

        BillboardGui2.StudsOffsetWorldSpace = Vector3.new(0, math.abs((math.sin(os.clock() * 4))) * 1.4 + 4, 0)

        for _, v11 in t2 do
            v11.Enabled = true
        end

        BillboardGui.Enabled = v2
    else
        for _, v12 in t2 do
            v12.Enabled = false
        end

        BillboardGui.Enabled = false
    end
end

function t1.show(p3, p4) -- line: 74
    -- upvalues: v1 (ref), v2 (ref)
    v1 = p3
    v2 = p4 == true
end

function t1.current() -- line: 80
    -- upvalues: v1 (ref)
    return v1
end

function t1.hide() -- line: 84
    -- upvalues: t2 (copy), v1 (ref), BillboardGui (ref)
    v1 = nil

    for _, v13 in t2 do
        v13.Enabled = false
    end

    BillboardGui.Enabled = false
end

function t1.init() -- line: 89
    -- upvalues: RunService (copy), Folder (ref), Attachment (ref), Attachment2 (ref), t2 (copy), v1 (ref), BillboardGui (ref), update (copy)
    Folder = Instance.new("Folder")
    Folder.Name = "TutorialArrow"
    Folder.Parent = workspace
    Attachment = Instance.new("Attachment")
    Attachment.Name = "TutorialBeamFrom"
    Attachment2 = Instance.new("Attachment")
    Attachment2.Name = "TutorialBeamTo"
    Attachment2.Parent = workspace.Terrain
    BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "TutorialMarker"
    BillboardGui.Size = UDim2.fromScale(4.5, 4.5)
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 1000
    BillboardGui.Enabled = false

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Glyph"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.Text = "▼"
    TextLabel.TextScaled = true
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
    TextLabel.TextColor3 = Color3.new(1, 1, 1)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 4
    UIStroke.Color = Color3.fromRGB(20, 20, 30)
    UIStroke.Parent = TextLabel
    TextLabel.Parent = BillboardGui
    BillboardGui.Parent = Attachment2

    for i = 1, 3 do
        local t3 = {
            Name = "Arrows",
            Width0 = 2.2,
            Width1 = 2.2,
            Texture = "rbxassetid://75453948966816",
            TextureLength = 3.6,
            TextureSpeed = -2.2,
            LightEmission = i == 1 and 1 or 0,
            TextureMode = Enum.TextureMode.Wrap,
            Color = ColorSequence.new(Color3.new(1, 1, 1)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.92, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
        }
        local Beam = Instance.new("Beam")

        Beam.Attachment0 = Attachment2
        Beam.Attachment1 = Attachment
        Beam.FaceCamera = true
        Beam.Segments = 1
        Beam.LightEmission = 0
        Beam.LightInfluence = 0
        Beam.Brightness = 10
        Beam.Enabled = false

        for v14, v15 in t3 do
            Beam[v14] = v15
        end

        Beam.Parent = Folder
        table.insert(t2, Beam)
    end

    RunService.Heartbeat:Connect(function() -- line: 138
        -- upvalues: v1 (ref), update (copy)
        if v1 then
            update()
        end
    end)
end

return t1
