-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local t1 = {
    RAYS = "rbxassetid://86205314584043"
}
local t2 = {}
local v1, v2
local elapsed = os.clock()

local function pageOf(p1) -- line: 20
    while true do
        if not p1 then
            return false
        end

        if p1:GetAttribute("ShopPage") then
            break
        end

        p1 = p1.Parent
    end

    return p1
end

local function add(p2, p3) -- line: 31
    -- upvalues: t2 (copy)
    table.insert(t2, {
        obj = p2,
        step = p3
    })
end

local function inView(p4, p5, p6) -- line: 36
    local v4 = if p4:IsA("GuiObject") then p4 else p4.Parent

    if v4 and v4:IsA("GuiObject") then
        local Y = v4.AbsolutePosition.Y

        if Y < p6 then
            return p5 < Y + v4.AbsoluteSize.Y
        end

        return false
    end

    return true
end

local function update(p7) -- line: 45
    -- upvalues: t2 (copy), v1 (ref), elapsed (copy)
    local v5 = os.clock() - elapsed
    local v6, v7

    if v1 then
        v7 = v1.AbsolutePosition.Y - 60
        v6 = v1.AbsolutePosition.Y + v1.AbsoluteSize.Y + 60
    else
        v7 = 0
        v6 = 0
    end

    for i = #t2, 1, -1 do
        local v8 = t2[i]

        if v8.obj.Parent then
            if v8.page == nil then
                local v9 = v8.obj

                while true do
                    if v9 then
                        if v9:GetAttribute("ShopPage") then
                            break
                        end

                        v9 = v9.Parent
                        continue
                    end

                    v9 = false
                    break
                end

                v8.page = v9
            end

            local v10 = true

            if v8.page == false then
                v10 = false
            elseif v8.page == v1 then
                local obj = v8.obj

                if not obj:IsA("GuiObject") then
                    obj = obj.Parent
                end

                local v11 = true

                if obj and obj:IsA("GuiObject") then
                    local Y = obj.AbsolutePosition.Y

                    v11 = Y < v6 and v7 < Y + obj.AbsoluteSize.Y
                end

                v10 = not v11
            end

            if not v10 then
                v8.step(v5, p7)
            end

            continue
        end

        table.remove(t2, i)
    end
end

function t1.start() -- line: 69
    -- upvalues: RunService (copy), v2 (ref), update (copy)
    v2 = v2 or RunService.RenderStepped:Connect(update)
end

function t1.stop() -- line: 75
    -- upvalues: v2 (ref)
    if v2 then
        v2:Disconnect()
        v2 = nil
    end
end

function t1.setPage(p8) -- line: 82
    -- upvalues: v1 (ref)
    v1 = p8
end

function t1.shine(p9, p10, p11, p12) -- line: 88
    -- upvalues: Kit (copy), t2 (copy)
    local v12 = p10 or 3
    local v13 = p11 or 0
    local v14 = Kit.frame(p9, {
        Name = "Shine",
        Interactable = false,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.fromScale(1, 1),
        ZIndex = p9.ZIndex
    })
    local UICorner = p9:FindFirstChildOfClass("UICorner")

    if UICorner then
        UICorner:Clone().Parent = v14
    end

    local v15 = 1 - (p12 or 0.45)
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 20
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 1),
        NumberSequenceKeypoint.new(0.5, v15),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Offset = Vector2.new(-1, 0)
    UIGradient.Parent = v14
    table.insert(t2, {
        obj = v14,
        step = function(p13) -- line: 113
            -- upvalues: v12 (copy), v13 (copy), UIGradient (copy)
            local v16 = (p13 + v13) % v12 / 0.65

            UIGradient.Offset = Vector2.new(if v16 <= 1 then -1 + 2 * v16 else 1, 0)
        end
    })

    return v14
end

function t1.breathe(p14, p15, p16) -- line: 121
    -- upvalues: UIUtil (copy), t2 (copy)
    UIUtil.centre(p14)

    local Size = p14.Size
    local v18 = p15 or 0.05
    local v19 = p16 or 3

    table.insert(t2, {
        obj = p14,
        step = function(p17) -- line: 125
            -- upvalues: p14 (copy), Size (copy), v18 (copy), v19 (copy)
            local v22 = 1 + v18 * (math.sin(p17 * v19) * 0.5 + 0.5)

            p14.Size = UDim2.new(Size.X.Scale * v22, Size.X.Offset * v22, Size.Y.Scale * v22, Size.Y.Offset * v22)
        end
    })
