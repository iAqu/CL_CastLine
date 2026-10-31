-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MonetizationConfig = require(ReplicatedStorage.Config.MonetizationConfig)
local t1 = {
    Changed = require(ReplicatedStorage.Shared.Signal).new()
}
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local n1 = (-1e999)

local function v1() -- line: 53
    -- upvalues: MarketplaceService (copy)
    return MarketplaceService.GetProductInfoAsync
end

local ok, result = pcall(v1)

if not ok or not result then
    result = MarketplaceService.GetProductInfo
end

local function remember(p1, p2) -- line: 57
    -- upvalues: t5 (copy), t6 (copy)
    if not t5[p1] then
        t5[p1] = p2
        table.insert(t6, p1)
    end
end

local function request(p3, p4, p5) -- line: 64
    -- upvalues: MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), result (ref)
    if not t5[p3] then
        t5[p3] = p4
        table.insert(t6, p3)
    end

    if t4[p3] or t2[p3] and not p5 then
        return
    end

    t4[p3] = true
    task.spawn(function() -- line: 68
        -- upvalues: p3 (copy), p4 (copy), p5 (copy), MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), result (ref)
        for i = 1, 3 do
            local ok, result2 = pcall(result, MarketplaceService, p3, p4)

            if ok and result2 and result2.PriceInRobux then
                t4[p3] = nil

                local v2 = tonumber(result2.UserBasePriceInRobux) or result2.PriceInRobux

                if t2[p3] ~= result2.PriceInRobux or t3[p3] ~= v2 then
                    t2[p3] = result2.PriceInRobux
                    t3[p3] = v2
                    t1.Changed:Fire(p3, result2.PriceInRobux)
                end

                return
            end

            if p5 and t2[p3] then
                break
            end

            task.wait(i * 2)
        end

        t4[p3] = nil
    end)
end

function t1.Get(p6, p7, p8) -- line: 88
    -- upvalues: MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), result (ref)
    local v3 = p7 or Enum.InfoType.Product

    if t2[p6] then
        if not t5[p6] then
            t5[p6] = v3
            table.insert(t6, p6)
        end

        return t2[p6]
    end

    if not t5[p6] then
        t5[p6] = v3
        table.insert(t6, p6)
    end

    if not t4[p6] then
        if t2[p6] then
            return p8
        end

        t4[p6] = true

        local spawn = task.spawn
        local v4

        spawn(function() -- line: 68
            -- upvalues: p6 (copy), v3 (copy), v4 (copy), MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), result (ref)
            for i = 1, 3 do
                local ok, result2 = pcall(result, MarketplaceService, p6, v3)

                if ok and result2 and result2.PriceInRobux then
                    t4[p6] = nil

                    local v5 = tonumber(result2.UserBasePriceInRobux) or result2.PriceInRobux

                    if t2[p6] ~= result2.PriceInRobux or t3[p6] ~= v5 then
                        t2[p6] = result2.PriceInRobux
                        t3[p6] = v5
                        t1.Changed:Fire(p6, result2.PriceInRobux)
                    end

                    return
                end

                if v4 and t2[p6] then
                    break
                end

                task.wait(i * 2)
            end

            t4[p6] = nil
        end)
    end

    return p8
end

function t1.GetBase(p9, p10, p11) -- line: 98
    -- upvalues: t1 (copy), t3 (copy)
    if t3[p9] then
        return t3[p9]
    end

    t1.Get(p9, p10, p11)

    return p11
end

function t1.IsLoaded(p12) -- line: 104
    -- upvalues: t2 (copy)
    return t2[p12] ~= nil
end

function t1.RefreshNow() -- line: 109
    -- upvalues: MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), n1 (ref), result (ref)
    if os.clock() - n1 < 30 then
        return
    end

    n1 = os.clock()

    for _, v6 in ipairs(t6) do
        local v7 = t5[v6]

        if not t5[v6] then
            t5[v6] = v7
            table.insert(t6, v6)
        end

        if not t4[v6] then
            if t2[v6] then
            end

            t4[v6] = true

            local spawn = task.spawn
            local v8 = true

            spawn(function() -- line: 68
                -- upvalues: v6 (copy), v7 (copy), v8 (copy), MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), result (ref)
                for i = 1, 3 do
                    local ok, result2 = pcall(result, MarketplaceService, v6, v7)

                    if ok and result2 and result2.PriceInRobux then
                        t4[v6] = nil

                        local v9 = tonumber(result2.UserBasePriceInRobux) or result2.PriceInRobux

                        if t2[v6] ~= result2.PriceInRobux or t3[v6] ~= v9 then
                            t2[v6] = result2.PriceInRobux
                            t3[v6] = v9
                            t1.Changed:Fire(v6, result2.PriceInRobux)
                        end

                        return
                    end

                    if v8 and t2[v6] then
                        break
                    end

                    task.wait(i * 2)
                end

                t4[v6] = nil
            end)
        end
    end
