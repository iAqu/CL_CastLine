-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

require(ReplicatedStorage.Data.Assets)

local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local Assets = require(ReplicatedStorage.Data.Assets)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local v1 = UDim2.fromScale(0.5, 0.5)
local v2 = Vector2.new(0.5, 0.5)
local v3 = UDim2.fromScale(1, 1)
local v4 = UDim2.fromScale(0.77, 0.77)
local v5 = UDim2.fromScale(0.85, 0.85)
local v6 = UDim2.fromScale(0, 0)
local v7 = Color3.fromRGB(0, 0, 0)
local v8 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v9 = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local v10 = t.strict(t.instanceIsA("ImageLabel"))
local v11 = t.strict(t.string)
local v12 = t.strict(t.Color3)
local v13 = t.strict(t.number)
local v14 = t.strict(t.instanceIsA("GuiObject"))
local v15 = t.strict(t.optional(t.callback))
local t1 = {}

local function carries(p1, p2) -- line: 52
    if p1.BaseMutation == p2 then
        return true
    end

    return table.find(p1.Mutations, p2) ~= nil
end

local function zoomFor(_) -- line: 58
    return 1, nil
end

local function iconFor(p4, p5) -- line: 60
    -- upvalues: Mutations (copy)
    local MutationIcons = p4.MutationIcons

    if MutationIcons ~= nil then
        local v16 = Mutations.Ids()

        for _, v17 in {
                v16.Golden,
                v16.Silver
            } do
            if (p5.BaseMutation == v17 or table.find(p5.Mutations, v17) ~= nil) and MutationIcons[v17] ~= nil then
                return MutationIcons[v17]
            end
        end
    end

    return p4.Icon or ""
end

local function imagesFor(p6, p7) -- line: 76
    -- upvalues: Mutations (copy), iconFor (copy)
    local v18 = iconFor(p6, p7)
    local t2 = {
        Icon = v18
    }
    local Rainbow = Mutations.Ids().Rainbow

    t2.RainbowOverlay = if p7.BaseMutation == Rainbow or table.find(p7.Mutations, Rainbow) ~= nil then p6.WhiteImage or v18 else nil

    return t2
end

local function stretchBy(p8, p9, p10) -- line: 86
    return UDim2.new(p8.X.Scale * p9, p8.X.Offset * p9, p8.Y.Scale * p10, p8.Y.Offset * p10)
end

local function makeCanvas(p11, p12, p13, p14) -- line: 95
    -- upvalues: v1 (copy), v2 (copy)
    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = p11
    CanvasGroup.Size = p12
    CanvasGroup.Position = v1
    CanvasGroup.AnchorPoint = v2
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.ClipsDescendants = true
    CanvasGroup.ZIndex = p13
    CanvasGroup.Parent = p14

    return CanvasGroup
end

local function makeZoomedImage(p15, p16, p17, p18, p19) -- line: 109
    -- upvalues: v1 (copy), v2 (copy)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = p15
    ImageLabel.Image = p16
    ImageLabel.Size = UDim2.fromScale(p17, p17)
    ImageLabel.Position = v1 + p18
    ImageLabel.AnchorPoint = v2
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = p19

    return ImageLabel
end

function t1.OverlayRainbow(p20, p21) -- line: 129
    -- upvalues: Rarity (copy), v1 (copy), v2 (copy), v3 (copy), v10 (copy), v11 (copy)
    v10(p20)
    v11(p21)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "RainbowOverlayImage"
    ImageLabel.Image = p21
    ImageLabel.ImageTransparency = 0.5
    ImageLabel.Size = v3
    ImageLabel.Position = v1
    ImageLabel.AnchorPoint = v2
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = p20.ZIndex + 1
    ImageLabel.Parent = p20
    Rarity.Rarities.Rainbow.RarityGradient:Clone().Parent = ImageLabel

    return ImageLabel
end

function t1.Strip(p22) -- line: 150
    -- upvalues: v10 (copy)
    v10(p22)

    local RainbowOverlayImage = p22:FindFirstChild("RainbowOverlayImage")

    if RainbowOverlayImage and RainbowOverlayImage:IsA("ImageLabel") then
        RainbowOverlayImage:Destroy()
    end

    local AssetIconShapeLayer = p22:FindFirstChild("AssetIconShapeLayer")

    if AssetIconShapeLayer ~= nil then
        AssetIconShapeLayer:Destroy()
    end

    p22.ImageTransparency = 0
