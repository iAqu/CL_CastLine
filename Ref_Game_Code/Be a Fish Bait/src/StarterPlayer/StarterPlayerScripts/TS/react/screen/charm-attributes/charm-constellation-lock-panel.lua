-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "vfx").playClonedSound
local default2 = RuntimeLib.import(script, script.Parent, "charm-scene-close-button").default
local t1 = {
    0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055,
    0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055,
    0.055, 0.055, 0.055, 0.055, 0.07, 0.08, 0.1, 0.13,
    0.17, 0.23, 0.48, 0.68
}

local function v1(p1, p2) -- line: 16
    return p1 + p2
end

local n1 = 0

for i = 1, #t1 do
    local v3 = t1[i]
    local _ = i - 1

    n1 += v3
end

local getAuraRevealSoundName

local function CharmConstellationLockPanel(p3) -- line: 26
    -- upvalues: react (copy), useEffect (copy), useRef (copy), default (copy), playClonedSound (copy), default2 (copy), t1 (copy), n1 (ref), getAuraRevealSoundName (ref)
    local candidate, onClose, onComplete = p3.candidate, p3.onClose, p3.onComplete
    local v4 = useRef(0)

    useEffect(function() -- line: 31
        -- upvalues: candidate (copy), v4 (copy), playClonedSound (copy), t1 (copy), n1 (ref), getAuraRevealSoundName (ref)
        v4.current += 1

        local current = v4.current
        local t2 = {}
        local n2 = 0

        for v5, v6 in t1 do
            local v7 = v5 - 1

            n2 += v6 / n1 * 2
            table.insert(t2, (task.delay(n2, function() -- line: 39
                -- upvalues: current (copy), v7 (copy), candidate (copy), v4 (copy), playClonedSound (copy), t1 (copy), getAuraRevealSoundName (ref)
                if v4.current ~= current then
                    return nil
                end

                local v10 = v7 == #t1 - 1

                playClonedSound("AuraRolling")

                if v10 and candidate ~= nil then
                    playClonedSound(getAuraRevealSoundName(candidate), {
                        timePosition = 0.1
                    })
                end
            end)))
        end

        table.insert(t2, (task.delay(1, function() -- line: 57
            -- upvalues: current (copy), v4 (copy), playClonedSound (copy)
            if v4.current ~= current then
                return nil
            end

            playClonedSound("AuraRiser", {
                timePosition = 1.65
            })
        end)))

        return function() -- line: 66
            -- upvalues: current (copy), t2 (copy), v4 (copy)
            if v4.current == current then
                v4.current = current + 1
            end

            local function v12(p4) -- line: 71
                return task.cancel(p4)
            end

            for v13, v14 in t2 do
                local _ = v13 - 1

                task.cancel(v14)
            end
        end
    end, { candidate })
    useEffect(function() -- line: 80
        -- upvalues: onComplete (copy)
        local v15 = task.delay(2, onComplete)

        return function() -- line: 82
            -- upvalues: v15 (copy)
            return task.cancel(v15)
        end
    end, { onComplete })

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 1200,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        zIndex = 1210,
        onClose = onClose
    }), react.createElement(default, {
        shadowYScale = 0.045,
        text = "Aligning your charm attributes...",
        color = Color3.fromRGB(234, 226, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 1204,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.33, 0.94),
            Size = UDim2.fromScale(0.34, 0.04)
        }
    }))
end

function getAuraRevealSoundName(p5) -- line: 106
    if p5.overallPercentile >= 0.99 then
        return "AuraRevealMythic"
    end

    local affixes = p5.affixes

    local function v16(p6) -- line: 113
        return p6.quality == "perfect"
    end

    local v17 = false

    for v18, v19 in affixes do
        local _ = v18 - 1

        if v19.quality == "perfect" then
            v17 = true
            break
        end
    end

    if v17 then
        return "AuraRevealLegend"
    end

    return "AuraReveal"
end

return {
    default = CharmConstellationLockPanel
}