end

function t1.Init() -- line: 117
    -- upvalues: MarketplaceService (copy), MonetizationConfig (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), n1 (ref), result (ref)
    for _, v10 in pairs(MonetizationConfig.Products) do
        local Id = v10.Id
        local Product = Enum.InfoType.Product

        if not t5[Id] then
            t5[Id] = Product
            table.insert(t6, Id)
        end

        if not t4[Id] and not t2[Id] then
            t4[Id] = true

            local spawn = task.spawn
            local v11

            spawn(function() -- line: 68
                -- upvalues: Id (copy), Product (copy), v11 (copy), MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), result (ref)
                for i = 1, 3 do
                    local ok, result2 = pcall(result, MarketplaceService, Id, Product)

                    if ok and result2 and result2.PriceInRobux then
                        t4[Id] = nil

                        local v12 = tonumber(result2.UserBasePriceInRobux) or result2.PriceInRobux

                        if t2[Id] ~= result2.PriceInRobux or t3[Id] ~= v12 then
                            t2[Id] = result2.PriceInRobux
                            t3[Id] = v12
                            t1.Changed:Fire(Id, result2.PriceInRobux)
                        end

                        return
                    end

                    if v11 and t2[Id] then
                        break
                    end

                    task.wait(i * 2)
                end

                t4[Id] = nil
            end)
        end
    end

    for _, v13 in pairs(MonetizationConfig.Passes) do
        local Id = v13.Id
        local GamePass = Enum.InfoType.GamePass

        if not t5[Id] then
            t5[Id] = GamePass
            table.insert(t6, Id)
        end

        if not t4[Id] and not t2[Id] then
            t4[Id] = true

            local spawn = task.spawn
            local v14

            spawn(function() -- line: 68
                -- upvalues: Id (copy), GamePass (copy), v14 (copy), MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), result (ref)
                for i = 1, 3 do
                    local ok, result2 = pcall(result, MarketplaceService, Id, GamePass)

                    if ok and result2 and result2.PriceInRobux then
                        t4[Id] = nil

                        local v15 = tonumber(result2.UserBasePriceInRobux) or result2.PriceInRobux

                        if t2[Id] ~= result2.PriceInRobux or t3[Id] ~= v15 then
                            t2[Id] = result2.PriceInRobux
                            t3[Id] = v15
                            t1.Changed:Fire(Id, result2.PriceInRobux)
                        end

                        return
                    end

                    if v14 and t2[Id] then
                        break
                    end

                    task.wait(i * 2)
                end

                t4[Id] = nil
            end)
        end
    end

    n1 = os.clock()
    task.spawn(function() -- line: 126
        -- upvalues: MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), result (ref)
        while true do
            if #t6 == 0 then
                task.wait(60)
            else
                local v17 = math.max(0.5, 60 / #t6)

                for i = 1, #t6 do
                    task.wait(v17)

                    local v18 = t6[i]

                    if v18 then
                        local v19 = t5[v18]

                        if not t5[v18] then
                            t5[v18] = v19
                            table.insert(t6, v18)
                        end

                        if not t4[v18] then
                            if t2[v18] then
                            end

                            t4[v18] = true

                            local spawn = task.spawn
                            local v20 = true

                            spawn(function() -- line: 68
                                -- upvalues: v18 (copy), v19 (copy), v20 (copy), MarketplaceService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), result (ref)
                                for i = 1, 3 do
                                    local ok, result2 = pcall(result, MarketplaceService, v18, v19)

                                    if ok and result2 and result2.PriceInRobux then
                                        t4[v18] = nil

                                        local v21 = tonumber(result2.UserBasePriceInRobux) or result2.PriceInRobux

                                        if t2[v18] ~= result2.PriceInRobux or t3[v18] ~= v21 then
                                            t2[v18] = result2.PriceInRobux
                                            t3[v18] = v21
                                            t1.Changed:Fire(v18, result2.PriceInRobux)
                                        end

                                        return
                                    end

                                    if v20 and t2[v18] then
                                        break
                                    end

                                    task.wait(i * 2)
                                end

                                t4[v18] = nil
                            end)
                        end
                    end
                end
            end
        end
    end)
end

return t1
