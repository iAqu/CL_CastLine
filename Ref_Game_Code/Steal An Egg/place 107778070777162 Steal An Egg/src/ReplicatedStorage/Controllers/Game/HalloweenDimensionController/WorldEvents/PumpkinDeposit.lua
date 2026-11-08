-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)

require(ReplicatedStorage.Packages.Trove)

local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local HalloweenDimension = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("HalloweenDimension")
local PumpkinDeposit = HalloweenDimension:WaitForChild("PumpkinDeposit")
local Pumpkin = PumpkinDeposit:WaitForChild("Pumpkin")
local Flail = PumpkinDeposit:WaitForChild("Flail")
local Burst = PumpkinDeposit:WaitForChild("Burst")
local PumpkinDeposit2 = HalloweenDimension:WaitForChild("Sounds"):WaitForChild("PumpkinDeposit")
local v1 = Color3.fromRGB(255, 150, 45)
local v2 = Color3.fromRGB(255, 205, 80)
local v3 = Color3.fromRGB(255, 170, 60)
local v4 = Color3.fromRGB(255, 160, 50)
local v5 = TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local BoundingBox, BoundingBox2 = Pumpkin:GetBoundingBox()
local v7 = Pumpkin:GetScale() * math.min(1, 8 / math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z))
local v8 = (Pumpkin:GetPivot().Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y * 0.5)) * v7 / Pumpkin:GetScale()
local t1 = {}

local function stage() -- line: 78
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("Transient") or Workspace
end

local function bezier(p1, p2, p3, p4) -- line: 82
    local v9 = 1 - p4

    return p1 * (v9 * v9) + p2 * (v9 * 2 * p4) + p3 * (p4 * p4)
end

local function ease(p5, p6, p7) -- line: 87
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p5, 0, 1), p6, p7)
end

local function quiet(p8) -- line: 91
    p8.CanCollide = false
    p8.CanQuery = false
    p8.CanTouch = false
end

local function shell(p9) -- line: 97
    local Archivable = p9.Archivable

    p9.Archivable = true

    local clone = p9:Clone()

    p9.Archivable = Archivable
    clone:ClearAllChildren()
    clone.Anchored = true
    clone.CastShadow = false
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false

    return clone
end

local function pumpkin(p10, p11, p12) -- line: 109
    -- upvalues: Pumpkin (copy), Flail (copy), v7 (copy)
    local v10 = p10:Add(Pumpkin:Clone())

    for _, descendant in v10:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end

    v10:ScaleTo(v7)
    v10:PivotTo(p11)
    v10.Parent = p12

    local v11 = v10:FindFirstChildWhichIsA("Animator", true)

    if v11 ~= nil then
        local v12 = p10:Add(v11:LoadAnimation(Flail))

        v12.Looped = true
        v12:Play(0, 1, 2.6)
    end

    return v10
end

local function anchor(p13, p14) -- line: 128
    -- upvalues: Workspace (copy)
    local v13 = p13:Add(Instance.new("Part"))

    v13.Name = "PumpkinDepositBurst"
    v13.Anchored = true
    v13.CastShadow = false
    v13.Transparency = 1
    v13.Size = Vector3.new(0.05, 0.05, 0.05)
    v13.CFrame = CFrame.new(p14)
    v13.CanCollide = false
    v13.CanQuery = false
    v13.CanTouch = false
    v13.Parent = Workspace:FindFirstChild("Transient") or Workspace

    return v13
end

local function flash(p15, p16) -- line: 141
    -- upvalues: TweenService (copy), v1 (copy)
    local v14 = p15:Add(Instance.new("PointLight"))

    v14.Color = v1
    v14.Brightness = 9
    v14.Range = 26
    v14.Shadows = false
    v14.Parent = p16
    p15:Add(TweenService:Create(v14, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Brightness = 0,
        Range = 7.8
    })):Play()
end

local function pulse(p17, p18) -- line: 159
    -- upvalues: TweenService (copy), Workspace (copy), v2 (copy)
    local Archivable = p18.Archivable

    p18.Archivable = true

    local clone = p18:Clone()

    p18.Archivable = Archivable
    clone:ClearAllChildren()
    clone.Anchored = true
    clone.CastShadow = false
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false

    local v15 = p17:Add(clone)

    v15.Name = "PumpkinDepositGlow"
    v15.Material = Enum.Material.Neon
    v15.Color = v2
    v15.Transparency = 0.05
    v15.Size = p18.Size + Vector3.new(0, 0.2, 0)
    v15.Parent = Workspace:FindFirstChild("Transient") or Workspace
    p17:Add(TweenService:Create(v15, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(p18.Size.X * 1.35, p18.Size.Y + 0.2, p18.Size.Z * 1.35)
    })):Play()
end

