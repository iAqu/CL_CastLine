-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService

return {
    default = function(p1) -- RainbowHighlight | line: 8
        -- upvalues: react (copy), useEffect (copy), useState (copy), RunService (copy)
        local adornee, fillTransparency = p1.adornee, p1.fillTransparency

        if fillTransparency == nil then
            fillTransparency = 0.5
        end

        local outlineTransparency = p1.outlineTransparency

        if outlineTransparency == nil then
            outlineTransparency = 0
        end

        local speed = p1.speed
        local v1 = speed

        if speed == nil then
            v1 = 1
        end

        local v2, v3 = useState(0)

        useEffect(function() -- line: 25
            -- upvalues: v1 (ref), v3 (copy), RunService (copy)
            local v4 = tick()
            local connection = RunService.Heartbeat:Connect(function() -- line: 27
                -- upvalues: v4 (ref), v1 (ref), v3 (copy)
                local v5 = tick()
                local v6 = v5 - v4

                v4 = v5
                v3(function(p2) -- line: 31
                    -- upvalues: v6 (copy), v1 (ref)
                    return (p2 + v6 * v1) % 1
                end)
            end)

            return function() -- line: 35
                -- upvalues: connection (copy)
                connection:Disconnect()
            end
        end, { v1 })

        local v7 = Color3.fromHSV(v2, 1, 1)

        return react.createElement("highlight", {
            Adornee = adornee,
            FillColor = v7,
            FillTransparency = fillTransparency,
            OutlineColor = v7,
            OutlineTransparency = outlineTransparency
        })
    end
}
