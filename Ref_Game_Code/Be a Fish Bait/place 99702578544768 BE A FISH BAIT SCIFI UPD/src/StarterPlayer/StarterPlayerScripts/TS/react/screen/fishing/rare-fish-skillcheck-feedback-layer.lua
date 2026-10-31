-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion

local function getScreenImpactVisual(p1) -- line: 9
    if p1 == "perfect" then
        return {
            coreColor = Color3.fromRGB(255, 230, 120),
            ringColor = Color3.fromRGB(255, 210, 70)
        }
    end

    if p1 == "great" then
        return {
            coreColor = Color3.fromRGB(150, 255, 220),
            ringColor = Color3.fromRGB(40, 230, 200)
        }
    end

    if p1 == "okay" then
        return {
            coreColor = Color3.fromRGB(220, 245, 255),
            ringColor = Color3.fromRGB(150, 215, 255)
        }
    end

    return {
        coreColor = Color3.fromRGB(255, 120, 90),
        ringColor = Color3.fromRGB(255, 60, 60)
    }
end

local function RareFishScreenImpact(p2) -- line: 34
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), getScreenImpactVisual (copy)
    local impact, onDone = p2.impact, p2.onDone
    local v1 = getScreenImpactVisual(impact.rating)
    local v2, v3 = useMotion(0)

    useEffect(function() -- line: 39
        -- upvalues: impact (copy), onDone (copy), v3 (copy)
        v3:set(0)
        v3:tween(1, {
            time = 0.55,
            direction = Enum.EasingDirection.Out,
            style = Enum.EasingStyle.Quad
        })

        local v4 = task.delay(0.55, function() -- line: 46
            -- upvalues: impact (copy), onDone (copy)
            return onDone(impact.id)
        end)

        return function() -- line: 49
            -- upvalues: v4 (copy)
            return task.cancel(v4)
        end
    end, {})

    local v5 = if impact.rating == "perfect" then 230 elseif impact.rating == "great" then 180 else 140
    local v6 = v2:map(function(p3) -- line: 54
        -- upvalues: v5 (copy)
        return UDim2.fromOffset(v5 * (0.4 + p3 * 1.1), v5 * (0.4 + p3 * 1.1))
    end)
    local v7 = v2:map(function(p4) -- line: 57
        return (math.clamp(p4, 0, 1))
    end)
    local v8 = v2:map(function(p5) -- line: 60
        -- upvalues: v5 (copy)
        return UDim2.fromOffset(v5 * 0.4 * (1 - p5), v5 * 0.4 * (1 - p5))
    end)
    local v9 = v2:map(function(p6) -- line: 63
        return (math.clamp(0.2 + p6 * 0.8, 0, 1))
    end)

    return react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 1,
        ZIndex = 7,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(impact.pos.x, impact.pos.y),
        Size = UDim2.fromOffset(1, 1)
    }, react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = v6
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.5, 0)
    }), react.createElement("uistroke", {
        Thickness = 5,
        Color = v1.ringColor,
        Transparency = v7
    })), react.createElement("frame", {
        Active = false,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = v1.coreColor,
        BackgroundTransparency = v9,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = v8
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.5, 0)
    })))
end

return {
    default = function(p7) -- RareFishFeedbackLayer | line: 98
        -- upvalues: react (copy), RareFishScreenImpact (copy)
        local impacts, onImpactDone = p7.impacts, p7.onImpactDone
        local v11 = table.create(#impacts)

        for v12, v13 in impacts do
            local _ = v12 - 1

            v11[v12] = react.createElement(RareFishScreenImpact, {
                impact = v13,
                key = tostring(v13.id),
                onDone = onImpactDone
            })
        end

        return react.createElement(react.Fragment, nil, v11)
    end
}
