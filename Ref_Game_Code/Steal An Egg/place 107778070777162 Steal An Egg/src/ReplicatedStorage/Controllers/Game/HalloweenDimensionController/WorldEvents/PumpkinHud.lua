-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Attributes, PlayerAttributes = HalloweenDimension.Attributes, HalloweenDimension.PlayerAttributes
local t1 = {}

local function child(p1, p2, p3) -- line: 44
    local v1 = p1:FindFirstChild(p2)

    assert(v1 ~= nil and v1:IsA(p3), (("%* is missing %* %*"):format(p1:GetFullName(), p3, p2)))

    return v1
end

local function bindSlot(p4) -- line: 50
    local Avatar = p4:FindFirstChild("Avatar")

    assert(Avatar ~= nil and Avatar:IsA("ImageLabel"), (("%* is missing ImageLabel Avatar"):format((p4:GetFullName()))))

    local t2 = {
        UserId = nil,
        Frame = p4,
        Avatar = Avatar
    }
    local YouStroke = Avatar:FindFirstChild("YouStroke")

    assert(YouStroke ~= nil and YouStroke:IsA("UIStroke"), (("%* is missing UIStroke YouStroke"):format((Avatar:GetFullName()))))
    t2.You = YouStroke

    local CounterHolder = p4:FindFirstChild("CounterHolder")

    assert(CounterHolder ~= nil and CounterHolder:IsA("GuiObject"), (("%* is missing GuiObject CounterHolder"):format((p4:GetFullName()))))

    local CounterLabel = CounterHolder:FindFirstChild("CounterLabel")

    assert(CounterLabel ~= nil and CounterLabel:IsA("TextLabel"), (("%* is missing TextLabel CounterLabel"):format((CounterHolder:GetFullName()))))
    t2.Counter = CounterLabel

    return t2
end

local function numberAttribute(p5, p6) -- line: 61
    local Attribute = p5:GetAttribute(p6)

    return if type(Attribute) == "number" then Attribute else nil
end

local function ranked() -- line: 66
    -- upvalues: Players (copy), PlayerAttributes (copy)
    local t3 = {}

    for _, player in Players:GetPlayers() do
        local Attribute = player:GetAttribute(PlayerAttributes.Pumpkins)

        if type(Attribute) ~= "number" then
            Attribute = nil
        end

        local v12 = Attribute or 0

        if v12 > 0 or player:GetAttribute(PlayerAttributes.Inside) == true then
            local t4 = {
                Player = player,
                Count = v12
            }
            local Attribute = player:GetAttribute(PlayerAttributes.PumpkinsAt)

            if type(Attribute) ~= "number" then
                Attribute = nil
            end

            t4.ReachedAt = Attribute or 1e999
            table.insert(t3, t4)
        end
    end

    table.sort(t3, function(p7, p8) -- line: 78
        if p7.Count ~= p8.Count then
            return p7.Count > p8.Count
        end

        if p7.ReachedAt == p8.ReachedAt then
            return p7.Player.UserId < p8.Player.UserId
        end

        return p7.ReachedAt < p8.ReachedAt
    end)

    return t3
end

local function clock(p9) -- line: 90
    local v14 = math.max(0, (math.ceil(p9)))

    return string.format("%02d:%02d", v14 // 60, v14 % 60)
end

local function show(p10, p11) -- line: 95
    -- upvalues: RunService (copy), Workspace (copy), LocalPlayer (copy), Attributes (copy), bindSlot (copy), ranked (copy)
    local HUD = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")

    assert(HUD:IsA("ScreenGui"), "HUD must be a ScreenGui")
    p10.ScreenInsets = HUD.ScreenInsets
    p10.ClipToDeviceSafeArea = HUD.ClipToDeviceSafeArea

    local Timer = p10:FindFirstChild("Timer")

    assert(Timer ~= nil and Timer:IsA("GuiObject"), (("%* is missing GuiObject Timer"):format((p10:GetFullName()))))

    local TimerLabel = Timer:FindFirstChild("TimerLabel")

    assert(TimerLabel ~= nil and TimerLabel:IsA("TextLabel"), (("%* is missing TextLabel TimerLabel"):format((Timer:GetFullName()))))

    local ProfileShowcase = p10:FindFirstChild("ProfileShowcase")

    assert(ProfileShowcase ~= nil and ProfileShowcase:IsA("GuiObject"), (("%* is missing GuiObject ProfileShowcase"):format((p10:GetFullName()))))

    local t5 = {}

    for i = 1, 4 do
        local v21 = ("Slot%*"):format(i)
        local v22 = ProfileShowcase:FindFirstChild(v21)

        assert(v22 ~= nil and v22:IsA("GuiObject"), (("%* is missing GuiObject %*"):format(ProfileShowcase:GetFullName(), v21)))
        table.insert(t5, (bindSlot(v22)))
    end

    local function refresh() -- line: 109
        -- upvalues: TimerLabel (copy), t5 (copy), Workspace (copy), LocalPlayer (copy), Attributes (copy), ranked (copy)
        local Attribute = Workspace:GetAttribute(Attributes.WorldEventEndsAt)
        local v28 = math.max(0, (math.ceil(if type(Attribute) == "number" then Attribute - Workspace:GetServerTimeNow() else 0)))

        TimerLabel.Text = string.format("%02d:%02d", v28 // 60, v28 % 60)

        local v29 = ranked()

        for v30, v31 in t5 do
            local v32 = v29[v30]

            v31.Frame.Visible = v32 ~= nil

            if v32 ~= nil then
                local UserId = v32.Player.UserId

                if v31.UserId ~= UserId then
                    v31.UserId = UserId
                    v31.Avatar.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420", UserId)
                end

                v31.Counter.Text = tostring(v32.Count)
                v31.You.Enabled = v32.Player == LocalPlayer
            else
                v31.You.Enabled = false
            end
        end
    end

    local n1 = 0

    p11:Connect(RunService.Heartbeat, function(p12) -- line: 132
        -- upvalues: refresh (copy), n1 (ref)
        n1 += p12

        if n1 >= 0.2 then
            n1 = 0
            refresh()
        end
    end)
    p11:Add(function() -- line: 139
        -- upvalues: p10 (copy), t5 (copy)
        p10.Enabled = false

        for _, v33 in t5 do
            v33.You.Enabled = false
        end
    end)
    refresh()
    p10.Enabled = true
end

function t1.Bind(p13) -- line: 153
    -- upvalues: LocalPlayer (copy), show (copy)
    p13:Add(task.spawn(function() -- line: 154
        -- upvalues: p13 (copy), LocalPlayer (copy), show (copy)
        local ReturnPumpkinsHUDTimer = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ReturnPumpkinsHUDTimer")

        assert(ReturnPumpkinsHUDTimer:IsA("ScreenGui"), (("%* must be a ScreenGui"):format((ReturnPumpkinsHUDTimer:GetFullName()))))
        show(ReturnPumpkinsHUDTimer, p13)
    end))
end

return t1
