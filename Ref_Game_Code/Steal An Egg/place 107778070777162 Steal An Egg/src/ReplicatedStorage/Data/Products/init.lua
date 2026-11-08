-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CashPacks = require(ReplicatedStorage.Data.CashPacks)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local EggProducts = require(ReplicatedStorage.Shared.Flags.GameplayBalance).EggProducts
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local GeneratedProducts = require(script.Internal.GeneratedProducts)
local LimitedEgg = require(ReplicatedStorage.Data.LimitedEgg)
local HalloweenEggSettings = require(ReplicatedStorage.Data.HalloweenEggSettings)
local MarketplaceValidator = require(script.Internal.MarketplaceValidator)

require(script.Internal.ProductTypes)

local RaceRally = require(ReplicatedStorage.Data.RaceRally)
local Sakura = require(ReplicatedStorage.Data.Sakura)
local StarBundles = require(ReplicatedStorage.Data.StarBundles)
local t = require(ReplicatedStorage.Packages.t)
local BillboardReward = require(script.Builders.BillboardReward)
local TreadmillAdEggBoost = require(script.Builders.TreadmillAdEggBoost)
local CashPack = require(script.Builders.CashPack)
local EggSkipGrowth = require(script.Builders.EggSkipGrowth)
local LimitedEgg2 = require(script.Builders.LimitedEgg)
local Money = require(script.Builders.Money)
local RiftRefresh = require(script.Builders.RiftRefresh)
local SamplePack = require(script.Builders.SamplePack)
local SamplePacks = require(ReplicatedStorage.Data.SamplePacks)
local ServerLuck = require(script.Builders.ServerLuck)
local ServerLuckExtension = require(script.Builders.ServerLuckExtension)
local SpeedBoost = require(script.Builders.SpeedBoost)
local SpeedPower = require(script.Builders.SpeedPower)
local TemporarySpeedBoost = require(script.Builders.TemporarySpeedBoost)
local t1 = {}
local t2 = {}

local function enlist(p1) -- line: 57
    -- upvalues: t (copy), t1 (copy), t2 (copy)
    local Name = p1.Name

    t.strict(t.string)(Name)
    t.strict(t.number)(p1.ProductId)

    if t1[Name] ~= nil then
        error((("product \"%*\" is listed twice"):format(Name)))
    end

    local v1 = t2[p1.ProductId]

    if v1 ~= nil then
        error((("\"%*\" reuses ProductId %* of \"%*\""):format(Name, p1.ProductId, v1.Name)))
    end

    t1[Name] = p1
    t2[p1.ProductId] = p1
end

local function requirePlayer(p2) -- line: 74
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Player"))(p2)
end

local function clientProfileLoaded() -- line: 78
    -- upvalues: ReplicatedStorage (copy)
    if require(ReplicatedStorage.Shared.Save).Await() == nil then
        return false, "Data not loaded"
    end

    return true
end

local function creditWhenLoaded(p3, _, _) -- line: 86
    -- upvalues: ServerScriptService (copy)
    if require(ServerScriptService.Library.Database).IsPlayerLoaded(p3) then
        return "Credit"
    end

    return "Retry"
end

local function retiredDnaProduct(p6, p7) -- line: 93
    local function refuse() -- line: 94
        return false, "DNA stealing is no longer available."
    end

    return {
        Desc = "DNA stealing is no longer available.",
        Silent = true,
        Name = p6,
        ProductId = p7,
        DisplayName = p6,
        Precheck = refuse,
        Authorize = refuse,
        Grant = refuse
    }
end

local function growAllEggsProduct(p8) -- line: 110
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), t (copy), creditWhenLoaded (copy)
    local function eggs() -- line: 111
        -- upvalues: ServerScriptService (copy)
        return require(ServerScriptService.Controllers.Eggs)
    end

    return {
        DisplayName = "Grow All Eggs",
        Desc = "Finish growing all placed eggs.",
        ProductId = 3611613592,
        HoldWhilePending = true,
        Silent = true,
        Name = p8,
        Grant = function(p9) -- Grant | line: 122
            -- upvalues: ServerScriptService (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p9)

            return require(ServerScriptService.Controllers.Eggs).PurchaseGrowAll(p9)
        end,
        Precheck = function() -- Precheck | line: 126
            -- upvalues: ReplicatedStorage (copy)
            return require(ReplicatedStorage.Client.EggState).MayBuyGrowAll()
        end,
        Authorize = function(p10) -- Authorize | line: 130
            -- upvalues: ServerScriptService (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p10)

            return require(ServerScriptService.Controllers.Eggs).CanPurchaseGrowAll(p10)
        end,
        ResolveFailedReceipt = creditWhenLoaded
    }
