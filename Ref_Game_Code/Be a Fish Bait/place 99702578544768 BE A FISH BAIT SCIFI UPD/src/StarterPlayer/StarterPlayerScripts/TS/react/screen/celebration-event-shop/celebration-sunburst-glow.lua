-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- CelebrationSunburstGlow | line: 10
        -- upvalues: react (copy), useEffect (copy), useRef (copy), TweenService (copy), images (copy)
        local accentColor, animated = p1.accentColor, p1.animated
        local v1 = animated

        if animated == nil then
            v1 = false
        end

        local animatedRayVisible = p1.animatedRayVisible
        local v2 = animatedRayVisible

        if animatedRayVisible == nil then
            v2 = true
        end

        local anchorPoint, clipsDescendants = p1.anchorPoint, p1.clipsDescendants

        if clipsDescendants == nil then
            clipsDescendants = true
        end

        local color, position, size, visible = p1.color, p1.position, p1.size, p1.visible
        local v3 = visible

        if visible == nil then
            v3 = true
        end

        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        local v4 = useRef(nil)

        useEffect(function() -- line: 37
            -- upvalues: v1 (ref), v2 (ref), v3 (ref), v4 (copy), TweenService (copy)
            if not (v1 and v2 and v3) then
                return nil
            end

            local current = v4.current

            if current == nil then
                return nil
            end

            local v5 = true
            local v6, v7

            v7 = function(p2) -- line: 48
                -- upvalues: v7 (ref), current (copy), v5 (ref), v6 (ref), TweenService (copy)
                if not v5 then
                    return nil
                end

                current.Rotation = p2 == 1 and 0 or 360
                v6 = TweenService:Create(current, TweenInfo.new(18, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                    Rotation = p2 == 1 and 360 or 0
                })
                v6.Completed:Once(function() -- line: 56
                    -- upvalues: p2 (copy), v7 (ref)
                    return v7(p2)
                end)
                v6:Play()
            end

            v7(1)

            return function() -- line: 62
                -- upvalues: v5 (ref), v6 (ref)
                v5 = false

                local v9 = v6

                if v9 ~= nil then
                    v9:Cancel()
                end
            end
        end, { v1, v2, v3 })

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = anchorPoint or Vector2.new(0.5, 0.5),
            ClipsDescendants = clipsDescendants,
            Position = position,
            Size = size,
            Visible = v3,
            ZIndex = zIndex
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.46,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = color or Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.36,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = color or accentColor or Color3.fromRGB(255, 210, 120),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.82, 0.82),
            ZIndex = zIndex + 1
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.36,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = color or Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.6, 1.6),
            Visible = v2,
            ZIndex = zIndex + 1,
            ref = v4
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.24,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = color or accentColor or Color3.fromRGB(255, 185, 90),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.42, 1.42),
            ZIndex = zIndex + 2
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })))
    end
}
