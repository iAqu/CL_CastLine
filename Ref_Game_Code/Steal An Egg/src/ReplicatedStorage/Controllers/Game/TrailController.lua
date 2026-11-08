-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

require(ReplicatedStorage.Shared.Globals.Constants)

local Log = require(ReplicatedStorage.Packages.Log)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trails = require(ReplicatedStorage.Data.Trails)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Log.new()

return {
    Start = function() -- Start | line: 35
        -- upvalues: Players (copy), ReplicatedStorage (copy), t (copy), Player (copy), Remotes (copy), Trails (copy), Trove (copy), v1 (copy)
        local Trails2 = ReplicatedStorage.Assets.Trails
        local t2 = {}
        local t3 = {}

        local function reconcileTrailVisual(p1) -- line: 46
            -- upvalues: Trails2 (copy), t2 (copy), Player (copy), Trails (copy)
            local v4 = assert(t2[p1], (("Missing trail renderer state for %*"):format(p1.Name)))

            v4.RenderRevision += 1

            local RenderRevision = v4.RenderRevision

            v4.CharacterTrove:Clean()

            local TrailId, Character = v4.TrailId, v4.Character

            if TrailId == nil or Character == nil then
                return
            end

            v4.CharacterTrove:Add(task.defer(function() -- line: 58
                -- upvalues: p1 (copy), v4 (copy), RenderRevision (copy), TrailId (copy), Character (copy), Trails2 (copy), t2 (copy), Player (copy), Trails (copy)
                assert(Trails.TrailNameExists(TrailId), (("Invalid active trail \"%*\""):format(TrailId)))

                local v7 = Player.WaitForRootPart(p1)

                if t2[p1] ~= v4 or v4.RenderRevision ~= RenderRevision or v4.Character ~= Character or v4.TrailId ~= TrailId or v7.Parent ~= Character then
                    return
                end

                local v8 = Trails2[TrailId]

                assert(v8:IsA("BasePart"), (("Trail asset \"%*\" must be a BasePart"):format(TrailId)))

                local clone = v8:Clone()

                v4.CharacterTrove:Add(clone)
                clone.Anchored = false
                clone.CanCollide = false
                clone.CanTouch = false
                clone.CanQuery = false
                clone.Massless = true
                clone.Transparency = 1
                clone.CFrame = v7.CFrame
                clone.Parent = v7

                local MainPartTrailWeldConstraint = clone.MainPartTrailWeldConstraint

                assert(MainPartTrailWeldConstraint:IsA("WeldConstraint"), (("Trail asset \"%*\" has an invalid weld"):format(TrailId)))
                MainPartTrailWeldConstraint.Part1 = v7
            end))
        end

        local function applyActiveTrail(p2, p3, p4) -- line: 93
            -- upvalues: t2 (copy), reconcileTrailVisual (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p2)
            t.strict(t.optional(t.string))(p3)

            local v13 = assert(t2[p2], (("Missing trail renderer state for %*"):format(p2.Name)))

            v13.TrailId = p3
            v13.ReceivedLiveUpdate = v13.ReceivedLiveUpdate or p4
            reconcileTrailVisual(p2)
        end

        local function bindPlayer(p5) -- line: 103
            -- upvalues: t2 (copy), reconcileTrailVisual (copy), Player (copy), Trove (copy)
            if t2[p5] ~= nil then
                return
            end

            local v14 = Trove.new()
            local v15 = v14:Extend()

            t2[p5] = {
                TrailId = nil,
                RenderRevision = 0,
                ReceivedLiveUpdate = false,
                Character = Player.FindCharacter(p5),
                PlayerTrove = v14,
                CharacterTrove = v15
            }

            local v16 = t2[p5]

            v14:Connect(p5.CharacterAdded, function(p6) -- line: 120
                -- upvalues: p5 (copy), v16 (copy), reconcileTrailVisual (copy)
                v16.Character = p6
                reconcileTrailVisual(p5)
            end)
            v14:Connect(p5.CharacterRemoving, function(p7) -- line: 124
                -- upvalues: p5 (copy), v16 (copy), reconcileTrailVisual (copy)
                if v16.Character == p7 then
                    v16.Character = nil
                    reconcileTrailVisual(p5)
                end
            end)

            if v16.Character ~= nil then
                reconcileTrailVisual(p5)
            end
        end

        local function handleActiveTrailChanged(p8, p9) -- line: 136
            -- upvalues: applyActiveTrail (copy), bindPlayer (copy)
            bindPlayer(p8)
            applyActiveTrail(p8, p9, true)
        end

        local function unbindPlayer(p10) -- line: 141
            -- upvalues: t2 (copy)
            local v19 = assert(t2[p10], (("Missing trail renderer state for %*"):format(p10.Name)))

            t2[p10] = nil
            v19.PlayerTrove:Destroy()
        end

        local function hydrateActiveTrailSnapshot() -- line: 147
            -- upvalues: t2 (copy), applyActiveTrail (copy), bindPlayer (copy), Players (copy), Remotes (copy), v1 (copy)
            local v20 = Remotes.Trailwear.AskWornSnapshot:InvokeServer()

            for v21, v22 in pairs(v20) do
                local PlayerByUserId = Players:GetPlayerByUserId(v21)

                if PlayerByUserId ~= nil then
                    bindPlayer(PlayerByUserId)

                    if not assert(t2[PlayerByUserId], (("Missing trail renderer state for %*"):format(PlayerByUserId.Name))).ReceivedLiveUpdate then
                        applyActiveTrail(PlayerByUserId, v22, false)
                    end
                else
                    v1:AtDebug():Log((("Skipped trail snapshot for departed user %*"):format(v21)))
                end
            end
        end

        Players.PlayerAdded:Connect(bindPlayer)
        Players.PlayerRemoving:Connect(unbindPlayer)

        for _, player in ipairs(Players:GetPlayers()) do
            task.spawn(bindPlayer, player)
        end

        Remotes.Trailwear.WornTrailShifted.OnClientEvent:Connect(handleActiveTrailChanged)
        task.defer(hydrateActiveTrailSnapshot)

        return t3
    end
}
