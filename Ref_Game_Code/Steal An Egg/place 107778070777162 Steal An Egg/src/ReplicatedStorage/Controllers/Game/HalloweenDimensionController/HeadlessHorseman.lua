-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)
local HeadlessHorsemanBattlepass = require(ReplicatedStorage.Data.HeadlessHorsemanBattlepass)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local HalloweenDimensionFlags = require(ReplicatedStorage.Shared.Flags.HalloweenDimensionFlags)
local GUI = require(ReplicatedStorage.Client.GUI)

require(ReplicatedStorage.Shared.Types.HalloweenDimension)

local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)

require(ReplicatedStorage.Packages.Trove)

local t1 = {
    "HalloweenBossMastery",
    "HalloweenDimensionEggUI",
    "HeadlessHorsemanBattlepass"
}
local v1 = Color3.fromRGB(80, 255, 120)
local v2 = Color3.fromRGB(255, 64, 64)
local v3 = Signal.new()
local v4 = false
local v5 = false
local v6 = false
local v7 = false
local t2 = {
    TabName = "HeadlessHorsemanBattlepass",
    Changed = v3
}

local function toast(p1, p2) -- line: 51
    -- upvalues: Assets (copy), HeadlessHorsemanBattlepass (copy), Toast (copy)
    local Icon = Assets.Directory[HeadlessHorsemanBattlepass.PetId].Icon

    Toast.Show({
        Seconds = 4,
        SingleLine = true,
        Unique = true,
        Text = p1,
        Color = p2,
        Image = Icon
    })
end

local function savedState() -- line: 56
    -- upvalues: Save (copy)
    local v8 = Save.Peek()

    return if v8 ~= nil then v8.HalloweenDimension.HeadlessHorseman else nil
end

local function timeLeft(p3) -- line: 61
    local v9 = p3 // 86400
    local v10 = p3 % 86400 // 3600
    local v11 = p3 % 3600 // 60
    local v12 = p3 % 60

    if v9 > 0 then
        return (("%*d %*h %*m %*s"):format(v9, v10, v11, v12))
    end

    if v10 > 0 then
        return (("%*h %*m %*s"):format(v10, v11, v12))
    end

    return (("%*m %*s"):format(v11, v12))
end

function t2.IsOpen() -- line: 78
    -- upvalues: Workspace (copy), HeadlessHorsemanBattlepass (copy)
    return HeadlessHorsemanBattlepass.IsOpen(Workspace:GetServerTimeNow())
end

function t2.IsClaimable() -- line: 82
    -- upvalues: HeadlessHorsemanBattlepass (copy), Save (copy), t2 (copy)
    local v13 = Save.Peek()
    local HeadlessHorseman = if v13 == nil then nil else v13.HalloweenDimension.HeadlessHorseman

    return HeadlessHorseman ~= nil and t2.IsOpen() and HeadlessHorsemanBattlepass.IsClaimable(HeadlessHorseman)
end

