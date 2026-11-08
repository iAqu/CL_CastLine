-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local BadgeReveal = require(script.BadgeReveal)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local TheHollowFlags = require(ReplicatedStorage.Shared.Flags.TheHollowFlags)
local GUI = require(ReplicatedStorage.Client.GUI)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Hud = require(ReplicatedStorage.Client.Hud)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local RaceRallyRewards = require(ReplicatedStorage.Shared.Modules.RaceRallyRewards)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local TheHollow = require(ReplicatedStorage.Data.TheHollow)
local TheHollow2 = require(ReplicatedStorage.Shared.Types.TheHollow)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(255, 80, 80)
local v2 = Color3.fromRGB(255, 196, 0)
local Inside = HalloweenDimension.PlayerAttributes.Inside

local function clock(p1) -- line: 42
    local v4 = math.max(math.ceil(p1), 0)

    return string.format("%d:%02d", v4 // 60, v4 % 60)
end

local function winsLabel(p2) -- line: 47
    if p2 == 1 then
        return "1 Win"
    end

    return (("%* Wins"):format(p2))
end

local function savedState() -- line: 51
    -- upvalues: Save (copy), TheHollow2 (copy)
    local v5 = Save.Peek()
    local TheHollow = if v5 == nil then nil else v5.TheHollow

    if TheHollow == nil then
        return (TheHollow2.Blank())
    end

    return TheHollow
end

local function quantityText(p3) -- line: 58
    if p3.Multiplier == nil then
        return p3.Amount
    end

    return (("%* %*"):format(p3.Multiplier, p3.Amount))
end

return {
    Start = function() -- Start | line: 66
        -- upvalues: RunService (copy), Workspace (copy), BadgeReveal (copy), ButtonFX (copy), TheHollowFlags (copy), GUI (copy), Hud (copy), MountRace (copy), Toast (copy), RaceRallyRewards (copy), Remotes (copy), Save (copy), Tabs (copy), TheHollow (copy), TheHollow2 (copy), Trove (copy), LocalPlayer (copy), v1 (copy), v2 (copy), Inside (copy)
        local Main = GUI.TheHollow().Main
        local Content = Main.Content
        local ProgressBar = Content.ProgressBar
        local Bar = ProgressBar.Bar
        local CompletedCheckmark = Content.Badge.CompletedCheckmark
        local TeleportToRace = Main.TeleportToRace
        local v6 = TheHollow.OrderedPrizes()
        local t2 = {}

        for v7, v8 in v6 do
            local v9 = ProgressBar[("Prize%*"):format(v7)]

            t2[v7] = {
                Id = v8.Id,
                Prize = v8.Config,
                Label = v9.RequirementLabel,
                Check = v9.CompletedCheckmark,
                Icon = v9.Icon,
                Quantity = v9.QuantityLabel
            }
        end

        assert(ProgressBar:FindFirstChild((`Prize{ #v6 + 1 }`)) == nil, "The Hollow UI has more prize cards than prizes")

        local t3 = {
            ProgressBar.MilestoneLine.Position.X.Scale,
            ProgressBar.MilestoneLine2.Position.X.Scale,
            ProgressBar.MilestoneLine3.Position.X.Scale,
            ProgressBar.MilestoneLine4.Position.X.Scale
        }
        local Id = v6[#v6].Id
        local TheHollowButton = Hud.Every("TheHollowButton")
        local v11 = Trove.new()
        local v12 = false
        local v13 = true

        local function refresh() -- line: 101
            -- upvalues: Bar (copy), CompletedCheckmark (copy), t2 (copy), t3 (copy), Id (copy), v13 (ref), TheHollowFlags (copy), RaceRallyRewards (copy), Save (copy), TheHollow2 (copy)
            local v14 = Save.Peek()
            local v15 = if v14 == nil then nil else v14.TheHollow

            if v15 == nil then
                v15 = TheHollow2.Blank()
            end

            local n1 = 0

            for v16, v17 in t2 do
                local v18 = RaceRallyRewards.Present(v17.Prize.Rewards[1])
                local Label = v17.Label
                local Wins = v17.Prize.Wins

                if Wins == 1 then
                    Label.Text = "1 Win"
                else
                    Label.Text = ("%* Wins"):format(Wins)
                end

                v17.Icon.Image = v18.Icon

                local Quantity = v17.Quantity

                if v18.Multiplier ~= nil then
                    Quantity.Text = ("%* %*"):format(v18.Multiplier, v18.Amount)
                else
                    Quantity.Text = v18.Amount
                end

                v17.Check.Visible = v15.Claimed[v17.Id] == true

                if v15.Wins >= v17.Prize.Wins then
                    n1 = v16
                end
            end

            local v19 = v15.Wins >= TheHollowFlags.WinsForBadge:Get()

            CompletedCheckmark.Visible = v19
            v13 = Save.Peek() == nil or v19 or v15.Claimed[Id] == true

            local v20 = if v19 then t3[#t3] elseif n1 > 0 then t3[n1] else 0

            Bar.Size = UDim2.new(v20, 0, Bar.Size.Y.Scale, Bar.Size.Y.Offset)
        end

        local function enter() -- line: 121
            -- upvalues: v12 (ref), Toast (copy), Remotes (copy), Tabs (copy), v1 (copy)
            if v12 then
                return
            end

            v12 = true

            local function v21() -- line: 126
                -- upvalues: Remotes (copy)
                return Remotes.TheHollow.AskEnter:InvokeServer()
            end

            local v22, v23, v24 = pcall(v21)

            v12 = false

            if not v22 or not v23 then
                if v22 then
                    if v24 ~= nil then
                        Toast.Show({
                            Seconds = 2.5,
                            SingleLine = true,
                            Text = v24,
                            Color = v1
                        })
                    end
                else
                    Toast.Show({
                        Text = "Something went wrong, please try again.",
                        Seconds = 2.5,
                        SingleLine = true,
                        Color = v1
                    })
                end
            else
                Tabs.Deactivate()
            end
        end

        v11:Add(ButtonFX(TeleportToRace, 1.06, enter))

        local function syncHud() -- line: 141
            -- upvalues: TheHollowButton (copy), v13 (ref), Workspace (copy), TheHollowFlags (copy), MountRace (copy), Tabs (copy), LocalPlayer (copy), Inside (copy)
            local v25 = TheHollowFlags.ContentEnabled:Get()
            local TheHollowJoinEndsAt = Workspace:GetAttribute("TheHollowJoinEndsAt")
            local v26 = if type(TheHollowJoinEndsAt) == "number" then TheHollowJoinEndsAt - Workspace:GetServerTimeNow() else 0
            local v27, v28

            if v25 then
                v28 = v26 > 0 and LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) == nil
                v27 = not (v13 and TheHollowFlags.HideBadgeAfterGrandPrize:Get()) and LocalPlayer:GetAttribute(Inside) ~= true
            else
                v27 = v25
                v28 = v25
            end

            if v25 and not v27 and Tabs.IsActive("TheHollow") then
                Tabs.Deactivate()
            end

            for _, v29 in TheHollowButton do
                v29.Visible = v27

                local Badge = v29:FindFirstChild("Badge")

                if Badge ~= nil then
                    Badge.Visible = v28 and not (v13 and TheHollowFlags.HideBadgeAfterGrandPrize:Get())
                end

                local RemovalTimer = v29:FindFirstChild("RemovalTimer")

                if RemovalTimer ~= nil then
                    RemovalTimer.Visible = v28

                    if v28 then
                        local v31 = math.max(math.ceil(v26), 0)

                        RemovalTimer.Text = string.format("%d:%02d", v31 // 60, v31 % 60)
                    end
                end
            end
        end

        for _, v32 in TheHollowButton do
            v11:Add(ButtonFX(v32, 1.08, function() -- line: 169
                -- upvalues: Tabs (copy)
                Tabs.Toggle("TheHollow")
            end))
        end

        v11:Add(TheHollowFlags.ContentEnabled.Changed:Connect(function() -- line: 173
            -- upvalues: syncHud (copy), TheHollowFlags (copy), Tabs (copy)
            syncHud()

            if not TheHollowFlags.ContentEnabled:Get() and Tabs.IsActive("TheHollow") then
                Tabs.Deactivate({
                    instant = true
                })
            end
        end))

        local n2 = 0.2

        v11:Connect(RunService.Heartbeat, function(p4) -- line: 180
            -- upvalues: syncHud (copy), n2 (ref)
            n2 += p4

            if n2 >= 0.2 then
                n2 = 0
                syncHud()
            end
        end)

        local v33

        local function toast(p5) -- line: 190
            -- upvalues: Toast (copy), v2 (copy)
            Toast.Show({
                Seconds = 3,
                SingleLine = true,
                Text = p5,
                Color = v2
            })
        end

        local function badgePrize(p6) -- line: 194
            -- upvalues: t2 (copy), RaceRallyRewards (copy)
            for _, v34 in t2 do
                if v34.Prize.Wins == p6 then
                    local v35 = RaceRallyRewards.Present(v34.Prize.Rewards[1])

                    return {
                        Text = ("Grand prize: %* (%*)"):format(v35.Title, v35.Amount),
                        Icon = v35.Icon
                    }
                end
            end

            return {
                Text = "You earned The Hollow badge!"
            }
        end

        v11:Add(Save.WatchFields("TheHollow", function() -- line: 207
            -- upvalues: t2 (copy), refresh (copy), v33 (ref), badgePrize (copy), BadgeReveal (copy), TheHollowFlags (copy), Toast (copy), RaceRallyRewards (copy), Save (copy), TheHollow2 (copy), v2 (copy)
            local v36 = Save.Peek()
            local v37 = if v36 == nil then nil else v36.TheHollow

            if v37 == nil then
                v37 = TheHollow2.Blank()
            end

            local v38 = v33

            if v38 ~= nil then
                local v39 = TheHollowFlags.WinsForBadge:Get()
                local v40 = TheHollowFlags.BadgeReveal:Get()

                if v37.Wins > v38.Wins then
                    if v37.Wins == v39 and v40 then
                        BadgeReveal.Show((badgePrize(v39)))
                    else
                        local v41 = if v37.Wins == v39 then "Grand prize unlocked! You earned The Hollow badge!" else ("Hollow race won! %*/%* wins"):format(math.min(v37.Wins, v39), v39)

                        Toast.Show({
                            Seconds = 3,
                            SingleLine = true,
                            Text = v41,
                            Color = v2
                        })
                    end
                end

                for _, v42 in t2 do
                    local v43 = v40 and v42.Prize.Wins == v39 and v39 <= v37.Wins

                    if v37.Claimed[v42.Id] and not v38.Claimed[v42.Id] and not v43 then
                        local v44 = RaceRallyRewards.Present(v42.Prize.Rewards[1])
                        local v45 = ("Prize unlocked: %* (%*)!"):format(v44.Title, v44.Amount)

                        Toast.Show({
                            Seconds = 3,
                            SingleLine = true,
                            Text = v45,
                            Color = v2
                        })
                    end
                end
            end

            v33 = v37
            refresh()
        end))
        v11:Add(Tabs.Activated:Connect(function(p7) -- line: 237
            -- upvalues: refresh (copy)
            if p7 == "TheHollow" then
                refresh()
            end
        end))
        v11:Add(task.spawn(function() -- line: 243
            -- upvalues: refresh (copy), v33 (ref), Save (copy), TheHollow2 (copy)
            Save.Await()

            if v33 == nil then
                local v46 = Save.Peek()
                local v47 = if v46 == nil then nil else v46.TheHollow

                if v47 == nil then
                    v47 = TheHollow2.Blank()
                end

                v33 = v47
            end

            refresh()
        end))
        syncHud()
        refresh()

        return v11
    end
}
