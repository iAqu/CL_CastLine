-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local _ = RuntimeLib.import(script, script.Parent, "nibbling-text").default
local _ = RuntimeLib.import(script, script.Parent, "bonus-text").default
local t1 = {
    Color3.fromRGB(255, 220, 0),
    Color3.fromRGB(255, 155, 0),
    Color3.fromRGB(255, 90, 0)
}

return {
    default = function(p1) -- FishNibbleScreen | line: 17
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), ReplicatedStorage (copy), useConfig (copy), images (copy), t1 (copy)
        local bonusComboCount = p1.bonusComboCount
        local v1 = bonusComboCount

        if bonusComboCount == nil then
            v1 = 0
        end

        local caughtFish = p1.caughtFish
        local getSound = useConfig().getSound
        local v2 = useCallback(function(p2) -- line: 25
            -- upvalues: getSound (copy)
            local BonusUpgrade = getSound("BonusUpgrade")

            BonusUpgrade.PlaybackSpeed = 0.8 + (p2 - 1) * 0.2
            BonusUpgrade:Play()
        end, { getSound })
        local v3 = caughtFish ~= nil
        local v4, v5 = useState(0)
        local _, v6 = useState(false)
        local v7 = useRef(0)

        useEffect(function() -- line: 35
            -- upvalues: caughtFish (copy), ReplicatedStorage (copy)
            if caughtFish == nil then
                return nil
            end

            local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

            if Sounds ~= nil then
                Sounds = Sounds:FindFirstChild("sfx")

                if Sounds ~= nil then
                    Sounds = Sounds:FindFirstChild("SkillCheckSuccess")
                end
            end

            if if Sounds == nil then Sounds else Sounds:IsA("Sound") then
                Sounds:Play()
            end
        end, { caughtFish })
        useEffect(function() -- line: 56
            -- upvalues: v1 (ref), v2 (copy), v7 (copy)
            local current = v7.current

            v7.current = v1

            if v1 <= current then
                return nil
            end

            v2(v1)
        end, { v1, v2 })
        useEffect(function() -- line: 65
            -- upvalues: v1 (ref), v6 (copy)
            if v1 < 3 then
                v6(false)

                return nil
            end

            local v8 = task.delay(0.9, function() -- line: 70
                -- upvalues: v6 (copy)
                return v6(true)
            end)

            return function() -- line: 73
                -- upvalues: v8 (copy)
                return task.cancel(v8)
            end
        end, { v1 })
        useEffect(function() -- line: 78
            -- upvalues: v1 (ref), v5 (copy), v3 (copy)
            if v3 then
                v5(0)

                return nil
            end

            v5(if v1 > 3 then 3 else v1)
        end, { v1, v3 })

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v4 > 0 and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.screenBorder,
            ImageColor3 = t1[v4],
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }), not v3 and nil)
    end
}