end

local function earningsBoostProduct(p11) -- line: 138
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), t (copy), clientProfileLoaded (copy), creditWhenLoaded (copy)
    local PlayerEarningsBoost = require(ReplicatedStorage.Shared.Util.PlayerEarningsBoost)
    local v2 = PlayerEarningsBoost.GetConfiguredMultiplier()
    local v3 = PlayerEarningsBoost.DURATION_SECONDS / 60

    local function boostService() -- line: 143
        -- upvalues: ServerScriptService (copy)
        return require(ServerScriptService.Controllers.EarningsBoostService)
    end

    return {
        ProductId = 3709963353,
        HoldWhilePending = true,
        Name = p11,
        DisplayName = ("x%* Earnings (%*m)"):format(v2, v3),
        Desc = ("Your pets earn %*x cash for %* minutes."):format(v2, v3),
        Grant = function(p12) -- Grant | line: 153
            -- upvalues: ServerScriptService (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p12)

            return require(ServerScriptService.Controllers.EarningsBoostService).Activate(p12)
        end,
        Precheck = clientProfileLoaded,
        Authorize = function(p13) -- Authorize | line: 158
            -- upvalues: ServerScriptService (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p13)

            return require(ServerScriptService.Controllers.EarningsBoostService).CanActivate(p13)
        end,
        ResolveFailedReceipt = creditWhenLoaded
    }
end

local function sakuraLuckBoostProduct(p14, p15, p16) -- line: 166
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), GameFlags (copy), Sakura (copy), t (copy)
    local function bloomActive() -- line: 167
        -- upvalues: GameFlags (copy)
        return GameFlags.GreatBloomEnabled:Get() == true
    end

    local function sakuraService() -- line: 171
        -- upvalues: ServerScriptService (copy)
        return require(ServerScriptService.Controllers.SakuraService)
    end

    return {
        HoldWhilePending = true,
        Name = p14,
        DisplayName = ("Sakura Luck Boost %*"):format(p16),
        Desc = ("%*x Great Bloom odds for the egg inside the incubator (%*/%*)."):format(Sakura.GetLuckMultiplier(p16), p16, Sakura.Incubator.MaxLuckBoosts),
        ProductId = p15,
        Grant = function(p17) -- Grant | line: 181
            -- upvalues: p16 (copy), ServerScriptService (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p17)

            return require(ServerScriptService.Controllers.SakuraService).ActivateLuckBoost(p17, p16)
        end,
        Precheck = function() -- Precheck | line: 185
            -- upvalues: p16 (copy), ReplicatedStorage (copy), GameFlags (copy), Sakura (copy)
            if GameFlags.GreatBloomEnabled:Get() ~= true then
                return false, "The Great Bloom has ended"
            end

            local v4 = require(ReplicatedStorage.Shared.Save).Await()

            if v4 == nil then
                return false, "Data not loaded"
            end

            return Sakura.CanBuyLuckBoost(v4.Sakura, p16)
        end,
        Authorize = function(p18) -- Authorize | line: 196
            -- upvalues: p16 (copy), ServerScriptService (copy), GameFlags (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p18)

            if GameFlags.GreatBloomEnabled:Get() == true then
                return require(ServerScriptService.Controllers.SakuraService).CanActivateLuckBoost(p18, p16)
            end

            return false, "The Great Bloom has ended"
        end,
        ResolveFailedReceipt = function(p19, _, p21) -- ResolveFailedReceipt | line: 203
            -- upvalues: p15 (copy), ServerScriptService (copy), GameFlags (copy)
            if GameFlags.GreatBloomEnabled:Get() == true then
                if require(ServerScriptService.Library.Database).IsPlayerLoaded(p19) then
                    return "Credit"
                end

                return "Retry"
            end

            require(ServerScriptService.UserGenerated.Analytics):LogPlayerEvent(p19, "PlayerRetiredProductReceipt", {
                ProductId = p15,
                Reason = p21 or "Unknown"
            })

            return "Satisfied"
        end
    }
