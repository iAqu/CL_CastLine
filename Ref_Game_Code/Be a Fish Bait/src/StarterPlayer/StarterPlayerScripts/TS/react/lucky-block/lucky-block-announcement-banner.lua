-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local GuiService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").GuiService
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "faded-background").default
local selectLuckyBlockBanner = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "lucky-block-drop.selectors").selectLuckyBlockBanner

local function LuckyBlockAnnouncementText(p1) -- line: 20
    -- upvalues: react (copy), GuiService (copy), useTheme (copy), default (copy), default2 (copy)
    local message, textTransparency = p1.message, p1.textTransparency
    local v1 = useTheme()
    local v2 = if type(textTransparency) == "number" then 0.4 + textTransparency * 0.6 else textTransparency:map(function(p2) -- line: 24
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
        text = message,
        textTransparency = textTransparency
    }))
end

return {
    LuckyBlockAnnouncementText = LuckyBlockAnnouncementText,
    default = function() -- LuckyBlockAnnouncementBanner | line: 56
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), useRootSelector (copy), selectLuckyBlockBanner (copy), LuckyBlockAnnouncementText (copy)
        local v3 = useRootSelector(selectLuckyBlockBanner)
        local v4, v5 = useState(false)
        local v6, v7 = useMotion(0)
        local v8 = useRef(nil)
        local v9 = useRef(nil)
        local v10 = useRef(nil)

        useEffect(function() -- line: 63
            -- upvalues: v3 (copy), v5 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy)
            if v3 == nil or v3.id == v8.current then
                return nil
            end

            v8.current = v3.id

            if v9.current ~= nil then
                task.cancel(v9.current)
            end

            if v10.current ~= nil then
                task.cancel(v10.current)
            end

            v5(true)
            v7:immediate(0)
            v9.current = task.delay(2, function() -- line: 83
                -- upvalues: v5 (copy), v7 (copy), v10 (copy)
                v7:tween(1, {
                    time = 1,
                    style = Enum.EasingStyle.Quad
                })
                v10.current = task.delay(1, function() -- line: 88
                    -- upvalues: v5 (copy)
                    return v5(false)
                end)
            end)
        end, { v3 })

        if v3 == nil then
            return react.createElement(react.Fragment)
        end

        return react.createElement(react.Fragment, nil, v4 and react.createElement(LuckyBlockAnnouncementText, {
            message = v3.message,
            textTransparency = v6
        }))
    end
}
