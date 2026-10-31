-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local AnimalPOV = require(ReplicatedStorage.Config.AnimalPOV)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local AnimalTemplates = require(ReplicatedStorage.Shared.AnimalTemplates)
local Mutations = require(ReplicatedStorage.Shared.Mutations)
local AnimationLibrary = require(ReplicatedStorage.Shared.AnimationLibrary)
local FeetGrounding = require(ReplicatedStorage.Shared.FeetGrounding)

require(ReplicatedStorage.Shared.NumberFormat)

local Boosts = require(ReplicatedStorage.Shared.Boosts)
local ClientState = require(script.Parent.ClientState)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local t2 = {}
local t3 = {}

local function waitForReplication(p1, p2) -- line: 58
    -- upvalues: AnimationLibrary (copy)
    local v1 = os.clock() + (p2 or 5)

    while true do
        if not p1.Parent then
            return false
        end

        if not (p1.PrimaryPart and AnimationLibrary.FindAnimator(p1)) then
            if v1 <= os.clock() then
                return true
            end

            task.wait(0.05)
            continue
        end

        break
    end

    return true
end

local function waitComplete(p3, p4, p5) -- line: 76
    -- upvalues: ReplicatedStorage (copy), AnimalTemplates (copy)
    local StudioPieces = require(ReplicatedStorage.Shared.StudioPieces)

    if StudioPieces.IsComplete(p3) then
        return true
    end

    local t4 = {}

    local function hide(p6) -- line: 80
        -- upvalues: p3 (copy), t4 (copy)
        if p6:IsA("BasePart") and t4[p6] == nil and p6.Name ~= "Bounds" and p6 ~= p3.PrimaryPart then
            t4[p6] = p6.LocalTransparencyModifier
            p6.LocalTransparencyModifier = 1
        end
    end

    for _, descendant in ipairs(p3:GetDescendants()) do
        if descendant:IsA("BasePart") and t4[descendant] == nil and descendant.Name ~= "Bounds" and descendant ~= p3.PrimaryPart then
            t4[descendant] = descendant.LocalTransparencyModifier
            descendant.LocalTransparencyModifier = 1
        end
    end

    local connection = p3.DescendantAdded:Connect(hide)
    local v2 = os.clock() + (p4 or 120)

    while p3.Parent and not StudioPieces.IsComplete(p3) and os.clock() < v2 and (p5 == nil or AnimalTemplates.Version() == p5) do
        task.wait(0.1)
    end

    connection:Disconnect()

    for v3, v4 in pairs(t4) do
        if v3.Parent then
            v3.LocalTransparencyModifier = v4
        end
    end

    return p3.Parent ~= nil
end

local v5 = false

local function isMine(p7) -- line: 106
    -- upvalues: LocalPlayer (copy)
    return p7:GetAttribute("OwnerUserId") == LocalPlayer.UserId
end

local t5 = {
    "AnimalId",
    "DisplayName",
    "OwnerUserId",
    "PlotIndex",
    "Income",
    "OfBest",
    "Bought",
    "Rarity"
}
local Folder
local t6 = {}
local t7 = {}
local t8 = {}

local function getViewFolder() -- line: 122
    -- upvalues: Folder (ref)
    if Folder and Folder.Parent then
        return Folder
    end

    Folder = Instance.new("Folder")
    Folder.Name = "NewAnimalView"

    local Folder2 = Folder

    Folder2.Parent = workspace

    return Folder
end

local function wantsView(p8) -- line: 131
    -- upvalues: AnimalTemplates (copy)
    local Get, v6

    if not AnimalTemplates.HasOverride() or p8:GetAttribute("PartMade") or p8:GetAttribute("ViewCopy") then
        return false
    else
        Get = AnimalTemplates.Get
        v6 = p8:GetAttribute("AnimalName") or p8.Name
    end

    local v8 = Get(v6)

    return v8 ~= nil and v8:GetAttribute("PartMade") == true
end

local function hideSource(p9) -- line: 140
    -- upvalues: t8 (copy)
    if t8[p9] then
        return
    end

    local t9 = {}

    local function hide(p10) -- line: 143
        -- upvalues: t9 (copy)
        if t9[p10] ~= nil then
            return
        end

        if p10:IsA("BasePart") or p10:IsA("Decal") or p10:IsA("Texture") then
            t9[p10] = p10.Transparency
            p10.Transparency = 1
        elseif p10:IsA("ParticleEmitter") or p10:IsA("Highlight") or p10:IsA("BillboardGui") or p10:IsA("Beam") or p10:IsA("Trail") then
            t9[p10] = p10.Enabled
            p10.Enabled = false
        end
    end

    for _, descendant in ipairs(p9:GetDescendants()) do
        hide(descendant)
    end

    t8[p9] = {
        Saved = t9,
        Conn = p9.DescendantAdded:Connect(hide)
    }
