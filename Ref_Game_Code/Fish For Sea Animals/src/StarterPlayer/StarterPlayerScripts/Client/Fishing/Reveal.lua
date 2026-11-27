-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local ClearView = require(script.Parent.ClearView)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Effects = require(script.Parent.Effects)
local OddsCounter = require(script.Parent.OddsCounter)
local LuckFX = require(script.Parent.LuckFX)
local LuckScenes = require(script.Parent.LuckScenes)
local RarityText = require(script.Parent.Parent.UI.RarityText)
local Skip = require(script.Parent.Skip)
local Auras = require(script.Parent.Parent.Auras.Auras)
local t1 = {}
local v1 = Random.new()
local v2 = Color3.new(1, 1, 1)

local function shake(p1, p2) -- line: 36
    -- upvalues: Effects (copy)
    return Effects.shake(p1, p2)
end

function t1.pov(p3, _, p5) -- line: 42
    -- upvalues: RunService (copy), Config (copy), UIUtil (copy), Effects (copy), Skip (copy), v1 (copy), v2 (copy)
    if Skip.requested() then
        return
    end

    local CurrentCamera = workspace.CurrentCamera
    local landing, surfaceY, color = p3.landing, p3.surfaceY, p3.color
    local Folder = Instance.new("Folder")

    Folder.Name = "FishPOV"
    Folder.Parent = workspace
    p3.bobber.CFrame = CFrame.new(landing + Vector3.new(0, 0.1, 0))
    p3.cap.CFrame = CFrame.new(landing + Vector3.new(0, 0.32, 0))

    local v3 = landing - Vector3.new(0, 2.6, 0)
    local v4 = Effects.part({
        Name = "Hook",
        Size = Vector3.new(0.32, 0.32, 0.32),
        Shape = Enum.PartType.Ball,
        Color = Color3.fromRGB(190, 190, 200),
        Material = Enum.Material.Metal,
        Position = v3,
        Parent = Folder
    })

    Effects.part({
        Name = "Worm",
        Size = Vector3.new(0.22, 0.75, 0.22),
        Color = Color3.fromRGB(255, 120, 150),
        CFrame = CFrame.new(v3 - Vector3.new(0, 0.4, 0)) * CFrame.Angles(0, 0, 0.3490658503988659),
        Parent = Folder
    })

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = v4

    local clone = p3.line:Clone()

    clone.Attachment0 = p3.bobber.Line
    clone.Attachment1 = Attachment
    clone.Parent = v4
    Effects.part({
        Name = "Surface",
        Size = Vector3.new(260, 0.2, 260),
        Transparency = 0.3,
        Position = Vector3.new(landing.X, surfaceY - 0.05, landing.Z),
        Color = color:Lerp(v2, 0.5),
        Parent = Folder
    })

    local v6 = Effects.part({
        Name = "Bubbler",
        Size = Vector3.new(6, 4, 1),
        Transparency = 1,
        Parent = Folder
    })

    Effects.emitter(v6, {
        LightEmission = 0.2,
        Rate = 35,
        Color = ColorSequence.new(v2),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.12),
            NumberSequenceKeypoint.new(1, 0.28)
        }),
        Transparency = NumberSequence.new(0.35, 1),
        Lifetime = NumberRange.new(0.6, 1.2),
        Speed = NumberRange.new(2, 5),
        EmissionDirection = Enum.NormalId.Top
    })

    local v7 = Effects.underwaterLook(color)

    UIUtil.sound("Bubbles", 0.6)

    local v8 = UIUtil.sound("BubbleSwell", 0.8, 1, 30)

    if v8 then
        v8.Looped = true
    end

    Effects.flash(p5, color:Lerp(v2, 0.3), 0.35)

    local v13 = Vector3.new(math.clamp(landing.X + v1:NextNumber(-10, 10), -40, 40), surfaceY - 6, landing.Z - 30)
    local v14 = v3 + Vector3.new(0, -0.3, -1.4)
    local v15 = 4.5 * Config.CastPace

    CurrentCamera.FieldOfView = 95

    local elapsed = os.clock()

    while true do
        local v17 = math.min((os.clock() - elapsed) / v15, 1)
        local v18 = v17 * v17 * (3 - v17 * 2)
        local v20 = math.sin(v17 * 30) * (1 - v17) * 0.9
        local v24 = v13:Lerp(v14, v18) + Vector3.new(v20, math.sin(v17 * 15) * 0.25, 0)
        local v26 = CFrame.Angles(0, 0, math.sin(v17 * 30) * 0.08726646259971647 * (1 - v17))

        CurrentCamera.CFrame = CFrame.lookAt(v24, v3) * v26
        CurrentCamera.FieldOfView = 95 - v18 * 20
        v6.CFrame = CurrentCamera.CFrame * CFrame.new(0, -1.5, -4)

        if v17 >= 1 or Skip.requested() then
            break
        end

        RunService.Heartbeat:Wait()
    end

    UIUtil.sound("Splash", 0.9, 0.7)
    Effects.flash(p5, v2, 0.5, 0.3)

    if v8 then
        UIUtil.tween(v8, 0.8, {
            Volume = 0
        })
        task.delay(0.8, function() -- line: 110
            -- upvalues: v8 (copy)
            v8:Destroy()
        end)
    end

    local elapsed2 = os.clock()
    local _CFrame = CurrentCamera.CFrame

    while os.clock() - elapsed2 < 0.25 * Config.CastPace and not Skip.requested() do
        CurrentCamera.CFrame = Effects.shake(_CFrame, 0.35)
        RunService.Heartbeat:Wait()
    end

    v7()
    Folder:Destroy()
