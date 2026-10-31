-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local getHallOfFameScreenshotData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "hall-of-fame-screenshots").getHallOfFameScreenshotData

return {
    default = function(p1) -- HallOfFameScreenshotSurfaceGui | line: 8
        -- upvalues: react (copy), createPortal (copy), default (copy), getHallOfFameScreenshotData (copy)
        local boardPart = p1.boardPart
        local v1 = getHallOfFameScreenshotData(p1.screenshotId)

        if not v1 then
            return nil
        end

        return createPortal(react.createElement("surfacegui", {
            LightInfluence = 0,
            PixelsPerStud = 50,
            ResetOnSpawn = false,
            Adornee = boardPart,
            Face = Enum.NormalId.Front,
            SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        }, react.createElement("frame", {
            BackgroundColor3 = Color3.fromRGB(10, 10, 15),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Image = v1.imageAssetId,
            ScaleType = Enum.ScaleType.Fit,
            Size = if v1.caption == nil then UDim2.fromScale(0.94, 0.94) else UDim2.fromScale(0.94, 0.8)
        }), v1.caption ~= nil and react.createElement(default, {
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = true,
                TextWrapped = true,
                Size = UDim2.fromScale(0.94, 0.15),
                TextColor3 = Color3.new(1, 1, 1)
            },
            strokeProps = {
                Thickness = 1
            },
            text = v1.caption
        }))), boardPart)
    end
}
