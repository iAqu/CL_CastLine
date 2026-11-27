-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local BossFx = require(script.Parent.BossFx)
local BossAttackFx = require(script.Parent.BossAttackFx)
local BossJuice = require(script.Parent.BossJuice)
local kit = BossAttackFx.kit
local part, tween, emitter, burst = kit.part, kit.tween, kit.emitter, kit.burst
local ring, headOf, waterY = kit.ring, kit.headOf, kit.waterY
local t1 = {}
local v1 = Color3.fromRGB(255, 90, 40)
local v2 = Color3.fromRGB(70, 20, 110)
local v3 = Color3.new(1, 1, 1)
local v4, Highlight
local n1 = 0
local v5 = v3
local PointLight
local n2 = 0
local BossHP
local n3 = 0

local function dress(p1) -- line: 39
    -- upvalues: emitter (copy), headOf (copy), v1 (copy), v2 (copy), v4 (ref), Highlight (ref), PointLight (ref)
    v4 = p1
    Highlight.Adornee = p1

    local v6 = headOf(p1)
    local v7 = p1:FindFirstChild("Nessie_NeckTop", true)

    if v6 then
        PointLight = Instance.new("PointLight")
        PointLight.Name = "BossEyes"
        PointLight.Color = v1
        PointLight.Range = 28
        PointLight.Brightness = 2.5
        PointLight.Parent = v6
        emitter(v6, {
            Name = "BossAura",
            LightEmission = 0.2,
            Acceleration = Vector3.new(0, 4, 0),
            Rate = 16,
            Color = ColorSequence.new(v2, Color3.fromRGB(20, 5, 35)),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 6),
                NumberSequenceKeypoint.new(1, 16)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.3, 0.55),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Lifetime = NumberRange.new(1.5, 2.5),
            Speed = NumberRange.new(2, 5),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-40, 40),
            Shape = Enum.ParticleEmitterShape.Box,
            ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
        })
        emitter(v6, {
            Name = "BossEmbers",
            LightEmission = 1,
            LightInfluence = 0,
            Acceleration = Vector3.new(0, 6, 0),
            Rate = 8,
            Color = ColorSequence.new(v1, Color3.fromRGB(255, 220, 120)),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.2),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Lifetime = NumberRange.new(0.8, 1.4),
            Speed = NumberRange.new(3, 7),
            SpreadAngle = Vector2.new(180, 180),
            Shape = Enum.ParticleEmitterShape.Box,
            ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
        })
    end

    for _, v8 in { v6, v7 } do
        if v8 then
            emitter(v8, {
                Name = "BossDrips",
                LightEmission = 0.2,
                Acceleration = Vector3.new(0, -70, 0),
                Rate = 30,
                Color = ColorSequence.new(Color3.fromRGB(190, 225, 255)),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.5),
                    NumberSequenceKeypoint.new(1, 0.2)
                }),
                Transparency = NumberSequence.new(0.2, 0.8),
                Lifetime = NumberRange.new(0.8, 1.3),
                Speed = NumberRange.new(0, 1),
                Shape = Enum.ParticleEmitterShape.Box,
                ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
            })
        end
    end
end

local function undress() -- line: 104
    -- upvalues: v4 (ref), Highlight (ref), PointLight (ref), BossHP (ref), n3 (ref)
    if v4 then
        for _, descendant in v4:GetDescendants() do
            if descendant.Name == "BossEyes" or descendant.Name == "BossAura" or descendant.Name == "BossEmbers" or descendant.Name == "BossDrips" or descendant.Name == "BossDissolve" then
                descendant:Destroy()
            end
        end
    end

    v4 = nil
    PointLight = nil
    Highlight.Adornee = nil
    BossHP = nil
    n3 = 0
end

