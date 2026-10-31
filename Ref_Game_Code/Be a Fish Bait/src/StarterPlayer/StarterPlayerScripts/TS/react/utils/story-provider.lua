-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local v1 = RuntimeLib.import(script, script.Parent.Parent, "context", "theme-context")
local defaultTheme, ThemeContext = v1.defaultTheme, v1.ThemeContext
local v2 = RuntimeLib.import(script, script.Parent.Parent, "context", "config-context")
local ConfigProvider, initialConfig = v2.ConfigProvider, v2.initialConfig
local combineProducers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").combineProducers
local clientSlices = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "producer").clientSlices
local ReflexProvider = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-reflex").ReflexProvider
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "transition", "transition").default
local ProductPriceContext = RuntimeLib.import(script, script.Parent.Parent, "context", "product-price-context").ProductPriceContext
local t1 = {
    getPrice = function() -- getPrice | line: 16
        return nil
    end,
    requestPrice = function() -- requestPrice | line: 19
    end,
    subscribe = function() -- subscribe | line: 20
        return function() -- line: 21
        end
    end
}

return {
    default = function(p1) -- StoryProvider | line: 24
        -- upvalues: react (copy), defaultTheme (copy), ThemeContext (copy), ConfigProvider (copy), initialConfig (copy), combineProducers (copy), clientSlices (copy), ReflexProvider (copy), default (copy), ProductPriceContext (copy), t1 (copy)
        local v3 = combineProducers(clientSlices)

        return react.createElement(ThemeContext.Provider, {
            value = defaultTheme
        }, react.createElement(ConfigProvider, {
            configValue = initialConfig
        }, react.createElement(ProductPriceContext.Provider, {
            value = t1
        }, react.createElement(ReflexProvider, {
            initialState = p1.initialState,
            producer = v3
        }, react.createElement(default, {
            ["in"] = true
        }, p1.children)))))
    end
}
