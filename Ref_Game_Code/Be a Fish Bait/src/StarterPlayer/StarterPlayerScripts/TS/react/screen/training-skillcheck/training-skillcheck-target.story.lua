-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local default2 = RuntimeLib.import(script, script.Parent, "training-skillcheck-target").default
local createBinding = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").createBinding
local n1 = 0

local function TargetStoryScene() -- line: 15
    -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), RunService (copy), default2 (copy), createBinding (copy), n1 (ref)
    local v1, v2 = useState({})
    local v3 = useRef({})

    useEffect(function() -- line: 18
        -- upvalues: v1 (copy), v3 (copy)
        v3.current = v1
    end, { v1 })
    useEffect(function() -- line: 21
        -- upvalues: v2 (copy), v3 (copy), RunService (copy)
        local connection = RunService.Heartbeat:Connect(function() -- line: 22
            -- upvalues: v2 (copy), v3 (copy)
            local v4 = os.clock() * 1000

            for _, v5 in v3.current do
                local v7 = math.clamp((v4 - v5.startTime) / 1800, 0, 1)

                v5.setProgress(v7)

                if v7 >= 1 then
                    v2(function(p1) -- line: 29
                        -- upvalues: v5 (copy)
                        local t1 = {}
                        local n2 = 0

                        for v8, v9 in p1 do
                            local _ = v8 - 1

                            if v9.id ~= v5.id == true then
                                n2 += 1
                                t1[n2] = v9
                            end
                        end

                        return t1
                    end)
                end
            end
        end)

        return function() -- line: 48
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, {})

    local function spawnTarget() -- line: 52
        -- upvalues: v2 (copy), createBinding (copy), n1 (ref)
        local v10 = n1

        n1 += 1

        local v11, v12 = createBinding(0)
        local t2 = {
            id = v10,
            startTime = os.clock() * 1000,
            pos = {
                x = 400,
                y = 300
            },
            progressBinding = v11,
            setProgress = v12
        }

        v2(function(p2) -- line: 67
            -- upvalues: t2 (copy)
            local t3 = {}
            local v13 = #t3
            local v14 = #p2

            table.move(p2, 1, v14, v13 + 1, t3)
            t3[v13 + v14 + 1] = t2

            return t3
        end)
    end

    local v15 = table.create(#v1)

    local function v16(p3) -- line: 79
        -- upvalues: v2 (copy), react (copy), default2 (copy)
        return react.createElement(default2, {
            approachRingProgress = p3.progressBinding,
            key = tostring(p3.id),
            onTap = function() -- onTap | line: 83
                -- upvalues: p3 (copy), v2 (copy)
                return v2(function(p4) -- line: 84
                    -- upvalues: p3 (copy)
                    local t5 = {}
                    local n3 = 0

                    for v17, v18 in p4 do
                        local _ = v17 - 1

                        if v18.id ~= p3.id == true then
                            n3 += 1
                            t5[n3] = v18
                        end
                    end

                    return t5
                end)
            end,
            targetPos = p3.pos
        })
    end

    for v19, v20 in v1 do
        v15[v19] = v16(v20, v19 - 1, v1)
    end

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30, 120, 30),
        Size = UDim2.fromScale(1, 1)
    }, v15, react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Spawn Target",
        TextScaled = true,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(50, 130, 220),
        Event = {
            Activated = spawnTarget
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.fromOffset(240, 48),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 10)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(TargetStoryScene)))