end

local function starBundleProduct(p22, p23, p24) -- line: 221
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), StarBundles (copy), t (copy), creditWhenLoaded (copy)
    local function starService() -- line: 222
        -- upvalues: ServerScriptService (copy)
        return require(ServerScriptService.Controllers.ShootingStarService)
    end

    return {
        HoldWhilePending = true,
        Silent = true,
        Giftable = false,
        Name = p22,
        DisplayName = if p24 == 1 then "1 Star" else ("%* Stars"):format(p24),
        Desc = ("Get %* Star%* from the Star Handler!"):format(p24, p24 == 1 and "" or "s"),
        ProductId = p23,
        Grant = function(p25, p26) -- Grant | line: 234
            -- upvalues: p24 (copy), ServerScriptService (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p25)

            local v5 = require(ServerScriptService.Controllers.ShootingStarService).GrantPurchased(p25, p24, p26)
            local v6 = v5 == true

            if v5 then
                return v6, nil
            end

            return v6, "Star grant failed"
        end,
        Precheck = function() -- Precheck | line: 239
            -- upvalues: p24 (copy), ReplicatedStorage (copy), StarBundles (copy)
            local v7 = require(ReplicatedStorage.Shared.Save).Await()

            if v7 == nil then
                return false, "Data not loaded"
            end

            local v8 = StarBundles.StockRefusal(v7.MountStarStock, p24, workspace:GetServerTimeNow())

            return v8 == nil, v8
        end,
        Authorize = function(p27, p28) -- Authorize | line: 252
            -- upvalues: p24 (copy), ServerScriptService (copy), StarBundles (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p27)

            local Database = require(ServerScriptService.Library.Database)

            if Database.IsPlayerLoaded(p27) then
                if p28 ~= nil then
                    return true
                end

                local UnsafeGetProfileAsync = Database.UnsafeGetProfileAsync
                local ok, result = pcall(UnsafeGetProfileAsync, p27)

                if ok and typeof(result) == "table" then
                    local v9 = StarBundles.StockRefusal(result.MountStarStock, p24, workspace:GetServerTimeNow())

                    return v9 == nil, v9
                end
            end

            return false, "Data not loaded"
        end,
        ResolveFailedReceipt = creditWhenLoaded
    }
end

enlist((growAllEggsProduct("EggGrowAll")))
enlist((earningsBoostProduct("EarningsBoost2x")))
enlist(RiftRefresh("RiftRefresh", 3710888247))

for v10, v11 in SamplePacks.Offers do
    enlist(SamplePack(("SamplePack%*"):format(v10), v11.ProductId))
end

for v12, v13 in {
        {
            ProductId = 3611606887,
            Minutes = 15
        },
        {
            ProductId = 3611606895,
            Minutes = 30
        },
        {
            ProductId = 3611606898,
            Minutes = 60
        },
        {
            ProductId = 3611606901,
            Minutes = 120
        },
        {
            ProductId = 3611606906,
            Minutes = 180
        },
        {
            ProductId = 3611606912,
            Minutes = 240
        },
        {
            ProductId = 3611606918,
            Minutes = 360
        },
        {
            ProductId = 3611606926,
            Minutes = 480
        },
        {
            ProductId = 3611606930,
            Minutes = 600
        },
        {
            ProductId = 3611606938,
            Minutes = 720
        }
    } do
    enlist(EggSkipGrowth(("Instant Hatch (%*)"):format(v12), v13.ProductId, v13.Minutes * 60))
end

