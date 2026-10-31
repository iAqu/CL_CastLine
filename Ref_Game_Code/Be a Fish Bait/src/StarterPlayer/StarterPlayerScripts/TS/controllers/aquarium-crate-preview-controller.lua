-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, Workspace = services.CollectionService, services.Players, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates")
local aquariumCrateSeriesList, getAquariumCrateSeriesById = v1.aquariumCrateSeriesList, v1.getAquariumCrateSeriesById
local getAquariumSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").getAquariumSkinData
local getAquariumSkinModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquariums").getAquariumSkinModel
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-placement-utils")
local computeAquariumPivotCFrame, prepareAquariumPrefabInstance = v2.computeAquariumPivotCFrame, v2.prepareAquariumPrefabInstance
local selectPlayerAquariumLevel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAquariumLevel
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local v3 = Vector2.new(0, -50)
local GothamBlack = Enum.Font.GothamBlack
local v4 = Color3.fromRGB(0, 0, 0)
local t1 = {}

for _, v5 in aquariumCrateSeriesList do
    for _, v6 in v5.entries do
        table.insert(t1, {
            seriesId = v5.id,
            skinName = v6.skin.name
        })
    end
end

local function getSkinDropChancePercent(p1, p2) -- line: 62
    -- upvalues: getAquariumCrateSeriesById (copy)
    local v7 = getAquariumCrateSeriesById(p1)

    if v7 ~= nil then
        local entries = v7.entries

        v7 = nil

        for v8, v9 in entries do
            local _ = v8 - 1

            if v9.skin.name == p2 == true then
                v7 = v9
                break
            end

            v7 = nil
        end
    end

    return if v7 ~= nil then v7.weightBasisPoints / 100 else nil
end

local function lightenColor(p3, p4) -- line: 84
    return Color3.new(p3.R + (1 - p3.R) * p4, p3.G + (1 - p3.G) * p4, p3.B + (1 - p3.B) * p4)
end

local function darkenColor(p5, p6) -- line: 89
    local v10 = 1 - p6

    return Color3.new(p5.R * v10, p5.G * v10, p5.B * v10)
end

local function getPreviewNameGradient(p7) -- line: 99
    -- upvalues: rarityColors (copy)
    local v11 = rarityColors[p7]
    local v12 = Color3.new(v11.R + (1 - v11.R) * 0.3, v11.G + (1 - v11.G) * 0.3, v11.B + (1 - v11.B) * 0.3)
    local v13 = Color3.new(v11.R * 0.4, v11.G * 0.4, v11.B * 0.4)

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, v12),
        ColorSequenceKeypoint.new(1, v13)
    })
end

local function ensureStroke(p8, p9) -- line: 105
    -- upvalues: v4 (copy)
    local v14 = p8:FindFirstChild(p9)

    if v14 == nil then
        v14 = Instance.new("UIStroke")
        v14.Name = p9
        v14.Parent = p8
    end

    v14.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    v14.Color = v4
    v14.LineJoinMode = Enum.LineJoinMode.Round
    v14.Thickness = 5

    return v14
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 121
        return "AquariumCratePreviewController"
    end
})

self.__index = self

function self.new(...) -- line: 126
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p10, p11) -- line: 130
    p10._skinPreviewController = p11
    p10._started = false
end

function self.onStart(p12) -- line: 134
    -- upvalues: CollectionService (copy)
    p12:_tryStart()
    CollectionService:GetInstanceAddedSignal("AquariumPreview"):Connect(function() -- line: 136
        -- upvalues: p12 (copy)
        return p12:_tryStart()
    end)
    CollectionService:GetInstanceAddedSignal("AqDisplayLbl"):Connect(function() -- line: 139
        -- upvalues: p12 (copy)
        return p12:_tryStart()
    end)
end

function self._tryStart(p13) -- line: 143
    -- upvalues: CollectionService (copy)
    if p13._started then
        return nil
    end

    local v17 = CollectionService:GetTagged("AquariumPreview")[1]
    local v18 = CollectionService:GetTagged("AqDisplayLbl")[1]
    local v19 = (if v17 == nil then v17 else v17:IsA("Attachment")) ~= true

    if not v19 then
        v19 = (if v18 == nil then v18 else v18:IsA("TextLabel")) ~= true
    end

    if v19 then
        return nil
    end

    local v20 = p13:_setupLabels(v18)

    if v20 == nil then
        return nil
    end

    p13._started = true
    task.spawn(function() -- line: 169
        -- upvalues: p13 (copy), v17 (copy), v18 (copy), v20 (copy)
        return p13:_runCycle(v17, v18, v20)
    end)
