-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local GUI = require(ReplicatedStorage.Client.GUI)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local t1 = {
    LightTeam = "Light",
    DarkTeam = "Darkness"
}
local t2 = {
    ["rbxassetid://90736891527931"] = "ChooseTeam_Hover",
    ["rbxassetid://135310337267680"] = "ChooseTeam_Select",
    ["rbxassetid://91838958509194"] = "ChooseTeam_Deselect"
}
local LocalPlayer = Players.LocalPlayer
local v1, TeamSelection
local t3 = {}
local t4 = {}
local t5 = {}
local v2
local t6 = {}
local t7 = {}
local v3
local v4 = false
local n1 = 0

local function easeOutBack(p1) -- line: 104
    local v5 = p1 - 1

    return v5 * 2.70158 * v5 * v5 + 1 + v5 * 1.70158 * v5
end

local function easeOutQuad(p2) -- line: 111
    local v6 = 1 - p2

    return 1 - v6 * v6
end

local function grown(p3, p4) -- line: 117
    return UDim2.new(p3.X.Scale * p4, p3.X.Offset * p4, p3.Y.Scale * p4, p3.Y.Offset * p4)
end

local function raised(p5, p6) -- line: 124
    return UDim2.new(p5.X.Scale, p5.X.Offset, p5.Y.Scale + p6, p5.Y.Offset)
end

local function advance(p7, p8, p9, p10) -- line: 128
    if p7.on then
        p7.p = math.min(1, p7.p + p8 / p9)
    else
        p7.p = math.max(0, p7.p - p8 / p10)
    end

    return p7.p
end

local function frame(p11) -- line: 138
    -- upvalues: t7 (copy), v3 (ref)
    local v9 = if p11 > 0.1 then 0.1 else p11

    for i = #t7, 1, -1 do
        local v10 = t7[i]

        if v10.dead or not v10.update(v10, v9) then
            v10.running = false
            table.remove(t7, i)
        end
    end

    if #t7 == 0 and v3 then
        v3:Disconnect()
        v3 = nil
    end
end

local function wake(p12) -- line: 155
    -- upvalues: RunService (copy), t7 (copy), v3 (ref), frame (copy)
    if p12.running or p12.dead then
        return
    end

    p12.running = true
    table.insert(t7, p12)
    v3 = v3 or RunService.PreRender:Connect(frame)
end

local function play(p13) -- line: 167
    -- upvalues: SoundService (copy), t2 (copy), t6 (copy)
    local v11 = t6[p13]

    if v11 == nil then
        v11 = Instance.new("Sound")
        v11.Name = t2[p13] or "ChooseTeam_SFX"
        v11.SoundId = p13
        v11.Volume = 0.5
        v11.Parent = SoundService
        t6[p13] = v11
    end

    v11.TimePosition = 0
    v11:Play()
end

local function restCard(p14) -- line: 181
    p14.card.Size = p14.cardSize
    p14.card.ZIndex = p14.cardZ
    p14.hover.Visible = false
    p14.hover.Position = p14.idlePos
    p14.hover.Size = p14.idleSize
    p14.hover.ImageTransparency = p14.hoverAlpha
    p14.idle.ImageTransparency = p14.idleAlpha

    for v12, v13 in p14.fx do
        v13.ImageTransparency = p14.fxAlpha[v12]
    end

    p14.phase = 0
    p14.press = 1
end

