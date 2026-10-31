-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService

return {
    default = function(p1) -- ScrollingImage | line: 8
        -- upvalues: react (copy), useEffect (copy), useRef (copy), TweenService (copy)
        local v1 = useRef(nil)
        local v2 = useRef(nil)

        useEffect(function() -- line: 11
            -- upvalues: p1 (copy), v1 (copy), v2 (copy), TweenService (copy)
            local current = v2.current

            if not current then
                return nil
            end

            local v3 = UDim2.fromScale(-0.2, 0.5)
            local v4 = UDim2.fromScale(1, 0.5)
            local v5 = TweenInfo.new(p1.speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
            local v6

            v6 = function() -- line: 20
                -- upvalues: v6 (ref), current (copy), v3 (copy), v4 (copy), v5 (copy), v1 (copy), TweenService (copy)
                current.Position = v3

                local v7 = TweenService:Create(current, v5, {
                    Position = v4
                })

                v1.current = v7
                v7.Completed:Connect(function() -- line: 28
                    -- upvalues: v6 (ref)
                    v6()
                end)
                v7:Play()
            end

            v6()

            return function() -- line: 37
                -- upvalues: v1 (copy)
                if v1.current then
                    v1.current:Cancel()
                    v1.current = nil
                end
            end
        end, { p1.speed })

        local t1 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Image = p1.imageId,
            Size = p1.imageSize or UDim2.fromScale(1, 1),
            ref = v2
        }
        local imageProperties = p1.imageProperties

        if imageProperties then
            for v8, v9 in imageProperties do
                t1[v8] = v9
            end
        end

        t1.ImageTransparency = 0.2

        local zIndex = p1.zIndex

        t1.ZIndex = if zIndex == nil then 2 else zIndex

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("imagelabel", t1))
    end
}
