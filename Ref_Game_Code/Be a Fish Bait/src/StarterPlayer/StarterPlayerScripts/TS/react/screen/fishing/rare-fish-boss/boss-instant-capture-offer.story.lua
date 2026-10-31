-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils", "story-provider").default
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "boss-instant-capture-offer").default

local function v1(p1) -- line: 11
    return p1.rarity == "mythic"
end

local v2

for v3, v4 in allFishData do
    local _ = v3 - 1

    if v4.rarity == "mythic" == true then
        v2 = v4
        break
    end

    v2 = nil
end

if v2 == nil then
    local function v5(p2) -- line: 25
        return p2.rarity == "legendary"
    end

    v2 = nil

    for v6, v7 in allFishData do
        local _ = v6 - 1

        if v7.rarity == "legendary" == true then
            v2 = v7
            break
        end

        v2 = nil
    end

    if v2 == nil then
        v2 = allFishData[1]
    end
end

local function InstantCaptureOfferStory() -- line: 42
    -- upvalues: react (copy), useState (copy), default2 (copy), v2 (ref)
    local v8, v9 = useState(0)
    local none, none2 = useState("none")

    local function restart() -- line: 46
        -- upvalues: v9 (copy), none2 (copy)
        v9(function(p3) -- line: 47
            return p3 + 1
        end)
        none2("none")
    end

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(46, 104, 140),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uigradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(86, 158, 196)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(40, 96, 132)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 44, 66))
        })
    }), react.createElement(default2, {
        durationSec = 10,
        priceRobux = 29,
        productId = 0,
        uiScale = 1,
        fish = v2,
        key = tostring(v8),
        onBuy = function() -- onBuy | line: 63
            -- upvalues: none2 (copy)
            return none2("buy")
        end,
        onCancel = function() -- onCancel | line: 66
            -- upvalues: none2 (copy)
            return none2("cancel / timeout")
        end
    }), react.createElement("frame", {
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 60,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(12, 16, 24),
        Position = UDim2.fromOffset(16, 16),
        Size = UDim2.fromOffset(260, 96)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.25,
        Color = Color3.fromRGB(78, 124, 170)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 61,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.fromOffset(232, 20),
        Text = ("Last action: %*"):format(none),
        TextColor3 = Color3.fromRGB(215, 235, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "RESTART OFFER",
        TextScaled = true,
        ZIndex = 61,
        BackgroundColor3 = Color3.fromRGB(56, 126, 235),
        Event = {
            Activated = function() -- Activated | line: 100
                -- upvalues: restart (copy)
                return restart()
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(14, 40),
        Size = UDim2.fromOffset(232, 40),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    }))))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(InstantCaptureOfferStory)))
