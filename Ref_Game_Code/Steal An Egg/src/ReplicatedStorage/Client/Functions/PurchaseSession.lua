-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CashPacks = require(ReplicatedStorage.Data.CashPacks)
local SpeedPacks = require(ReplicatedStorage.Data.SpeedPacks)
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local Gamepasses = require(ReplicatedStorage.Data.Gamepasses)
local PurchaseLedger = require(ReplicatedStorage.Client.Functions.PurchaseLedger)
local Products = require(ReplicatedStorage.Data.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local t1 = {
    Busy = "Wrap up the purchase window that's already open before starting another one.",
    Disabled = "Purchases are paused for a moment while Roblox catches up. Please try again shortly.",
    Owned = "You already own this!",
    Pending = "Roblox is still confirming your last attempt to buy this. If it never arrives, rejoin and it will sync.",
    Screened = "This item isn't available to buy right now.",
    Settled = "This one-time item already went through on your account. Rejoin if it hasn't shown up yet.",
    Unavailable = "The shop couldn't open that purchase. Please try again in a moment.",
    UnknownSku = "We couldn't find that item in the shop. If this keeps happening, let our support team know."
}
local t2 = {
    Owned = true
}
local t3 = {
    Silent = true
}
local LocalPlayer = Players.LocalPlayer
local t4 = {}

local function refusal(p1, p2) -- line: 43
    return {
        Refusal = p1,
        Note = p2
    }
end

local function refuse(p3, p4) -- line: 47
    -- upvalues: ReplicatedStorage (copy), t1 (copy), t2 (copy)
    local Message = require(ReplicatedStorage.Client.Message)

    p4 = p4 or t1[p3]

    if t2[p3] then
        Message.Notice(p4)
    else
        Message.Warn(p4)
    end
end

local function chime() -- line: 57
    -- upvalues: ReplicatedStorage (copy)
    require(ReplicatedStorage.Shared.Audio).Play(129627240635324, script, {
        PlaybackSpeed = 1.3,
        Volume = 0.6
    })
end

local function askServer(p5, p6, p7, p8) -- line: 62
    local function v2() -- line: 63
        -- upvalues: p5 (copy), p6 (copy), p7 (copy), p8 (copy)
        return p5:InvokeServer(p6, p7, p8)
    end

    local v3, v4, v5 = pcall(v2)
    local v6 = v3 and v4 == true

    if not v3 or type(v5) ~= "string" then
        return v6, nil
    end

    return v6, v5
end

local function storefrontOpen(_) -- line: 71
    -- upvalues: GameFlags (copy)
    return if not GameFlags.StorefrontOpen:Get() then {
        Refusal = "Disabled",
        Note = nil
    } else nil
end

local function knownSku(p10) -- line: 75
    return if p10.Config == nil then {
        Refusal = "UnknownSku",
        Note = nil
    } else nil
end

local function configVeto(p11) -- line: 79
    local Precheck = p11.Config.Precheck

    if Precheck == nil then
        return nil
    end

    local v7, v8, v9 = pcall(Precheck)

    if v7 then
        if v8 == true then
            return nil
        end

        if type(v9) ~= "string" then
            v9 = nil
        end

        return {
            Refusal = "Screened",
            Note = v9
        }
    end

    warn((("purchase precheck raised an error: %*"):format(v8)))

    return {
        Refusal = "Screened",
        Note = nil
    }
end

local function playCue(_) -- line: 95
    -- upvalues: ReplicatedStorage (copy)
    require(ReplicatedStorage.Shared.Audio).Play(129627240635324, script, {
        PlaybackSpeed = 1.3,
        Volume = 0.6
    })

    return nil
end

local function noOpenPrompt(_) -- line: 102
    -- upvalues: PurchaseLedger (copy)
    return if PurchaseLedger.HasOpenTicket() then {
        Refusal = "Busy",
        Note = nil
    } else nil
end

local function oneTimeNotRepeated(p14) -- line: 106
    -- upvalues: GameFlags (copy), PurchaseLedger (copy)
    if p14.Config.OneTime and GameFlags.OneTimeRepeatGuard:Get() then
        if PurchaseLedger.OwnedPerProfile(p14.SkuId) then
            return {
                Refusal = "Settled",
                Note = nil
            }
        end

        if PurchaseLedger.AwaitingReceipt(p14.SkuId) then
            return {
                Refusal = "Pending",
                Note = nil
            }
        end
    end

    return nil
end

local function serverApproves(p15) -- line: 116
    -- upvalues: CashPacks (copy), PurchaseLedger (copy), Remotes (copy), t3 (copy)
    local v10 = PurchaseLedger.OpenTicket(p15.SkuId)

    p15.Ticket = v10

    if CashPacks.FindSlot(p15.SkuId) then
        return nil
    end

    local AskServerProbe = Remotes.Storefront.AskServerProbe
    local SkuId = p15.SkuId
    local v11, v12

    local function v13() -- line: 63
        -- upvalues: AskServerProbe (copy), SkuId (copy), v11 (copy), v12 (copy)
        return AskServerProbe:InvokeServer(SkuId, v11, v12)
    end

    local v14, v15, v16 = pcall(v13)
    local v17 = v14 and v15 == true

    if not v14 or type(v16) ~= "string" then
        v16 = nil
    end

    if not v10.Live then
        return t3
    end

    if v17 then
        return nil
    end

    PurchaseLedger.CloseTicket(p15.SkuId)

    return {
        Refusal = "Unavailable",
        Note = v16
    }
end

local function promptFromClient(p16) -- line: 133
    -- upvalues: MarketplaceService (copy), PurchaseLedger (copy), t3 (copy), LocalPlayer (copy)
    local Ticket = p16.Ticket
    local PromptProductPurchase = MarketplaceService.PromptProductPurchase
    local SkuId = p16.SkuId

    if pcall(PromptProductPurchase, MarketplaceService, LocalPlayer, SkuId) or not Ticket.Live then
        return t3
    end

    PurchaseLedger.CloseTicket(p16.SkuId)

    return {
        Refusal = "Unavailable",
        Note = nil
    }
end

local function promptFromServer(p17) -- line: 143
    -- upvalues: PurchaseLedger (copy), Remotes (copy), t3 (copy)
    local Ticket = p17.Ticket
    local AskPurchaseOffer = Remotes.Storefront.AskPurchaseOffer
    local SkuId, Source, SpeedRevision = p17.SkuId, p17.Source, p17.SpeedRevision

    local function v18() -- line: 63
        -- upvalues: AskPurchaseOffer (copy), SkuId (copy), Source (copy), SpeedRevision (copy)
        return AskPurchaseOffer:InvokeServer(SkuId, Source, SpeedRevision)
    end

    local v19, v20, v21 = pcall(v18)
    local v22 = v19 and v20 == true

    if not v19 or type(v21) ~= "string" then
        v21 = nil
    end

    if not Ticket.Live then
        return t3
    end

    if v22 then
        return nil
    end

    PurchaseLedger.CloseTicket(p17.SkuId)

    return {
        Refusal = "Unavailable",
        Note = v21
    }
end

local function openProductPrompt(p18) -- line: 157
    -- upvalues: MarketplaceService (copy), CashPacks (copy), SpeedPacks (copy), GameFlags (copy), PurchaseLedger (copy), Remotes (copy), t3 (copy), LocalPlayer (copy)
    if CashPacks.FindSlot(p18.SkuId) == nil and SpeedPacks.FindSlot(p18.SkuId) == nil and GameFlags.ClientSidePrompts:Get() then
        local Ticket = p18.Ticket
        local PromptProductPurchase = MarketplaceService.PromptProductPurchase
        local SkuId = p18.SkuId

        if pcall(PromptProductPurchase, MarketplaceService, LocalPlayer, SkuId) or not Ticket.Live then
            return t3
        end

        PurchaseLedger.CloseTicket(p18.SkuId)

        return {
            Refusal = "Unavailable",
            Note = nil
        }
    end

    local Ticket = p18.Ticket
    local AskPurchaseOffer = Remotes.Storefront.AskPurchaseOffer
    local SkuId, Source, SpeedRevision = p18.SkuId, p18.Source, p18.SpeedRevision

    local function v23() -- line: 63
        -- upvalues: AskPurchaseOffer (copy), SkuId (copy), Source (copy), SpeedRevision (copy)
        return AskPurchaseOffer:InvokeServer(SkuId, Source, SpeedRevision)
    end

    local v24, v25, v26 = pcall(v23)
    local v27 = v24 and v25 == true

    if not v24 or type(v26) ~= "string" then
        v26 = nil
    end

    if not Ticket.Live then
        return t3
    end

    if v27 then
        return nil
    end

    PurchaseLedger.CloseTicket(p18.SkuId)

    return {
        Refusal = "Unavailable",
        Note = v26
    }
end

local function passNotOwned(p19) -- line: 169
    -- upvalues: ReplicatedStorage (copy)
    return if require(ReplicatedStorage.Client.Gamepasses).Owns(p19.Config.Name) then {
        Refusal = "Owned",
        Note = nil
    } else nil
end

local function openPassPrompt(p20) -- line: 174
    -- upvalues: MarketplaceService (copy), LocalPlayer (copy)
    MarketplaceService:PromptGamePassPurchase(LocalPlayer, p20.SkuId)

    return nil
end

local t5 = {
    storefrontOpen,
    knownSku,
    noOpenPrompt,
    oneTimeNotRepeated,
    configVeto,
    serverApproves,
    playCue,
    openProductPrompt
}
local t6 = {
    storefrontOpen,
    knownSku,
    passNotOwned,
    configVeto,
    playCue,
    openPassPrompt
}

local function run(p21, p22) -- line: 201
    -- upvalues: ReplicatedStorage (copy), t1 (copy), t2 (copy)
    for _, v28 in p21 do
        local v29 = v28(p22)

        if v29 ~= nil then
            if v29.Refusal ~= nil then
                local Refusal, Note = v29.Refusal, v29.Note
                local Message = require(ReplicatedStorage.Client.Message)
                local v30 = Note or t1[Refusal]

                if t2[Refusal] then
                    Message.Notice(v30)

                    return
                end

                Message.Warn(v30)
            end

            return
        end
    end
end

function t4.Request(p23, p24, p25) -- line: 214
    -- upvalues: Players (copy), RunService (copy), SpeedPacks (copy), Gamepasses (copy), Products (copy), t5 (copy), t6 (copy), run (copy)
    assert(RunService:IsClient(), "purchases are requested from the client")
    assert(type(p23) == "number", "PurchaseSession.Request needs a numeric SKU id")

    if p24 then
        run(t5, {
            Ticket = nil,
            Source = p25,
            SpeedRevision = if SpeedPacks.FindSlot(p23) then Players.LocalPlayer:GetAttribute(SpeedPacks.RevisionAttribute) else nil,
            SkuId = p23,
            Config = Products.FromProductId(p23)
        })
    else
        run(t6, {
            Ticket = nil,
            SkuId = p23,
            Config = Gamepasses.FromProductId(p23)
        })
    end
end

return table.freeze(t4)
