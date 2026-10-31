-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local memo, useCallback, useContext, useEffect = react.memo, react.useCallback, react.useContext, react.useEffect
local useRef, useState = react.useRef, react.useState
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectMostRecentFeedback = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "on-screen-feedback.selectors").selectMostRecentFeedback
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local selectEquippedInventoryItem = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectEquippedInventoryItem
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "transition").default
local useTransitionMotion = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "use-transition-motion").useTransitionMotion
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "faded-background").default
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local v1 = Color3.fromRGB(78, 254, 86)
local v2 = Color3.fromRGB(0, 100, 10)
local v3 = Color3.fromRGB(255, 80, 80)
local v4 = Color3.fromRGB(150, 0, 0)
local v5 = Color3.fromRGB(255, 255, 255)
local v6 = Color3.fromRGB(0, 0, 0)
local t1 = {
    time = 0.2
}

local function FeedbackDisplay(p1) -- line: 34
    -- upvalues: react (copy), useContext (copy), useTransitionMotion (copy), default2 (copy), default3 (copy), ThemeContext (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), t1 (copy)
    local count, message, position = p1.count, p1.message, p1.position

    if position == nil then
        position = UDim2.fromScale(0.5, 0.85)
    end

    local type, zIndex = p1.type, p1.zIndex

    if zIndex == nil then
        zIndex = 1
    end

    local v7 = useContext(ThemeContext)
    local v8 = useTransitionMotion({
        whenIn = 1,
        whenOut = 0
    }, {
        motionType = "tween",
        tweenOptions = t1
    })[1]
    local v9 = useTransitionMotion({
        whenIn = 0.45,
        whenOut = 1
    }, {
        motionType = "tween",
        tweenOptions = t1
    })[1]
    local v10 = useTransitionMotion({
        whenIn = 0,
        whenOut = 1
    }, {
        motionType = "tween",
        tweenOptions = t1
    })[1]
    local v11 = if type == "success" then v1 elseif type == "neutral" then v5 else v3
    local v12 = if type == "success" then v2 elseif type == "neutral" then v6 else v4

    if count > 1 then
        message = ("%* (x%*)"):format(message, count)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = position,
        Size = UDim2.fromScale(0.5, 0.065),
        ZIndex = zIndex
    }, react.createElement("uiscale", {
        Scale = v8
    }), react.createElement(default3, {
        backgroundTransparency = v9,
        cornerRadius = UDim.new(0.35, 0),
        zIndex = zIndex
    }), react.createElement(default2, {
        color = v11,
        overrideProps = {
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = v7.textFont,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.95, 0.85),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = zIndex + 1
        },
        strokeProps = {
            Thickness = 0.07,
            Color = v12,
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        },
        text = message,
        textTransparency = v10
    }))
end

