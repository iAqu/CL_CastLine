-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef = react.useCallback, react.useEffect, react.useRef
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, RunService, Workspace = services.Players, services.RunService, services.Workspace
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local default2 = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-countdown").default
local useFlameworkComponents = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-flamework-components").useFlameworkComponents
local selectLuckyBlockNextDropTimestamp = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "lucky-block-drop.selectors").selectLuckyBlockNextDropTimestamp
local v1 = Color3.fromRGB(255, 255, 255)

local function formatMmSs(p1) -- line: 27
    local v3 = math.max(0, (math.floor(p1)))
    local v5 = math.floor(v3 / 60)
    local v6 = v3 % 60

    local function v7(p2) -- line: 31
        if p2 < 10 then
            return (("0%*"):format(p2))
        end

        return (tostring(p2))
    end

    return (("%*:%*"):format(if v5 < 10 then ("0%*"):format(v5) else tostring(v5), if v6 < 10 then ("0%*"):format(v6) else tostring(v6)))
end

local function useFloatingBobAndSpin(p3) -- line: 39
    -- upvalues: useEffect (copy), useRef (copy), RunService (copy), Workspace (copy)
    local v8 = useRef()

    if v8.current == nil then
        v8.current = p3:GetPivot()
    end

    useEffect(function() -- line: 44
        -- upvalues: p3 (copy), v8 (copy), RunService (copy), Workspace (copy)
        local current = v8.current
        local connection = RunService.Heartbeat:Connect(function() -- line: 46
            -- upvalues: current (copy), p3 (copy), Workspace (copy)
            local ServerTimeNow = Workspace:GetServerTimeNow()
            local v10 = math.sin(ServerTimeNow / 3 * 6.283185307179586) * 0.75
            local v11 = ServerTimeNow / 8 * 6.283185307179586 % 6.283185307179586

            p3:PivotTo(current * CFrame.new(0, v10, 0) * CFrame.Angles(0, v11, 0))
        end)

        return function() -- line: 63
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, { p3 })
end

local function LuckyBlockDisplayBillboard(p4) -- line: 68
    -- upvalues: react (copy), useCallback (copy), createPortal (copy), Players (copy), default (copy), useRootProducer (copy), useRootSelector (copy), default2 (copy), selectLuckyBlockNextDropTimestamp (copy), v1 (copy), formatMmSs (copy), useFloatingBobAndSpin (copy)
    local v13 = useRootProducer()
    local secondsLeft = default2((useRootSelector(selectLuckyBlockNextDropTimestamp))).secondsLeft

    useFloatingBobAndSpin(p4.component.instance)

    local v15 = useCallback(function(_, p6) -- line: 74
        -- upvalues: v13 (copy), Players (copy)
        if p6 ~= Players.LocalPlayer then
            return nil
        end

        v13.windowOpened({
            currentWindow = "luckyBlockChances"
        })
    end, { v13 })

    return createPortal(react.createElement(react.Fragment, nil, react.createElement("billboardgui", {
        AlwaysOnTop = true,
        LightInfluence = 0,
        MaxDistance = 150,
        StudsOffsetWorldSpace = Vector3.new(0, 4, 0),
        Adornee = p4.component.instance,
        Size = UDim2.fromScale(18, 3.9)
    }, react.createElement(default, {
        shadowYScale = 0.07,
        color = v1,
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        text = secondsLeft:map(function(p7) -- line: 97
            -- upvalues: formatMmSs (copy)
            return (("DROPPING IN %*"):format((formatMmSs(p7))))
        end)
    })), react.createElement("proximityprompt", {
        ActionText = "View Chances",
        HoldDuration = 0.1,
        MaxActivationDistance = 10,
        ObjectText = "Lucky Block",
        RequiresLineOfSight = false,
        Event = {
            Triggered = v15
        },
        KeyboardKeyCode = Enum.KeyCode.E
    })), p4.component.instance)
end

return {
    default = function() -- LuckyBlockDisplayManager | line: 112
        -- upvalues: react (copy), useFlameworkComponents (copy), LuckyBlockDisplayBillboard (copy)
        local v16 = useFlameworkComponents(function() -- line: 113
            return true
        end, "client/components/lucky-block-display-component@LuckyBlockDisplayComponent")
        local v17 = table.create(#v16)

        local function v18(p8) -- line: 118
            -- upvalues: react (copy), LuckyBlockDisplayBillboard (copy)
            return react.createElement(LuckyBlockDisplayBillboard, {
                component = p8,
                key = tostring(p8.instance)
            })
        end

        for v19, v20 in v16 do
            local _ = v19 - 1

            v17[v19] = react.createElement(LuckyBlockDisplayBillboard, {
                component = v20,
                key = tostring(v20.instance)
            })
        end

        return react.createElement(react.Fragment, nil, v17)
    end
}
