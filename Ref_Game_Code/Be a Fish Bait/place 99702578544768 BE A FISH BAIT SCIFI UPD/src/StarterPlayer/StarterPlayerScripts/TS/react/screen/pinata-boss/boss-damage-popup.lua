-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootProducer
local v1 = UDim2.fromOffset(140, 50)

local function createPopupPart(p1) -- line: 16
    -- upvalues: Workspace (copy)
    local Part = Instance.new("Part")

    Part.Name = "PinataBossDamagePopupAnchor"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.1, 0.1, 0.1)
    Part.Position = p1
    Part.Parent = Workspace

    return Part
end

return {
    default = function(p2) -- BossDamagePopup | line: 29
        -- upvalues: react (copy), useEffect (copy), useState (copy), createPortal (copy), useMotion (copy), Workspace (copy), default (copy), useRootProducer (copy), v1 (copy)
        local cascadeIndex, entry = p2.cascadeIndex, p2.entry
        local v2 = useRootProducer()
        local v3, v4 = useState()
        local v5, v6 = useMotion(0)

        useEffect(function() -- line: 35
            -- upvalues: cascadeIndex (copy), entry (copy), v2 (copy), v4 (copy), v6 (copy), Workspace (copy)
            local v8 = entry.position + Vector3.new(0, cascadeIndex * 1.75, 0)
            local Part = Instance.new("Part")

            Part.Name = "PinataBossDamagePopupAnchor"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.Transparency = 1
            Part.Size = Vector3.new(0.1, 0.1, 0.1)
            Part.Position = v8
            Part.Parent = Workspace
            v4(Part)
            v6:immediate(0)
            v6:linear(1, {
                speed = 1
            })

            local v9 = task.delay(1, function() -- line: 44
                -- upvalues: entry (copy), v2 (copy)
                v2.pinataBossDamagePopupRemoved({
                    id = entry.id
                })
            end)

            return function() -- line: 49
                -- upvalues: Part (copy), v9 (copy)
                task.cancel(v9)
                Part:Destroy()
            end
        end, {})

        if v3 == nil then
            return nil
        end

        local v10 = v5:map(function(p3) -- line: 58
            return (Vector3.new(0, 2.5 * p3, 0))
        end)
        local v12 = v5:map(function(p4) -- line: 61
            if p4 < 0.15 then
                return 1 - p4 / 0.15
            end

            return (p4 - 0.15) / 0.85
        end)

        return createPortal(react.createElement("billboardgui", {
            AlwaysOnTop = true,
            LightInfluence = 0,
            MaxDistance = 100,
            Size = v1,
            StudsOffsetWorldSpace = v10
        }, react.createElement(default, {
            color = Color3.new(1, 0.85, 0.2),
            overrideProps = {
                Font = Enum.Font.GothamBlack,
                TextTransparency = v12
            },
            strokeProps = {
                Transparency = v12
            },
            text = ("-%*"):format(entry.damage)
        })), v3)
    end
}
