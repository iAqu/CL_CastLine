-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig

return {
    default = function(_) -- SlapButton | line: 8
        -- upvalues: react (copy), useState (copy), useConfig (copy)
        local v1, v2 = useState(false)
        local v3 = useConfig()

        return react.createElement("imagebutton", {
            BackgroundTransparency = 1,
            Image = "http://www.roblox.com/asset/?id=95694879307679",
            AnchorPoint = Vector2.new(0, 0),
            BorderColor3 = Color3.new(27, 42, 53),
            Event = {
                Activated = function() -- Activated | line: 16
                    -- upvalues: v3 (copy)
                    v3.handleWeaponUsed()
                end,
                MouseButton1Down = function() -- MouseButton1Down | line: 19
                    -- upvalues: v2 (copy)
                    v2(true)
                end,
                MouseButton1Up = function() -- MouseButton1Up | line: 22
                    -- upvalues: v2 (copy)
                    v2(false)
                end,
                MouseLeave = function() -- MouseLeave | line: 25
                    -- upvalues: v2 (copy)
                    v2(false)
                end
            },
            ImageColor3 = Color3.new(1, 1, 1),
            ImageRectOffset = if v1 then Vector2.new(146, 146) else Vector2.new(1, 146),
            ImageRectSize = Vector2.new(146, 146),
            Position = UDim2.new(1, -170, 0.58, 0),
            Size = UDim2.fromOffset(80, 80),
            SizeConstraint = Enum.SizeConstraint.RelativeXY
        })
    end
}