end

local function showSource(p11) -- line: 157
    -- upvalues: t8 (copy)
    local v9 = t8[p11]

    if not v9 then
        return
    end

    t8[p11] = nil
    v9.Conn:Disconnect()

    for v10, v11 in pairs(v9.Saved) do
        if v10.Parent then
            if type(v11) == "boolean" then
                v10.Enabled = v11
            else
                v10.Transparency = v11
            end
        end
    end
end

local function makeView(p12, p13) -- line: 171
    -- upvalues: GameConfig (copy), AnimalPOV (copy), AnimalUtil (copy), Mutations (copy), t5 (copy)
    local v12 = p12:GetAttribute("AnimalName") or p12.Name
    local v13 = AnimalUtil.Create(v12)

    if not v13 then
        return nil
    end

    v13:SetAttribute("ViewCopy", true)
    AnimalUtil.ApplyScale(v13)

    local v14 = v13:GetAttribute("VisualScale") or 1

    Mutations.ApplySize(v13, p12:GetAttribute("SizeMult") or 1)
    AnimalUtil.SoftCapSize(v13, GameConfig.Plot.GrownSizeSoftCap, GameConfig.Plot.GrownSizeCurve)

    for _, v15 in ipairs(t5) do
        v13:SetAttribute(v15, p12:GetAttribute(v15))
    end

    if p13 then
        v13:SetAttribute("Carried", true)
    else
        v13:SetAttribute("Hover", AnimalPOV.GetHover(v12) * v14)
    end

    Mutations.Apply(v13, p12:GetAttribute("Mutation"))

    for _, descendant in ipairs(v13:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanQuery = false

            if not p13 then
                descendant.CastShadow = false
            end
        end
    end

    return v13
end

function t1.ShownModel(p14, p15) -- line: 198
    -- upvalues: t6 (copy), wantsView (copy)
    if not p14 then
        return nil
    end

    if t6[p14] then
        return t6[p14]
    end

    if p15 and wantsView(p14) then
        local v16 = os.clock() + p15

        while not t6[p14] and p14.Parent and os.clock() < v16 do
            task.wait()
        end
    end

    return t6[p14] or p14
end

local function makeBillboard(p16, p17) -- line: 212
    -- upvalues: Players (copy), UITheme (copy), RarityConfig (copy), AnimalUtil (copy), Mutations (copy), Boosts (copy)
    local PrimaryPart = p16.PrimaryPart

    if not PrimaryPart then
        return
    end

    local v17, v18 = AnimalUtil.GetBoundingBox(p16)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "LabelAttachment"
    Attachment.Parent = PrimaryPart

    local v19 = v17.Position.Y + v18.Y / 2

    Attachment.WorldPosition = Vector3.new(v17.Position.X, v19 + 0.9, v17.Position.Z)
    p17.LabelAttachment = Attachment
    p17.TopAbovePrimary = v19 - PrimaryPart.Position.Y

    local t10 = {}
    local n1 = (-1e999)

    for _, descendant in ipairs(p16:GetDescendants()) do
        if descendant:IsA("Bone") then
            table.insert(t10, descendant)
            n1 = math.max(n1, descendant.WorldPosition.Y)
        end
    end

    if #t10 > 0 then
        p17.Bones = t10
        p17.BoneMargin = v19 - n1
    end

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "InfoBillboard"
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = Attachment

    local Mutation = p16:GetAttribute("Mutation")
    local v21 = p16:GetAttribute("SizeMult") or 1
    local v22 = RarityConfig.Get(p16:GetAttribute("Rarity") or "Common")
    local v23, v24 = Mutations.SizeTitle(v21)
    local t11 = {}

    if Mutation then
        table.insert(t11, {
            Height = 0.32,
            Text = string.upper(Mutation),
            Gradient = Mutations.NameGradient(Mutation)
        })
    end

    table.insert(t11, {
        Height = 0.5,
        Text = p16:GetAttribute("DisplayName") or p16.Name,
        Gradient = v22.Gradient
    })

    if v23 then
        table.insert(t11, {
            Height = 0.42,
            Bold = true,
            Text = v23,
            Color = v24
        })
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p16:GetAttribute("OwnerUserId") or 0)

    local function incomeText() -- line: 262
        -- upvalues: p16 (copy), PlayerByUserId (copy), Boosts (copy)
        return Boosts.AnimalIncomeText(p16:GetAttribute("Income") or 0, PlayerByUserId, p16:GetAttribute("OfBest"), true)
    end

    table.insert(t11, {
        Height = 0.6,
        IsIncome = true,
        Text = Boosts.AnimalIncomeText(p16:GetAttribute("Income") or 0, PlayerByUserId, p16:GetAttribute("OfBest"), true),
        Color = UITheme.Colors.Money
    })

    local n2 = 0

    for _, v25 in ipairs(t11) do
        n2 += v25.Height
    end

    local v27 = math.clamp(v21 ^ 0.5, 1, 3)
    local v28 = p16:GetAttribute("OfBest") and 1.6 or 1

    BillboardGui.Size = UDim2.fromScale(v27 * 3.2 * v28, n2 * v27)
    BillboardGui.MaxDistance = v27 * 50 + 100

    local n3 = 0

    for _, v29 in ipairs(t11) do
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Size = UDim2.fromScale(1, v29.Height / n2)
        TextLabel.Position = UDim2.fromScale(0, n3 / n2)
        TextLabel.BackgroundTransparency = 1
        TextLabel.FontFace = UITheme.Font
        TextLabel.TextScaled = true
        TextLabel.Text = v29.Text
        TextLabel.TextColor3 = v29.Color or Color3.new(1, 1, 1)

        if v29.Gradient then
            local UIGradient = Instance.new("UIGradient")

            UIGradient.Color = v29.Gradient
            UIGradient.Rotation = 90
            UIGradient.Parent = TextLabel
        end

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = v29.Bold and 2.5 or 2
        UIStroke.Color = Color3.new(0, 0, 0)
        UIStroke.Parent = TextLabel
        TextLabel.Parent = BillboardGui
        n3 += v29.Height

        if v29.IsIncome then
            TextLabel.RichText = true
            p17.IncomeLabel = TextLabel
        end
    end

    BillboardGui.Parent = PrimaryPart
    p17.Billboard = BillboardGui

    local function refreshIncome() -- line: 301
        -- upvalues: p16 (copy), p17 (copy), PlayerByUserId (copy), Boosts (copy)
        if p17.IncomeLabel and p17.IncomeLabel.Parent then
            p17.IncomeLabel.Text = Boosts.AnimalIncomeText(p16:GetAttribute("Income") or 0, PlayerByUserId, p16:GetAttribute("OfBest"), true)
        end
    end

    if PlayerByUserId then
        p17.CashConn = PlayerByUserId:GetAttributeChangedSignal("CashMultiplier"):Connect(refreshIncome)
    end

    if p16:GetAttribute("OfBest") then
        p17.IncomeConn = p16:GetAttributeChangedSignal("Income"):Connect(refreshIncome)
    end