end

function self._setupLabels(_, p15) -- line: 173
    -- upvalues: GothamBlack (copy), v4 (copy)
    local BillboardGui = p15:FindFirstAncestorOfClass("BillboardGui")

    if BillboardGui == nil then
        warn("[src/client/controllers/aquarium-crate-preview-controller.ts:157]", "[AquariumCratePreviewController] \"AqDisplayLbl\" must be inside a BillboardGui.")

        return nil
    end

    p15.Visible = false
    BillboardGui.Size = UDim2.new(BillboardGui.Size.X.Scale * 1.3, BillboardGui.Size.X.Offset * 1.3, BillboardGui.Size.Y.Scale * 1.3, BillboardGui.Size.Y.Offset * 1.3)

    local AquariumCratePreviewTextStack = BillboardGui:FindFirstChild("AquariumCratePreviewTextStack")

    if AquariumCratePreviewTextStack == nil then
        AquariumCratePreviewTextStack = Instance.new("Frame")
        AquariumCratePreviewTextStack.Name = "AquariumCratePreviewTextStack"
        AquariumCratePreviewTextStack.BackgroundTransparency = 1
        AquariumCratePreviewTextStack.Size = UDim2.fromScale(1, 1)
        AquariumCratePreviewTextStack.Parent = BillboardGui

        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.FillDirection = Enum.FillDirection.Vertical
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.Padding = UDim.new(0, -4)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.Parent = AquariumCratePreviewTextStack

        local UIPadding = Instance.new("UIPadding")

        UIPadding.PaddingLeft = UDim.new(0.06, 0)
        UIPadding.PaddingRight = UDim.new(0.06, 0)
        UIPadding.Parent = AquariumCratePreviewTextStack
    end

    local AquariumCratePreviewSeriesTitle = AquariumCratePreviewTextStack:FindFirstChild("AquariumCratePreviewSeriesTitle")

    if not (if AquariumCratePreviewSeriesTitle == nil then AquariumCratePreviewSeriesTitle else AquariumCratePreviewSeriesTitle:IsA("TextLabel")) then
        AquariumCratePreviewSeriesTitle = Instance.new("TextLabel")
        AquariumCratePreviewSeriesTitle.Name = "AquariumCratePreviewSeriesTitle"
        AquariumCratePreviewSeriesTitle.Parent = AquariumCratePreviewTextStack
    end

    AquariumCratePreviewSeriesTitle.LayoutOrder = 0
    AquariumCratePreviewSeriesTitle.BackgroundTransparency = 1
    AquariumCratePreviewSeriesTitle.Font = GothamBlack
    AquariumCratePreviewSeriesTitle.Size = UDim2.fromScale(1, 0.2)
    AquariumCratePreviewSeriesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AquariumCratePreviewSeriesTitle.TextScaled = true
    AquariumCratePreviewSeriesTitle.TextXAlignment = Enum.TextXAlignment.Center
    AquariumCratePreviewSeriesTitle.TextYAlignment = Enum.TextYAlignment.Center

    local AquariumCratePreviewSeriesTitleStroke = AquariumCratePreviewSeriesTitle:FindFirstChild("AquariumCratePreviewSeriesTitleStroke")

    if AquariumCratePreviewSeriesTitleStroke == nil then
        AquariumCratePreviewSeriesTitleStroke = Instance.new("UIStroke")
        AquariumCratePreviewSeriesTitleStroke.Name = "AquariumCratePreviewSeriesTitleStroke"
        AquariumCratePreviewSeriesTitleStroke.Parent = AquariumCratePreviewSeriesTitle
    end

    AquariumCratePreviewSeriesTitleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    AquariumCratePreviewSeriesTitleStroke.Color = v4
    AquariumCratePreviewSeriesTitleStroke.LineJoinMode = Enum.LineJoinMode.Round
    AquariumCratePreviewSeriesTitleStroke.Thickness = 5

    local AquariumCratePreviewName = AquariumCratePreviewTextStack:FindFirstChild("AquariumCratePreviewName")

    if not (if AquariumCratePreviewName == nil then AquariumCratePreviewName else AquariumCratePreviewName:IsA("TextLabel")) then
        AquariumCratePreviewName = Instance.new("TextLabel")
        AquariumCratePreviewName.Name = "AquariumCratePreviewName"
        AquariumCratePreviewName.Parent = AquariumCratePreviewTextStack
    end

    AquariumCratePreviewName.LayoutOrder = 1
    AquariumCratePreviewName.BackgroundTransparency = 1
    AquariumCratePreviewName.Font = GothamBlack
    AquariumCratePreviewName.Size = UDim2.fromScale(1, 0.55)
    AquariumCratePreviewName.TextColor3 = Color3.fromRGB(255, 255, 255)
    AquariumCratePreviewName.TextScaled = true
    AquariumCratePreviewName.TextXAlignment = Enum.TextXAlignment.Center
    AquariumCratePreviewName.TextYAlignment = Enum.TextYAlignment.Center

    local AquariumCratePreviewNameStroke = AquariumCratePreviewName:FindFirstChild("AquariumCratePreviewNameStroke")

    if AquariumCratePreviewNameStroke == nil then
        AquariumCratePreviewNameStroke = Instance.new("UIStroke")
        AquariumCratePreviewNameStroke.Name = "AquariumCratePreviewNameStroke"
        AquariumCratePreviewNameStroke.Parent = AquariumCratePreviewName
    end

    AquariumCratePreviewNameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    AquariumCratePreviewNameStroke.Color = v4
    AquariumCratePreviewNameStroke.LineJoinMode = Enum.LineJoinMode.Round
    AquariumCratePreviewNameStroke.Thickness = 5

    local AquariumCratePreviewNameGradient = AquariumCratePreviewName:FindFirstChild("AquariumCratePreviewNameGradient")

    if AquariumCratePreviewNameGradient == nil then
        AquariumCratePreviewNameGradient = Instance.new("UIGradient")
        AquariumCratePreviewNameGradient.Name = "AquariumCratePreviewNameGradient"
        AquariumCratePreviewNameGradient.Rotation = 0
        AquariumCratePreviewNameGradient.Parent = AquariumCratePreviewName
    end

    local AquariumCratePreviewChance = AquariumCratePreviewTextStack:FindFirstChild("AquariumCratePreviewChance")

    if not (if AquariumCratePreviewChance == nil then AquariumCratePreviewChance else AquariumCratePreviewChance:IsA("TextLabel")) then
        AquariumCratePreviewChance = Instance.new("TextLabel")
        AquariumCratePreviewChance.Name = "AquariumCratePreviewChance"
        AquariumCratePreviewChance.Parent = AquariumCratePreviewTextStack
    end

    AquariumCratePreviewChance.LayoutOrder = 2
    AquariumCratePreviewChance.BackgroundTransparency = 1
    AquariumCratePreviewChance.Font = GothamBlack
    AquariumCratePreviewChance.Size = UDim2.fromScale(1, 0.15)
    AquariumCratePreviewChance.TextColor3 = Color3.fromRGB(255, 255, 255)
    AquariumCratePreviewChance.TextScaled = true
    AquariumCratePreviewChance.TextXAlignment = Enum.TextXAlignment.Center
    AquariumCratePreviewChance.TextYAlignment = Enum.TextYAlignment.Center

    local AquariumCratePreviewChanceStroke = AquariumCratePreviewChance:FindFirstChild("AquariumCratePreviewChanceStroke")

    if AquariumCratePreviewChanceStroke == nil then
        AquariumCratePreviewChanceStroke = Instance.new("UIStroke")
        AquariumCratePreviewChanceStroke.Name = "AquariumCratePreviewChanceStroke"
        AquariumCratePreviewChanceStroke.Parent = AquariumCratePreviewChance
    end

    AquariumCratePreviewChanceStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    AquariumCratePreviewChanceStroke.Color = v4
    AquariumCratePreviewChanceStroke.LineJoinMode = Enum.LineJoinMode.Round
    AquariumCratePreviewChanceStroke.Thickness = 5

    return {
        chanceLabel = AquariumCratePreviewChance,
        nameGradient = AquariumCratePreviewNameGradient,
        nameLabel = AquariumCratePreviewName,
        seriesTitleLabel = AquariumCratePreviewSeriesTitle
    }
