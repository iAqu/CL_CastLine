-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ObserveUITag = require(ReplicatedStorage.Client.ObserveUITag)

require(ReplicatedStorage.Packages.Trove)

local v1 = if UserInputService.TouchEnabled then 32 else 64
local t1 = {
    Aqua = {
        Resolution = 19,
        Stops = {
            {
                Position = 0,
                Color = Color3.fromRGB(69, 212, 255)
            },
            {
                Position = 0.151986,
                Color = Color3.fromRGB(51, 255, 160)
            },
            {
                Position = 0.326425,
                Color = Color3.fromRGB(41, 173, 255)
            },
            {
                Position = 0.587219,
                Color = Color3.fromRGB(52, 255, 204)
            },
            {
                Position = 0.777202,
                Color = Color3.fromRGB(49, 255, 145)
            },
            {
                Position = 1,
                Color = Color3.fromRGB(51, 177, 255)
            }
        }
    },
    Fire = {
        Resolution = 19,
        Stops = {
            {
                Position = 0,
                Color = Color3.fromRGB(255, 247, 15)
            },
            {
                Position = 0.151986,
                Color = Color3.fromRGB(255, 62, 23)
            },
            {
                Position = 0.326425,
                Color = Color3.fromRGB(255, 30, 34)
            },
            {
                Position = 0.587219,
                Color = Color3.fromRGB(255, 71, 34)
            },
            {
                Position = 0.777202,
                Color = Color3.fromRGB(255, 234, 0)
            },
            {
                Position = 1,
                Color = Color3.fromRGB(255, 238, 152)
            }
        }
    },
    Gold = {
        Resolution = 13,
        PhaseSteps = 60,
        Stops = {
            {
                Position = 0,
                Color = Color3.fromRGB(255, 225, 0)
            },
            {
                Position = 0.14285714285714285,
                Color = Color3.fromRGB(255, 225, 0)
            },
            {
                Position = 0.2857142857142857,
                Color = Color3.fromRGB(255, 248, 39)
            },
            {
                Position = 0.42857142857142855,
                Color = Color3.fromRGB(255, 191, 0)
            },
            {
                Position = 0.5714285714285714,
                Color = Color3.fromRGB(255, 225, 0)
            },
            {
                Position = 0.7142857142857143,
                Color = Color3.fromRGB(255, 250, 115)
            },
            {
                Position = 0.8571428571428571,
                Color = Color3.fromRGB(255, 225, 0)
            },
            {
                Position = 1,
                Color = Color3.fromRGB(255, 225, 0)
            }
        }
    },
    Halloween = {
        Resolution = 19,
        Stops = {
            {
                Position = 0,
                Color = Color3.fromRGB(255, 165, 20)
            },
            {
                Position = 0.151986,
                Color = Color3.fromRGB(82, 25, 138)
            },
            {
                Position = 0.326425,
                Color = Color3.fromRGB(182, 56, 255)
            },
            {
                Position = 0.587219,
                Color = Color3.fromRGB(255, 138, 20)
            },
            {
                Position = 0.777202,
                Color = Color3.fromRGB(255, 234, 0)
            },
            {
                Position = 1,
                Color = Color3.fromRGB(255, 238, 152)
            }
        }
    },
    Rainbow = {
        Resolution = 19,
        Stops = {
            {
                Position = 0,
                Color = Color3.fromRGB(255, 0, 0)
            },
            {
                Position = 0.125,
                Color = Color3.fromRGB(255, 127, 0)
            },
            {
                Position = 0.25,
                Color = Color3.fromRGB(255, 255, 0)
            },
            {
                Position = 0.375,
                Color = Color3.fromRGB(0, 255, 0)
            },
            {
                Position = 0.5,
                Color = Color3.fromRGB(0, 255, 255)
            },
            {
                Position = 0.625,
                Color = Color3.fromRGB(17, 0, 255)
            },
            {
                Position = 0.75,
                Color = Color3.fromRGB(149, 0, 255)
            },
            {
                Position = 0.875,
                Color = Color3.fromRGB(255, 0, 255)
            },
            {
                Position = 1,
                Color = Color3.fromRGB(255, 0, 0)
            }
        }
    },
    Sheen = {
        Resolution = 19,
        Stops = {
            {
                Position = 0,
                Color = Color3.fromRGB(255, 255, 255)
            },
            {
                Position = 0.272884,
                Color = Color3.fromRGB(255, 255, 255)
            },
            {
                Position = 0.502591,
                Color = Color3.fromRGB(135, 118, 255)
            },
            {
                Position = 0.547496,
                Color = Color3.fromRGB(137, 169, 252)
            },
            {
                Position = 0.73057,
                Color = Color3.fromRGB(246, 249, 255)
            },
            {
                Position = 1,
                Color = Color3.fromRGB(255, 255, 255)
            }
        }
    }
}
local t2 = {}
local t3 = {}
local connection

