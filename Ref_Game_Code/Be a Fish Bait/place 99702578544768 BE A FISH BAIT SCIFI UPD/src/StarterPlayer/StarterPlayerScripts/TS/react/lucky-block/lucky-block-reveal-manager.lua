-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useCamera, useMotion = out.useCamera, out.useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage, RunService, Workspace = services.Players, services.ReplicatedStorage, services.RunService, services.Workspace
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useCyclingSelection = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-cycling-selection").useCyclingSelection
local useConfig = RuntimeLib.import(script, script.Parent.Parent, "context", "config-context").useConfig
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local selectLuckyBlockReveal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "lucky-block-drop.selectors").selectLuckyBlockReveal
local baseFov = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils").baseFov
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "faded-background").default
local default2 = RuntimeLib.import(script, script.Parent, "lucky-block-roll-item").default
local luckyBlockRewardVisuals = RuntimeLib.import(script, script.Parent, "lucky-block-reward-visuals").luckyBlockRewardVisuals
local t1 = {
    frequency = 0.3,
    damping = 0.3
}

local function useRevealCameraZoom(p1, p2) -- line: 44
    -- upvalues: useEffect (copy), useCamera (copy), useMotion (copy), Players (copy), Workspace (copy), baseFov (copy), t1 (copy)
    local v1 = useCamera()
    local _, v2 = useMotion(v1.FieldOfView)

    useEffect(function() -- line: 47
        -- upvalues: p1 (copy), Players (copy)
        if not p1 then
            return nil
        end

        local LocalPlayer = Players.LocalPlayer
        local CameraMinZoomDistance, CameraMaxZoomDistance = LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance

        LocalPlayer.CameraMinZoomDistance = 22
        LocalPlayer.CameraMaxZoomDistance = 22

        return function() -- line: 59
            -- upvalues: LocalPlayer (copy), CameraMinZoomDistance (copy), CameraMaxZoomDistance (copy)
            LocalPlayer.CameraMinZoomDistance = CameraMinZoomDistance
            LocalPlayer.CameraMaxZoomDistance = CameraMaxZoomDistance
        end
    end, { p1 })
    useEffect(function() -- line: 64
        -- upvalues: v1 (copy), v2 (copy), baseFov (copy)
        local v3 = v2:onStep(function(p3) -- line: 65
            -- upvalues: v1 (copy)
            v1.FieldOfView = p3
        end)

        return function() -- line: 68
            -- upvalues: v3 (copy), v1 (copy), baseFov (copy)
            v3()
            v1.FieldOfView = baseFov
        end
    end, { v2, v1 })
    useEffect(function() -- line: 73
        -- upvalues: p1 (copy), p2 (copy), v2 (copy), Workspace (copy), baseFov (copy), t1 (copy)
        if not p1 or p2 <= 0 then
            v2:spring(baseFov, t1)

            return nil
        end

        local v4 = p2 - Workspace:GetServerTimeNow()

        if v4 < 1 then
            return nil
        end

        v2:tween(50, {
            time = v4
        })

        local v5 = task.delay(v4, function() -- line: 85
            -- upvalues: v2 (copy), baseFov (copy), t1 (copy)
            return v2:spring(baseFov, t1)
        end)

        return function() -- line: 88
            -- upvalues: v5 (copy)
            return task.cancel(v5)
        end
    end, { p1, p2, v2 })
end

return {
    default = function() -- LuckyBlockRevealManager | line: 93
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), ReplicatedStorage (copy), RunService (copy), Workspace (copy), useRootProducer (copy), useRootSelector (copy), useCyclingSelection (copy), useConfig (copy), localPlayerUserId (copy), selectLuckyBlockReveal (copy), default (copy), default2 (copy), luckyBlockRewardVisuals (copy), useRevealCameraZoom (copy)
        local v6 = useRootProducer()
        local getSound = useConfig().getSound
        local v7 = useRootSelector(selectLuckyBlockReveal)
        local v8 = v7 ~= nil and tostring(v7.winnerUserId) == localPlayerUserId
        local v9, v10 = useState(function() -- line: 99
            -- upvalues: Workspace (copy)
            return Workspace:GetServerTimeNow()
        end)
        local v11 = v8

        useEffect(function() -- line: 102
            -- upvalues: v10 (copy), v11 (copy), RunService (copy), Workspace (copy)
            if not v11 then
                return nil
            end

            local connection = RunService.Heartbeat:Connect(function() -- line: 106
                -- upvalues: v10 (copy), Workspace (copy)
                return v10(Workspace:GetServerTimeNow())
            end)

            return function() -- line: 109
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v8 })

        local v12 = if v7 == nil then v7 else v7.rewardPool

        if v12 == nil then
            v12 = {}
        end

        local v13 = if v7 == nil then v7 else v7.expireTimestamp

        if v13 == nil then
            v13 = 0
        end

        local v14 = not v8 or v13 <= v9

        useRevealCameraZoom(v8 and not v14, v13)

        local v15 = useRef(nil)

        useEffect(function() -- line: 136
            -- upvalues: v6 (copy), v7 (copy), v11 (copy), v15 (copy), v14 (copy), luckyBlockRewardVisuals (copy)
            if not v11 or v7 == nil or not v14 or v15.current == v7.dropId then
                return nil
            end

            v15.current = v7.dropId
            v6.onScreenFeedbackAdded({
                type = "success",
                id = ("luckyBlockReward:%*"):format(v7.dropId),
                message = ("You got: %*!"):format(luckyBlockRewardVisuals[v7.awardedReward].label)
            })
        end, { v8, v14, v6, v7 })

        local v16 = useCyclingSelection({
            baseInterval = 0.08,
            maxInterval = 0.35,
            expireTimestamp = v13,
            isActive = v8 and not v14,
            items = v12
        })
        local v17 = useRef(-1)

        useEffect(function() -- line: 159
            -- upvalues: getSound (copy), v11 (copy), v16 (copy), v17 (copy), v14 (copy)
            if not v11 or v14 or v16 == v17.current then
                return nil
            end

            v17.current = v16
            getSound("FishNibble"):Play()
        end, { v16, v8, v14, getSound })

        local v18 = useRef(nil)

        useEffect(function() -- line: 170
            -- upvalues: v7 (copy), v11 (copy), v18 (copy), v14 (copy), ReplicatedStorage (copy)
            if not v11 or v7 == nil or not v14 or v18.current == v7.dropId then
                return nil
            end

            v18.current = v7.dropId

            local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

            if Sounds ~= nil then
                Sounds = Sounds:FindFirstChild("sfx")

                if Sounds ~= nil then
                    Sounds = Sounds:FindFirstChild("SkillCheckSuccess")
                end
            end

            if if Sounds == nil then Sounds else Sounds:IsA("Sound") then
                Sounds:Play()
            end
        end, { v8, v14, v7 })

        if v8 then
            v8 = v7 ~= nil and v9 < v13 + 2 and #v12 > 0
        end

        local v19

        if v7 ~= nil then
            for v20, v21 in v12 do
                local _ = v20 - 1

                if v21.reward == v7.awardedReward == true then
                    v19 = v21
                    break
                end

                v19 = nil
            end
        end

        if not v14 then
            v19 = v12[v16 % #v12 + 1]
        end

        if not v8 or v19 == nil then
            return nil
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.26, 0.3)
        }, react.createElement(default, {
            backgroundTransparency = 0.35,
            zIndex = 1
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.85, 0.85)
        }, react.createElement(default2, {
            chancePercent = v19.chance * 100,
            isSettled = v14,
            reward = v19.reward
        })))
    end
}