end

function t1.ping(p18, p19, p20, p21) -- line: 132
    -- upvalues: Kit (copy), t2 (copy)
    local v23 = p20 or 1.6
    local v24 = Kit.frame(p18, {
        Name = "Ping",
        BackgroundTransparency = 1,
        Interactable = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        ZIndex = p18.ZIndex
    })

    Kit.corner(v24, p21 or 14)

    local v25 = Kit.stroke(v24, 4, p19 or Color3.new(1, 1, 1))

    table.insert(t2, {
        obj = v24,
        step = function(p22) -- line: 145
            -- upvalues: v23 (copy), v24 (copy), v25 (copy)
            local v28 = math.min(p22 % v23 / 0.8, 1)
            local v29 = v28 * 28

            v24.Size = UDim2.new(1, v29, 1, v29)
            v25.Thickness = (1 - v28) * 6 + 1
            v25.Transparency = v28 * 0.85 + 0.15
        end
    })
end

function t1.spin(p23, p24) -- line: 155
    -- upvalues: t2 (copy)
    local v30 = p24 or 30

    table.insert(t2, {
        obj = p23,
        step = function(p25) -- line: 157
            -- upvalues: p23 (copy), v30 (copy)
            p23.Rotation = p25 * v30 % 360
        end
    })
end

function t1.rays(p26, p27, p28, p29, p30) -- line: 164
    -- upvalues: Kit (copy), t1 (copy)
    local v32 = Kit.frame(p26, {
        Name = "RaysClip",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Interactable = false,
        Size = UDim2.fromScale(1, 1),
        ZIndex = p30 or p26.ZIndex
    })
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Rays"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = t1.RAYS
    ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
    ImageLabel.ImageTransparency = 0.15
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(p28 or 0.5, p29 or 0.5)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.Size = UDim2.fromScale(p27 or 1.2, p27 or 1.2)
    ImageLabel.ZIndex = p30 or p26.ZIndex
    ImageLabel.Interactable = false
    ImageLabel.Parent = v32
    t1.spin(ImageLabel, 25)

    return ImageLabel
end

function t1.bob(p31, p32, p33, p34) -- line: 191
    -- upvalues: t2 (copy)
    local Position = p31.Position
    local v33 = p32 or 6
    local v34 = p33 or 2.4
    local v35 = p34 or 0

    table.insert(t2, {
        obj = p31,
        step = function(p35) -- line: 194
            -- upvalues: p31 (copy), Position (copy), v33 (copy), v34 (copy), v35 (copy)
            p31.Position = Position + UDim2.fromOffset(0, math.sin(p35 * v34 + v35) * v33)
        end
    })
end

function t1.wiggle(p36, p37, p38, p39) -- line: 200
    -- upvalues: t2 (copy)
    local Rotation = p36.Rotation
    local v38 = p37 or 7
    local v39 = p38 or 2.5
    local v40 = p39 or 0

    table.insert(t2, {
        obj = p36,
        step = function(p40) -- line: 203
            -- upvalues: p36 (copy), Rotation (copy), v38 (copy), v39 (copy), v40 (copy)
            local v42 = (p40 + v40) % v39 / 0.5

            p36.Rotation = Rotation + (if v42 < 1 then math.sin(v42 * 3.141592653589793 * 4) * v38 * (1 - v42) else 0)
        end
    })
end

function t1.turn(p41, p42) -- line: 210
    -- upvalues: t2 (copy)
    local v45 = p42 or 60

    table.insert(t2, {
        obj = p41,
        step = function(p43) -- line: 212
            -- upvalues: p41 (copy), v45 (copy)
            p41.Rotation = p43 * v45 % 360
        end
    })
end

