-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local GuiService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").GuiService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectPinataBossDeathAnnouncement = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "pinata-boss-death-announcement.selectors").selectPinataBossDeathAnnouncement
local pinataBossRewardActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "pinata-boss-reward-active-atom").pinataBossRewardActiveAtom
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "faded-background").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "transition").default
local useTransitionMotion = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "use-transition-motion").useTransitionMotion
local t1 = {
    time = 0.3
}
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 214, 64)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 214, 64))
})
local t2 = {
    TextScaled = true,
    ZIndex = 93,
    Font = Enum.Font.FredokaOne,
    Size = UDim2.fromScale(1, 1),
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center
}

local function PinataBossDeathDisplay() -- line: 34
    -- upvalues: react (copy), GuiService (copy), default (copy), default2 (copy), useTransitionMotion (copy), t1 (copy), v1 (copy), t2 (copy)
    local v2 = useTransitionMotion({
        whenIn = 0,
        whenOut = 1
    }, {
        motionType = "tween",
        tweenOptions = t1
    })[1]
    local v3 = useTransitionMotion({
        whenIn = 0.4,
        whenOut = 1
    }, {
        motionType = "tween",
        tweenOptions = t1
    })[1]
    local t3 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0)
    }

    t3.Position = UDim2.fromScale(0.5, 0.1) + UDim2.fromOffset(0, GuiService:GetGuiInset().Y)
    t3.Size = UDim2.fromScale(0.6, 0.07)
    t3.ZIndex = 92

    return react.createElement("frame", t3, react.createElement(default2, {
        zIndex = 92,
        backgroundTransparency = v3,
        cornerRadius = UDim.new(0.35, 0)
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 93,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.95, 0.85)
    }, react.createElement(default, {
        text = "THE PINATA BOSS HAS BEEN DEFEATED!",
        color = v1,
        overrideProps = t2,
        strokeProps = {
            Color = Color3.fromRGB(80, 20, 0)
        },
        textTransparency = v2
    })))
end

return {
    default = function() -- PinataBossDeathBanner | line: 80
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), subscribe (copy), useRootSelector (copy), selectPinataBossDeathAnnouncement (copy), pinataBossRewardActiveAtom (copy), default3 (copy), PinataBossDeathDisplay (copy)
        local v4 = useRootSelector(selectPinataBossDeathAnnouncement)
        local v5, v6 = useState(nil)
        local v7, v8 = useState(false)
        local v9 = useRef(nil)
        local v10 = useRef(nil)

        useEffect(function() -- line: 86
            -- upvalues: v4 (copy), v6 (copy), v8 (copy), v9 (copy), v10 (copy), subscribe (copy), pinataBossRewardActiveAtom (copy)
            if v4 == nil or v4.id == v9.current then
                return nil
            end

            v9.current = v4.id

            local v11
            local v12 = task.delay(0.4, function() -- line: 99
                -- upvalues: v11 (ref), v4 (copy), v6 (copy), v8 (copy), v10 (copy), subscribe (copy), pinataBossRewardActiveAtom (copy)
                if not pinataBossRewardActiveAtom() then
                    v6(v4)
                    v8(true)
                    v10.current = task.delay(3, function() -- line: 94
                        -- upvalues: v8 (copy)
                        v8(false)
                    end)

                    return nil
                end

                v11 = subscribe(pinataBossRewardActiveAtom, function(p1) -- line: 104
                    -- upvalues: v11 (ref), v4 (copy), v6 (copy), v8 (copy), v10 (copy)
                    if p1 then
                        return nil
                    end

                    local v13 = v11

                    if v13 ~= nil then
                        v13()
                    end

                    v6(v4)
                    v8(true)
                    v10.current = task.delay(3, function() -- line: 94
                        -- upvalues: v8 (copy)
                        v8(false)
                    end)
                end)
            end)

            return function() -- line: 115
                -- upvalues: v11 (ref), v12 (copy), v10 (copy)
                task.cancel(v12)

                local v14 = v11

                if v14 ~= nil then
                    v14()
                end

                if v10.current ~= nil then
                    task.cancel(v10.current)
                end
            end
        end, { v4 })

        if v5 == nil then
            return nil
        end

        return react.createElement(default3, {
            doEnterTransitionOnFirstMount = true,
            ["in"] = v7
        }, react.createElement(PinataBossDeathDisplay))
    end
}
