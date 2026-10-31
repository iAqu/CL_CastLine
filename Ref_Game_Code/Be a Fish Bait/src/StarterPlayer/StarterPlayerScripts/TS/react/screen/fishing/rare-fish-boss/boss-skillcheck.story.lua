-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "fishing-phase-atom")
local bossActivePromptAtom, bossWeakSpotsAtom = v1.bossActivePromptAtom, v1.bossWeakSpotsAtom
local default = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils", "story-provider").default
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "boss-screenborder").default
local default3 = RuntimeLib.import(script, script.Parent, "boss-skillcheck").default
local allWeakSpotIds = RuntimeLib.import(script, script.Parent, "boss-config").allWeakSpotIds

local function v2(p1) -- line: 20
    return p1.rarity == "cosmic"
end

local v3

for v4, v5 in allFishData do
    local _ = v4 - 1

    if v5.rarity == "cosmic" == true then
        v3 = v5
        break
    end

    v3 = nil
end

if v3 == nil then
    local function v6(p2) -- line: 34
        return p2.rarity == "legendary"
    end

    v3 = nil

    for v7, v8 in allFishData do
        local _ = v7 - 1

        if v8.rarity == "legendary" == true then
            v3 = v8
            break
        end

        v3 = nil
    end

    if v3 == nil then
        v3 = allFishData[1]
    end
end

local function v9(p3) -- line: 52
    return p3.name == "Frostwyrm"
end

local v10

for v11, v12 in allFishData do
    local _ = v11 - 1

    if v12.name == "Frostwyrm" == true then
        v10 = v12
        break
    end

    v10 = nil
end

if v10 == nil then
    v10 = v3
end

local t1 = {
    body = Vector2.new(0.5, 0.47),
    left = Vector2.new(0.39, 0.48),
    mouth = Vector2.new(0.5, 0.36),
    right = Vector2.new(0.61, 0.48),
    tail = Vector2.new(0.5, 0.61),
    upper = Vector2.new(0.5, 0.27)
}

local function RareFishBossWeakSpotDriver() -- line: 76
    -- upvalues: react (copy), useEffect (copy), RunService (copy), Workspace (copy), bossActivePromptAtom (copy), bossWeakSpotsAtom (copy), allWeakSpotIds (copy), t1 (copy)
    useEffect(function() -- line: 77
        -- upvalues: RunService (copy), Workspace (copy), bossActivePromptAtom (copy), bossWeakSpotsAtom (copy), allWeakSpotIds (copy), t1 (copy)
        local connection = RunService.RenderStepped:Connect(function() -- line: 78
            -- upvalues: Workspace (copy), bossWeakSpotsAtom (copy), allWeakSpotIds (copy), t1 (copy)
            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil then
                CurrentCamera = CurrentCamera.ViewportSize
            end

            if CurrentCamera == nil then
                CurrentCamera = Vector2.new(1280, 720)
            end

            local elapsed = os.clock()
            local t2 = {}

            for _, v13 in allWeakSpotIds do
                local v14 = t1[v13]
                local v15 = (table.find(allWeakSpotIds, v13) or 0) - 1
                local v17 = math.sin(elapsed * 1.25 + v15 * 0.8) * 16
                local v19 = math.cos(elapsed * 1.6 + v15 * 0.65) * 10

                t2[v13] = {
                    onScreen = true,
                    x = v14.X * CurrentCamera.X + v17,
                    y = v14.Y * CurrentCamera.Y + v19
                }
            end

            bossWeakSpotsAtom(t2)
        end)

        return function() -- line: 105
            -- upvalues: connection (copy), bossActivePromptAtom (copy), bossWeakSpotsAtom (copy)
            connection:Disconnect()
            bossActivePromptAtom(nil)
            bossWeakSpotsAtom({})
        end
    end, {})

    return react.createElement(react.Fragment)
end

local function formatFishLabel(p4) -- line: 113
    if p4 == nil then
        return "Rare Fish Boss"
    end

    return (("%* (%*)"):format(p4.displayName, p4.rarity))
