-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

game:GetService("StarterGui")

local Workspace = game:GetService("Workspace")
local GUI = require(ReplicatedStorage.Client.GUI)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local SammyEvent = require(ReplicatedStorage.Data.SammyEvent)

require(ReplicatedStorage.Packages.Trove)

local t1 = {
    0.04, 0.05, 0.035
}
local t2 = {
    0.06, 0.04, 0.05, 0.05, 0.035, 0.07, 0.09
}
local v1 = Color3.fromRGB(0, 170, 255)
local v2 = Color3.fromRGB(200, 250, 255)
local v3 = Color3.fromRGB(70, 210, 255)
local v4 = Random.new()
local t3
local v5 = false
local v6 = false
local v7 = false
local n1 = 0
local n2 = 0
local n3 = 0
local v8 = true
local n4 = -1
local v9 = ""
local v10 = ""
local v11 = ""
local n5 = 0
local n6 = 0
local n7 = 0
local n8 = 0
local n9 = -1
local v12
local n10 = 0
local n11 = 0
local v13 = false
local n12 = -1
local n13 = 0
local n14 = 0
local n15 = -1
local n16 = -1
local n17 = -1
local v14
local v15 = false
local n18 = 0
local n19 = 1
local n20 = -1

local function makeSheet(p1) -- line: 170
    local Cells = p1:GetAttribute("Cells")
    local FPS = p1:GetAttribute("FPS")

    assert(typeof(Cells) == "Vector2" and type(FPS) == "number", (("%* needs Cells and FPS attributes"):format((p1:GetFullName()))))

    local StartAt = p1:GetAttribute("StartAt")

    p1.Visible = false
    p1.ImageRectOffset = Vector2.zero

    return {
        Offsets = nil,
        Frame = 1,
        Acc = 0,
        On = false,
        Image = p1,
        Cells = Cells,
        Frames = math.max(1, Cells.X * Cells.Y),
        FrameTime = 1 / FPS,
        StartAt = if type(StartAt) ~= "number" then 30 else StartAt
    }
end

