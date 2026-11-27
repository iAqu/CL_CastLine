-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HUD = PlayerGui:WaitForChild("HUD")
local FishTag = HUD:WaitForChild("FishTag")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local Format = require(Modules:WaitForChild("Format"))
local GrowthDisplay = require(Modules:WaitForChild("GrowthDisplay"))
local MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))
local Loc = require(Modules:WaitForChild("Loc"))
local TitanConfig = require(Modules:WaitForChild("TitanConfig"))
local v1 = Vector2.new(FishTag.Size.X.Scale, FishTag.Size.Y.Scale)
local v2 = Vector2.new(3, 3 * v1.Y / v1.X)

local function tagScale(p1, p2) -- line: 77
    local ExtentsSize = p1:IsA("Model") and p1:GetExtentsSize() or p2.Size

    return (math.clamp(math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z) / 12, 0.35, 8))
end

local t1 = {}
local t2 = {}

local function tagShown(p3) -- line: 89
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("CameraUnderwater") then
        return false
    end

    local PenOwner = p3:GetAttribute("PenOwner")

    if PenOwner == nil or PenOwner == LocalPlayer.UserId then
        return true
    end

    if LocalPlayer:GetAttribute("SetOtherAquariums") == false then
        return false
    end

    return LocalPlayer:GetAttribute("Potato") ~= true
end

local function refreshShown() -- line: 96
    -- upvalues: t1 (copy), tagShown (copy)
    for v4, v5 in pairs(t1) do
        v5.gui.Enabled = tagShown(v4)
    end
end

LocalPlayer:GetAttributeChangedSignal("SetOtherAquariums"):Connect(refreshShown)
LocalPlayer:GetAttributeChangedSignal("Potato"):Connect(refreshShown)
LocalPlayer:GetAttributeChangedSignal("CameraUnderwater"):Connect(refreshShown)

local function paint(p4, p5) -- line: 104
    -- upvalues: RarityStyle (copy)
    p4.TextColor3 = p5
    p4.UIStroke.Color = RarityStyle.Glows(p5) and RarityStyle.StrokeOf(p5) or Color3.new(0, 0, 0)
end

local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 50)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 255, 50)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(50, 150, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(130, 50, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 150))
})

local function setMutation(p6, p7) -- line: 117
    -- upvalues: RarityStyle (copy), MutationDisplay (copy), Loc (copy), v6 (copy)
    local Mutation = p7:GetAttribute("Mutation")
    local v7 = Mutation and MutationDisplay[Mutation]

    p6.Visible = v7 ~= nil

    if not v7 then
        return
    end

    p6.Text = Loc.T(v7.display)
    p6.Grad.Enabled = v7.cycle == true

    if v7.cycle then
        p6.Grad.Color = v6

        local v8 = Color3.new(1, 1, 1)

        p6.TextColor3 = v8
        p6.UIStroke.Color = RarityStyle.Glows(v8) and RarityStyle.StrokeOf(v8) or Color3.new(0, 0, 0)
    else
        local v9 = v7.textColor or v7.color

        p6.TextColor3 = v9
        p6.UIStroke.Color = RarityStyle.Glows(v9) and RarityStyle.StrokeOf(v9) or Color3.new(0, 0, 0)

        if v7.glow then
            p6.UIStroke.Color = v7.glow
        end
    end
end

local function rateText(p8, p9) -- line: 134
    -- upvalues: Format (copy), TitanConfig (copy)
    local TitanBonus = p8:GetAttribute("TitanBonus")

    if TitanBonus then
        return TitanConfig.Signed(p9, TitanBonus)
    end

    local Boost = p8:GetAttribute("Boost")

    if Boost then
        return "+" .. Boost .. "% $/s"
    end

    local Copy = p8:GetAttribute("Copy")

    if Copy then
        return tostring(Copy) .. "x BEST $/s"
    end

    return Format.money(p8:GetAttribute("Rate") or 0) .. "/s"
end

