-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function getLoadingStep(p1) -- line: 10
    local v2 = math.floor((if type(p1) == "number" then p1 else 0) * 4) % 4

    if v2 == 0 then
        return "Loading"
    end

    if v2 == 1 then
        return "Loading."
    end

    if v2 == 2 then
        return "Loading.."
    end

    return "Loading..."
end

return {
    default = function(_) -- DefaultLoadingScreen | line: 24
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), images (copy)
        local v3, v4 = useMotion(0)

        useEffect(function() -- line: 26
            -- upvalues: v4 (copy)
            v4:linear(1, {
                speed = 0.3333333333333333
            })

            local v5 = v4:onComplete(function() -- line: 30
                -- upvalues: v4 (copy)
                v4:immediate(0)
                v4:linear(1, {
                    speed = 0.3333333333333333
                })
            end)

            return function() -- line: 36
                -- upvalues: v5 (copy)
                v5()
            end
        end, { v4 })

        local v6 = v3:map(function(p3) -- line: 40
            local v8 = math.floor((if type(p3) == "number" then p3 else 0) * 4) % 4

            if v8 == 0 then
                return "Loading"
            end

            if v8 == 1 then
                return "Loading."
            end

            if v8 == 2 then
                return "Loading.."
            end

            return "Loading..."
        end)

        return react.createElement("frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 100,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.voidDeckStudios,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.4, 0.4)
        }), react.createElement("uigradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 0, 59)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(54, 3, 112)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(31, 0, 59))
            })
        }), react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                Size = UDim2.fromScale(0.5, 0.065)
            },
            position = UDim2.fromScale(0.5, 0.85),
            text = v6
        }))
    end
}
