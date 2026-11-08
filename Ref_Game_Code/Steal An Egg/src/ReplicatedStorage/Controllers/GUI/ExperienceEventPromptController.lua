-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Shared.Globals.Constants)

local EggState = require(ReplicatedStorage.Client.EggState)
local ExpandedLobby = require(ReplicatedStorage.Data.ExpandedLobby)
local ExperienceEventPromptPolicy = require(ReplicatedStorage.Shared.Modules.ExperienceEventPromptPolicy)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Timer = require(ReplicatedStorage.Packages.Timer)
local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local Trove = require(ReplicatedStorage.Packages.Trove)
local PlayerAttributes = HalloweenDimension.PlayerAttributes
local t1 = {
    "InBossArena",
    "InScrambleArena",
    "InPumpkinArena",
    "TrainEventPhase",
    PlayerAttributes.Carrying,
    PlayerAttributes.PumpkinCarrying
}
local LocalPlayer = Players.LocalPlayer
local v1 = Trove.new()
local t2 = {}
local v2, v3, v4, v5
local v6 = false
local v7 = false
local v8 = false
local n1 = 0
local v9 = false

return {
    Start = function() -- Start | line: 48
        -- upvalues: SocialService (copy), Workspace (copy), EggState (copy), ExpandedLobby (copy), ExperienceEventPromptPolicy (copy), GuardAreaGeometry (copy), HalloweenDimension (copy), Player (copy), Remotes (copy), Timer (copy), ToolGameplayGuard (copy), PlayerAttributes (copy), t1 (copy), LocalPlayer (copy), v1 (copy), t2 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), n1 (ref), v9 (ref)
        local function IsExpandedLobbyServer() -- line: 49
            -- upvalues: Workspace (copy), ExpandedLobby (copy)
            return Workspace:GetAttribute(ExpandedLobby.ServerAttribute) == ExpandedLobby.Groups.Variant
        end

        local function IsBusy() -- line: 53
            -- upvalues: t1 (copy), LocalPlayer (copy), v9 (ref)
            if v9 then
                return true
            end

            for _, v10 in t1 do
                local Attribute = LocalPlayer:GetAttribute(v10)

                if Attribute ~= nil and Attribute ~= false then
                    return true
                end
            end

            local Character = LocalPlayer.Character

            return Character ~= nil and Character:GetAttribute("TrainEventInForgottenTown") == true
        end

        local function FindDimensionMap() -- line: 68
            -- upvalues: Workspace (copy), HalloweenDimension (copy)
            local v11 = Workspace:FindFirstChild(HalloweenDimension.MapName)

            return if v11 ~= nil and v11:IsA("Model") then v11 else nil
        end

        local function IsInDimensionRegion(p1, p2) -- line: 73
            local PlayRadius = p1:GetAttribute("PlayRadius")

            if type(PlayRadius) ~= "number" then
                PlayRadius = 700
            end

            local v12 = p2 - p1:GetPivot().Position

            return Vector3.new(v12.X, 0, v12.Z).Magnitude <= PlayRadius
        end

        local function IsInDimensionSafeZone(p3, p4) -- line: 82
            -- upvalues: GuardAreaGeometry (copy)
            local Zones = p3:FindFirstChild("Zones")
            local SafeZone = if Zones == nil then nil else Zones:FindFirstChild("SafeZone")

            return SafeZone ~= nil and SafeZone:IsA("BasePart") and GuardAreaGeometry.IsWithinFootprint(SafeZone, p4)
        end

        local function IsInSafeArea() -- line: 90
            -- upvalues: IsBusy (copy), Workspace (copy), ExperienceEventPromptPolicy (copy), GuardAreaGeometry (copy), HalloweenDimension (copy), Player (copy), ToolGameplayGuard (copy), PlayerAttributes (copy), LocalPlayer (copy)
            local v13 = Player.FindRootPart(LocalPlayer)

            if not v13 then
                return false
            end

            local Position = v13.Position
            local v14 = Workspace:FindFirstChild(HalloweenDimension.MapName)

            if v14 == nil or not v14:IsA("Model") then
                v14 = nil
            end

            local PlayRadius, v15

            if LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true then
                v15 = true
            elseif v14 ~= nil then
                PlayRadius = v14:GetAttribute("PlayRadius")

                if type(PlayRadius) ~= "number" then
                    PlayRadius = 700
                end

                local v16 = Position - v14:GetPivot().Position

                v15 = Vector3.new(v16.X, 0, v16.Z).Magnitude <= PlayRadius
            else
                v15 = false
            end

            local v17

            if not v15 then
                v17 = ToolGameplayGuard.IsLocalInsideArena()

                return ExperienceEventPromptPolicy.IsSafeToPrompt(true, v17, (IsBusy()))
            end

            if v14 ~= nil then
                local Zones = v14:FindFirstChild("Zones")
                local SafeZone = if Zones == nil then nil else Zones:FindFirstChild("SafeZone")

                v17 = not (SafeZone ~= nil and SafeZone:IsA("BasePart") and GuardAreaGeometry.IsWithinFootprint(SafeZone, Position))
            else
                v17 = true
            end

            return ExperienceEventPromptPolicy.IsSafeToPrompt(true, v17, (IsBusy()))
        end

        local function GetSoonestUnseenEvent() -- line: 107
            -- upvalues: SocialService (copy), ExperienceEventPromptPolicy (copy), t2 (copy)
            local function v18() -- line: 108
                -- upvalues: SocialService (copy)
                return SocialService:GetUpcomingExperienceEventsAsync()
            end

            local ok, result = pcall(v18)

            if ok and type(result) == "table" then
                return ExperienceEventPromptPolicy.GetSoonestUnseenEvent(result, t2), true
            end

            if not ok then
                warn((("Failed to get upcoming experience events: %*"):format(result)))
            end

            return nil, false
        end

        local function MarkSeen(p5) -- line: 121
            -- upvalues: Remotes (copy), t2 (copy)
            t2[p5] = true

            local function v19() -- line: 123
                -- upvalues: p5 (copy), Remotes (copy)
                return Remotes.SeasonBanner.FlagSeen:InvokeServer(p5)
            end

            local ok, result = pcall(v19)

            if ok then
                if result ~= true then
                    warn((("Server rejected experience event prompt acknowledgement for %*"):format(p5)))
                end
            else
                warn((("Failed to mark experience event prompt as seen: %*"):format(result)))
            end
        end

        local function PromptSoonestEvent() -- line: 133
            -- upvalues: IsInSafeArea (copy), GetSoonestUnseenEvent (copy), MarkSeen (copy), SocialService (copy)
            local v20, v21 = GetSoonestUnseenEvent()

            if v21 then
                if not v20 then
                    return "NoEvent"
                end

                local GetEventRsvpStatusAsync = SocialService.GetEventRsvpStatusAsync
                local Id = v20.Id
                local ok, result = pcall(GetEventRsvpStatusAsync, SocialService, Id)

                if ok then
                    if result == Enum.RsvpStatus.None then
                        if not IsInSafeArea() then
                            return "WaitForSafeArea"
                        end

                        local PromptRsvpToEventAsync = SocialService.PromptRsvpToEventAsync
                        local Id = v20.Id
                        local ok, result = pcall(PromptRsvpToEventAsync, SocialService, Id)

                        if ok then
                            MarkSeen(v20.Id)

                            return "Complete"
                        end

                        warn((("Failed to prompt for experience event RSVP: %*"):format(result)))

                        return "Retry"
                    end

                    MarkSeen(v20.Id)

                    return "Complete"
                end

                warn((("Failed to get experience event RSVP status: %*"):format(result)))
            end

            return "Retry"
        end

        local v22 = v1:Add(Timer.new(0.1))
        local v23 = v1:Add(Timer.new(ExperienceEventPromptPolicy.RetryDelaySeconds))
        local v24 = v1:Add(Timer.new(ExperienceEventPromptPolicy.NoEventRecheckSeconds))

        v2 = function() -- line: 172
            -- upvalues: v22 (copy)
            if not v22:IsRunning() then
                v22:Start()
            end
        end

        v3 = function() -- line: 178
            -- upvalues: v23 (copy), ExperienceEventPromptPolicy (copy), n1 (ref)
            n1 += 1

            if n1 >= ExperienceEventPromptPolicy.MaxAttempts then
                warn((("Experience event prompt stopped after %* failed attempts"):format(n1)))
            elseif not v23:IsRunning() then
                v23:Start()
            end
        end

        v4 = function() -- line: 189
            -- upvalues: v24 (copy)
            if not v24:IsRunning() then
                v24:Start()
            end
        end

        v5 = function() -- line: 195
            -- upvalues: IsInSafeArea (copy), PromptSoonestEvent (copy), Workspace (copy), ExpandedLobby (copy), Remotes (copy), t2 (copy), v2 (ref), v3 (ref), v4 (ref), v6 (ref), v7 (ref), v8 (ref), n1 (ref)
            if v8 then
                return
            end

            v8 = true

            if not v6 then
                local function v26() -- line: 202
                    -- upvalues: Remotes (copy)
                    return Remotes.SeasonBanner.FetchState:InvokeServer()
                end

                local v27, v28, v29 = pcall(v26)

                if not v27 or type(v28) ~= "boolean" or type(v29) ~= "table" then
                    if not v27 then
                        warn((("Failed to get experience event prompt state: %*"):format(v28)))
                    end

                    v8 = false
                    v3()

                    return
                end

                v6 = true
                v7 = v28
                n1 = 0

                for v30, v31 in v29 do
                    if type(v30) == "string" and v31 == true then
                        t2[v30] = true
                    end
                end
            end

            if not v7 then
                v8 = false

                return
            end

            if Workspace:GetAttribute(ExpandedLobby.ServerAttribute) == ExpandedLobby.Groups.Variant then
                v8 = false
            elseif IsInSafeArea() then
                local v32 = PromptSoonestEvent()

                v8 = false

                if v32 == "Retry" then
                    v3()
                elseif v32 == "NoEvent" then
                    v4()
                elseif v32 == "WaitForSafeArea" then
                    v2()
                end
            else
                v8 = false
                v2()
            end
        end

        v1:Connect(v22.Tick, function() -- line: 249
            -- upvalues: IsInSafeArea (copy), v22 (copy), v5 (ref)
            if IsInSafeArea() then
                v22:Stop()
                v5()
            end
        end)
        v1:Connect(v23.Tick, function() -- line: 257
            -- upvalues: v23 (copy), v5 (ref)
            v23:Stop()
            v5()
        end)
        v1:Connect(v24.Tick, function() -- line: 261
            -- upvalues: v24 (copy), v5 (ref)
            v24:Stop()
            v5()
        end)
        v1:Connect(EggState.CarryChanged, function(p6) -- line: 265
            -- upvalues: v9 (ref)
            v9 = p6.IsCarrying
        end)

        local v33 = v1:Add(Timer.new(ExperienceEventPromptPolicy.PromptDelaySeconds))

        v1:Connect(v33.Tick, function() -- line: 270
            -- upvalues: v33 (copy), v5 (ref)
            v33:Stop()
            v5()
        end)
        v9 = EggState.ReadCarryState().IsCarrying
        v1:AttachToInstance(script)
        v33:Start()
    end
}