local function setStage(p10, p11) -- line: 151
    -- upvalues: GrowthDisplay (copy)
    local Stage = p11:GetAttribute("Stage")

    p10.Text = Stage and GrowthDisplay.Span(Stage, nil, p11:GetAttribute("Inf")) or ""

    local v10 = Stage and GrowthDisplay.gradients[Stage]

    p10.Grad.Enabled = v10 ~= nil

    if v10 then
        p10.Grad.Color = v10
    end
end

local function titanLook(p12, p13, p14) -- line: 164
    -- upvalues: HUD (copy), RarityStyle (copy), TitanConfig (copy)
    local v11 = TitanConfig.SPECIES[p13]

    if not (v11 and TitanConfig.STATS[v11.stat]) then
        return
    end

    TitanConfig.StatIcon(p12.RateRow.Icon, v11.stat)

    local v12 = TitanConfig.StatGradient(HUD, v11.stat)

    if v12 then
        local Money, Money2 = p12.RateRow.Rate.Money, p12.RateRow.Rate.Money
        local Color, Rotation = v12.Color, v12.Rotation

        Money.Color = Color
        Money2.Rotation = Rotation
    end

    p12.Stage.Visible = false

    local Rate = p12.RateRow.Rate
    local TextSize = game:GetService("TextService"):GetTextSize(Rate.Text, 100, Rate.Font, Vector2.new(1E+05, 1E+05))
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.AspectRatio = TextSize.X / math.max(TextSize.Y, 1)
    UIAspectRatioConstraint.Parent = Rate
    Rate.TextXAlignment = Enum.TextXAlignment.Center

    if p14 then
        p12.Rarity.Grad.Enabled = true
        RarityStyle.Track(p12.Rarity, p14.color)
    end
end

