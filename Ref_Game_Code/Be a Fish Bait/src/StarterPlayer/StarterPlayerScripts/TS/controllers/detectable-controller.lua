-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Signal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "beacon", "out").Signal
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, computed, subscribe = charm.atom, charm.computed, charm.subscribe
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 18
        return "DetectableController"
    end
})

self.__index = self

function self.new(...) -- line: 23
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 27
    -- upvalues: Signal (copy), atom (copy)
    p1._components = p2
    p1.onPlayerEnter = Signal.new()
    p1.onPlayerExit = Signal.new()
    p1.componentsPlayerIsInsideAtom = atom({})
    p1._timeLastChecked = 0
    p1._checkInterval = 0.2
end

function self.onInit(p3) -- line: 35
    -- upvalues: subscribe (copy)
    subscribe(p3.componentsPlayerIsInsideAtom, function(p4, p5) -- line: 36
        -- upvalues: p3 (copy)
        for _, v3 in p4 do
            if table.find(p5, v3) == nil then
                p3.onPlayerEnter:Fire(v3)
            end
        end

        for _, v4 in p5 do
            if table.find(p4, v4) == nil then
                p3.onPlayerExit:Fire(v4)
            end
        end
    end)
end

function self.onTick(p6, _) -- line: 51
    if os.clock() - p6._timeLastChecked < p6._checkInterval then
        return nil
    end

    p6._timeLastChecked = os.clock()

    local v5 = p6:_getComponentsPlayerIsInside()

    p6.componentsPlayerIsInsideAtom(v5)
end

function self._getComponentsPlayerIsInside(p8) -- line: 60
    local v6 = p8._components:getAllComponents("client/components/detectable-component@DetectableComponent")
    local t4 = {}

    local function v7(p9) -- line: 64
        return p9:isPlayerInside()
    end

    local n1 = 0

    for v8, v9 in v6 do
        local _ = v8 - 1

        if v9:isPlayerInside() == true then
            n1 += 1
            t4[n1] = v9
        end
    end

    return t4
end

function self.getInsideOfComponentsAtom(p10, p11, p12, p13) -- line: 78
    -- upvalues: computed (copy)
    assert(p13 ~= "" and p13)

    return computed(function() -- line: 81
        -- upvalues: p10 (copy), p11 (copy), p12 (copy)
        local t5 = {}
        local n2 = 0

        for v11, v12 in (p11()) do
            local _ = v11 - 1
            local v13 = p12(v12)
            local t6 = if v13 then { v13, v12 } else nil

            if t6 ~= nil then
                n2 += 1
                t5[n2] = t6
            end
        end

        local t7 = {}

        for _, v14 in t5 do
            t7[v14[1]] = v14[2]
        end

        local v15 = p10.componentsPlayerIsInsideAtom()
        local t8 = {}
        local n3 = 0

        for v16, v17 in v15 do
            local _ = v16 - 1
            local v18 = t7[v17]

            if v18 ~= nil then
                n3 += 1
                t8[n3] = v18
            end
        end

        return t8
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/detectable-controller@DetectableController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnTick", "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    DetectableController = self
}