function t2.Start(p4) -- line: 87
    -- upvalues: Workspace (copy), Assets (copy), HeadlessHorsemanBattlepass (copy), ButtonFX (copy), HalloweenDimensionFlags (copy), GUI (copy), Numbers (copy), Remotes (copy), Save (copy), Tabs (copy), Toast (copy), t1 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (ref), v5 (ref), v6 (ref), v7 (ref), t2 (copy)
    local Main = GUI.Get("HeadlessHorsemanBattlepass").Main
    local Track = Main.Track
    local GrandPrize = Track.GrandPrize
    local ClaimPill = GrandPrize.ClaimPill
    local t3 = {}

    for _, v14 in t1 do
        local v15 = GUI.Get(v14):FindFirstChild("TabButtonsHolder", true)

        assert(v15 ~= nil, (("%* has no TabButtonsHolder"):format(v14)))

        local Horseman = v15.Horseman

        table.insert(t3, Horseman)
        p4:Add(ButtonFX(Horseman.Horseman, 1.06, function() -- line: 98
            -- upvalues: Tabs (copy), t2 (copy)
            if t2.IsOpen() then
                Tabs.Activate("HeadlessHorsemanBattlepass", {
                    instant = true
                })
            end
        end))
    end

    local function refresh() -- line: 105
        -- upvalues: Main (copy), Track (copy), GrandPrize (copy), ClaimPill (copy), Workspace (copy), HeadlessHorsemanBattlepass (copy), Numbers (copy), Save (copy), v4 (ref), t2 (copy)
        local v18 = Save.Peek()
        local HeadlessHorseman = if v18 == nil then nil else v18.HalloweenDimension.HeadlessHorseman
        local v19 = HeadlessHorsemanBattlepass.Goal()
        local v20 = if HeadlessHorseman == nil then 0 else math.min(HeadlessHorseman.TokensCollected, v19)
        local ServerTimeNow = Workspace:GetServerTimeNow()

        Track.Goal.Text = ("Collect %* Candy Corn total to unlock!"):format((Numbers.AddCommas(v19)))
        Track.Progress.Label.Text = ("%* / %*"):format(Numbers.AddCommas(v20), (Numbers.AddCommas(v19)))
        Track.Progress.Fill.Size = UDim2.fromScale(v20 / v19, 1)
        ClaimPill.Visible = t2.IsClaimable() and not v4
        GrandPrize.State.Text = not (HeadlessHorseman ~= nil and HeadlessHorseman.Claimed) and "" or "Claimed!"

        local TimeLeft = Main.TimeLeft
        local v23 = math.max(math.floor(HeadlessHorsemanBattlepass.EndsAt() - ServerTimeNow), 0)
        local v24 = v23 // 86400
        local v25 = v23 % 86400 // 3600
        local v26 = v23 % 3600 // 60
        local v27 = v23 % 60

        if v24 > 0 then
            TimeLeft.Text = ("%*d %*h %*m %*s"):format(v24, v25, v26, v27)
        elseif v25 > 0 then
            TimeLeft.Text = ("%*h %*m %*s"):format(v25, v26, v27)
        else
            TimeLeft.Text = ("%*m %*s"):format(v26, v27)
        end
    end

    local function sync() -- line: 118
        -- upvalues: t3 (copy), refresh (copy), Assets (copy), HeadlessHorsemanBattlepass (copy), Tabs (copy), Toast (copy), v1 (copy), v3 (copy), v5 (ref), v6 (ref), v7 (ref), t2 (copy)
        local v28 = t2.IsOpen()
        local v29 = t2.IsClaimable()

        if not v28 and Tabs.IsActive("HeadlessHorsemanBattlepass") then
            Tabs.Deactivate()
        end

        for _, v30 in t3 do
            v30.Visible = v28
        end

        if v29 and not v5 then
            v5 = true

            local Icon = Assets.Directory[HeadlessHorsemanBattlepass.PetId].Icon

            Toast.Show({
                Text = "Headless Horseman Battlepass complete! The Headless Horseman is ready to claim!",
                Seconds = 4,
                SingleLine = true,
                Unique = true,
                Color = v1,
                Image = Icon
            })
        end

        refresh()

        if v28 == v6 and v29 == v7 then
            return
        end

        v6 = v28
        v7 = v29
        v3:Fire()
    end

    local function claim() -- line: 138
        -- upvalues: refresh (copy), sync (copy), Assets (copy), HeadlessHorsemanBattlepass (copy), Remotes (copy), Tabs (copy), Toast (copy), v2 (copy), v4 (ref), t2 (copy)
        if not v4 and t2.IsClaimable() then
            v4 = true
            refresh()

            local function v31() -- line: 144
                -- upvalues: Remotes (copy)
                return Remotes.HalloweenDimension.AskClaimHorseman:InvokeServer()
            end

            local v32, v33, v34 = pcall(v31)

            v4 = false

            if v32 then
                if v33 == true then
                    if Tabs.IsActive("HeadlessHorsemanBattlepass") then
                        Tabs.Deactivate()
                    end
                else
                    if typeof(v34) ~= "string" then
                        v34 = "Could not confirm the claim. Try again."
                    end

                    local Icon = Assets.Directory[HeadlessHorsemanBattlepass.PetId].Icon

                    Toast.Show({
                        Seconds = 4,
                        SingleLine = true,
                        Unique = true,
                        Text = v34,
                        Color = v2,
                        Image = Icon
                    })
                end
            else
                v34 = "Could not confirm the claim. Try again."

                local Icon = Assets.Directory[HeadlessHorsemanBattlepass.PetId].Icon

                Toast.Show({
                    Seconds = 4,
                    SingleLine = true,
                    Unique = true,
                    Text = v34,
                    Color = v2,
                    Image = Icon
                })
            end

            sync()
        end
    end

    p4:Add(ButtonFX(ClaimPill, 1.06, function() -- line: 162
        -- upvalues: claim (copy)
        task.spawn(claim)
    end))
    p4:Add(Save.WatchFields("HalloweenDimension", sync))
    p4:Add(HalloweenDimensionFlags.ContentEnabled.Changed:Connect(sync))
    p4:Add(HalloweenDimensionFlags.HeadlessHorsemanBattlepassEnabled.Changed:Connect(sync))
    p4:Add(HalloweenDimensionFlags.HeadlessHorsemanBattlepassGoal.Changed:Connect(sync))
    p4:Add(task.spawn(function() -- line: 169
        -- upvalues: sync (copy)
        while true do
            sync()
            task.wait(1)
        end
    end))
end

return table.freeze(t2)
