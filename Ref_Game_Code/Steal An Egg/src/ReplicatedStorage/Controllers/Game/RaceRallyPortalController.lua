-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local RaceRallyFlags = require(ReplicatedStorage.Shared.Flags.RaceRallyFlags)
local Hud = require(ReplicatedStorage.Client.Hud)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local RaceRally = require(ReplicatedStorage.Data.RaceRally)
local RaceRallyEligibility = require(ReplicatedStorage.Shared.Util.RaceRallyEligibility)
local RaceRallySchedule = require(ReplicatedStorage.Shared.Util.RaceRallySchedule)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(255, 196, 0)
local Attributes, PlayerAttributes = RaceRally.Attributes, RaceRally.PlayerAttributes

local function clock(p1) -- line: 50
    local v3 = math.max(math.ceil(p1), 0)

    return string.format("%d:%02d", v3 // 60, v3 % 60)
end

local function racedThisWindow(p2) -- line: 55
    -- upvalues: Workspace (copy), RaceRallyFlags (copy), Attributes (copy)
    if not RaceRallyFlags.OneRacePerWindow:Get() then
        return false
    end

    local Attribute = Workspace:GetAttribute(Attributes.Window)

    if type(Attribute) ~= "number" then
        return false
    end

    local RaceRally = if p2 == nil then nil else p2.RaceRally

    return (if RaceRally == nil then nil else RaceRally.LastRacedWindow) == Attribute
end

return {
    Start = function() -- Start | line: 70
        -- upvalues: RunService (copy), Workspace (copy), RaceRallyFlags (copy), Hud (copy), MountRace (copy), Toast (copy), RaceRallyEligibility (copy), RaceRallySchedule (copy), Save (copy), Tabs (copy), Trove (copy), LocalPlayer (copy), v1 (copy), Attributes (copy), PlayerAttributes (copy)
        local World = Workspace.World
        local RaceTimer = Hud.Every("RaceTimer")
        local RaceTimerValue = Hud.Every("RaceTimerValue")
        local v4 = Trove.new()
        local t2
        local v5 = ""
        local v6, v7, update

        local function unbind() -- line: 81
            -- upvalues: t2 (ref)
            local t3 = t2

            if t3 ~= nil then
                t2 = nil
                t3.Lifetime:Destroy()
            end
        end

        local function bind(p3) -- line: 90
            -- upvalues: t2 (ref), v5 (ref), v6 (ref), v7 (ref), update (ref), Tabs (copy), Trove (copy)
            local t4 = t2

            if t4 ~= nil then
                t2 = nil
                t4.Lifetime:Destroy()
            end

            local Hitbox = p3.Hitbox
            local Sign = Hitbox.SignAnchor.Sign
            local Title = Sign.Title
            local Prompt = Hitbox.PromptAnchor.Prompt
            local ParticleEmitter = p3.Gate:QueryDescendants("ParticleEmitter")
            local t5 = {}
            local t6 = {}

            for _, descendant in p3:GetDescendants() do
                if descendant:IsA("BasePart") then
                    t5[descendant] = {
                        CanCollide = descendant.CanCollide,
                        CanQuery = descendant.CanQuery,
                        CanTouch = descendant.CanTouch
                    }
                elseif (descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Light")) and table.find(ParticleEmitter, descendant) == nil then
                    t6[descendant] = descendant.Enabled
                end
            end

            local t7 = {
                Model = p3,
                Hitbox = Hitbox,
                GateEffects = ParticleEmitter,
                Parts = t5,
                Effects = t6,
                Sign = Sign,
                Title = Title,
                TitleText = Title.Text,
                Prompt = Prompt,
                Status = Sign.Status,
                Lifetime = Trove.new()
            }

            t7.Lifetime:Connect(Prompt.Triggered, function() -- line: 129
                -- upvalues: Tabs (copy)
                Tabs.Activate("RaceRally")
            end)
            v5 = ""
            v6 = nil
            v7 = nil
            t2 = t7
            update()
        end

        function update() -- line: 140
            -- upvalues: RaceTimer (copy), RaceTimerValue (copy), t2 (ref), v5 (ref), v6 (ref), v7 (ref), Workspace (copy), RaceRallyFlags (copy), MountRace (copy), RaceRallyEligibility (copy), RaceRallySchedule (copy), Save (copy), LocalPlayer (copy), Attributes (copy), PlayerAttributes (copy)
            local ServerTimeNow = Workspace:GetServerTimeNow()
            local v8 = RaceRallyFlags.ContentEnabled:Get()
            local Attribute = Workspace:GetAttribute(Attributes.JoinEndsAt)
            local Attribute2 = Workspace:GetAttribute(Attributes.HeatJoinEndsAt)
            local v9 = Workspace:GetAttribute(Attributes.Running) == true
            local v10 = type(Attribute) == "number" and ServerTimeNow < Attribute
            local v11 = type(Attribute2) == "number" and ServerTimeNow < Attribute2
            local v12 = LocalPlayer:GetAttribute(PlayerAttributes.Queued) == true
            local v13 = LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil
            local v14 = RaceRallySchedule.NextOpening(ServerTimeNow)
            local v15 = Save.Peek()
            local v16 = v15 ~= nil and RaceRallyEligibility.IsEligible(v15.SpeedPower)
            local v17

            if v10 then
                if RaceRallyFlags.OneRacePerWindow:Get() then
                    local Attribute = Workspace:GetAttribute(Attributes.Window)

                    if type(Attribute) == "number" then
                        local RaceRally = if v15 == nil then nil else v15.RaceRally

                        v17 = (if RaceRally == nil then nil else RaceRally.LastRacedWindow) == Attribute
                    else
                        v17 = false
                    end
                else
                    v17 = false
                end
            else
                v17 = v10
            end

            local v18 = v8 and v16 and not v17
            local t8 = t2

            if t8 ~= nil then
                if v18 ~= v7 then
                    v7 = v18

                    for v19, v20 in t8.Parts do
                        v19.LocalTransparencyModifier = v18 and 0 or 1
                        v19.CanCollide = v18 and v20.CanCollide
                        v19.CanQuery = v18 and v20.CanQuery
                        v19.CanTouch = v18 and v20.CanTouch
                    end

                    for v21, v22 in t8.Effects do
                        v21.Enabled = v18 and v22
                    end

                    t8.Sign.Enabled = v18
                    t8.Prompt.Enabled = v18
                end

                local v23 = if v11 then "A RACE IS STARTING" else t8.TitleText

                if t8.Title.Text ~= v23 then
                    t8.Title.Text = v23
                end

                local v24

                if v12 then
                    v24 = "IN LINE"
                elseif v11 then
                    local v27 = math.max(math.ceil(Attribute2 - ServerTimeNow), 0)

                    v24 = string.format("%d:%02d", v27 // 60, v27 % 60)
                else
                    v24 = if v10 then "OPEN" else string.format("%d:%02d", 0, 0)
                end

                if v24 ~= v5 then
                    v5 = v24
                    t8.Status.Text = v24
                end

                local v28 = v10 and v18

                if v28 ~= v6 then
                    v6 = v28

                    for _, v29 in t8.GateEffects do
                        v29.Enabled = v28
                    end
                end
            end

            local v30 = RaceRallySchedule.IsScheduled() and not v9 and v14 - ServerTimeNow <= RaceRallyFlags.TimerLeadSeconds:Get()
            local v31, v32

            if v8 then
                if v16 then
                    local v33 = not v13

                    if v33 then
                        if v10 then
                            local v34 = not v17

                            if v34 then
                                v31 = v34
                                v32 = true
                            else
                                v32 = false
                            end
                        else
                            v32 = false
                        end
                    else
                        v31 = v33
                        v32 = true
                    end
                else
                    v31 = v16
                    v32 = true
                end
            else
                v31 = v8
                v32 = true
            end

            if not v32 then
                v31 = v30
            end

            local v35

            if v12 then
                v35 = "You're in line for the next race!"
            elseif v10 then
                local v38 = math.max(math.ceil(Attribute - ServerTimeNow), 0)

                v35 = ("Race open! %*"):format((string.format("%d:%02d", v38 // 60, v38 % 60)))
            else
                local v41 = math.max(math.ceil(v14 - ServerTimeNow), 0)

                v35 = ("Race in %*"):format((string.format("%d:%02d", v41 // 60, v41 % 60)))
            end

            for _, v42 in RaceTimer do
                v42.Visible = v31
            end

            for _, v43 in RaceTimerValue do
                if v43.Text ~= v35 then
                    v43.Text = v35
                end
            end
        end

        v4:Connect(World.ChildAdded, function(p4) -- line: 213
            -- upvalues: bind (copy)
            if p4.Name == "RaceRallyPortal" and p4:IsA("Model") then
                bind(p4)
            end
        end)
        v4:Connect(World.ChildRemoved, function(p5) -- line: 218
            -- upvalues: t2 (ref)
            local t9 = t2

            if t9 == nil or p5 ~= t9.Model then
                return
            end

            local t10 = t2

            if t10 == nil then
                return
            end

            t2 = nil
            t10.Lifetime:Destroy()
        end)

        local RaceRallyPortal = World:FindFirstChild("RaceRallyPortal")

        if RaceRallyPortal ~= nil then
            bind(RaceRallyPortal)
        end

        local n1 = 0.2

        v4:Connect(RunService.Heartbeat, function(p6) -- line: 230
            -- upvalues: update (ref), n1 (ref)
            n1 += p6

            if n1 >= 0.2 then
                n1 = 0
                update()
            end
        end)
        v4:Connect(RaceRallyFlags.ContentEnabled.Changed, update)
        v4:Add(unbind)

        local Wins

        v4:Add(Save.WatchFields("RaceRally", function() -- line: 242
            -- upvalues: Wins (ref), Toast (copy), Save (copy), v1 (copy)
            local v44 = Save.Peek()
            local RaceRally = if v44 == nil then nil else v44.RaceRally

            if RaceRally ~= nil then
                if Wins ~= nil and RaceRally.Wins > Wins then
                    Toast.Show({
                        Seconds = 3,
                        SingleLine = true,
                        Text = ("1st place! Race wins: %*"):format(RaceRally.Wins),
                        Color = v1
                    })
                end

                Wins = RaceRally.Wins
            end
        end))
        v4:Add(task.spawn(function() -- line: 259
            -- upvalues: Wins (ref), Save (copy)
            local v45 = Save.Await()
            local RaceRally = if v45 == nil then nil else v45.RaceRally

            if RaceRally ~= nil and Wins == nil then
                Wins = RaceRally.Wins
            end
        end))
        update()

        return v4
    end
}