for _, v14 in {
        {
            Name = "Limited Egg",
            Count = 1,
            ProductId = 3712476038,
            Config = LimitedEgg.Luminous
        },
        {
            Name = "Limited Egg x3",
            Count = 3,
            ProductId = 3712476039,
            Config = LimitedEgg.Luminous
        },
        {
            Name = "Limited Egg x10",
            Count = 10,
            ProductId = 3712476044,
            Config = LimitedEgg.Luminous
        },
        {
            Name = "Limited Egg x50",
            Count = 50,
            ProductId = 3712476050,
            Config = LimitedEgg.Luminous
        },
        {
            Name = "Extinction Egg",
            Count = 1,
            ProductId = 3714749344,
            Config = LimitedEgg.Extinction
        },
        {
            Name = "Extinction Egg x3",
            Count = 3,
            ProductId = 3714749375,
            Config = LimitedEgg.Extinction
        },
        {
            Name = "Extinction Egg x10",
            Count = 10,
            ProductId = 3714749397,
            Config = LimitedEgg.Extinction
        },
        {
            Name = "Extinction Egg x50",
            Count = 50,
            ProductId = 3714749414,
            Config = LimitedEgg.Extinction
        }
    } do
    enlist(LimitedEgg2(v14.Name, v14.ProductId, v14.Count, v14.Config))
end

for _, v15 in {
        {
            Key = "Single",
            Count = 1
        },
        {
            Key = "Triple",
            Count = 3
        },
        {
            Key = "Ten",
            Count = 10
        },
        {
            Key = "Fifty",
            Count = 50
        }
    } do
    local v16 = HalloweenEggSettings.ProductIds[v15.Key]

    if v16 > 0 then
        enlist(LimitedEgg2(if v15.Count == 1 then "Halloween Egg" else ("Halloween Egg x%*"):format(v15.Count), v16, v15.Count, LimitedEgg.Halloween))
    end

    local v17 = HalloweenEggSettings.GiftProductIds[v15.Key]

    if v17 > 0 then
        enlist(LimitedEgg2(if v15.Count == 1 then "Halloween Egg Gift" else ("Halloween Egg Gift x%*"):format(v15.Count), v17, v15.Count, LimitedEgg.Halloween))
    end
end

for _, v18 in {
        {
            Amount = 24000,
            ProductId = 3611606487
        },
        {
            Amount = 2E+05,
            ProductId = 3611606470
        },
        {
            Amount = 8E+05,
            ProductId = 3611606501
        },
        {
            Amount = 4E+06,
            ProductId = 3611606493
        },
        {
            Amount = 8E+06,
            ProductId = 3611606507
        }
    } do
    enlist(Money(("Money_%*"):format(v18.Amount), v18.ProductId))
end

for _, v19 in CashPacks.Offers do
    enlist(CashPack(v19.Name, v19.ProductId))
end

for v20, v21 in { 3709207454, 3709207509, 3709207563 } do
    enlist((sakuraLuckBoostProduct(("SakuraLuckBoost%*"):format(v20), v21, v20)))
end

for _, v22 in {
        {
            Multiplier = 2,
            ProductId = 3604958187
        },
        {
            Multiplier = 4,
            ProductId = 3604958083
        },
        {
            Multiplier = 8,
            ProductId = 3604957992
        }
    } do
    enlist(ServerLuck(("ServerLuck_X%*"):format(v22.Multiplier), v22.ProductId, v22.Multiplier))
end

for _, v23 in {
        {
            Minutes = 15,
            ProductId = 3604958348
        },
        {
            Minutes = 30,
            ProductId = 3604958272
        }
    } do
    enlist(ServerLuckExtension(("ServerLuck_Extend%*"):format(v23.Minutes), v23.ProductId, v23.Minutes))
end

