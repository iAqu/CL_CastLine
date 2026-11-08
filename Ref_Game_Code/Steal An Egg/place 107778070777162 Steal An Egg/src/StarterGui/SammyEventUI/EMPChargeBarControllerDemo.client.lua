-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Parent = script.Parent
local EMPChargeBar = Parent:WaitForChild("EMPChargeBar")
local BarHolder = EMPChargeBar:WaitForChild("BarHolder")
local Icon = BarHolder:WaitForChild("Icon")
local GlowImage = Icon:WaitForChild("GlowImage")
local ProgressHolder = BarHolder:WaitForChild("ProgressHolder")
local BarBG = BarHolder:WaitForChild("BarBG")
local Bar = BarBG:WaitForChild("Bar")
local PhantomBar = BarBG:WaitForChild("PhantomBar")
local Decor = BarBG:WaitForChild("Decor")
local ENERGY_LINE_WIDTH = EMPChargeBar:WaitForChild("Frame")
local t1 = {
    LIGHTNING_AT = 30,
    BAR_LIGHTNING = true,
    REARM_BELOW = 99,
    FILL_SPEED = 9,
    TEXT_HZ = 20,
    KICK_DEGREES = 1.6,
    KICK_FULL_DEGREES = 4,
    KICK_MAX_DEGREES = 5,
    KICK_HZ = 6.5,
    KICK_DAMPING = 0.3,
    KICK_MIN_GAP = 0.08,
    TREMBLE_PX = { 1, 3.5 },
    TREMBLE_DEGREES = { 2, 6 },
    TREMBLE_HZ = 30,
    FLICKER = { 0.04, 0.05, 0.035 },
    FLICKER_FULL = { 0.06, 0.04, 0.05, 0.05, 0.035, 0.07, 0.09 },
    FLICKER_MIN_GAP = 0.22,
    ENERGY_CORE_COLOR = Color3.fromRGB(0, 170, 255),
    ENERGY_LINE_COLOR = Color3.fromRGB(200, 250, 255),
    ENERGY_CORE_TRANSPARENCY = 0.72,
    ENERGY_LINE_TRANSPARENCY = 0.2,
    ENERGY_LINE_WIDTH = 0.06,
    ENERGY_EMPTY = 0.1,
    ENERGY_FULL = 1.08,
    GLOW_REST = 0.15,
    HALO_COLOR = Color3.fromRGB(70, 210, 255),
    HALO_SCALE = 1.16,
    HALO_EMPTY = 0.92,
    HALO_FULL = 0.4,
    LINE_TOP = 0.92,
    HUM = 0.06,
    HUM_HZ = 1.6,
    SURGE = 0.35,
    SURGE_FULL = 0.7,
    SURGE_DECAY = 5
}
local v1 = Random.new()
local Fired = Parent:FindFirstChild("Fired")
local v2 = Fired
local v3

if not (Fired and Fired:IsA("BindableEvent")) then
    v3 = Instance.new("BindableEvent")
    v2 = v3
    v3.Name = "Fired"
    v3.Parent = Parent
end

local child

v3 = nil

for _, child2 in ENERGY_LINE_WIDTH:GetChildren() do
    if child2:IsA("TextLabel") and (not v3 or child2.Position.Y.Scale > v3.Position.Y.Scale) then
        v3 = child2
        child = child2
    end
end

ENERGY_LINE_WIDTH = t1.ENERGY_LINE_WIDTH

local v4 = GlowImage:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

v4.Rotation = -90

local new = ColorSequence.new
local v5 = ColorSequenceKeypoint.new(0, t1.ENERGY_CORE_COLOR)
local v6 = ColorSequenceKeypoint.new(0.5 - ENERGY_LINE_WIDTH, t1.ENERGY_CORE_COLOR)
local v7 = ColorSequenceKeypoint.new(0.49, t1.ENERGY_LINE_COLOR)

