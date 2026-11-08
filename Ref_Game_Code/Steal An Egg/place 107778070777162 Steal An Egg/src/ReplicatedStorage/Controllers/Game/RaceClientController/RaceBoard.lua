-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("StarterGui")

local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local GUI = require(ReplicatedStorage.Client.GUI)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local RacePowerUps = require(ReplicatedStorage.Data.RacePowerUps)
local TheHollowFlags = require(ReplicatedStorage.Shared.Flags.TheHollowFlags)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local PlayerAttributes = MountRace.PlayerAttributes
local BoardPlace, BotAvatar = RacePowerUps.Attributes.BoardPlace, RacePowerUps.Attributes.BotAvatar
local v1 = ("player:%*"):format(LocalPlayer.UserId)
local TrackAttributes = MountRace.TrackAttributes
local t1 = {
    "First",
    "Second",
    "Third"
}
local t2 = {
    "rbxassetid://110020507589632",
    "rbxassetid://138453357586829",
    "rbxassetid://98134965629376",
    "rbxassetid://133624868976164",
    "rbxassetid://107870451775346",
    "rbxassetid://129253971737893",
    "rbxassetid://99903302571729"
}
local v2 = UDim2.fromScale(0.5, 0.5)
local v3 = UDim2.fromScale(0.5, 0.1)

local function headshot(p1) -- line: 74
    return (("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p1))
end

local function standingsFor(p2, p3) -- line: 78
    -- upvalues: Players (copy), Workspace (copy), MountRace (copy), PlayerAttributes (copy), BoardPlace (copy), BotAvatar (copy)
    local t3 = {}

    for _, player in Players:GetPlayers() do
        if MountRace.HeatOf(player) == p3 then
            local v4 = if player:GetAttribute(PlayerAttributes.RaceId) == p2 then player:GetAttribute(PlayerAttributes.Place) else player:GetAttribute(PlayerAttributes.FinishPlace)

            if type(v4) == "number" then
                local Attribute = player:GetAttribute(BoardPlace)

                table.insert(t3, {
                    Key = ("player:%*"):format(player.UserId),
                    UserId = player.UserId,
                    Place = if type(Attribute) ~= "number" then v4 else Attribute
                })
            end
        end
    end

    local RaceBots = Workspace:FindFirstChild("RaceBots")

    if RaceBots ~= nil then
        for _, child in RaceBots:GetChildren() do
            local Attribute = child:GetAttribute(BoardPlace)
            local Attribute2 = child:GetAttribute(BotAvatar)

            if child:GetAttribute(PlayerAttributes.RaceId) == p2 and MountRace.HeatOf(child) == p3 and type(Attribute) == "number" and type(Attribute2) == "number" then
                table.insert(t3, {
                    Key = ("bot:%*"):format(child.Name),
                    UserId = Attribute2,
                    Place = Attribute
                })
            end
        end
    end

    table.sort(t3, function(p4, p5) -- line: 112
        if p4.Place == p5.Place then
            return p4.Key < p5.Key
        end

        return p4.Place < p5.Place
    end)

    return t3
end

local function pop(p6, p7, p8, p9) -- line: 121
    -- upvalues: TweenService (copy)
    p6.Scale = p7
    TweenService:Create(p6, TweenInfo.new(p8, p9), {
        Scale = 1
    }):Play()
end

local function showCard(p10, p11) -- line: 126
    -- upvalues: TweenService (copy)
    if p10.Position == p11 then
        return
    end

    p10.Position = p11

    if not p10.Frame.Visible then
        p10.Frame.Position = p11 + UDim2.fromScale(0, -0.32)
        p10.Frame.Visible = true
        TweenService:Create(p10.Scale, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Scale = 1
        }):Play()
    end

    TweenService:Create(p10.Frame, TweenInfo.new(0.42, Enum.EasingStyle.Quint), {
        Position = p11
    }):Play()
end

local function hideCard(p12) -- line: 140
    p12.Key = nil
    p12.Position = nil
    p12.Frame.Visible = false
    p12.Scale.Scale = 0.72
end

local function setCard(p13, p14) -- line: 147
    -- upvalues: TweenService (copy), MountRace (copy), v1 (copy)
    if p13.Key ~= p14.Key then
        p13.Key = p14.Key
        p13.Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p14.UserId)
        p13.Avatar.ImageTransparency = 0.5
        TweenService:Create(p13.Avatar, TweenInfo.new(0.2), {
            ImageTransparency = 0
        }):Play()
    end

    p13.Place.Text = string.upper(MountRace.FormatPlace(p14.Place))
    p13.YouStroke.Enabled = p14.Key == v1
