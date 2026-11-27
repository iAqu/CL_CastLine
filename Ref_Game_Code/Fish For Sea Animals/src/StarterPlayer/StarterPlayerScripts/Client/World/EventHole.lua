-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Effects = require(script.Parent.Parent.Fishing.Effects)
local t1 = {}
local LocalPlayer = Players.LocalPlayer

local function v1() -- line: 23
    return false
end

function t1.setBusyCheck(p1) -- line: 28
    -- upvalues: v1 (ref)
    v1 = p1
end

local t2 = {
    Lighting = {
        Brightness = 2,
        ClockTime = 0,
        EnvironmentDiffuseScale = 0.5,
        EnvironmentSpecularScale = 0.6,
        ExposureCompensation = 0.9,
        Ambient = Color3.fromRGB(175, 190, 220),
        OutdoorAmbient = Color3.fromRGB(185, 200, 230),
        ColorShift_Top = Color3.fromRGB(140, 185, 240)
    },
    Atmosphere = {
        Density = 0.27,
        Offset = 0.15,
        Glare = 0,
        Haze = 1.6,
        Color = Color3.fromRGB(40, 75, 125),
        Decay = Color3.fromRGB(16, 34, 70)
    },
    Bloom = {
        Intensity = 1,
        Size = 30,
        Threshold = 1.15
    },
    SunRays = {
        Intensity = 0
    },
    ColorGrade = {
        Brightness = 0.02,
        Contrast = 0.12,
        Saturation = 0,
        TintColor = Color3.fromRGB(220, 232, 255)
    },
    Sky = {
        StarCount = 0,
        CelestialBodiesShown = false
    }
}
local t3
local n1 = 1

local function setWorldLight(p2, p3) -- line: 64
    -- upvalues: Lighting (copy), TweenService (copy), t2 (copy), t3 (ref), n1 (ref)
    if p2 == n1 then
        return
    end

    n1 = p2

    if not t3 then
        t3 = {}

        for v2, v3 in t2 do
            local v4 = if v2 == "Lighting" then Lighting else Lighting:FindFirstChild(v2)

            if v4 then
                local t4 = t3

                t4[v2] = {}

                for v5 in v3 do
                    t3[v2][v5] = v4[v5]
                end
            end
        end
    end

    for v6, v7 in t2 do
        local v8 = if v6 == "Lighting" then Lighting else Lighting:FindFirstChild(v6)
        local v9 = if p2 > 1 then v7 else t3[v6]

        if v8 and v9 then
            local t5 = {}

            for v10, v11 in v9 do
                if p3 then
                    v8[v10] = v11
                elseif type(v11) == "number" or typeof(v11) == "Color3" then
                    t5[v10] = v11
                else
                    v8[v10] = v11
                end
            end

            if next(t5) then
                TweenService:Create(v8, TweenInfo.new(1.2, Enum.EasingStyle.Sine), t5):Play()
            end
        end
    end
end

local function cutsceneGui() -- line: 101
    -- upvalues: UIUtil (copy)
    return UIUtil.gui("Cutscene")
end

local function root() -- line: 105
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v12 = Character

    if Character then
        v12 = Character:FindFirstChildOfClass("Humanoid")
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    return if v12 and v12.Health > 0 then Character else nil
end

local function insidePart(p4, p5) -- line: 112
    local v13 = p4.CFrame:PointToObjectSpace(p5)
    local v14 = p4.Size / 2

    if math.abs(v13.X) <= v14.X then
        if not (math.abs(v13.Y) <= v14.Y + 3) then
            return false
        end

        return math.abs(v13.Z) <= v14.Z
    end

    return false
end

local t6 = {}

local function findPortals() -- line: 119
    -- upvalues: t6 (ref)
    t6 = {}

    for _, descendant in workspace:GetDescendants() do
        if descendant:IsA("BasePart") and type(descendant:GetAttribute("Destination")) == "string" then
            table.insert(t6, descendant)
        end
    end
end

local v15 = false
local v16 = false

local function travel(p6) -- line: 131
    -- upvalues: Config (copy), UIUtil (copy), Effects (copy), LocalPlayer (copy), setWorldLight (copy), v15 (ref), v16 (ref)
    local v17 = workspace:FindFirstChild(p6:GetAttribute("Destination"), true)
    local Character = LocalPlayer.Character
    local v18 = Character

    if Character then
        v18 = Character:FindFirstChildOfClass("Humanoid")
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not (v18 and v18.Health > 0) then
        Character = nil
    end

    if not (v17 and v17:IsA("BasePart") and Character) then
        return
    end

    v15 = true

    local Cutscene = UIUtil.gui("Cutscene")

    Cutscene.Enabled = true
    Effects.fade(Cutscene, true, 0.35)
    UIUtil.sound("Whoosh", 0.6)

    local Character2 = LocalPlayer.Character
    local Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")

    if not (Humanoid and Humanoid.Health > 0) then
        HumanoidRootPart = nil
    end

    if HumanoidRootPart then
        local Parent = HumanoidRootPart.Parent
        local Humanoid = Parent:FindFirstChildOfClass("Humanoid")

        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

        local v19 = v17.Size.Y / 2 + (if Humanoid then Humanoid.HipHeight else 2) + HumanoidRootPart.Size.Y / 2

        Parent:PivotTo(v17.CFrame + Vector3.new(0, v19, 0))
        workspace.CurrentCamera.CFrame = v17.CFrame * CFrame.new(0, v19 + 5, 12) * CFrame.Angles(-0.20943951023931956, 0, 0)
    end

    local v20 = Config.worldAt(v17.Position)

    setWorldLight(v20, true)
    task.wait(0.25)
    Effects.fade(Cutscene, false, 0.5)

    if v20 > 1 and not v16 then
        v16 = true
        UIUtil.toast("Welcome to the Deep Sea! Everything down here is 2x harder 🌊", "info")
    end

    task.wait(1)
    v15 = false

    if not Cutscene.Fade or Cutscene.Fade.BackgroundTransparency >= 0.99 then
        Cutscene.Enabled = false
    end
end

function t1.init() -- line: 167
    -- upvalues: RunService (copy), Config (copy), LocalPlayer (copy), v1 (ref), setWorldLight (copy), t6 (ref), findPortals (copy), v15 (ref), travel (copy)
    task.spawn(function() -- line: 168
        -- upvalues: findPortals (copy)
        workspace:WaitForChild("EventHole", 30)
        findPortals()
    end)
    workspace.DescendantAdded:Connect(function(p7) -- line: 172
        -- upvalues: t6 (ref)
        if p7:IsA("BasePart") and p7:GetAttribute("Destination") then
            table.insert(t6, p7)
        end
    end)
    RunService.Heartbeat:Connect(function() -- line: 177
        -- upvalues: Config (copy), LocalPlayer (copy), v1 (ref), setWorldLight (copy), t6 (ref), v15 (ref), travel (copy)
        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera and not v15 then
            setWorldLight(Config.worldAt(CurrentCamera.CFrame.Position))
        end

        if v15 or v1() then
            return
        end

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not (Humanoid and Humanoid.Health > 0) then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart then
            for _, v21 in t6 do
                if v21.Parent then
                    local Position = HumanoidRootPart.Position
                    local v22 = v21.CFrame:PointToObjectSpace(Position)
                    local v23 = v21.Size / 2

                    if math.abs(v22.X) <= v23.X and math.abs(v22.Y) <= v23.Y + 3 and math.abs(v22.Z) <= v23.Z then
                        task.spawn(travel, v21)

                        return
                    end
                end
            end
        end
    end)
end

return t1