v4.Color = new({
    v5,
    v6,
    v7,
    ColorSequenceKeypoint.new(1, t1.ENERGY_LINE_COLOR)
})
v4.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, t1.ENERGY_CORE_TRANSPARENCY),
    NumberSequenceKeypoint.new(0.5 - ENERGY_LINE_WIDTH, t1.ENERGY_CORE_TRANSPARENCY),
    NumberSequenceKeypoint.new(0.485, t1.ENERGY_LINE_TRANSPARENCY),
    NumberSequenceKeypoint.new(0.52, 1),
    NumberSequenceKeypoint.new(1, 1)
})
v4.Parent = GlowImage
GlowImage.ImageColor3 = Color3.new(1, 1, 1)

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "EnergyHalo"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = GlowImage.Image
ImageLabel.ScaleType = GlowImage.ScaleType
ImageLabel.ImageColor3 = t1.HALO_COLOR
ImageLabel.ImageTransparency = 1
ImageLabel.AnchorPoint = Icon.AnchorPoint
ImageLabel.Position = Icon.Position
ImageLabel.Size = UDim2.new(Icon.Size.X.Scale * t1.HALO_SCALE, Icon.Size.X.Offset * t1.HALO_SCALE, Icon.Size.Y.Scale * t1.HALO_SCALE, Icon.Size.Y.Offset * t1.HALO_SCALE)
ImageLabel.ZIndex = Icon.ZIndex - 1
ImageLabel.Visible = false
ImageLabel.Parent = BarHolder

local Rotation = BarHolder.Rotation
local IconPosition, Rotation2 = Icon.Position, Icon.Rotation
local Y = Bar.Size.Y
local Y2 = PhantomBar.Size.Y
local v9, v10
local t2 = {}

local function buildOffsets(p1) -- line: 192
    local X = p1.cells.X
    local ImageRectSize = p1.image.ImageRectSize
    local v11 = table.create(p1.frames)

    for i = 0, p1.frames - 1 do
        local new = Vector2.new
        local v12 = ImageRectSize.X * (i % X)
        local Y = ImageRectSize.Y
        local v13 = i / X

        v11[i + 1] = new(v12, Y * math.floor(v13))
    end

    p1.offsets = v11
end

local function makeSheet(p2, p3, p4) -- line: 202
    -- upvalues: t1 (copy)
    p3 = p3 or Vector2.new(1, 1)
    p2.Visible = false
    p2.ImageRectOffset = Vector2.zero

    return {
        offsets = nil,
        frame = 1,
        acc = 0,
        on = false,
        image = p2,
        cells = p3,
        frames = math.max(1, p3.X * p3.Y),
        frameTime = 1 / (p4 or 24),
        startAt = p2:GetAttribute("StartAt") or t1.LIGHTNING_AT
    }
end

local t4 = {}
local v8 = nil
local v16 = nil