local function pillar(p19, p20) -- line: 185
    -- upvalues: TweenService (copy), Workspace (copy), v3 (copy)
    local v20 = p19:Add(Instance.new("Part"))

    v20.Name = "PumpkinDepositPillar"
    v20.Shape = Enum.PartType.Cylinder
    v20.Material = Enum.Material.Neon
    v20.Color = v3
    v20.Anchored = true
    v20.CastShadow = false
    v20.Transparency = 0.15
    v20.Size = Vector3.new(0.2, 7, 7)
    v20.CFrame = CFrame.new(p20 + Vector3.new(0, 0.1, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    v20.CanCollide = false
    v20.CanQuery = false
    v20.CanTouch = false
    v20.Parent = Workspace:FindFirstChild("Transient") or Workspace
    p19:Add(TweenService:Create(v20, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(13, 1.75, 1.75),
        CFrame = CFrame.new(p20 + Vector3.new(0, 6.5, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    })):Play()
end

local function burst(p21, p22) -- line: 214
    -- upvalues: Audio (copy), VFX (copy), Burst (copy), PumpkinDeposit2 (copy), anchor (copy), flash (copy), pulse (copy), pillar (copy)
    local WorldPosition = p22.Target.WorldPosition
    local v21 = anchor(p21, WorldPosition + Vector3.new(0, 0.3, 0))
    local v22 = VFX.EmitAt(v21, Burst:GetChildren())

    flash(p21, v21)
    pillar(p21, WorldPosition)

    if p22.Plate ~= nil and p22.Plate.Parent ~= nil then
        pulse(p21, p22.Plate)
    end

    Audio.Play(PumpkinDeposit2, WorldPosition, {
        MaxDistance = 180
    })

    return (math.max(v22.settleSeconds, 0.7, 0.55, 0.6))
end

function t1.Play(p23, p24, p25, p26, p27) -- line: 231
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), v7 (copy), v8 (copy), pumpkin (copy), burst (copy)
    local WorldPosition = p25.Target.WorldPosition
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - WorldPosition).Magnitude > 450 then
        if p27 ~= nil then
            p27()
        end

        return
    end

    local v23 = p23:Extend()
    local v24 = p27

    local function land() -- line: 249
        -- upvalues: v24 (ref)
        local v25 = v24

        v24 = nil

        if v25 ~= nil then
            v25()
        end
    end

    v23:Add(land)

    local v27 = pumpkin(v23, p24, p26 or Workspace:FindFirstChild("Transient") or Workspace)
    local Position, Rotation = p24.Position, p24.Rotation
    local v28 = WorldPosition + Vector3.new(0, 1, 0) * (v8 + 0.6)
    local v29 = WorldPosition - Vector3.new(0, 0.8, 0)
    local v31 = math.clamp((v28 - Position).Magnitude * 0.45, 5, 16)
    local v33 = (Position + v28) * 0.5 + Vector3.new(0, 1, 0) * (math.max(Position.Y, v28.Y) - (Position.Y + v28.Y) * 0.5 + v31)
    local v34 = v7
    local v35
    local n1 = 0
    local elapsed = os.clock()

    local function pose(p28, p29, p30, p31) -- line: 270
        -- upvalues: v27 (copy), Rotation (copy), v34 (ref)
        if math.abs(p31 - v34) > 0.002 then
            v34 = p31
            v27:ScaleTo(p31)
        end

        v27:PivotTo(CFrame.new(p28) * CFrame.Angles(0, p29, 0) * Rotation * CFrame.Angles(p30, 0, 0))
    end

    v23:Connect(RunService.RenderStepped, function() -- line: 280
        -- upvalues: p23 (copy), p25 (copy), v23 (copy), v24 (ref), v27 (copy), Position (copy), v28 (copy), v29 (copy), v33 (copy), v35 (ref), n1 (ref), elapsed (copy), pose (copy), TweenService (copy), v7 (copy), burst (copy)
        local v37 = os.clock() - elapsed

        if v37 < 0.6 then
            local v38 = v37 / 0.6
            local Sine = Enum.EasingStyle.Sine
            local InOut = Enum.EasingDirection.InOut
            local Value = TweenService:GetValue(math.clamp(v38, 0, 1), Sine, InOut)
            local v40 = math.sin(3.141592653589793 * Value)
            local v41 = 1 - Value

            pose(Position * (v41 * v41) + v33 * (v41 * 2 * Value) + v28 * (Value * Value), 4.71238898038469 * Value, v40 * 0.3141592653589793, v7 * (v40 * 0.12 + 1))
        elseif v37 < 0.82 then
            local v42 = (v37 - 0.6) / 0.22
            local Quad = Enum.EasingStyle.Quad
            local In = Enum.EasingDirection.In
            local Value = TweenService:GetValue(math.clamp(v42, 0, 1), Quad, In)

            pose(v28:Lerp(v29, Value), (Value * 0.5 + 0.75) * 3.141592653589793 * 2, 0, v7 * (Value * -0.96 + 1))
        elseif v35 ~= nil then
            if v37 - v35 >= n1 then
                p23:Remove(v23)
            end
        else
            v35 = v37
            v23:Remove(v27)
            n1 = burst(v23, p25)

            local v43 = v24

            v24 = nil

            if v43 ~= nil then
                v43()
            end
        end
    end)
end

function t1.Beacon(p32, p33) -- line: 312
    -- upvalues: TweenService (copy), Workspace (copy), v4 (copy), v5 (copy)
    local v44 = p32:Add(Instance.new("Attachment"))

    v44.Name = "PumpkinDepositBeacon"
    v44.Parent = Workspace.Terrain
    v44.WorldPosition = p33.Target.WorldPosition + Vector3.new(0, 2, 0)

    local v45 = p32:Add(Instance.new("PointLight"))

    v45.Color = v4
    v45.Brightness = 1.2
    v45.Range = 16
    v45.Shadows = false
    v45.Parent = v44
    p32:Add(TweenService:Create(v45, v5, {
        Brightness = 3.5
    })):Play()
end

return t1