local function updateCard(p15, p16) -- line: 196
    -- upvalues: restCard (copy)
    if p15.on then
        p15.p = math.min(1, p15.p + p16 / 0.22)
    else
        p15.p = math.max(0, p15.p - p16 / 0.16)
    end

    local p = p15.p
    local v16 = if p15.pressed then 0.95 else 1

    p15.press = p15.press + (v16 - p15.press) * (1 - math.exp(-p16 / 0.09))

    local v20 = math.abs(p15.press - 1) > 0.001

    if not v20 then
        p15.press = 1
    end

    if p <= 0 and not p15.on and not v20 then
        restCard(p15)

        return false
    end

    local v21

    if p15.on then
        local v22 = p - 1

        v21 = v22 * 2.70158 * v22 * v22 + 1 + v22 * 1.70158 * v22
    else
        local v23 = 1 - p

        v21 = 1 - v23 * v23
    end

    local card, cardSize = p15.card, p15.cardSize
    local v24 = (v21 * 0.050000000000000044 + 1) * p15.press

    card.Size = UDim2.new(cardSize.X.Scale * v24, cardSize.X.Offset * v24, cardSize.Y.Scale * v24, cardSize.Y.Offset * v24)
    p15.phase = (p15.phase + p16 * 0.9 * 6.283185307179586) % 6.283185307179586

    local v25 = math.sin(p15.phase)
    local hover = p15.hover
    local v26 = p15.idlePos:Lerp(p15.hoverPos, v21)
    local v27 = v25 * 0.014 * v21

    hover.Position = UDim2.new(v26.X.Scale, v26.X.Offset, v26.Y.Scale + v27, v26.Y.Offset)

    local hover2 = p15.hover
    local v28 = p15.idleSize:Lerp(p15.hoverSize, v21)
    local v29 = v25 * 0.012 * v21 + 1

    hover2.Size = UDim2.new(v28.X.Scale * v29, v28.X.Offset * v29, v28.Y.Scale * v29, v28.Y.Offset * v29)

    local v31 = math.min(1, p * 1.35)

    p15.hover.ImageTransparency = p15.hoverAlpha + (1 - p15.hoverAlpha) * (1 - v31)
    p15.idle.ImageTransparency = p15.idleAlpha + (1 - p15.idleAlpha) * v31

    for v32, v33 in p15.fx do
        local v34 = p15.fxAlpha[v32]

        v33.ImageTransparency = v34 + (1 - v34) * (1 - v31)
    end

    return true
end

local function panelShown() -- line: 232
    -- upvalues: TeamSelection (ref)
    local TeamSelection2 = TeamSelection

    return TeamSelection2 ~= nil and TeamSelection2.Visible
end

local function refreshCard(p17) -- line: 238
    -- upvalues: RunService (copy), TeamSelection (ref), t7 (copy), v3 (ref), frame (copy), updateCard (copy)
    local hovered = p17.hovered
    local selected = if not hovered then p17.selected else nil

    if hovered or selected then
        local TeamSelection2 = TeamSelection

        selected = TeamSelection2 ~= nil and TeamSelection2.Visible
    end

    if p17.on ~= selected then
        p17.on = selected

        if selected then
            updateCard(p17, 0)
            p17.hover.Visible = true
            p17.card.ZIndex = 100
        end
    end

    if p17.running or p17.dead then
        return
    end

    p17.running = true
    table.insert(t7, p17)
    v3 = v3 or RunService.PreRender:Connect(frame)
end

local function updateStroke(p18, p19) -- line: 255
    if p18.on then
        p18.p = math.min(1, p18.p + p19 / 0.26)
    else
        p18.p = math.max(0, p18.p - p19 / 0.18)
    end

    local p = p18.p

    if not (p <= 0) or p18.on then
        local v37

        if p18.on then
            local v38 = p - 1

            v37 = v38 * 2.70158 * v38 * v38 + 1 + v38 * 1.70158 * v38
        else
            local v39 = 1 - p

            v37 = 1 - v39 * v39
        end

        p18.stroke.Enabled = true
        p18.stroke.Thickness = math.max(0, p18.thickness * v37)
        p18.stroke.Transparency = p18.transparency + (1 - p18.transparency) * (1 - p)

        return true
    end

    p18.stroke.Enabled = false
    p18.stroke.Thickness = p18.thickness
    p18.stroke.Transparency = p18.transparency

    return false
end

