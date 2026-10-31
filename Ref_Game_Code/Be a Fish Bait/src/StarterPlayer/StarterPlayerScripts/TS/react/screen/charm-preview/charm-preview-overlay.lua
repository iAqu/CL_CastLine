-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local charmPreviewCharmIdAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "charm-preview-atom").charmPreviewCharmIdAtom
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function() -- CharmPreviewOverlay | line: 13
        -- upvalues: Flamework (copy), subscribe (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), charmPreviewCharmIdAtom (copy), default (copy), images (copy)
        local v1, v2 = useState(charmPreviewCharmIdAtom())
        local v3 = useRef()

        useEffect(function() -- line: 16
            -- upvalues: v2 (copy), subscribe (copy), charmPreviewCharmIdAtom (copy)
            return subscribe(charmPreviewCharmIdAtom, v2)
        end, {})
        useEffect(function() -- line: 19
            -- upvalues: v3 (copy)
            if v3.current ~= nil then
                v3.current.Name = "CharmPreviewOverlay"
            end
        end, {})

        return react.createElement("screengui", {
            DisplayOrder = 1E+05,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            Enabled = v1 ~= nil,
            ScreenInsets = Enum.ScreenInsets.None,
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ref = v3
        }, react.createElement(default, {
            cornerRadius = 0.22,
            zIndex = 1E+05,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(235, 66, 76),
            onClick = function() -- onClick | line: 36
                -- upvalues: Flamework (copy)
                return Flamework.resolveDependency("client/controllers/charm-preview-controller@CharmPreviewController"):closePreview()
            end,
            popoutColor = Color3.fromRGB(120, 24, 32),
            position = UDim2.new(1, -42, 0, 42),
            size = UDim2.fromOffset(62, 62),
            strokeColor = Color3.new(1, 1, 1)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 100003,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.crossIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.48, 0.48)
        })))
    end
}
