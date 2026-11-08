-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local t1 = {
    ["rbxassetid://90736891527931"] = "ChooseTeam_Hover",
    ["rbxassetid://135310337267680"] = "ChooseTeam_Select",
    ["rbxassetid://91838958509194"] = "ChooseTeam_Deselect"
}
local ParentParent = script.Parent.Parent
local Main = ParentParent:WaitForChild("Main")
local t2 = {}
local v1

local function easeOutBack(p1) -- line: 67
    local v2 = p1 - 1

    return v2 * 2.70158 * v2 * v2 + 1 + v2 * 1.70158 * v2
end

local function easeOutQuad(p2) -- line: 74
    local v3 = 1 - p2

    return 1 - v3 * v3
end

local function grown(p3, p4) -- line: 80
    return UDim2.new(p3.X.Scale * p4, p3.X.Offset * p4, p3.Y.Scale * p4, p3.Y.Offset * p4)
end

local function raised(p5, p6) -- line: 85
    return UDim2.new(p5.X.Scale, p5.X.Offset, p5.Y.Scale + p6, p5.Y.Offset)
end

local function advance(p7, p8, p9, p10) -- line: 89
    if p7.on then
        p7.p = math.min(1, p7.p + p8 / p9)
    else
        p7.p = math.max(0, p7.p - p8 / p10)
    end

    return p7.p
end

local function frame(p11) -- line: 98
    -- upvalues: t2 (copy), v1 (ref)
    local v6 = if p11 > 0.1 then 0.1 else p11

    for i = #t2, 1, -1 do
        local v7 = t2[i]

        if v7.dead or not v7.update(v7, v6) then
            v7.running = false
            table.remove(t2, i)
        end
    end

    if #t2 == 0 and v1 then
        v1:Disconnect()
        v1 = nil
    end
end

local function wake(p12) -- line: 117
    -- upvalues: RunService (copy), t2 (copy), v1 (ref), frame (copy)
    if p12.running or p12.dead then
        return
    end

    p12.running = true
    table.insert(t2, p12)
    v1 = v1 or RunService.PreRender:Connect(frame)
end

local function bind(p13, p14) -- line: 128
    p13.Destroying:Connect(function() -- line: 129
        -- upvalues: p14 (copy)
        p14.dead = true
    end)
end

local t3 = {}

local function loadSound(p15) -- line: 141
    -- upvalues: SoundService (copy), t1 (copy), t3 (copy)
    local Sound = Instance.new("Sound")

    Sound.Name = t1[p15] or "ChooseTeam_SFX"
    Sound.SoundId = p15
    Sound.Volume = 0.5
    Sound.Parent = SoundService
    t3[p15] = Sound

    return Sound
end

local function play(p16) -- line: 151
    -- upvalues: SoundService (copy), t1 (copy), t3 (copy)
    local v8 = t3[p16]

    if not v8 then
        v8 = Instance.new("Sound")
        v8.Name = t1[p16] or "ChooseTeam_SFX"
        v8.SoundId = p16
        v8.Volume = 0.5
        v8.Parent = SoundService
        t3[p16] = v8
    end

    v8.TimePosition = 0
    v8:Play()
end

for _, v9 in { "rbxassetid://90736891527931", "rbxassetid://135310337267680", "rbxassetid://91838958509194" } do
    local Sound = Instance.new("Sound")

    Sound.Name = t1[v9] or "ChooseTeam_SFX"
    Sound.SoundId = v9
    Sound.Volume = 0.5
    Sound.Parent = SoundService
    t3[v9] = Sound
end

script.Destroying:Connect(function() -- line: 161
    -- upvalues: t3 (copy)
    for _, v10 in t3 do
        v10:Destroy()
    end

    table.clear(t3)
end)

local function restCard(p17) -- line: 172
    p17.card.Size = p17.cardSize
    p17.card.ZIndex = p17.cardZ
    p17.hover.Visible = false
    p17.hover.Position = p17.idlePos
    p17.hover.Size = p17.idleSize
    p17.hover.ImageTransparency = p17.hoverAlpha
    p17.idle.ImageTransparency = p17.idleAlpha

    for v11, v12 in p17.fx do
        v12.ImageTransparency = p17.fxAlpha[v11]
    end

    p17.phase = 0
    p17.press = 1
end

