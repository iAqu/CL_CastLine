-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Products = require(ReplicatedStorage.Shared.Products)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Robux = require(script.Parent.Parent.Shop.Robux)
local Style = require(script.Parent.Parent.Shop.Style)
local GlitchText = require(script.Parent.GlitchText)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Vector2.new(560, 320)
local v2 = Color3.new(1, 1, 1)
local v3 = Color3.fromRGB(255, 60, 60)
local v4 = Color3.fromRGB(70, 235, 80)
local Folder, Folder2
local t2 = {}
local v5 = false

local function v6() -- line: 50
    return false
end

local t3 = {}

local function setVisible(p1, p2) -- line: 56
    -- upvalues: t3 (copy)
    local function apply(p3) -- line: 57
        -- upvalues: p2 (copy), t3 (copy)
        if p3:IsA("BasePart") then
            p3.LocalTransparencyModifier = p2 and 0 or 1
        else
            if not p3:IsA("ParticleEmitter") and not p3:IsA("Light") and not p3:IsA("Trail") and not p3:IsA("BillboardGui") and not p3:IsA("SurfaceGui") then
                return
            end

            if p2 or not p3.Enabled then
                if p2 and t3[p3] then
                    p3.Enabled = true
                    t3[p3] = nil
                end
            else
                p3.Enabled = false
                t3[p3] = true
            end
        end
    end

    apply(p1)

    for _, descendant in p1:GetDescendants() do
        apply(descendant)
    end
end

local function standFolders() -- line: 77
    -- upvalues: Config (copy)
    local t4 = {}
    local t5 = {
        workspace
    }
    local v7 = Config.worldFolder(2)

    if v7 then
        table.insert(t5, v7)
    end

    for _, v8 in t5 do
        for _, child in v8:GetChildren() do
            if child.Name == "RobuxStands" then
                table.insert(t4, child)
            end
        end
    end

    return t4
end

local n1 = 0

local function setHidden(p4) -- line: 95
    -- upvalues: Folder (ref), Folder2 (ref), v5 (ref), setVisible (copy), standFolders (copy), n1 (ref)
    v5 = p4
    n1 = os.clock()

    local v9 = standFolders()

    table.insert(v9, Folder)
    table.insert(v9, Folder2)

    local EventBoard = workspace:FindFirstChild("EventBoard")

    if EventBoard then
        table.insert(v9, EventBoard)
    end

    for _, v10 in v9 do
        setVisible(v10, not p4)
    end
end

local function part(p5) -- line: 110
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Material = Enum.Material.SmoothPlastic
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth

    for v11, v12 in p5 do
        Part[v11] = v12
    end

    return Part
end

local function faces(p6, p7) -- line: 125
    -- upvalues: Kit (copy), v1 (copy), Folder2 (ref)
    local t6 = {}

    for _, v13 in {
            Enum.NormalId.Front,
            Enum.NormalId.Back
        } do
        local SurfaceGui = Instance.new("SurfaceGui")

        SurfaceGui.Name = p6.Parent.Name .. v13.Name
        SurfaceGui.Adornee = p6
        SurfaceGui.Face = v13
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        SurfaceGui.PixelsPerStud = v1.X / p7
        SurfaceGui.LightInfluence = 0
        SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        SurfaceGui.ResetOnSpawn = false
        SurfaceGui.MaxDistance = 160

        local v14 = Kit.frame(SurfaceGui, {
            Name = "Pages",
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(v1.X, v1.Y)
        })

        SurfaceGui.Parent = Folder2
        table.insert(t6, v14)
    end

    return t6
end