end

local function updateLabelHeight(p18) -- line: 317
    -- upvalues: AnimalUtil (copy)
    local Model, LabelAttachment = p18.Model, p18.LabelAttachment
    local PrimaryPart = Model.PrimaryPart

    if LabelAttachment and PrimaryPart and LabelAttachment.Parent then
        local v30, v31 = AnimalUtil.GetBoundingBox(Model)
        local v32 = v30.Position.Y + v31.Y / 2

        if p18.Bones then
            local n4 = (-1e999)

            for _, v33 in ipairs(p18.Bones) do
                local Y = v33.TransformedWorldCFrame.Position.Y

                if n4 < Y then
                    n4 = Y
                end
            end

            v32 = math.max(v32, n4 + p18.BoneMargin)
        end

        local v35 = v32 - PrimaryPart.Position.Y

        if not (p18.TopAbovePrimary + 0.05 < v35) then
            return
        end

        p18.TopAbovePrimary = v35

        local WorldPosition = LabelAttachment.WorldPosition

        LabelAttachment.WorldPosition = Vector3.new(WorldPosition.X, PrimaryPart.Position.Y + v35 + 0.9, WorldPosition.Z)
    end
end

local function setAnim(p19, p20) -- line: 339
    -- upvalues: AnimationLibrary (copy)
    if p19.AnimCategory == p20 then
        return
    end

    p19.AnimCategory = p20
    p19.WatchLabelUntil = os.clock() + 6

    if p19.Track then
        p19.Track:Stop(0.25)
    end

    p19.Track = AnimationLibrary.PlayAnimal(p19.Model, p20, {
        FadeTime = 0.25
    })
