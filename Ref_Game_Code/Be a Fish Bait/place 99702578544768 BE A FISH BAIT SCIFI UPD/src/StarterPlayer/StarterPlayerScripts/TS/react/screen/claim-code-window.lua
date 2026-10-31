-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRef, useState = react.useRef, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default4 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default5 = RuntimeLib.import(script, script.Parent.Parent, "common", "reward-screen").default
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootProducer
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").functions
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useSound = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-sound").useSound
local getTextSize = RuntimeLib.import(script, script.Parent.Parent, "utils", "responsive-utils").getTextSize
local normalizeRewardCode = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "reward-codes").normalizeRewardCode
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local v1 = Color3.fromRGB(20, 60, 20)
local v2 = Color3.fromRGB(170, 170, 170)
local v3 = Color3.fromRGB(80, 200, 60)
local v4 = Color3.fromRGB(40, 120, 30)

return {
    default = function(_) -- ClaimCodeWindow | line: 27
        -- upvalues: react (copy), useRef (copy), useState (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy), useRootProducer (copy), functions (copy), HttpService (copy), useTheme (copy), useScreenSizeState (copy), useSound (copy), getTextSize (copy), normalizeRewardCode (copy), getTitleData (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
        local v5 = useRootProducer()
        local v6 = useTheme()
        local v7 = useScreenSizeState()
        local v8 = v7 == "sm" or v7 == "md"
        local playSound = useSound("SkillCheckSuccess").playSound
        local v9 = useRef(nil)
        local v10, v11 = useState(nil)

        return react.createElement(default, {
            title = "Codes",
            bodyBg = v1,
            headerBg = v6.colorSequences.greenGradient,
            onClose = function() -- onClose | line: 91
                -- upvalues: v5 (copy)
                return v5.windowClosed({})
            end,
            size = UDim2.fromScale(0.42, 0.42)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Image = "rbxassetid://0",
            ImageTransparency = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.03, 0.42),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.44, 0.55)
        }), react.createElement(default3, {
            cornerRadius = 0.15,
            isStudded = false,
            strokeThickness = 0.01,
            transparency = 0,
            zIndex = 2,
            anchorPoint = Vector2.new(0, 0.5),
            backgroundColor = v2,
            position = UDim2.fromScale(0.52, 0.28),
            size = UDim2.fromScale(0.44, 0.22),
            strokeColor = Color3.fromRGB(100, 100, 100)
        }, react.createElement("textbox", {
            BackgroundTransparency = 1,
            ClearTextOnFocus = false,
            PlaceholderText = "Enter Code",
            Text = "",
            TextScaled = true,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = v6.textFont,
            PlaceholderColor3 = Color3.fromRGB(90, 90, 90),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.92, 0.8),
            TextColor3 = Color3.fromRGB(50, 50, 50),
            TextXAlignment = Enum.TextXAlignment.Center,
            ref = v9
        }, react.createElement("uitextsizeconstraint", {
            MaxTextSize = getTextSize(v7, "md")
        }))), react.createElement(default2, {
            cornerRadius = 0.2,
            isStudded = false,
            strokeThickness = 0.015,
            zIndex = 2,
            anchorPoint = Vector2.new(0, 0.5),
            backgroundColor = v3,
            onClick = function() -- onClick | line: 138
                -- upvalues: v5 (copy), v9 (copy), v11 (copy), functions (copy), HttpService (copy), normalizeRewardCode (copy), getTitleData (copy)
                local current = v9.current

                if current ~= nil then
                    current = current.Text
                end

                if current == nil then
                    current = ""
                end

                functions.claimRewardCode(normalizeRewardCode(current)):andThen(function(p2) -- line: 37
                    -- upvalues: v5 (copy), v11 (copy), HttpService (copy), getTitleData (copy)
                    local v14 = HttpService:GenerateGUID(false)

                    if p2.kind == "success" then
                        local v15, t3, v16

                        if p2.data.rewardType == "title" and p2.data.rewardTitleId ~= nil then
                            v15 = getTitleData(p2.data.rewardTitleId)
                            t3 = {}
                            v16 = if v15 ~= nil then v15.animatedColor else v15

                            if v16 ~= nil then
                                t3.color = v16
                            else
                                local v17 = if v15 == nil then v15 else v15.color

                                if v17 ~= nil then
                                    t3.color = v17
                                else
                                    t3.color = Color3.fromRGB(255, 255, 255)
                                end
                            end

                            if v15 ~= nil then
                                v15 = v15.displayName
                            end

                            if v15 == nil then
                                v15 = p2.data.rewardTitleId
                            end

                            t3.displayName = v15
                            v11(t3)

                            return nil
                        end

                        v5.onScreenFeedbackAdded({
                            message = "Code claimed successfully!",
                            type = "success",
                            id = v14
                        })
                    else
                        local v18 = p2.reason == "invalidCode" and "Invalid code" or "Code already claimed"

                        v5.onScreenFeedbackAdded({
                            type = "error",
                            id = v14,
                            message = v18
                        })
                    end
                end)
            end,
            position = UDim2.fromScale(0.52, 0.58),
            size = UDim2.fromScale(0.44, 0.22),
            strokeColor = v4
        }, react.createElement(default4, {
            text = "Claim",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v6.textFont2,
                Size = UDim2.fromScale(0.85, 0.75)
            },
            position = UDim2.fromScale(0.5, 0.5)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.97),
            Size = UDim2.fromScale(0.9, 0.28)
        }, react.createElement(default4, {
            text = "Join our Community in social links for\nexclusive OP Codes!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 3,
                Font = v6.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.5)
        })), v10 ~= nil and react.createElement(default5, {
            showIcon = false,
            title = "YOU UNLOCKED!",
            zIndex = 200,
            onFinished = function() -- onFinished | line: 187
                -- upvalues: v11 (copy)
                return v11(nil)
            end,
            onReveal = function() -- onReveal | line: 190
                -- upvalues: playSound (copy)
                return playSound()
            end,
            rewardText = v10.displayName,
            titleReward = v10,
            uiScale = v8 and 0.78 or 1
        }))
    end
}
