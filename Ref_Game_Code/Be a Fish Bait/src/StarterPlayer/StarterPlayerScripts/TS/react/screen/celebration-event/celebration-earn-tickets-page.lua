-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local LabeledImageSlot = RuntimeLib.import(script, script.Parent, "celebration-placeholder-image").LabeledImageSlot
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 240, 255)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(90, 190, 255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(30, 140, 245)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 70, 180))
})
local v2 = Color3.fromRGB(10, 40, 90)
local t1 = {
    {
        description = "CATCH FISH ICON\nEvery catch can carry FOMO Tickets",
        label = "Catch Fish",
        image = images.catchFishTicketImage
    },
    {
        description = "FOMOBBY ICON\nCurrent island minigame that awards Tickets",
        label = "FOMObby",
        image = images.obbyImage
    },
    {
        description = "RED LIGHT GREEN LIGHT ICON\nAnother current minigame that awards Tickets",
        label = "Red Light Green Light",
        image = images.rlglImage
    },
    {
        description = "REACTION TEST ICON\nThird current minigame that awards Tickets",
        label = "Reaction Test",
        image = images.reactionTestImage
    },
    {
        description = "DAILY LOGIN ICON\nReturn each day for free Tickets",
        label = "Login Daily + Challenge",
        textYSize = 0.16,
        image = images.dailyLoginChallengeImage
    }
}

return {
    default = function() -- CelebrationEarnTicketsPage | line: 42
        -- upvalues: react (copy), default (copy), useTheme (copy), LabeledImageSlot (copy), v1 (copy), v2 (copy), t1 (copy)
        local v3 = useTheme()
        local v4 = react.createElement(default, {
            text = "How to Earn FOMO Tickets",
            anchorPoint = Vector2.new(0.5, 0),
            color = v1,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Font = v3.textFont2,
                Size = UDim2.fromScale(0.72, 0.07)
            },
            popoutColor = v2,
            position = UDim2.fromScale(0.5, 0.06),
            strokeProps = {
                Color = v2
            }
        })
        local v5 = react.createElement("uigridlayout", {
            FillDirectionMaxCells = 5,
            CellPadding = UDim2.fromScale(0.02, 0),
            CellSize = UDim2.fromScale(0.1825, 1),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v6 = table.create(#t1)

        local function v7(p1, p2) -- line: 69
            -- upvalues: react (copy), LabeledImageSlot (copy)
            local t2 = {
                textYPosition = 0.825,
                description = p1.description,
                image = p1.image,
                key = p1.label,
                label = p1.label,
                layoutOrder = p2
            }
            local textYSize = p1.textYSize

            t2.textYSize = if textYSize == nil then 0.1 else textYSize

            return react.createElement(LabeledImageSlot, t2)
        end

        for v8, v9 in t1 do
            v6[v8] = v7(v9, v8 - 1, t1)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, v4, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.25),
            Size = UDim2.fromScale(0.8, 0.64)
        }, v5, v6))
    end
}
