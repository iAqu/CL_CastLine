-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loc = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Loc"))
local t1 = {}
local t2 = {
    FROM = 2,
    R0 = 0.63,
    R1 = 0.74,
    LIFE = 0.75,
    FADE_AT = 0.35,
    GROW = 0.08,
    GROW_MAX = 1.4,
    ALIVE = 3,
    POP = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}
local n1 = 0
local n2 = 0
local n3 = 0
local t3 = {}

local function float(p1, p2, p3, p4) -- line: 33
    -- upvalues: TweenService (copy), Loc (copy), t2 (copy), t3 (copy)
    local v2 = p1 and p1.Circle:FindFirstChild("ComboFloat")

    if not v2 then
        return
    end

    if #t3 >= t2.ALIVE then
        local v3 = table.remove(t3, 1)

        if v3.Parent then
            v3:Destroy()
        end
    end

    local clone = v2:Clone()

    clone.Name = "Combo"
    clone.Streak.Text = Loc.F("reel.combo_streak", "{n} IN A ROW", {
        n = tostring(p3)
    })
    clone.Word.Text = Loc.F("reel.combo_xp", "+{xp} XP", {
        xp = tostring(p4)
    })

    local v4 = math.rad(p2)

    local function at(p5) -- line: 45
        -- upvalues: v4 (copy)
        return UDim2.fromScale(0.5 + math.sin(v4) * p5, 0.5 - math.cos(v4) * p5)
    end

    local R0 = t2.R0

    clone.Position = UDim2.fromScale(0.5 + math.sin(v4) * R0, 0.5 - math.cos(v4) * R0)
    clone.Visible = true
    clone.Pop.Scale = 0
    clone.Parent = p1.Circle
    t3[#t3 + 1] = clone

    local v6 = math.min(t2.GROW_MAX, 1 + t2.GROW * (p3 - t2.FROM))

    TweenService:Create(clone.Pop, t2.POP, {
        Scale = v6
    }):Play()

    local v7 = TweenInfo.new(t2.LIFE, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local R1 = t2.R1

    TweenService:Create(clone, v7, {
        Position = UDim2.fromScale(0.5 + math.sin(v4) * R1, 0.5 - math.cos(v4) * R1)
    }):Play()

    local v8 = TweenInfo.new(t2.LIFE - t2.FADE_AT, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, t2.FADE_AT)

    for _, v9 in ipairs({
            clone.Word,
            clone.Streak
        }) do
        TweenService:Create(v9, v8, {
            TextTransparency = 1
        }):Play()
        TweenService:Create(v9.UIStroke, v8, {
            Transparency = 1
        }):Play()
    end

    task.delay(t2.LIFE + 0.05, function() -- line: 59
        -- upvalues: clone (copy), t3 (copy)
        local v10 = table.find(t3, clone)

        if v10 then
            table.remove(t3, v10)
        end

        if clone.Parent then
            clone:Destroy()
        end
    end)
end

function t1.Msg(p6, p7, p8) -- line: 67
    -- upvalues: n1 (ref), n2 (ref), n3 (ref)
    if p7 then
        local v11 = p6.combo or 0
        local v12 = p6.comboStep or 0
        local v13 = p6.comboLeft or 0

        n1 = v11
        n2 = v12
        n3 = v13
    elseif p8 and type(p6.combo) == "number" then
        n1 = p6.combo

        if type(p6.comboLeft) == "number" then
            n3 = p6.comboLeft
        end
    end
end

function t1.Hit(p9, p10, p11, p12) -- line: 78
    -- upvalues: t2 (copy), n1 (ref), n2 (ref), n3 (ref), float (copy)
    if n2 <= 0 then
        return
    end

    local v14 = if p10.v1 < 0 then -1 else 1
    local v15 = (p10.arcCenter - p10.angle0) * v14 % 360

    n1 = if math.abs(p10.v1) * math.max(0, p11 - p10.time0) > v15 + 180 then 1 else n1 + 1

    if n1 < t2.FROM or n3 <= 0 then
        return
    end

    local v19 = n3
    local v21 = n2
    local v22 = n1
    local v25 = math.min(v19, (math.max(1, (math.round(v21 * (v22 - t2.FROM + 1))))))

    n3 -= v25
    float(p9, p12, n1, v25)
end

function t1.Miss() -- line: 91
    -- upvalues: n1 (ref)
    n1 = 0
end

return t1