local function SampleColor(p1, p2) -- line: 105
    local v2 = p2 % 1

    for i = 1, #p1 - 1 do
        local v3 = p1[i]
        local v4 = p1[i + 1]

        if v2 <= v4.Position then
            local v5 = v4.Position - v3.Position
            local v6 = if v5 > 0 then (v2 - v3.Position) / v5 else 0

            return v3.Color:Lerp(v4.Color, v6)
        end
    end

    return p1[#p1].Color
end

local function BuildPhases(p3) -- line: 119
    -- upvalues: SampleColor (copy), v1 (copy)
    local v7 = p3.PhaseSteps or v1
    local Resolution = p3.Resolution
    local v8 = table.create(v7)
    local v9 = table.create(Resolution + 1)

    for i = 0, v7 - 1 do
        local v10 = i / v7

        for j = 0, Resolution do
            local v11 = j / Resolution

            v9[j + 1] = ColorSequenceKeypoint.new(v11, SampleColor(p3.Stops, v11 * 0.5 - v10))
        end

        v8[i + 1] = ColorSequence.new(v9)
    end

    return v8
end

local function GetPhases(p4) -- line: 136
    -- upvalues: t1 (copy), t2 (copy), BuildPhases (copy)
    local v12 = t2[p4]

    if v12 ~= nil then
        return v12
    end

    local v13 = t1[p4]

    if v13 == nil then
        return nil
    end

    local v14 = BuildPhases(v13)

    t2[p4] = v14

    return v14
end

local function StepGradients() -- line: 150
    -- upvalues: t3 (copy)
    local v15 = os.clock() % 2 / 2

    for v16, v17 in t3 do
        local Phases = v17.Phases
        local v18 = v15 * #Phases // 1 % #Phases + 1

        if v18 ~= v17.LastIndex then
            v17.LastIndex = v18
            v16.Color = Phases[v18]
        end
    end
end

local function StartGradient(p5, p6) -- line: 162
    -- upvalues: RunService (copy), t1 (copy), t2 (copy), t3 (copy), connection (ref), BuildPhases (copy), StepGradients (copy)
    local Palette = p5:GetAttribute("Palette")
    local v19

    if type(Palette) == "string" then
        v19 = t2[Palette]

        if v19 == nil then
            local v20 = t1[Palette]

            if v20 ~= nil then
                v19 = BuildPhases(v20)
                t2[Palette] = v19
            else
                v19 = nil
            end
        end
    end

    if v19 ~= nil then
        t3[p5] = {
            LastIndex = 0,
            Phases = v19
        }

        if connection == nil then
            connection = RunService.Heartbeat:Connect(StepGradients)
        end

        p6:Add(function() -- line: 173
            -- upvalues: p5 (copy), t3 (copy), connection (ref)
            t3[p5] = nil

            if next(t3) ~= nil or connection == nil then
                return
            end

            connection:Disconnect()
            connection = nil
        end)
    else
        warn((("%* needs a Palette attribute naming one of the GradientLoop palettes"):format((p5:GetFullName()))))
    end
end

ObserveUITag("GradientLoop", function(p7, p8) -- PlayGradient | line: 182
    -- upvalues: StartGradient (copy)
    if p7:IsA("UIGradient") then
        StartGradient(p7, p8)
    else
        warn((("GradientLoop tag on %* needs a UIGradient"):format((p7:GetFullName()))))
    end
end)

return nil
