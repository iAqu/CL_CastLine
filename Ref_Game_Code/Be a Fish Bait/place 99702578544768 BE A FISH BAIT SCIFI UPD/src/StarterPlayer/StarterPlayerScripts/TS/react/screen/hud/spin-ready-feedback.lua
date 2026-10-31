-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local memo, useEffect, useRef, useState = react.memo, react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local GuiService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").GuiService
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local selectPlayerMetadata = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerMetadata
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "faded-background").default

local function SpinReadyText(p1) -- line: 29
    -- upvalues: react (copy), GuiService (copy), useTheme (copy), default (copy), default2 (copy)
    local textTransparency = p1.textTransparency
    local v1 = useTheme()
    local v2 = if type(textTransparency) == "number" then 0.4 + textTransparency * 0.6 else textTransparency:map(function(p2) -- line: 34
        return 0.4 + p2 * 0.6
    end)
    local t1 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0)
    }

    t1.Position = UDim2.fromScale(0.5, 0.1) + UDim2.fromOffset(0, GuiService:GetGuiInset().Y)
    t1.Size = UDim2.fromScale(0.55, 0.07)

    return react.createElement("frame", t1, react.createElement(default2, {
        zIndex = 1,
        backgroundTransparency = v2
    }), react.createElement(default, {
        text = "Your Spin is ready!",
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = v1.textFont2,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.95, 0.85),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.06
        },
        textTransparency = textTransparency
    }))
end

return {
    SpinReadyText = SpinReadyText,
    default = memo(function() -- SpinReadyFeedback | line: 66
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), useRootSelector (copy), selectTutorialStep (copy), selectPlayerMetadata (copy), tutorialSteps (copy), localPlayerUserId (copy), SpinReadyText (copy)
        local v3 = useRootSelector(selectTutorialStep)
        local v4 = useRootSelector(selectPlayerMetadata(localPlayerUserId))

        if v4 ~= nil then
            v4 = v4.spinWheelSpinsGrantedToday
        end

        if v4 == nil then
            v4 = 0
        end

        local v5 = tutorialSteps.completed <= v3
        local v6, v7 = useState(false)
        local v8, v9 = useMotion(0)
        local v10 = useRef(v4)

        useEffect(function() -- line: 97
            -- upvalues: v4 (ref), v7 (copy), v9 (copy), v10 (copy), v5 (copy)
            if not v5 then
                v10.current = v4

                return nil
            end

            local current = v10.current

            v10.current = v4

            if not (current < v4) then
                return
            end

            v7(true)
            v9:set(0)
            task.delay(2, function() -- line: 86
                -- upvalues: v7 (copy), v9 (copy)
                v9:tween(1, {
                    time = 1,
                    style = Enum.EasingStyle.Quad
                })
                task.delay(1, function() -- line: 91
                    -- upvalues: v7 (copy)
                    return v7(false)
                end)
            end)
        end, { v4, v5 })

        if not v5 then
            return react.createElement(react.Fragment)
        end

        return react.createElement(react.Fragment, nil, v6 and react.createElement(SpinReadyText, {
            textTransparency = v8
        }))
    end)
}