for _, descendant in EMPChargeBar:GetDescendants() do
    if descendant:IsA("LocalScript") and descendant.Name == "PlaySprite" then
        descendant.Enabled = false
    end

    if not (t4[descendant.Parent] and descendant:IsA("LocalScript")) then
        local Parent = descendant:IsA("ImageLabel")

        if Parent then
            Parent = descendant:GetAttribute("ChargeLine")

            if Parent then
                Parent = descendant:IsDescendantOf(Icon)

                if Parent then
                    t4[descendant] = true
                    Parent = descendant:FindFirstChildOfClass("LocalScript")

                    if Parent then
                        Parent.Enabled = false
                    end

                    if not Parent or not Parent:GetAttribute("Cells") then
                        Parent = descendant
                    end

                    v16 = makeSheet(descendant, Parent:GetAttribute("Cells"), Parent:GetAttribute("FPS"))
                    v10 = v16
                else
                    Parent = descendant:IsA("LocalScript")

                    if Parent then
                        Parent = descendant:GetAttribute("Cells")

                        if Parent then
                            Parent = descendant.Parent:IsA("ImageLabel")

                            if Parent then
                                Parent = descendant.Parent:GetAttribute("ChargeLine")

                                if not Parent then
                                    descendant.Enabled = false
                                    Parent = descendant.Parent
                                    t4[Parent] = true

                                    local v18 = makeSheet(Parent, descendant:GetAttribute("Cells"), descendant:GetAttribute("FPS"))

                                    if Parent:IsDescendantOf(Bar) then
                                        v8 = v18
                                        v9 = v18
                                    elseif Parent:IsDescendantOf(Icon) or t1.BAR_LIGHTNING then
                                        table.insert(t2, v18)
                                    end
                                end
                            end
                        end
                    end
                end
            else
                Parent = descendant:IsA("LocalScript")

                if Parent then
                    Parent = descendant:GetAttribute("Cells")

                    if Parent then
                        Parent = descendant.Parent:IsA("ImageLabel")

                        if Parent then
                            Parent = descendant.Parent:GetAttribute("ChargeLine")

                            if not Parent then
                                descendant.Enabled = false
                                Parent = descendant.Parent
                                t4[Parent] = true

                                local v19 = makeSheet(Parent, descendant:GetAttribute("Cells"), descendant:GetAttribute("FPS"))

                                if Parent:IsDescendantOf(Bar) then
                                    v8 = v19
                                    v9 = v19
                                elseif Parent:IsDescendantOf(Icon) or t1.BAR_LIGHTNING then
                                    table.insert(t2, v19)
                                end
                            end
                        end
                    end
                end
            end
        else
            Parent = descendant:IsA("LocalScript")

            if Parent then
                Parent = descendant:GetAttribute("Cells")

                if Parent then
                    Parent = descendant.Parent:IsA("ImageLabel")

                    if Parent then
                        Parent = descendant.Parent:GetAttribute("ChargeLine")

                        if not Parent then
                            descendant.Enabled = false
                            Parent = descendant.Parent
                            t4[Parent] = true

                            local v20 = makeSheet(Parent, descendant:GetAttribute("Cells"), descendant:GetAttribute("FPS"))

                            if Parent:IsDescendantOf(Bar) then
                                v8 = v20
                                v9 = v20
                            elseif Parent:IsDescendantOf(Icon) or t1.BAR_LIGHTNING then
                                table.insert(t2, v20)
                            end
                        end
                    end
                end
            end
        end
    end
end

local v21 = v16 and v16.image.Position.X
local v22, v23

local function buildTremble() -- line: 253
    -- upvalues: Icon (copy), t1 (copy), v1 (copy), IconPosition (copy), Rotation2 (copy), v22 (ref), v23 (ref)
    local v24 = table.create(4)
    local v25 = table.create(4)

    v22 = v24
    v23 = v25

    local X = Icon.AbsoluteSize.X

    for i = 1, 4 do
        local v26 = (i - 1) / 3
        local v27 = X * (t1.TREMBLE_PX[1] + (t1.TREMBLE_PX[2] - t1.TREMBLE_PX[1]) * v26) / 100
        local v28 = t1.TREMBLE_DEGREES[1] + (t1.TREMBLE_DEGREES[2] - t1.TREMBLE_DEGREES[1]) * v26
        local v29 = table.create(12)
        local v30 = table.create(12)

        for j = 1, 12 do
            local v31 = j / 12 * 3.141592653589793 * 2 + v1:NextNumber(-0.4, 0.4)
            local v32 = v27 * v1:NextNumber(0.45, 1)

            v29[j] = IconPosition + UDim2.fromOffset(math.round(math.cos(v31) * v32), (math.round(math.sin(v31) * v32)))
            v30[j] = Rotation2 + v28 * v1:NextNumber(-1, 1)
        end

        local v36 = v22
        local v37 = v23

        v36[i] = v29
        v37[i] = v30
    end
end

local t5 = {}
local v38 = Icon

while v38 do
    table.insert(t5, v38)

    if v38:IsA("LayerCollector") then
        break
    end

    v38 = v38.Parent
end

