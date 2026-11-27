-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local t1 = {}
local v1 = Color3.fromRGB(70, 165, 255)
local v2 = Color3.fromRGB(215, 240, 255)

local function v3() -- line: 13
    return false
end

function t1.setHiddenCheck(p1) -- line: 17
    -- upvalues: v3 (ref)
    v3 = p1
end

local function glowFace(p2, p3) -- line: 22
    -- upvalues: v1 (copy), v2 (copy)
    local SurfaceGui = Instance.new("SurfaceGui")

    SurfaceGui.Face = p3
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    SurfaceGui.PixelsPerStud = 20
    SurfaceGui.LightInfluence = 0
    SurfaceGui.Brightness = 2
    SurfaceGui.MaxDistance = 1000

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v1),
        ColorSequenceKeypoint.new(0.7, v1),
        ColorSequenceKeypoint.new(1, v2)
    })
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.55, 0.7),
        NumberSequenceKeypoint.new(0.9, 0.25),
        NumberSequenceKeypoint.new(1, 0)
    })
    UIGradient.Parent = Frame
    Frame.Parent = SurfaceGui
    SurfaceGui.Parent = p2

    return SurfaceGui
end

function t1.init() -- line: 53
    -- upvalues: RunService (copy), v3 (ref), glowFace (copy)
    local Deck = workspace:WaitForChild("Map"):WaitForChild("World1"):WaitForChild("FishingDock"):WaitForChild("Deck")
    local Folder = Instance.new("Folder")

    Folder.Name = "DockGlow"

    local v4 = Deck.Size / 2
    local v5 = v4.Y + 1.75
    local t2 = {
        Vector3.new(0, v5, -v4.Z),
        Deck.Size.X,
        false
    }
    local t3 = {
        Vector3.new(0, v5, v4.Z),
        Deck.Size.X,
        false
    }
    local t4 = {
        Vector3.new(-v4.X, v5, 0),
        Deck.Size.Z,
        true
    }
    local v8 = Vector3.new(v4.X, v5, 0)
    local Z2 = Deck.Size.Z
    local t5 = {}

    for _, v9 in {
            t2,
            t3,
            t4,
            { v8, Z2, true }
        } do
        local Part = Instance.new("Part")

        Part.Name = "Glow"
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Transparency = 1
        Part.Size = Vector3.new(v9[2], 3.5, 0.05)
        Part.CFrame = Deck.CFrame * CFrame.new(v9[1]) * (if v9[3] then CFrame.Angles(0, 1.5707963267948966, 0) else CFrame.identity)
        table.insert(t5, (glowFace(Part, Enum.NormalId.Front)))
        table.insert(t5, (glowFace(Part, Enum.NormalId.Back)))
        Part.Parent = Folder
    end

    Folder.Parent = workspace

    local v13 = true

    RunService.Heartbeat:Connect(function() -- line: 82
        -- upvalues: t5 (copy), v13 (ref), v3 (ref)
        local v14 = not v3()

        if v14 ~= v13 then
            v13 = v14

            for _, v15 in t5 do
                v15.Enabled = v14
            end
        end

        if not v14 then
            return
        end

        local v17 = math.sin(os.clock() * 2.2) * 0.5 + 1.8

        for _, v18 in t5 do
            v18.Brightness = v17
        end
    end)
end

return t1
