-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local default2 = RuntimeLib.import(script, script.Parent, "rare-fish-skillcheck").default

local function v1(p1) -- line: 12
    return p1.rarity == "legendary"
end

local v2

for v3, v4 in allFishData do
    local _ = v3 - 1

    if v4.rarity == "legendary" == true then
        v2 = v4
        break
    end

    v2 = nil
end

if v2 == nil then
    v2 = allFishData[1]
end

local function v5(p2) -- line: 29
    return p2.rarity == "mythic"
end

local v6

for v7, v8 in allFishData do
    local _ = v7 - 1

    if v8.rarity == "mythic" == true then
        v6 = v8
        break
    end

    v6 = nil
end

if v6 == nil then
    v6 = allFishData[1]
end

local function pickRandomFish() -- line: 45
    -- upvalues: allFishData (copy)
    return allFishData[math.random(0, #allFishData - 1) + 1]
end

local t1 = {
    approachRingWidth = 7,
    greatWindowMs = 200,
    innerBorderWidth = 5,
    lateOkayWindowMs = 450,
    okayWindowMs = 325,
    perfectWindowMs = 110,
    playAreaHeight = 320,
    playAreaWidth = 520,
    showFishIconOnBar = true,
    showPlayAreaBounds = false,
    showPerfectTimingColor = true,
    targetDurationMs = 750
}
local t2 = {
    label = "RevampedDefault",
    useJackpotFish = true
}
local v9 = table.clone(t1)

setmetatable(v9, nil)
v9.showActionLabels = true
v9.showCountdown = true
v9.variableTimingEnabled = true
t2.props = v9

local t3 = {
    label = "ApexPhase",
    useJackpotFish = true
}
local v10 = table.clone(t1)

setmetatable(v10, nil)
v10.initialProgress = 75
v10.showActionLabels = true
v10.showCountdown = false
t3.props = v10

local t4 = {
    label = "DangerState",
    useJackpotFish = true
}
local v11 = table.clone(t1)

setmetatable(v11, nil)
v11.initialProgress = 20
v11.showActionLabels = true
v11.showCountdown = false
t4.props = v11

local t5 = {
    label = "DebugTimingProfiles",
    useJackpotFish = true
}
local v12 = table.clone(t1)

setmetatable(v12, nil)
v12.enableHitstop = true
v12.enableProgressPulse = true
v12.enableScreenImpact = true
v12.impactIntensityMultiplier = 1.5
v12.showActionLabels = true
v12.showCountdown = false
v12.showPlayAreaBounds = true
v12.variableTimingEnabled = true
t5.props = v12

local t6 = {
    t2,
    t3,
    t4,
    t5
}

local function RareFishSkillCheckStory() -- line: 112
    -- upvalues: react (copy), useState (copy), allFishData (copy), default2 (copy), t6 (copy)
    local v13, v14 = useState(0)
    local v15, v16 = useState(0)
    local _, v17 = useState(nil)
    local _, v18 = useState(nil)
    local v19, v20 = useState(function() -- line: 118
        -- upvalues: allFishData (copy)
        return allFishData[math.random(0, #allFishData - 1) + 1]
    end)
    local v21 = t6[v15 + 1]
    local v22

    if v21.useJackpotFish then
        v22 = table.clone(v21.props)
        setmetatable(v22, nil)
        v22.currentFish = v19
    else
        v22 = v21.props
    end

    local function restart(p3) -- line: 133
        -- upvalues: v14 (copy), v16 (copy), v17 (copy), v18 (copy), v20 (copy), allFishData (copy)
        v17(nil)
        v18(nil)

        if p3 ~= nil then
            v16(p3)
        end

        v20(allFishData[math.random(0, #allFishData - 1) + 1])
        v14(function(p4) -- line: 140
            return p4 + 1
        end)
    end

    local useJackpotFish = v21.useJackpotFish
    local t7 = {
        key = tostring(v13)
    }

    for v23, v24 in v22 do
        t7[v23] = v24
    end

    t7.onComplete = function(p5) -- line: 151
        -- upvalues: v17 (copy)
        v17(p5)
        print(("[SkillCheck] %* — "):format(if p5.success then "SUCCESS" else "FAILED") .. ("progress: %*%% | "):format((math.floor(p5.finalProgress))) .. ("P:%* G:%* O:%* M:%* | "):format(p5.perfects, p5.greats, p5.okays, p5.misses) .. ("score: %*"):format(p5.score))
    end

    t7.onHit = function(p6) -- line: 155
        -- upvalues: v18 (copy)
        v18(p6)
        print(("[SkillCheck] hit #%* — %* | "):format(p6.index, p6.rating) .. ("Δ%*%* → %*%%"):format(if p6.progressDelta > 0 then "+" else "", math.floor(p6.progressDelta), (math.floor(p6.progressAfter))))
    end

    local v29 = react.createElement(default2, t7)
    local v30 = useJackpotFish and react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.08),
        Size = UDim2.fromOffset(300, 28),
        Text = ("🎣 %* (%*)"):format(v19.displayName, v19.rarity),
        TextColor3 = Color3.fromRGB(255, 220, 100)
    }, react.createElement("uistroke", {
        Thickness = 1.5,
        Color = Color3.fromRGB(0, 0, 0)
    }))
    local v31 = table.create(#t6)

    local function v32(p7, p8) -- line: 176
        -- upvalues: v15 (copy), restart (copy), react (copy)
        return react.createElement("textbutton", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            TextScaled = true,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = if p8 == v15 then Color3.fromRGB(60, 130, 230) else Color3.fromRGB(35, 40, 55),
            Event = {
                Activated = function() -- Activated | line: 183
                    -- upvalues: p8 (copy), restart (copy)
                    return restart(p8)
                end
            },
            Font = Enum.Font.GothamBold,
            Position = UDim2.new(0.01 + p8 * 0.155, 0, 0.02, 0),
            Size = UDim2.fromOffset(130, 40),
            Text = p7.label,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            key = p7.label
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.2, 0)
        }))
    end

    for v33, v34 in t6 do
        v31[v33] = v32(v34, v33 - 1, t6)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(18, 22, 32),
        Size = UDim2.fromScale(1, 1)
    }, v29, v30, v31)
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(RareFishSkillCheckStory)))