local v39 = false
local connection
local n1 = 0
local n2 = 0
local v40 = true
local v41 = false
local X = BarBG.AbsoluteSize.X
local n3 = -1
local v42
local n4 = 0
local v43
local n5 = 0
local n6 = 0
local n7 = 0
local n8 = -1
local v44 = nil
local n9 = 0
local n10 = 0
local v45 = false
local n11 = -1
local n12 = 0
local n13 = 0
local n14 = -1
local n15 = -1
local n16 = -1
local v46 = false
local n17 = 0
local n18 = 1
local n19 = -1
local v47 = table.clone(t2)

if v8 then
    table.insert(v47, v8)
end

if v16 then
    table.insert(v47, v16)
end

local function writeTimer() -- line: 344
    -- upvalues: Parent (copy), child (ref), v43 (ref)
    local TimeLeft = Parent:GetAttribute("TimeLeft")

    if type(TimeLeft) == "number" and child then
        local v49 = math.max(0, (math.floor(TimeLeft)))
        local v50 = string.format("%02d:%02d", v49 // 60, v49 % 60)

        if v50 == v43 then
            return
        end

        v43 = v50
        child.Text = v50
    end
end

local function setSheet(p5, p6) -- line: 355
    -- upvalues: buildOffsets (copy)
    if p5.on == p6 then
        return
    end

    p5.on = p6
    p5.image.Visible = p6

    if not p6 then
        return
    end

    if not p5.offsets then
        buildOffsets(p5)
    end

    p5.frame = 1
    p5.acc = 0
    p5.image.ImageRectOffset = p5.offsets[1]
end

local function setDecorOff(p7) -- line: 367
    -- upvalues: Decor (copy), v45 (ref)
    if p7 ~= v45 then
        v45 = p7
        Decor.Visible = not p7
    end
end

local function writeEnergy(p8) -- line: 375
    -- upvalues: GlowImage (copy), t1 (copy), v4 (copy), ImageLabel (copy), v10 (ref), buildOffsets (copy), n2 (ref), n12 (ref), n13 (ref), n14 (ref), n15 (ref), n16 (ref), v46 (ref), v21 (copy)
    local v51 = t1.ENERGY_EMPTY + (t1.ENERGY_FULL - t1.ENERGY_EMPTY) * n2
    local v52 = if not p8 then math.abs(v51 - n14) >= 0.002 else nil

    if p8 or v52 then
        n14 = v51
        v4.Offset = Vector2.new(0, 0.5 - v51)

        if v10 then
            v10.image.Position = UDim2.new(v21.Scale, v21.Offset, 1 - math.min(v51, t1.LINE_TOP), 0)
        end
    end

    if v10 then
        local v54 = v10
        local v55 = n2 > 0 and n2 < 1

        if v54.on ~= v55 then
            v54.on = v55
            v54.image.Visible = v55

            if v55 then
                if not v54.offsets then
                    buildOffsets(v54)
                end

                v54.frame = 1
                v54.acc = 0
                v54.image.ImageRectOffset = v54.offsets[1]
            end
        end
    end

    local v56 = v46
    local v57 = 0

    if v56 then
        local HUM = t1.HUM
        local v59 = n13

        v57 = HUM * math.sin(v59 * t1.HUM_HZ * 3.141592653589793 * 2) or 0
    end

    local v61 = math.clamp(t1.GLOW_REST * (1 - n12) + v57, 0, 1)
    local v62 = if not p8 then math.abs(v61 - n15) >= 0.01 else nil

    if p8 or v62 then
        n15 = v61
        GlowImage.ImageTransparency = v61
    end

    local v64 = t1.HALO_EMPTY + (t1.HALO_FULL - t1.HALO_EMPTY) * n2
    local v66 = n12
    local v67 = math.clamp(v64 - v66 * (v64 - 0.1) + v57, 0, 1)
    local v68 = if not p8 then math.abs(v67 - n16) >= 0.01 else nil

    if p8 or v68 then
        n16 = v67
        ImageLabel.ImageTransparency = v67
    end

    local v70 = n2 > 0

    if p8 or GlowImage.Visible ~= v70 then
        GlowImage.Visible = v70
        ImageLabel.Visible = v70
    end
end

local function rest() -- line: 422
    -- upvalues: BarHolder (copy), Icon (copy), GlowImage (copy), Decor (copy), ImageLabel (copy), Rotation (copy), IconPosition (copy), Rotation2 (copy), v22 (ref), v23 (ref), n3 (ref), v42 (ref), n5 (ref), n6 (ref), n7 (ref), v44 (ref), v45 (ref), n12 (ref), n13 (ref), n14 (ref), n15 (ref), n16 (ref), v46 (ref), n17 (ref), n19 (ref), v47 (copy)
    n5 = 0
    n6 = 0
    n7 = 0
    BarHolder.Rotation = Rotation
    v44 = nil

    if v45 ~= false then
        v45 = false
        Decor.Visible = true
    end

    n12 = 0
    n13 = 0

    if v46 ~= false then
        v46 = false
        n17 = 0
        Icon.Position = IconPosition
        Icon.Rotation = Rotation2
    end

    for _, v71 in v47 do
        if v71.on ~= false then
            v71.on = false
            v71.image.Visible = false
        end

        v71.offsets = nil
    end

    GlowImage.Visible = false
    ImageLabel.Visible = false
    v22 = nil
    v23 = nil
    n19 = -1
    n14 = -1
    n15 = -1
    n16 = -1
    n3 = -1
    v42 = nil
end

local v72 = t1.KICK_HZ * 2 * 3.141592653589793

local function step(p9) -- line: 446
    -- upvalues: BarHolder (copy), Icon (copy), ProgressHolder (copy), Bar (copy), Decor (copy), t1 (copy), v1 (copy), Rotation (copy), IconPosition (copy), Rotation2 (copy), Y (copy), v9 (ref), t2 (copy), buildOffsets (copy), v22 (ref), v23 (ref), connection (ref), n1 (ref), n2 (ref), X (ref), n3 (ref), v42 (ref), n4 (ref), n5 (ref), n6 (ref), n7 (ref), v44 (ref), n9 (ref), n10 (ref), v45 (ref), n12 (ref), n13 (ref), n14 (ref), v46 (ref), n17 (ref), n18 (ref), n19 (ref), v47 (copy), writeEnergy (copy), v72 (copy)
    local v73 = if p9 > 0.1 then 0.1 else p9
    local v74 = true

    if n2 == n1 then
        v74 = false
    else
        n2 += (n1 - n2) * (1 - math.exp(-t1.FILL_SPEED * v73))

        local v81 = n1

        if math.abs(v81 - n2) < 4E-04 then
            n2 = n1
        end

        local v83 = math.round(n2 * X)

        if v83 ~= n3 then
            n3 = v83
            Bar.Size = UDim2.new(n2, 0, Y.Scale, Y.Offset)
        end

        n4 += v73

        local v84 = n2 == n1

        if not v84 then
            v84 = n4 >= 1 / t1.TEXT_HZ
        end

        if v84 then
            n4 = 0

            local v87 = string.format("%.2f%%", n2 * 100)

            if v87 ~= v42 then
                v42 = v87
                ProgressHolder.Text = v87
            end
        end
    end

    if n5 ~= 0 or n6 ~= 0 then
        local v89 = math.ceil(v73 * 120)
        local v90 = v73 / v89
        local KICK_DAMPING = t1.KICK_DAMPING

        for _ = 1, v89 do
            n6 += (-v72 * v72 * n5 - 2 * KICK_DAMPING * v72 * n6) * v90
            n5 += n6 * v90
        end

        if math.abs(n5) < 0.02 and math.abs(n6) < 0.3 then
            n5 = 0
            n6 = 0
        end

        if math.abs(n5 - n7) >= 0.02 or n5 == 0 then
            n7 = n5
            BarHolder.Rotation = Rotation + n5
        end

        v74 = true
    end

    if v44 then
        n10 -= v73

        while v44 and n10 <= 0 do
            n9 += 1

            local v96 = v44[n9]

            if v96 then
                n10 += v96

                local v97 = n9 % 2 == 1

                if v97 ~= v45 then
                    v45 = v97
                    Decor.Visible = not v97
                end
            else
                v44 = nil

                if v45 ~= false then
                    v45 = false
                    Decor.Visible = true
                end
            end
        end

        v74 = true
    end

    local v99 = n2 * 100

    if v99 ~= n19 then
        n19 = v99

        local v100 = t1.LIGHTNING_AT <= v99

        if v46 ~= v100 then
            v46 = v100
            n17 = 0

            if not v100 then
                Icon.Position = IconPosition
                Icon.Rotation = Rotation2
            end
        end

        for _, v101 in t2 do
            local v102 = v101.startAt <= v99

            if v101.on ~= v102 then
                v101.on = v102
                v101.image.Visible = v102

                if v102 then
                    if not v101.offsets then
                        buildOffsets(v101)
                    end

                    v101.frame = 1
                    v101.acc = 0
                    v101.image.ImageRectOffset = v101.offsets[1]
                end
            end
        end

        if v9 then
            local v103 = v9
            local v104 = n2 > 0

            if v103.on ~= v104 then
                v103.on = v104
                v103.image.Visible = v104

                if v104 then
                    if not v103.offsets then
                        buildOffsets(v103)
                    end

                    v103.frame = 1
                    v103.acc = 0
                    v103.image.ImageRectOffset = v103.offsets[1]
                end
            end
        end
    end

    local v105 = n12 > 0 or v46 or n14 < 0

    if n12 > 0 then
        n12 *= math.exp(-t1.SURGE_DECAY * v73)

        if n12 < 0.01 then
            n12 = 0
        end
    end

    if v46 then
        n13 += v73
    else
        n13 = 0
    end

    if v105 or v74 then
        writeEnergy(false)
    end

    if n12 > 0 then
        v74 = true
    end

    if v46 then
        n17 += v73

        if n17 >= 1 / t1.TREMBLE_HZ then
            n17 %= 1 / t1.TREMBLE_HZ

            local v112 = math.clamp(math.floor((v99 - t1.LIGHTNING_AT) / (100 - t1.LIGHTNING_AT) * 3 + 0.5) + 1, 1, 4)

            n18 = (n18 + v1:NextInteger(3, 9) - 1) % 12 + 1
            Icon.Position = v22[v112][n18]
            Icon.Rotation = v23[v112][n18]
        end

        v74 = true
    end

    for _, v114 in v47 do
        if v114.on then
            local v115 = v114.acc + v73
            local frameTime = v114.frameTime

            if frameTime <= v115 then
                local v116 = v115 // frameTime

                v115 -= v116 * frameTime
                v114.frame = (v114.frame - 1 + v116) % v114.frames + 1
                v114.image.ImageRectOffset = v114.offsets[v114.frame]
            end

            v74 = true
            v114.acc = v115
        end
    end

    if v74 or not connection then
        return
    end

    connection:Disconnect()
    connection = nil
end

local function wake() -- line: 561
    -- upvalues: RunService (copy), v39 (ref), connection (ref), step (copy)
    if v39 and not connection then
        connection = RunService.Heartbeat:Connect(step)
    end
end

local function onCharged(p10) -- line: 583
    -- upvalues: RunService (copy), Decor (copy), t1 (copy), v1 (copy), v39 (ref), connection (ref), n6 (ref), n8 (ref), v44 (ref), n9 (ref), n10 (ref), v45 (ref), n11 (ref), n12 (ref), v72 (copy), step (copy)
    if not v39 then
        return
    end

    local elapsed = os.clock()

    if p10 then
        n8 = elapsed
        n11 = elapsed

        local KICK_FULL_DEGREES = t1.KICK_FULL_DEGREES
        local v117 = if v1:NextNumber() < 0.5 then -1 else 1
        local v118 = t1.KICK_MAX_DEGREES * v72 / 0.7
        local v120 = n6

        n6 = math.clamp(v120 + v117 * KICK_FULL_DEGREES * v1:NextNumber(0.8, 1) * v72 / 0.7, -v118, v118)

        local FLICKER_FULL = t1.FLICKER_FULL

        v44 = FLICKER_FULL
        n9 = 1
        n10 = FLICKER_FULL[1]

        if v45 ~= true then
            v45 = true
            Decor.Visible = false
        end

        n12 = t1.SURGE_FULL
    else
        if elapsed - n8 >= t1.KICK_MIN_GAP then
            n8 = elapsed

            local KICK_DEGREES = t1.KICK_DEGREES
            local v122 = if v1:NextNumber() < 0.5 then -1 else 1
            local v123 = t1.KICK_MAX_DEGREES * v72 / 0.7
            local v124 = n6

            n6 = math.clamp(v124 + v122 * KICK_DEGREES * v1:NextNumber(0.8, 1) * v72 / 0.7, -v123, v123)
        end

        local v127 = n12

        n12 = math.max(v127, t1.SURGE)

        if not v44 and elapsed - n11 >= t1.FLICKER_MIN_GAP then
            n11 = elapsed

            local FLICKER = t1.FLICKER

            v44 = FLICKER
            n9 = 1
            n10 = FLICKER[1]

            if v45 ~= true then
                v45 = true
                Decor.Visible = false
            end
        end
    end

    if v39 and not connection then
        connection = RunService.Heartbeat:Connect(step)
    end
end

local function readCharge() -- line: 607
    -- upvalues: Parent (copy)
    local Charge = Parent:GetAttribute("Charge")

    return if type(Charge) == "number" and Charge == Charge then math.clamp(Charge, 0, 100) / 100 else nil
end

local function onChargeChanged() -- line: 613
    -- upvalues: RunService (copy), Parent (copy), ProgressHolder (copy), Bar (copy), PhantomBar (copy), t1 (copy), v2 (ref), Y (copy), Y2 (copy), v39 (ref), connection (ref), n1 (ref), n2 (ref), v40 (ref), v41 (ref), X (ref), n3 (ref), v42 (ref), writeEnergy (copy), step (copy), onCharged (copy)
    local Charge = Parent:GetAttribute("Charge")
    local v128 = if type(Charge) ~= "number" or Charge ~= Charge then nil else math.clamp(Charge, 0, 100) / 100

    if v128 then
        if v41 then
            if v128 ~= n1 then
                local v129 = n1 < v128

                n1 = v128

                if v128 < t1.REARM_BELOW / 100 then
                    v40 = true
                end

                local v130 = v40 and v128 >= 1

                if v130 then
                    v40 = false
                    v2:Fire()
                end

                if v39 then
                    PhantomBar.Size = UDim2.new(n1, 0, Y2.Scale, Y2.Offset)

                    if v129 then
                        onCharged(v130)
                    end

                    if v39 and not connection then
                        connection = RunService.Heartbeat:Connect(step)
                    end
                end
            end
        else
            v41 = true
            n1 = v128
            n2 = v128
            v40 = v128 < t1.REARM_BELOW / 100

            if v39 then
                PhantomBar.Size = UDim2.new(n1, 0, Y2.Scale, Y2.Offset)
                n3 = math.round(n2 * X)
                Bar.Size = UDim2.new(n2, 0, Y.Scale, Y.Offset)

                local v132 = string.format("%.2f%%", n2 * 100)

                if v132 ~= v42 then
                    v42 = v132
                    ProgressHolder.Text = v132
                end

                writeEnergy(true)

                if v39 and not connection then
                    connection = RunService.Heartbeat:Connect(step)
                end
            end
        end
    end
end

local function isShown() -- line: 652
    -- upvalues: Parent (copy), t5 (copy)
    if not Parent.Parent then
        return false
    end

    for _, v133 in t5 do
        if v133:IsA("LayerCollector") then
            if not v133.Enabled then
                return false
            end
        elseif not v133.Visible then
            return false
        end
    end

    return true
end

local function refreshGate() -- line: 664
    -- upvalues: RunService (copy), Parent (copy), ProgressHolder (copy), Bar (copy), PhantomBar (copy), child (ref), Y (copy), Y2 (copy), buildTremble (copy), v39 (ref), connection (ref), n1 (ref), n2 (ref), X (ref), n3 (ref), v42 (ref), v43 (ref), writeEnergy (copy), rest (copy), step (copy), isShown (copy)
    local v134 = isShown()

    if v134 ~= v39 then
        v39 = v134

        if v39 then
            buildTremble()
            n2 = n1
            n3 = math.round(n2 * X)
            Bar.Size = UDim2.new(n2, 0, Y.Scale, Y.Offset)
            PhantomBar.Size = UDim2.new(n1, 0, Y2.Scale, Y2.Offset)

            local v136 = string.format("%.2f%%", n2 * 100)

            if v136 ~= v42 then
                v42 = v136
                ProgressHolder.Text = v136
            end

            local TimeLeft = Parent:GetAttribute("TimeLeft")

            if type(TimeLeft) == "number" and child then
                local v138 = math.max(0, (math.floor(TimeLeft)))
                local v139 = string.format("%02d:%02d", v138 // 60, v138 % 60)

                if v139 ~= v43 then
                    v43 = v139
                    child.Text = v139
                end
            end

            writeEnergy(true)

            if v39 and not connection then
                connection = RunService.Heartbeat:Connect(step)
            end
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end

            rest()
        end
    end
end

local Charge = Parent:GetAttribute("Charge")
local v140 = if type(Charge) ~= "number" or Charge ~= Charge then nil else math.clamp(Charge, 0, 100) / 100

if v140 then
    v41 = true
    n1 = v140
    n2 = v140
    v40 = v140 < t1.REARM_BELOW / 100
end

local t6 = {
    Parent:GetAttributeChangedSignal("Charge"):Connect(onChargeChanged),
    Parent:GetAttributeChangedSignal("TimeLeft"):Connect(function() -- line: 699
        -- upvalues: Parent (copy), child (ref), v39 (ref), v43 (ref)
        if not v39 then
            return
        end

        local TimeLeft = Parent:GetAttribute("TimeLeft")

        if type(TimeLeft) == "number" then
            if not child then
                return
            end

            local v142 = math.max(0, (math.floor(TimeLeft)))
            local v143 = string.format("%02d:%02d", v142 // 60, v142 % 60)

            if v143 ~= v43 then
                v43 = v143
                child.Text = v143
            end
        end
    end),
    BarBG:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 702
        -- upvalues: BarBG (copy), X (ref)
        X = BarBG.AbsoluteSize.X
    end),
    Icon:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 705
        -- upvalues: buildTremble (copy), v39 (ref)
        if v39 then
            buildTremble()
        end
    end)
}

for _, v144 in t5 do
    table.insert(t6, v144:GetPropertyChangedSignal(if v144:IsA("LayerCollector") then "Enabled" else "Visible"):Connect(refreshGate))
end

table.insert(t6, Parent.AncestryChanged:Connect(refreshGate))

local v145 = n2 * X

n3 = math.round(v145)
Bar.Size = UDim2.new(n2, 0, Y.Scale, Y.Offset)
PhantomBar.Size = UDim2.new(n1, 0, Y2.Scale, Y2.Offset)

local v146 = string.format("%.2f%%", n2 * 100)

if v146 ~= v42 then
    v42 = v146
    ProgressHolder.Text = v146
end

Charge = Parent:GetAttribute("TimeLeft")

if type(Charge) == "number" and child then
    v145 = math.max(0, (math.floor(Charge)))

    local v147 = string.format("%02d:%02d", v145 // 60, v145 % 60)

    if v147 ~= v43 then
        v43 = v147
        child.Text = v147
    end
end

refreshGate()
script.Destroying:Connect(function() -- line: 721
    -- upvalues: ImageLabel (copy), v39 (ref), connection (ref), rest (copy), t6 (copy)
    for _, v148 in t6 do
        v148:Disconnect()
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end

    v39 = false
    rest()
    ImageLabel:Destroy()
end)
