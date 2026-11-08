-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Dropshadow = require(script.Dropshadow)
local Gradient = require(script.Gradient)

require(script.Layers)

local GradientTemplates = require(script.GradientTemplates)
local Stroke = require(script.Stroke)
local t = require(ReplicatedStorage.Packages.t)
local VisibilityGate = require(script.VisibilityGate)
local t1 = {
    UIStroke = true,
    UIGradient = true
}
local t2 = {}

t2.__index = t2
t2.Gradient = Gradient
t2.Stroke = Stroke
t2.Dropshadow = Dropshadow
t2.Templates = GradientTemplates
t2.CurrentEffects = {}

local Presets = script.Presets
local v1 = t.strict(t.union(t.instanceIsA("GuiObject"), t.instanceIsA("UIStroke")))
local v2 = t.strict(t.string)
local v3 = t.strict(t.number)
local v4 = t.strict(t.union(t.ColorSequence, t.Color3))
local v5 = t.strict(t.union(t.NumberSequence, t.number))

local function broadcast(p1, p2) -- line: 61
    for _, v6 in p1.EffectObjects do
        local v7 = v6[p2]

        if v7 then
            v7(v6)
        end
    end
end

local function absorb(p3, p4) -- line: 70
    if not p4 then
        return
    end

    for _, v8 in p4 do
        p3[#p3 + 1] = v8
    end
end

local function teardown(p5) -- line: 80
    for _, v9 in p5.detached do
        v9.Parent = p5.host
    end

    for _, v10 in p5.watchers do
        if typeof(v10) == "table" then
            if typeof(v10.Destroy) == "function" then
                v10:Destroy()
            else
                v10:Disconnect()
            end
        else
            v10:Disconnect()
        end
    end

    table.clear(p5.detached)
    table.clear(p5.watchers)

    for _, v11 in p5.EffectObjects do
        local Destroy = v11.Destroy

        if Destroy then
            Destroy(v11)
        end
    end

    p5.lifeWatch:Disconnect()
end

local function watchLifetime(p6) -- line: 102
    -- upvalues: teardown (copy)
    local host = p6.host

    return host.AncestryChanged:Connect(function() -- line: 105
        -- upvalues: p6 (copy), host (copy), teardown (copy)
        if not host:IsDescendantOf(game) then
            teardown(p6)
        end
    end)
end

local function stashExisting(p7) -- line: 114
    -- upvalues: t1 (copy)
    local detached = p7.detached

    for _, child in (p7.host:GetChildren()) do
        if t1[child.ClassName] then
            detached[#detached + 1] = child
            child.Parent = nil
        end
    end
end

function t2.new(p8, p9, p10, p11, p12, p13, p14, p15, p16) -- line: 126
    -- upvalues: VisibilityGate (copy), t2 (copy), Presets (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), teardown (copy), stashExisting (copy)
    v1(p8)
    v2(p9)

    local v12 = Presets:FindFirstChild(p9)

    assert(v12, (("EasyVisuals has no preset named %*"):format(p9)))

    if p10 then
        v3(p10)
    end

    if p11 then
        v3(p11)
    end

    if p13 then
        v4(p13)
    end

    if p14 then
        v5(p14)
    end

    local v14 = setmetatable({
        isPaused = false,
        lifeWatch = nil,
        Diagnostic = "DIAGNOSTIC VALUE",
        host = p8,
        EffectObjects = {},
        detached = {},
        watchers = {},
        resumesWhenShown = p15 == nil or p15,
        drift = p10 or 0.007,
        width = p11 or 1
    }, t2)
    local v15 = require(v12)({
        Host = p8,
        Drift = v14.drift,
        Width = v14.width,
        Color = p13,
        Alpha = p14,
        Chain = p16
    })

    assert(typeof(v15) == "table", "an effect preset must hand back a table")

    if p12 then
        stashExisting(v14)
    end

    local watchers = v14.watchers
    local Connections = v15.Connections

    if Connections then
        for _, v17 in Connections do
            watchers[#watchers + 1] = v17
        end
    end

    local EffectObjects = v14.EffectObjects
    local Effects = v15.Effects

    if Effects then
        for _, v18 in Effects do
            EffectObjects[#EffectObjects + 1] = v18
        end
    end

    local host = v14.host

    v14.lifeWatch = host.AncestryChanged:Connect(function() -- line: 105
        -- upvalues: v14 (copy), host (copy), teardown (copy)
        if not host:IsDescendantOf(game) then
            teardown(v14)
        end
    end)

    local v19 = VisibilityGate.Watch(p8, function() -- line: 193
        -- upvalues: v14 (copy)
        for _, v20 in v14.EffectObjects do
            local Suspend = v20.Suspend

            if Suspend then
                Suspend(v20)
            end
        end
    end, function() -- line: 193
        -- upvalues: v14 (copy)
        if v14.resumesWhenShown then
            for _, v21 in v14.EffectObjects do
                local Wake = v21.Wake

                if Wake then
                    Wake(v21)
                end
            end
        end
    end)

    if v19 then
        local watchers = v14.watchers

        watchers[#watchers + 1] = v19
    end

    return v14
end

function t2.Destroy(p17) -- line: 207
    -- upvalues: teardown (copy)
    teardown(p17)
end

function t2.Suspend(p18) -- line: 209
    for _, v22 in p18.EffectObjects do
        local Suspend = v22.Suspend

        if Suspend then
            Suspend(v22)
        end
    end
end

function t2.Wake(p19) -- line: 211
    for _, v23 in p19.EffectObjects do
        local Wake = v23.Wake

        if Wake then
            Wake(v23)
        end
    end
end

return table.freeze(t2)