local function doubleTrophiesProduct(p29, p30) -- line: 388
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), RaceRally (copy), t (copy)
    local v24 = tostring(p30)

    local function database() -- line: 391
        -- upvalues: ServerScriptService (copy)
        return require(ServerScriptService.Library.Database)
    end

    local function owned(p31) -- line: 395
        -- upvalues: v24 (copy), ServerScriptService (copy)
        local Database = require(ServerScriptService.Library.Database)

        if Database.IsPlayerLoaded(p31) then
            local v25, v26 = Database.UnsafeGetProfileAwait(p31)

            if v25 and type(v26) == "table" then
                if type(v26.Products) == "table" then
                    return v26.Products[v24] == true
                end

                return false
            end
        end

        return nil
    end

    return {
        DisplayName = "2x Trophies",
        Desc = "Earn double Trophies from every race. Forever!",
        OneTime = true,
        HoldWhilePending = true,
        Giftable = false,
        Name = p29,
        ProductId = p30,
        Icon = RaceRally.DoubleTrophies.Icon,
        Precheck = function() -- Precheck | line: 416
            -- upvalues: v24 (copy), ReplicatedStorage (copy)
            local v27 = require(ReplicatedStorage.Shared.Save).Await()

            if v27 == nil then
                return false, "Data not loaded"
            end

            if type(v27.Products) ~= "table" or v27.Products[v24] ~= true then
                return true
            end

            return false, "You already own 2x Trophies!"
        end,
        Authorize = function(p32, p33) -- Authorize | line: 427
            -- upvalues: owned (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p32)

            local v28 = owned(p32)

            if v28 == nil then
                return false, "Data not loaded"
            end

            if not v28 or p33 ~= nil then
                return true
            end

            return false, "You already own 2x Trophies!"
        end,
        Grant = function(p34) -- Grant | line: 438
            -- upvalues: v24 (copy), ServerScriptService (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p34)

            local v29, v30 = require(ServerScriptService.Library.Database).UpdateProfileImmutable(p34, function(p35) -- line: 441
                -- upvalues: v24 (copy)
                local v31 = table.clone(p35)
                local v32 = table.clone(p35.Products or {})

                v32[v24] = true
                v31.Products = v32

                return v31
            end):await()

            if not v29 or v30 ~= true then
                return false, "Couldn't save 2x Trophies"
            end

            return true
        end,
        ResolveFailedReceipt = function(p36) -- ResolveFailedReceipt | line: 454
            -- upvalues: owned (copy)
            if owned(p36) == true then
                return "Satisfied"
            end

            return "Retry"
        end
    }
end

enlist((doubleTrophiesProduct(RaceRally.DoubleTrophies.Key, RaceRally.DoubleTrophies.ProductId)))
enlist((doubleTrophiesProduct(("%*_DEV"):format(RaceRally.DoubleTrophies.Key), RaceRally.DoubleTrophies.DevProductId)))

for _, v33 in StarBundles.Bundles do
    enlist((starBundleProduct(v33.Key, v33.ProductId, v33.Count)))
    enlist((starBundleProduct(("%*_DEV"):format(v33.Key), v33.DevProductId, v33.Count)))
end

for v34, v35 in {
        3611606570, 3611606611, 3611606618, 3611606628, 3611606636, 3611606645, 3611606648, 3611606653,
        3611606661, 3611606588, 3611606597, 3611606604
    } do
    enlist(SpeedBoost(("SpeedBoostTier%*"):format(v34), v35, v34, 2 ^ v34))
end

for _, v36 in {
        {
            Amount = 150000,
            ProductId = 3611606545
        },
        {
            Amount = 1E+06,
            ProductId = 3611606516
        },
        {
            Amount = 1E+07,
            ProductId = 3611606528
        },
        {
            Amount = 5E+07,
            ProductId = 3611606552
        },
        {
            Amount = 5E+08,
            ProductId = 3611606562
        },
        {
            Amount = 1E+09,
            ProductId = 3611606539
        }
    } do
    enlist(SpeedPower(("SpeedPower_%*"):format(v36.Amount), v36.ProductId))
end

for _, v37 in {
        {
            Rarity = "Common",
            ProductId = 3611606824
        },
        {
            Rarity = "Uncommon",
            ProductId = 3611606832
        },
        {
            Rarity = "Rare",
            ProductId = 3611606840
        },
        {
            Rarity = "Epic",
            ProductId = 3611606843
        },
        {
            Rarity = "Legendary",
            ProductId = 3611606849
        },
        {
            Rarity = "Mythic",
            ProductId = 3611606854
        },
        {
            Rarity = "Cosmic",
            ProductId = 3611606859
        },
        {
            Rarity = "Secret",
            ProductId = 3611606864
        },
        {
            Rarity = "Eternal",
            ProductId = 3611606875
        },
        {
            Rarity = "Divine",
            ProductId = 3611606880
        }
    } do
    enlist((retiredDnaProduct(("Steal%*"):format(v37.Rarity), v37.ProductId)))
