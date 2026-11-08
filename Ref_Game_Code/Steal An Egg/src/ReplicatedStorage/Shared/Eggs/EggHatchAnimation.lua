-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)

require(ReplicatedStorage.Shared.Types.AssetItem)

local Audio = require(ReplicatedStorage.Shared.Audio)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local CollisionGroups = require(ReplicatedStorage.Shared.Types.CollisionGroups)
local EggActionMovement = require(script.Parent.EggActionMovement)
local EggRenderer = require(script.Parent.EggRenderer)
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local EmitTree = require(ReplicatedStorage.Shared.Utils.VFX).EmitTree
local ItemDisplay = require(ReplicatedStorage.Shared.Modules.ItemDisplay)
local Player = require(ReplicatedStorage.Shared.Player)
local SfxRework = require(ReplicatedStorage.Data.SfxRework)
local VisualTransform = require(ReplicatedStorage.Shared.Utils.VisualTransform)
local t = require(ReplicatedStorage.Packages.t)
local v1 = Color3.fromRGB(248, 248, 248)
local Assets2 = ReplicatedStorage.Assets
local Transient = Workspace.Transient
local PlacedEggOpen = Assets2.Particles["Egg Open"].PlacedEggOpen
local EggExplode, Trail = PlacedEggOpen.EggExplode, PlacedEggOpen.Trail
local EggPoof = Assets2.EggPoof

assert(Transient:IsA("Folder"), "Workspace.Transient must be a Folder")
assert(EggExplode:IsA("Model"), "PlacedEggOpen.EggExplode must be a Model")
assert(Trail:IsA("Trail"), "PlacedEggOpen.Trail must be a Trail")
assert(EggPoof:IsA("BasePart"), "Assets.EggPoof must be a BasePart")

for _, descendant in EggExplode:GetDescendants() do
    if descendant:IsA("BasePart") then
        descendant.CollisionGroup = CollisionGroups.PLAYER_COLLISION_GROUP
    end
end

local t1 = {}

local function buildAssetItemData(p1, p2) -- line: 90
    return {
        HasBeenFirstPlaced = false,
        Category = p1.AssetCategory,
        Scale = p2 or p1.AssetScale,
        EyeColor = p1.AssetEyeColor,
        ColorSeed = p1.AssetColorSeed,
        ColorIndex = p1.AssetColorIndex,
        Mutations = p1.Mutations or {},
        BaseMutation = p1.BaseMutation
    }
end

local function playPoofSound() -- line: 106
    -- upvalues: Audio (copy)
    Audio.Play("rbxassetid://102267539121951", script)
end

local function playAssetRevealSound(p3, p4) -- line: 108
    -- upvalues: Assets (copy), Audio (copy), SfxRework (copy)
    local v2 = SfxRework.Resolve(p3.AssetCategory, "Idle", Assets.Directory[p3.AssetCategory].RandomIdleSound)

    if v2 == nil then
        return nil
    end

    return Audio.PlayFile(v2, p4)
end

local function arcApex(p5, p6) -- line: 117
    local v4 = math.clamp((p6 - p5).Magnitude * 0.6, 2, 36)

    return p5:Lerp(p6, 0.5) + Vector3.new(0, 1, 0) * v4
end

local function arcPosition(p7, p8, p9) -- line: 127
    local v6 = math.clamp((p8 - p7).Magnitude * 0.6, 2, 36)
    local v7 = p7:Lerp(p8, 0.5) + Vector3.new(0, 1, 0) * v6

    return p7:Lerp(v7, p9):Lerp(v7:Lerp(p8, p9), p9)
end

local function getPlayerBodyPosition(p10, p11) -- line: 132
    -- upvalues: Player (copy)
    local v8 = Player.FindPrimaryPart(p10)

    if v8 then
        return v8:GetPivot().Position
    end

    return p11
end

