-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 5
        return "SoundSingleton"
    end
})

self.__index = self

function self.new(...) -- line: 10
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 14
    p1._components = p2
    p1._soundCache = {}
    p1._soundGroupCache = {}
end

function self.getSoundComponent(p3, p4) -- line: 19
    local v3 = p3._soundCache[p4]

    if v3 then
        return v3
    end

    local v4

    for v5, v6 in (p3._components:getAllComponents("shared/components/sound-component@SoundComponent")) do
        local _ = v5 - 1

        if v6.instance.Name == p4 == true then
            v4 = v6
            break
        end

        v4 = nil
    end

    if not v4 then
        error("[src/shared/singletons/sound-singleton.ts:21]" .. ("Sound not found for name %*"):format(p4))
    end

    p3._soundCache[p4] = v4

    return v4
end

function self.getSound(p5, p6) -- line: 48
    return p5:getSoundComponent(p6).instance
end

function self.getSoundGroupComponent(p7, p8) -- line: 51
    local v7 = p7._soundGroupCache[p8]

    if v7 then
        return v7
    end

    local v8

    for v9, v10 in (p7._components:getAllComponents("shared/components/sound-group-component@SoundGroupComponent")) do
        local _ = v9 - 1

        if v10.instance.Name == p8 == true then
            v8 = v10
            break
        end

        v8 = nil
    end

    if not v8 then
        error("[src/shared/singletons/sound-singleton.ts:42]" .. ("Sound group not found for name %*"):format(p8))
    end

    p7._soundGroupCache[p8] = v8

    return v8
end

function self.getSoundGroup(p9, p10) -- line: 80
    return p9:getSoundGroupComponent(p10).instance
end

return {
    SoundSingleton = self
}
