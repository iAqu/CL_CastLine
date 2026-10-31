-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default

return {
    default = function(p1) -- RareFishProgressBar | line: 13
        -- upvalues: react (copy), default (copy), default2 (copy)
        local v1 = react.createElement("uiscale", {
            Scale = p1.pulseScale
        })
        local v2 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0, p1.barCornerRadius)
        })
        local v3 = react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0, 0),
            Size = p1.barFillScale
        }, react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = p1.texturePos,
            Size = UDim2.fromScale(2, 1)
        }, react.createElement("uigradient", {
            Rotation = 25,
            Color = p1.barFillGradient
        })), react.createElement("frame", {
            BackgroundTransparency = 0.55,
            BorderSizePixel = 0,
            ZIndex = 8,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 0.3)
        }))
        local t1 = {
            0.25, 0.5, 0.75
        }
        local v4 = table.create(#t1)

        local function v5(p2, p3) -- line: 52
            -- upvalues: react (copy)
            return react.createElement("frame", {
                BackgroundTransparency = 0.25,
                BorderSizePixel = 0,
                ZIndex = 9,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Position = UDim2.fromScale(p2, 0.5),
                Size = UDim2.fromScale(0.003, 0.85),
                key = tostring(p3)
            })
        end

        for v6, v7 in t1 do
            v4[v6] = v5(v7, v6 - 1, t1)
        end

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -p1.barBottomOffset),
            Size = UDim2.fromOffset(p1.barWidth, p1.barHeight + 34)
        }, v1, react.createElement(default, {
            clipsDescendants = true,
            isStudded = true,
            textureTransparency = 0.88,
            tileSize = 55,
            transparency = 0.5,
            zIndex = 5,
            anchorPoint = Vector2.new(0.5, 1),
            backgroundColor = p1.barTrack,
            position = UDim2.fromScale(0.5, 1),
            size = UDim2.fromOffset(p1.barWidth, p1.barHeight)
        }, v2, v3, v4, p1.showProgressPercent and react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 10,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(120, p1.barHeight - 8)
            },
            text = p1.progressText
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 11,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromOffset(p1.barWidth, p1.barHeight)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, p1.barCornerRadius)
        }), react.createElement("uistroke", {
            Transparency = 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = p1.barBorderColor,
            Thickness = p1.barBorderThickness
        })))
    end
}
