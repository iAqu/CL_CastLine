-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Leaderboards = require(ReplicatedStorage.Shared.Types.Leaderboards)
local Log = require(ReplicatedStorage.Packages.Log)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Log.new()
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 40
        -- upvalues: CollectionService (copy), ReplicatedStorage (copy), RunService (copy), Leaderboards (copy), Player (copy), Remotes (copy), Trove (copy), v1 (copy), LocalPlayer (copy)
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local Leaderboards2 = ReplicatedStorage.Assets.UI.Leaderboards
        local t2 = {}
        local t3 = {}
        local n1 = 0

        local function getLeaderboardPart(p1) -- line: 48
            local Adornee = p1.Adornee

            if Adornee and Adornee:IsA("BasePart") then
                return Adornee
            end

            local Parent = p1.Parent

            return if Parent and Parent:IsA("BasePart") then Parent else nil
        end

        local function getRowTemplate(p2) -- line: 62
            -- upvalues: Leaderboards2 (copy)
            local v2 = Leaderboards2:FindFirstChild(p2)

            return if v2 ~= nil and v2:IsA("Frame") then v2 else nil
        end

        local function getHeadshotUrl(p3) -- line: 71
            return (("rbxthumb://type=AvatarHeadShot&id=%*&w=48&h=48"):format(p3))
        end

        local function createRow(p4, p5) -- line: 75
            local clone = p4.Template:Clone()

            clone.Name = ("Player_%*"):format(p5.UserId)
            clone.Holder_Thumbnail.ImageLabel_PlayerThumb.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=48&h=48"):format(p5.UserId)
            clone.Parent = p4.Container
            p4.Rows[p5.UserId] = clone

            return clone
        end

        local function renderLeaderboard(p6, p7) -- line: 85
            local t4 = {}

            for v3, v4 in p7 do
                local v5 = p6.Rows[v4.UserId]

                if not v5 then
                    v5 = p6.Template:Clone()
                    v5.Name = ("Player_%*"):format(v4.UserId)
                    v5.Holder_Thumbnail.ImageLabel_PlayerThumb.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=48&h=48"):format(v4.UserId)
                    v5.Parent = p6.Container
                    p6.Rows[v4.UserId] = v5
                end

                v5.LayoutOrder = v3
                v5.Holder_PlayerName.Display.TextLabel_PlayerName.Text = v4.Name
                v5.Holder_Value.Holder.TextLabel_Value.Text = v4.ValueText
                t4[v4.UserId] = true
            end

            for v6, v7 in p6.Rows do
                if not t4[v6] then
                    p6.Rows[v6] = nil
                    v7:Destroy()
                end
            end
        end

        local function updateLeaderboard(p8, p9) -- line: 109
            -- upvalues: t2 (copy)
            local v8 = t2[p8]

            if not v8 then
                return
            end

            local MaxDistance = v8.Gui.MaxDistance
            local v9 = not not (p9 and (not (MaxDistance > 0) or (p9.Position - v8.Part.Position).Magnitude <= MaxDistance))

            if v8.Gui.Enabled ~= v9 then
                v8.Gui.Enabled = v9
            end
        end

        local function cleanupLeaderboard(p10) -- line: 130
            -- upvalues: t2 (copy)
            local v10 = t2[p10]

            if not v10 then
                return
            end

            v10.Trove:Clean()

            for v11, v12 in v10.Rows do
                v10.Rows[v11] = nil
                v12:Destroy()
            end

            if v10.Gui.Parent then
                v10.Gui.Enabled = true
            end

            t2[p10] = nil
        end

        local function trackLeaderboard(p11) -- line: 148
            -- upvalues: PlayerGui (copy), Leaderboards2 (copy), t2 (copy), t3 (copy), renderLeaderboard (copy), cleanupLeaderboard (copy), Player (copy), Trove (copy), v1 (copy), LocalPlayer (copy)
            if not p11:IsA("ScrollingFrame") then
                return
            end

            cleanupLeaderboard(p11)

            local Key = p11:GetAttribute("Key")

            if type(Key) ~= "string" then
                v1:AtWarning():Log((("leaderboard %* has no Key attribute"):format((p11:GetFullName()))))

                return
            end

            local v13 = Leaderboards2:FindFirstChild(Key)

            if v13 == nil or not v13:IsA("Frame") then
                v13 = nil
            end

            if not v13 then
                v1:AtWarning():Log((("leaderboard key \"%*\" has no row template"):format(Key)))

                return
            end

            local Parent = p11.Parent

            if Parent and Parent:IsA("Frame") then
                local ParentParent = Parent.Parent

                if ParentParent and ParentParent:IsA("SurfaceGui") then
                    local Adornee = ParentParent.Adornee

                    if not Adornee or not Adornee:IsA("BasePart") then
                        Adornee = ParentParent.Parent

                        if not Adornee or not Adornee:IsA("BasePart") then
                            Adornee = nil
                        end
                    end

                    if Adornee then
                        ParentParent.Adornee = Adornee
                        ParentParent.Parent = PlayerGui

                        local v14 = Trove.new()
                        local t5 = {
                            Key = Key,
                            Part = Adornee,
                            Gui = ParentParent,
                            Container = p11,
                            Template = v13,
                            Rows = {},
                            Trove = v14
                        }

                        t2[p11] = t5
                        v14:Add(p11.Destroying:Connect(function() -- line: 197
                            -- upvalues: p11 (copy), cleanupLeaderboard (copy)
                            cleanupLeaderboard(p11)
                        end))
                        v14:Add(ParentParent.Destroying:Connect(function() -- line: 199
                            -- upvalues: p11 (copy), cleanupLeaderboard (copy)
                            cleanupLeaderboard(p11)
                        end))

                        local v15 = t3[Key]

                        if v15 then
                            renderLeaderboard(t5, v15)
                        end

                        local v16 = Player.FindRootPart(LocalPlayer)
                        local v17 = t2[p11]

                        if v17 then
                            local MaxDistance = v17.Gui.MaxDistance
                            local v18 = not not (v16 and (not (MaxDistance > 0) or (v16.Position - v17.Part.Position).Magnitude <= MaxDistance))

                            if v17.Gui.Enabled ~= v18 then
                                v17.Gui.Enabled = v18
                            end
                        end
                    end
                end
            end
        end

        local function updateLeaderboards() -- line: 209
            -- upvalues: t2 (copy), Player (copy), LocalPlayer (copy)
            local v19 = Player.FindRootPart(LocalPlayer)

            for v20 in t2 do
                local v21 = t2[v20]

                if v21 then
                    local MaxDistance = v21.Gui.MaxDistance
                    local v22 = not not (v19 and (not (MaxDistance > 0) or (v19.Position - v21.Part.Position).Magnitude <= MaxDistance))

                    if v21.Gui.Enabled ~= v22 then
                        v21.Gui.Enabled = v22
                    end
                end
            end
        end

        local function stepLeaderboards(p12) -- line: 216
            -- upvalues: t2 (copy), n1 (ref), Player (copy), LocalPlayer (copy)
            n1 += p12

            if n1 < 0.2 then
                return
            end

            n1 = 0

            local v23 = Player.FindRootPart(LocalPlayer)

            for v24 in t2 do
                local v25 = t2[v24]

                if v25 then
                    local MaxDistance = v25.Gui.MaxDistance
                    local v26 = not not (v23 and (not (MaxDistance > 0) or (v23.Position - v25.Part.Position).Magnitude <= MaxDistance))

                    if v25.Gui.Enabled ~= v26 then
                        v25.Gui.Enabled = v26
                    end
                end
            end
        end

        local function setLeaderboardEntries(p13, p14) -- line: 226
            -- upvalues: t2 (copy), t3 (copy), renderLeaderboard (copy)
            t3[p13] = p14

            for v27 in t2 do
                local v28 = t2[v27]

                if v28.Key == p13 then
                    renderLeaderboard(v28, p14)
                end
            end
        end

        local function requestLeaderboards() -- line: 236
            -- upvalues: t3 (copy), setLeaderboardEntries (copy), requestLeaderboards (copy), Leaderboards (copy), Remotes (copy), v1 (copy)
            local function v29() -- line: 237
                -- upvalues: Remotes (copy)
                return Remotes.Leaderboards.Fetch:InvokeServer()
            end

            local ok, result = pcall(v29)
            local v30 = if ok then Leaderboards.SchemaValidation.LeaderboardsByKey(result) else false
            local v31 = tostring(result)

            if not v30 then
                v1:AtError():Log((("leaderboard request failed, retrying: %*"):format(v31)))
                task.delay(5, requestLeaderboards)

                return
            end

            for v32, v33 in result do
                if t3[v32] == nil then
                    setLeaderboardEntries(v32, v33)
                end
            end
        end

        local function onLeaderboardUpdate(p15, p16) -- line: 255
            -- upvalues: setLeaderboardEntries (copy), Leaderboards (copy), v1 (copy)
            if type(p15) == "string" then
                local v34, v35 = Leaderboards.SchemaValidation.Leaderboard(p16)

                if v34 then
                    setLeaderboardEntries(p15, p16)
                else
                    v1:AtError():Log((("leaderboard update for \"%*\" failed validation: %*"):format(p15, v35)))
                end
            else
                v1:AtError():Log((("leaderboard update had a non-string key: %*"):format((tostring(p15)))))
            end
        end

        for _, v36 in CollectionService:GetTagged("Leaderboard") do
            trackLeaderboard(v36)
        end

        CollectionService:GetInstanceAddedSignal("Leaderboard"):Connect(trackLeaderboard)
        CollectionService:GetInstanceRemovedSignal("Leaderboard"):Connect(cleanupLeaderboard)
        RunService.Heartbeat:Connect(stepLeaderboards)
        Remotes.Leaderboards.Updated.OnClientEvent:Connect(onLeaderboardUpdate)
        task.spawn(requestLeaderboards)
    end
}