local function getBottomCFrameFacingPlayer(p12, p13, p14) -- line: 137
    -- upvalues: Players (copy), Player (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p12)

    if PlayerByUserId == nil then
        return CFrame.new(p13) * p14
    end

    local v9 = Player.FindPrimaryPart(PlayerByUserId)
    local v10 = if v9 then v9:GetPivot().Position else p13
    local v11 = Vector3.new(v10.X, p13.Y, v10.Z)

    if (p13 - v11).Magnitude < 0.001 then
        return CFrame.new(p13) * p14
    end

    return CFrame.lookAt(p13, v11)
end

local function shakeEggPass(p15, p16, p17) -- line: 156
    -- upvalues: RunService (copy), EggActionMovement (copy)
    local n1 = 0

    while n1 < 0.5 do
        n1 += RunService.Heartbeat:Wait()

        local v14 = (1 - n1 / 0.5) * math.sin(tick() * 90) * p17

        EggActionMovement.SetPivot(p15, p16 * CFrame.Angles(0, 0, (math.rad(v14))))
    end
end

local function shakeEgg(p18, p19) -- line: 165
    -- upvalues: shakeEggPass (copy)
    shakeEggPass(p18, p19, 7)
    task.wait(0.3)
    shakeEggPass(p18, p19, 9)
    task.wait(0.3)
    shakeEggPass(p18, p19, 13)
end

local function pivotAssetToEggBottom(p20, p21) -- line: 173
    -- upvalues: ModelBounds (copy)
    local Pivot = p20:GetPivot()
    local v15, v16 = ModelBounds(p20)
    local v17 = v15.Position - Vector3.new(0, 1, 0) * (v16.Y * 0.5) - Pivot.Position
    local v18 = p21.Position - v17
    local v19 = p21 - p21.Position

    p20:PivotTo(CFrame.new(v18) * v19)
end

local n2 = 0

local function runHatchMotion(p22, p23) -- line: 190
    -- upvalues: RunService (copy), n2 (ref)
    n2 += 1

    local v20 = ("EggHatchAnimation.%*"):format(n2)
    local n3 = 0
    local v21 = false

    RunService:BindToRenderStep(v20, Enum.RenderPriority.Last.Value, function(p24) -- line: 195
        -- upvalues: p22 (copy), p23 (copy), n3 (ref), v21 (ref)
        if v21 then
            return
        end

        n3 = math.min(n3 + p24, p22)

        local v23 = n3 / p22
        local ok, result = pcall(p23, v23)

        if not ok then
            warn((("EggHatchAnimation motion step failed: %*"):format(result)))
        end

        if not ok or result or n3 >= p22 then
            v21 = true
        end
    end)

    while not v21 do
        task.wait()
    end

    RunService:UnbindFromRenderStep(v20)
end

