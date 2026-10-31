-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local Component, ReactComponent = react.Component, react.ReactComponent
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 10
        return "ErrorBoundary"
    end,
    __index = Component
})
local v2 = self

self.__index = self

local function new(...) -- line: 16
    -- upvalues: v2 (ref)
    local self = setmetatable({}, v2)

    return self:constructor(...) or self
end

local v5 = v2

v5.new = new

function v5.constructor(p1, ...) -- line: 20
    -- upvalues: Component (copy)
    Component.constructor(p1, ...)
    p1.state = {
        hasError = false
    }
end

function v5.componentDidCatch(p2, p3, p4) -- line: 26
    warn(p3, p4.componentStack)
    p2:setState({
        hasError = true,
        message = ("%* %*"):format(p3, p4.componentStack)
    })
end

function v5.render(p5) -- line: 33
    if p5.state.hasError then
        return p5.props.fallback(p5.state.message)
    end

    return p5.props.children
end

v2 = ReactComponent(v2) or v5

return {
    ErrorBoundary = v2
}
