-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local LocalPlayer = Players.LocalPlayer
local MonsterDeath = ReplicatedStorage.Assets.HalloweenDimension:WaitForChild("MonsterDeath")
local t1 = {
    Small = 1,
    Medium = 1.35,
    Large = 1.8
}
local t2 = {
    SurfaceAppearance = true,
    SpecialMesh = true,
    Decal = true,
    Texture = true
}
local v1 = Color3.fromRGB(255, 150, 50)
local v2 = Random.new()
local t3 = {}

local function emitters() -- line: 70
    -- upvalues: MonsterDeath (copy)
    local t4 = {}

    for _, descendant in MonsterDeath:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            table.insert(t4, descendant)
        end
    end

    return t4
end

local function popSound() -- line: 80
    -- upvalues: ReplicatedStorage (copy)
    local Sounds = ReplicatedStorage.Assets:FindFirstChild("Sounds")
    local ScrambleBoss = if Sounds == nil then nil else Sounds:FindFirstChild("ScrambleBoss")
    local Pop = if ScrambleBoss == nil then nil else ScrambleBoss:FindFirstChild("Pop")

    return if Pop ~= nil and Pop:IsA("Sound") then Pop else nil
end

local function randomFlat() -- line: 87
    -- upvalues: v2 (copy)
    local v3 = v2:NextNumber(0, 6.283185307179586)

    return (Vector3.new(math.cos(v3), 0, (math.sin(v3))))
end

local function shell(p1) -- line: 92
    -- upvalues: t2 (copy)
    local Archivable = p1.Archivable

    p1.Archivable = true

    local clone = p1:Clone()

    p1.Archivable = Archivable

    if clone == nil then
        return nil
    end

    for _, child in clone:GetChildren() do
        if not t2[child.ClassName] then
            child:Destroy()
        end
    end

    clone.Name = "MonsterDeathPiece"
    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false
    clone.CastShadow = false
    clone.Massless = true
    clone.LocalTransparencyModifier = 0

    return clone
end

