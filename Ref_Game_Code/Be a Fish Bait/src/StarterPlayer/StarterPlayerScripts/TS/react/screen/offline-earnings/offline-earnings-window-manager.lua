-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef = react.useCallback, react.useEffect, react.useRef
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, ReplicatedStorage, Workspace = services.HttpService, services.ReplicatedStorage, services.Workspace
local cameraShakeEnabledAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics").cameraShakeEnabledAtom
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local moneyConfettiTriggerAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "money-confetti-atom").moneyConfettiTriggerAtom
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local selectPlayerPendingOfflineEarnings = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerPendingOfflineEarnings
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local offlineEarningsMultiplierProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").offlineEarningsMultiplierProductId
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local default = RuntimeLib.import(script, script.Parent, "offline-earnings-window").default

return {
    default = function() -- OfflineEarningsWindowManager | line: 29
        -- upvalues: RuntimeLib (copy), react (copy), useCallback (copy), useEffect (copy), useRef (copy), HttpService (copy), ReplicatedStorage (copy), Workspace (copy), cameraShakeEnabledAtom (copy), shake (copy), moneyConfettiTriggerAtom (copy), useRootProducer (copy), useRootSelector (copy), events (copy), functions (copy), attemptStorePurchase (copy), selectPlayerPendingOfflineEarnings (copy), selectCurrentWindow (copy), localPlayerUserId (copy), offlineEarningsMultiplierProductId (copy), abbreviate (copy), default (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectPlayerPendingOfflineEarnings(localPlayerUserId))
        local v3 = useRootSelector(selectCurrentWindow)
        local v4 = useCallback(function() -- line: 33
            -- upvalues: v1 (copy)
            v1.windowClosed({})
        end, { v1 })
        local v5 = useRef(false)

        useEffect(function() -- line: 37
            -- upvalues: v2 (copy), v3 (copy), v4 (copy), v5 (copy)
            if v2 == 0 then
                if v5.current and v3 == "offlineEarnings" then
                    v4()
                end
            else
                v5.current = true
            end
        end, { v2, v3, v4 })

        local v6 = useCallback(function(p1) -- line: 44
            -- upvalues: v1 (copy), HttpService (copy), abbreviate (copy)
            v1.onScreenFeedbackAdded({
                type = "success",
                id = HttpService:GenerateGUID(false),
                message = ("Collected $%* offline earnings!"):format((abbreviate(p1)))
            })
        end, { v1 })
        local v7 = useRef(v2)
        local v8 = useRef(v6)

        useEffect(function() -- line: 54
            -- upvalues: v2 (copy), v6 (copy), v7 (copy), v8 (copy)
            v7.current = v2
            v8.current = v6
        end)
        useEffect(function() -- line: 58
            -- upvalues: v7 (copy), v8 (copy), RuntimeLib (copy), functions (copy)
            return function() -- line: 59
                -- upvalues: v7 (copy), v8 (copy), RuntimeLib (copy), functions (copy)
                if v7.current > 0 then
                    task.spawn(RuntimeLib.async(function() -- line: 61
                        -- upvalues: v8 (copy), RuntimeLib (copy), functions (copy)
                        local v9 = RuntimeLib.await(functions.claimOfflineEarnings())

                        if v9 ~= false and v9 > 0 then
                            v8.current(v9)
                        end
                    end))
                end
            end
        end, {})

        local v10 = useCallback(function() -- line: 70
            -- upvalues: v4 (copy), v6 (copy), RuntimeLib (copy), functions (copy)
            task.spawn(RuntimeLib.async(function() -- line: 71
                -- upvalues: v6 (copy), RuntimeLib (copy), functions (copy)
                local v11 = RuntimeLib.await(functions.claimOfflineEarnings())

                if v11 ~= false and v11 > 0 then
                    v6(v11)
                end
            end))
            v4()
        end, { v4, v6 })
        local v12 = useCallback(function() -- line: 79
            -- upvalues: ReplicatedStorage (copy), Workspace (copy), cameraShakeEnabledAtom (copy), shake (copy), moneyConfettiTriggerAtom (copy)
            moneyConfettiTriggerAtom(function(p2) -- line: 81
                return p2 + 1
            end)

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

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera and cameraShakeEnabledAtom() then
                local v13 = shake.new()

                v13.Amplitude = 1.5
                v13.Frequency = 0.15
                v13.FadeInTime = 0
                v13.FadeOutTime = 0.6
                v13.SustainTime = 0.05
                v13.PositionInfluence = Vector3.new(0.3, 0.3, 0.3)
                v13.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
                v13:Start()
                v13:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p3, p4) -- line: 112
                    -- upvalues: CurrentCamera (copy)
                    local _CFrame = CurrentCamera.CFrame
                    local v14 = CFrame.new(p3)
                    local v15 = CFrame.fromEulerAnglesXYZ(p4.X, p4.Y, p4.Z)

                    CurrentCamera.CFrame = _CFrame * v14 * v15
                end)
            end
        end, {})
        local v16 = useCallback(function() -- line: 120
            -- upvalues: v4 (copy), v6 (copy), v12 (copy), RuntimeLib (copy), functions (copy)
            task.spawn(RuntimeLib.async(function() -- line: 121
                -- upvalues: v6 (copy), RuntimeLib (copy), functions (copy)
                local v17 = RuntimeLib.await(functions.claimOfflineEarnings())

                if v17 ~= false and v17 > 0 then
                    v6(v17)
                end
            end))
            v12()
            v4()
        end, { v12, v4, v6 })
        local v18 = useCallback(function() -- line: 130
            -- upvalues: events (copy), attemptStorePurchase (copy), offlineEarningsMultiplierProductId (copy)
            events.snapshotOfflineEarningsForPurchase()
            attemptStorePurchase(offlineEarningsMultiplierProductId)
        end, {})

        return react.createElement(default, {
            robuxCost = 39,
            amount = v2,
            onClaim = v16,
            onClaimMultiply = v18,
            onClose = v10
        })
    end
}
