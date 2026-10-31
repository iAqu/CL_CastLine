-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState

return {
    default = function(p1) -- SearchBar | line: 7
        -- upvalues: react (copy), useState (copy)
        local v1, v2 = useState("")

        local function v3(p2) -- line: 9
            -- upvalues: p1 (copy), v2 (copy)
            v2(p2.Text)
            p1.onQueryChanged(p2.Text)
        end

        local t1 = {
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            AnchorPoint = p1.anchorPoint or Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }
        local layoutOrder = p1.layoutOrder

        t1.LayoutOrder = if layoutOrder == nil then 0 else layoutOrder
        t1.Position = p1.position or UDim2.fromScale(0, 0)
        t1.Size = p1.size or UDim2.fromScale(0.25, 0.55)

        local zIndex = p1.zIndex

        t1.ZIndex = if zIndex == nil then 1 else zIndex

        local v4 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.1, 0)
        })
        local v5 = react.createElement("uistroke", {
            Thickness = 1,
            Transparency = 0.7,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(255, 255, 255)
        })
        local t2 = {
            BackgroundTransparency = 1,
            ClearTextOnFocus = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Change = {
                Text = v3
            },
            Font = Enum.Font.GothamBold,
            PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
        }
        local placeholder = p1.placeholder

        t2.PlaceholderText = if placeholder == nil then "Search..." else placeholder
        t2.Position = UDim2.fromScale(0.5, 0.5)
        t2.Size = UDim2.fromScale(0.9, 0.8)
        t2.Text = v1
        t2.TextColor3 = Color3.fromRGB(255, 255, 255)
        t2.TextScaled = true

        local zIndex2 = p1.zIndex

        if zIndex2 == nil then
            zIndex2 = 1
        end

        t2.ZIndex = zIndex2 + 1

        return react.createElement("frame", t1, v4, v5, react.createElement("textbox", t2))
    end
}
