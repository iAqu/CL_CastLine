-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext, useEffect, useState = react.useContext, react.useEffect, react.useState
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext

local function hsvToRgb(p1, p2, p3) -- line: 11
    local v1 = p3 * p2
    local v3 = v1 * (1 - math.abs(p1 * 6 % 2 - 1))
    local v4 = p3 - v1
    local v5

    if p1 * 6 < 1 then
        v5 = 0
    elseif p1 * 6 < 2 then
        v1, v3, v5 = v3, v1, 0
    elseif p1 * 6 < 3 then
        v1, v3, v5 = 0, v1, v3
    elseif p1 * 6 < 4 then
        v1, v5 = 0, v1
    else
        if p1 * 6 < 5 then
            v1, v5 = v3, v1
        else
            v5 = v3
        end

        v3 = 0
    end

    return Color3.new(v1 + v4, v3 + v4, v5 + v4)
end

local function getRainbowColorSequence(p4, p5) -- line: 46
    -- upvalues: hsvToRgb (copy)
    local t1 = {}
    local n1 = 0
    local v6 = false

    while true do
        if v6 then
            n1 += 1
        else
            v6 = true
        end

        if n1 < p5 then
            local v7 = n1 / (p5 - 1)
            local v9 = hsvToRgb((p4 + v7) % 1, 1, 1)

            table.insert(t1, (ColorSequenceKeypoint.new(v7, v9)))
            continue
        end

        break
    end

    return ColorSequence.new(t1)
end

return {
    default = function(p6) -- RainbowTextLabel | line: 71
        -- upvalues: react (copy), useContext (copy), useEffect (copy), useState (copy), RunService (copy), ThemeContext (copy), getRainbowColorSequence (copy)
        local v11 = useContext(ThemeContext)
        local v12, v13 = useState(0)
        local speed = p6.speed

        if speed == nil then
            speed = 1
        end

        useEffect(function() -- line: 80
            -- upvalues: v13 (copy), speed (ref), RunService (copy)
            local v14 = tick()
            local connection = RunService.Heartbeat:Connect(function() -- line: 82
                -- upvalues: v14 (ref), v13 (copy), speed (ref)
                local v15 = tick()
                local v16 = v15 - v14

                v14 = v15
                v13(function(p7) -- line: 86
                    -- upvalues: v16 (copy), speed (ref)
                    return (p7 + v16 * speed) % 1
                end)
            end)

            return function() -- line: 90
                -- upvalues: connection (copy)
                connection:Disconnect()
            end
        end, { speed })

        local v17 = getRainbowColorSequence(v12, 8)
        local t2 = {
            BackgroundTransparency = 1,
            RichText = true,
            TextScaled = true,
            Font = p6.font or v11.textFont,
            Size = p6.size,
            Text = p6.text,
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        }
        local overrideProps = p6.overrideProps

        if overrideProps then
            for v18, v19 in overrideProps do
                t2[v18] = v19
            end
        end

        local v20 = react.createElement("uigradient", {
            Rotation = 0,
            Color = v17
        })
        local t3 = {
            Color = Color3.new(0, 0, 0)
        }
        local strokeThickness = p6.strokeThickness

        t3.Thickness = if strokeThickness == nil then 1 else strokeThickness

        local strokeTransparency = p6.strokeTransparency

        t3.Transparency = if strokeTransparency == nil then 0 else strokeTransparency

        return react.createElement("textlabel", t2, v20, react.createElement("uistroke", t3), p6.children)
    end
}