function t1.reelHit(p2, p3) -- line: 122
    -- upvalues: UIUtil (copy), BossFx (copy), burst (copy), headOf (copy), waterY (copy), v3 (copy), n1 (ref), v5 (ref)
    local v9 = headOf(p2)

    if not v9 then
        return
    end

    n1 = math.max(n1, 0.55)
    v5 = v3
    burst(v9.Position, 6, {
        LightEmission = 1,
        Color = ColorSequence.new(Color3.fromRGB(255, 240, 150), Color3.fromRGB(255, 150, 40)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Lifetime = NumberRange.new(0.25, 0.45),
        Speed = NumberRange.new(25, 45),
        SpreadAngle = Vector2.new(180, 180)
    })

    if p3 % 2 == 0 then
        BossFx.splash(Vector3.new(v9.Position.X, waterY() + 1, v9.Position.Z), 4)
    end

    if p3 % 6 == 0 then
        UIUtil.sound(p3 % 12 == 0 and "BossRoar" or "BossGrowl", 0.4, 0.95 + math.random() * 0.1)
    end
end

function t1.surge(p4) -- line: 145
    -- upvalues: BossFx (copy), headOf (copy), waterY (copy), n2 (ref)
    local v12 = headOf(p4)

    if not v12 then
        return
    end

    BossFx.splash(Vector3.new(v12.Position.X, waterY() + 1, v12.Position.Z), 12)
    n2 = 0.7
end

function t1.bigHit(p5, p6) -- line: 155
    -- upvalues: UIUtil (copy), BossFx (copy), BossJuice (copy), burst (copy), ring (copy), headOf (copy), waterY (copy), n1 (ref), v5 (ref)
    local v14 = headOf(p5)

    if not v14 then
        return
    end

    if p6 ~= false then
        BossJuice.hitStop(0.12)
        BossJuice.impactFrame(Color3.new(1, 1, 1), 0.8, 0.3)
        BossJuice.fovPunch(9, 0.45)
    end

    BossJuice.explosion(v14.Position + (workspace.CurrentCamera.CFrame.Position - v14.Position).Unit * 4, 1.2)
    UIUtil.sound("BossScreech", 0.4, 1, 8)

    local v15 = Color3.fromRGB(255, 60, 60)

    n1 = 1
    v5 = v15
    ring(v14.Position, (workspace.CurrentCamera.CFrame.Position - v14.Position).Unit, 8, 60, 0.5, Color3.fromRGB(255, 220, 90), 0.2)
    burst(v14.Position, 50, {
        LightEmission = 1,
        Color = ColorSequence.new(Color3.fromRGB(255, 240, 150), Color3.fromRGB(255, 90, 40)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Lifetime = NumberRange.new(0.4, 0.8),
        Speed = NumberRange.new(40, 80),
        SpreadAngle = Vector2.new(180, 180)
    })
    BossFx.splash(Vector3.new(v14.Position.X, waterY() + 1, v14.Position.Z), 20)
    ring(Vector3.new(v14.Position.X, waterY() + 0.6, v14.Position.Z), Vector3.new(0, 1, 0), 6, 90, 0.7, Color3.fromRGB(220, 240, 255), 0.25)

    for i = 1, 3 do
        task.delay(i * 0.12, function() -- line: 183
            -- upvalues: v14 (copy), BossFx (copy), waterY (copy)
            if v14.Parent then
                BossFx.splash(Vector3.new(v14.Position.X, waterY() + 1, v14.Position.Z), 14)
            end
        end)
    end

    UIUtil.sound("BigSplash", 0.9, 0.8)
    task.delay(0.45, UIUtil.sound, "BossHitRoar", 0.4, 1)
end

local function lastRoar(p7) -- line: 196
    -- upvalues: UIUtil (copy), BossAttackFx (copy), kit (copy), n2 (ref)
    BossAttackFx.clear()
    kit.roar(p7, 0.75)
    task.delay(0.9, function() -- line: 199
        -- upvalues: p7 (copy), kit (copy)
        if p7.Parent then
            kit.roar(p7, 0.85)
        end
    end)
    UIUtil.sound("BossRoar", 1, 1, 8)
    n2 = 1
end

local function die(p8) -- line: 210
    -- upvalues: UIUtil (copy), BossFx (copy), BossJuice (copy), kit (copy), tween (copy), emitter (copy), burst (copy), ring (copy), headOf (copy), waterY (copy), v1 (copy), v3 (copy), n1 (ref), v5 (ref), PointLight (ref)
    local v20 = headOf(p8)

    for i = 0, 3 do
        task.delay(i * 0.35, function() -- line: 213
            -- upvalues: v3 (copy), n1 (ref), v5 (ref)
            n1 = 1
            v5 = v3
        end)
    end

    if PointLight then
        tween(PointLight, 0.8, {
            Brightness = 0,
            Range = 0
        })
    end

    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") and (descendant.Name == "BossAura" or descendant.Name == "BossEmbers" or descendant.Name == "BossDrips") then
            descendant.Enabled = false
        elseif descendant:IsA("BasePart") then
            task.delay(0.5, function() -- line: 225
                -- upvalues: descendant (copy), tween (copy)
                if descendant.Parent then
                    tween(descendant, 2, {
                        Transparency = 1
                    }, Enum.EasingStyle.Sine)
                end
            end)

            local v21 = emitter(descendant, {
                Name = "BossDissolve",
                LightEmission = 0.1,
                Acceleration = Vector3.new(0, 10, 0),
                Rate = 25,
                Color = ColorSequence.new(Color3.fromRGB(60, 20, 90), Color3.fromRGB(10, 5, 15)),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 3),
                    NumberSequenceKeypoint.new(1, 9)
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.3),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Lifetime = NumberRange.new(1, 1.8),
                Speed = NumberRange.new(4, 10),
                SpreadAngle = Vector2.new(180, 180),
                Rotation = NumberRange.new(0, 360),
                RotSpeed = NumberRange.new(-60, 60),
                Shape = Enum.ParticleEmitterShape.Box,
                ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
            })
            local v22 = emitter(descendant, {
                Name = "BossDissolve",
                LightEmission = 1,
                LightInfluence = 0,
                Acceleration = Vector3.new(0, 14, 0),
                Rate = 18,
                Color = ColorSequence.new(Color3.fromRGB(255, 230, 140), v1),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Lifetime = NumberRange.new(0.6, 1.2),
                Speed = NumberRange.new(6, 16),
                SpreadAngle = Vector2.new(180, 180),
                Shape = Enum.ParticleEmitterShape.Box,
                ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
            })

            task.delay(2.4, function() -- line: 260
                -- upvalues: v21 (copy), v22 (copy)
                v21.Enabled = false
                v22.Enabled = false
            end)
        end
    end

    if v20 then
        burst(v20.Position, 80, {
            LightEmission = 1,
            Color = ColorSequence.new(v3, Color3.fromRGB(255, 200, 90)),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 3),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Lifetime = NumberRange.new(0.6, 1.1),
            Speed = NumberRange.new(40, 90),
            SpreadAngle = Vector2.new(180, 180)
        })
        ring(v20.Position, (workspace.CurrentCamera.CFrame.Position - v20.Position).Unit, 10, 120, 0.8, v3, 0.1)

        local v24 = Vector3.new(v20.Position.X, waterY() + 0.6, v20.Position.Z)

        ring(v24, Vector3.new(0, 1, 0), 10, 160, 1.2, Color3.fromRGB(220, 240, 255), 0.2)
        kit.shakeFrom(v20.Position, 0.9, 300)
        task.delay(1.6, function() -- line: 279
            -- upvalues: v24 (copy), UIUtil (copy), BossFx (copy)
            BossFx.splash(v24, 40)
            UIUtil.sound("BigSplash", 1, 0.6)
        end)
    end

    BossJuice.deathChain(p8)
    UIUtil.sound("BossRoar", 1, 0.9, 8)
    UIUtil.sound("SubBoom", 1, 0.7)
    task.delay(0.5, UIUtil.sound, "Rumble", 0.8, 0.8)