end

function self._runCycle(p16, p17, p18, p19) -- line: 264
    -- upvalues: t1 (copy)
    local WorldCFrame = p17.WorldCFrame
    local v21

    while p17.Parent ~= nil and p18.Parent ~= nil do
        local v22 = v21

        for _, v23 in t1 do
            local v24 = p16:_spawnPreviewModel(v23.skinName, WorldCFrame)

            if v24 ~= nil then
                if v22 ~= nil then
                    v22:Destroy()
                end

                v22 = v24
                p16:_applyLabels(p19, v23)
            end

            task.wait(8)

            if p17.Parent == nil then
                v21 = v22
                break
            end

            if p18.Parent == nil then
                v21 = v22
                break
            end

            v21 = v22
        end
    end

    if v21 ~= nil then
        v21:Destroy()
    end
end

function self._applyLabels(_, p21, p22) -- line: 291
    -- upvalues: getAquariumCrateSeriesById (copy), getAquariumSkinData (copy), getSkinDropChancePercent (copy), getPreviewNameGradient (copy)
    local v25 = getAquariumCrateSeriesById(p22.seriesId)
    local seriesTitleLabel = p21.seriesTitleLabel

    if v25 ~= nil then
        seriesTitleLabel.Text = ("%* Crate"):format(v25.displayName)
    else
        seriesTitleLabel.Text = ""
    end

    local v26 = getAquariumSkinData(p22.skinName)
    local v27 = if v26 == nil then v26 else v26.displayName

    if v27 == nil then
        v27 = p22.skinName
    end

    p21.nameLabel.Text = v27

    if v26 ~= nil then
        p21.nameGradient.Color = getPreviewNameGradient(v26.rarity)
    end

    local v28 = getSkinDropChancePercent(p22.seriesId, p22.skinName)
    local chanceLabel = p21.chanceLabel

    if v28 ~= nil then
        chanceLabel.Text = ("%*%%"):format(v28)
    else
        chanceLabel.Text = ""
    end
