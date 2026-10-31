-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectPinataBossHudState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss.selectors").selectPinataBossHudState
local rglActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "rgl-active-atom").rglActiveAtom
local catchSticksActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "catch-sticks-active-atom").catchSticksActiveAtom
local default = RuntimeLib.import(script, script.Parent, "boss-area-hud").default

return {
    default = function() -- BossAreaHudManager | line: 13
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), useRootSelector (copy), selectPinataBossHudState (copy), rglActiveAtom (copy), catchSticksActiveAtom (copy), default (copy)
        local v1 = useRootSelector(selectPinataBossHudState)
        local damageContributions, despawnTimestamp, hp, isActive = v1.damageContributions, v1.despawnTimestamp, v1.hp, v1.isActive
        local maxHp = v1.maxHp
        local v2, v3 = useState(rglActiveAtom())
        local v4, v5 = useState(catchSticksActiveAtom())

        useEffect(function() -- line: 22
            -- upvalues: v3 (copy), subscribe (copy), rglActiveAtom (copy)
            return subscribe(rglActiveAtom, v3)
        end, {})
        useEffect(function() -- line: 25
            -- upvalues: v5 (copy), subscribe (copy), catchSticksActiveAtom (copy)
            return subscribe(catchSticksActiveAtom, v5)
        end, {})

        if isActive and not v2 and not v4 then
            return react.createElement(default, {
                damageContributions = damageContributions,
                despawnTimestamp = despawnTimestamp,
                hp = hp,
                maxHp = maxHp
            })
        end

        return nil
    end
}