local function updateCard(p18, p19) -- line: 187
    -- upvalues: restCard (copy)
    if p18.on then
        p18.p = math.min(1, p18.p + p19 / 0.22)
    else
        p18.p = math.max(0, p18.p - p19 / 0.16)
    end

    local p = p18.p
    local v15 = if p18.pressed then 0.95 else 1

    p18.press = p18.press + (v15 - p18.press) * (1 - math.exp(-p19 / 0.09))

    local v19 = math.abs(p18.press - 1) > 0.001

    if not v19 then
        p18.press = 1
    end

    if p <= 0 and not p18.on and not v19 then
        restCard(p18)

        return false
    end

    local v20

    if p18.on then
        local v21 = p - 1

        v20 = v21 * 2.70158 * v21 * v21 + 1 + v21 * 1.70158 * v21
    else
        local v22 = 1 - p

        v20 = 1 - v22 * v22
    end

    local card, cardSize = p18.card, p18.cardSize
    local v23 = (v20 * 0.050000000000000044 + 1) * p18.press

    card.Size = UDim2.new(cardSize.X.Scale * v23, cardSize.X.Offset * v23, cardSize.Y.Scale * v23, cardSize.Y.Offset * v23)
    p18.phase = (p18.phase + p19 * 0.9 * 6.283185307179586) % 6.283185307179586

    local v24 = math.sin(p18.phase)
    local hover = p18.hover
    local v25 = p18.idlePos:Lerp(p18.hoverPos, v20)
    local v26 = v24 * 0.014 * v20

    hover.Position = UDim2.new(v25.X.Scale, v25.X.Offset, v25.Y.Scale + v26, v25.Y.Offset)

    local hover2 = p18.hover
    local v27 = p18.idleSize:Lerp(p18.hoverSize, v20)
    local v28 = v24 * 0.012 * v20 + 1

    hover2.Size = UDim2.new(v27.X.Scale * v28, v27.X.Offset * v28, v27.Y.Scale * v28, v27.Y.Offset * v28)

    local v30 = math.min(1, p * 1.35)

    p18.hover.ImageTransparency = p18.hoverAlpha + (1 - p18.hoverAlpha) * (1 - v30)
    p18.idle.ImageTransparency = p18.idleAlpha + (1 - p18.idleAlpha) * v30

    for v31, v32 in p18.fx do
        local v33 = p18.fxAlpha[v31]

        v32.ImageTransparency = v33 + (1 - v33) * (1 - v30)
    end

    return true
end

local function refreshCard(p20) -- line: 228
    -- upvalues: RunService (copy), ParentParent (copy), t2 (copy), v1 (ref), frame (copy), updateCard (copy)
    local hovered = p20.hovered
    local selected = if not hovered then p20.selected else nil

    if hovered or selected then
        selected = ParentParent.Enabled
    end

    if p20.on ~= selected then
        p20.on = selected

        if selected then
            updateCard(p20, 0)
            p20.hover.Visible = true
            p20.card.ZIndex = 100
        end
    end

    if p20.running or p20.dead then
        return
    end

    p20.running = true
    table.insert(t2, p20)
    v1 = v1 or RunService.PreRender:Connect(frame)
end

