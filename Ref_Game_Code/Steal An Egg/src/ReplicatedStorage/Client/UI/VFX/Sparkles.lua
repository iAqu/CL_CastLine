-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local v1 = NumberRange.new(0.14, 0.21)
local v2 = NumberRange.new(0.55, 0.85)
local v3 = NumberRange.new(1.4, 2.1)
local v4 = NumberRange.new(0.8, 2)
local Back, Cubic = Enum.EasingStyle.Back, Enum.EasingStyle.Cubic
local v5 = UDim2.fromScale(0, 0)
local v6 = Random.new()

local function glintTemplate() -- line: 39
    -- upvalues: Assets (copy)
    return Assets.UI.Misc.Effects.Glint
end

local function draw(p1, p2) -- line: 44
    -- upvalues: v6 (copy)
    return v6:NextNumber(p1.Min, p1.Max) * p2
end

local function layerAbove(p3) -- line: 48
    local v7 = p3.ZIndex

    for _, child in p3:GetChildren() do
        if child:IsA("GuiObject") then
            v7 = math.max(v7, child.ZIndex)
        end
    end

    return v7 + 2
end

local function newLane(p4, p5) -- line: 58
    -- upvalues: Assets (copy), v5 (copy)
    local clone = Assets.UI.Misc.Effects.Glint:Clone()

    clone.Visible = false
    clone.Size = v5
    clone.ZIndex = p5
    clone.Parent = p4

    return {
        readyAt = 0,
        inFlight = nil,
        retired = false,
        glint = clone
    }
end

local function tweenSize(p6, p7, p8, p9, p10) -- line: 67
    -- upvalues: TweenService (copy)
    return TweenService:Create(p6, TweenInfo.new(p7, p8, p9), {
        Size = p10
    })
end

local function finish(p11) -- line: 77
    p11.inFlight = nil

    if p11.retired then
        p11.glint:Destroy()
    else
        p11.glint.Visible = false
    end
end

local function twinkle(p12, p13, p14) -- line: 87
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), v3 (copy), Back (copy), Cubic (copy), v5 (copy), v6 (copy)
    local glint = p12.glint
    local v8 = v6:NextNumber(v1.Min, v1.Max) * p13
    local v9 = v6:NextNumber(v2.Min, v2.Max) * 1 / p14
    local v10 = v6:NextNumber(v3.Min, v3.Max) * 1 / p14

    glint.Position = UDim2.fromScale(v6:NextNumber(), v6:NextNumber())
    glint.Size = v5
    glint.Visible = true

    local Out = Enum.EasingDirection.Out
    local v11 = UDim2.fromScale(v8, v8)
    local tween = TweenService:Create(glint, TweenInfo.new(v9, Back, Out), {
        Size = v11
    })

    tween.Completed:Once(function(p15) -- line: 98
        -- upvalues: p12 (copy), glint (copy), v10 (copy), TweenService (copy), Cubic (copy), v5 (copy)
        if p15 == Enum.PlaybackState.Completed then
            local InOut = Enum.EasingDirection.InOut
            local tween = TweenService:Create(glint, TweenInfo.new(v10, Cubic, InOut), {
                Size = v5
            })

            tween.Completed:Once(function() -- line: 104
                -- upvalues: p12 (copy)
                p12.inFlight = nil

                if p12.retired then
                    p12.glint:Destroy()
                else
                    p12.glint.Visible = false
                end
            end)
            p12.inFlight = tween
            tween:Play()
        else
            p12.inFlight = nil

            if p12.retired then
                p12.glint:Destroy()
            else
                p12.glint.Visible = false
            end
        end
    end)
    p12.inFlight = tween
    tween:Play()

    return v9 + v10
end

return function(p16, p17) -- line: 117
    -- upvalues: Assets (copy), v4 (copy), v5 (copy), v6 (copy), layerAbove (copy), twinkle (copy)
    local LayerCollector = p16:FindFirstAncestorWhichIsA("LayerCollector")

    if LayerCollector == nil then
        return function() -- line: 120
        end
    end

    p17 = p17 or {}

    local v13 = p17.Size or 1
    local v14 = p17.Pace or 1
    local v15 = p17.Lanes or 1

    assert(type(v15) == "number" and v15 >= 1, "a sparkle field needs at least one lane")

    local v17 = layerAbove(p16)
    local t1 = {}

    for _ = 1, v15 do
        local clone = Assets.UI.Misc.Effects.Glint:Clone()

        clone.Visible = false
        clone.Size = v5
        clone.ZIndex = v17
        clone.Parent = p16
        table.insert(t1, {
            readyAt = 0,
            inFlight = nil,
            retired = false,
            glint = clone
        })
    end

    local v18 = true

    local function retireLanes() -- line: 138
        -- upvalues: t1 (copy)
        for _, v19 in t1 do
            v19.retired = true

            if v19.inFlight == nil then
                v19.glint:Destroy()
            end
        end
    end

    task.spawn(function() -- line: 149
        -- upvalues: p16 (copy), LayerCollector (copy), v13 (copy), v14 (copy), t1 (copy), v18 (ref), retireLanes (copy), v4 (copy), v6 (copy), twinkle (copy)
        while v18 and p16.Parent ~= nil do
            local elapsed = os.clock()
            local n1 = 1e999

            for _, v20 in t1 do
                if elapsed < v20.readyAt then
                elseif LayerCollector.Enabled then
                    v20.readyAt = elapsed + twinkle(v20, v13, v14) + v6:NextNumber(v4.Min, v4.Max) * 1
                else
                    v20.readyAt = elapsed + 0.4
                end

                n1 = math.min(n1, v20.readyAt)
            end

            task.wait((math.clamp(n1 - os.clock(), 0.05, 0.3)))
        end

        retireLanes()
    end)

    return function() -- line: 170
        -- upvalues: v18 (ref)
        v18 = false
    end
end