local function select(p20) -- line: 271
    -- upvalues: RunService (copy), SoundService (copy), t2 (copy), TeamSelection (ref), t4 (copy), t5 (copy), v2 (ref), t6 (copy), t7 (copy), v3 (ref), frame (copy), updateCard (copy)
    v2 = if v2 == p20 then nil else p20

    local v41 = if v2 then "rbxassetid://135310337267680" else "rbxassetid://91838958509194"
    local v42 = t6[v41]

    if v42 == nil then
        v42 = Instance.new("Sound")
        v42.Name = t2[v41] or "ChooseTeam_SFX"
        v42.SoundId = v41
        v42.Volume = 0.5
        v42.Parent = SoundService
        t6[v41] = v42
    end

    v42.TimePosition = 0
    v42:Play()

    for v43, v44 in t5 do
        local v45 = v43 == v2

        if v44.on ~= v45 then
            v44.on = v45

            if not v44.running and not v44.dead then
                v44.running = true
                table.insert(t7, v44)
                v3 = v3 or RunService.PreRender:Connect(frame)
            end
        end
    end

    for v46, v47 in t4 do
        v47.selected = v46 == v2

        local selected

        if v47.hovered then
            local TeamSelection2 = TeamSelection

            selected = TeamSelection2 ~= nil and TeamSelection2.Visible
        else
            selected = v47.selected

            if selected then
                local TeamSelection2 = TeamSelection

                selected = TeamSelection2 ~= nil and TeamSelection2.Visible
            end
        end

        if v47.on ~= selected then
            v47.on = selected

            if selected then
                updateCard(v47, 0)
                v47.hover.Visible = true
                v47.card.ZIndex = 100
            end
        end

        if not v47.running and not v47.dead then
            v47.running = true
            table.insert(t7, v47)
            v3 = v3 or RunService.PreRender:Connect(frame)
        end
    end
end

local function cardParts(p21) -- line: 287
    local IdleIcon = p21:FindFirstChild("IdleIcon")
    local HoverIcon = p21:FindFirstChild("HoverIcon")

    assert(IdleIcon and IdleIcon:IsA("ImageLabel") and HoverIcon and HoverIcon:IsA("ImageLabel"), (("%* needs an IdleIcon and a HoverIcon"):format((p21:GetFullName()))))

    local StrokeHolder = p21:FindFirstChild("StrokeHolder")
    local SelectedUIStroke = if StrokeHolder then StrokeHolder:FindFirstChild("SelectedUIStroke") else nil

    assert(SelectedUIStroke and SelectedUIStroke:IsA("UIStroke"), (("%* needs a StrokeHolder.SelectedUIStroke"):format((p21:GetFullName()))))

    return IdleIcon, HoverIcon, SelectedUIStroke
end

local function authoredFor(p22) -- line: 300
    -- upvalues: t3 (copy), cardParts (copy)
    local v52 = t3[p22]

    if v52 then
        return v52
    end

    local v53, v54, v55 = cardParts(p22)
    local t8 = {}

    for _, descendant in v54:GetDescendants() do
        if descendant:IsA("ImageLabel") then
            t8[descendant] = descendant.ImageTransparency
        end
    end

    local t9 = {
        CardSize = p22.Size,
        CardZ = p22.ZIndex,
        IdleAlpha = v53.ImageTransparency,
        IdlePos = v53.Position,
        IdleSize = v53.Size,
        HoverAlpha = v54.ImageTransparency,
        HoverPos = v54.Position,
        HoverSize = v54.Size,
        FxAlpha = t8,
        StrokeThickness = v55.Thickness,
        StrokeTransparency = v55.Transparency
    }

    t3[p22] = t9

    return t9
end