local function setupCard(p21) -- line: 244
    -- upvalues: RunService (copy), SoundService (copy), t1 (copy), ParentParent (copy), t2 (copy), v1 (ref), frame (copy), t3 (copy), restCard (copy), updateCard (copy)
    local IdleIcon = p21:FindFirstChild("IdleIcon")
    local HoverIcon = p21:FindFirstChild("HoverIcon")

    if not (IdleIcon and IdleIcon:IsA("ImageLabel") and HoverIcon and HoverIcon:IsA("ImageLabel")) then
        return nil
    end

    local t4 = {}
    local t5 = {}

    for _, descendant in HoverIcon:GetDescendants() do
        if descendant:IsA("ImageLabel") then
            table.insert(t4, descendant)
            table.insert(t5, descendant.ImageTransparency)
        end
    end

    local t6 = {
        p = 0,
        phase = 0,
        press = 1,
        on = false,
        hovered = false,
        selected = false,
        pressed = false,
        running = false,
        dead = false,
        card = p21,
        idle = IdleIcon,
        hover = HoverIcon,
        fx = t4,
        fxAlpha = t5,
        idleAlpha = IdleIcon.ImageTransparency,
        hoverAlpha = HoverIcon.ImageTransparency,
        cardSize = p21.Size,
        cardZ = p21.ZIndex,
        idlePos = IdleIcon.Position,
        idleSize = IdleIcon.Size,
        hoverPos = HoverIcon.Position,
        hoverSize = HoverIcon.Size,
        update = updateCard
    }

    HoverIcon.ZIndex = 999
    HoverIcon.Active = false
    restCard(t6)
    p21.MouseEnter:Connect(function() -- line: 291
        -- upvalues: t6 (copy), RunService (copy), SoundService (copy), t1 (copy), ParentParent (copy), t2 (copy), v1 (ref), frame (copy), t3 (copy), updateCard (copy)
        t6.hovered = true

        local v34 = t3["rbxassetid://90736891527931"]

        if not v34 then
            v34 = Instance.new("Sound")
            v34.Name = t1["rbxassetid://90736891527931"] or "ChooseTeam_SFX"
            v34.SoundId = "rbxassetid://90736891527931"
            v34.Volume = 0.5
            v34.Parent = SoundService
            t3["rbxassetid://90736891527931"] = v34
        end

        v34.TimePosition = 0
        v34:Play()

        local hovered = t6.hovered
        local selected = if not hovered then t6.selected else nil

        if hovered or selected then
            selected = ParentParent.Enabled
        end

        if t6.on ~= selected then
            t6.on = selected

            if selected then
                updateCard(t6, 0)
                t6.hover.Visible = true
                t6.card.ZIndex = 100
            end
        end

        if t6.running or t6.dead then
            return
        end

        t6.running = true
        table.insert(t2, t6)
        v1 = v1 or RunService.PreRender:Connect(frame)
    end)
    p21.MouseLeave:Connect(function() -- line: 297
        -- upvalues: t6 (copy), RunService (copy), ParentParent (copy), t2 (copy), v1 (ref), frame (copy), updateCard (copy)
        t6.hovered = false
        t6.pressed = false

        local hovered = t6.hovered
        local selected = if not hovered then t6.selected else nil

        if hovered or selected then
            selected = ParentParent.Enabled
        end

        if t6.on ~= selected then
            t6.on = selected

            if selected then
                updateCard(t6, 0)
                t6.hover.Visible = true
                t6.card.ZIndex = 100
            end
        end

        if t6.running or t6.dead then
            return
        end

        t6.running = true
        table.insert(t2, t6)
        v1 = v1 or RunService.PreRender:Connect(frame)
    end)
    p21.MouseButton1Down:Connect(function() -- line: 303
        -- upvalues: t6 (copy), RunService (copy), t2 (copy), v1 (ref), frame (copy)
        t6.pressed = true

        if t6.running or t6.dead then
            return
        end

        t6.running = true
        table.insert(t2, t6)
        v1 = v1 or RunService.PreRender:Connect(frame)
    end)
    p21.MouseButton1Up:Connect(function() -- line: 308
        -- upvalues: t6 (copy), RunService (copy), t2 (copy), v1 (ref), frame (copy)
        t6.pressed = false

        if t6.running or t6.dead then
            return
        end

        t6.running = true
        table.insert(t2, t6)
        v1 = v1 or RunService.PreRender:Connect(frame)
    end)
    p21.TouchTap:Connect(function() -- line: 313
        -- upvalues: t6 (copy), RunService (copy), t2 (copy), v1 (ref), frame (copy)
        t6.pressed = false

        if t6.running or t6.dead then
            return
        end

        t6.running = true
        table.insert(t2, t6)
        v1 = v1 or RunService.PreRender:Connect(frame)
    end)
    p21.Destroying:Connect(function() -- line: 129
        -- upvalues: t6 (copy)
        t6.dead = true
    end)

    return t6
end