end

local v37

v37 = function(p21) -- line: 349
    -- upvalues: v37 (ref), CollectionService (copy), AnimalUtil (copy), AnimalTemplates (copy), AnimationLibrary (copy), FeetGrounding (copy), LocalPlayer (copy), t2 (copy), t3 (copy), waitForReplication (copy), waitComplete (copy), v5 (ref), Folder (ref), t6 (copy), wantsView (copy), hideSource (copy), showSource (copy), makeView (copy), makeBillboard (copy), setAnim (copy)
    if t2[p21] or t3[p21] then
        return
    end

    t3[p21] = true

    local v38 = AnimalTemplates.Version()
    local v39 = waitForReplication(p21, 5)
    local v40, v41

    if v39 and wantsView(p21) then
        v41 = makeView(p21, false)
        v40 = v41

        if v41 then
            hideSource(p21)
            t6[p21] = v41

            local v43, v44 = AnimalUtil.GetBoundingBox(p21)
            local MoveStart = p21:GetAttribute("MoveStart")

            if not MoveStart then
                MoveStart = Vector3.new(v43.Position.X, v43.Position.Y - v44.Y / 2, v43.Position.Z)
            end

            AnimalUtil.PlaceOnGround(v41, MoveStart, p21:GetPivot().LookVector, v41:GetAttribute("Hover") or 0)

            if Folder then
                if not Folder.Parent then
                    Folder = Instance.new("Folder")
                    Folder.Name = "NewAnimalView"
                    Folder.Parent = workspace
                end
            else
                Folder = Instance.new("Folder")
                Folder.Name = "NewAnimalView"
                Folder.Parent = workspace
            end

            v41.Parent = Folder
        end
    end

    local v46 = v41 or p21
    local v47 = if v39 and v46:GetAttribute("PartMade") then waitComplete(v46, 120, v38) and p21.Parent ~= nil else v39

    AnimationLibrary.EnsureAnimalClips(v46:GetAttribute("AnimalName") or v46.Name)
    t3[p21] = nil

    local function dropView() -- line: 376
        -- upvalues: p21 (copy), v40 (ref), t6 (copy), showSource (copy)
        if not v40 then
            return
        end

        if t6[p21] == v40 then
            t6[p21] = nil
        end

        v40:Destroy()
        showSource(p21)
    end

    if AnimalTemplates.Version() == v38 then
        local t16, Pivot, v48, MoveStart, v49

        if not v47 or t2[p21] then
            v49 = true
        elseif p21.Parent and CollectionService:HasTag(p21, "PlotAnimal") then
            t16 = {
                Moving = false,
                Facing = nil,
                Model = v46,
                Source = p21,
                View = v40
            }
            t2[p21] = t16

            local v50, v51 = AnimalUtil.GetBoundingBox(v46)

            Pivot = v46:GetPivot()
            t16.BottomOffset = Pivot.Position.Y - (v50.Position.Y - v51.Y / 2)
            t16.PivotToCenter = Pivot:PointToObjectSpace(v50.Position)
            t16.Hover = v46:GetAttribute("Hover") or 0

            local v52

            v52, v48 = AnimalUtil.GetGrounding(v46)
            t16.GroundOffset = v52
            t16.Seed = math.random() * 10
            MoveStart = p21:GetAttribute("MoveStart")

            if not MoveStart then
                MoveStart = Vector3.new(v50.Position.X, v50.Position.Y - v51.Y / 2 - t16.Hover + v52, v50.Position.Z)
            end

            v49 = false
        else
            v49 = true
        end

        if not v49 then
            t16.GroundPos = MoveStart

            local LookVector = Pivot.LookVector

            t16.Facing = Vector3.new(LookVector.X, 0, LookVector.Z)

            if t16.Facing.Magnitude < 0.01 then
                t16.Facing = Vector3.new(0, 0, -1)
            end

            t16.Facing = t16.Facing.Unit

            if v48 and t16.Hover == 0 then
                t16.Feet = FeetGrounding.new(v46)

                if not t16.Feet:HasFeet() then
                    t16.Feet = nil

                    local delay = task.delay
                    local t17 = t16

                    delay(0.5, function() -- line: 417
                        -- upvalues: p21 (copy), v46 (copy), t17 (copy), FeetGrounding (copy), t2 (copy)
                        if t2[p21] == t17 and p21.Parent then
                            local v54 = FeetGrounding.new(v46)

                            if v54:HasFeet() then
                                t17.Feet = v54
                            end
                        end
                    end)
                end
            end

            if p21:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                t16.Outlined = true
                AnimalUtil.SetOutline(v46, Color3.new(0, 0, 0), not v5)
            end

            makeBillboard(v46, t16)

            if v40 then
                t16.SourceConn = p21:GetAttributeChangedSignal("Income"):Connect(function() -- line: 432
                    -- upvalues: p21 (copy), v40 (ref)
                    v40:SetAttribute("Income", p21:GetAttribute("Income"))
                end)
            end

            setAnim(t16, AnimationLibrary.GetIdleCategory(v46:GetAttribute("AnimalName") or v46.Name))

            local t18 = t16

            local function onMove() -- line: 438
                -- upvalues: p21 (copy), v46 (copy), t18 (copy), AnimationLibrary (copy), setAnim (copy)
                local v56 = p21:GetAttribute("MoveDuration") or 0

                if v56 > 0 then
                    t18.Moving = true
                    t18.Start = p21:GetAttribute("MoveStart")
                    t18.Target = p21:GetAttribute("MoveTarget")
                    t18.StartTime = p21:GetAttribute("MoveStartTime")
                    t18.Duration = v56
                    setAnim(t18, AnimationLibrary.GetMoveCategory(v46:GetAttribute("AnimalName") or v46.Name) or "Idle")
                else
                    t18.Moving = false

                    local MoveStart = p21:GetAttribute("MoveStart")

                    if MoveStart then
                        t18.GroundPos = MoveStart
                    end

                    setAnim(t18, AnimationLibrary.GetIdleCategory(v46:GetAttribute("AnimalName") or v46.Name) or "Idle")
                end
            end

            if v46:GetAttribute("PartMade") then
                local Look = v46:GetAttributeChangedSignal("Look")
                local t19 = t16

                t16.LookConn = Look:Connect(function() -- line: 456
                    -- upvalues: p21 (copy), v46 (copy), t19 (copy), t2 (copy), waitComplete (copy), setAnim (copy)
                    task.spawn(function() -- line: 457
                        -- upvalues: p21 (copy), v46 (copy), t19 (copy), t2 (copy), waitComplete (copy), setAnim (copy)
                        if not waitComplete(v46, 120) or t2[p21] ~= t19 then
                            return
                        end

                        local AnimCategory = t19.AnimCategory

                        t19.AnimCategory = nil

                        if AnimCategory then
                            setAnim(t19, AnimCategory)
                        end
                    end)
                end)
            end

            t16.Conn = p21:GetAttributeChangedSignal("MoveDuration"):Connect(onMove)
            t16.Conn2 = p21:GetAttributeChangedSignal("MoveStartTime"):Connect(onMove)
            onMove()
        elseif v40 then
            if t6[p21] == v40 then
                t6[p21] = nil
            end

            v40:Destroy()
            showSource(p21)
        end
    else
        if v40 then
            if t6[p21] == v40 then
                t6[p21] = nil
            end

            v40:Destroy()
            showSource(p21)
        end

        if p21.Parent and CollectionService:HasTag(p21, "PlotAnimal") then
            task.spawn(v37, p21)
        end
    end