end

local function damageNumber(p9, p10) -- line: 291
    -- upvalues: Debris (copy), Format (copy), Kit (copy), part (copy), tween (copy), v3 (copy)
    local v28 = part({
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        CFrame = CFrame.new(p9.Position + Vector3.new((math.random() - 0.5) * 12, p9.Size.Y * 0.5, (math.random() - 0.5) * 12))
    })
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(14, 6)
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = v28
    BillboardGui.Parent = v28

    local v29 = p10 >= 60
    local v32 = Kit.text(BillboardGui, ("-%*"):format((Format.short((math.floor(p10 + 0.5))))), {
        StrokeThickness = 3,
        Size = UDim2.fromScale(1, 1),
        TextColor3 = if v29 then Color3.fromRGB(255, 220, 80) else v3
    })
    local v33 = if v29 then UDim2.fromScale(26, 11) else BillboardGui.Size

    v32.Rotation = (math.random() - 0.5) * (v29 and 16 or 10)
    BillboardGui.Size = UDim2.fromScale(v33.X.Scale * 0.2, v33.Y.Scale * 0.2)
    tween(BillboardGui, 0.22, {
        Size = v33
    }, Enum.EasingStyle.Back)
    tween(BillboardGui, 0.9, {
        StudsOffsetWorldSpace = Vector3.new((math.random() - 0.5) * 6, v29 and 14 or 10, 0)
    })
    task.delay(0.45, function() -- line: 310
        -- upvalues: v32 (copy), tween (copy)
        tween(v32, 0.45, {
            TextTransparency = 1
        })
    end)
    Debris:AddItem(v28, 1)