local function updateStroke(p22, p23) -- line: 326
    if p22.on then
        p22.p = math.min(1, p22.p + p23 / 0.26)
    else
        p22.p = math.max(0, p22.p - p23 / 0.18)
    end

    local p = p22.p

    if not (p <= 0) or p22.on then
        local v37

        if p22.on then
            local v38 = p - 1

            v37 = v38 * 2.70158 * v38 * v38 + 1 + v38 * 1.70158 * v38
        else
            local v39 = 1 - p

            v37 = 1 - v39 * v39
        end

        p22.stroke.Enabled = true
        p22.stroke.Thickness = math.max(0, p22.thickness * v37)
        p22.stroke.Transparency = p22.transparency + (1 - p22.transparency) * (1 - p)

        return true
    end

    p22.stroke.Enabled = false
    p22.stroke.Thickness = p22.thickness
    p22.stroke.Transparency = p22.transparency

    return false
end

local function setupStroke(p24) -- line: 342
    -- upvalues: updateStroke (copy)
    local StrokeHolder = p24:FindFirstChild("StrokeHolder")
    local SelectedUIStroke = StrokeHolder and StrokeHolder:FindFirstChild("SelectedUIStroke")

    if SelectedUIStroke and SelectedUIStroke:IsA("UIStroke") then
        local t7 = {
            p = 0,
            on = false,
            running = false,
            dead = false,
            stroke = SelectedUIStroke,
            thickness = SelectedUIStroke.Thickness,
            transparency = SelectedUIStroke.Transparency,
            update = updateStroke
        }

        SelectedUIStroke.Enabled = false
        p24.Destroying:Connect(function() -- line: 129
            -- upvalues: t7 (copy)
            t7.dead = true
        end)

        return t7
    end

    return nil
end

local t8 = {}
local t9 = {}
local v41

local function select(p25) -- line: 374
    -- upvalues: RunService (copy), SoundService (copy), t1 (copy), ParentParent (copy), t2 (copy), v1 (ref), frame (copy), t3 (copy), updateCard (copy), t8 (copy), t9 (copy), v41 (ref)
    v41 = if v41 == p25 then nil else p25

    local v42 = if v41 then "rbxassetid://135310337267680" else "rbxassetid://91838958509194"
    local v43 = t3[v42]

    if not v43 then
        v43 = Instance.new("Sound")
        v43.Name = t1[v42] or "ChooseTeam_SFX"
        v43.SoundId = v42
        v43.Volume = 0.5
        v43.Parent = SoundService
        t3[v42] = v43
    end

    v43.TimePosition = 0
    v43:Play()

    for v44, v45 in t9 do
        local v46 = v44 == v41

        if v45.on ~= v46 then
            v45.on = v46

            if not v45.running and not v45.dead then
                v45.running = true
                table.insert(t2, v45)
                v1 = v1 or RunService.PreRender:Connect(frame)
            end
        end
    end

    for v47, v48 in t8 do
        v48.selected = v47 == v41

        local selected = if v48.hovered then ParentParent.Enabled else v48.selected and ParentParent.Enabled

        if v48.on ~= selected then
            v48.on = selected

            if selected then
                updateCard(v48, 0)
                v48.hover.Visible = true
                v48.card.ZIndex = 100
            end
        end

        if not v48.running and not v48.dead then
            v48.running = true
            table.insert(t2, v48)
            v1 = v1 or RunService.PreRender:Connect(frame)
        end
    end
end

local TeamHolder = Main:FindFirstChild("TeamHolder")

if TeamHolder then
    for _, child in TeamHolder:GetChildren() do
        if child:IsA("ImageButton") then
            local v49 = setupCard(child)

            if v49 then
                t8[child] = v49
            end

            local v50 = setupStroke(child)

            if v50 then
                t9[child] = v50
            end

            child.Active = true
            child.Activated:Connect(function() -- line: 409
                -- upvalues: select (copy), child (copy)
                select(child)
            end)
        end
    end
end

ParentParent:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 418
    -- upvalues: RunService (copy), ParentParent (copy), t2 (copy), v1 (ref), frame (copy), updateCard (copy), t8 (copy)
    for _, v51 in t8 do
        if not ParentParent.Enabled then
            v51.hovered = false
            v51.pressed = false
        end

        local selected = if v51.hovered then ParentParent.Enabled else v51.selected and ParentParent.Enabled

        if v51.on ~= selected then
            v51.on = selected

            if selected then
                updateCard(v51, 0)
                v51.hover.Visible = true
                v51.card.ZIndex = 100
            end
        end

        if not v51.running and not v51.dead then
            v51.running = true
            table.insert(t2, v51)
            v1 = v1 or RunService.PreRender:Connect(frame)
        end
    end
end)
