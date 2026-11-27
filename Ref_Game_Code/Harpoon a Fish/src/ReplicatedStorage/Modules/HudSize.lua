-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    ORDER = { "Small", "Normal", "Large" },
    DEFAULT = "Normal",
    PRESETS = {
        Small = {
            buttons = 0.8,
            pills = 0.7,
            effects = 0.72
        },
        Normal = {
            buttons = 0.9,
            pills = 0.8,
            effects = 0.85
        },
        Large = {
            buttons = 1,
            pills = 1,
            effects = 1
        }
    },
    CORNER = 0.975
}
local t2 = {
    0.32, 0.13
}
local t3 = {
    ShopSlot = {
        y = 0.33507961,
        size = { 0.279417485, 0.1771 }
    },
    CrateSlot = {
        y = 0.478439003,
        size = { 0.14, 0.14 }
    },
    IndexSlot = {
        y = 0.606439054,
        size = { 0.14, 0.14 }
    },
    SmallRow = {
        y = 0.694607794,
        size = { 0.14, 0.14 }
    },
    FatBoost = {
        y = 0.458019376,
        size = { 1, 0.17 }
    }
}
local t4 = {
    FishSlot = {
        size = 0.14,
        y = 0.449
    },
    FeedSlot = {
        size = 0.14,
        y = 0.578
    },
    PlaytimeSlot = {
        size = 0.14,
        y = 0.706
    },
    HydraSlot = {
        size = 0.16,
        y = 0.293
    },
    BaitSlot = {
        size = 0.14,
        y = 0.5,
        fixed = true
    },
    QuestSlot = {
        size = 0.105,
        top = 0.025
    }
}
local t5 = {
    size = { 0.3, 0.26 },
    cap = Vector2.new(231, 210)
}
local v1 = t1.DEFAULT
local BindableEvent = Instance.new("BindableEvent")

t1.Changed = BindableEvent.Event

function t1.Valid(p1) -- line: 60
    -- upvalues: t1 (copy)
    if type(p1) == "string" then
        return t1.PRESETS[p1] ~= nil
    end

    return false
end

function t1.Current() -- line: 63
    -- upvalues: v1 (ref)
    return v1
end

function t1.TopRowY(p2) -- line: 66
    -- upvalues: t1 (copy), v1 (ref)
    local v2 = t1.PRESETS[p2 or v1] or t1.PRESETS[t1.DEFAULT]

    return t1.CORNER - 0.12 * v2.pills
end

local function setY(p3, p4) -- line: 71
    p3.Position = UDim2.new(p3.Position.X.Scale, p3.Position.X.Offset, p4, p3.Position.Y.Offset)
end

function t1.Apply(p5, p6, p7) -- line: 76
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), v1 (ref), BindableEvent (copy)
    local v3 = if t1.Valid(p6) then p6 else t1.DEFAULT
    local v4 = t1.PRESETS[v3]
    local buttons, pills = v4.buttons, v4.pills
    local v5 = p5:FindFirstChild("MoneyGui") and p5.MoneyGui:FindFirstChild("Money")
    local HUD = p5:FindFirstChild("HUD")
    local Fat = HUD and HUD:FindFirstChild("Fat")

    for _, v6 in ipairs({ v5, Fat }) do
        if v6 then
            v6.Size = UDim2.fromScale(t2[1] * pills, t2[2] * pills)
        end
    end

    if Fat then
        local v7 = t1.TopRowY(v3)

        Fat.Position = UDim2.new(Fat.Position.X.Scale, Fat.Position.X.Offset, v7, Fat.Position.Y.Offset)
    end

    local v8 = t1.CORNER - (0.12 + t2[2]) * pills
    local MenuButtons = p5:FindFirstChild("MenuButtons")

    for v9, v10 in pairs(t3) do
        local v11 = MenuButtons and MenuButtons:FindFirstChild(v9)

        if v11 then
            v11.Size = UDim2.fromScale(v10.size[1] * buttons, v10.size[2] * buttons)

            local v12 = v8 - (0.725 - v10.y) * buttons

            v11.Position = UDim2.new(v11.Position.X.Scale, v11.Position.X.Offset, v12, v11.Position.Y.Offset)
        end
    end

    local SideButtons = p5:FindFirstChild("SideButtons")

    for v13, v14 in pairs(t4) do
        local v15 = SideButtons and SideButtons:FindFirstChild(v13)

        if v15 then
            v15.Size = UDim2.fromScale(v14.size * buttons, v14.size * buttons)

            local v16 = v14.top and v14.top + v14.size * buttons / 2 or v14.fixed and v14.y or 0.578 + (v14.y - 0.578) * buttons

            v15.Position = UDim2.new(v15.Position.X.Scale, v15.Position.X.Offset, v16, v15.Position.Y.Offset)
        end
    end

    local v17 = p5:FindFirstChild("EffectsGui") and p5.EffectsGui:FindFirstChild("Stack")

    if v17 then
        v17.Size = UDim2.fromScale(t5.size[1] * v4.effects, t5.size[2] * v4.effects)

        local UISizeConstraint = v17:FindFirstChildOfClass("UISizeConstraint")

        if UISizeConstraint and not p7 then
            UISizeConstraint.MaxSize = Vector2.new(math.round(t5.cap.X * v4.effects), (math.round(t5.cap.Y * v4.effects)))
        end
    end

    if p5:IsA("PlayerGui") then
        v1 = v3
        BindableEvent:Fire(v3)
    end
end

return t1