local function scatter(p2, p3, p4) -- line: 117
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), Trove (copy), v2 (copy), shell (copy)
    local t5 = {}
    local v6 = Trove.new()
    local v7 = Workspace:FindFirstChild("Transient") or Workspace

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") and not (descendant.Transparency >= 1) then
            local v8 = if #t5 < 14 then shell(descendant) else nil

            descendant.LocalTransparencyModifier = 1

            if v8 ~= nil then
                local v9 = descendant.Position - p3
                local v10 = Vector3.new(v9.X, 0, v9.Z)
                local v11

                if v10.Magnitude > 0.1 then
                    v11 = v10.Unit
                else
                    local v12 = v2:NextNumber(0, 6.283185307179586)

                    v11 = Vector3.new(math.cos(v12), 0, (math.sin(v12)))
                end

                local v15 = Vector3.new(0, 1, 0) * v2:NextNumber(0.3, 0.9)
                local v16 = v2:NextUnitVector()

                table.insert(t5, {
                    Part = v8,
                    Offset = v9,
                    Rotation = descendant.CFrame.Rotation,
                    Size = descendant.Size,
                    Travel = (v11 + v15).Unit * v2:NextNumber(5, 10) * p4,
                    Axis = v16,
                    Spin = v2:NextNumber(2, 5) * (v2:NextNumber() < 0.5 and -1 or 1)
                })
                v8.Parent = v7
                v6:Add(v8)
            end
        end
    end

    if #t5 == 0 then
        v6:Destroy()
    else
        local elapsed = os.clock()

        v6:Connect(RunService.RenderStepped, function() -- line: 157
            -- upvalues: p3 (copy), t5 (copy), v6 (copy), elapsed (copy), TweenService (copy)
            local v17 = os.clock() - elapsed

            if v17 >= 0.5 then
                v6:Destroy()
            else
                local v18, v19, v20

                if v17 < 0.08 then
                    v18 = 1 + 0.1499999999999999 * (v17 / 0.08)
                    v20 = v18
                    v19 = 0
                else
                    local v21 = (v17 - 0.08) / 0.42

                    v19 = TweenService:GetValue(v21, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    v18 = 1.15 * (1 - TweenService:GetValue(v21, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
                    v20 = 1.15
                end

                for _, v22 in t5 do
                    local v23 = p3 + v22.Offset * v20 + v22.Travel * v19

                    v22.Part.Size = v22.Size * math.max(v18, 0.01)
                    v22.Part.CFrame = CFrame.new(v23) * CFrame.fromAxisAngle(v22.Axis, v22.Spin * v19) * v22.Rotation
                end
            end
        end)
    end
end

local function glow(p5, p6) -- line: 187
    -- upvalues: TweenService (copy), Workspace (copy), VFX (copy), v1 (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "MonsterDeathGlow"
    Attachment.WorldPosition = p5
    Attachment.Parent = Workspace.Terrain

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v1
    PointLight.Brightness = 6
    PointLight.Range = p6 * 14
    PointLight.Shadows = false
    PointLight.Parent = Attachment
    TweenService:Create(PointLight, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {
        Brightness = 0,
        Range = PointLight.Range * 0.3
    }):Play()
    VFX.Discard(Attachment, 0.55)
end

local function burst(p7, p8) -- line: 206
    -- upvalues: VFX (copy), emitters (copy)
    local v24 = math.sqrt(p8)

    VFX.EmitAt(p7, emitters(), function(p9) -- line: 208
        -- upvalues: p8 (copy), v24 (copy), VFX (copy)
        VFX.Rescale(p9, p8)

        local EmitCount = p9:GetAttribute("EmitCount")

        if type(EmitCount) == "number" and EmitCount > 2 then
            p9:SetAttribute("EmitCount", EmitCount * v24)
        end
    end)
end

function t3.Play(p10, p11, p12) -- line: 221
    -- upvalues: Audio (copy), VFX (copy), emitters (copy), popSound (copy), scatter (copy), glow (copy)
    if p12 ~= nil then
        scatter(p12, p10, p11)
    end

    local v25 = math.sqrt(p11)

    VFX.EmitAt(p10, emitters(), function(p13) -- line: 208
        -- upvalues: p11 (copy), v25 (copy), VFX (copy)
        VFX.Rescale(p13, p11)

        local EmitCount = p13:GetAttribute("EmitCount")

        if type(EmitCount) == "number" and EmitCount > 2 then
            p13:SetAttribute("EmitCount", EmitCount * v25)
        end
    end)
    glow(p10, p11)

    local v26 = popSound()

    if v26 == nil then
        return
    end

    Audio.Play(v26, p10, {
        Volume = 0.5,
        MaxDistance = 220,
        PlaybackSpeed = math.clamp(1.75 - p11 * 0.45, 0.8, 1.4)
    })
end

function t3.NearestModel(p14, p15, p16) -- line: 238
    if p14 == nil then
        return nil
    end

    local v28 = p16
    local child

    for _, child2 in p14:GetChildren() do
        if child2:IsA("Model") then
            local Magnitude = (child2:GetPivot().Position - p15).Magnitude

            if Magnitude <= v28 then
                v28 = Magnitude
                child = child2
            end
        end
    end

    return child
end

function t3.Start(p17) -- line: 257
    -- upvalues: CollectionService (copy), Shake (copy), LocalPlayer (copy), t1 (copy), t3 (copy)
    local t8 = {}

    local function unwatch(p18) -- line: 260
        -- upvalues: p17 (copy), t8 (copy)
        local v29 = t8[p18]

        if v29 ~= nil then
            t8[p18] = nil
            p17:Remove(v29)
        end
    end

    local function watch(p19) -- line: 268
        -- upvalues: p17 (copy), t8 (copy), Shake (copy), LocalPlayer (copy), t1 (copy), t3 (copy)
        if p19:IsA("Model") and t8[p19] == nil then
            local v30 = p17:Extend()

            t8[p19] = v30
            v30:Connect(p19:GetAttributeChangedSignal("KilledBy"), function() -- line: 276
                -- upvalues: p19 (copy), p17 (copy), t8 (copy), Shake (copy), LocalPlayer (copy), t1 (copy), t3 (copy)
                local KilledBy = p19:GetAttribute("KilledBy")

                if type(KilledBy) ~= "number" then
                    return
                end

                local v31 = t8[p19]

                if v31 ~= nil then
                    t8[p19] = nil
                    p17:Remove(v31)
                end

                local MonsterSize = p19:GetAttribute("MonsterSize")
                local v32 = type(MonsterSize) == "string" and t1[MonsterSize] or 1

                t3.Play(p19:GetBoundingBox().Position, v32, p19)

                if KilledBy == LocalPlayer.UserId then
                    Shake.Play({
                        Seconds = 0.35,
                        Shape = "Fade",
                        Magnitude = 0.3 * v32
                    })
                end
            end)
        end
    end

    p17:Connect(CollectionService:GetInstanceAddedSignal("HalloweenMonster"), watch)
    p17:Connect(CollectionService:GetInstanceRemovedSignal("HalloweenMonster"), unwatch)

    for _, v33 in CollectionService:GetTagged("HalloweenMonster") do
        watch(v33)
    end

    p17:Add(function() -- line: 301
        -- upvalues: t8 (copy)
        table.clear(t8)
    end)
end

return t3