local function buildTag(p15, p16, p17, p18, p19) -- line: 194
    -- upvalues: PlayerGui (copy), FishTag (copy), FishDisplay (copy), RarityDisplay (copy), RarityStyle (copy), Loc (copy), t1 (copy), tagShown (copy), setMutation (copy), rateText (copy), setStage (copy), titanLook (copy)
    if t1[p15] then
        return
    end

    local v13 = FishDisplay[p17]
    local RarityDisplay2, v14, v15

    if v13 then
        local rarity = v13.rarity

        if rarity then
            RarityDisplay2 = RarityDisplay
            v14 = v13.shown or v13.rarity
            v15 = RarityDisplay2[v14]
        else
            v15 = rarity
        end
    else
        v15 = v13
    end

    local clone = FishTag:Clone()
    local Rate = clone.RateRow.Rate

    clone.Rarity.Text = v15 and Loc.T(v15.display) or ""

    if v15 then
        local Rarity = clone.Rarity
        local color = v15.color

        Rarity.TextColor3 = color
        Rarity.UIStroke.Color = RarityStyle.Glows(color) and RarityStyle.StrokeOf(color) or Color3.new(0, 0, 0)
    end

    setMutation(clone.Mutation, p15)

    local function nameText() -- line: 205
        -- upvalues: p15 (copy), p17 (copy), v13 (copy), Loc (copy)
        local Serial = p15:GetAttribute("Serial")
        local Nick = p15:GetAttribute("Nick")
        local v16, v17

        if Nick then
            v16 = Nick
            v17 = true
        elseif v13 then
            local v18 = Loc.T(v13.display)

            if v18 then
                v16 = v18
                v17 = true
            else
                v17 = false
            end
        else
            v17 = false
        end

        if not v17 then
            v16 = p17
        end

        return v16 .. (Serial and " #" .. Serial or "")
    end

    local Species = clone.Species
    local Serial = p15:GetAttribute("Serial")
    local Nick = p15:GetAttribute("Nick")
    local v19, v20

    if Nick then
        v19 = Nick
        v20 = true
    elseif v13 then
        local v21 = Loc.T(v13.display)

        if v21 then
            v19 = v21
            v20 = true
        else
            v20 = false
        end
    else
        v20 = false
    end

    if not v20 then
        v19 = p17
    end

    Species.Text = v19 .. (Serial and " #" .. Serial or "")
    Rate.Text = rateText(p15, p17)
    setStage(clone.Stage, p15)

    if p15:GetAttribute("TitanBonus") then
        titanLook(clone, p17, v15)
    end

    local Attachment

    local function place() -- line: 224
        -- upvalues: p15 (copy), p16 (copy), p18 (copy), p19 (copy), clone (copy), Attachment (ref)
        local ExtentsSize = p15:IsA("Model") and p15:GetExtentsSize() or p16.Size
        local v23 = math.clamp(math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z) / 12, 0.35, 8)

        clone.Size = UDim2.fromScale(p19.X * v23, p19.Y * v23)
        clone.StudsOffsetWorldSpace = Vector3.new(0, p18() + p19.Y * v23 / 2, 0)

        local TagOffset = p15:GetAttribute("TagOffset")

        if typeof(TagOffset) ~= "Vector3" then
            return
        end

        if not Attachment then
            Attachment = Instance.new("Attachment")
            Attachment.Name = "TagAnchor"
            Attachment.Parent = p16
            clone.Adornee = Attachment
        end

        local Attachment2 = Attachment

        Attachment2.Position = TagOffset * (p15:GetAttribute("Size") or 1)
    end

    clone.Adornee = p16
    place()
    clone.Enabled = tagShown(p15)
    clone.Parent = PlayerGui
    t1[p15] = {
        gui = clone,
        anchor = Attachment,
        conns = {
            p15:GetAttributeChangedSignal("Rate"):Connect(function() -- line: 249
                -- upvalues: p15 (copy), p17 (copy), Rate (copy), rateText (copy)
                Rate.Text = rateText(p15, p17)
            end),
            p15:GetAttributeChangedSignal("Boost"):Connect(function() -- line: 250
                -- upvalues: p15 (copy), p17 (copy), Rate (copy), rateText (copy)
                Rate.Text = rateText(p15, p17)
            end),
            p15:GetAttributeChangedSignal("Mutation"):Connect(function() -- line: 251
                -- upvalues: p15 (copy), clone (copy), setMutation (copy)
                setMutation(clone.Mutation, p15)
            end),
            p15:GetAttributeChangedSignal("Nick"):Connect(function() -- line: 252
                -- upvalues: p15 (copy), p17 (copy), v13 (copy), clone (copy), Loc (copy)
                local Species = clone.Species
                local Serial = p15:GetAttribute("Serial")
                local Nick = p15:GetAttribute("Nick")
                local v25, v26

                if Nick then
                    v25 = Nick
                    v26 = true
                elseif v13 then
                    local v27 = Loc.T(v13.display)

                    if v27 then
                        v25 = v27
                        v26 = true
                    else
                        v26 = false
                    end
                else
                    v26 = false
                end

                if not v26 then
                    v25 = p17
                end

                Species.Text = v25 .. (Serial and " #" .. Serial or "")
            end),
            p15:GetAttributeChangedSignal("Stage"):Connect(function() -- line: 253
                -- upvalues: p15 (copy), clone (copy), setStage (copy)
                setStage(clone.Stage, p15)
            end),
            p15:GetAttributeChangedSignal("Inf"):Connect(function() -- line: 255
                -- upvalues: p15 (copy), clone (copy), setStage (copy)
                setStage(clone.Stage, p15)
            end),
            p16:GetPropertyChangedSignal("Size"):Connect(place),
            Loc.Changed:Connect(function() -- line: 257
                -- upvalues: p15 (copy), p17 (copy), v13 (copy), clone (copy), v15 (ref), Loc (copy), setMutation (copy), setStage (copy)
                clone.Rarity.Text = v15 and Loc.T(v15.display) or ""
                setMutation(clone.Mutation, p15)

                local Species = clone.Species
                local Serial = p15:GetAttribute("Serial")
                local Nick = p15:GetAttribute("Nick")
                local v28, v29

                if Nick then
                    v28 = Nick
                    v29 = true
                elseif v13 then
                    local v30 = Loc.T(v13.display)

                    if v30 then
                        v28 = v30
                        v29 = true
                    else
                        v29 = false
                    end
                else
                    v29 = false
                end

                if not v29 then
                    v28 = p17
                end

                Species.Text = v28 .. (Serial and " #" .. Serial or "")
                setStage(clone.Stage, p15)
            end)
        }
    }
    p15.Destroying:Once(function() -- line: 268
        -- upvalues: p15 (copy), t1 (copy)
        local v31 = t1[p15]

        if not v31 then
            return
        end

        for _, v32 in ipairs(v31.conns) do
            v32:Disconnect()
        end

        v31.gui:Destroy()

        if v31.anchor then
            v31.anchor:Destroy()
        end

        t1[p15] = nil
    end)