local function setupCard(p23, p24) -- line: 329
    -- upvalues: RunService (copy), SoundService (copy), t2 (copy), TeamSelection (ref), t6 (copy), t7 (copy), v3 (ref), frame (copy), restCard (copy), updateCard (copy), select (copy), cardParts (copy), authoredFor (copy)
    local v56, v57 = cardParts(p23)
    local v58 = authoredFor(p23)
    local t10 = {}
    local t11 = {}

    for _, descendant in v57:GetDescendants() do
        if descendant:IsA("ImageLabel") then
            table.insert(t10, descendant)
            table.insert(t11, v58.FxAlpha[descendant] or descendant.ImageTransparency)
        end
    end

    local t12 = {
        p = 0,
        phase = 0,
        press = 1,
        on = false,
        hovered = false,
        selected = false,
        pressed = false,
        running = false,
        dead = false,
        card = p23,
        idle = v56,
        hover = v57,
        fx = t10,
        fxAlpha = t11,
        idleAlpha = v58.IdleAlpha,
        hoverAlpha = v58.HoverAlpha,
        cardSize = v58.CardSize,
        cardZ = v58.CardZ,
        idlePos = v58.IdlePos,
        idleSize = v58.IdleSize,
        hoverPos = v58.HoverPos,
        hoverSize = v58.HoverSize,
        update = updateCard
    }

    v57.ZIndex = 999
    v57.Active = false
    restCard(t12)
    p24:Connect(p23.MouseEnter, function() -- line: 373
        -- upvalues: t12 (copy), RunService (copy), SoundService (copy), t2 (copy), TeamSelection (ref), t6 (copy), t7 (copy), v3 (ref), frame (copy), updateCard (copy)
        t12.hovered = true

        local v60 = t6["rbxassetid://90736891527931"]

        if v60 == nil then
            v60 = Instance.new("Sound")
            v60.Name = t2["rbxassetid://90736891527931"] or "ChooseTeam_SFX"
            v60.SoundId = "rbxassetid://90736891527931"
            v60.Volume = 0.5
            v60.Parent = SoundService
            t6["rbxassetid://90736891527931"] = v60
        end

        v60.TimePosition = 0
        v60:Play()

        local hovered = t12.hovered
        local selected = if not hovered then t12.selected else nil

        if hovered or selected then
            local TeamSelection2 = TeamSelection

            selected = TeamSelection2 ~= nil and TeamSelection2.Visible
        end

        if t12.on ~= selected then
            t12.on = selected

            if selected then
                updateCard(t12, 0)
                t12.hover.Visible = true
                t12.card.ZIndex = 100
            end
        end

        if t12.running or t12.dead then
            return
        end

        t12.running = true
        table.insert(t7, t12)
        v3 = v3 or RunService.PreRender:Connect(frame)
    end)
    p24:Connect(p23.MouseLeave, function() -- line: 378
        -- upvalues: t12 (copy), RunService (copy), TeamSelection (ref), t7 (copy), v3 (ref), frame (copy), updateCard (copy)
        t12.hovered = false
        t12.pressed = false

        local hovered = t12.hovered
        local selected = if not hovered then t12.selected else nil

        if hovered or selected then
            local TeamSelection2 = TeamSelection

            selected = TeamSelection2 ~= nil and TeamSelection2.Visible
        end

        if t12.on ~= selected then
            t12.on = selected

            if selected then
                updateCard(t12, 0)
                t12.hover.Visible = true
                t12.card.ZIndex = 100
            end
        end

        if t12.running or t12.dead then
            return
        end

        t12.running = true
        table.insert(t7, t12)
        v3 = v3 or RunService.PreRender:Connect(frame)
    end)
    p24:Connect(p23.MouseButton1Down, function() -- line: 383
        -- upvalues: t12 (copy), RunService (copy), t7 (copy), v3 (ref), frame (copy)
        t12.pressed = true

        if t12.running or t12.dead then
            return
        end

        t12.running = true
        table.insert(t7, t12)
        v3 = v3 or RunService.PreRender:Connect(frame)
    end)
    p24:Connect(p23.MouseButton1Up, function() -- line: 387
        -- upvalues: t12 (copy), RunService (copy), t7 (copy), v3 (ref), frame (copy)
        t12.pressed = false

        if t12.running or t12.dead then
            return
        end

        t12.running = true
        table.insert(t7, t12)
        v3 = v3 or RunService.PreRender:Connect(frame)
    end)
    p24:Connect(p23.TouchTap, function() -- line: 391
        -- upvalues: t12 (copy), RunService (copy), t7 (copy), v3 (ref), frame (copy)
        t12.pressed = false

        if t12.running or t12.dead then
            return
        end

        t12.running = true
        table.insert(t7, t12)
        v3 = v3 or RunService.PreRender:Connect(frame)
    end)
    p23.Active = true
    p24:Connect(p23.Activated, function() -- line: 397
        -- upvalues: p23 (copy), select (copy)
        select(p23)
    end)

    return t12
end