end

local function detachPlotAnimal(p22, p23) -- line: 471
    -- upvalues: AnimalUtil (copy), t2 (copy), t6 (copy), showSource (copy)
    local v57 = t2[p22]

    if not v57 then
        return
    end

    t2[p22] = nil

    for _, v58 in ipairs({ "Conn", "Conn2", "LookConn", "CashConn", "IncomeConn", "SourceConn" }) do
        if v57[v58] then
            v57[v58]:Disconnect()
        end
    end

    if v57.Track then
        v57.Track:Stop(0)
    end

    if v57.View then
        if t6[p22] == v57.View then
            t6[p22] = nil
        end

        v57.View:Destroy()
        showSource(p22)
    elseif p23 then
        if v57.Billboard then
            v57.Billboard:Destroy()
        end

        if v57.LabelAttachment then
            v57.LabelAttachment:Destroy()
        end

        if v57.Outlined then
            AnimalUtil.SetOutline(p22, nil, false)
        end
    end
end

local function removeHeldView(p24) -- line: 494
    -- upvalues: t6 (copy), t7 (copy), showSource (copy)
    local v59 = t7[p24]

    t7[p24] = nil

    if t6[p24] == v59 then
        t6[p24] = nil
    end

    if v59 then
        v59:Destroy()
    end

    showSource(p24)