end

function self._spawnPreviewModel(p23, p24, p25) -- line: 310
    -- upvalues: Workspace (copy), getAquariumSkinModel (copy), computeAquariumPivotCFrame (copy), prepareAquariumPrefabInstance (copy)
    local v29 = getAquariumSkinModel(5, p24)
    local Archivable = v29.Archivable

    v29.Archivable = true

    local clone = v29:Clone()

    v29.Archivable = Archivable

    if clone == nil then
        warn("[src/client/controllers/aquarium-crate-preview-controller.ts:296]", (("[AquariumCratePreviewController] Could not clone skin \"%*\"."):format(p24)))

        return nil
    end

    clone.Name = "AquariumCratePreviewModel"
    prepareAquariumPrefabInstance(clone)

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end

    clone.Parent = Workspace
    clone:ScaleTo(0.48)
    clone:PivotTo(computeAquariumPivotCFrame(clone, p25, 5, p24, 0.48, true))
    p23:_attachPreviewPrompt(clone, p24)

    return clone
end

function self._attachPreviewPrompt(p26, p27, p28) -- line: 333
    -- upvalues: Players (copy), clientProducer (copy), getAquariumSkinData (copy), selectPlayerAquariumLevel (copy), v3 (copy)
    local v30 = p27:FindFirstChild("AquariumTank", true)

    if not (if v30 == nil then v30 else v30:IsA("BasePart")) then
        warn("[src/client/controllers/aquarium-crate-preview-controller.ts:324]", (("[AquariumCratePreviewController] No \"AquariumTank\" part found on skin \"%*\" preview model."):format(p28)))

        return nil
    end

    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.Name = "PreviewPrompt"
    ProximityPrompt.ActionText = "Preview"

    local v31 = getAquariumSkinData(p28)

    if v31 ~= nil then
        v31 = v31.displayName
    end

    ProximityPrompt.ObjectText = if v31 == nil then p28 else v31
    ProximityPrompt.HoldDuration = 0
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.Q
    ProximityPrompt.MaxActivationDistance = 20
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.UIOffset = v3
    ProximityPrompt.Triggered:Connect(function(p29) -- line: 360
        -- upvalues: p26 (copy), p28 (copy), Players (copy), clientProducer (copy), selectPlayerAquariumLevel (copy)
        if p29 ~= Players.LocalPlayer then
            return nil
        end

        local v33 = selectPlayerAquariumLevel((tostring(Players.LocalPlayer.UserId)))(clientProducer:getState())

        p26._skinPreviewController:startPreview(p28, v33)
    end)
    ProximityPrompt.Parent = v30
end

Reflect.defineMetadata(self, "identifier", "client/controllers/aquarium-crate-preview-controller@AquariumCratePreviewController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/aquarium-skin-preview-controller@AquariumSkinPreviewController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    AquariumCratePreviewController = self
}