local function setupStroke(p25) -- line: 403
    -- upvalues: updateStroke (copy), cardParts (copy), authoredFor (copy)
    local _, _, v61 = cardParts(p25)
    local v62 = authoredFor(p25)
    local t13 = {
        p = 0,
        on = false,
        running = false,
        dead = false,
        stroke = v61,
        thickness = v62.StrokeThickness,
        transparency = v62.StrokeTransparency,
        update = updateStroke
    }

    v61.Enabled = false

    return t13
end

local function hasTeam() -- line: 420
    -- upvalues: LocalPlayer (copy)
    return type(LocalPlayer:GetAttribute("LvdTeam")) == "string"
end

local function autoPick(p26) -- line: 426
    -- upvalues: Remotes (copy), t1 (copy), LocalPlayer (copy), TeamSelection (ref), v2 (ref), v4 (ref), n1 (ref)
    local v63 = v2

    if p26 == n1 and v4 then
        local TeamSelection2 = TeamSelection

        if TeamSelection2 ~= nil and TeamSelection2.Visible and type(LocalPlayer:GetAttribute("LvdTeam")) ~= "string" then
            Remotes.LightVsDarkness.AskSelectTeam:FireServer(if v63 then t1[v63.Name] else "Random")
        end
    end
end

local function setPanelShown(p27) -- line: 435
    -- upvalues: RunService (copy), TeamSelection (ref), t4 (copy), t7 (copy), v3 (ref), n1 (ref), frame (copy), updateCard (copy), autoPick (copy)
    local TeamSelection2 = TeamSelection

    if TeamSelection2 == nil or TeamSelection2.Visible == p27 then
        return
    end

    TeamSelection2.Visible = p27
    n1 += 1

    if p27 then
        task.delay(20, autoPick, n1)
    end

    for _, v64 in t4 do
        if not p27 then
            v64.hovered = false
            v64.pressed = false
        end

        local selected

        if v64.hovered then
            local TeamSelection2 = TeamSelection

            selected = TeamSelection2 ~= nil and TeamSelection2.Visible
        else
            selected = v64.selected

            if selected then
                local TeamSelection2 = TeamSelection

                selected = TeamSelection2 ~= nil and TeamSelection2.Visible
            end
        end

        if v64.on ~= selected then
            v64.on = selected

            if selected then
                updateCard(v64, 0)
                v64.hover.Visible = true
                v64.card.ZIndex = 100
            end
        end

        if not v64.running and not v64.dead then
            v64.running = true
            table.insert(t7, v64)
            v3 = v3 or RunService.PreRender:Connect(frame)
        end
    end
end

local function confirm() -- line: 454
    -- upvalues: Remotes (copy), t1 (copy), LocalPlayer (copy), v2 (ref), v4 (ref)
    local v65 = v2

    if v4 and v65 ~= nil then
        local v66 = type(LocalPlayer:GetAttribute("LvdTeam")) == "string"

        if not v66 then
            Remotes.LightVsDarkness.AskSelectTeam:FireServer(t1[v65.Name])
        end
    end
end

local function refresh() -- line: 464
    -- upvalues: LocalPlayer (copy), v4 (ref), setPanelShown (copy)
    setPanelShown(v4 and type(LocalPlayer:GetAttribute("LvdTeam")) ~= "string")
end