local t7 = {
    {
        key = "CashX2",
        title = "2x Cash",
        line = "Double cash forever!",
        color = Style.KELP,
        image = Config.Icons.Cash
    },
    {
        key = "StrengthX2",
        title = "2x Training",
        line = "Double strength per rep!",
        color = Style.CORAL,
        image = Config.Icons.Strength
    },
    {
        key = "VIP",
        title = "V.I.P",
        emoji = "👑",
        line = "+20% Cash, Luck & Strength",
        color = Style.GOLD
    },
    {
        key = "LuckX2",
        title = "2x Luck",
        line = "Rarer animals forever!",
        color = Style.SEAFOAM,
        image = Config.Icons.Luck
    }
}

local function owned(p8) -- line: 153
    -- upvalues: Products (copy), Robux (copy)
    return Products.isPass(p8) and Robux.owns(p8)
end

local function unavailable(p9) -- line: 158
    -- upvalues: Products (copy), Robux (copy)
    return Products.isPass(p9) and Robux.owns(p9) or Robux.soldOut(p9)
end

local function stage(p10, p11) -- line: 165
    -- upvalues: RunService (copy), Animals (copy), AnimalModel (copy), v2 (copy), Folder (ref), v5 (ref), setVisible (copy)
    local t8 = {
        Name = "Stage",
        CanCollide = false,
        Size = Vector3.new(0.4, 4.6, 4.6),
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Transparency = p11 and 1 or 0,
        CFrame = CFrame.new(p10 + Vector3.new(0, 0.2, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
        Parent = Folder
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Material = Enum.Material.SmoothPlastic
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth

    for v15, v16 in t8 do
        Part[v15] = v16
    end

    local PointLight = Instance.new("PointLight")

    PointLight.Range = 14
    PointLight.Brightness = 2
    PointLight.Parent = Part

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Size = NumberSequence.new(0.45, 0)
    ParticleEmitter.Lifetime = NumberRange.new(1, 2)
    ParticleEmitter.Speed = NumberRange.new(2, 4)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Right
    ParticleEmitter.Rate = 10
    ParticleEmitter.Parent = Part

    local v17, v18, v19, v20
    local elapsed = os.clock()

    RunService.Heartbeat:Connect(function() -- line: 183
        -- upvalues: p10 (copy), v17 (ref), v18 (ref), v19 (ref), v20 (ref), elapsed (copy), AnimalModel (copy)
        if v17 and v17.Parent then
            local v21 = os.clock() - elapsed
            local v22 = if v20 then -v18.bottom else v19 * 0.5 + 0.6 + math.sin(v21 * 1.6) * 0.35
            local v25 = CFrame.new(p10.X, p10.Y + 0.4 + v22, p10.Z) * CFrame.Angles(0, v21 * 0.7, 0)

            AnimalModel.pose(v18, v25, v21, 0.35, v20)
        end
    end)

    return function(p12, p13, p14) -- line: 193
        -- upvalues: p11 (copy), Part (copy), PointLight (copy), ParticleEmitter (copy), v17 (ref), v18 (ref), v19 (ref), v20 (ref), Animals (copy), AnimalModel (copy), v2 (copy), Folder (ref), v5 (ref), setVisible (copy)
        Part.Color = p14
        PointLight.Color = p14
        ParticleEmitter.Color = ColorSequence.new(v2, p14)
        ParticleEmitter:Emit(25)

        if v17 then
            v17:Destroy()
        end

        v17 = AnimalModel.clone(p12, p13)

        if not v17 then
            return
        end

        if v5 then
            setVisible(v17, false)
        end

        v18 = AnimalModel.rig(v17)
        v19 = p13

        local v26 = Animals.get(p12)
        local v27 = not p11 and v26 ~= nil and v26.Walks

        v20 = v27
        v17.Parent = Folder
    end
end

local function button(p15) -- line: 218
    -- upvalues: t2 (copy)
    local Button = p15:FindFirstChild("Button")

    if Button and Button:IsA("BasePart") then
        local ButtonRim = p15:FindFirstChild("ButtonRim")
        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        ParticleEmitter.LightEmission = 1
        ParticleEmitter.Size = NumberSequence.new(0.8, 0)
        ParticleEmitter.Lifetime = NumberRange.new(0.4, 0.8)
        ParticleEmitter.Speed = NumberRange.new(8, 14)
        ParticleEmitter.SpreadAngle = Vector2.new(60, 60)
        ParticleEmitter.EmissionDirection = Enum.NormalId.Top
        ParticleEmitter.Rate = 0
        ParticleEmitter.Parent = Button

        local t9 = {
            inside = false,
            key = nil,
            top = Button
        }

        if not ButtonRim or not ButtonRim:IsA("BasePart") then
            ButtonRim = nil
        end

        t9.rim = ButtonRim
        t9.rest = Button.CFrame
        t9.burst = ParticleEmitter
        table.insert(t2, t9)

        return t9
    end

    warn((("RobuxStands.%* has no Button part"):format(p15.Name)))

    return nil
end

local function paint(p16, p17, p18, p19) -- line: 240
    -- upvalues: UIUtil (copy), Style (copy), v2 (copy)
    local v28 = if p18 then Style.GREY else p17

    UIUtil.tween(p16.top, 0.3, {
        Color = v28
    })

    if p16.rim then
        UIUtil.tween(p16.rim, 0.3, {
            Color = v28
        })

        local rim = p16.rim

        if p18 then
            rim.Material = Enum.Material.SmoothPlastic
        else
            rim.Material = Enum.Material.Neon
        end
    end

    if p19 then
        p16.burst.Color = ColorSequence.new(v2, p17)
        p16.burst:Emit(18)
    end
end

local function signAnchor(p20, p21) -- line: 254
    -- upvalues: Folder (ref)
    local Sign = p20:FindFirstChild("Sign")

    if Sign and Sign:IsA("BasePart") then
        return Sign
    end

    local t10 = {
        Name = "SignAnchor",
        Transparency = 1,
        CanCollide = false,
        Size = Vector3.new(0.2, 0.2, 0.2),
        CFrame = p21.rest + Vector3.new(0, 7, 0),
        Parent = Folder
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Material = Enum.Material.SmoothPlastic
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth

    for v29, v30 in t10 do
        Part[v29] = v30
    end

    return Part
end

local function textWidth(p22) -- line: 264
    -- upvalues: TextService (copy)
    return TextService:GetTextSize(p22, 100, Enum.Font.MontserratBold, Vector2.new(1E+05, 1E+05)).X / 100 * 1.06
end

local function sign(p23, p24, p25) -- line: 274
    -- upvalues: RunService (copy), TextService (copy), Products (copy), UIUtil (copy), Kit (copy), Robux (copy), Style (copy), GlitchText (copy), v2 (copy), v3 (copy), v4 (copy), Folder2 (ref)
    local v31 = if p24 then 4.6 else 0
    local v32 = v31 + 1.05 + 1.7 + 1.05 + 1.3
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "Sign"
    BillboardGui.Adornee = p23
    BillboardGui.Size = UDim2.fromScale(11 * (p25.scale or 1), v32 * (p25.scale or 1))
    BillboardGui.StudsOffset = Vector3.new(0, 0.6 * (p25.scale or 1), 0)
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 140
    BillboardGui.Parent = Folder2

    local v34 = Kit.frame(BillboardGui, {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })
    local ImageLabel, v35, v36, v37

    if p24 then
        local v38 = Kit.frame(v34, {
            Name = "Icon",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(1, v31 / v32)
        })

        Instance.new("UIAspectRatioConstraint").Parent = v38

        local ImageLabel2 = Instance.new("ImageLabel")

        ImageLabel = ImageLabel2
        ImageLabel2.Name = "Shine"
        ImageLabel2.BackgroundTransparency = 1
        ImageLabel2.Image = "rbxassetid://86205314584043"
        ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel2.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel2.Size = UDim2.fromScale(1.35, 1.35)
        ImageLabel2.Parent = v38

        local v39 = Kit.frame(v38, {
            Name = "Disc",
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.78, 0.78)
        })

        v35 = v39

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = v39
        Kit.stroke(v39, 3)
        Kit.shade(v39, 0.6)

        local v40 = Style.icon(v39, "")

        v36 = v40
        v40.Size = UDim2.fromScale(0.78, 0.78)
        v37 = Kit.text(v39, "", {
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.7, 0.7)
        })

        local elapsed = os.clock()

        RunService.RenderStepped:Connect(function() -- line: 310
            -- upvalues: BillboardGui (copy), ImageLabel (ref), elapsed (copy)
            if BillboardGui.Enabled then
                local v41 = os.clock() - elapsed

                ImageLabel.Rotation = v41 * 30 % 360
                BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, math.sin(v41 * 2) * 0.25, 0)
            end
        end)
    end

    local v44 = v31 / v32
    local v45 = Style.text(v34, "", {
        Name = "Tag",
        StrokeThickness = 2.5,
        Position = UDim2.fromScale(0, v44),
        Size = UDim2.fromScale(1, 1.05 / v32),
        TextColor3 = v3
    })
    local v46 = v44 + 1.05 / v32
    local v47

    if p25.glitch then
        v47 = GlitchText.new(v34, {
            StrokeThickness = 3,
            Position = UDim2.fromScale(0, v46),
            Size = UDim2.fromScale(1, 1.7 / v32)
        })
    else
        local v48 = Style.text(v34, "", {
            Name = "Title",
            StrokeThickness = 3,
            Position = UDim2.fromScale(0, v46),
            Size = UDim2.fromScale(1, 1.7 / v32)
        })

        Style.gradient(v48, ColorSequence.new(Style.YELLOW, Color3.fromRGB(255, 150, 40)))

        v47 = function(p26) -- line: 327
            -- upvalues: v48 (copy)
            v48.Text = p26
        end
    end

    local v49 = v46 + 1.7 / v32
    local v50 = Style.text(v34, "", {
        Name = "Line",
        StrokeThickness = 2.5,
        Position = UDim2.fromScale(0, v49),
        Size = UDim2.fromScale(1, 1.05 / v32),
        TextColor3 = Style.YELLOW
    })
    local v51 = v49 + 1.05 / v32
    local v52 = Kit.frame(v34, {
        Name = "Price",
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, v51),
        Size = UDim2.fromScale(1, 1.3 / v32)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0.01, 0)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v52

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Image = Style.ROBUX
    ImageLabel2.ImageColor3 = v4
    ImageLabel2.Size = UDim2.fromScale(0.8, 0.8)
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel2.Parent = v52

    local v53 = Kit.text(v52, "", {
        LayoutOrder = 1,
        StrokeThickness = 3,
        Size = UDim2.fromScale(1, 1)
    })
    local v54 = Style.gradient(v53, ColorSequence.new(Style.MINT, v4))

    return function(p27, p28) -- line: 353
        -- upvalues: p24 (copy), v34 (copy), ImageLabel (ref), v35 (ref), v36 (ref), v37 (ref), v45 (copy), v47 (ref), v50 (copy), ImageLabel2 (copy), v53 (copy), v54 (copy), TextService (copy), Products (copy), UIUtil (copy), Robux (copy), Style (copy), v2 (copy), v3 (copy)
        local key = p27.key
        local v55 = Products.isPass(key) and Robux.owns(key)
        local v56 = Robux.soldOut(p27.key)

        if p24 then
            ImageLabel.ImageColor3 = v2

            local v57 = v35

            v57.BackgroundColor3 = p27.color

            local v58 = v36

            v58.Image = p27.image or ""
            v58.Visible = p27.image ~= nil

            local v59 = v37

            v59.Text = p27.emoji or ""
            v59.Visible = p27.image == nil
        end

        local v60, v61 = p27.tag(v55, v56)

        v45.Text = ("[%*]"):format(v60)
        v45.TextColor3 = v61 or v3
        v47(p27.title)
        v50.Text = if type(p27.line) == "function" then p27.line() else p27.line or ""
        ImageLabel2.Visible = not v55 and not v56
        v53.Text = if v55 then "OWNED" elseif v56 then "SOLD OUT" else ("%* ONLY!"):format((Robux.price(p27.key)))
        v54.Enabled = not v55 and not v56
        v53.TextColor3 = if v55 then Style.GREY elseif v56 then v3 else v2
        v53.Size = UDim2.fromScale(math.min(TextService:GetTextSize(v53.Text, 100, Enum.Font.MontserratBold, Vector2.new(1E+05, 1E+05)).X / 100 * 1.06 * 1.3 / 11, 0.95 - (if ImageLabel2.Visible then 0.12 else 0)), 1)

        if p28 then
            UIUtil.pop(v34, 0.8)
        end
    end
end

local function header(p29) -- line: 383
    -- upvalues: Kit (copy), Style (copy), v2 (copy), Folder2 (ref)
    local Header = p29:FindFirstChild("Header")

    if Header and Header:IsA("BasePart") then
        local BillboardGui = Instance.new("BillboardGui")

        BillboardGui.Name = "Header"
        BillboardGui.Adornee = Header
        BillboardGui.Size = UDim2.fromScale(26, 3.6)
        BillboardGui.LightInfluence = 0
        BillboardGui.MaxDistance = 180
        BillboardGui.Parent = Folder2

        local v67 = Kit.text(BillboardGui, Header:GetAttribute("HeaderText") or p29.Name, {
            StrokeThickness = 3,
            Size = UDim2.fromScale(1, 1)
        })

        Style.gradient(v67, ColorSequence.new(v2, Header.Color))
    end
end

local function cycle(p30, p31, p32) -- line: 401
    -- upvalues: Products (copy), Robux (copy)
    task.spawn(function() -- line: 402
        -- upvalues: p30 (copy), p31 (copy), p32 (copy), Products (copy), Robux (copy)
        local n2 = 0
        local v68

        while true do
            local v69 = true

            for _, v70 in p31 do
                if v69 then
                    local key = v70.key

                    v69 = Products.isPass(key) and Robux.owns(key)
                end
            end

            while true do
                n2 = n2 % #p31 + 1

                if not v69 then
                    local key = p31[n2].key

                    if Products.isPass(key) and Robux.owns(key) then
                        continue
                    end
                end

                break
            end

            if p31[n2] ~= v68 then
                v68 = p31[n2]
                p32(v68, true)
            end

            local n3 = 0

            while true do
                n3 += task.wait(0.25)

                if n3 >= 4 then
                    if p30.inside then
                        continue
                    end

                    break
                end
            end
        end
    end)
end

local function standFor(p33, p34, p35, p36) -- line: 426
    -- upvalues: Products (copy), Robux (copy), stage (copy), button (copy), paint (copy), signAnchor (copy), sign (copy), header (copy)
    local v71 = button(p33)

    if not v71 then
        return function() -- line: 429
        end
    end

    header(p33)

    local v72 = sign(signAnchor(p33, v71), p35 == nil, p36 or {})
    local PedestalTop = p33:FindFirstChild("PedestalTop")
    local AnimalSpot = p33:FindFirstChild("AnimalSpot")
    local v73

    if p35 and PedestalTop and PedestalTop:IsA("BasePart") then
        v73 = stage(PedestalTop.Position + Vector3.new(0, PedestalTop.Size.Y / 2, 0))
    elseif p35 and AnimalSpot and AnimalSpot:IsA("BasePart") then
        v73 = stage(AnimalSpot.Position, true)
    elseif p35 then
        warn((("%* has no AnimalSpot part, so its animal isn't shown"):format((p33:GetFullName()))))
    end

    local v75

    local function show(p37, p38) -- line: 444
        -- upvalues: p35 (copy), v71 (copy), v72 (copy), v73 (ref), v75 (ref), Products (copy), Robux (copy), paint (copy)
        v75 = p37
        v71.key = p37.key

        local color, key = p37.color, p37.key

        paint(v71, color, Products.isPass(key) and Robux.owns(key) or Robux.soldOut(key), p38)
        v72(p37, p38)

        if p38 and v73 then
            v73(p37.id, p35, p37.color)
        end
    end

    local function refresh() -- line: 453
        -- upvalues: v71 (copy), v72 (copy), v75 (ref), Products (copy), Robux (copy), paint (copy)
        if not v75 then
            return
        end

        local v76 = v75

        v75 = v76
        v71.key = v76.key

        local color, key = v76.color, v76.key

        paint(v71, color, Products.isPass(key) and Robux.owns(key) or Robux.soldOut(key), false)
        v72(v76, false)
    end

    Robux.onPrices(refresh)
    task.spawn(function() -- line: 402
        -- upvalues: p34 (copy), v71 (copy), show (copy), Products (copy), Robux (copy)
        local n4 = 0
        local v78

        while true do
            local v79 = true

            for _, v80 in p34 do
                if v79 then
                    local key = v80.key

                    v79 = Products.isPass(key) and Robux.owns(key)
                end
            end

            while true do
                n4 = n4 % #p34 + 1

                if not v79 then
                    local key = p34[n4].key

                    if Products.isPass(key) and Robux.owns(key) then
                        continue
                    end
                end

                break
            end

            if p34[n4] ~= v78 then
                v78 = p34[n4]
                show(v78, true)
            end

            local n5 = 0

            while true do
                n5 += task.wait(0.25)

                if n5 >= 4 then
                    if v71.inside then
                        continue
                    end

                    break
                end
            end
        end
    end)

    return refresh
end

local function passStand(p39) -- line: 463
    -- upvalues: Products (copy), Robux (copy), Style (copy), LocalPlayer (copy), v2 (copy), t7 (copy), standFor (copy)
    local t11 = {}

    for _, v81 in t7 do
        table.insert(t11, {
            key = v81.key,
            color = v81.color,
            title = v81.title,
            image = v81.image,
            emoji = v81.emoji,
            line = function() -- line | line: 472
                -- upvalues: v81 (copy), Products (copy), Robux (copy)
                local key = v81.key

                if Products.isPass(key) and Robux.owns(key) then
                    return "You own this!"
                end

                return v81.line
            end,
            tag = function(p40) -- tag | line: 476
                -- upvalues: v81 (copy), Products (copy), Robux (copy), Style (copy), v2 (copy)
                local v82 = not p40 and Products.saleOff(v81.key, Robux.price(v81.key))

                if v82 then
                    return (("%*%% OFF!"):format(v82))
                end

                if p40 then
                    return "OWNED", Style.GREY
                end

                return "GAMEPASS", (v81.color:Lerp(v2, 0.35))
            end
        })
    end

    local v83 = standFor(p39, t11)

    for _, v84 in t7 do
        LocalPlayer:GetAttributeChangedSignal("Pass_" .. v84.key):Connect(v83)
    end
end

local function stockTag(p41) -- line: 492
    -- upvalues: Robux (copy)
    local v85 = Robux.left(p41)

    if not v85 then
        return "EXCLUSIVE"
    end

    if v85 <= 0 then
        return "SOLD OUT"
    end

    return (("LIMITED · %* LEFT"):format(v85))
end

local function earnsLine(p42) -- line: 501
    -- upvalues: Animals (copy), Format (copy), LocalPlayer (copy)
    return (("Earns %*/s!"):format((Format.money(Animals.income({
        Id = p42
    }, LocalPlayer:GetAttribute("MegaBase") or 0)))))
end

local function watchStock(p43, p44) -- line: 505
    for _, v86 in p43 do
        workspace:GetAttributeChangedSignal("Left_" .. v86):Connect(p44)
    end
end

local function mermaidStand(p45) -- line: 513
    -- upvalues: Products (copy), Robux (copy), LocalPlayer (copy), standFor (copy), earnsLine (copy), watchStock (copy)
    local Mermaid = Products.Mermaid
    local v88 = standFor(p45, {
        {
            title = "The Mermaid",
            key = Mermaid.Key,
            id = Mermaid.Id,
            color = Color3.fromRGB(255, 110, 200),
            line = function() -- line | line: 521
                -- upvalues: Mermaid (copy), earnsLine (copy)
                return (earnsLine(Mermaid.Id))
            end,
            tag = function() -- tag | line: 524
                -- upvalues: Mermaid (copy), Robux (copy)
                local Key = Mermaid.Key
                local v87 = Robux.left(Key)

                if not v87 then
                    return "EXCLUSIVE"
                end

                if v87 <= 0 then
                    return "SOLD OUT"
                end

                return (("LIMITED · %* LEFT"):format(v87))
            end
        }
    }, 15, {
        scale = 1.25
    })

    LocalPlayer:GetAttributeChangedSignal("MegaBase"):Connect(v88)
    watchStock({ Mermaid.Key }, v88)
end

local function krakenStand(p46) -- line: 534
    -- upvalues: Products (copy), Robux (copy), LocalPlayer (copy), standFor (copy), earnsLine (copy), watchStock (copy)
    local Kraken = Products.Kraken
    local v90 = standFor(p46, {
        {
            title = "The Kraken",
            key = Kraken.Key,
            id = Kraken.Id,
            color = Color3.fromRGB(200, 40, 60),
            line = function() -- line | line: 542
                -- upvalues: Kraken (copy), earnsLine (copy)
                return (earnsLine(Kraken.Id))
            end,
            tag = function() -- tag | line: 545
                -- upvalues: Kraken (copy), Robux (copy)
                local Key = Kraken.Key
                local v89 = Robux.left(Key)

                if not v89 then
                    return "EXCLUSIVE"
                end

                if v89 <= 0 then
                    return "SOLD OUT"
                end

                return (("LIMITED · %* LEFT"):format(v89))
            end
        }
    }, 16, {
        glitch = true,
        scale = 1.35
    })

    LocalPlayer:GetAttributeChangedSignal("MegaBase"):Connect(v90)
    watchStock({ Kraken.Key }, v90)
end

local function watchButtons() -- line: 555
    -- upvalues: RunService (copy), Products (copy), UIUtil (copy), Robux (copy), LocalPlayer (copy), t2 (copy), v5 (ref), v6 (ref), n1 (ref), setHidden (copy)
    RunService.Heartbeat:Connect(function() -- line: 556
        -- upvalues: Products (copy), UIUtil (copy), Robux (copy), LocalPlayer (copy), t2 (copy), v5 (ref), v6 (ref), n1 (ref), setHidden (copy)
        if v6() == v5 then
            if v5 and os.clock() - n1 > 1 then
                setHidden(true)
            end
        else
            setHidden(not v5)
        end

        local v91 = if v5 then nil else LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        for _, v92 in t2 do
            local v93 = false

            if v91 and v92.key and v92.top.Parent then
                local v94 = v92.rest:PointToObjectSpace(v91.Position)
                local v95 = v92.top.Size / 2

                if math.abs(v94.X) <= v95.X + 0.6 and math.abs(v94.Z) <= v95.Z + 0.6 and v94.Y > -2 then
                    v93 = v94.Y < 7
                end
            end

            if v93 then
                if v92.inside then
                    local _ = v92.inside
                else
                    UIUtil.tween(v92.top, 0.12, {
                        CFrame = v92.rest - Vector3.new(0, 0.3, 0)
                    })

                    local key = v92.key

                    if Products.isPass(key) and Robux.owns(key) then
                        UIUtil.toast("You already own this!", "info")
                    else
                        UIUtil.sound("Click", 0.6)
                        Robux.buy(v92.key)
                    end
                end
            elseif v92.inside then
                UIUtil.tween(v92.top, 0.2, {
                    CFrame = v92.rest
                }, Enum.EasingStyle.Back)
            end

            v92.inside = v93
        end
    end)
end

local t16 = {
    Gamepasses = passStand,
    Mermaid = mermaidStand,
    Kraken = krakenStand
}

function t1.init() -- line: 588
    -- upvalues: RunService (copy), Products (copy), UIUtil (copy), Robux (copy), LocalPlayer (copy), Folder (ref), Folder2 (ref), t2 (copy), v5 (ref), v6 (ref), standFolders (copy), n1 (ref), setHidden (copy), t16 (copy)
    Folder = Instance.new("Folder")
    Folder.Name = "Showcases"
    Folder.Parent = workspace
    Folder2 = Instance.new("Folder")
    Folder2.Name = "Showcases"
    Folder2.Parent = LocalPlayer:WaitForChild("PlayerGui")
    task.spawn(function() -- line: 595
        -- upvalues: standFolders (copy), t16 (copy)
        if not workspace:WaitForChild("RobuxStands", 15) then
            warn("workspace.RobuxStands is missing, so there are no Robux stands")

            return
        end

        local v96 = workspace:WaitForChild("Map"):WaitForChild("World2", 15)

        if v96 then
            v96:WaitForChild("RobuxStands", 5)
        end

        for _, v97 in standFolders() do
            for v98, v99 in t16 do
                local v100 = v97:WaitForChild(v98, 5)

                if v100 then
                    task.spawn(v99, v100)
                else
                    warn((("%*.%* is missing"):format(v97:GetFullName(), v98)))
                end
            end
        end
    end)
    RunService.Heartbeat:Connect(function() -- line: 556
        -- upvalues: Products (copy), UIUtil (copy), Robux (copy), LocalPlayer (copy), t2 (copy), v5 (ref), v6 (ref), n1 (ref), setHidden (copy)
        if v6() == v5 then
            if v5 and os.clock() - n1 > 1 then
                setHidden(true)
            end
        else
            setHidden(not v5)
        end

        local v101 = if v5 then nil else LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        for _, v102 in t2 do
            local v103 = false

            if v101 and v102.key and v102.top.Parent then
                local v104 = v102.rest:PointToObjectSpace(v101.Position)
                local v105 = v102.top.Size / 2

                if math.abs(v104.X) <= v105.X + 0.6 and math.abs(v104.Z) <= v105.Z + 0.6 and v104.Y > -2 then
                    v103 = v104.Y < 7
                end
            end

            if v103 then
                if v102.inside then
                    local _ = v102.inside
                else
                    UIUtil.tween(v102.top, 0.12, {
                        CFrame = v102.rest - Vector3.new(0, 0.3, 0)
                    })

                    local key = v102.key

                    if Products.isPass(key) and Robux.owns(key) then
                        UIUtil.toast("You already own this!", "info")
                    else
                        UIUtil.sound("Click", 0.6)
                        Robux.buy(v102.key)
                    end
                end
            elseif v102.inside then
                UIUtil.tween(v102.top, 0.2, {
                    CFrame = v102.rest
                }, Enum.EasingStyle.Back)
            end

            v102.inside = v103
        end
    end)
end

function t1.setHiddenCheck(p47) -- line: 620
    -- upvalues: v6 (ref)
    v6 = p47
end

function t1.board(p48) -- line: 626
    -- upvalues: faces (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Size = NumberSequence.new(0.7, 0)
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
    ParticleEmitter.Speed = NumberRange.new(6, 12)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 3
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = p48

    return ParticleEmitter, (faces(p48, p48.Size.X))
end

return t1