end

local function attachHeldView(p25) -- line: 505
    -- upvalues: GameConfig (copy), AnimalUtil (copy), AnimationLibrary (copy), waitComplete (copy), t6 (copy), t7 (copy), hideSource (copy), makeView (copy)
    if t7[p25] then
        return true
    end

    local Parent = p25.Parent

    if Parent then
        local Handle = Parent:FindFirstChild("Handle")

        if Parent:IsA("Tool") and Handle and Handle:IsA("BasePart") then
            local v60 = makeView(p25, true)

            if v60 then
                local PrimaryPart = v60.PrimaryPart

                if PrimaryPart then
                    t7[p25] = v60
                    t6[p25] = v60
                    hideSource(p25)

                    for _, descendant in ipairs(v60:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            descendant.Anchored = false
                            descendant.Massless = true
                            descendant.CanCollide = false
                        end
                    end

                    AnimalUtil.UseCarriedStuds(v60)

                    local Pivot = v60:GetPivot()
                    local Weld = Instance.new("Weld")

                    Weld.Name = "ViewHold"
                    Weld.Part0 = Handle
                    Weld.Part1 = PrimaryPart

                    local v61 = AnimalUtil.HoldGrip(v60)

                    if v61 then
                        Weld.C0 = CFrame.new(0, -0.1, -0.15) * CFrame.Angles(0, 1.5707963267948966, 0)
                        Weld.C1 = PrimaryPart.CFrame:ToObjectSpace(Pivot * CFrame.new(v61))
                    else
                        local v62, v63 = AnimalUtil.GetBoundingBox(v60)
                        local HandAnimalOffset = GameConfig.Plot.HandAnimalOffset
                        local v64 = v63 / 2

                        Weld.C0 = CFrame.new(HandAnimalOffset.X, math.max(HandAnimalOffset.Y, v64.Y - 1), -(v64.X - 0.1)) * CFrame.Angles(0, 1.5707963267948966, 0)
                        Weld.C1 = PrimaryPart.CFrame:ToObjectSpace(Pivot) * Pivot:ToObjectSpace(v62)
                    end

                    Weld.Parent = PrimaryPart
                    v60.Parent = Parent
                    task.spawn(function() -- line: 548
                        -- upvalues: p25 (copy), v60 (copy), AnimationLibrary (copy), waitComplete (copy), t7 (copy)
                        if waitComplete(v60, 120) and t7[p25] == v60 then
                            AnimationLibrary.EnsureAnimalClips(v60:GetAttribute("AnimalName") or v60.Name)

                            if t7[p25] == v60 then
                                local function v66() -- line: 552
                                    -- upvalues: v60 (copy), AnimationLibrary (copy)
                                    AnimationLibrary.PlayAnimal(v60, "Idle", {
                                        FadeTime = 0
                                    })
                                end

                                pcall(v66)
                            end
                        end
                    end)

                    return true
                end

                v60:Destroy()
            end

            return false
        end
    end

    return false
end

local function attachOther(p26) -- line: 557
    -- upvalues: AnimationLibrary (copy), waitForReplication (copy), waitComplete (copy), wantsView (copy), attachHeldView (copy)
    if not p26:GetAttribute("ViewCopy") and p26:GetAttribute("Carried") then
        task.spawn(function() -- line: 561
            -- upvalues: p26 (copy), AnimationLibrary (copy), waitForReplication (copy), waitComplete (copy), wantsView (copy), attachHeldView (copy)
            if waitForReplication(p26, 5) and not (wantsView(p26) and attachHeldView(p26)) and (not p26:GetAttribute("PartMade") or waitComplete(p26, 120)) then
                AnimationLibrary.EnsureAnimalClips(p26:GetAttribute("AnimalName") or p26.Name)

                if p26.Parent then
                    local function v67() -- line: 567
                        -- upvalues: p26 (copy), AnimationLibrary (copy)
                        AnimationLibrary.PlayAnimal(p26, "Idle", {
                            FadeTime = 0
                        })
                    end

                    pcall(v67)
                end
            end
        end)
    end
end

local function refreshOutlines() -- line: 575
    -- upvalues: AnimalUtil (copy), ClientState (copy), t2 (copy), v5 (ref)
    local v68 = ClientState.Busy == "Throw" or ClientState.Spotlight == true

    if v68 ~= v5 then
        v5 = v68

        for v69, v70 in pairs(t2) do
            if v70.Outlined and v69.Parent then
                AnimalUtil.SetOutline(v70.Model, Color3.new(0, 0, 0), not v68)
            end
        end
    end
end

local v71 = false
local n5 = 0
local t20 = {}
local t21 = {}

local function setHeld(p27, p28) -- line: 594
    -- upvalues: t20 (copy), t21 (copy)
    for _, descendant in ipairs(p27:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p28 and 1 or 0
        elseif descendant:IsA("ParticleEmitter") then
            if p28 then
                if t21[descendant] == nil then
                    t21[descendant] = descendant.Enabled
                end

                descendant.Enabled = false
            elseif t21[descendant] ~= nil then
                descendant.Enabled = t21[descendant]
                t21[descendant] = nil
            end
        end
    end

    t20[p27] = p28 or nil
end

local function refreshHeld() -- line: 610
    -- upvalues: Players (copy), ClientState (copy), v71 (ref), n5 (ref), t20 (copy), t21 (copy), setHeld (copy)
    local v72 = ClientState.Busy == "Throw" or ClientState.Busy == "Hatch"

    if v72 == v71 and (not v72 or os.clock() < n5) then
        return
    end

    n5 = os.clock() + 0.3
    v71 = v72

    if v72 then
        for _, player in ipairs(Players:GetPlayers()) do
            for _, v73 in ipairs(player.Character and player.Character:GetChildren() or {}) do
                if v73:IsA("Tool") then
                    for _, child in ipairs(v73:GetChildren()) do
                        if child:IsA("Model") and child:GetAttribute("Carried") and not t20[child] then
                            setHeld(child, true)
                        end
                    end
                end
            end
        end
    else
        for v74 in pairs(t20) do
            setHeld(v74, false)
        end

        table.clear(t20)
        table.clear(t21)
    end
end

local function step(p29) -- line: 633
    -- upvalues: t2 (copy), updateLabelHeight (copy), detachPlotAnimal (copy), refreshOutlines (copy), refreshHeld (copy)
    refreshOutlines()
    refreshHeld()

    local ServerTimeNow = workspace:GetServerTimeNow()
    local elapsed = os.clock()

    for v75, v76 in pairs(t2) do
        if v75.Parent then
            local GroundPos = v76.GroundPos

            if v76.Moving and v76.Start and v76.Target then
                local v79 = math.clamp((ServerTimeNow - v76.StartTime) / math.max(v76.Duration, 0.01), 0, 1)

                GroundPos = v76.Start:Lerp(v76.Target, v79)

                local v80 = v76.Target - v76.Start
                local v81 = Vector3.new(v80.X, 0, v80.Z)

                if v81.Magnitude > 0.01 then
                    local v84 = math.atan2(-v76.Facing.X, -v76.Facing.Z)
                    local v89 = v84 + ((math.atan2(-v81.X, -v81.Z) - v84 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * (1 - math.exp(-p29 * 6))

                    v76.Facing = Vector3.new(-math.sin(v89), 0, -math.cos(v89))
                end

                if v79 >= 1 then
                    v76.Moving = false
                    v76.GroundPos = v76.Target
                end
            end

            local n6 = 0

            if v76.Hover > 0 then
                n6 = math.sin(ServerTimeNow * 2 + v76.Seed) * 0.25
            elseif v76.Feet then
                n6 = -v76.Feet:Update(p29)
            end

            local v93 = GroundPos.Y + v76.Hover + v76.BottomOffset + n6 - v76.GroundOffset
            local v94 = CFrame.lookAt(Vector3.new(0, 0, 0), v76.Facing)
            local v95 = v94:VectorToWorldSpace(v76.PivotToCenter)

            v76.Model:PivotTo(v94 + Vector3.new(GroundPos.X - v95.X, v93, GroundPos.Z - v95.Z))

            if v76.WatchLabelUntil and elapsed < v76.WatchLabelUntil and (v76.NextLabelCheck or 0) <= elapsed then
                v76.NextLabelCheck = elapsed + 0.2
                updateLabelHeight(v76)
            end

            continue
        end

        detachPlotAnimal(v75)
    end
end

local function redrawAll() -- line: 686
    -- upvalues: v37 (ref), CollectionService (copy), AnimationLibrary (copy), t2 (copy), waitForReplication (copy), waitComplete (copy), t6 (copy), t7 (copy), wantsView (copy), showSource (copy), detachPlotAnimal (copy), attachHeldView (copy)
    local t22 = {}

    for v98 in pairs(t2) do
        table.insert(t22, v98)
    end

    for _, v99 in ipairs(t22) do
        detachPlotAnimal(v99, true)
    end

    local t23 = {}

    for v100 in pairs(t7) do
        table.insert(t23, v100)
    end

    for _, v101 in ipairs(t23) do
        local v102 = t7[v101]

        t7[v101] = nil

        if t6[v101] == v102 then
            t6[v101] = nil
        end

        if v102 then
            v102:Destroy()
        end

        showSource(v101)
    end

    for _, v103 in ipairs(CollectionService:GetTagged("PlotAnimal")) do
        task.spawn(v37, v103)
    end

    for _, v104 in ipairs(CollectionService:GetTagged("Animal")) do
        if not v104:GetAttribute("ViewCopy") and v104:GetAttribute("Carried") then
            task.spawn(function() -- line: 561
                -- upvalues: v104 (copy), AnimationLibrary (copy), waitForReplication (copy), waitComplete (copy), wantsView (copy), attachHeldView (copy)
                if waitForReplication(v104, 5) and not (wantsView(v104) and attachHeldView(v104)) and (not v104:GetAttribute("PartMade") or waitComplete(v104, 120)) then
                    AnimationLibrary.EnsureAnimalClips(v104:GetAttribute("AnimalName") or v104.Name)

                    if v104.Parent then
                        local function v105() -- line: 567
                            -- upvalues: v104 (copy), AnimationLibrary (copy)
                            AnimationLibrary.PlayAnimal(v104, "Idle", {
                                FadeTime = 0
                            })
                        end

                        pcall(v105)
                    end
                end
            end)
        end
    end
end

function t1.Init() -- line: 697
    -- upvalues: v37 (ref), CollectionService (copy), RunService (copy), AnimalTemplates (copy), Mutations (copy), AnimationLibrary (copy), waitForReplication (copy), waitComplete (copy), t6 (copy), t7 (copy), t8 (copy), wantsView (copy), showSource (copy), detachPlotAnimal (copy), attachHeldView (copy), attachOther (copy), step (copy), redrawAll (copy)
    for _, v106 in ipairs(CollectionService:GetTagged("PlotAnimal")) do
        task.spawn(v37, v106)
    end

    CollectionService:GetInstanceAddedSignal("PlotAnimal"):Connect(function(p30) -- line: 701
        -- upvalues: v37 (ref)
        task.spawn(v37, p30)
    end)
    CollectionService:GetInstanceRemovedSignal("PlotAnimal"):Connect(detachPlotAnimal)
    CollectionService:GetInstanceAddedSignal("Animal"):Connect(attachOther)
    CollectionService:GetInstanceRemovedSignal("Animal"):Connect(function(p31) -- line: 706
        -- upvalues: t6 (copy), t7 (copy), t8 (copy), showSource (copy)
        if t7[p31] then
            local v107 = t7[p31]

            t7[p31] = nil

            if t6[p31] == v107 then
                t6[p31] = nil
            end

            if v107 then
                v107:Destroy()
            end

            showSource(p31)
        end

        local v108 = t8[p31]

        if v108 and not p31.Parent then
            t8[p31] = nil
            v108.Conn:Disconnect()
        end
    end)

    for _, v109 in ipairs(CollectionService:GetTagged("Animal")) do
        if not v109:GetAttribute("ViewCopy") and v109:GetAttribute("Carried") then
            task.spawn(function() -- line: 561
                -- upvalues: v109 (copy), AnimationLibrary (copy), waitForReplication (copy), waitComplete (copy), wantsView (copy), attachHeldView (copy)
                if waitForReplication(v109, 5) and not (wantsView(v109) and attachHeldView(v109)) and (not v109:GetAttribute("PartMade") or waitComplete(v109, 120)) then
                    AnimationLibrary.EnsureAnimalClips(v109:GetAttribute("AnimalName") or v109.Name)

                    if v109.Parent then
                        local function v110() -- line: 567
                            -- upvalues: v109 (copy), AnimationLibrary (copy)
                            AnimationLibrary.PlayAnimal(v109, "Idle", {
                                FadeTime = 0
                            })
                        end

                        pcall(v110)
                    end
                end
            end)
        end
    end

    AnimalTemplates.Changed:Connect(redrawAll)
    RunService.Heartbeat:Connect(step)
    Mutations.StartScrolling()
end

return t1
