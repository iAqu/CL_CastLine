-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Products = require(ReplicatedStorage.Shared.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local LocalPlayer = Players.LocalPlayer
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local v1 = false
local t1 = {}

function t1.price(p1) -- line: 24
    -- upvalues: Products (copy), t2 (copy)
    return t2[p1] or Products.get(p1).Price
end

function t1.owns(p2) -- line: 29
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("Pass_" .. p2) == true
end

function t1.left(p3) -- line: 34
    -- upvalues: Products (copy)
    return if Products.Limited[p3] then workspace:GetAttribute("Left_" .. p3) or Products.Limited[p3] else nil
end

function t1.soldOut(p4) -- line: 41
    -- upvalues: t1 (copy)
    local v2 = t1.left(p4)

    return v2 ~= nil and v2 <= 0
end

function t1.onGranted(p5) -- line: 47
    -- upvalues: t4 (copy)
    table.insert(t4, p5)
end

function t1.onPrices(p6) -- line: 52
    -- upvalues: t5 (copy)
    table.insert(t5, p6)
end

function t1.buy(p7, p8) -- line: 57
    -- upvalues: MarketplaceService (copy), RunService (copy), Products (copy), Remotes (copy), UIUtil (copy), LocalPlayer (copy), t1 (copy), t3 (copy)
    local v3 = Products.get(p7)

    if v3 then
        if Products.isPass(p7) and t1.owns(p7) then
            UIUtil.toast("You already own this!", "info")
        elseif t1.soldOut(p7) then
            UIUtil.toast("SOLD OUT! They're all gone 😢", "info")
        else
            if p8 then
                t3[p7] = t3[p7] or {}
                table.insert(t3[p7], p8)
            end

            if v3.Id ~= 0 or RunService:IsStudio() then
                UIUtil.sound("ShopBell", 0.8)
            end

            if v3.Id == 0 then
                if RunService:IsStudio() then
                    Remotes.ShopTest:FireServer(p7)
                else
                    t3[p7] = nil
                    UIUtil.toast("Coming soon!", "info")
                end
            elseif Products.isPass(p7) then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, v3.Id)
            else
                MarketplaceService:PromptProductPurchase(LocalPlayer, v3.Id)
            end
        end
    end
end

local function keyOf(p9, p10) -- line: 91
    -- upvalues: Products (copy)
    local v6 = if p10 then Products.Passes else Products.Items

    for v7, v8 in v6 do
        if v8.Id == p9 then
            return v7
        end
    end

    return nil
end

local function loadPrices() -- line: 100
    -- upvalues: MarketplaceService (copy), Products (copy), t2 (copy), t5 (copy)
    for _, v9 in {
            {
                Products.Items,
                Enum.InfoType.Product
            },
            {
                Products.Passes,
                Enum.InfoType.GamePass
            }
        } do
        for v10, v11 in v9[1] do
            if v11.Id > 0 then
                task.spawn(function() -- line: 104
                    -- upvalues: v9 (copy), v11 (copy), v10 (copy), MarketplaceService (copy), t2 (copy), t5 (copy)
                    local GetProductInfo = MarketplaceService.GetProductInfo
                    local Id = v11.Id
                    local v12 = v9[2]
                    local ok, result = pcall(GetProductInfo, MarketplaceService, Id, v12)

                    if ok and result and type(result.PriceInRobux) == "number" then
                        t2[v10] = result.PriceInRobux

                        for _, v13 in t5 do
                            task.spawn(v13)
                        end
                    end
                end)
            end
        end
    end
end

function t1.init() -- line: 118
    -- upvalues: MarketplaceService (copy), Products (copy), Remotes (copy), LocalPlayer (copy), t3 (copy), t4 (copy), v1 (ref), loadPrices (copy)
    if v1 then
        return
    end

    v1 = true
    Remotes.Granted.OnClientEvent:Connect(function(p11) -- line: 123
        -- upvalues: t3 (copy), t4 (copy)
        local v14 = t3[p11]

        t3[p11] = nil

        for _, v15 in v14 or {} do
            task.spawn(v15)
        end

        for _, v16 in t4 do
            task.spawn(v16, p11)
        end
    end)
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p12, p13, p14) -- line: 134
        -- upvalues: Products (copy), LocalPlayer (copy), t3 (copy)
        local v17

        if p12 == LocalPlayer.UserId then
            local v18 = not p14

            if v18 then
                local v19 = false

                for v20, v21 in Products.Items do
                    if v21.Id == p13 then
                        v17 = v20
                        v19 = true
                        break
                    end
                end

                if not v19 then
                    v17 = nil
                end
            else
                v17 = v18
            end
        else
            v17 = false
        end

        if v17 then
            t3[v17] = nil
        end
    end)
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p15, p16, p17) -- line: 140
        -- upvalues: Products (copy), LocalPlayer (copy), t4 (copy)
        local v22

        if p15 == LocalPlayer then
            local v23 = false

            for v24, v25 in Products.Passes do
                if v25.Id == p16 then
                    v22 = v24
                    v23 = true
                    break
                end
            end

            if not v23 then
                v22 = nil
            end
        else
            v22 = false
        end

        if v22 and p17 then
            for _, v26 in t4 do
                task.spawn(v26, v22)
            end
        end
    end)
    loadPrices()
end

return t1