local function resolveUi() -- line: 190
    -- upvalues: GUI (copy), v1 (copy), v2 (copy), v3 (copy), t3 (ref), makeSheet (copy)
    local t5 = t3

    if t5 then
        return t5
    end

    local v19 = GUI.SammyEventUI()
    local EMPChargeBar = v19.EMPChargeBar
    local BarHolder = EMPChargeBar.BarHolder
    local Icon = BarHolder.Icon
    local GlowImage = Icon.GlowImage
    local BarBG = BarHolder.BarBG
    local Bar = BarBG.Bar
    local t6 = {}

    for _, v20 in EMPChargeBar:QueryDescendants("ImageLabel[$Cells][$FPS]") do
        if v20:IsA("ImageLabel") and v20 ~= Bar.BarCharge and v20 ~= Icon.ChargeLine then
            table.insert(t6, (makeSheet(v20)))
        end
    end

    local v22 = makeSheet(Bar.BarCharge)
    local v23 = makeSheet(Icon.ChargeLine)
    local v24 = table.clone(t6)

    table.insert(v24, v22)
    table.insert(v24, v23)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = -90
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v1),
        ColorSequenceKeypoint.new(0.44, v1),
        ColorSequenceKeypoint.new(0.49, v2),
        ColorSequenceKeypoint.new(1, v2)
    })
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.72),
        NumberSequenceKeypoint.new(0.44, 0.72),
        NumberSequenceKeypoint.new(0.485, 0.2),
        NumberSequenceKeypoint.new(0.52, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = GlowImage
    GlowImage.ImageColor3 = Color3.new(1, 1, 1)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "EnergyHalo"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = GlowImage.Image
    ImageLabel.ScaleType = GlowImage.ScaleType
    ImageLabel.ImageColor3 = v3
    ImageLabel.ImageTransparency = 1
    ImageLabel.AnchorPoint = Icon.AnchorPoint
    ImageLabel.Position = Icon.Position
    ImageLabel.Size = UDim2.new(Icon.Size.X.Scale * 1.16, Icon.Size.X.Offset * 1.16, Icon.Size.Y.Scale * 1.16, Icon.Size.Y.Offset * 1.16)
    ImageLabel.ZIndex = Icon.ZIndex - 1
    ImageLabel.Visible = false
    ImageLabel.Parent = BarHolder

    local t7 = {
        Gui = v19,
        Holder = BarHolder,
        Icon = Icon,
        Glow = GlowImage,
        Halo = ImageLabel,
        EnergyGradient = UIGradient,
        Percent = BarHolder.ProgressHolder,
        Title = EMPChargeBar.TitleHolder.BossName,
        TitleText = EMPChargeBar.TitleHolder.BossName.Text,
        Timer = EMPChargeBar.TimeLeftHolder.TimeLeft,
        BarBG = BarBG,
        Bar = Bar,
        Phantom = BarBG.PhantomBar,
        Decor = BarBG.Decor,
        BaseHolderRotation = BarHolder.Rotation,
        BaseIconPosition = Icon.Position,
        BaseIconRotation = Icon.Rotation,
        BarSizeY = Bar.Size.Y,
        PhantomSizeY = BarBG.PhantomBar.Size.Y,
        LineBaseX = Icon.ChargeLine.Position.X,
        FillSheet = v22,
        LineSheet = v23,
        LightningSheets = t6,
        AllSheets = v24
    }

    t3 = t7

    return t7
end

local function isRaiding() -- line: 287
    -- upvalues: Workspace (copy)
    local SammyWeaponRequired = Workspace:GetAttribute("SammyWeaponRequired")

    if type(SammyWeaponRequired) == "number" then
        return SammyWeaponRequired > 0
    end

    return false
end

local function isSavingBen() -- line: 293
    -- upvalues: Workspace (copy)
    return Workspace:GetAttribute("SammyPhase") == "SaveBen"
end

local function readCharge() -- line: 298
    -- upvalues: Workspace (copy), SammyEvent (copy)
    local SammyEmpCharge = Workspace:GetAttribute("SammyEmpCharge")

    if type(SammyEmpCharge) ~= "number" then
        return 0
    end

    return (math.clamp(SammyEmpCharge / SammyEvent.ChargeMax, 0, 1))
end

local function writeTitle(p2) -- line: 326
    -- upvalues: Workspace (copy), v10 (ref)
    local v26

    if Workspace:GetAttribute("SammyPhase") == "SaveBen" then
        v26 = "Save Ben from Mind Controlled Sammy!"
    else
        local SammyWeaponRequired = Workspace:GetAttribute("SammyWeaponRequired")

        v26 = if type(SammyWeaponRequired) == "number" and SammyWeaponRequired > 0 then "Bring Brainrots to the Laser Gun!" else p2.TitleText
    end

    if v26 ~= v10 then
        v10 = v26
        p2.Title.Text = v26
    end
end

local function setSheet(p3, p4) -- line: 343
    if p3.On == p4 then
        return
    end

    p3.On = p4
    p3.Image.Visible = p4

    if not p4 then
        return
    end

    local Offsets = p3.Offsets

    if Offsets == nil then
        Offsets = table.create(p3.Frames)

        local ImageRectSize = p3.Image.ImageRectSize

        for i = 0, p3.Frames - 1 do
            Offsets[i + 1] = Vector2.new(ImageRectSize.X * (i % p3.Cells.X), ImageRectSize.Y * (i // p3.Cells.X))
        end

        p3.Offsets = Offsets
    end

    p3.Frame = 1
    p3.Acc = 0
    p3.Image.ImageRectOffset = Offsets[1]
end

local function setDecorOff(p5, p6) -- line: 367
    -- upvalues: v13 (ref)
    if p6 ~= v13 then
        v13 = p6
        p5.Decor.Visible = not p6
    end
end

local function writeEnergy(p7, p8) -- line: 375
    -- upvalues: n3 (ref), n13 (ref), n14 (ref), n15 (ref), n16 (ref), n17 (ref), v15 (ref), setSheet (copy)
    local v27 = n3 * 0.9800000000000001 + 0.1
    local v28 = if not p8 then math.abs(v27 - n15) >= 0.002 else nil

    if p8 or v28 then
        n15 = v27
        p7.EnergyGradient.Offset = Vector2.new(0, 0.5 - v27)
        p7.LineSheet.Image.Position = UDim2.new(p7.LineBaseX.Scale, p7.LineBaseX.Offset, 1 - math.min(v27, 0.92), 0)
    end

    setSheet(p7.LineSheet, n3 > 0 and n3 < 1)

    local v31 = if v15 then math.sin(n14 * 1.6 * 3.141592653589793 * 2) * 0.06 else 0
    local v34 = math.clamp((1 - n13) * 0.15 + v31, 0, 1)
    local v35 = if not p8 then math.abs(v34 - n16) >= 0.01 else nil

    if p8 or v35 then
        n16 = v34
        p7.Glow.ImageTransparency = v34
    end

    local v37 = n3 * -0.52 + 0.92
    local v39 = n13
    local v40 = math.clamp(v37 - v39 * (v37 - 0.1) + v31, 0, 1)
    local v41 = if not p8 then math.abs(v40 - n17) >= 0.01 else nil

    if p8 or v41 then
        n17 = v40
        p7.Halo.ImageTransparency = v40
    end

    local v43 = n3 > 0

    if p8 or p7.Glow.Visible ~= v43 then
        p7.Glow.Visible = v43
        p7.Halo.Visible = v43
    end
end

local function buildTremble(p9, p10) -- line: 407
    -- upvalues: v4 (copy)
    local t8 = {}
    local t9 = {}

    for i = 1, 4 do
        local v44 = (i - 1) / 3
        local v45 = p10 * (v44 * 2.5 + 1) / 100
        local v46 = v44 * 4 + 2
        local t10 = {}
        local t11 = {}

        for j = 1, 12 do
            local v47 = j / 12 * 3.141592653589793 * 2 + v4:NextNumber(-0.4, 0.4)
            local v48 = v45 * v4:NextNumber(0.45, 1)

            t10[j] = p9.BaseIconPosition + UDim2.fromOffset(math.round(math.cos(v47) * v48), (math.round(math.sin(v47) * v48)))
            t11[j] = p9.BaseIconRotation + v46 * v4:NextNumber(-1, 1)
        end

        t8[i] = t10
        t9[i] = t11
    end

    return {
        Positions = t8,
        Rotations = t9,
        Width = p10
    }
end

local function setTremble(p11, p12) -- line: 429
    -- upvalues: v15 (ref), n18 (ref)
    if v15 == p12 then
        return
    end

    v15 = p12
    n18 = 0

    if not p12 then
        p11.Icon.Position = p11.BaseIconPosition
        p11.Icon.Rotation = p11.BaseIconRotation
    end
end

local function rest(p13) -- line: 442
    -- upvalues: n4 (ref), v9 (ref), v10 (ref), v11 (ref), n6 (ref), n7 (ref), n8 (ref), v12 (ref), v13 (ref), n13 (ref), n14 (ref), n15 (ref), n16 (ref), n17 (ref), v14 (ref), v15 (ref), n18 (ref), n20 (ref)
    n6 = 0
    n7 = 0
    n8 = 0
    p13.Holder.Rotation = p13.BaseHolderRotation
    v12 = nil

    if v13 ~= false then
        v13 = false
        p13.Decor.Visible = true
    end

    n13 = 0
    n14 = 0

    if v15 ~= false then
        v15 = false
        n18 = 0
        p13.Icon.Position = p13.BaseIconPosition
        p13.Icon.Rotation = p13.BaseIconRotation
    end

    for _, v52 in p13.AllSheets do
        if v52.On ~= false then
            v52.On = false
            v52.Image.Visible = false
        end

        v52.Offsets = nil
    end

    p13.Glow.Visible = false
    p13.Halo.Visible = false
    v14 = nil
    n20 = -1
    n15 = -1
    n16 = -1
    n17 = -1
    n4 = -1
    v9 = ""
    v10 = ""
    v11 = ""
end

local function flicker(p14, p15) -- line: 469
    -- upvalues: v12 (ref), n10 (ref), n11 (ref), v13 (ref)
    v12 = p15
    n10 = 1
    n11 = p15[1]

    if v13 ~= true then
        v13 = true
        p14.Decor.Visible = false
    end
end

local function stepBar(p16, p17) -- line: 543
    -- upvalues: Workspace (copy), SammyEvent (copy), t2 (copy), v4 (copy), n2 (ref), n3 (ref), v8 (ref), n4 (ref), v9 (ref), n5 (ref), n6 (ref), n7 (ref), n8 (ref), n9 (ref), v12 (ref), n10 (ref), n11 (ref), v13 (ref), n12 (ref), n13 (ref), n14 (ref), v14 (ref), v15 (ref), n18 (ref), n19 (ref), n20 (ref), setSheet (copy), writeEnergy (copy), buildTremble (copy)
    local SammyEmpCharge = Workspace:GetAttribute("SammyEmpCharge")
    local v53 = if type(SammyEmpCharge) == "number" then math.clamp(SammyEmpCharge / SammyEvent.ChargeMax, 0, 1) else 0

    if v53 ~= n2 then
        n2 = v53

        if v53 < 0.99 then
            v8 = true
        elseif v8 and v53 >= 1 then
            v8 = false

            local elapsed = os.clock()

            n9 = elapsed
            n12 = elapsed

            local v55 = if v4:NextNumber() < 0.5 then -1 else 1
            local v56 = n7

            n7 = math.clamp(v56 + v55 * 4 * v4:NextNumber(0.8, 1) * 40.840704496667314 / 0.7, -291.719317833338, 291.719317833338)
            v12 = t2
            n10 = 1
            n11 = t2[1]

            if v13 ~= true then
                v13 = true
                p16.Decor.Visible = false
            end

            n13 = 0.7
        end

        p16.Phantom.Size = UDim2.new(n2, 0, p16.PhantomSizeY.Scale, p16.PhantomSizeY.Offset)
    end

    local v59 = n3

    if v59 ~= n2 then
        local v60 = n3
        local v62 = n2

        n3 = v60 + (v62 - n3) * (1 - math.exp(p17 * -9))

        local v65 = n2

        if math.abs(v65 - n3) < 4E-04 then
            n3 = n2
        end

        local v67 = n3
        local v68 = math.round(v67 * p16.BarBG.AbsoluteSize.X)

        if v68 ~= n4 then
            n4 = v68
            p16.Bar.Size = UDim2.new(n3, 0, p16.BarSizeY.Scale, p16.BarSizeY.Offset)
        end

        n5 += p17

        local v69 = n3

        if v69 == n2 or n5 >= 0.05 then
            n5 = 0

            local v70 = string.format("%.2f%%", n3 * 100)

            if v70 ~= v9 then
                v9 = v70
                p16.Percent.Text = v70
            end
        end
    end

    if n6 ~= 0 or n7 ~= 0 then
        local v73 = math.max(math.ceil(p17 * 120), 1)
        local v74 = p17 / v73

        for _ = 1, v73 do
            local v75 = n7

            n7 = v75 + (-1667.9631437841017 * n6 - 24.504422698000386 * n7) * v74

            local v76 = n6

            n6 = v76 + n7 * v74
        end

        if math.abs(n6) < 0.02 and math.abs(n7) < 0.3 then
            n6 = 0
            n7 = 0
        end

        if math.abs(n6 - n8) >= 0.02 or n6 == 0 then
            n8 = n6
            p16.Holder.Rotation = p16.BaseHolderRotation + n6
        end
    end

    local v80 = v12

    if v80 then
        n11 -= p17

        while n11 <= 0 do
            n10 += 1

            local v81 = v80[n10]

            if v81 == nil then
                v12 = nil

                if v13 ~= false then
                    v13 = false
                    p16.Decor.Visible = true
                end

                break
            end

            n11 += v81

            local v82 = n10 % 2 == 1

            if v82 ~= v13 then
                v13 = v82
                p16.Decor.Visible = not v82
            end
        end
    end

    local v83 = n3 * 100

    if v83 ~= n20 then
        n20 = v83

        local v84 = v83 >= 30

        if v15 ~= v84 then
            v15 = v84
            n18 = 0

            if not v84 then
                p16.Icon.Position = p16.BaseIconPosition
                p16.Icon.Rotation = p16.BaseIconRotation
            end
        end

        for _, v85 in p16.LightningSheets do
            setSheet(v85, v85.StartAt <= v83)
        end

        setSheet(p16.FillSheet, n3 > 0)
    end

    if n13 > 0 then
        local v86 = n13

        n13 = v86 * math.exp(p17 * -5)

        if n13 < 0.01 then
            n13 = 0
        end
    end

    if v15 then
        n14 += p17
    else
        n14 = 0
    end

    writeEnergy(p16, false)

    if v15 then
        local X = p16.Icon.AbsoluteSize.X
        local v88 = v14

        if v88 == nil or v88.Width ~= X then
            v88 = buildTremble(p16, X)
            v14 = v88
        end

        n18 += p17

        if n18 >= 0.03333333333333333 then
            n18 %= 0.03333333333333333

            local v91 = math.clamp(math.floor((v83 - 30) / 70 * 3 + 0.5) + 1, 1, 4)
            local v92 = n19

            n19 = (v92 + v4:NextInteger(3, 9) - 1) % 12 + 1
            p16.Icon.Position = v88.Positions[v91][n19]
            p16.Icon.Rotation = v88.Rotations[v91][n19]
        end
    end

    for _, v93 in p16.AllSheets do
        local Offsets = v93.Offsets

        if v93.On and Offsets ~= nil then
            local v94 = v93.Acc + p17

            if v93.FrameTime <= v94 then
                local v95 = v94 // v93.FrameTime

                v94 -= v95 * v93.FrameTime
                v93.Frame = (v93.Frame - 1 + v95) % v93.Frames + 1
                v93.Image.ImageRectOffset = Offsets[v93.Frame]
            end

            v93.Acc = v94
        end
    end
end

local function step(p18) -- line: 645
    -- upvalues: Workspace (copy), HiddenUIHandler (copy), SammyEvent (copy), t3 (ref), v5 (ref), v6 (ref), v7 (ref), n1 (ref), n2 (ref), n3 (ref), n4 (ref), v9 (ref), v10 (ref), v11 (ref), writeEnergy (copy), rest (copy), stepBar (copy)
    local t12 = t3

    if v5 and t12 ~= nil then
        if HiddenUIHandler.IsHidden() then
            if v6 then
                v6 = false
                v7 = false
                rest(t12)
                t12.Gui.Enabled = false
            end
        else
            if not v6 then
                v6 = true
                t12.Gui.Enabled = true

                local SammyEmpCharge = Workspace:GetAttribute("SammyEmpCharge")

                n2 = if type(SammyEmpCharge) == "number" then math.clamp(SammyEmpCharge / SammyEvent.ChargeMax, 0, 1) else 0
                n3 = n2

                local v99 = n3

                n4 = math.round(v99 * t12.BarBG.AbsoluteSize.X)
                t12.Bar.Size = UDim2.new(n3, 0, t12.BarSizeY.Scale, t12.BarSizeY.Offset)
                t12.Phantom.Size = UDim2.new(n2, 0, t12.PhantomSizeY.Scale, t12.PhantomSizeY.Offset)

                local v100 = string.format("%.2f%%", n3 * 100)

                if v100 ~= v9 then
                    v9 = v100
                    t12.Percent.Text = v100
                end

                writeEnergy(t12, true)

                local v101

                if Workspace:GetAttribute("SammyPhase") == "SaveBen" then
                    v101 = "Save Ben from Mind Controlled Sammy!"
                else
                    local SammyWeaponRequired = Workspace:GetAttribute("SammyWeaponRequired")

                    v101 = if type(SammyWeaponRequired) == "number" and SammyWeaponRequired > 0 then "Bring Brainrots to the Laser Gun!" else t12.TitleText
                end

                if v101 ~= v10 then
                    v10 = v101
                    t12.Title.Text = v101
                end

                local v103 = n1
                local v105 = math.max(0, (math.floor(v103 - Workspace:GetServerTimeNow())))
                local v106 = string.format("%02d:%02d", v105 // 60, v105 % 60)

                if v106 ~= v11 then
                    v11 = v106
                    t12.Timer.Text = v106
                end
            end

            local v107 = math.min(p18, 0.1)
            local SammyWeaponRequired = Workspace:GetAttribute("SammyWeaponRequired")
            local v108 = not (type(SammyWeaponRequired) == "number" and SammyWeaponRequired > 0) and Workspace:GetAttribute("SammyPhase") ~= "SaveBen"

            if v7 ~= v108 then
                v7 = v108

                if v108 then
                    local SammyEmpCharge = Workspace:GetAttribute("SammyEmpCharge")

                    n2 = if type(SammyEmpCharge) == "number" then math.clamp(SammyEmpCharge / SammyEvent.ChargeMax, 0, 1) else 0
                    n3 = n2

                    local v112 = n3

                    n4 = math.round(v112 * t12.BarBG.AbsoluteSize.X)
                    t12.Bar.Size = UDim2.new(n3, 0, t12.BarSizeY.Scale, t12.BarSizeY.Offset)
                    t12.Phantom.Size = UDim2.new(n2, 0, t12.PhantomSizeY.Scale, t12.PhantomSizeY.Offset)

                    local v117 = string.format("%.2f%%", n3 * 100)

                    if v117 ~= v9 then
                        v9 = v117
                        t12.Percent.Text = v117
                    end

                    writeEnergy(t12, true)
                else
                    rest(t12)
                end

                t12.Holder.Visible = v108
            end

            if v7 then
                stepBar(t12, v107)
            end

            local v119

            if Workspace:GetAttribute("SammyPhase") == "SaveBen" then
                v119 = "Save Ben from Mind Controlled Sammy!"
            else
                local SammyWeaponRequired = Workspace:GetAttribute("SammyWeaponRequired")

                v119 = if type(SammyWeaponRequired) == "number" and SammyWeaponRequired > 0 then "Bring Brainrots to the Laser Gun!" else t12.TitleText
            end

            if v119 ~= v10 then
                v10 = v119
                t12.Title.Text = v119
            end

            local v121 = n1
            local v123 = math.max(0, (math.floor(v121 - Workspace:GetServerTimeNow())))
            local v124 = string.format("%02d:%02d", v123 // 60, v123 % 60)

            if v124 ~= v11 then
                v11 = v124
                t12.Timer.Text = v124
            end
        end
    end
end

local function stop() -- line: 672
    -- upvalues: t3 (ref), v5 (ref), v6 (ref), v7 (ref), rest (copy)
    if not v5 then
        return
    end

    v5 = false
    v6 = false
    v7 = false

    local t13 = t3

    if t13 ~= nil then
        rest(t13)
        t13.Gui.Enabled = false
    end
end

local function pickupArrived(_) -- line: 688
    -- upvalues: t1 (copy), v4 (copy), t3 (ref), v5 (ref), v6 (ref), n7 (ref), n9 (ref), v12 (ref), n10 (ref), n11 (ref), v13 (ref), n12 (ref), n13 (ref)
    local t14 = t3
    local elapsed

    if not v5 or not v6 or t14 == nil then
        return
    else
        elapsed = os.clock()

        if elapsed - n9 >= 0.08 then
            n9 = elapsed

            local v126 = if v4:NextNumber() < 0.5 then -1 else 1
            local v127 = n7

            n7 = math.clamp(v127 + v126 * 1.6 * v4:NextNumber(0.8, 1) * 40.840704496667314 / 0.7, -291.719317833338, 291.719317833338)
        end
    end

    n13 = math.max(n13, 0.35)

    if v12 ~= nil or not (elapsed - n12 >= 0.22) then
        return
    end

    n12 = elapsed
    v12 = t1
    n10 = 1
    n11 = t1[1]

    if v13 == true then
        return
    end

    v13 = true
    t14.Decor.Visible = false
end

return {
    Start = function(p20, p21) -- start | line: 695
        -- upvalues: RunService (copy), Workspace (copy), SammyEvent (copy), v5 (ref), v6 (ref), v7 (ref), n1 (ref), n2 (ref), n3 (ref), v8 (ref), resolveUi (copy), step (copy), stop (copy)
        resolveUi()
        v5 = true
        v6 = false
        v7 = false
        n1 = p21

        local SammyEmpCharge = Workspace:GetAttribute("SammyEmpCharge")

        n2 = if type(SammyEmpCharge) == "number" then math.clamp(SammyEmpCharge / SammyEvent.ChargeMax, 0, 1) else 0
        n3 = n2
        v8 = n2 < 0.99
        p20:Connect(RunService.PreRender, step)
        p20:Add(stop)
    end,
    Stop = stop,
    PickupArrived = pickupArrived
}