end

local function addTag(p20) -- line: 280
    -- upvalues: v1 (copy), buildTag (copy)
    local v33 = p20.PrimaryPart or p20:FindFirstChildWhichIsA("BasePart")

    if v33 then
        buildTag(p20, v33, p20.Name, function() -- line: 286
            -- upvalues: p20 (copy)
            return p20:GetExtentsSize().Y / 2 + 1.6
        end, v1)
    end
end

local function dropTag(p21) -- line: 289
    -- upvalues: t1 (copy), t2 (copy)
    local v34 = t1[p21]

    if v34 then
        for _, v35 in ipairs(v34.conns) do
            v35:Disconnect()
        end

        v34.gui:Destroy()

        if v34.anchor then
            v34.anchor:Destroy()
        end

        t1[p21] = nil
    end

    local v36 = t2[p21]

    if v36 then
        v36:Disconnect()
        t2[p21] = nil
    end
end

local function watch(p22) -- line: 308
    -- upvalues: v1 (copy), t2 (copy), buildTag (copy)
    if p22:GetAttribute("PenOwner") then
        local v37 = p22.PrimaryPart or p22:FindFirstChildWhichIsA("BasePart")

        if v37 then
            buildTag(p22, v37, p22.Name, function() -- line: 286
                -- upvalues: p22 (copy)
                return p22:GetExtentsSize().Y / 2 + 1.6
            end, v1)
        end
    elseif not t2[p22] then
        t2[p22] = p22:GetAttributeChangedSignal("PenOwner"):Connect(function() -- line: 314
            -- upvalues: p22 (copy), v1 (copy), t2 (copy), buildTag (copy)
            local v38 = t2[p22]

            if v38 then
                v38:Disconnect()
                t2[p22] = nil
            end

            if p22:GetAttribute("PenOwner") then
                local v39 = p22.PrimaryPart or p22:FindFirstChildWhichIsA("BasePart")

                if not v39 then
                    return
                end

                buildTag(p22, v39, p22.Name, function() -- line: 286
                    -- upvalues: p22 (copy)
                    return p22:GetExtentsSize().Y / 2 + 1.6
                end, v1)
            end
        end)
    end
end

local Fish = workspace:WaitForChild("Fish")

for _, child in ipairs(Fish:GetChildren()) do
    watch(child)
end

Fish.ChildAdded:Connect(watch)
Fish.ChildRemoved:Connect(dropTag)

local function toolEquipped(p23) -- line: 335
    -- upvalues: v2 (copy), buildTag (copy)
    if p23:IsA("Tool") and p23:GetAttribute("Species") then
        task.spawn(function() -- line: 338
            -- upvalues: p23 (copy), v2 (copy), buildTag (copy)
            local v40 = p23:FindFirstChild("Handle") or p23:WaitForChild("Handle", 5)

            if not (v40 and p23.Parent and p23.Parent:FindFirstChildOfClass("Humanoid")) then
                return
            end

            buildTag(p23, v40, p23:GetAttribute("Species"), function() -- line: 342
                -- upvalues: v40 (copy)
                return v40.Size.Y / 2 + 1.6
            end, v2)
        end)
    end
end

local function watchCharacter(p24) -- line: 346
    -- upvalues: dropTag (copy), toolEquipped (copy)
    for _, child in ipairs(p24:GetChildren()) do
        toolEquipped(child)
    end

    p24.ChildAdded:Connect(toolEquipped)
    p24.ChildRemoved:Connect(dropTag)
