-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local SoundService = game:GetService("SoundService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local GUI = require(ReplicatedStorage.Client.GUI)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local TrainEvent = require(ReplicatedStorage.Shared.Remotes).TrainEvent
local TrainEventFlags = require(ReplicatedStorage.Shared.Flags.TrainEventFlags)
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local TrainRewardFlight = require(script.Parent.TrainRewardFlight)
local t1 = {}
local _ = {
    Id = 120773212780205,
    Volume = 0.55,
    Delay = 1.25
}
local v1 = {
    Phase = "Home",
    ArrivalOpen = false
}
local DepartureAt
local v2 = false
local v3 = false
local t2 = {}
local t3 = {}
local v4 = false
local v5, TradeButton, HauntedSpirit, MutationItem, Hint

local function bindEventBannerStack(p1, p2, p3, p4) -- line: 33
    -- upvalues: Players (copy)
    local Position = p1.Position
    local t4 = {}
    local v6
    local v7 = false
    local v8 = false

    local function verticalBounds(p5) -- line: 39
        local Y = p5.AbsolutePosition.Y
        local v9 = Y
        local v10 = Y + p5.AbsoluteSize.Y

        local function visit(p6) -- line: 42
            -- upvalues: v9 (ref), v10 (ref), visit (copy)
            for _, child in p6:GetChildren() do
                if child:IsA("GuiObject") and child.Visible then
                    local v11 = v9

                    v9 = math.min(v11, child.AbsolutePosition.Y)

                    local v12 = v10

                    v10 = math.max(v12, child.AbsolutePosition.Y + child.AbsoluteSize.Y)
                    visit(child)
                end
            end
        end

        visit(p5)

        return v9, v10
    end

    local function refresh() -- line: 54
        -- upvalues: p1 (copy), p2 (copy), p3 (copy), Position (copy), v6 (ref), v7 (ref), v8 (ref)
        v7 = false

        if v8 then
            return
        end

        local Y = p3.AbsoluteSize.Y
        local v14

        if not p1.Visible or Y <= 0 then
            p1.Position = Position

            return
        elseif p2.Visible then
            local Y = p2.AbsolutePosition.Y
            local v16 = Y
            local v17 = Y + p2.AbsoluteSize.Y

            local function visit(p7) -- line: 42
                -- upvalues: v16 (ref), v17 (ref), visit (copy)
                for _, child in p7:GetChildren() do
                    if child:IsA("GuiObject") and child.Visible then
                        local v18 = v16

                        v16 = math.min(v18, child.AbsolutePosition.Y)

                        local v19 = v17

                        v17 = math.max(v19, child.AbsolutePosition.Y + child.AbsoluteSize.Y)
                        visit(child)
                    end
                end
            end

            visit(p2)
            v14 = v17
        else
            v14 = (-1e999)
        end

        if v6 and v6.Parent and v6.Enabled then
            local v21 = v14

            for _, child in v6:GetChildren() do
                if child:IsA("GuiObject") and child.Visible then
                    local Y = child.AbsolutePosition.Y
                    local v22 = Y
                    local v23 = Y + child.AbsoluteSize.Y

                    local function visit(p8) -- line: 42
                        -- upvalues: v22 (ref), v23 (ref), visit (copy)
                        for _, child in p8:GetChildren() do
                            if child:IsA("GuiObject") and child.Visible then
                                local v24 = v22

                                v22 = math.min(v24, child.AbsolutePosition.Y)

                                local v25 = v23

                                v23 = math.max(v25, child.AbsolutePosition.Y + child.AbsoluteSize.Y)
                                visit(child)
                            end
                        end
                    end

                    visit(child)
                    v21 = math.max(v21, v23)
                end

                v14 = v21
            end
        end

        local Y2 = p1.AbsolutePosition.Y
        local v28 = Y2
        local v29 = Y2 + p1.AbsoluteSize.Y

        local function visit(p9) -- line: 42
            -- upvalues: v28 (ref), v29 (ref), visit (copy)
            for _, child in p9:GetChildren() do
                if child:IsA("GuiObject") and child.Visible then
                    local v30 = v28

                    v28 = math.min(v30, child.AbsolutePosition.Y)

                    local v31 = v29

                    v29 = math.max(v31, child.AbsolutePosition.Y + child.AbsoluteSize.Y)
                    visit(child)
                end
            end
        end

        visit(p1)

        local v34 = v28
        local v33 = v34 - (p1.Position.Y.Scale - Position.Y.Scale) * Y
        local v37 = math.max(0, v14 + math.max(8, Y * 0.012) - v33)

        p1.Position = Position + UDim2.fromScale(0, v37 / Y)
    end

    local function schedule() -- line: 83
        -- upvalues: v7 (ref), v8 (ref), refresh (copy)
        if not (v7 or v8) then
            v7 = true
            task.defer(refresh)
        end
    end

    local function watch(p10) -- line: 88
        -- upvalues: t4 (copy), schedule (copy)
        if not p10:IsA("GuiObject") then
            return
        end

        table.insert(t4, p10:GetPropertyChangedSignal("Visible"):Connect(schedule))
        table.insert(t4, p10:GetPropertyChangedSignal("AbsoluteSize"):Connect(schedule))
    end

    for _, v38 in { p1, p2 } do
        watch(v38)

        for _, descendant in v38:GetDescendants() do
            watch(descendant)
        end
    end

    local function bindPumpkin(p11) -- line: 98
        -- upvalues: t4 (copy), v6 (ref), v7 (ref), v8 (ref), refresh (copy), schedule (copy), watch (copy)
        if p11.Name ~= "ReturnPumpkinsHUDTimer" or not p11:IsA("ScreenGui") or p11 == v6 then
            return
        end

        v6 = p11
        table.insert(t4, p11:GetPropertyChangedSignal("Enabled"):Connect(schedule))
        table.insert(t4, p11.AncestryChanged:Connect(schedule))
        table.insert(t4, p11.DescendantAdded:Connect(function(p12) -- line: 103
            -- upvalues: v7 (ref), v8 (ref), refresh (copy), watch (copy)
            watch(p12)

            if v7 or v8 then
                return
            end

            v7 = true
            task.defer(refresh)
        end))

        for _, descendant in p11:GetDescendants() do
            watch(descendant)
        end

        if v7 or v8 then
            return
        end

        v7 = true
        task.defer(refresh)
    end

    p4 = p4 or Players.LocalPlayer:WaitForChild("PlayerGui")

    for _, child in p4:GetChildren() do
        bindPumpkin(child)
    end

    table.insert(t4, p4.ChildAdded:Connect(bindPumpkin))
    table.insert(t4, p3:GetPropertyChangedSignal("AbsoluteSize"):Connect(schedule))

    if not v7 and not v8 then
        v7 = true
        task.defer(refresh)
    end

    return function() -- line: 115
        -- upvalues: p1 (copy), Position (copy), t4 (copy), v8 (ref)
        v8 = true

        for _, v41 in t4 do
            v41:Disconnect()
        end

        p1.Position = Position
    end
end

local function notice(p13, p14) -- line: 122
    -- upvalues: Toast (copy)
    Toast.Show({
        Lane = "Feed",
        Seconds = 3,
        Text = p13,
        Color = if p14 then Color3.fromRGB(150, 255, 120) else Color3.fromRGB(255, 120, 120)
    })
end

function t1.Update(p15) -- line: 130
    -- upvalues: v1 (ref)
    v1 = p15
end

function t1.InvasionTimer(p16, p17) -- line: 133
    local Invasion = p16.Invasion

    if p16.Phase ~= "Town" and p16.Phase ~= "Respawning" or typeof(Invasion) ~= "table" then
        return false, ""
    end

    local v42, v43

    if Invasion.Phase == "Warmup" then
        v43 = "Starts in"
        v42 = Invasion.StartsAt
    elseif Invasion.Phase == "Active" then
        v43 = "Invasion"
        v42 = Invasion.EndsAt
    else
        v43 = "Return in"
        v42 = p16.ReturnAt
    end

    if type(v42) ~= "number" or v42 ~= v42 or math.abs(v42) == 1e999 then
        return false, ""
    end

    local v46 = math.max(0, (math.ceil(v42 - p17)))

    if v46 ~= 0 then
        return true, string.format("%s\n%02d:%02d", v43, math.floor(v46 / 60), v46 % 60)
    end

    local v48 = Invasion.Phase == "Active"

    if Invasion.Phase == "Active" then
        return v48, "Invasion ended"
    end

    return v48, ""
end

function t1.TrainBanner(p18, p19, p20) -- line: 162
    local Invasion = p18.Invasion
    local v49 = (p18.Phase == "Town" or p18.Phase == "Respawning") and typeof(Invasion) == "table" and Invasion.Phase ~= "Warmup" and Invasion.Phase ~= "Active"

    if v49 and not p20 then
        return false, "", ""
    end

    local v50 = if v49 then p18.ReturnAt else p18.DepartureAt
    local v51, ArrivalOpen

    if type(v50) ~= "number" or v50 ~= v50 or math.abs(v50) == 1e999 then
        return false, "", ""
    else
        v51 = math.max(0, (math.ceil(v50 - p19)))

        if v51 > 0 then
            if v49 then
                ArrivalOpen = v49
            else
                ArrivalOpen = p18.ArrivalOpen

                if ArrivalOpen then
                    ArrivalOpen = p18.Phase == "Home" or p18.Phase == "Boarded"
                end
            end
        else
            ArrivalOpen = false
        end
    end

    local v57 = string.format("%s In: %d:%02d", if v49 then "Returning" else "Boarding Closes", math.floor(v51 / 60), v51 % 60)

    if v49 then
        return ArrivalOpen, v57, "The Phantom Express is leaving!"
    end

    return ArrivalOpen, v57, "The Phantom Express has arrived!"
end

function t1.UpdateInvasion(p21) -- line: 190
    -- upvalues: v1 (ref)
    v1.Invasion = p21
end

function t1.HasArrivalBanner() -- line: 193
    -- upvalues: t2 (copy)
    return #t2 > 0
end

local function refreshShop() -- line: 196
    -- upvalues: Tabs (copy), TrainEventFlags (copy), v1 (ref), v4 (ref), v5 (ref), TradeButton (ref), HauntedSpirit (ref), MutationItem (ref), Hint (ref)
    if not v5 then
        return
    end

    local SoulShop = v1.SoulShop

    if not SoulShop then
        TradeButton.Active = false

        return
    end

    HauntedSpirit.ItemName.Text = "Haunted Spirits (Souls)"
    HauntedSpirit.Quantity.RichText = true
    HauntedSpirit.Quantity.Text = string.format("<font color=\"%s\">%d</font> / %d", SoulShop.Souls >= SoulShop.Cost and "#7CFF6B" or "#FF6B6B", SoulShop.Souls, SoulShop.Cost)
    MutationItem.Quantity.Text = ("x1 · %*%%"):format((TrainEventFlags.SpectralSuccessPercent:Get()))

    local MutationItem2 = MutationItem

    MutationItem2:SetAttribute("OwnedCount", SoulShop.Count)
    MutationItem.ItemName.Text = "Spectral Mutation"

    local Hint2 = Hint

    if SoulShop.Enabled then
        Hint2.Text = string.format("Trade %d Souls for 1 Spectral Mutation Consumable", SoulShop.Cost)
    else
        Hint2.Text = SoulShop.Reason or "Trading is temporarily unavailable."
    end

    local AtShop = SoulShop.AtShop and SoulShop.CanTrade and not v4
    local TradeButton2 = TradeButton

    TradeButton2.Active = not v4

    local TradeButton3 = TradeButton

    TradeButton3:SetAttribute("Disabled", not AtShop)
    TradeButton.Title.Text = v4 and "TRADING..." or "TRADE"

    local TradeButton4 = TradeButton

    TradeButton4.ImageTransparency = AtShop and 0 or 0.4

    if Tabs.IsActive("SoulsTradeInMachine") and (v1.Phase ~= "Town" or not SoulShop.AtShop) then
        Tabs.Deactivate()
    end
end

local function fetch() -- line: 228
    -- upvalues: TrainEvent (copy), t1 (copy), v2 (ref), refreshShop (copy)
    if v2 then
        return
    end

    v2 = true

    local function v58() -- line: 233
        -- upvalues: TrainEvent (copy)
        return TrainEvent.Action:InvokeServer("Status")
    end

    local v59, v60, v61 = pcall(v58)

    if v59 and v60 and typeof(v61) == "table" then
        t1.Update(v61)
    end

    v2 = false
    refreshShop()
end

function t1.Start() -- line: 242
    -- upvalues: Players (copy), RunService (copy), ProximityPromptService (copy), SoundService (copy), Audio (copy), GUI (copy), Tabs (copy), ButtonFX (copy), TrainEvent (copy), TrainEventFlags (copy), PumpkinBossState (copy), TrainRewardFlight (copy), t1 (copy), v1 (ref), DepartureAt (ref), v3 (ref), t2 (copy), t3 (copy), v4 (ref), v5 (ref), TradeButton (ref), HauntedSpirit (ref), MutationItem (ref), Hint (ref), bindEventBannerStack (copy), notice (copy), refreshShop (copy), fetch (copy)
    if v3 then
        return
    end

    v3 = true
    v5 = GUI.Get("SoulsTradeInMachine")

    local TradeUp = v5.Frame.Collection.TradeUp

    HauntedSpirit = TradeUp.InputSlot.HauntedSpirit
    MutationItem = TradeUp.OutputSlot.MutationItem
    TradeButton = TradeUp.TradeButton
    Hint = v5.Frame.Collection.Hint
    ButtonFX(TradeButton)
    GUI.OnActivated(TradeButton, function() -- line: 254
        -- upvalues: TrainEvent (copy), TrainRewardFlight (copy), v1 (ref), v4 (ref), TradeButton (ref), MutationItem (ref), notice (copy), refreshShop (copy), fetch (copy)
        if not v4 then
            if v1.SoulShop then
                if TradeButton:GetAttribute("Disabled") then
                    notice(if v1.SoulShop.AtShop then v1.SoulShop.Reason or "Trade is unavailable." else "Get closer to the Soul Keeper.", false)
                else
                    v4 = true
                    refreshShop()

                    local function v63() -- line: 273
                        -- upvalues: TrainEvent (copy), v1 (ref)
                        return TrainEvent.Action:InvokeServer("TradeSouls", v1.SoulShop.Cost)
                    end

                    local v64, v65, v66 = pcall(v63)

                    v4 = false

                    if not v64 or typeof(v66) ~= "string" then
                        v66 = "Trade could not finish. Please try again."
                    end

                    notice(v66, v64 and v65 == true)
                    fetch()

                    if v64 and v65 == true then
                        TrainRewardFlight.Play(MutationItem, "Spectral")
                    end
                end
            else
                notice("Your data is still loading.", false)
            end
        end
    end)

    local HUD = GUI.Get("HUD")

    for _, v67 in { "GameHUD", "TradmilHud" } do
        local v68 = HUD:FindFirstChild(v67)
        local v69, v70

        if v68 then
            v70 = v68:FindFirstChild("TrainNotification")
            v69 = v68:FindFirstChild("BottomRight")
        else
            v69 = v68
            v70 = v68
        end

        local GhostInvasionTimer = v69 and v69:FindFirstChild("GhostInvasionTimer")

        if GhostInvasionTimer then
            GhostInvasionTimer.Visible = false
            table.insert(t3, GhostInvasionTimer)
        end

        if v70 then
            table.insert(t2, v70)
            v70.Visible = false

            local WorldEventNotification = v68:FindFirstChild("WorldEventNotification")

            if WorldEventNotification and WorldEventNotification:IsA("GuiObject") then
                bindEventBannerStack(v70, WorldEventNotification, v68)
            end

            local TextButton = Instance.new("TextButton")

            TextButton.Name = "TrainStationAction"
            TextButton.Text = ""
            TextButton.BackgroundTransparency = 1
            TextButton.Size = UDim2.fromScale(1, 1)
            TextButton.ZIndex = 100
            TextButton.Parent = v70
            GUI.OnActivated(TextButton, function() -- line: 312
                -- upvalues: TrainEvent (copy), v1 (ref), v4 (ref), notice (copy)
                if v4 or v1.StationAvailable ~= true or not v1.ArrivalOpen or v1.Phase ~= "Home" or v1.AtStation then
                    return
                end

                v4 = true

                local function v71() -- line: 323
                    -- upvalues: TrainEvent (copy)
                    return TrainEvent.Action:InvokeServer("Station")
                end

                local v72, v73, v74 = pcall(v71)

                v4 = false

                if not v72 or not v73 then
                    if typeof(v74) ~= "string" then
                        v74 = "Station is unavailable."
                    end

                    notice(v74, false)
                end
            end)
        end
    end

    ProximityPromptService.PromptTriggered:Connect(function(p22, p23) -- line: 336
        -- upvalues: Players (copy), Tabs (copy), TrainEvent (copy), t1 (copy), v4 (ref), notice (copy), refreshShop (copy)
        if p23 and p23 ~= Players.LocalPlayer or p22:GetAttribute("TrainEventAction") ~= "OpenSoulShop" or v4 then
            return
        end

        v4 = true

        local function v75() -- line: 344
            -- upvalues: TrainEvent (copy)
            return TrainEvent.Action:InvokeServer("OpenSoulShop")
        end

        local v76, v77, v78 = pcall(v75)

        v4 = false

        if v76 and v77 and typeof(v78) == "table" then
            t1.Update(v78)
            refreshShop()

            if not Tabs.IsActive("SoulsTradeInMachine") then
                Tabs.Activate("SoulsTradeInMachine")
            end
        else
            if typeof(v78) ~= "string" then
                v78 = "The Soul Keeper is unavailable."
            end

            notice(v78, false)
        end
    end)
    TrainEventFlags.SpectralSuccessPercent.Changed:Connect(refreshShop)
    Tabs.Activated:Connect(function(p24) -- line: 362
        -- upvalues: fetch (copy)
        if p24 == "SoulsTradeInMachine" then
            fetch()
        end
    end)

    local n1 = 0
    local n2 = 0
    local v79 = false
    local v80 = false
    local v81

    local function readArena() -- line: 372
        -- upvalues: v79 (ref), Players (copy), PumpkinBossState (copy)
        v79 = Players.LocalPlayer:GetAttribute(PumpkinBossState.MemberAttribute) == true
    end

    RunService.Heartbeat:Connect(function(p25) -- line: 375
        -- upvalues: n1 (ref), n2 (ref), v79 (ref), v80 (ref), v81 (ref), Players (copy), SoundService (copy), Audio (copy), Tabs (copy), PumpkinBossState (copy), t1 (copy), v1 (ref), DepartureAt (ref), t2 (copy), t3 (copy), v4 (ref), refreshShop (copy), fetch (copy)
        local v82, v83 = t1.InvasionTimer(v1, workspace:GetServerTimeNow())

        for _, v84 in t3 do
            v84.Visible = v82
            v84.Value.Text = v83
        end

        local Character = Players.LocalPlayer.Character
        local v86, v87, v88 = t1.TrainBanner(v1, workspace:GetServerTimeNow(), Character ~= nil and Character:GetAttribute("TrainEventInForgottenTown") == true)

        n2 += p25

        if v86 and not v80 or n2 >= 0.5 then
            n2 = 0
            v79 = Players.LocalPlayer:GetAttribute(PumpkinBossState.MemberAttribute) == true
        end

        v80 = v86

        local v92 = v86 and not v79
        local v93 = v92 ~= v81

        v81 = v92

        for _, v94 in t2 do
            if v93 then
                v94.Visible = v92
            end

            v94.TimerHolder.TimerLabel.Text = v87
            v94.txt.Text = v88
        end

        if v86 and v1.ArrivalOpen and v1.Phase == "Home" and v1.DepartureAt ~= DepartureAt then
            DepartureAt = v1.DepartureAt
            task.delay(1.25, Audio.Play, 120773212780205, SoundService, {
                Volume = 0.55
            })
        end

        n1 += p25

        if not (n1 >= 1) then
            return
        end

        n1 = 0
        refreshShop()

        if Tabs.IsActive("SoulsTradeInMachine") and not v4 then
            task.spawn(fetch)
        end
    end)
end

return t1