local function start() -- line: 468
    -- upvalues: RunService (copy), GUI (copy), t1 (copy), LocalPlayer (copy), v1 (ref), TeamSelection (ref), t4 (copy), t5 (copy), v2 (ref), t6 (copy), t7 (copy), v3 (ref), v4 (ref), n1 (ref), frame (copy), restCard (copy), updateCard (copy), setupCard (copy), setupStroke (copy), setPanelShown (copy), confirm (copy), refresh (copy)
    local AssetTrove = v1.AssetTrove
    local TeamSelection2 = GUI.LightVsDarknessUI():FindFirstChild("TeamSelection")

    assert(TeamSelection2 and TeamSelection2:IsA("Frame"), "LightVsDarknessUI.TeamSelection must be a Frame")
    TeamSelection = TeamSelection2
    v4 = true
    v2 = nil
    table.clear(t4)
    table.clear(t5)

    local TeamHolder = TeamSelection2:FindFirstChild("TeamHolder")

    assert(TeamHolder, "TeamSelection.TeamHolder is missing")

    for _, child in TeamHolder:GetChildren() do
        if child:IsA("ImageButton") and t1[child.Name] ~= nil then
            t4[child] = setupCard(child, AssetTrove)
            t5[child] = setupStroke(child)
        end
    end

    local ConfirmBTN = TeamSelection2:FindFirstChild("ConfirmBTN")

    assert(ConfirmBTN and ConfirmBTN:IsA("ImageButton"), "TeamSelection.ConfirmBTN must be an ImageButton")
    GUI.OnActivated(ConfirmBTN, confirm)
    AssetTrove:Connect(LocalPlayer:GetAttributeChangedSignal("LvdTeam"), refresh)
    AssetTrove:Add(function() -- line: 493
        -- upvalues: RunService (copy), TeamSelection (ref), t4 (copy), t5 (copy), v2 (ref), t6 (copy), t7 (copy), v3 (ref), v4 (ref), n1 (ref), frame (copy), restCard (copy), updateCard (copy)
        v4 = false

        local TeamSelection2 = TeamSelection

        if TeamSelection2 ~= nil and TeamSelection2.Visible ~= false then
            TeamSelection2.Visible = false
            n1 += 1

            for _, v70 in t4 do
                v70.hovered = false
                v70.pressed = false

                local selected

                if v70.hovered then
                    local TeamSelection2 = TeamSelection

                    selected = TeamSelection2 ~= nil and TeamSelection2.Visible
                else
                    selected = v70.selected

                    if selected then
                        local TeamSelection2 = TeamSelection

                        selected = TeamSelection2 ~= nil and TeamSelection2.Visible
                    end
                end

                if v70.on ~= selected then
                    v70.on = selected

                    if selected then
                        updateCard(v70, 0)
                        v70.hover.Visible = true
                        v70.card.ZIndex = 100
                    end
                end

                if not v70.running and not v70.dead then
                    v70.running = true
                    table.insert(t7, v70)
                    v3 = v3 or RunService.PreRender:Connect(frame)
                end
            end
        end

        for _, v71 in t4 do
            v71.dead = true
            restCard(v71)
        end

        for _, v72 in t5 do
            v72.dead = true
            v72.stroke.Enabled = false
            v72.stroke.Thickness = v72.thickness
            v72.stroke.Transparency = v72.transparency
        end

        table.clear(t4)
        table.clear(t5)
        v2 = nil

        if v3 then
            v3:Disconnect()
            v3 = nil
        end

        table.clear(t7)

        for _, v73 in t6 do
            v73:Destroy()
        end

        table.clear(t6)
    end)
    setPanelShown(v4 and type(LocalPlayer:GetAttribute("LvdTeam")) ~= "string")
end

local function stop() -- line: 524
    -- upvalues: RunService (copy), TeamSelection (ref), t4 (copy), t7 (copy), v3 (ref), v4 (ref), n1 (ref), frame (copy), updateCard (copy)
    v4 = false

    local TeamSelection2 = TeamSelection

    if TeamSelection2 == nil or TeamSelection2.Visible == false then
        return
    end

    TeamSelection2.Visible = false
    n1 += 1

    for _, v75 in t4 do
        v75.hovered = false
        v75.pressed = false

        local selected

        if v75.hovered then
            local TeamSelection2 = TeamSelection

            selected = TeamSelection2 ~= nil and TeamSelection2.Visible
        else
            selected = v75.selected

            if selected then
                local TeamSelection2 = TeamSelection

                selected = TeamSelection2 ~= nil and TeamSelection2.Visible
            end
        end

        if v75.on ~= selected then
            v75.on = selected

            if selected then
                updateCard(v75, 0)
                v75.hover.Visible = true
                v75.card.ZIndex = 100
            end
        end

        if not v75.running and not v75.dead then
            v75.running = true
            table.insert(t7, v75)
            v3 = v3 or RunService.PreRender:Connect(frame)
        end
    end
end

return function(p28) -- line: 531
    -- upvalues: v1 (ref), start (copy), stop (copy)
    v1 = p28

    return {
        Start = start,
        Stop = stop
    }
end
