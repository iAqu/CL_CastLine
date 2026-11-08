-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local t1 = {
    top = {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.12)
    },
    center = {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5)
    },
    left = {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.03, 0.3)
    },
    right = {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(0.97, 0.3)
    }
}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local t2 = {}
local n1 = 0

local function findHotbar() -- line: 35
    -- upvalues: PlayerGui (copy)
    local BackpackGui = PlayerGui:FindFirstChild("BackpackGui")
    local Backpack = BackpackGui and BackpackGui:FindFirstChild("Backpack")
    local Hotbar = Backpack and Backpack:FindFirstChild("Hotbar")

    return if Hotbar and Hotbar:IsA("GuiObject") and Hotbar.AbsoluteSize.Y > 0 then Hotbar else nil
end

local function placeAboveHotbar(p1, p2) -- line: 45
    -- upvalues: findHotbar (copy)
    p2.AnchorPoint = Vector2.new(0.5, 1)

    local AbsoluteSize = p1.AbsoluteSize
    local v1 = findHotbar()

    if v1 == nil or AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        p2.Position = UDim2.fromScale(0.5, 0.86)

        return
    end

    local v2 = p1:GetAttribute("Gap") or 0.01
    local AbsolutePosition = p1.AbsolutePosition
    local v3 = v1.AbsolutePosition.X + v1.AbsoluteSize.X / 2 - AbsolutePosition.X
    local v4 = v1.AbsolutePosition.Y - AbsolutePosition.Y

    p2.Position = UDim2.fromScale(v3 / AbsoluteSize.X, v4 / AbsoluteSize.Y - v2)
end

local function place(p3, p4, p5) -- line: 62
    -- upvalues: t1 (copy), placeAboveHotbar (copy)
    local v5 = if p5 then t1[p5] else nil

    if v5 ~= nil then
        p4.AnchorPoint = v5.AnchorPoint
        p4.Position = v5.Position
    else
        placeAboveHotbar(p3, p4)
    end
end

local function flash(p6) -- line: 73
    -- upvalues: t1 (copy), LocalPlayer (copy), PlayerGui (copy), n1 (ref), placeAboveHotbar (copy)
    local FlashUserId = PlayerGui:FindFirstChild("FlashUserId")
    local UserId = FlashUserId and FlashUserId:FindFirstChild("UserId")
    local v6, v7, v8

    if FlashUserId ~= nil then
        if not FlashUserId:IsA("ScreenGui") or UserId == nil then
            v8 = true
        elseif UserId:IsA("TextLabel") then
            n1 += 1
            v6 = n1
            UserId.Text = tostring(LocalPlayer.UserId)

            if p6 then
                v7 = t1[p6]
            end

            v8 = false
        else
            v8 = true
        end
    else
        v8 = true
    end

    if v8 then
        warn("[FlashUserId] PlayerGui.FlashUserId.UserId is missing")

        return
    end

    if v7 ~= nil then
        UserId.AnchorPoint = v7.AnchorPoint
        UserId.Position = v7.Position
    else
        placeAboveHotbar(FlashUserId, UserId)
    end

    FlashUserId.Enabled = true

    local delay = task.delay
    local v9 = FlashUserId:GetAttribute("Seconds") or 0.7
    local v10 = v6

    delay(v9, function() -- line: 92
        -- upvalues: FlashUserId (copy), v10 (copy), n1 (ref)
        if n1 == v10 then
            FlashUserId.Enabled = false
        end
    end)
end

function t2.Start() -- line: 99
    -- upvalues: Remotes (copy), flash (copy)
    Remotes.Broadcasts.FlashUserId.OnClientEvent:Connect(flash)
end

return t2
