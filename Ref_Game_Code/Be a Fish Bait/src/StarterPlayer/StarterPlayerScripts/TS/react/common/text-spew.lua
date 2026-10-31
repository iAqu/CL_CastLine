-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo = react.useEffect, react.useMemo
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent, "styled-text-label").default

return {
    default = function(p1) -- TextSpew | line: 30
        -- upvalues: react (copy), useEffect (copy), useMemo (copy), createPortal (copy), useMotion (copy), default (copy)
        local adornee, color = p1.adornee, p1.color
        local v1 = color

        if color == nil then
            v1 = Color3.new(1, 1, 1)
        end

        local count, durationSec = p1.count, p1.durationSec
        local v2 = durationSec

        if durationSec == nil then
            v2 = 1.6
        end

        local model, scaleContent = p1.model, p1.scaleContent
        local v3 = scaleContent

        if scaleContent == nil then
            v3 = false
        end

        local size = p1.size
        local v4 = size

        if size == nil then
            v4 = UDim2.fromOffset(260, 60)
        end

        local texts, trigger = p1.texts, p1.trigger
        local v5

        if adornee ~= nil then
            v5 = adornee
        else
            local v6 = if model == nil then model else model.PrimaryPart

            v5 = if v6 ~= nil then v6 elseif model ~= nil then model:FindFirstChildWhichIsA("BasePart", true) else model
        end

        local v7, v8 = useMotion(0)
        local v9 = useMemo(function() -- line: 69
            -- upvalues: count (copy), texts (copy), trigger (copy)
            if trigger == 0 or #texts == 0 then
                return {}
            end

            local v10 = Random.new(trigger)
            local v11 = count

            if count == nil then
                v11 = #texts
            end

            local t1 = {}
            local n1 = 0
            local v12 = false

            while true do
                if v12 then
                    n1 += 1
                else
                    v12 = true
                end

                if n1 < v11 then
                    table.insert(t1, {
                        angle = v10:NextNumber(0, 360),
                        delay = v10:NextNumber(0, 0.45),
                        distance = v10:NextNumber(3.5, 8),
                        lift = v10:NextNumber(0.5, 3),
                        scale = v10:NextNumber(0.8, 1.35),
                        spin = v10:NextNumber(-20, 20),
                        text = texts[v10:NextInteger(0, #texts - 1) + 1]
                    })
                    continue
                end

                break
            end

            return t1
        end, { texts, trigger, count })

        useEffect(function() -- line: 106
            -- upvalues: v2 (ref), trigger (copy), v8 (copy)
            if trigger == 0 then
                return nil
            end

            v8:immediate(0)
            v8:linear(1, {
                speed = 1 / v2
            })
        end, { trigger, v2, v8 })

        if v5 == nil or #v9 == 0 then
            return nil
        end

        local v13 = table.create(#v9)

        local function v14(p2, p3) -- line: 120
            -- upvalues: v1 (ref), v3 (ref), v4 (ref), trigger (copy), v5 (ref), v7 (copy), react (copy), createPortal (copy), default (copy)
            local v15 = v7:map(function(p4) -- line: 121
                -- upvalues: p2 (copy)
                return (math.clamp((p4 - p2.delay) / (1 - p2.delay), 0, 1))
            end)
            local v17 = v15:map(function(p5) -- line: 124
                return 1 - (1 - p5) * (1 - p5)
            end)
            local v18 = math.rad(p2.angle)
            local v19 = v17:map(function(p6) -- line: 128
                -- upvalues: p2 (copy), v18 (copy)
                local v20 = p2.distance * p6

                return (Vector3.new(math.cos(v18) * v20, p2.lift * p6 + p6 * p6 * 1.5, math.sin(v18) * v20))
            end)
            local v24 = v15:map(function(p7) -- line: 132
                if p7 < 0.12 then
                    return 1 - p7 / 0.12
                end

                if p7 > 0.65 then
                    return (p7 - 0.65) / 0.35
                end

                return 0
            end)
            local v25 = v17:map(function(p8) -- line: 135
                -- upvalues: p2 (copy)
                return p2.spin * p8
            end)
            local v26 = v17:map(function(p9) -- line: 138
                -- upvalues: p2 (copy)
                return p2.scale * (math.min(p9 * 3, 1) * 0.5 + 0.5)
            end)

            return createPortal(react.createElement("billboardgui", {
                AlwaysOnTop = true,
                LightInfluence = 0,
                MaxDistance = 100,
                Size = v4,
                StudsOffsetWorldSpace = v19,
                key = ("%*-%*"):format(trigger, p3)
            }, react.createElement("frame", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Rotation = v25,
                Size = v26:map(function(p10) -- line: 153
                    -- upvalues: v3 (ref)
                    if v3 then
                        return (UDim2.fromScale(p10, p10))
                    end

                    return (UDim2.fromOffset(260 * p10, 60 * p10))
                end)
            }, react.createElement(default, {
                color = v1,
                overrideProps = {
                    AutoLocalize = p2.text ~= "du bist gut genung",
                    Font = Enum.Font.GothamBlack,
                    TextTransparency = v24
                },
                strokeProps = {
                    Transparency = v24
                },
                text = p2.text
            }))), v5)
        end

        for v28, v29 in v9 do
            v13[v28] = v14(v29, v28 - 1, v9)
        end

        return react.createElement(react.Fragment, nil, v13)
    end
}