end

for _, v38 in {
        {
            Label = "10Minutes",
            Seconds = 600,
            ProductId = 3608561503
        },
        {
            Label = "30Minutes",
            Seconds = 1800,
            ProductId = 3608561464
        },
        {
            Label = "1Hour",
            Seconds = 3600,
            ProductId = 3608561433
        }
    } do
    enlist(TemporarySpeedBoost(("TemporarySpeedBoost_%*"):format(v38.Label), v38.ProductId, v38.Seconds))
end

for _, v39 in {
        {
            Variant = "Alt1",
            Control = 3711307995,
            Double = 3711308134,
            Quadruple = 3711308259
        },
        {
            Variant = "Alt2",
            Control = 3711039542,
            Double = 3711036110,
            Quadruple = 3711036196
        },
        {
            Variant = "Default",
            Control = 3711313393,
            Double = 3711313465,
            Quadruple = 3711313519
        }
    } do
    for v40, v41 in {
            Control = v39.Control,
            ["2x"] = v39.Double,
            ["4x"] = v39.Quadruple
        } do
        enlist(BillboardReward(("RVBillboard_%*_%*"):format(v39.Variant, v40), v41))
    end
end

for _, v42 in {
        {
            Name = "TreadmillAdEggBoost",
            ProductId = 3714369091
        },
        {
            Name = "TreadmillAdEggBoost_DEV",
            ProductId = 3714368905
        },
        {
            Name = "TreadmillAdEggBoost_DEV2",
            ProductId = 3590880144
        }
    } do
    enlist(TreadmillAdEggBoost(v42.Name, v42.ProductId))
end

for _, v43 in GeneratedProducts.Records do
    enlist(v43)
end

if Constants.IS_STUDIO then
    local t6 = {}

    for v44 in t1 do
        table.insert(t6, v44)
    end

    table.sort(t6)
    task.spawn(function() -- line: 585
        -- upvalues: MarketplaceValidator (copy), t1 (copy), t6 (copy)
        for _, v45 in t6 do
            MarketplaceValidator.Validate(v45, t1[v45])
        end
    end)
end

table.freeze(t1)
table.freeze(t2)

local function ladder(p37) -- line: 597
    -- upvalues: t1 (copy)
    local t7 = {}

    for _, v46 in t1 do
        if p37(v46) ~= nil then
            table.insert(t7, v46)
        end
    end

    table.sort(t7, function(p38, p39) -- line: 604
        -- upvalues: p37 (copy)
        return p37(p38) < p37(p39)
    end)

    return table.freeze(t7)
end

local v47 = ladder(function(p40) -- line: 610
    return p40.EggSkipGrowthMaxRemainingSeconds
end)
local v48 = ladder(function(p41) -- line: 613
    return p41.SpeedPowerReward
end)
local t8 = {
    Directory = t1,
    TreadmillSpeedEquivalentOffers = GeneratedProducts.TreadmillSpeedEquivalentOffers
}

function t8.FromProductId(p42) -- line: 622
    -- upvalues: t2 (copy)
    return t2[p42]
end

function t8.ProductNameExists(p43) -- line: 626
    -- upvalues: t1 (copy)
    if rawget(t1, p43) == nil then
        return false, (("no product is registered under \"%*\""):format(p43))
    end

    return true
end

function t8.GetEggSkipGrowthProduct(p44) -- line: 633
    -- upvalues: EggProducts (copy), v47 (copy)
    assert(p44 >= 0, "remaining seconds cannot be negative")

    if p44 <= EggProducts.MIN_SKIP_SECONDS then
        return nil
    end

    for _, v50 in v47 do
        if p44 <= v50.EggSkipGrowthMaxRemainingSeconds then
            return v50
        end
    end

    return assert(v47[#v47], "no egg skip-growth product is registered")
end

function t8.SmallestSufficientSpeedPowerProduct(p45) -- line: 646
    -- upvalues: t (copy), v48 (copy)
    t.strict(t.numberPositive)(p45)

    for _, v52 in v48 do
        if p45 <= v52.SpeedPowerReward then
            return v52
        end
    end

    return (assert(v48[#v48], "no speed-power product is registered"))
end

return t8
