-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootProducer
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local default2 = RuntimeLib.import(script, script.Parent, "default-loading-screen").default

return {
    default = function(p1) -- LoadingScreen | line: 12
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), images (copy), default (copy), useRootProducer (copy), Maid (copy), default2 (copy)
        local v1 = useRootProducer()
        local v2, v3 = useMotion(0)

        useEffect(function() -- line: 15
            -- upvalues: v3 (copy)
            v3:linear(360, {
                speed = 180
            })

            local v4 = v3:onComplete(function() -- line: 22
                -- upvalues: v3 (copy)
                v3:immediate(0)
                v3:linear(360, {
                    speed = 180
                })
            end)

            return function() -- line: 26
                -- upvalues: v4 (copy)
                v4()
            end
        end, { v3 })
        useEffect(function() -- line: 30
            -- upvalues: p1 (copy), v1 (copy), Maid (copy)
            local v5 = Maid.new()

            if p1.timeout ~= nil then
                v5:GiveTask(task.delay(p1.timeout, function() -- line: 33
                    -- upvalues: v1 (copy)
                    v1.windowToggled({
                        currentWindow = "none"
                    })
                end))
            end

            return function() -- line: 39
                -- upvalues: v5 (copy)
                v5:Destroy()
            end
        end, {
            p1.timeout,
            v1
        })

        if p1.loadingBackground == nil then
            return react.createElement(default2)
        end

        local t1 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5)
        }
        local loadingBackground = p1.loadingBackground

        t1.Image = if loadingBackground == nil then images.darkBackground else loadingBackground
        t1.Position = UDim2.fromScale(0.5, 0.5)
        t1.ScaleType = Enum.ScaleType.Crop
        t1.Size = UDim2.fromScale(1, 1)
        t1.ZIndex = 100

        local v6 = react.createElement("imagelabel", t1)
        local t2 = {
            overrideProps = {
                ZIndex = 101,
                RichText = true,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.85),
                Size = UDim2.fromScale(0.5, 0.2)
            }
        }
        local loadingText = p1.loadingText

        t2.text = if loadingText == nil then "Loading…" else loadingText

        local v7 = react.createElement(default, t2)
        local v8 = p1.loadingText == nil

        if v8 then
            local t3 = {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5)
            }
            local loadingBackground = p1.loadingBackground

            t3.Image = if loadingBackground == nil then images.loadingCircle else loadingBackground
            t3.Position = UDim2.fromScale(0.5, 0.75)
            t3.Rotation = v2
            t3.ScaleType = Enum.ScaleType.Fit
            t3.Size = UDim2.fromScale(0.1, 0.1)
            t3.ZIndex = 101
            v8 = react.createElement("imagelabel", t3, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1
            }))
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v6, v7, v8, react.createElement("frame", {
            ZIndex = 99,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }))
    end
}