end

function t1.update(p11, p12) -- line: 318
    -- upvalues: BossJuice (copy), headOf (copy), v4 (ref), Highlight (ref), n1 (ref), v5 (ref), PointLight (ref), n2 (ref), BossHP (ref), n3 (ref), dress (copy), undress (copy), lastRoar (copy), die (copy), damageNumber (copy)
    if p11 ~= v4 then
        undress()

        if p11 and p11.Parent then
            dress(p11)
        end
    end

    if not v4 then
        return
    end

    local BossDiedAt = workspace:GetAttribute("BossDiedAt")

    if workspace:GetAttribute("BossState") == "Won" and type(BossDiedAt) == "number" then
        if n3 < 1 then
            n3 = 1
            lastRoar(v4)
            BossJuice.finalBlow(v4, math.max(BossDiedAt - workspace:GetServerTimeNow(), 0) + 2.6)
        end

        if n3 < 2 and BossDiedAt <= workspace:GetServerTimeNow() then
            n3 = 2
            die(v4)
        end
    end

    local v39 = n1

    n1 = math.max(0, v39 - p12 * 4)
    Highlight.FillColor = v5
    Highlight.FillTransparency = 1 - n1 * 0.8
    Highlight.Enabled = n1 > 0.01

    local v41 = n2

    n2 = math.max(0, v41 - p12 * 1.2)

    if PointLight then
        PointLight.Brightness = n2 * 8 + 2.5 + math.sin(os.clock() * 13) * 0.4
        PointLight.Range = n2 * 30 + 28
    end

    local BossHP2 = workspace:GetAttribute("BossHP")

    if type(BossHP2) ~= "number" then
        return
    end

    local v44 = headOf(v4)

    if BossHP and BossHP2 < BossHP - 0.01 and v44 then
        damageNumber(v44, BossHP - BossHP2)
    end

    BossHP = BossHP2
end

function t1.clear() -- line: 364
    -- upvalues: undress (copy)
    undress()
end

function t1.init() -- line: 368
    -- upvalues: BossAttackFx (copy), kit (copy), Highlight (ref), n2 (ref)
    Highlight = Instance.new("Highlight")
    Highlight.Name = "BossHitFlash"
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Enabled = false
    Highlight.Parent = kit.folder()

    BossAttackFx.onRoar = function() -- line: 376
        -- upvalues: n2 (ref)
        n2 = 1
    end
end

return t1
