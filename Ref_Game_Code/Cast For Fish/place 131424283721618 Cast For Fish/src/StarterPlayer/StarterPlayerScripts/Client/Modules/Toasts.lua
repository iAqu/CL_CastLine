-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Parent = script.Parent
local UIKit = require(Parent.UIKit)
local Notifications = require(Parent.Notifications)
local BannerDodge = require(Parent.BannerDodge)
local t1 = {
    "^Sold",
    "^Bought",
    "^Upgraded"
}
local t2 = {
    "BaitOffer",
    "Popups"
}
local t3 = {
    success = {
        Sound = "ToastSuccess",
        Top = UIKit.Colors.Green,
        Bottom = UIKit.Colors.GreenDark
    },
    error = {
        Sound = "ToastError",
        Top = UIKit.Colors.Red,
        Bottom = UIKit.Colors.RedDark
    },
    gold = {
        Sound = "ToastGold",
        Top = UIKit.Colors.Gold,
        Bottom = UIKit.Colors.GoldDark
    },
    info = {
        Sound = "ToastInfo",
        Top = UIKit.Colors.Blue,
        Bottom = UIKit.Colors.BlueDark
    }
}
local PlayerGui, v1, v2
local n1 = 0
local t4 = {}

local function cleanKind(p1) -- line: 45
    -- upvalues: t3 (copy)
    if type(p1) ~= "string" or #p1 > 16 then
        return nil
    end

    if t3[p1] then
        return p1
    end

    return "info"
end

local function cleanText(p2) -- line: 52
    if type(p2) ~= "string" or p2 == "" or #p2 > 800 then
        return nil
    end

    local v3 = utf8.len(p2)

    return if v3 and not (v3 > 200) then p2 else nil
end

local function soundFor(p3, p4) -- line: 63
    -- upvalues: t1 (copy), t3 (copy)
    if p3 ~= "success" then
        return (t3[p3] or t3.info).Sound
    end

    for _, v4 in t1 do
        if string.find(p4, v4) then
            return "Cash"
        end
    end

    return (t3[p3] or t3.info).Sound
end

local function isBlocked() -- line: 74
    -- upvalues: UIKit (copy), PlayerGui (ref)
    if UIKit.anyWindowOpen() then
        return true
    end

    local OfflineEarnings = PlayerGui and PlayerGui:FindFirstChild("OfflineEarnings")
    local Card = OfflineEarnings and OfflineEarnings:FindFirstChild("Card")

    return Card ~= nil and Card:IsA("GuiObject") and Card.Visible
end

local function makeRoom() -- line: 83
    -- upvalues: Notifications (copy), t4 (copy)
    if #Notifications.Shared.Active < Notifications.MAX_ON_SCREEN or #t4 == 0 then
        return
    end

    local v5 = t4[1]
    local v6 = 0.6 - (os.clock() - v5.ShownAt)

    if v6 <= 0 then
        v5.Finish()
    else
        task.delay(v6, v5.Finish)
    end
end

local function trimStack(p5) -- line: 96
    local t5 = {}

    for _, child in p5:GetChildren() do
        if child:IsA("CanvasGroup") then
            table.insert(t5, child)
        end
    end

    table.sort(t5, function(p6, p7) -- line: 103
        return p6.LayoutOrder < p7.LayoutOrder
    end)

    for i = 1, #t5 - 3 do
        t5[i]:Destroy()
    end
end