local function growAsset(p25, p26, p27) -- line: 215
    -- upvalues: TweenService (copy), pivotAssetToEggBottom (copy), runHatchMotion (copy)
    local v24 = p27 * 0.5

    runHatchMotion(1.3, function(p28) -- line: 217
        -- upvalues: p25 (copy), p26 (copy), p27 (copy), v24 (copy), TweenService (copy), pivotAssetToEggBottom (copy)
        if p25.Parent == nil then
            return true
        end

        local Value = TweenService:GetValue(p28, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

        p25:ScaleTo(v24 + (p27 - v24) * Value)
        pivotAssetToEggBottom(p25, p26)

        return nil
    end)

    if p25.Parent ~= nil then
        p25:ScaleTo(p27)
        pivotAssetToEggBottom(p25, p26)
    end
end

local function lookAtPlayer(p29, p30) -- line: 236
    -- upvalues: TweenService (copy), Player (copy), runHatchMotion (copy)
    local Pivot = p29:GetPivot()

    runHatchMotion(3, function(p31) -- line: 238
        -- upvalues: p29 (copy), p30 (copy), Pivot (copy), TweenService (copy), Player (copy)
        if p29.Parent == nil then
            return true
        end

        local v27 = Pivot + Vector3.new(0, math.sin(6.283185307179586 * p31 * 0.5) * 1, 0)
        local PivotPosition = Pivot.Position
        local v28 = Player.FindPrimaryPart(p30)

        if v28 then
            PivotPosition = v28:GetPivot().Position
        end

        local v29 = Vector3.new(PivotPosition.X, v27.Y, PivotPosition.Z)

        p29:PivotTo(v27:Lerp(if (v27.Position - v29).Magnitude < 0.001 then v27 else CFrame.lookAt(v27.Position, v29), (TweenService:GetValue(p31, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))))

        return nil
    end)
end

local function flyAssetIntoPlayer(p32, p33) -- line: 262
    -- upvalues: TweenService (copy), Player (copy), VisualTransform (copy), runHatchMotion (copy)
    local Scale = p32:GetScale()
    local Pivot = p32:GetPivot()
    local v31 = VisualTransform.Fader()

    task.spawn(function() -- line: 268
        -- upvalues: p32 (copy), p33 (copy), Scale (copy), Pivot (copy), v31 (copy), TweenService (copy), Player (copy), runHatchMotion (copy)
        runHatchMotion(0.7, function(p34) -- line: 269
            -- upvalues: p32 (copy), p33 (copy), Scale (copy), Pivot (copy), v31 (copy), TweenService (copy), Player (copy)
            if p32.Parent == nil then
                return true
            end

            local PivotPosition = Pivot.Position
            local v32 = Player.FindPrimaryPart(p33)

            if v32 then
                PivotPosition = v32:GetPivot().Position
            end

            local PivotPosition2 = Pivot.Position
            local v34 = math.clamp((PivotPosition - PivotPosition2).Magnitude * 0.6, 2, 36)
            local v35 = PivotPosition2:Lerp(PivotPosition, 0.5) + Vector3.new(0, 1, 0) * v34
            local v36 = PivotPosition2:Lerp(v35, p34):Lerp(v35:Lerp(PivotPosition, p34), p34)
            local v37 = CFrame.new(v36) * Pivot.Rotation
            local v38 = Vector3.new(PivotPosition.X, v37.Y, PivotPosition.Z)

            if not ((v37.Position - v38).Magnitude < 0.001) then
                v37 = CFrame.lookAt(v37.Position, v38)
            end

            local Value = TweenService:GetValue(math.clamp((p34 - 0.6) / 0.4, 0, 1), Enum.EasingStyle.Exponential, Enum.EasingDirection.In)

            v31:Hide(p32, Value)
            p32:ScaleTo((math.max(0.001, Scale * (1 - Value))))
            p32:PivotTo(v37)

            return nil
        end)

        if p32.Parent == nil then
            return
        end

        v31:Hide(p32, 1)
        p32:ScaleTo(0.001)
        p32:Destroy()
    end)
    task.wait(0.3)
end

local function playAssetClaimSequence(p35, p36) -- line: 303
    -- upvalues: Players (copy), TweenService (copy), Player (copy), runHatchMotion (copy), flyAssetIntoPlayer (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p35)

    if PlayerByUserId ~= nil then
        local Pivot = p36:GetPivot()

        runHatchMotion(3, function(p37) -- line: 238
            -- upvalues: p36 (copy), PlayerByUserId (copy), Pivot (copy), TweenService (copy), Player (copy)
            if p36.Parent == nil then
                return true
            end

            local v44 = Pivot + Vector3.new(0, math.sin(6.283185307179586 * p37 * 0.5) * 1, 0)
            local PivotPosition = Pivot.Position
            local v45 = Player.FindPrimaryPart(PlayerByUserId)

            if v45 then
                PivotPosition = v45:GetPivot().Position
            end

            local v46 = Vector3.new(PivotPosition.X, v44.Y, PivotPosition.Z)

            p36:PivotTo(v44:Lerp(if (v44.Position - v46).Magnitude < 0.001 then v44 else CFrame.lookAt(v44.Position, v46), (TweenService:GetValue(p37, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))))

            return nil
        end)
        flyAssetIntoPlayer(p36, PlayerByUserId)
    else
        p36:Destroy()
    end
end

local function revealAsset(p38, p39, p40, p41) -- line: 314
    -- upvalues: TweenService (copy), ModelBounds (copy), ItemDisplay (copy), t (copy), Transient (copy), buildAssetItemData (copy), pivotAssetToEggBottom (copy), growAsset (copy)
    local v48 = ItemDisplay.CreateActiveModel(p39, buildAssetItemData(p40, 1), true, true)

    v48.Name = ("%*_%*"):format(p38, p39)
    v48.Parent = Transient

    local PrimaryPart = v48.PrimaryPart

    t.strict(t.instanceIsA("BasePart"))(PrimaryPart)
    PrimaryPart.Anchored = true

    local Highlight = Instance.new("Highlight")

    Highlight.FillColor = Color3.new(1, 1, 1)
    Highlight.FillTransparency = 0
    Highlight.OutlineTransparency = 1
    Highlight.Adornee = v48
    Highlight.Parent = v48
    v48:ScaleTo(p40.AssetScale * 0.5)

    local v49, v50 = ModelBounds(v48)
    local v51 = v49.Position.Y - v50.Y * 0.5
    local Y = PrimaryPart.CFrame.Position.Y

    PrimaryPart.PivotOffset = CFrame.new(0, v51 - Y, 0)
    pivotAssetToEggBottom(v48, p41)
    task.spawn(function() -- line: 340
        -- upvalues: p40 (copy), p41 (copy), v48 (copy), growAsset (copy)
        growAsset(v48, p41, p40.AssetScale)
    end)

    for _, descendant in ipairs(v48:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
        end
    end

    TweenService:Create(Highlight, TweenInfo.new(0.5), {
        FillTransparency = 1
    }):Play()

    return v48
end

function t1.Play(p42, p43, p44, p45, p46) -- line: 360
    -- upvalues: Debris (copy), Players (copy), ReplicatedStorage (copy), TweenService (copy), Assets (copy), Audio (copy), ModelBounds (copy), EggRenderer (copy), Eggs (copy), EmitTree (copy), Player (copy), SfxRework (copy), t (copy), v1 (copy), Transient (copy), EggExplode (copy), Trail (copy), EggPoof (copy), getBottomCFrameFacingPlayer (copy), shakeEgg (copy), runHatchMotion (copy), flyAssetIntoPlayer (copy), revealAsset (copy)
    t.strict(t.number)(p42)
    t.strict(t.string)(p43)
    assert(Eggs.SchemaValidation.SavedEgg(p44), "Invalid saved egg record")
    t.strict(t.instanceIsA("Model"))(p45)
    t.strict(t.optional(t.boolean))(p46)
    EggRenderer.DisableCollisions(p45)

    local clone = EggExplode:Clone()

    clone:ScaleTo(p45:GetScale() / 3)
    clone:PivotTo(p45:GetPivot())

    local Core = clone.Core

    assert(Core:IsA("BasePart"), "Egg explosion Core must be a BasePart")
    Core.Parent = Transient
    Debris:AddItem(Core, 60)
    clone.Parent = ReplicatedStorage

    if not p46 then
        task.wait(0.4)
        Audio.Play("rbxassetid://125937767292519", script, {
            Volume = 2.8
        })
    end

    local Pivot = p45:GetPivot()
    local v53, v54 = ModelBounds(p45)
    local v56 = getBottomCFrameFacingPlayer(p42, v53.Position - Vector3.new(0, 1, 0) * (v54.Y * 0.5) + Vector3.new(0, 0.2, 0), Pivot - Pivot.Position)

    if not p46 then
        shakeEgg(p45, Pivot)
    end

    local n4 = 0
    local n5 = 0
    local n6 = 0
    local n7 = 0
    local n8 = 0

    for _, descendant in ipairs(p45:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local Color = descendant.Color

            n5 += Color.R
            n4 += Color.G
            n6 += Color.B
            n7 += 1

            if descendant.Transparency > 0.3 then
                n8 = descendant.Transparency
            end
        end
    end

    local v57 = if n7 > 0 then Color3.new(n5 / n7, n4 / n7, n6 / n7) else v1
    local PrimaryPart = p45.PrimaryPart

    t.strict(t.instanceIsA("BasePart"))(PrimaryPart)

    local t3 = {
        Color = v57,
        Material = PrimaryPart.Material,
        MaterialVariant = PrimaryPart.MaterialVariant,
        Transparency = PrimaryPart.Transparency
    }

    p45:Destroy()
    clone.Parent = Transient

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant ~= Core and descendant.Name ~= "RootPart" and descendant:IsA("BasePart") then
            descendant.Anchored = false
        end
    end

    local v58 = revealAsset(p42, p43, p44, v56)
    local v59 = SfxRework.Resolve(p44.AssetCategory, "Idle", Assets.Directory[p44.AssetCategory].RandomIdleSound)
    local v60 = if v59 == nil then nil else Audio.PlayFile(v59, v56)

    for _, child in ipairs(clone:GetChildren()) do
        if not child:IsA("BasePart") then
            assert(child:IsA("Model"), (("Explosion child %* must be a Model"):format((child:GetFullName()))))

            local PrimaryPart = child.PrimaryPart

            t.strict(t.instanceIsA("BasePart"))(PrimaryPart)

            local BoundingBox, BoundingBox2 = child:GetBoundingBox()
            local Part = Instance.new("Part")

            Part.Transparency = 1
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CFrame = BoundingBox
            Part.Size = BoundingBox2

            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Part0 = Part
            WeldConstraint.Part1 = PrimaryPart
            WeldConstraint.Parent = Part
            Part.Parent = child

            local Attachment = Instance.new("Attachment")
            local Attachment2 = Instance.new("Attachment")

            Attachment.Parent = Part
            Attachment2.Parent = Part
            Attachment.Position = Vector3.new(0, BoundingBox2.Y / 2, 0)
            Attachment2.Position = Vector3.new(0, -BoundingBox2.Y / 2, 0)

            local clone = Trail:Clone()

            clone.Attachment0 = Attachment
            clone.Attachment1 = Attachment2
            clone.Color = ColorSequence.new(t3.Color)
            clone.Parent = Attachment
            clone.Enabled = true
        end
    end

    if not p46 then
        Audio.Play("rbxassetid://102267539121951", script)
    end

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant ~= Core and descendant.Name ~= "RootPart" and descendant:IsA("BasePart") then
            local Position = descendant.Position
            local v64 = CFrame.new(Core.Position, Position).LookVector * 16 + Vector3.new(0, 24, 0)

            descendant.Transparency = n8
            descendant.Color = v57
            descendant.Material = t3.Material
            descendant.MaterialVariant = t3.MaterialVariant
            descendant:ApplyImpulse(v64 * descendant.AssemblyMass)
        end
    end

    task.delay(3, function() -- line: 498
        -- upvalues: clone (copy), Debris (copy), TweenService (copy)
        for _, child in ipairs(clone:GetChildren()) do
            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    TweenService:Create(descendant, TweenInfo.new(1), {
                        Transparency = 1
                    }):Play()
                end
            end
        end

        Debris:AddItem(clone, 1)
    end)

    local Attachment = Core.Attachment

    assert(Attachment:IsA("Attachment"), "Egg explosion core Attachment must be an Attachment")

    for _, descendant in ipairs(Attachment:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") and descendant.Name == "ColorMe" then
            descendant.Color = ColorSequence.new(t3.Color)
        end
    end

    EmitTree(Attachment)

    local Rare = Core.Rare

    assert(Rare:IsA("Attachment"), "Egg explosion core Rare must be an Attachment")

    for _, descendant in ipairs(Rare:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Color = ColorSequence.new(t3.Color)
        end
    end

    EmitTree(Rare)

    local clone2 = EggPoof:Clone()

    clone2.CFrame = Pivot
    clone2.Parent = Transient
    EmitTree(clone2)
    Debris:AddItem(clone2, 6)

    local PlayerByUserId = Players:GetPlayerByUserId(p42)

    if PlayerByUserId ~= nil then
        local Pivot = v58:GetPivot()

        runHatchMotion(3, function(p47) -- line: 238
            -- upvalues: v58 (copy), PlayerByUserId (copy), Pivot (copy), TweenService (copy), Player (copy)
            if v58.Parent == nil then
                return true
            end

            local v67 = Pivot + Vector3.new(0, math.sin(6.283185307179586 * p47 * 0.5) * 1, 0)
            local PivotPosition = Pivot.Position
            local v68 = Player.FindPrimaryPart(PlayerByUserId)

            if v68 then
                PivotPosition = v68:GetPivot().Position
            end

            local v69 = Vector3.new(PivotPosition.X, v67.Y, PivotPosition.Z)

            v58:PivotTo(v67:Lerp(if (v67.Position - v69).Magnitude < 0.001 then v67 else CFrame.lookAt(v67.Position, v69), (TweenService:GetValue(p47, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))))

            return nil
        end)
        flyAssetIntoPlayer(v58, PlayerByUserId)
    else
        v58:Destroy()
    end

    return v60
end

function t1.FadeSoundWhenGrantedToolUnequips(p48, p49) -- line: 538
    -- upvalues: Players (copy), Audio (copy), t (copy)
    t.strict(t.instanceIsA("Sound"))(p48)
    t.strict(t.string)(p49)

    if p48:IsDescendantOf(game) then
        local LocalPlayer = Players.LocalPlayer
        local connection, connection2, connection3, connection4
        local v71 = false

        local function disconnectLifecycle() -- line: 555
            -- upvalues: connection (ref), connection2 (ref), connection3 (ref), connection4 (ref)
            if connection ~= nil then
                connection:Disconnect()
                connection = nil
            end

            if connection2 ~= nil then
                connection2:Disconnect()
                connection2 = nil
            end

            if connection3 ~= nil then
                connection3:Disconnect()
                connection3 = nil
            end

            if connection4 == nil then
                return
            end

            connection4:Disconnect()
            connection4 = nil
        end

        local function fadeAndStop() -- line: 574
            -- upvalues: p48 (copy), disconnectLifecycle (copy), Audio (copy)
            disconnectLifecycle()

            if p48:IsDescendantOf(game) then
                Audio.FadeTo(p48, {
                    Volume = 0,
                    Seconds = 0.35
                }).Completed:Once(function() -- line: 581
                    -- upvalues: p48 (copy)
                    if p48:IsDescendantOf(game) then
                        p48:Stop()
                    end
                end)
            end
        end

        local function tryBindTool(p50) -- line: 588
            -- upvalues: p49 (copy), connection (ref), connection4 (ref), v71 (ref), fadeAndStop (copy)
            if not v71 and p50:IsA("Tool") and p50:GetAttribute("UID") == p49 then
                v71 = true

                if connection ~= nil then
                    connection:Disconnect()
                    connection = nil
                end

                connection4 = p50.Unequipped:Once(fadeAndStop)
            end
        end

        connection2 = p48.Ended:Once(disconnectLifecycle)
        connection3 = p48.Stopped:Once(disconnectLifecycle)
        connection = LocalPlayer.DescendantAdded:Connect(tryBindTool)

        for _, descendant in LocalPlayer:GetDescendants() do
            tryBindTool(descendant)

            if v71 then
                break
            end
        end
    end
end

return t1