end

local function showPlacement(p15, p16, p17, p18) -- line: 159
    -- upvalues: TweenService (copy), t2 (copy), pop (copy)
    local v5 = t2[p17]

    p15.Visible = v5 ~= nil

    if v5 == nil then
        return
    end

    p15.Image = v5
    p15.Rotation = not (p18 ~= nil and p18 < p17) and -14 or 14
    pop(p16, 1.5, 0.5, Enum.EasingStyle.Back)
    TweenService:Create(p15, TweenInfo.new(0.7, Enum.EasingStyle.Elastic), {
        Rotation = 0
    }):Play()
end

return {
    Run = function(p19, p20, p21, p22) -- Run | line: 175
        -- upvalues: TweenService (copy), GUI (copy), MountRace (copy), TheHollowFlags (copy), LocalPlayer (copy), PlayerAttributes (copy), v1 (copy), TrackAttributes (copy), t1 (copy), v2 (copy), v3 (copy), standingsFor (copy), pop (copy), showCard (copy), setCard (copy), showPlacement (copy)
        local v6 = MountRace.HeatOf(LocalPlayer)
        local Main = GUI.MountRaceBoardUI().Main
        local Leaderboard, Lap, PlacementImage = Main.Leaderboard, Main.Lap, Main.PlacementImage
        local Attribute = p20:GetAttribute(MountRace.RaceNameAttribute)

        assert(type(Attribute) == "string", (("%* has no %* attribute"):format(p20:GetFullName(), MountRace.RaceNameAttribute)))
        Main.Title.Text = Attribute

        local Fallback = Leaderboard.First.Crown.Fallback
        local Image = Fallback.Image
        local CrownImage = p20:GetAttribute("CrownImage")

        if type(CrownImage) == "string" and CrownImage ~= "" then
            local v9 = TheHollowFlags.CrownImage:Get()

            if v9 ~= "" then
                Fallback.Image = v9
            end
        end

        local UIListLayout = Leaderboard:FindFirstChildOfClass("UIListLayout")

        if UIListLayout ~= nil then
            UIListLayout:Destroy()
        end

        local t7 = {}

        for _, v10 in { "First", "Second", "Third", "You" } do
            local v11 = Leaderboard:FindFirstChild(v10)
            local Avatar = v11:FindFirstChild("Avatar")
            local UIScale = Instance.new("UIScale")

            UIScale.Parent = v11
            p19:Add(UIScale)
            v11.AnchorPoint = Vector2.new(0.5, 0.5)
            t7[v10] = {
                Key = nil,
                Position = nil,
                Frame = v11,
                Avatar = Avatar,
                Place = v11:FindFirstChild("Place"),
                YouStroke = Avatar:FindFirstChild("YouStroke"),
                Scale = UIScale
            }

            local v12 = t7[v10]

            v12.Key = nil
            v12.Position = nil
            v12.Frame.Visible = false
            v12.Scale.Scale = 0.72
        end

        local UIScale = Instance.new("UIScale")

        UIScale.Parent = PlacementImage
        p19:Add(UIScale)
        PlacementImage.Visible = false
        Main.Position = v3
        Main.Visible = false

        local v13 = false
        local Key, Place

        p19:Add(function() -- line: 232
            -- upvalues: Main (copy), Lap (copy), PlacementImage (copy), Fallback (copy), Image (copy), t7 (copy)
            Main.Visible = false
            PlacementImage.Visible = false
            Lap.Text = ""
            Fallback.Image = Image

            for _, v14 in t7 do
                v14.Key = nil
                v14.Position = nil
                v14.Frame.Visible = false
                v14.Scale.Scale = 0.72
            end
        end)

        local function setShown(p23) -- line: 242
            -- upvalues: Main (copy), v13 (ref), TweenService (copy), v2 (copy), v3 (copy)
            if p23 == v13 then
                return
            end

            v13 = p23

            if p23 then
                Main.Visible = true
                TweenService:Create(Main, TweenInfo.new(0.42, Enum.EasingStyle.Back), {
                    Position = v2
                }):Play()
            else
                local tween = TweenService:Create(Main, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = v3
                })

                tween:Play()
                tween.Completed:Once(function() -- line: 257
                    -- upvalues: Main (copy), v13 (ref)
                    if not v13 then
                        Main.Visible = false
                    end
                end)
            end
        end

        local function refresh() -- line: 265
            -- upvalues: p21 (copy), p22 (copy), v6 (copy), Lap (copy), PlacementImage (copy), t7 (copy), UIScale (copy), Key (ref), Place (ref), setShown (copy), MountRace (copy), LocalPlayer (copy), PlayerAttributes (copy), v1 (copy), TrackAttributes (copy), t1 (copy), standingsFor (copy), pop (copy), showCard (copy), setCard (copy), showPlacement (copy)
            local Attribute = p21:GetAttribute(TrackAttributes.Phase)

            setShown(Attribute == MountRace.Phase.Racing or Attribute == MountRace.Phase.Results)

            local Attribute2 = LocalPlayer:GetAttribute(PlayerAttributes.Lap)
            local Attribute3 = p21:GetAttribute(TrackAttributes.Laps)
            local v16 = if type(LocalPlayer:GetAttribute(PlayerAttributes.FinishTime)) == "number" then "FINISHED!" elseif type(Attribute3) == "number" then ("LAP %*/%*"):format(if type(Attribute2) == "number" then Attribute2 else 1, Attribute3) else ""

            if v16 ~= Lap.Text then
                Lap.Text = v16
                pop(Lap.PopScale, 1.35, 0.45, Enum.EasingStyle.Back)
            end

            local v17 = standingsFor(p22, v6)
            local t8 = {}
            local v21 = false

            for i = 1, math.min(#v17, #t1) do
                local v22 = v17[i]

                v21 = v21 or v22.Key == v1
                table.insert(t8, {
                    Card = t7[t1[i]],
                    Standing = v22
                })
            end

            for _, v23 in v17 do
                if v23.Key == v1 then
                    if not v21 then
                        table.insert(t8, {
                            Card = t7.You,
                            Standing = v23
                        })
                    end

                    if v23.Place ~= Place then
                        showPlacement(PlacementImage, UIScale, v23.Place, Place)
                        Place = v23.Place
                    end
                end
            end

            local v25 = math.max(#t8 - 1, 0) * 0.05

            for _, v26 in t8 do
                v25 += v26.Card.Frame.Size.X.Scale
            end

            local t11 = {}
            local v27 = 0.5 - v25 / 2

            for _, v28 in t8 do
                local Scale = v28.Card.Frame.Size.X.Scale

                t11[v28.Card] = true
                setCard(v28.Card, v28.Standing)
                showCard(v28.Card, UDim2.fromScale(v27 + Scale / 2, 0.5))
                v27 += Scale + 0.05
            end

            for _, v29 in t7 do
                if not t11[v29] and v29.Frame.Visible then
                    v29.Key = nil
                    v29.Position = nil
                    v29.Frame.Visible = false
                    v29.Scale.Scale = 0.72
                end
            end

            local Key2 = if #v17 > 0 then v17[1].Key else nil

            if Key ~= nil and Key2 ~= nil and Key2 ~= Key then
                pop(t7.First.Scale, 1.16, 0.62, Enum.EasingStyle.Elastic)
            end

            Key = Key2
        end

        p19:Add(task.spawn(function() -- line: 326
            -- upvalues: refresh (copy)
            while true do
                refresh()
                task.wait(0.25)
            end
        end))
    end
}