end

local t3 = {
    aEasy = "A Easy",
    aHard = "A Hard",
    bEasy = "B Easy",
    bHard = "B Hard",
    superBoss = "EXCLUSIVE"
}

local function RareFishBossStory() -- line: 127
    -- upvalues: react (copy), useState (copy), bossActivePromptAtom (copy), default2 (copy), default3 (copy), v3 (ref), v10 (ref), RareFishBossWeakSpotDriver (copy), t3 (copy)
    local v20, v21 = useState(0)
    local v22, v23 = useState(true)
    local aHard, aHard2 = useState("aHard")
    local v24, v25 = useState(nil)
    local v26, v27 = useState(nil)
    local intro, intro2 = useState("intro")
    local v28, v29 = useState(nil)

    local function restart(p5, p6) -- line: 135
        -- upvalues: v21 (copy), v22 (copy), v23 (copy), aHard (copy), aHard2 (copy), v25 (copy), v27 (copy), intro2 (copy), v29 (copy), bossActivePromptAtom (copy)
        local v30 = if p5 == nil then v22 else p5
        local v31 = if p6 == nil then aHard else p6

        bossActivePromptAtom(nil)
        v25(nil)
        v27(nil)
        v29(nil)
        intro2("intro")
        v23(v30)
        aHard2(v31)
        v21(function(p7) -- line: 149
            return p7 + 1
        end)
    end

    local v32 = aHard == "aEasy" or aHard == "bEasy"
    local v33 = aHard == "superBoss"
    local v34 = aHard == "aHard" or v33
    local v35 = if v33 then v10 else v3

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(7, 11, 18),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(RareFishBossWeakSpotDriver), react.createElement(default2), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.22,
        ZIndex = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = v35.imageId,
        ImageColor3 = Color3.fromRGB(145, 215, 255),
        Position = UDim2.fromScale(0.5, 0.46),
        Size = UDim2.fromScale(0.42, 0.42)
    }), react.createElement(default3, {
        currentFish = v35,
        difficultyMultiplier = if v33 then 1.08 else nil,
        easyMode = v32,
        key = tostring(v20),
        onComplete = function(p8) -- onComplete | line: 176
            -- upvalues: v25 (copy)
            v25(p8)
            print((("[RareFishBoss] %* | progress %*%%"):format(if p8.success then "SUCCESS" else "FAILED", (math.floor(p8.finalProgress)))))
        end,
        onHit = function(p9) -- onHit | line: 180
            -- upvalues: v27 (copy)
            v27(p9)
            print((("[RareFishBoss] %* %* %* on %*"):format(p9.rating, p9.promptType, p9.action, p9.weakSpotId)))
        end,
        onPhaseChanged = function(p10) -- onPhaseChanged | line: 184
            -- upvalues: intro2 (copy)
            intro2(p10)
            print((("[RareFishBoss] phase %*"):format(p10)))
        end,
        onSuccessCutscene = function() -- onSuccessCutscene | line: 188
            return print("[RareFishBoss] success cutscene")
        end,
        onTelegraph = function(p11) -- onTelegraph | line: 191
            -- upvalues: v29 (copy)
            v29(p11)
            print((("[RareFishBoss] telegraph %* %* on %*"):format(p11.promptType, p11.action, p11.weakSpotId)))
        end,
        qteVariant = aHard,
        showCountdown = v22,
        slidePromptsEnabled = v34
    }), react.createElement("frame", {
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 30,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(12, 16, 24),
        Position = UDim2.fromOffset(16, 16),
        Size = UDim2.fromOffset(300, 258)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.25,
        Color = Color3.fromRGB(78, 124, 170)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 31,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.fromOffset(232, 24),
        Text = if v35 == nil then "Rare Fish Boss" else ("%* (%*)"):format(v35.displayName, v35.rarity),
        TextColor3 = Color3.fromRGB(255, 238, 150),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 31,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(14, 40),
        Size = UDim2.fromOffset(232, 20),
        Text = ("Phase: %* | %*"):format(intro, t3[aHard]),
        TextColor3 = Color3.fromRGB(215, 235, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 31,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(14, 64),
        Size = UDim2.fromOffset(232, 18),
        Text = if v26 ~= nil then ("%* %* (%*)"):format(v26.rating, v26.action, v26.weakSpotId) elseif v28 == nil then "Waiting for first prompt" else ("Next: %* (%*)"):format(v28.action, v28.weakSpotId),
        TextColor3 = Color3.fromRGB(180, 210, 235),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "RESTART",
        TextScaled = true,
        ZIndex = 31,
        BackgroundColor3 = Color3.fromRGB(56, 126, 235),
        Event = {
            Activated = function() -- Activated | line: 246
                -- upvalues: v22 (copy), restart (copy)
                return restart(v22)
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(14, 92),
        Size = UDim2.fromOffset(132, 28),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextScaled = true,
        ZIndex = 31,
        BackgroundColor3 = if v22 then Color3.fromRGB(40, 190, 120) else Color3.fromRGB(62, 72, 88),
        Event = {
            Activated = function() -- Activated | line: 263
                -- upvalues: v22 (copy), restart (copy)
                return restart(not v22)
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(154, 92),
        Size = UDim2.fromOffset(132, 28),
        Text = v22 and "COUNTDOWN" or "INSTANT",
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "A Easy",
        TextScaled = true,
        ZIndex = 31,
        BackgroundColor3 = if aHard == "aEasy" then Color3.fromRGB(40, 190, 120) else Color3.fromRGB(62, 72, 88),
        Event = {
            Activated = function() -- Activated | line: 280
                -- upvalues: v22 (copy), restart (copy)
                return restart(v22, "aEasy")
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(14, 124),
        Size = UDim2.fromOffset(132, 28),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "A Hard",
        TextScaled = true,
        ZIndex = 31,
        BackgroundColor3 = if aHard == "aHard" then Color3.fromRGB(40, 190, 120) else Color3.fromRGB(62, 72, 88),
        Event = {
            Activated = function() -- Activated | line: 297
                -- upvalues: v22 (copy), restart (copy)
                return restart(v22, "aHard")
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(154, 124),
        Size = UDim2.fromOffset(132, 28),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "B Easy",
        TextScaled = true,
        ZIndex = 31,
        BackgroundColor3 = if aHard == "bEasy" then Color3.fromRGB(40, 190, 120) else Color3.fromRGB(62, 72, 88),
        Event = {
            Activated = function() -- Activated | line: 314
                -- upvalues: v22 (copy), restart (copy)
                return restart(v22, "bEasy")
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(14, 158),
        Size = UDim2.fromOffset(132, 28),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "B Hard",
        TextScaled = true,
        ZIndex = 31,
        BackgroundColor3 = if aHard == "bHard" then Color3.fromRGB(40, 190, 120) else Color3.fromRGB(62, 72, 88),
        Event = {
            Activated = function() -- Activated | line: 331
                -- upvalues: v22 (copy), restart (copy)
                return restart(v22, "bHard")
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(154, 158),
        Size = UDim2.fromOffset(132, 28),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "EXCLUSIVE",
        TextScaled = true,
        ZIndex = 31,
        BackgroundColor3 = if v33 then Color3.fromRGB(40, 190, 120) else Color3.fromRGB(62, 72, 88),
        Event = {
            Activated = function() -- Activated | line: 348
                -- upvalues: v22 (copy), restart (copy)
                return restart(v22, "superBoss")
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(14, 192),
        Size = UDim2.fromOffset(272, 28),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    })), v24 ~= nil and react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 31,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(14, 226),
        Size = UDim2.fromOffset(272, 18),
        Text = v24.success and "Boss caught" or "Boss escaped",
        TextColor3 = if v24.success then Color3.fromRGB(130, 255, 160) else Color3.fromRGB(255, 125, 125),
        TextXAlignment = Enum.TextXAlignment.Left
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(RareFishBossStory)))
