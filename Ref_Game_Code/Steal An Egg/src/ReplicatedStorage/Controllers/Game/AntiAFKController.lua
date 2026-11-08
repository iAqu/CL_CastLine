-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local AfkProtection = require(ReplicatedStorage.Shared.Types.AfkProtection)
local AfkTreadmillTest = require(ReplicatedStorage.Shared.Modules.AfkTreadmillTest)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local LocalPlayer = Players.LocalPlayer
local v1 = false

return {
    Start = function() -- Start | line: 26
        -- upvalues: TeleportService (copy), UserInputService (copy), AfkProtection (copy), AfkTreadmillTest (copy), Constants (copy), Remotes (copy), LocalPlayer (copy), v1 (ref)
        local function connectActivityInputs(p1) -- line: 31
            -- upvalues: UserInputService (copy)
            UserInputService.InputBegan:Connect(function() -- line: 32
                -- upvalues: p1 (copy)
                p1()
            end)
            UserInputService.InputChanged:Connect(function(p2) -- line: 35
                -- upvalues: p1 (copy)
                if p2.UserInputType == Enum.UserInputType.MouseMovement or p2.UserInputType == Enum.UserInputType.Touch or string.find(p2.UserInputType.Name, "Gamepad") ~= nil then
                    p1()
                end
            end)
        end

        local function startControlBehaviour() -- line: 52
            -- upvalues: connectActivityInputs (copy), TeleportService (copy), Constants (copy), Remotes (copy), LocalPlayer (copy)
            local v2 = false

            local function reportAfkState(p3) -- line: 55
                -- upvalues: v2 (ref), Remotes (copy)
                if v2 ~= p3 then
                    v2 = p3
                    Remotes.Telemetry.SubmitIdleState:FireServer(p3)
                end
            end

            local function reportActiveFromInput() -- line: 64
                -- upvalues: v2 (ref), Remotes (copy)
                if v2 and v2 ~= false then
                    v2 = false
                    Remotes.Telemetry.SubmitIdleState:FireServer(false)
                end
            end

            LocalPlayer.Idled:Connect(function(p4) -- line: 72
                -- upvalues: v2 (ref), TeleportService (copy), Constants (copy), Remotes (copy), LocalPlayer (copy)
                if p4 >= 60 and v2 ~= true then
                    v2 = true
                    Remotes.Telemetry.SubmitIdleState:FireServer(true)
                end

                if not (p4 > 1080) or Constants.IS_STUDIO then
                    return
                end

                local function v3() -- line: 78
                    -- upvalues: Remotes (copy)
                    Remotes.Telemetry.AskIdleHopFlush:InvokeServer()
                end

                pcall(v3)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
            connectActivityInputs(reportActiveFromInput)
        end

        local function startVariantBehaviour() -- line: 88
            -- upvalues: connectActivityInputs (copy), TeleportService (copy), AfkProtection (copy), Constants (copy), Remotes (copy), LocalPlayer (copy)
            local TELEPORT_IDLE_THRESHOLD_SECONDS, CLIENT_FALLBACK_IDLE_THRESHOLD_SECONDS, IDLE_POLL_INTERVAL_SECONDS, TELEPORT_REQUEST_RETRY_INTERVAL_SECONDS = AfkProtection.TELEPORT_IDLE_THRESHOLD_SECONDS, AfkProtection.CLIENT_FALLBACK_IDLE_THRESHOLD_SECONDS, AfkProtection.IDLE_POLL_INTERVAL_SECONDS, AfkProtection.TELEPORT_REQUEST_RETRY_INTERVAL_SECONDS
            local TELEPORT_DATA_KEY = AfkProtection.TELEPORT_DATA_KEY
            local elapsed = os.clock()
            local n1 = 0
            local v4 = false
            local n2 = 0
            local v5 = false

            local function resolveIdleSeconds() -- line: 101
                -- upvalues: elapsed (ref), n1 (ref)
                return (math.max(os.clock() - elapsed, n1))
            end

            local function reportIdleState(p5) -- line: 105
                -- upvalues: v4 (ref), Remotes (copy)
                if v4 == p5 then
                    return
                end

                v4 = p5
                Remotes.Telemetry.SubmitIdleState:FireServer(p5)
                Remotes.IdleRescue.SubmitIdleFlag:FireServer(p5)
            end

            local function markActive() -- line: 115
                -- upvalues: elapsed (ref), n1 (ref), v4 (ref), n2 (ref), v5 (ref), Remotes (copy)
                elapsed = os.clock()
                n1 = 0
                n2 = 0
                v5 = false

                if v4 == false then
                    return
                end

                v4 = false
                Remotes.Telemetry.SubmitIdleState:FireServer(false)
                Remotes.IdleRescue.SubmitIdleFlag:FireServer(false)
            end

            local function requestTeleport() -- line: 123
                -- upvalues: TELEPORT_REQUEST_RETRY_INTERVAL_SECONDS (copy), n2 (ref), Remotes (copy)
                local elapsed = os.clock()

                if not (elapsed < n2) then
                    n2 = elapsed + TELEPORT_REQUEST_RETRY_INTERVAL_SECONDS
                    Remotes.IdleRescue.AskRescueHop:FireServer()
                end
            end

            local function fallbackTeleport() -- line: 133
                -- upvalues: TELEPORT_DATA_KEY (copy), v5 (ref), TeleportService (copy), Constants (copy), Remotes (copy), LocalPlayer (copy)
                if v5 or Constants.IS_STUDIO or Constants.IS_PRIVATE_SERVER then
                    return
                end

                v5 = true

                local function v8() -- line: 139
                    -- upvalues: Remotes (copy)
                    Remotes.Telemetry.AskIdleHopFlush:InvokeServer()
                end

                pcall(v8)
                TeleportService:Teleport(game.PlaceId, LocalPlayer, {
                    [TELEPORT_DATA_KEY] = true
                })
            end

            local function step() -- line: 145
                -- upvalues: TELEPORT_IDLE_THRESHOLD_SECONDS (copy), CLIENT_FALLBACK_IDLE_THRESHOLD_SECONDS (copy), TELEPORT_REQUEST_RETRY_INTERVAL_SECONDS (copy), elapsed (ref), n1 (ref), v4 (ref), n2 (ref), fallbackTeleport (copy), Remotes (copy)
                local v11 = math.max(os.clock() - elapsed, n1)

                if v11 < 60 then
                    return
                end

                if v4 ~= true then
                    v4 = true
                    Remotes.Telemetry.SubmitIdleState:FireServer(true)
                    Remotes.IdleRescue.SubmitIdleFlag:FireServer(true)
                end

                if TELEPORT_IDLE_THRESHOLD_SECONDS <= v11 then
                    local elapsed = os.clock()

                    if not (elapsed < n2) then
                        n2 = elapsed + TELEPORT_REQUEST_RETRY_INTERVAL_SECONDS
                        Remotes.IdleRescue.AskRescueHop:FireServer()
                    end
                end

                if CLIENT_FALLBACK_IDLE_THRESHOLD_SECONDS <= v11 then
                    fallbackTeleport()
                end
            end

            LocalPlayer.Idled:Connect(function(p6) -- line: 162
                -- upvalues: n1 (ref)
                n1 = p6
            end)
            connectActivityInputs(markActive)
            task.spawn(function() -- line: 168
                -- upvalues: TELEPORT_IDLE_THRESHOLD_SECONDS (copy), CLIENT_FALLBACK_IDLE_THRESHOLD_SECONDS (copy), IDLE_POLL_INTERVAL_SECONDS (copy), TELEPORT_REQUEST_RETRY_INTERVAL_SECONDS (copy), elapsed (ref), n1 (ref), v4 (ref), n2 (ref), fallbackTeleport (copy), Remotes (copy)
                while true do
                    task.wait(IDLE_POLL_INTERVAL_SECONDS)

                    local v14 = math.max(os.clock() - elapsed, n1)

                    if v14 < 60 then
                        continue
                    end

                    if v4 ~= true then
                        v4 = true
                        Remotes.Telemetry.SubmitIdleState:FireServer(true)
                        Remotes.IdleRescue.SubmitIdleFlag:FireServer(true)
                    end

                    if TELEPORT_IDLE_THRESHOLD_SECONDS <= v14 then
                        local elapsed = os.clock()

                        if not (elapsed < n2) then
                            n2 = elapsed + TELEPORT_REQUEST_RETRY_INTERVAL_SECONDS
                            Remotes.IdleRescue.AskRescueHop:FireServer()
                        end
                    end

                    if CLIENT_FALLBACK_IDLE_THRESHOLD_SECONDS <= v14 then
                        fallbackTeleport()
                    end
                end
            end)
        end

        local function startBehaviourOnce(p7) -- line: 176
            -- upvalues: startControlBehaviour (copy), startVariantBehaviour (copy), AfkTreadmillTest (copy), v1 (ref)
            if not v1 then
                v1 = true

                if p7 == AfkTreadmillTest.Groups.Variant then
                    startVariantBehaviour()
                else
                    startControlBehaviour()
                end
            end
        end

        task.spawn(function() -- line: 193
            -- upvalues: startControlBehaviour (copy), startVariantBehaviour (copy), AfkTreadmillTest (copy), LocalPlayer (copy), v1 (ref)
            local v15 = AfkTreadmillTest.GetGroupAsync(LocalPlayer)

            if not v1 then
                v1 = true

                if v15 == AfkTreadmillTest.Groups.Variant then
                    startVariantBehaviour()
                else
                    startControlBehaviour()
                end
            end
        end)
        task.delay(30, function() -- line: 197
            -- upvalues: startControlBehaviour (copy), startVariantBehaviour (copy), AfkTreadmillTest (copy), v1 (ref)
            local Control = AfkTreadmillTest.Groups.Control

            if not v1 then
                v1 = true

                if Control == AfkTreadmillTest.Groups.Variant then
                    startVariantBehaviour()
                else
                    startControlBehaviour()
                end
            end
        end)
    end
}