end

local function sideTag(p6, p7, p8) -- line: 126
    local v27 = p6:FindFirstChild(p7)

    if not v27 then
        v27 = p6.NewTag:Clone()
        v27.Name = p7

        local Y = v27.Position.Y
        local Y2 = v27.Size.Y
        local v28 = (p8 - 1) * 1.05

        v27.Position = UDim2.new(0, 40, Y.Scale - Y2.Scale * v28, Y.Offset - Y2.Offset * v28)
        v27.Rotation = -v27.Rotation
        v27.Parent = p6
    end

    return v27
end

local function newText(p9) -- line: 141
    if p9.IsNew then
        return "NEW!"
    end

    if p9.NewMutation then
        return "NEW MUTATION!"
    end

    return if p9.NewSize then "NEW SIZE!" else nil
end

local function showBanner(p10, p11, _, p13) -- line: 152
    -- upvalues: Config (copy), Animals (copy), Format (copy), UIUtil (copy), Effects (copy), RarityText (copy), v2 (copy), sideTag (copy)
    local Banner = p10.Banner
    local v29 = p11.Mutation and Config.MutationByName[p11.Mutation]
    local v30 = p11.Size and Config.SizeByName[p11.Size]

    Banner.Rarity.Text = string.upper(p13.Name)
    RarityText.apply(Banner.Rarity, p13)
    Banner.AnimalName.Text = p11.Name or Animals.displayName(p11)

    local v31 = Format.money(p11.Income or Animals.income(p11))
    local Income = Banner.Income

    if p11.Weight then
        Income.Text = ("+%*/s   %*"):format(v31, (Animals.formatWeight(p11.Weight)))
    else
        Income.Text = ("+%*/s"):format(v31)
    end

    local NewTag = Banner.NewTag

    if NewTag:GetAttribute("HomeText") == nil then
        NewTag:SetAttribute("HomeText", NewTag.Text)
    end

    NewTag.Visible = false

    local v32 = sideTag(Banner, "MutationTag", 1)

    v32.Visible = false

    local v34 = sideTag(Banner, "SizeTag", if v29 then 2 else 1)

    v34.Visible = false
    Banner.Visible = true

    for v35, v36 in {
            Banner.Rarity,
            Banner.AnimalName,
            Banner.Income
        } do
        v36.Visible = false
        task.delay((v35 - 1) * 0.18 * Config.CastPace, function() -- line: 173
            -- upvalues: v36 (copy), UIUtil (copy)
            v36.Visible = true
            UIUtil.pop(v36, 0.2)
        end)
    end

    local v37 = if p11.IsNew then "NEW!"
        elseif p11.NewMutation then "NEW MUTATION!"
        elseif p11.NewSize then "NEW SIZE!"
        else nil

    if v37 then
        NewTag.Text = if p11.IsNew then NewTag:GetAttribute("HomeText") else v37
        task.delay(0.6 * Config.CastPace, function() -- line: 181
            -- upvalues: NewTag (copy), UIUtil (copy)
            NewTag.Visible = true
            UIUtil.pop(NewTag, 2.5)
        end)
    end

    if v29 then
        v32.Text = string.upper(v29.Name)
        RarityText.apply(v32, v29)
        task.delay(0.45 * Config.CastPace, function() -- line: 189
            -- upvalues: v32 (copy), UIUtil (copy)
            v32.Visible = true
            UIUtil.pop(v32, 2.5)
        end)
    end

    if not v30 then
        return
    end

    local Y = v32.Position.Y
    local Y2 = v32.Size.Y
    local v39 = if v29 then 1.05 else 0

    v34.Position = UDim2.new(v32.Position.X, UDim.new(Y.Scale - Y2.Scale * v39, Y.Offset - Y2.Offset * v39))
    v34.Text = string.upper(v30.Name)
    RarityText.apply(v34, v30)
    task.delay((0.55 + v30.Index * 0.04) * Config.CastPace, function() -- line: 202
        -- upvalues: p10 (copy), v34 (copy), v30 (copy), UIUtil (copy), Effects (copy), v2 (copy)
        v34.Visible = true
        UIUtil.pop(v34, 2.5 + v30.Index * 0.25)

        if v30.Index >= 4 then
            Effects.flash(p10, v30.Color:Lerp(v2, 0.4), 0.45, 0.12)
            UIUtil.sound("Splash", 0.7, 0.45)
        end
    end)
