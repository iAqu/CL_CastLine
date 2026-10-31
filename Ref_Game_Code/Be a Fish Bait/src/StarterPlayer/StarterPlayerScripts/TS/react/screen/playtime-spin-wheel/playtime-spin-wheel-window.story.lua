-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useState = react.useEffect, react.useMemo, react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config")
local jurassicDuplicateTimeSkipSeconds, monarchDuplicateTimeSkipSeconds, getSpinWheelTimeSkipCash, playtimeSpinWheelSegments = v1.jurassicDuplicateTimeSkipSeconds, v1.monarchDuplicateTimeSkipSeconds, v1.getSpinWheelTimeSkipCash, v1.playtimeSpinWheelSegments
local default = RuntimeLib.import(script, script.Parent, "playtime-spin-wheel-window").default

local function rollStorySegment(p1) -- line: 16
    local n1 = 0

    for _, v2 in p1 do
        n1 += v2.chance
    end

    local v3 = math.random() * n1

    for _, v4 in p1 do
        v3 -= v4.chance

        if v3 <= 0 then
            return v4
        end
    end

    return p1[#p1]
end

local function PlaytimeSpinWheelStory() -- line: 30
    -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useMemo (copy), useState (copy), jurassicDuplicateTimeSkipSeconds (copy), monarchDuplicateTimeSkipSeconds (copy), getSpinWheelTimeSkipCash (copy), playtimeSpinWheelSegments (copy), default (copy), rollStorySegment (copy)
    local v5, v6 = useState(true)
    local v7, v8 = useState(3)
    local v9, v10 = useState(false)
    local v11, v12 = useState(false)
    local v13 = useMemo(function() -- line: 35
        -- upvalues: v9 (copy), v11 (copy), jurassicDuplicateTimeSkipSeconds (copy), monarchDuplicateTimeSkipSeconds (copy), playtimeSpinWheelSegments (copy)
        local v14 = table.create(#playtimeSpinWheelSegments)

        local function v15(p2) -- line: 38
            -- upvalues: v9 (copy), v11 (copy), jurassicDuplicateTimeSkipSeconds (copy), monarchDuplicateTimeSkipSeconds (copy)
            if v9 and p2.reward.kind == "title" and p2.reward.titleId == "monarch" then
                local v16 = table.clone(p2)

                setmetatable(v16, nil)
                v16.reward = {
                    kind = "timeSkip",
                    seconds = monarchDuplicateTimeSkipSeconds
                }

                return v16
            end

            if not v11 or p2.reward.kind ~= "aquariumSkin" or p2.reward.skinName ~= "Jurassic" then
                return p2
            end

            local v17 = table.clone(p2)

            setmetatable(v17, nil)
            v17.reward = {
                kind = "timeSkip",
                seconds = jurassicDuplicateTimeSkipSeconds
            }

            return v17
        end

        for v18, v19 in playtimeSpinWheelSegments do
            v14[v18] = v15(v19, v18 - 1, playtimeSpinWheelSegments)
        end

        return v14
    end, { v9, v11 })

    useEffect(function() -- line: 65
        -- upvalues: v5 (copy), v6 (copy), v8 (copy)
        if v5 then
            return nil
        end

        task.delay(0.6, function() -- line: 69
            -- upvalues: v6 (copy), v8 (copy)
            v8(3)
            v6(true)
        end)
    end, { v5 })

    if not v5 then
        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        })
    end

    local function v20(p3, p4, p5, p6) -- line: 80
        -- upvalues: react (copy)
        return react.createElement("textbutton", {
            AutoButtonColor = true,
            TextScaled = true,
            BackgroundColor3 = if p4 then Color3.fromRGB(45, 180, 80) else Color3.fromRGB(80, 80, 90),
            Event = {
                Activated = p6
            },
            Font = Enum.Font.GothamBold,
            LayoutOrder = p5,
            Size = UDim2.fromOffset(190, 42),
            Text = ("%*: %*"):format(p3, p4 and "OWNED" or "NOT OWNED"),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 8)
        }), react.createElement("uistroke", {
            Thickness = 2,
            Color = Color3.fromRGB(0, 0, 0)
        }))
    end

    return react.createElement(react.Fragment, nil, react.createElement(default, {
        totalMps = 1000,
        onBuyFiveSpinsRequested = function() -- onBuyFiveSpinsRequested | line: 101
            -- upvalues: v8 (copy)
            return v8(function(p7) -- line: 102
                return p7 + 5
            end)
        end,
        onBuyOneSpinRequested = function() -- onBuyOneSpinRequested | line: 106
            -- upvalues: v8 (copy)
            return v8(function(p8) -- line: 107
                return p8 + 1
            end)
        end,
        onClose = function() -- onClose | line: 111
            -- upvalues: v6 (copy)
            return v6(false)
        end,
        onSpinRequested = RuntimeLib.async(function() -- line: 114
            -- upvalues: v7 (copy), v8 (copy), v9 (copy), v11 (copy), v13 (copy), jurassicDuplicateTimeSkipSeconds (copy), monarchDuplicateTimeSkipSeconds (copy), getSpinWheelTimeSkipCash (copy), rollStorySegment (copy)
            if v7 <= 0 then
                return nil
            end

            v8(function(p9) -- line: 118
                return (math.max(p9 - 1, 0))
            end)

            local v22 = rollStorySegment(v13)

            if v22.reward.kind == "timeSkip" then
                return {
                    cashAmount = getSpinWheelTimeSkipCash(v22.reward.seconds, 1000),
                    segment = v22
                }
            end

            if v22.reward.kind == "title" then
                if not v9 or v22.reward.titleId ~= "monarch" then
                    return {
                        segment = v22,
                        titleId = v22.reward.titleId
                    }
                end

                return {
                    cashAmount = getSpinWheelTimeSkipCash(monarchDuplicateTimeSkipSeconds, 1000),
                    replacementTimeSkipSeconds = monarchDuplicateTimeSkipSeconds,
                    segment = v22
                }
            end

            if v22.reward.kind ~= "aquariumSkin" then
                return {
                    fishName = v22.reward.fishName,
                    segment = v22
                }
            end

            if not v11 or v22.reward.skinName ~= "Jurassic" then
                return {
                    segment = v22,
                    skinName = v22.reward.skinName
                }
            end

            return {
                cashAmount = getSpinWheelTimeSkipCash(jurassicDuplicateTimeSkipSeconds, 1000),
                replacementTimeSkipSeconds = jurassicDuplicateTimeSkipSeconds,
                segment = v22
            }
        end),
        segmentsOverride = v13,
        spinCount = v7
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 500,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromOffset(20, 20),
        Size = UDim2.fromOffset(200, 96)
    }, react.createElement("uilistlayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }), v20("Monarch", v9, 1, function() -- line: 173
        -- upvalues: v10 (copy)
        return v10(function(p10) -- line: 174
            return not p10
        end)
    end), v20("Jurassic", v11, 2, function() -- line: 177
        -- upvalues: v12 (copy)
        return v12(function(p11) -- line: 178
            return not p11
        end)
    end)))
end

return storyForScreenGui(react.createElement(PlaytimeSpinWheelStory), {
    zIndexBehavior = Enum.ZIndexBehavior.Sibling
})
