-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local memo, useMemo = react.memo, react.useMemo
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService

return {
    default = memo(function(p1) -- QteKeyImage | line: 9
        -- upvalues: react (copy), useMemo (copy), UserInputService (copy)
        local gap = p1.gap

        if gap == nil then
            gap = 8
        end

        local keyCode, position, radius = p1.keyCode, p1.position, p1.radius

        if radius == nil then
            radius = 0
        end

        local size = p1.size

        if size == nil then
            size = 32
        end

        local visible = p1.visible

        if visible == nil then
            visible = true
        end

        local v1 = useMemo(function() -- line: 28
            -- upvalues: keyCode (copy), UserInputService (copy)
            return UserInputService:GetImageForKeyCode(keyCode)
        end, { keyCode })

        return react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0.5, 0),
            Image = v1,
            Position = position or UDim2.new(0.5, 0, 0.5, radius + gap),
            Size = UDim2.fromOffset(size, size),
            Visible = visible
        })
    end)
}
