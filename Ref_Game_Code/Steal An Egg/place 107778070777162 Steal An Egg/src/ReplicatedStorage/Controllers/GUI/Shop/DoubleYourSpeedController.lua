-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)

require(ReplicatedStorage.Client.Types.GUI)

local Hud = require(ReplicatedStorage.Client.Hud)
local Price = require(ReplicatedStorage.Shared.Utils.Marketplace).Price

require(ReplicatedStorage.Data.Products)

local Products = require(ReplicatedStorage.Data.Products)
local Save = require(ReplicatedStorage.Shared.Save)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    Products.Directory.SpeedBoostTier1,
    Products.Directory.SpeedBoostTier2,
    Products.Directory.SpeedBoostTier3,
    Products.Directory.SpeedBoostTier4,
    Products.Directory.SpeedBoostTier5,
    Products.Directory.SpeedBoostTier6,
    Products.Directory.SpeedBoostTier7,
    Products.Directory.SpeedBoostTier8,
    Products.Directory.SpeedBoostTier9,
    Products.Directory.SpeedBoostTier10,
    Products.Directory.SpeedBoostTier11,
    Products.Directory.SpeedBoostTier12
}
local v1 = ("ONLY ?%*"):format(Constants.ROBUX_ICON_STR)

return {
    Start = function() -- Start | line: 58
        -- upvalues: ButtonFX (copy), Constants (copy), Simple (copy), GUI (copy), Hud (copy), Price (copy), Save (copy), Storefront (copy), TreadmillUtil (copy), t (copy), t1 (copy), v1 (copy)
        local Spacer = GUI.Shop().Frame.ScrollingFrame.DoubleSpeed.Spacer
        local Treadmill = Hud.Get("SpeedMultiButton", "Treadmill")
        local t3 = {}

        for _, child in Treadmill:GetChildren() do
            if child:IsA("TextLabel") then
                table.insert(t3, child)
            end
        end

        assert(#t3 >= 2, "TradmilHud SpeedMulti needs a multiplier label and a price label")

        local v3 = t3[1]
        local v4 = t3[2]
        local t4 = {
            {
                Buy = Spacer.Buy,
                End = Spacer.NextAm,
                Start = Spacer.CurAm
            }
        }
        local n1 = 0

        local function resolveOwnedSpeedBoostTierIndex() -- line: 92
            -- upvalues: Save (copy), TreadmillUtil (copy)
            return TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await())
        end

        local function resolveNextSpeedBoostProduct() -- line: 96
            -- upvalues: Save (copy), TreadmillUtil (copy), t1 (copy)
            return t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1]
        end

        local function resolveSpeedBoostMultiplierForTierIndex(p1) -- line: 100
            -- upvalues: t1 (copy)
            local v5 = t1[p1]

            if v5 == nil then
                return 1
            end

            return v5.SpeedBoostMultiplier
        end

        local function resolveCurrentAndNextSpeedBoostMultipliers() -- line: 107
            -- upvalues: Save (copy), TreadmillUtil (copy), t1 (copy)
            local v6 = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await())
            local v7 = t1[v6]
            local v8 = if v7 == nil then 1 else v7.SpeedBoostMultiplier
            local v9 = t1[v6 + 1]

            return v8, if v9 == nil then v8 else v9.SpeedBoostMultiplier, v9 == nil
        end

        local function formatSpeedBoostMultiplier(p2) -- line: 123
            -- upvalues: Simple (copy), t (copy)
            t.strict(t.number)(p2)

            return (("x%*"):format((Simple.FormatCompact(p2, ".#"))))
        end

        local function hasProductCredit(p3) -- line: 128
            -- upvalues: Save (copy)
            if not Save.IsLoaded() then
                return false
            end

            local v10 = Save.Await()
            local ProductCredits = if v10 == nil then nil else v10.ProductCredits

            if typeof(ProductCredits) ~= "table" then
                return false
            end

            local v11 = ProductCredits[tostring(p3)]

            if typeof(v11) == "number" then
                return v11 > 0
            end

            return false
        end

        local function updateProductPrice(p4, p5) -- line: 141
            -- upvalues: Constants (copy), Price (copy), Save (copy)
            p4.Visible = true

            if p5 ~= nil then
                local ProductId = p5.ProductId

                if ProductId <= 0 then
                    p4.Text = "???"
                    p4.Visible = false
                else
                    local v12 = false

                    if Save.IsLoaded() then
                        local v13 = Save.Await()
                        local ProductCredits = if v13 == nil then nil else v13.ProductCredits

                        if typeof(ProductCredits) == "table" then
                            local v14 = ProductCredits[tostring(ProductId)]

                            if typeof(v14) == "number" then
                                v12 = v14 > 0
                            end
                        end
                    end

                    if v12 then
                        p4.Text = "FREE!"
                    else
                        task.spawn(function() -- line: 164
                            -- upvalues: p4 (copy), ProductId (copy), Constants (copy), Price (copy)
                            local v15 = Price(ProductId, Enum.InfoType.Product)

                            p4.Text = ("%*%*"):format(Constants.ROBUX_ICON_STR, if v15 == nil then "???" else tostring(v15))
                        end)
                    end
                end
            else
                p4.Text = "MAX"
                p4.Visible = false
            end
        end

        local function updateSideButtonPrice(p6) -- line: 172
            -- upvalues: v4 (copy), n1 (ref), Constants (copy), Price (copy), Save (copy), v1 (copy)
            n1 += 1

            local v17 = n1

            if p6 ~= nil then
                local ProductId = p6.ProductId
                local v18 = false

                if Save.IsLoaded() then
                    local v19 = Save.Await()
                    local ProductCredits = if v19 == nil then nil else v19.ProductCredits

                    if typeof(ProductCredits) == "table" then
                        local v20 = ProductCredits[tostring(ProductId)]

                        if typeof(v20) == "number" then
                            v18 = v20 > 0
                        end
                    end
                end

                if v18 then
                    v4.Text = "FREE!"
                else
                    v4.Text = v1
                    task.spawn(function() -- line: 187
                        -- upvalues: v17 (copy), ProductId (copy), v4 (copy), n1 (ref), Constants (copy), Price (copy), v1 (copy)
                        local v21 = Price(ProductId, Enum.InfoType.Product)

                        if v17 ~= n1 then
                            return
                        end

                        v4.Text = if v21 == nil then v1 else ("ONLY %*%*"):format(v21, Constants.ROBUX_ICON_STR)
                    end)
                end
            else
                v4.Text = "MAX"
            end
        end

        local function updateDoubleYourSpeedTool() -- line: 199
            -- upvalues: Treadmill (copy), v3 (copy), v4 (copy), n1 (ref), Constants (copy), Price (copy), Save (copy), TreadmillUtil (copy), t1 (copy), v1 (copy)
            local v23 = t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1]
            local v24 = v23 ~= nil

            Treadmill.Interactable = v24
            v4.Visible = v24

            if v23 ~= nil then
                v3.Text = TreadmillUtil.FormatSpeedMultiplier(v23.SpeedBoostMultiplier)
                n1 += 1

                local v25 = n1

                if v23 ~= nil then
                    local ProductId = v23.ProductId
                    local v26 = false

                    if Save.IsLoaded() then
                        local v27 = Save.Await()
                        local ProductCredits = if v27 == nil then nil else v27.ProductCredits

                        if typeof(ProductCredits) == "table" then
                            local v28 = ProductCredits[tostring(ProductId)]

                            if typeof(v28) == "number" then
                                v26 = v28 > 0
                            end
                        end
                    end

                    if v26 then
                        v4.Text = "FREE!"
                    else
                        v4.Text = v1
                        task.spawn(function() -- line: 187
                            -- upvalues: v25 (copy), ProductId (copy), v4 (copy), n1 (ref), Constants (copy), Price (copy), v1 (copy)
                            local v29 = Price(ProductId, Enum.InfoType.Product)

                            if v25 ~= n1 then
                                return
                            end

                            v4.Text = if v29 == nil then v1 else ("ONLY %*%*"):format(v29, Constants.ROBUX_ICON_STR)
                        end)
                    end
                else
                    v4.Text = "MAX"
                end
            else
                v3.Text = "MAX"
                n1 += 1
                v4.Text = "MAX"
            end
        end

        local function updateDoubleYourSpeedText(p7, p8, p9, p10) -- line: 217
            -- upvalues: Simple (copy), t (copy)
            local Start = p7.Start

            t.strict(t.number)(p8)
            Start.Text = ("x%*"):format((Simple.FormatCompact(p8, ".#")))

            local End = p7.End

            if p10 then
                End.Text = "MAX"
            else
                t.strict(t.number)(p9)
                End.Text = ("x%*"):format((Simple.FormatCompact(p9, ".#")))
            end
        end

        local function updateDoubleYourSpeedVisibility(p11, p12) -- line: 230
            p11.Buy.Visible = not p12
            p11.Buy.Interactable = not p12
        end

        local function updateDoubleYourSpeedPack(p13) -- line: 238
            -- upvalues: updateProductPrice (copy), Simple (copy), Save (copy), TreadmillUtil (copy), t (copy), t1 (copy)
            local v31 = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await())
            local v32 = t1[v31]
            local v33 = if v32 == nil then 1 else v32.SpeedBoostMultiplier
            local v34 = t1[v31 + 1]
            local v35 = if v34 == nil then v33 else v34.SpeedBoostMultiplier
            local v36 = v34 == nil

            p13.Buy.Visible = not v36
            p13.Buy.Interactable = not v36
            updateProductPrice(p13.Buy.Price, t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1])

            local Start = p13.Start

            t.strict(t.number)(v33)
            Start.Text = ("x%*"):format((Simple.FormatCompact(v33, ".#")))

            local End = p13.End

            if v36 then
                End.Text = "MAX"
            else
                t.strict(t.number)(v35)
                End.Text = ("x%*"):format((Simple.FormatCompact(v35, ".#")))
            end
        end

        local function bindDoubleYourSpeedButton(p14) -- line: 251
            -- upvalues: ButtonFX (copy), Save (copy), Storefront (copy), TreadmillUtil (copy), t1 (copy)
            ButtonFX(p14.Buy, nil, function() -- line: 252
                -- upvalues: Save (copy), Storefront (copy), TreadmillUtil (copy), t1 (copy)
                local v37 = t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1]

                if v37 ~= nil then
                    Storefront.Prompt(v37.ProductId, true)
                end
            end)
        end

        local function updateSpeedBoostProducts() -- line: 262
            -- upvalues: Treadmill (copy), v3 (copy), v4 (copy), t4 (copy), n1 (ref), updateProductPrice (copy), Constants (copy), Simple (copy), Price (copy), Save (copy), TreadmillUtil (copy), t (copy), t1 (copy), v1 (copy)
            for _, v38 in ipairs(t4) do
                local v39 = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await())
                local v40 = t1[v39]
                local v41 = if v40 == nil then 1 else v40.SpeedBoostMultiplier
                local v42 = t1[v39 + 1]
                local v43 = if v42 == nil then v41 else v42.SpeedBoostMultiplier
                local v44 = v42 == nil

                v38.Buy.Visible = not v44
                v38.Buy.Interactable = not v44
                updateProductPrice(v38.Buy.Price, t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1])

                local Start = v38.Start

                t.strict(t.number)(v41)
                Start.Text = ("x%*"):format((Simple.FormatCompact(v41, ".#")))

                local End = v38.End

                if v44 then
                    End.Text = "MAX"
                else
                    t.strict(t.number)(v43)
                    End.Text = ("x%*"):format((Simple.FormatCompact(v43, ".#")))
                end
            end

            local v45 = t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1]
            local v46 = v45 ~= nil

            Treadmill.Interactable = v46
            v4.Visible = v46

            if v45 ~= nil then
                v3.Text = TreadmillUtil.FormatSpeedMultiplier(v45.SpeedBoostMultiplier)
                n1 += 1

                local v47 = n1

                if v45 ~= nil then
                    local ProductId = v45.ProductId
                    local v48 = false

                    if Save.IsLoaded() then
                        local v49 = Save.Await()
                        local ProductCredits = if v49 == nil then nil else v49.ProductCredits

                        if typeof(ProductCredits) == "table" then
                            local v50 = ProductCredits[tostring(ProductId)]

                            if typeof(v50) == "number" then
                                v48 = v50 > 0
                            end
                        end
                    end

                    if v48 then
                        v4.Text = "FREE!"
                    else
                        v4.Text = v1
                        task.spawn(function() -- line: 187
                            -- upvalues: v47 (copy), ProductId (copy), v4 (copy), n1 (ref), Constants (copy), Price (copy), v1 (copy)
                            local v51 = Price(ProductId, Enum.InfoType.Product)

                            if v47 ~= n1 then
                                return
                            end

                            v4.Text = if v51 == nil then v1 else ("ONLY %*%*"):format(v51, Constants.ROBUX_ICON_STR)
                        end)
                    end
                else
                    v4.Text = "MAX"
                end
            else
                v3.Text = "MAX"
                n1 += 1
                v4.Text = "MAX"
            end
        end

        Save.Await()

        for _, v53 in ipairs(t4) do
            ButtonFX(v53.Buy, nil, function() -- line: 252
                -- upvalues: Save (copy), Storefront (copy), TreadmillUtil (copy), t1 (copy)
                local v54 = t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1]

                if v54 ~= nil then
                    Storefront.Prompt(v54.ProductId, true)
                end
            end)

            local v55 = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await())
            local v56 = t1[v55]
            local v57 = if v56 == nil then 1 else v56.SpeedBoostMultiplier
            local v58 = t1[v55 + 1]
            local v59 = if v58 == nil then v57 else v58.SpeedBoostMultiplier
            local v60 = v58 == nil

            v53.Buy.Visible = not v60
            v53.Buy.Interactable = not v60
            updateProductPrice(v53.Buy.Price, t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1])

            local Start = v53.Start

            t.strict(t.number)(v57)
            Start.Text = ("x%*"):format((Simple.FormatCompact(v57, ".#")))

            local End = v53.End

            if v60 then
                End.Text = "MAX"
            else
                t.strict(t.number)(v59)
                End.Text = ("x%*"):format((Simple.FormatCompact(v59, ".#")))
            end
        end

        ButtonFX(Treadmill, 1.08, function() -- line: 280
            -- upvalues: Save (copy), Storefront (copy), TreadmillUtil (copy), t1 (copy)
            local v61 = t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1]

            if v61 ~= nil then
                Storefront.Prompt(v61.ProductId, true)
            end
        end)

        local v62 = t1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Await()) + 1]
        local v63 = v62 ~= nil

        Treadmill.Interactable = v63
        v4.Visible = v63

        if v62 ~= nil then
            v3.Text = TreadmillUtil.FormatSpeedMultiplier(v62.SpeedBoostMultiplier)
            n1 += 1

            local v64 = n1

            if v62 ~= nil then
                local ProductId = v62.ProductId
                local v65 = false

                if Save.IsLoaded() then
                    local v66 = Save.Await()
                    local ProductCredits = if v66 == nil then nil else v66.ProductCredits

                    if typeof(ProductCredits) == "table" then
                        local v67 = ProductCredits[tostring(ProductId)]

                        if typeof(v67) == "number" then
                            v65 = v67 > 0
                        end
                    end
                end

                if v65 then
                    v4.Text = "FREE!"
                else
                    v4.Text = v1
                    task.spawn(function() -- line: 187
                        -- upvalues: v4 (copy), n1 (ref), v64 (copy), ProductId (copy), Constants (copy), Price (copy), v1 (copy)
                        local v68 = Price(ProductId, Enum.InfoType.Product)

                        if v64 ~= n1 then
                            return
                        end

                        v4.Text = if v68 == nil then v1 else ("ONLY %*%*"):format(v68, Constants.ROBUX_ICON_STR)
                    end)
                end
            else
                v4.Text = "MAX"
            end
        else
            v3.Text = "MAX"
            n1 += 1
            v4.Text = "MAX"
        end

        Save.WatchFields({ "SpeedBoostTierIndex", "ProductCredits" }, updateSpeedBoostProducts)
    end
}