function t1.sparkles(p44, p45, p46, p47, p48) -- line: 218
    -- upvalues: Kit (copy), t2 (copy)
    p46 = p46 or Color3.new(1, 1, 1)

    local v48 = p47 or 26

    for i = 1, p45 or 6 do
        local v49 = Kit.frame(p44, {
            Name = "Sparkle",
            BackgroundTransparency = 1,
            Interactable = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(v48, v48),
            ZIndex = p48 or p44.ZIndex + 1
        })

        for _, v50 in { true, false } do
            local v51 = Kit.frame(v49, {
                BackgroundColor3 = p46,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = if v50 then UDim2.fromScale(1, 0.1) else UDim2.fromScale(0.1, 1),
                ZIndex = v49.ZIndex
            })

            Kit.corner(v51, 4)
        end

        Kit.frame(v49, {
            Rotation = 45,
            BackgroundColor3 = p46,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.34, 0.34),
            ZIndex = v49.ZIndex
        })

        local v52 = 1.1 + math.random() * 0.8
        local v53 = i * 0.37
        local n1 = -1

        table.insert(t2, {
            obj = v49,
            step = function(p49) -- line: 251
                -- upvalues: v48 (copy), v49 (copy), v52 (copy), v53 (copy), n1 (ref)
                local v55 = math.floor((p49 + v53) / v52)

                if v55 ~= n1 then
                    n1 = v55
                    v49.Position = UDim2.fromScale(0.06 + math.random() * 0.88, 0.08 + math.random() * 0.84)
                end

                local v56 = (p49 + v53) % v52 / v52
                local v58 = math.sin(v56 * 3.141592653589793)

                v49.Size = UDim2.fromOffset(v48 * v58, v48 * v58)
                v49.Rotation = v56 * 30
            end
        })
    end
end

function t1.sway(p50, p51, p52, p53) -- line: 267
    -- upvalues: t2 (copy)
    local v60 = math.rad(p51 or 28)
    local v61 = p52 or 0.9
    local Model, Pivot

    table.insert(t2, {
        obj = p50,
        step = function(p54) -- line: 271
            -- upvalues: p50 (copy), p53 (copy), v60 (copy), v61 (copy), Model (ref), Pivot (ref)
            local Model2 = p50:FindFirstChildWhichIsA("Model")

            if not Model2 then
                return
            end

            if Model2 ~= Model then
                local Pivot2 = Model2:GetPivot()

                Model = Model2
                Pivot = Pivot2
            end

            local v63 = if p53 then p54 * v61 else math.sin(p54 * v61) * v60

            Model2:PivotTo(CFrame.new(Pivot.Position) * CFrame.Angles(0, v63, 0) * Pivot.Rotation)
        end
    })
end

function t1.bubbles(p55, p56) -- line: 285
    -- upvalues: Kit (copy), t2 (copy)
    for i = 1, p56 or 14 do
        local v65 = math.random(14, 46)
        local v66 = Kit.frame(p55, {
            Name = "Bubble",
            BackgroundTransparency = 0.9,
            ZIndex = 0,
            Interactable = false,
            BackgroundColor3 = Color3.fromRGB(150, 230, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(v65, v65)
        })
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = v66
        Kit.stroke(v66, 2, Color3.fromRGB(190, 240, 255)).Transparency = 0.6

        local v67 = math.random()
        local v68 = 0.035 + math.random() * 0.05
        local v69 = math.random()

        table.insert(t2, {
            obj = v66,
            step = function(p57) -- line: 305
                -- upvalues: v66 (copy), v67 (copy), v68 (copy), v69 (copy), i (copy)
                local v70 = 1.05 - (v69 + p57 * v68) % 1.1

                v66.Position = UDim2.fromScale(v67 + math.sin(p57 * 1.3 + i) * 0.006, v70)
            end
        })
    end
end

function t1.stagger(p58, p59) -- line: 313
    -- upvalues: UIUtil (copy)
    for v72, v73 in p58 do
        task.delay((v72 - 1) * (p59 or 0.035), function() -- line: 315
            -- upvalues: v73 (copy), UIUtil (copy)
            if v73.Parent then
                UIUtil.pop(v73, 0.8)
            end
        end)
    end
end

function t1.celebrate(p60) -- line: 324
    -- upvalues: Kit (copy)
    local v74 = p60.AbsoluteSize / math.max(p60:FindFirstChild("Scale") and p60.Scale.Scale or 1, 0.01)
    local v75 = v74 / 2

    Kit.flash(p60, Color3.fromRGB(255, 240, 160), 0.45)

    for _, v76 in {
            Color3.fromRGB(255, 210, 60),
            Color3.fromRGB(90, 235, 130),
            Color3.fromRGB(80, 200, 255),
            Color3.fromRGB(255, 104, 112)
        } do
        Kit.burst(p60, v75, v76, 14, v74.X * 0.35)
    end

    Kit.ring(p60, v75, Color3.fromRGB(255, 230, 120), v74.X * 0.6)
end

return t1
