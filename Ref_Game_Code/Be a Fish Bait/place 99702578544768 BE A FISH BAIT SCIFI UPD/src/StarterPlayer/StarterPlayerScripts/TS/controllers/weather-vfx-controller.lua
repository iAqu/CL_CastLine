-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local selectCurrentWeathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "current-weather.selectors").selectCurrentWeathers

local function resolveActiveWeather(p1) -- line: 7
    for v1 in p1 do
        return v1
    end

    return "None"
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 16
        return "WeatherVFXController"
    end
})

self.__index = self

function self.new(...) -- line: 21
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2, p3, p4) -- line: 25
    -- upvalues: Maid (copy)
    p2._components = p3
    p2._reflexController = p4
    p2._maid = Maid.new()
    p2._activeWeather = "None"
end

function self.onStart(p5) -- line: 31
    -- upvalues: selectCurrentWeathers (copy)
    local v4 = p5._reflexController:getClientProducer()

    p5._maid:GiveTask(v4:subscribe(function(p6) -- line: 33
        -- upvalues: p5 (copy), selectCurrentWeathers (copy)
        for v5 in (selectCurrentWeathers(p6)) do
            if v5 == p5._activeWeather then
                return nil
            end

            p5._activeWeather = v5
            p5:_applyWeatherToAllComponents(v5)

            return
        end

        local v6 = "None"

        if v6 == p5._activeWeather then
            return nil
        end

        p5._activeWeather = v6
        p5:_applyWeatherToAllComponents(v6)
    end))
end

function self._applyWeatherToAllComponents(p7, p8) -- line: 43
    for _, v7 in p7._components:getAllComponents("client/components/weather-vfx-component@WeatherVFXComponent") do
        v7:setWeather(p8)
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/weather-vfx-controller@WeatherVFXController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components", "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    WeatherVFXController = self
}
