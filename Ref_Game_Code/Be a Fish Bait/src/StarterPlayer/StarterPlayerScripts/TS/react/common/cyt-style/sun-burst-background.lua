-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- SunBurstBackground | line: 8
        -- upvalues: useMotion (copy), react (copy), useEffect (copy), images (copy)
        local v1, v2 = useMotion(0)

        useEffect(function() -- line: 11
            -- upvalues: p1 (copy), v2 (copy)
            if not p1.doRotate then
                return nil
            end

            v2:linear(360, {
                speed = 20
            })

            local v3 = v2:onComplete(function() -- line: 21
                -- upvalues: v2 (copy)
                v2:immediate(0)
                v2:linear(360, {
                    speed = 20
                })
            end)

            return function() -- line: 25
                -- upvalues: v3 (copy)
                v3()
            end
        end, {
            p1.doRotate,
            v2
        })

        local t1 = {
            BackgroundTransparency = 1,
            AnchorPoint = p1.anchorPoint
        }
        local image = p1.image

        t1.Image = if image == nil then images.sunburstBackground else image
        t1.ImageColor3 = p1.imageColor3 or Color3.fromRGB(255, 255, 255)

        local imageTransparency = p1.imageTransparency

        t1.ImageTransparency = if imageTransparency == nil then 0 else imageTransparency
        t1.Position = p1.position
        t1.Rotation = v1
        t1.Size = p1.size
        t1.ZIndex = p1.zIndex

        return react.createElement("imagelabel", t1, p1.children, if p1.uiAspectRatio == nil then nil else react.createElement("uiaspectratioconstraint", {
            AspectRatio = p1.uiAspectRatio
        }))
    end
}