end

function t1.Tint(p23, p24, p25) -- line: 166
    -- upvalues: v7 (copy), v10 (copy), v12 (copy), v13 (copy)
    v10(p23)
    v12(p24)
    v13(p25)
    p23.ImageColor3 = p24
    p23.ImageTransparency = p25

    local AssetIconShapeLayer = p23:FindFirstChild("AssetIconShapeLayer")

    if AssetIconShapeLayer ~= nil then
        local v19 = if p24 == v7 then p24 else v7

        for _, descendant in AssetIconShapeLayer:GetDescendants() do
            if descendant:IsA("ImageLabel") then
                descendant.ImageTransparency = p25

                if descendant.Name == "IconStrokeImage" then
                    descendant.ImageColor3 = v19
                else
                    descendant.ImageColor3 = p24
                end
            end
        end
    end
end

function t1.ResolveImages(p26) -- line: 192
    -- upvalues: AssetItem (copy), Assets (copy), imagesFor (copy)
    assert(AssetItem.AssetItemData(p26))

    local v20 = Assets.Directory[p26.Category]

    assert(v20 ~= nil, (("no asset directory entry for category %*"):format(p26.Category)))

    return (imagesFor(v20, p26))
end

function t1.Paint(p27, p28) -- line: 200
    -- upvalues: AssetItem (copy), Assets (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v10 (copy), t1 (copy), imagesFor (copy)
    v10(p27)
    assert(AssetItem.AssetItemData(p28))

    local v23 = Assets.Directory[p28.Category]

    assert(v23 ~= nil, (("no asset directory entry for category %*"):format(p28.Category)))

    local v26 = imagesFor(v23, p28)
    local Icon = v26.Icon

    assert(v6, "the icon zoom offset fell through its own default")
    t1.Strip(p27)
    p27.BackgroundTransparency = 1
    p27.ScaleType = Enum.ScaleType.Fit

    if 1 <= 1 then
        p27.Image = Icon
        p27.ImageTransparency = 0

        if v26.RainbowOverlay ~= nil then
            t1.OverlayRainbow(p27, v26.RainbowOverlay)
        end
    else
        p27.Image = ""
        p27.ImageTransparency = 1

        local Frame = Instance.new("Frame")

        Frame.Name = "AssetIconShapeLayer"
        Frame.Size = v3
        Frame.Position = v1
        Frame.AnchorPoint = v2
        Frame.BackgroundTransparency = 1
        Frame.ZIndex = p27.ZIndex
        Frame.Parent = p27

        local ZIndex = p27.ZIndex
        local CanvasGroup = Instance.new("CanvasGroup")

        CanvasGroup.Name = "IconStrokeFrame"
        CanvasGroup.Size = v5
        CanvasGroup.Position = v1
        CanvasGroup.AnchorPoint = v2
        CanvasGroup.BackgroundTransparency = 1
        CanvasGroup.ClipsDescendants = true
        CanvasGroup.ZIndex = ZIndex
        CanvasGroup.Parent = Frame

        local ZIndex2 = p27.ZIndex
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "IconStrokeImage"
        ImageLabel.Image = Icon
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.Position = v1 + v6
        ImageLabel.AnchorPoint = v2
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.ZIndex = ZIndex2
        ImageLabel.ImageColor3 = v7
        ImageLabel.Parent = CanvasGroup

        local v27 = p27.ZIndex + 1
        local CanvasGroup2 = Instance.new("CanvasGroup")

        CanvasGroup2.Name = "IconClipFrame"
        CanvasGroup2.Size = v4
        CanvasGroup2.Position = v1
        CanvasGroup2.AnchorPoint = v2
        CanvasGroup2.BackgroundTransparency = 1
        CanvasGroup2.ClipsDescendants = true
        CanvasGroup2.ZIndex = v27
        CanvasGroup2.Parent = Frame

        local v28 = p27.ZIndex + 1
        local ImageLabel2 = Instance.new("ImageLabel")

        ImageLabel2.Name = "IconImage"
        ImageLabel2.Image = Icon
        ImageLabel2.Size = UDim2.fromScale(1, 1)
        ImageLabel2.Position = v1 + v6
        ImageLabel2.AnchorPoint = v2
        ImageLabel2.BackgroundTransparency = 1
        ImageLabel2.ScaleType = Enum.ScaleType.Fit
        ImageLabel2.ZIndex = v28
        ImageLabel2.Parent = CanvasGroup2

        if v26.RainbowOverlay ~= nil then
            t1.OverlayRainbow(ImageLabel2, v26.RainbowOverlay)
        end
    end
end

function t1.WireHoverSquash(p29, p30, p31) -- line: 254
    -- upvalues: TweenService (copy), Trove (copy), v8 (copy), v9 (copy), v10 (copy), v14 (copy), v15 (copy)
    v14(p29)
    v10(p30)
    v15(p31)

    local Size = p30.Size
    local v29 = Trove.new()
    local tween

    local function drop() -- line: 267
        -- upvalues: tween (ref)
        local tween2 = tween

        if tween2 then
            tween2:Cancel()
            tween2:Destroy()
            tween = nil
        end
    end

    local function applyScaleType(p32) -- line: 276
        -- upvalues: p30 (copy)
        p30.ScaleType = p32

        for _, descendant in p30:GetDescendants() do
            if descendant:IsA("ImageLabel") then
                descendant.ScaleType = p32
            end
        end
    end

    local function snapTo(p33) -- line: 285
        -- upvalues: p30 (copy), Size (copy), tween (ref), applyScaleType (copy)
        local tween2 = tween

        if tween2 then
            tween2:Cancel()
            tween2:Destroy()
            tween = nil
        end

        if not p30 then
            return
        end

        p33 = p33 or Size

        if p33 then
            p30.Size = p33
        end

        applyScaleType(Enum.ScaleType.Fit)
    end

    local function relax(p34) -- line: 298
        -- upvalues: p30 (copy), Size (copy), tween (ref), applyScaleType (copy), TweenService (copy), v9 (copy)
        if not (p30 and Size) then
            local tween2 = tween

            if tween2 then
                tween2:Cancel()
                tween2:Destroy()
                tween = nil
            end

            if p30 then
                if Size then
                    p30.Size = Size
                end

                applyScaleType(Enum.ScaleType.Fit)
            end
        elseif p34 == false then
            local tween2 = tween

            if tween2 then
                tween2:Cancel()
                tween2:Destroy()
                tween = nil
            end

            if p30 then
                local v31 = Size or Size

                if v31 then
                    p30.Size = v31
                end

                applyScaleType(Enum.ScaleType.Fit)
            end
        else
            local tween2 = tween

            if tween2 then
                tween2:Cancel()
                tween2:Destroy()
                tween = nil
            end

            local tween3 = TweenService:Create(p30, v9, {
                Size = Size
            })

            tween = tween3
            tween3.Completed:Once(function(p35) -- line: 312
                -- upvalues: tween (ref), applyScaleType (copy)
                if p35 ~= Enum.PlaybackState.Cancelled then
                    applyScaleType(Enum.ScaleType.Fit)
                    tween = nil
                end
            end)
            tween3:Play()
        end
    end

    local function squash() -- line: 322
        -- upvalues: p30 (copy), p31 (copy), Size (copy), tween (ref), applyScaleType (copy), TweenService (copy), v8 (copy)
        if not p30 or p31 and not p31() then
            return
        end

        local tween2 = tween

        if tween2 then
            tween2:Cancel()
            tween2:Destroy()
            tween = nil
        end

        applyScaleType(Enum.ScaleType.Stretch)

        local tween3 = TweenService:Create(p30, v8, {
            Size = UDim2.new(Size.X.Scale * 1.2, Size.X.Offset * 1.2, Size.Y.Scale * 0.43, Size.Y.Offset * 0.43)
        })

        tween = tween3
        tween3:Play()
    end

    v29:Add(drop)
    v29:Connect(p29.MouseEnter, squash)
    v29:Connect(p29.MouseLeave, relax)
    v29:Connect(p29.InputEnded, function(p36) -- line: 340
        -- upvalues: relax (copy)
        if p36.UserInputType == Enum.UserInputType.MouseButton1 or p36.UserInputType == Enum.UserInputType.Touch then
            relax()
        end
    end)

    return v29, relax
end

return t1
