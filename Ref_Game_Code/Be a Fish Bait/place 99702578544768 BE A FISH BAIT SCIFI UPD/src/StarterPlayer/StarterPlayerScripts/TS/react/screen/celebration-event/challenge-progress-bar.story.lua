-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "challenge-progress-bar").default
local challengeTiers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "challenge-tiers").challengeTiers
local t1 = {
    0, 1.3E+08, 2.5E+08, 3.8E+08, 5.2E+08, 6.7E+08, 8.3E+08, 1E+09,
    1.18E+09, 1.35E+09, 1.5E+09
}

local function cloneSet(p1) -- line: 11
    local t2 = {}

    for v1 in p1 do
        t2[v1] = true
    end

    return t2
end

local function ChallengeProgressBarStory() -- line: 25
    -- upvalues: react (copy), useState (copy), default2 (copy), challengeTiers (copy), t1 (copy), cloneSet (copy)
    local v2, v3 = useState(0)
    local v4, v5 = useState({})
    local v6 = t1[v2 + 1]

    local function v7(p2) -- line: 29
        -- upvalues: v5 (copy), cloneSet (copy)
        v5(function(p3) -- line: 30
            -- upvalues: p2 (copy), cloneSet (copy)
            local v8 = cloneSet(p3)

            v8[p2] = true

            return v8
        end)
    end

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0.5, 0.45),
        Size = UDim2.fromScale(0.5, 0.8)
    }, react.createElement(default2, {
        claimedTierIds = v4,
        currentTickets = v6,
        onClaim = v7,
        tiers = challengeTiers
    })), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 1),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.94),
        Size = UDim2.fromOffset(400, 28),
        Text = ("Tickets: %*"):format(v6),
        TextColor3 = Color3.fromRGB(255, 220, 90)
    }), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "Next Ticket Amount",
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(60, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 68
                -- upvalues: v3 (copy), t1 (copy)
                return v3(function(p4) -- line: 69
                    -- upvalues: t1 (copy)
                    return (p4 + 1) % #t1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.99),
        Size = UDim2.fromOffset(220, 44),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(ChallengeProgressBarStory)))