end

local function waitForContinue(p14, p15, p16, p17) -- line: 214
    -- upvalues: UserInputService (copy)
    if not p17 then
        task.wait(p16)

        return
    end

    local elapsed = os.clock()
    local v40 = false
    local elapsed2 = elapsed
    local connection = UserInputService.InputBegan:Connect(function(p18) -- line: 223
        -- upvalues: p15 (copy), elapsed (copy), v40 (ref), elapsed2 (ref)
        local UserInputType = p18.UserInputType

        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch and p18.KeyCode ~= Enum.KeyCode.Space and p18.KeyCode ~= Enum.KeyCode.ButtonA then
            return
        end

        local elapsed3 = os.clock()
        local v41 = elapsed3 - elapsed

        if p15 <= v41 and (elapsed3 - elapsed2 >= 0.45 or p15 + 0.3 <= v41) then
            v40 = true
        end

        elapsed2 = elapsed3
    end)

    task.delay(p15, function() -- line: 236
        -- upvalues: p14 (copy), v40 (ref)
        if not v40 then
            p14.Continue.Visible = true
        end
    end)

    while not v40 and os.clock() - elapsed < p16 do
        task.wait()
    end

    connection:Disconnect()
    p14.Continue.Visible = false
end

local t3 = {}

local function onCleanup(p19) -- line: 251
    -- upvalues: t3 (copy)
    table.insert(t3, p19)
end

function t1.cleanup() -- line: 255
    -- upvalues: t3 (copy)
    for _, v42 in t3 do
        pcall(v42)
    end

    table.clear(t3)
end

