-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local bonusWaveSpeedupPerWave = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fish-bite-weight-config").bonusWaveSpeedupPerWave
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils")
local StoryScreenGui, storyForBillboardGui = v1.StoryScreenGui, v1.storyForBillboardGui
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "fish-nibble-billboard").default
local v2 = if #allFishData > 3 then {
    allFishData[1],
    allFishData[2],
    allFishData[3]
} else allFishData
local v3 = if #allFishData > 5 then {
    allFishData[4],
    allFishData[5]
}
    elseif #allFishData > 4 then { allFishData[4] }
    else v2
local v4 = allFishData[#allFishData] or v2[1]

local function nibbleDurationForWave(p1) -- line: 22
    -- upvalues: bonusWaveSpeedupPerWave (copy)
    return math.pow(bonusWaveSpeedupPerWave, p1) * 3
end

local function getFishForWave(p2, p3) -- line: 25
    -- upvalues: v4 (copy), v2 (copy), v3 (copy)
    if p3 == 3 and p2 == 3 then
        return { v4 }
    end

    if p2 == 0 then
        return v2
    end

    return v3
end

local function getCaughtFish(p4) -- line: 31
    -- upvalues: v4 (copy), v2 (copy), v3 (copy)
    if p4 == 3 then
        return v4
    end

    return (if p4 > 0 then v3[1] else v2[1]) or v2[1]
end

local function Session(p5) -- line: 37
    -- upvalues: react (copy), useEffect (copy), useState (copy), Workspace (copy), bonusWaveSpeedupPerWave (copy), default2 (copy), v4 (copy), v2 (copy), v3 (copy)
    local adornee, bonusCount = p5.adornee, p5.bonusCount
    local v5, v6 = useState({
        kind = "wave",
        index = 0
    })
    local v7, v8 = useState(function() -- line: 44
        -- upvalues: Workspace (copy), bonusWaveSpeedupPerWave (copy)
        return Workspace:GetServerTimeNow() + math.pow(bonusWaveSpeedupPerWave, 0) * 3
    end)

    useEffect(function() -- line: 47
        -- upvalues: bonusCount (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), Workspace (copy), bonusWaveSpeedupPerWave (copy)
        if v5.kind == "wave" then
            local v9 = v7 - Workspace:GetServerTimeNow()
            local v10 = task.delay(math.max(0, v9), function() -- line: 50
                -- upvalues: bonusCount (copy), v5 (copy), v6 (copy)
                if v5.index < bonusCount then
                    v6({
                        kind = "intermission",
                        nextWave = v5.index + 1
                    })
                else
                    v6({
                        kind = "caught"
                    })
                end
            end)

            return function() -- line: 62
                -- upvalues: v10 (copy)
                return task.cancel(v10)
            end
        end

        if v5.kind == "intermission" then
            local v11 = task.delay(1, function() -- line: 67
                -- upvalues: v5 (copy), v6 (copy), v8 (copy), Workspace (copy), bonusWaveSpeedupPerWave (copy)
                v8(Workspace:GetServerTimeNow() + math.pow(bonusWaveSpeedupPerWave, v5.nextWave) * 3)
                v6({
                    kind = "wave",
                    index = v5.nextWave
                })
            end)

            return function() -- line: 74
                -- upvalues: v11 (copy)
                return task.cancel(v11)
            end
        end
    end, { v5, v7, bonusCount })

    local v12 = v5.kind == "caught"
    local v13 = v5.kind == "intermission"
    local v14 = bonusCount == 3 and v5.kind == "wave" and v5.index == 3
    local index = if v5.kind == "wave" then v5.index else nil
    local v15

    if not v12 then
        if v13 then
            v15 = {}
        elseif index ~= nil then
            if bonusCount == 3 and index == 3 then
                v15 = { v4 }
            else
                v15 = if index == 0 then v2 else v3
            end
        end
    end

    return react.createElement(default2, {
        adornee = adornee,
        bonusChosen = v13,
        bonusFishInPool = not v12 and not v14,
        caughtFish = if not v12 then nil elseif bonusCount == 3 then v4 else (if bonusCount > 0 then v3[1] else v2[1]) or v2[1],
        keepObscured = v12 and bonusCount == 3,
        nibbleExpireTimestamp = v7,
        nibblingFish = v15
    })
end

local t2 = {
    {
        count = 0,
        label = "No bonus",
        activeColor = Color3.fromRGB(50, 100, 180)
    },
    {
        count = 1,
        label = "×1 bonus",
        activeColor = Color3.fromRGB(70, 140, 60)
    },
    {
        count = 2,
        label = "×2 bonus",
        activeColor = Color3.fromRGB(160, 90, 30)
    },
    {
        count = 3,
        label = "×3 bonus ✦",
        activeColor = Color3.fromRGB(140, 50, 160)
    }
}
local v16 = Color3.fromRGB(40, 40, 55)

local function Controls(p6) -- line: 112
    -- upvalues: react (copy), t2 (copy), v16 (copy)
    local bonusCount, onBonusChange, onRemount = p6.bonusCount, p6.onBonusChange, p6.onRemount
    local v17 = react.createElement("uilistlayout", {
        FillDirection = "Horizontal",
        HorizontalAlignment = "Center",
        VerticalAlignment = "Center",
        Padding = UDim.new(0, 8)
    })
    local v18 = table.create(#t2)

    local function v19(p7) -- line: 124
        -- upvalues: bonusCount (copy), onBonusChange (copy), react (copy), v16 (copy)
        local count, label, activeColor = p7.count, p7.label, p7.activeColor

        return react.createElement("textbutton", {
            BorderSizePixel = 0,
            TextScaled = true,
            BackgroundColor3 = if bonusCount ~= count then v16 else activeColor,
            Event = {
                MouseButton1Down = function() -- MouseButton1Down | line: 132
                    -- upvalues: count (copy), onBonusChange (copy)
                    return onBonusChange(count)
                end
            },
            Size = UDim2.fromOffset(110, 36),
            Text = label,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            key = label
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 6)
        }))
    end

    for v20, v21 in t2 do
        v18[v20] = v19(v21, v20 - 1, t2)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.new(0, 600, 0, 36)
    }, v17, v18, react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Remount",
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(50, 160, 80),
        Event = {
            MouseButton1Down = onRemount
        },
        Size = UDim2.fromOffset(100, 36),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    })))
end

local function StoryRoot(p8) -- line: 168
    -- upvalues: react (copy), useState (copy), StoryScreenGui (copy), Session (copy), Controls (copy)
    local part = p8.part
    local v22, v23 = useState(0)
    local v24, v25 = useState(0)

    local function v26(p9) -- line: 172
        -- upvalues: v23 (copy), v25 (copy)
        v23(p9)
        v25(function(p10) -- line: 174
            return p10 + 1
        end)
    end

    return react.createElement(react.Fragment, nil, react.createElement(Session, {
        adornee = part,
        bonusCount = v22,
        key = v24
    }), react.createElement(StoryScreenGui, nil, react.createElement(Controls, {
        bonusCount = v22,
        onBonusChange = v26,
        onRemount = function() -- onRemount | line: 185
            -- upvalues: v25 (copy)
            return v25(function(p11) -- line: 186
                return p11 + 1
            end)
        end
    })))
end

return storyForBillboardGui(function(p12) -- line: 192
    -- upvalues: react (copy), default (copy), StoryRoot (copy)
    return react.createElement(default, nil, react.createElement(StoryRoot, {
        part = p12
    }))
end)