end

task.spawn(function() -- line: 354
    -- upvalues: v1 (copy), buildTag (copy), dropTag (copy)
    local Mimics = workspace:WaitForChild("Mimics")

    local function watchMimic(p25) -- line: 356
        -- upvalues: v1 (copy), buildTag (copy)
        if p25.PrimaryPart then
            local v41 = p25.PrimaryPart or p25:FindFirstChildWhichIsA("BasePart")

            if v41 then
                buildTag(p25, v41, p25.Name, function() -- line: 286
                    -- upvalues: p25 (copy)
                    return p25:GetExtentsSize().Y / 2 + 1.6
                end, v1)
            end
        else
            local connection

            connection = p25:GetPropertyChangedSignal("PrimaryPart"):Connect(function() -- line: 359
                -- upvalues: p25 (copy), connection (ref), v1 (copy), buildTag (copy)
                if p25.PrimaryPart then
                    connection:Disconnect()

                    local v42 = p25.PrimaryPart or p25:FindFirstChildWhichIsA("BasePart")

                    if not v42 then
                        return
                    end

                    buildTag(p25, v42, p25.Name, function() -- line: 286
                        -- upvalues: p25 (copy)
                        return p25:GetExtentsSize().Y / 2 + 1.6
                    end, v1)
                end
            end)
        end
    end

    for _, child in ipairs(Mimics:GetChildren()) do
        if child.PrimaryPart then
            local v43 = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")

            if v43 then
                buildTag(child, v43, child.Name, function() -- line: 286
                    -- upvalues: child (copy)
                    return child:GetExtentsSize().Y / 2 + 1.6
                end, v1)
            end
        else
            local connection

            connection = child:GetPropertyChangedSignal("PrimaryPart"):Connect(function() -- line: 359
                -- upvalues: child (copy), connection (ref), v1 (copy), buildTag (copy)
                if child.PrimaryPart then
                    connection:Disconnect()

                    local v44 = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")

                    if not v44 then
                        return
                    end

                    buildTag(child, v44, child.Name, function() -- line: 286
                        -- upvalues: child (copy)
                        return child:GetExtentsSize().Y / 2 + 1.6
                    end, v1)
                end
            end)
        end
    end

    Mimics.ChildAdded:Connect(watchMimic)
    Mimics.ChildRemoved:Connect(dropTag)
end)
task.spawn(function() -- line: 377
    -- upvalues: v1 (copy), t1 (copy), buildTag (copy), dropTag (copy)
    local TitanPets = workspace:WaitForChild("TitanPets")

    local function watchPet(p26) -- line: 379
        -- upvalues: v1 (copy), t1 (copy), buildTag (copy)
        local PrimaryPart = p26.PrimaryPart

        if not PrimaryPart then
            return
        end

        buildTag(p26, PrimaryPart, p26.Name, function() -- line: 382
            -- upvalues: p26 (copy)
            return p26:GetExtentsSize().Y / 2 + 1.6
        end, v1 * 0.55)

        local v45 = t1[p26]

        if v45 then
            v45.gui.MaxDistance = 300
        end
    end

    for _, child in ipairs(TitanPets:GetChildren()) do
        local PrimaryPart = child.PrimaryPart

        if PrimaryPart then
            buildTag(child, PrimaryPart, child.Name, function() -- line: 382
                -- upvalues: child (copy)
                return child:GetExtentsSize().Y / 2 + 1.6
            end, v1 * 0.55)

            local v46 = t1[child]

            if v46 then
                v46.gui.MaxDistance = 300
            end
        end
    end

    TitanPets.ChildAdded:Connect(watchPet)
    TitanPets.ChildRemoved:Connect(dropTag)
end)

local function watchPlayer(p27) -- line: 391
    -- upvalues: watchCharacter (copy)
    if p27.Character then
        watchCharacter(p27.Character)
    end

    p27.CharacterAdded:Connect(watchCharacter)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        watchCharacter(player.Character)
    end

    player.CharacterAdded:Connect(watchCharacter)
end

Players.PlayerAdded:Connect(watchPlayer)
