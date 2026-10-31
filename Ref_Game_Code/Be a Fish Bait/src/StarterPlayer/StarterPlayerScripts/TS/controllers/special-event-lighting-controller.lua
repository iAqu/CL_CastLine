-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Lighting, Workspace = services.Lighting, services.Workspace
local selectActiveSpecialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "active-special-event.selectors").selectActiveSpecialEvents
local specialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "special-events").specialEvents
local hueForElapsed = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "hue-cycle-utils").hueForElapsed

local function resolveActiveEvent(p1) -- line: 12
    for v1, v2 in p1 do
        return {
            kind = v1,
            startTimestamp = v2.startTimestamp
        }
    end

    return nil
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 32
        return "SpecialEventLightingController"
    end
})

self.__index = self

function self.new(...) -- line: 37
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2, p3) -- line: 41
    p2._reflexController = p3
    p2._activeStartTimestamp = 0
    p2._atmosphereWasNewlyCreated = false
end

function self.onStart(p4) -- line: 46
    -- upvalues: selectActiveSpecialEvents (copy), specialEvents (copy), resolveActiveEvent (copy)
    p4._reflexController:getClientProducer():subscribe(selectActiveSpecialEvents, function(p5) -- line: 48
        -- upvalues: p4 (copy), specialEvents (copy), resolveActiveEvent (copy)
        local v5 = resolveActiveEvent(p5)

        if (if v5 == nil then v5 else v5.kind) == p4._activeKind then
            return nil
        end

        p4:_teardown()
        p4._activeKind = if v5 == nil then v5 else v5.kind

        if v5 == nil then
            return nil
        end

        p4._activeStartTimestamp = v5.startTimestamp
        p4._activeDefinition = specialEvents[v5.kind]
        p4:_setup()
    end)
end

function self._setup(p6) -- line: 72
    -- upvalues: Lighting (copy)
    local _activeDefinition = p6._activeDefinition

    if _activeDefinition ~= nil then
        _activeDefinition = _activeDefinition.skybox
    end

    if _activeDefinition then
        p6._clonedSkybox = _activeDefinition:Clone()

        if p6._clonedSkybox then
            p6._clonedSkybox.Parent = Lighting
        end
    end

    local _activeDefinition2 = p6._activeDefinition

    if _activeDefinition2 ~= nil then
        _activeDefinition2 = _activeDefinition2.lightingOverride
    end

    if not _activeDefinition2 then
        return nil
    end

    p6._savedLighting = {
        ambient = Lighting.Ambient,
        brightness = Lighting.Brightness,
        colorShiftBottom = Lighting.ColorShift_Bottom,
        colorShiftTop = Lighting.ColorShift_Top,
        fogColor = Lighting.FogColor,
        fogEnd = Lighting.FogEnd,
        fogStart = Lighting.FogStart,
        outdoorAmbient = Lighting.OutdoorAmbient
    }
    Lighting.Ambient = _activeDefinition2.ambient
    Lighting.Brightness = _activeDefinition2.brightness
    Lighting.ColorShift_Bottom = _activeDefinition2.colorShiftBottom
    Lighting.ColorShift_Top = _activeDefinition2.colorShiftTop
    Lighting.FogColor = _activeDefinition2.fogColor
    Lighting.FogEnd = _activeDefinition2.fogEnd
    Lighting.FogStart = _activeDefinition2.fogStart
    Lighting.OutdoorAmbient = _activeDefinition2.outdoorAmbient

    if _activeDefinition2.atmosphereColor == nil and _activeDefinition2.atmosphereDensity == nil and _activeDefinition2.atmosphereOffset == nil then
        return
    end

    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    p6._atmosphereWasNewlyCreated = Atmosphere == nil

    local v7 = Atmosphere or Instance.new("Atmosphere")

    if p6._atmosphereWasNewlyCreated then
        v7.Parent = Lighting
    end

    p6._savedAtmosphere = {
        color = v7.Color,
        density = v7.Density,
        offset = v7.Offset
    }

    if _activeDefinition2.atmosphereColor ~= nil then
        v7.Color = _activeDefinition2.atmosphereColor
    end

    if _activeDefinition2.atmosphereDensity ~= nil then
        v7.Density = _activeDefinition2.atmosphereDensity
    end

    if _activeDefinition2.atmosphereOffset ~= nil then
        v7.Offset = _activeDefinition2.atmosphereOffset
    end
end

function self._teardown(p7) -- line: 134
    -- upvalues: Lighting (copy)
    local _clonedSkybox = p7._clonedSkybox

    if _clonedSkybox ~= nil then
        _clonedSkybox:Destroy()
    end

    p7._clonedSkybox = nil

    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    if Atmosphere and p7._savedAtmosphere then
        if p7._atmosphereWasNewlyCreated then
            Atmosphere:Destroy()
        else
            Atmosphere.Color = p7._savedAtmosphere.color
            Atmosphere.Density = p7._savedAtmosphere.density
            Atmosphere.Offset = p7._savedAtmosphere.offset
        end
    end

    p7._savedAtmosphere = nil

    local _savedLighting = p7._savedLighting

    if _savedLighting then
        Lighting.Ambient = _savedLighting.ambient
        Lighting.Brightness = _savedLighting.brightness
        Lighting.ColorShift_Bottom = _savedLighting.colorShiftBottom
        Lighting.ColorShift_Top = _savedLighting.colorShiftTop
        Lighting.FogColor = _savedLighting.fogColor
        Lighting.FogEnd = _savedLighting.fogEnd
        Lighting.FogStart = _savedLighting.fogStart
        Lighting.OutdoorAmbient = _savedLighting.outdoorAmbient
    end

    p7._savedLighting = nil
    p7._activeDefinition = nil
end

function self.onTick(p8) -- line: 165
    -- upvalues: Lighting (copy), Workspace (copy), hueForElapsed (copy)
    local _activeDefinition = p8._activeDefinition

    if not (if _activeDefinition == nil then _activeDefinition else _activeDefinition.lightingOverride) or _activeDefinition.hueCycleSeconds == nil then
        return nil
    end

    local v9 = hueForElapsed(Workspace:GetServerTimeNow() - p8._activeStartTimestamp, _activeDefinition.hueCycleSeconds)

    Lighting.FogColor = Color3.fromHSV(v9, 0.85, 1)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/special-event-lighting-controller@SpecialEventLightingController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    SpecialEventLightingController = self
}