return {
    FeedbackDisplay = FeedbackDisplay,
    default = memo(function() -- FeedbackManager | line: 106
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), useRootProducer (copy), useRootSelector (copy), selectMostRecentFeedback (copy), selectCurrentWindow (copy), selectEquippedInventoryItem (copy), localPlayerUserId (copy), default (copy), FeedbackDisplay (copy)
        local v13 = useRootProducer()
        local v14 = useRootSelector(selectMostRecentFeedback)
        local v15 = useRootSelector(selectCurrentWindow)
        local v16 = useRootSelector(selectEquippedInventoryItem(localPlayerUserId))

        if v16 ~= nil then
            v16 = v16.itemType
        end

        local v17 = v16 == "trainingWeight"
        local v18 = if v15 == "aquarium" then UDim2.fromScale(0.5, 0.12)
            elseif v15 == "none" then if v17 then UDim2.fromScale(0.5, 0.68) else UDim2.fromScale(0.5, 0.78)
            elseif v17 then UDim2.fromScale(0.5, 0.75)
            else UDim2.fromScale(0.5, 0.85)
        local v19, v20 = useState(nil)
        local v21, v22 = useState(1)
        local v23, v24 = useState(false)
        local v25 = useRef(nil)
        local v26 = useRef(nil)
        local v27 = useRef(v19)
        local v28 = useRef(v23)

        v27.current = v19
        v28.current = v23

        local v29 = useRef(nil)
        local v30 = useCallback(function() -- line: 131
            -- upvalues: v25 (copy), v26 (copy)
            if v25.current ~= nil then
                task.cancel(v25.current)
                v25.current = nil
            end

            if v26.current ~= nil then
                task.cancel(v26.current)
                v26.current = nil
            end
        end, {})
        local v31 = useCallback(function(p2) -- line: 141
            -- upvalues: v13 (copy)
            v13.onScreenFeedbackRemoved({
                id = p2
            })
        end, { v13 })
        local v32

        v32 = useCallback(function() -- line: 149
            -- upvalues: v20 (copy), v22 (copy), v24 (copy), v25 (copy), v26 (copy), v29 (copy), v32 (ref)
            local current = v29.current

            v29.current = nil

            if current == nil then
                v20(nil)
                v22(1)

                return nil
            end

            v20({
                timestamp = 0,
                duration = current.duration,
                id = current.id,
                message = current.message,
                type = current.type
            })
            v22(current.count)
            v24(true)

            local duration = current.duration

            if duration == nil then
                duration = 2
            end

            v25.current = task.delay(duration, function() -- line: 170
                -- upvalues: v24 (copy), v25 (copy), v26 (copy), v32 (ref)
                v25.current = nil
                v24(false)
                v26.current = task.delay(0.2, function() -- line: 173
                    -- upvalues: v26 (copy), v32 (ref)
                    v26.current = nil
                    v32()
                end)
            end)
        end, {})
        useEffect(function() -- line: 179
            -- upvalues: v14 (copy), v22 (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), v28 (copy), v29 (copy), v30 (copy), v31 (copy), v32 (ref)
            local current = v27.current
            local current2 = v28.current

            if v14 ~= nil then
                if current == nil or current.id ~= v14.id then
                    if current ~= nil and v14.message == current.message and v14.type == current.type then
                        v30()
                        v22(function(p3) -- line: 205
                            return p3 + 1
                        end)

                        if not current2 then
                            v24(true)
                        end

                        local id = current.id
                        local duration = v14.duration

                        if duration == nil then
                            duration = 2
                        end

                        v25.current = task.delay(duration, function() -- line: 223
                            -- upvalues: id (copy), v24 (copy), v25 (copy), v26 (copy), v31 (copy), v32 (ref)
                            v25.current = nil
                            v24(false)
                            v26.current = task.delay(0.2, function() -- line: 226
                                -- upvalues: id (copy), v26 (copy), v31 (copy), v32 (ref)
                                v26.current = nil
                                v31(id)
                                v32()
                            end)
                        end)
                        v31(v14.id)
                    else
                        local current2 = v29.current

                        if current2 ~= nil and current2.message == v14.message and current2.type == v14.type then
                            current2.count += 1
                        else
                            v29.current = {
                                count = 1,
                                duration = v14.duration,
                                id = v14.id,
                                message = v14.message,
                                type = v14.type
                            }
                        end

                        local v33

                        if current ~= nil then
                            if v26.current ~= nil then
                                v33 = false
                            else
                                v30()
                                v24(false)
                                v33 = true
                                v26.current = task.delay(0.2, function() -- line: 261
                                    -- upvalues: v26 (copy), v32 (ref)
                                    v26.current = nil
                                    v32()
                                end)
                            end
                        else
                            v30()
                            v33 = false
                            v32()
                        end

                        v31(v14.id)

                        if v33 then
                            v31(current.id)
                        end
                    end
                end
            elseif current ~= nil and current2 and v25.current == nil and v26.current == nil then
                v30()
                v24(false)
                v26.current = task.delay(0.2, function() -- line: 192
                    -- upvalues: v26 (copy), v32 (ref)
                    v26.current = nil
                    v32()
                end)
            end

            return nil
        end, { v14, v30, v31, v32 })

        if v19 == nil then
            return nil
        end

        return react.createElement(default, {
            doEnterTransitionOnFirstMount = true,
            ["in"] = v23
        }, react.createElement(FeedbackDisplay, {
            count = v21,
            message = v19.message,
            position = v18,
            type = v19.type,
            zIndex = if v15 == "celebrationEventShop" then 100 else nil
        }))
    end)
}
