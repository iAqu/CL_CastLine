-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Confetti = require(ReplicatedStorage.Client.UI.VFX.Confetti)
local Message = require(ReplicatedStorage.Client.Message)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local t1 = {
    ProductSettled = 0.8,
    Rejected = 90
}
local t2 = {
    Bounced = "Your gift couldn't reach its recipient, so it was added to your account instead.",
    Failed = "That purchase didn't go through. If any Robux were taken, Roblox refunds them automatically. Let us know if this keeps happening. 🙏",
    GiftDelivered = "Your gift has been delivered! 🎁",
    Thanks = "Thanks for your support! Your purchase is on its way. 🎉"
}
local t3 = {}
local t4 = {}
local t5 = {}

local function profileLoaded() -- line: 42
    -- upvalues: Save (copy)
    return Save.Await() ~= nil
end

local function firstSighting(p1) -- line: 46
    -- upvalues: t3 (copy)
    if t3[p1] then
        return false
    end

    t3[p1] = true

    return true
end

local function report(p2, p3) -- line: 54
    -- upvalues: Audio (copy), Confetti (copy), Message (copy)
    local v1 = p3 or {}

    local function deliver() -- line: 56
        -- upvalues: p2 (copy), v1 (copy), Audio (copy), Confetti (copy), Message (copy)
        if v1.Celebrate then
            Confetti.Burst()
            Audio.Play(98002834893313, script)
        end

        Message.Notice(p2)
    end

    if v1.After ~= nil then
        task.delay(v1.After, deliver)
    else
        if v1.Celebrate then
            Confetti.Burst()
            Audio.Play(98002834893313, script)
        end

        Message.Notice(p2)
    end
end

local function productIdOf(p4) -- line: 70
    local ProductId = if type(p4) == "table" then p4.ProductId else nil

    return if type(ProductId) == "number" then ProductId else nil
end

local function holdFailureNotice(p5) -- line: 77
    -- upvalues: t4 (copy), report (copy)
    if p5 ~= nil then
        if t4[p5] == nil then
            t4[p5] = task.delay(90, function() -- line: 85
                -- upvalues: p5 (copy), t4 (copy), report (copy)
                t4[p5] = nil
                report("That purchase didn't go through. If any Robux were taken, Roblox refunds them automatically. Let us know if this keeps happening. 🙏")
            end)
        end
    else
        report("That purchase didn't go through. If any Robux were taken, Roblox refunds them automatically. Let us know if this keeps happening. 🙏", {
            After = 90
        })
    end
end

local function withdrawFailureNotice(p6) -- line: 91
    -- upvalues: t4 (copy)
    local v2 = t4[p6]

    if v2 ~= nil then
        t4[p6] = nil
        task.cancel(v2)
    end
end

local function giftLine(p7) -- line: 99
    -- upvalues: Players (copy)
    if p7 == Players.LocalPlayer.UserId then
        return "Your gift couldn't reach its recipient, so it was added to your account instead."
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p7)

    if PlayerByUserId then
        return (("Your gift is on its way to %*! 🎁"):format(PlayerByUserId.DisplayName))
    end

    return "Your gift has been delivered! 🎁"
end

function t5.Start() -- line: 107
    -- upvalues: Players (copy), Remotes (copy), Save (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), report (copy), holdFailureNotice (copy)
    Remotes.PassGrants.Awarded.OnClientEvent:Connect(function(_, p9) -- line: 108
        -- upvalues: Save (copy), report (copy)
        if not p9 and Save.Await() ~= nil then
            report("Thanks for your support! Your purchase is on its way. 🎉", {
                Celebrate = true
            })
        end
    end)

    local function onReceiptSettled(p10, p11) -- line: 114
        -- upvalues: Save (copy), t4 (copy), report (copy)
        if p10 ~= nil then
            local v3 = t4[p10]

            if v3 ~= nil then
                t4[p10] = nil
                task.cancel(v3)
            end
        end

        if p11 and Save.Await() ~= nil then
            report("Thanks for your support! Your purchase is on its way. 🎉", {
                Celebrate = true,
                After = 0.8
            })
        end
    end

    Remotes.Storefront.PurchaseSettled.OnClientEvent:Connect(function(_, p13) -- line: 122
        -- upvalues: Save (copy), t1 (copy), t2 (copy), t4 (copy), report (copy)
        local ProductId = if type(p13) == "table" then p13.ProductId else nil

        if type(ProductId) ~= "number" then
            ProductId = nil
        end

        if ProductId ~= nil then
            local v4 = t4[ProductId]

            if v4 ~= nil then
                t4[ProductId] = nil
                task.cancel(v4)
            end
        end

        if Save.Await() ~= nil then
            report(t2.Thanks, {
                Celebrate = true,
                After = t1.ProductSettled
            })
        end
    end)
    Remotes.Storefront.ReceiptCleared.OnClientEvent:Connect(function(p14, _, p16) -- line: 125
        -- upvalues: Save (copy), t1 (copy), t2 (copy), t4 (copy), report (copy)
        local v5 = if type(p14) == "number" then p14 else nil
        local v6 = not p16

        if v5 ~= nil then
            local v7 = t4[v5]

            if v7 ~= nil then
                t4[v5] = nil
                task.cancel(v7)
            end
        end

        if v6 and Save.Await() ~= nil then
            report(t2.Thanks, {
                Celebrate = true,
                After = t1.ProductSettled
            })
        end
    end)
    Remotes.Storefront.PurchaseRejected.OnClientEvent:Connect(function(p17) -- line: 129
        -- upvalues: holdFailureNotice (copy)
        local ProductId = if type(p17) == "table" then p17.ProductId else nil

        if type(ProductId) ~= "number" then
            ProductId = nil
        end

        holdFailureNotice(ProductId)
    end)
    Remotes.Gifting.Received.OnClientEvent:Connect(function(p18, p19, p20) -- line: 133
        -- upvalues: t3 (copy), report (copy)
        if not t3[p19] then
            t3[p19] = true
            report(("%* sent you a gift: %*! 🎁"):format(p18, p20), {
                Celebrate = true
            })
        end
    end)
    Remotes.Gifting.Completed.OnClientEvent:Connect(function(_, p22, p23) -- line: 138
        -- upvalues: Players (copy), t2 (copy), t3 (copy), report (copy)
        if t3[p23] then
            return
        end

        t3[p23] = true

        local v8

        if p22 == Players.LocalPlayer.UserId then
            v8 = t2.Bounced
        else
            local PlayerByUserId = Players:GetPlayerByUserId(p22)

            v8 = if PlayerByUserId then ("Your gift is on its way to %*! 🎁"):format(PlayerByUserId.DisplayName) else t2.GiftDelivered
        end

        report(v8, {
            Celebrate = true
        })
    end)
end

return t5