function t1.show(p20, p21, p22) -- line: 269
    -- upvalues: RunService (copy), Config (copy), Animals (copy), Canyon (copy), ClearView (copy), AnimalModel (copy), UIUtil (copy), Effects (copy), OddsCounter (copy), LuckFX (copy), LuckScenes (copy), Skip (copy), Auras (copy), t1 (copy), v1 (copy), v2 (copy), showBanner (copy), waitForContinue (copy), t3 (copy)
    local CurrentCamera = workspace.CurrentCamera
    local CastPace = Config.CastPace
    local v43 = Animals.get(p21.Id)
    local v44 = Config.RarityByName[p21.Rarity or v43.Rarity]
    local v45 = Animals.displaySize(p21)
    local landing, surfaceY, color = p20.landing, p20.surfaceY, p20.color
    local X = landing.X
    local v47 = Vector3.new(X, surfaceY, landing.Z)
    local v49 = v47 + Vector3.new(0, math.clamp(v45 * 0.8, 1.2, 3) + v45 * 0.55, 0)
    local v50 = math.clamp(v45 / 4, 0.6, 1)
    local v51, v52
    local v46 = (v45 * 1.15 + math.clamp(v45 * 2, 3, 8)) * v50

    if landing.Z + v46 > -Canyon.dockS(-landing.Z) - 3 then
        v51 = landing.Z - v46
        v52 = 205
    else
        v51 = landing.Z + v46
        v52 = -25
    end

    local v53 = math.rad(v52)
    local v57 = Canyon.clearView(Vector3.new(math.clamp(landing.X + (v45 * 0.9 + math.clamp(v45, 1.5, 4)) * v50, -44, 44), surfaceY + math.clamp(v45 * 0.9, 1.5, 3.5) * v50, v51), v47)

    p20.bobber:Destroy()

    local Folder = Instance.new("Folder")

    Folder.Name = "Reveal"
    Folder.Parent = workspace

    local v58 = Effects.heave(p20.liquid)

    table.insert(t3, function() -- line: 296
        -- upvalues: v58 (copy)
        v58(0)
    end)

    local v59

    v59, v52 = Effects.storm(v44.Color)
    table.insert(t3, v52)

    local v60 = Config.worldAt(v47) > 1
    local v61

    if v60 then
        local Lighting = game:GetService("Lighting")
        local ExposureCompensation = Lighting.ExposureCompensation
        local BloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")

        v61 = if BloomEffect then BloomEffect.Intensity else 0
        UIUtil.tween(Lighting, 0.5, {
            ExposureCompensation = ExposureCompensation - 0.85
        })

        if BloomEffect then
            UIUtil.tween(BloomEffect, 0.5, {
                Intensity = v61 * 0.15
            })
        end

        Effects.flashScale = 0.5

        local function kept(p23) -- line: 320
            -- upvalues: Folder (copy)
            while true do
                if not p23 or p23 == Folder then
                    return false
                end

                if p23:GetAttribute("Untamed") then
                    break
                end

                p23 = p23.Parent
            end

            return true
        end

        local function tame(p24) -- line: 330
            -- upvalues: Folder (copy)
            if p24:IsA("ParticleEmitter") then
                p24.LightEmission *= 0.5
                p24.Brightness = math.min(p24.Brightness, 1.5)
            elseif p24:IsA("BasePart") then
                task.defer(function() -- line: 337
                    -- upvalues: p24 (copy), Folder (copy)
                    if p24.Material ~= Enum.Material.Neon then
                        return
                    end

                    local v63 = p24
                    local v64

                    while true do
                        if not v63 or v63 == Folder then
                            v64 = false
                            break
                        end

                        if v63:GetAttribute("Untamed") then
                            v64 = true
                            break
                        end

                        v63 = v63.Parent
                    end

                    if not v64 then
                        p24.Color = p24.Color:Lerp(Color3.new(0, 0, 0), 0.35)
                    end
                end)
            elseif p24:IsA("Light") then
                task.defer(function() -- line: 343
                    -- upvalues: p24 (copy), Folder (copy)
                    local v65 = p24
                    local v66

                    while true do
                        if not v65 or v65 == Folder then
                            v66 = false
                            break
                        end

                        if v65:GetAttribute("Untamed") then
                            v66 = true
                            break
                        end

                        v65 = v65.Parent
                    end

                    if not v66 then
                        p24.Brightness *= 0.5
                    end
                end)
            end
        end

        local connection = Folder.DescendantAdded:Connect(tame)
        local v67 = v61

        table.insert(t3, function() -- line: 351
            -- upvalues: Lighting (copy), ExposureCompensation (copy), BloomEffect (copy), connection (copy), v67 (copy), UIUtil (copy), Effects (copy)
            connection:Disconnect()
            Effects.flashScale = 1
            UIUtil.tween(Lighting, 0.6, {
                ExposureCompensation = ExposureCompensation
            })
            UIUtil.tween(Lighting, 0.6, {
                ExposureCompensation = ExposureCompensation
            })

            if BloomEffect then
                UIUtil.tween(BloomEffect, 0.6, {
                    Intensity = v67
                })
            end
        end)
    end

    local v55 = ClearView.hide(v57, v49, math.max(v45 * 0.6, 2) + 3)

    table.insert(t3, v55)

    local v70 = LuckFX.stage(p21.Odds or 1)
    local v54 = (1.8 + LuckFX.extraHold(v70)) * CastPace

    table.insert(t3, function() -- line: 366
        -- upvalues: p22 (copy), LuckFX (copy)
        LuckFX.reset(p22)
    end)
    v61 = p20.odds

    local v72, v73, v74, PointLight, v75, v76, v77, Magnitude, v78, v79, v80, v81, v82, v83, v84, v85, v86, v87

    if v61 then
        v77 = v61
    else
        v72 = Effects.part
        v73 = {
            Name = "Bubbles",
            Transparency = 1
        }

        local v88 = v45 * 0.25

        v75 = v45 * 0.25
        v73.Size = Vector3.new(v88, 0.2, v75)
        v73.Position = v47 - Vector3.new(0, 3, 0)
        v73.Parent = Folder
        v72 = v72(v73)
        v73 = Effects.emitter(v72, {
            LightEmission = 0.15,
            Rate = 3,
            Color = ColorSequence.new(v2, color:Lerp(v2, 0.7)),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.12),
                NumberSequenceKeypoint.new(1, 0.32)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.6),
                NumberSequenceKeypoint.new(0.85, 0.25),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Lifetime = NumberRange.new(0.7, 1),
            Speed = NumberRange.new(3, 4.2),
            SpreadAngle = Vector2.new(8, 8),
            EmissionDirection = Enum.NormalId.Top
        })
        v74 = Effects.part
        v88 = {
            Name = "Fizz",
            Transparency = 1
        }
        v75 = v45 * 0.3
        v88.Size = Vector3.new(v75, 0.1, v45 * 0.3)
        v88.Position = v47 + Vector3.new(0, 0.1, 0)
        v88.Parent = Folder
        v74 = v74(v88)
        v88 = Effects.emitter(v74, {
            LightEmission = 0.2,
            Acceleration = Vector3.new(0, -6, 0),
            Rate = 0,
            Color = ColorSequence.new(v2),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.18),
                NumberSequenceKeypoint.new(1, 0.05)
            }),
            Transparency = NumberSequence.new(0.25, 1),
            Lifetime = NumberRange.new(0.25, 0.5),
            Speed = NumberRange.new(0.6, 2),
            SpreadAngle = Vector2.new(60, 60),
            EmissionDirection = Enum.NormalId.Top
        })
        PointLight = Instance.new("PointLight")
        PointLight.Color = v44.Color
        PointLight.Range = v45 * 2.5
        PointLight.Brightness = 0
        PointLight.Parent = v72
        UIUtil.sound("Bubbles", 0.35, 0.8)
        v75 = UIUtil.sound("BubbleSwell", 0, 0.55, 12)

        if v75 then
            v75.Looped = true
            UIUtil.tween(v75, 2 * CastPace, {
                Volume = 0.35
            })
        end

        local v90 = (2.8 + v44.Index * 0.3 + LuckFX.extraBuild(v70)) * CastPace

        v76 = LuckFX.buildUp(p22)
        v77 = OddsCounter.start(p22, p21.Odds or 1, v90)
        v87 = v57.X - v47.X
        Magnitude = v57.Z - v47.Z

        local v89 = math.atan2(v87, Magnitude)

        v87 = if landing.X > 0 then -1 else 1
        Magnitude = Vector2.new(v57.X - v47.X, v57.Z - v47.Z).Magnitude
        CurrentCamera.FieldOfView = 55
        v78 = os.clock()
        v85 = -1
        v86 = -1

        while true do
            v79 = os.clock() - v78
            v80 = math.min(v79 / v90, 1)

            local v91 = v45 * (v80 * 0.45 + 0.15)

            v72.Size = Vector3.new(v91, 0.2, v91)
            v82 = v91 * 1.2
            v83 = v91 * 1.2
            v74.Size = Vector3.new(v82, 0.1, v83)
            v82 = v80 * 40 * v80 + 3
            v81 = if v80 > 0.85 then (v80 - 0.85) * 120 / 0.15 else 0
            v73.Rate = v82 + v81
            PointLight.Brightness = v80 * 3 * v80

            local v92, v93

            if v79 - v85 > 0.5 - v80 * 0.42 then
                v85 = v79
                v81 = v1:NextNumber(0, 6.283185307179586)
                v82 = v1:NextNumber(0, v91 * 0.6)
                v93 = math.cos(v81) * v82
                v74.Position = v47 + Vector3.new(v93, 0.1, math.sin(v81) * v82)
                v92 = v80 * 10 + 2
                v88:Emit((math.floor(v92)))
            end

            local v95

            if v80 > 0.35 and v79 - v86 > 1.1 - v80 * 0.7 then
                v86 = v79
                UIUtil.sound("Bubbles", v80 * 0.25 + 0.12, v1:NextNumber(0.9, 1.2))
                v95 = Effects.ripple
                v92 = v1:NextNumber(-1, 1)
                v95(v47 + Vector3.new(v92, 0, v1:NextNumber(-1, 1)) * v91 * 0.3, v45 * (v80 * 0.5 + 0.4), color:Lerp(v2, 0.7))
            end

            v91 = v80 * v80 * (3 - v80 * 2)
            v95 = v89 + v87 * v91 * 0.3141592653589793
            v82 = Magnitude * (1 - v91 * 0.18)
            v83 = math.clamp(v47.X + math.sin(v95) * v82, -44, 44)
            v81 = Vector3.new(v83, v57.Y + v91 * 1.5 + math.sin(v79 * 0.9) * 0.15, v47.Z + math.cos(v95) * v82)
            CurrentCamera.FieldOfView = 55 - v91 * 8
            v83 = v76(Config.luckStage(v77.update(v80)))
            CurrentCamera.CFrame = Effects.shake(CFrame.lookAt(v81, v47 + Vector3.new(0, 1, 0)), v83)

            if v80 >= 1 or Skip.requested() then
                break
            end

            RunService.Heartbeat:Wait()
        end

        v84 = v75
        Skip.stop()
        v73.Enabled = false
    end

    table.insert(t3, v77.reset)

    if v84 then
        UIUtil.tween(v84, 0.6 * CastPace, {
            Volume = 0
        })
    end

    v72 = math.min(v45, 24)
    table.insert(t3, function() -- line: 467
        -- upvalues: p22 (copy)
        for _, v97 in { "LuckHush", "LuckSlowMo" } do
            local v98 = game:GetService("Lighting"):FindFirstChild(v97)

            if v98 then
                v98:Destroy()
            end
        end

        for _, child in p22:GetChildren() do
            if child.Name:match("^LuckEdge") or child.Name == "Crack" or child.Name == "Shard" then
                child:Destroy()
            end
        end
    end)

    local v56 = LuckScenes.prelude(v70, p22, v47, v72, v44, Folder, LuckFX.title(p22))

    v77.finish(v44.Color:Lerp(v2, 0.25))
    v73 = AnimalModel.clone(v43.Id, v45, p21.Mutation)
    v73:SetAttribute("Untamed", true)
    v73.Parent = Folder

    local v99 = AnimalModel.rig(v73)

    v74 = AnimalModel.body(v73)

    local v100 = Auras.make(v43, v73, v45)

    PointLight = Instance.new("PointLight")
    PointLight.Color = v44.Color:Lerp(v2, 0.5)
    PointLight.Range = v45 * 2
    PointLight.Brightness = v60 and 0.3 or 0.8
    PointLight.Parent = v74
    PointLight = (v57 - v49).Unit

    if v60 then
        Magnitude = v45 * 0.9 + 5
        v87 = math.min(Magnitude, 40)
    else
        Magnitude = v45 * 0.7 + 10
        v87 = math.min(Magnitude, 45)
    end

    v75 = v49 + PointLight * v87 + Vector3.new(0, v45 * 0.3 + 3, 0)
    v76 = Effects.part({
        Name = "KeyLight",
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1,
        CFrame = CFrame.lookAt(v75, v49)
    })
    v76:SetAttribute("Untamed", true)
    v76.Parent = Folder
    v75 = Instance.new("SpotLight")
    v75.Face = Enum.NormalId.Front
    v75.Angle = 70
    v75.Range = v60 and 30 or 60
    v75.Brightness = v60 and 3 or 2
    v75.Color = v2:Lerp(v44.Color, 0.12)
    v75.Parent = v76

    if v60 then
        v75 = Instance.new("PointLight")
        v75.Brightness = 1
        v75.Range = (v57 - v49).Magnitude + v45 + 4
        v75.Color = v2
        v75.Shadows = false
        v76 = Effects.part({
            Name = "FillLight",
            Size = Vector3.new(0.2, 0.2, 0.2),
            Transparency = 1,
            Position = v57:Lerp(v49, 0.15)
        })
        v76:SetAttribute("Untamed", true)
        v76.Parent = Folder
        v75.Parent = v76
    end

    if v45 < 4 then
        v76 = Instance.new("Highlight")
        v76.Name = "SmallOutline"
        v76.FillTransparency = 1
        v76.OutlineColor = v44.Color:Lerp(v2, 0.5)
        v76.OutlineTransparency = 0.25
        v76.DepthMode = Enum.HighlightDepthMode.Occluded
        v76.Adornee = v73
        v76.Parent = v73
    end

    local v101 = Effects.emitter(v74, {
        Acceleration = Vector3.new(0, -55, 0),
        Color = ColorSequence.new(color:Lerp(v2, 0.6)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 0.1)
        }),
        Transparency = NumberSequence.new(0.2, 0.9),
        Lifetime = NumberRange.new(0.5, 0.9),
        Speed = NumberRange.new(0, 2),
        SpreadAngle = Vector2.new(180, 180),
        Rate = v72 * 4 + 60
    })

    task.delay(2.2 * CastPace, function() -- line: 552
        -- upvalues: v101 (copy)
        v101.Enabled = false
    end)
    v76 = Effects.part
    v77 = {
        Name = "Rain",
        Transparency = 1
    }
    v77.Size = Vector3.new(v72 * 4, 1, v72 * 4)
    v85 = v72 * 2.5
    v77.Position = v47 + Vector3.new(0, v85, 0)
    v77.Parent = Folder
    v76 = v76(v77)

    local v102 = Effects.emitter(v76, {
        Acceleration = Vector3.new(0, -60, 0),
        Rate = 400,
        Color = ColorSequence.new(color:Lerp(v2, 0.7)),
        Size = NumberSequence.new(0.18),
        Transparency = NumberSequence.new(0.3, 0.8),
        Lifetime = NumberRange.new(0.8, 1.2),
        Speed = NumberRange.new(4, 8),
        EmissionDirection = Enum.NormalId.Bottom
    })

    task.delay(1.8 * CastPace, function() -- line: 567
        -- upvalues: v102 (copy)
        v102.Enabled = false
    end)
    v74 = v72 / 12 + 0.9
    Effects.breach(v47, color, v74 * 1.6)

    for i = 0, 2 do
        task.delay(i * 0.22 * CastPace, Effects.wave, v47, color, v72 * (i + 5), 3 + v44.Index * 0.5 - i * 0.6, 2.4 * CastPace)
    end

    Effects.flash(p22, v44.Color:Lerp(v2, 0.6), 0.7, 0.15)
    UIUtil.sound("Splash", 1, 0.6)
    UIUtil.sound("Splash", 0.8, 0.85)
    UIUtil.sound("Reveal", 0.9)
    showBanner(p22, p21, v43, v44)

    local v103 = LuckFX.burst(v70, p22, v47, v49, v72, v44, Folder, v57, v56)

    LuckScenes.slowBlur(v70)

    local v104 = LuckScenes.clock(v70)
    local v105 = Effects.rays(v49, v57, v45, v44, Folder)

    for i = 1, 8 do
        v78 = i / 8 * 3.141592653589793 * 2 + v1:NextNumber(-0.3, 0.3)
        v85 = v72 * v1:NextNumber(0.9, 1.8)
        v86 = task.delay
        v79 = v1:NextNumber(0, 0.45) * CastPace
        v80 = Effects.splash
        v82 = math.cos(v78) * v85
        v83 = math.sin(v78) * v85
        v86(v79, v80, v47 + Vector3.new(v82, 0, v83), color, v1:NextNumber(0.6, 1.1))
    end

    color = if v44.Index >= 4 then 0.25 else 0

    local v106 = p20.odds ~= nil

    if v106 then
        Magnitude = -40
    else
        surfaceY -= v45 * 0.9
        Magnitude = -75
    end

    local v107 = math.rad(Magnitude)
    local _CFrame, FieldOfView = CurrentCamera.CFrame, CurrentCamera.FieldOfView
    local elapsed = os.clock()

    v78 = p20.cover
    p20.cover = nil

    if v78 then
        task.delay(0.3 * CastPace, v78.Destroy, v78)
    end

    local v108 = false
    local v109 = math.clamp((v57 - v49).Magnitude / 15, 0.35, 1)

    if v60 then
        local Lighting = game:GetService("Lighting")
        local ColorGrade = Lighting:FindFirstChild("ColorGrade")

        v81 = Enum.RenderPriority.Last.Value
        RunService:BindToRenderStep("RevealKeepLit", v81, function() -- line: 624
            -- upvalues: Lighting (copy), ColorGrade (copy)
            for _, child in Lighting:GetChildren() do
                if child:IsA("ColorCorrectionEffect") and child ~= ColorGrade then
                    if child.Brightness < -0.03 then
                        child.Brightness = -0.03
                    end

                    if child.Contrast > 0.15 then
                        child.Contrast = 0.15
                    end
                end
            end
        end)

        v86 = function() -- line: 636
            -- upvalues: RunService (copy)
            RunService:UnbindFromRenderStep("RevealKeepLit")
        end

        table.insert(t3, v86)
    end

    v86 = RunService.Heartbeat
    v86 = v86:Connect(function() -- line: 641
        -- upvalues: CurrentCamera (copy), CastPace (copy), v44 (copy), surfaceY (ref), color (ref), v47 (copy), v49 (copy), v53 (copy), v57 (copy), v58 (copy), v59 (ref), v60 (copy), v70 (copy), v99 (copy), v100 (copy), v103 (copy), v104 (copy), v105 (copy), v106 (copy), v107 (copy), _CFrame (copy), FieldOfView (copy), elapsed (copy), v108 (ref), v109 (copy), AnimalModel (copy), Effects (copy), Auras (copy)
        local v110 = v104(os.clock() - elapsed) / CastPace

        v58(math.cos(v110 * 5) * 2.4 * math.exp(-v110 * 1.3))

        local v118 = math.max(math.min(0.25 + 0.12 * v70, if v60 then 0.6 else 0.9), 1 - v110 / 1.2)
        local v119 = if v110 < color then 1 - v110 / color else 0

        v59(v118, v119)

        local v120

        if v110 < 1 then
            local v121 = 1 - (1 - v110 / 1) ^ 3
            local v122 = surfaceY + (v49.Y - surfaceY) * v121
            local v123 = v107 * (1 - v121) ^ 1.5

            v120 = CFrame.new(v49.X, v122, v49.Z) * CFrame.Angles(0, v53 + (1 - v121) * 3.141592653589793 * 2, 0) * CFrame.Angles(v123, 0, 0)
        else
            local v124 = v110 - 1

            v120 = CFrame.new(v49 + Vector3.new(0, math.sin(v124 * 2) * 0.35, 0)) * CFrame.Angles(0, v53 + math.sin(v124 * 0.8) * 0.35, 0)
        end

        AnimalModel.pose(v99, v120, v110, v110 < 1.4 and 1 or 0.5)

        if v100 then
            Auras.move(v100, v120.Position, v110, -v120.LookVector)
        end

        v105(v110)

        local v130 = v47:Lerp(v49, (math.min(v110 / 1, 1)))
        local v132 = math.min(v110 / 3, 1) * 0.18
        local v133 = CFrame.lookAt(v57:Lerp(v49, v132), v130)
        local v134, v135 = v103(v110)

        if v110 < 0.9 then
            local v136 = (0.9 - v110) * (0.5 + v44.Index * 0.08) * v109

            v133 = Effects.shake(v133, v136)
        end

        if v134 > 0 then
            local v137 = v134 * v109

            v133 = Effects.shake(v133, v137)
        end

        local v139 = math.max(0, 1 - v110 / 0.7) ^ 2 * 22 + 55
        local v143 = v133 * CFrame.Angles(math.atan(math.tan(math.rad(v139 + v135) / 2) * 0.24), 0, 0)

        if v106 and v110 < 0.5 then
            local v144 = v110 / 0.5
            local v145 = v144 * v144 * (3 - 2 * v144)

            v143 = _CFrame:Lerp(v143, v145)
            v139 = FieldOfView + (v139 - FieldOfView) * v145
        end

        if not v108 then
            CurrentCamera.FieldOfView = v139 + v135
            CurrentCamera.CFrame = v143
        end
    end)
    waitForContinue(p22, v54, p21.Hold or (6 + v70 * 1.2) * CastPace, p21.Hold == nil)
    v108 = true
    v86:Disconnect()
    p22.Banner.Visible = false
    Effects.flash(p22, v2, 0.35, 0.4)

    if v84 then
        v84:Destroy()
    end

    Folder:Destroy()

    if v100 then
        Auras.destroy(v100)
    end

    t1.cleanup()

    if not p21.Preview then
        UIUtil.toast(("%* added to your inventory! Place it on your plot 🎒"):format((Animals.displayName(p21))), "success")
    end
end

return t1