local function display(p8, p9, p10, p11) -- line: 111
    -- upvalues: UIKit (copy), Notifications (copy), t3 (copy), v1 (ref), n1 (ref), t4 (copy), soundFor (copy), makeRoom (copy), trimStack (copy)
    local v7 = v1

    if not v7 then
        p10:Done()

        return
    end

    local v8 = t3[p8] or t3.info

    n1 += 1
    trimStack(v7)

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Toast"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.Size = UDim2.fromOffset(640, 76)
    CanvasGroup.LayoutOrder = n1
    CanvasGroup.Parent = v7

    local v9 = UIKit.frame(CanvasGroup, {
        Name = "Bar",
        Corner = 14,
        Stroke = 5,
        Size = UDim2.new(1, -14, 1, -14),
        Position = UDim2.fromOffset(7, 7),
        Color = v8.Top,
        Color2 = v8.Bottom
    })

    UIKit.text(v9, {
        Stroke = 4,
        Text = p9,
        Size = UDim2.new(1, -28, 1, -14),
        Position = UDim2.fromOffset(14, 7)
    })

    local v10 = UIKit.scaleOf(CanvasGroup)

    v10.Scale = 0.6
    CanvasGroup.GroupTransparency = 1
    UIKit.tween(v10, 0.25, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    UIKit.tween(CanvasGroup, 0.12, {
        GroupTransparency = 0
    })

    if not p11 then
        UIKit.sound((soundFor(p8, p9)))
    end

    local t6

    t6 = {
        Finished = false,
        ShownAt = os.clock(),
        Finish = function() -- Finish | line: 143
            -- upvalues: p10 (copy), CanvasGroup (copy), t6 (ref), UIKit (copy), t4 (copy)
            if t6.Finished then
                return
            end

            t6.Finished = true

            local v11 = table.find(t4, t6)

            if v11 then
                table.remove(t4, v11)
            end

            if CanvasGroup.Parent then
                UIKit.tween(CanvasGroup, 0.3, {
                    GroupTransparency = 1
                }).Completed:Once(function() -- line: 154
                    -- upvalues: p10 (copy), CanvasGroup (copy)
                    CanvasGroup:Destroy()
                    p10:Done()
                end)
            else
                p10:Done()
            end
        end
    }
    table.insert(t4, t6)
    task.delay(2, t6.Finish)

    if #Notifications.Shared.Pending > 0 then
        task.defer(makeRoom)
    end
end

local function applyBlocked(p12) -- line: 170
    -- upvalues: t2 (copy), PlayerGui (ref), v1 (ref)
    local v12 = v1

    if v12 then
        v12.Visible = not p12
    end

    if PlayerGui then
        for _, v13 in t2 do
            local v14 = PlayerGui:FindFirstChild(v13)

            if v14 and v14:IsA("ScreenGui") then
                v14.Enabled = not p12
            end
        end
    end
end

local t8 = {}

function t8.Show(p13, p14) -- line: 188
    -- upvalues: UIKit (copy), Notifications (copy), t3 (copy), PlayerGui (ref), v1 (ref), soundFor (copy), makeRoom (copy), display (copy)
    local v15 = if type(p13) ~= "string" or #p13 > 16 then nil elseif t3[p13] then p13 else "info"
    local v16

    if type(p14) == "string" and p14 ~= "" and not (#p14 > 800) then
        local v17 = utf8.len(p14)

        if v17 and not (v17 > 200) then
            v16 = p14
        end
    end

    if not (v1 and v15 and v16) then
        return
    end

    local Shared = Notifications.Shared
    local v18 = "toast:" .. v15 .. ":" .. v16
    local v19 = Shared:Find(v18) == nil
    local v20 = false
    local v21 = Shared:Push({
        priority = Notifications.CATCH,
        key = v18,
        show = function(p15) -- show | line: 201
            -- upvalues: v20 (ref), v15 (copy), v16 (ref), display (copy)
            display(v15, v16, p15, v20)
        end
    })

    if v19 and v21.State == "pending" then
        local GuiObject

        if UIKit.anyWindowOpen() then
            GuiObject = true
        else
            local v22 = PlayerGui

            if v22 then
                v22 = PlayerGui:FindFirstChild("OfflineEarnings")
                v22 = v22 and v22:FindFirstChild("Card")
            end

            GuiObject = v22 ~= nil and v22:IsA("GuiObject") and v22.Visible
        end

        if GuiObject then
            v20 = true
            UIKit.sound((soundFor(v15, v16)))
        end
    end

    makeRoom()
end

function t8.SetTop(p16) -- line: 212
    -- upvalues: UIKit (copy), v1 (ref), v2 (ref)
    local v23 = v1

    if not v23 then
        return
    end

    local v24 = UDim2.new(0.5, 0, 0, p16 or 150)

    if v2 then
        v2.Base = v24
    end

    UIKit.tween(v23, 0.2, {
        Position = v24 + UDim2.fromOffset(0, if v2 then v2.Shift else 0)
    })
end

function t8.Init() -- line: 224
    -- upvalues: Players (copy), ReplicatedStorage (copy), RunService (copy), UIKit (copy), Notifications (copy), BannerDodge (copy), PlayerGui (ref), v1 (ref), v2 (ref), isBlocked (copy), applyBlocked (copy), t8 (copy)
    PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    local v25 = UIKit.screenGui("Toasts", 20)
    local v26 = UIKit.frame(v25, {
        Name = "List",
        Transparency = 1,
        Size = UDim2.fromOffset(640, 400),
        Position = UDim2.new(0.5, 0, 0, 150),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Padding = UDim.new(0, -6)
    UIListLayout.Parent = v26
    v1 = v26
    v2 = BannerDodge.new(v26, { { "BaitOffer", "Bar" } })
    Notifications.Shared.Paused = isBlocked

    local v27 = false

    RunService.Heartbeat:Connect(function() -- line: 238
        -- upvalues: v27 (ref), UIKit (copy), PlayerGui (ref), applyBlocked (copy)
        local v28

        if UIKit.anyWindowOpen() then
            v28 = true
        else
            local OfflineEarnings = PlayerGui and PlayerGui:FindFirstChild("OfflineEarnings")
            local Card = OfflineEarnings and OfflineEarnings:FindFirstChild("Card")

            v28 = Card ~= nil and Card:IsA("GuiObject") and Card.Visible
        end

        if v28 ~= v27 then
            v27 = v28
            applyBlocked(v28)
        end
    end)
    ReplicatedStorage:WaitForChild("Remotes").Notify.OnClientEvent:Connect(t8.Show)
end

return t8
