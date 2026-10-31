-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext, useEffect, useState = react.useContext, react.useEffect, react.useState
local ProductPriceContext = RuntimeLib.import(script, script.Parent.Parent, "context", "product-price-context").ProductPriceContext

return {
    useProductPrice = function(p1, p2) -- useProductPrice | line: 16
        -- upvalues: useContext (copy), useEffect (copy), useState (copy), ProductPriceContext (copy)
        local v1 = useContext(ProductPriceContext)

        if v1 == nil then
            error("[src/client/react/hooks/use-product-price.ts:17]useProductPrice must be used within a ProductPriceContext provider")
        end

        local v2 = p1 ~= nil and p1 > 0
        local v3, v4 = useState(function() -- line: 22
            -- upvalues: p1 (copy), p2 (copy), v1 (copy), v2 (copy)
            return if v2 then v1.getPrice(p1, p2) else nil
        end)

        useEffect(function() -- line: 25
            -- upvalues: p1 (copy), p2 (copy), v1 (copy), v2 (copy), v4 (copy)
            if not v2 then
                return nil
            end

            v4(v1.getPrice(p1, p2))
            v1.requestPrice(p1, p2)

            local v5 = v1.subscribe(function() -- line: 31
                -- upvalues: p1 (copy), p2 (copy), v1 (copy), v4 (copy)
                v4(v1.getPrice(p1, p2))
            end)

            return function() -- line: 34
                -- upvalues: v5 (copy)
                return v5()
            end
        end, { p1, p2, v2, v1 })

        return v3
    end
}
