-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")

return {
    default = function(p1) -- StyledTabButton | line: 5
        -- upvalues: react (copy)
        local text, isActive, onClick, overrideProps = p1.text, p1.isActive, p1.onClick, p1.overrideProps
        local t1 = {
            AutoButtonColor = not isActive,
            Event = {
                Activated = onClick
            }
        }

        if overrideProps then
            for v1, v2 in overrideProps do
                t1[v1] = v2
            end
        end

        t1.BackgroundTransparency = 0.8
        t1.Image = "http://www.roblox.com/asset/?id=84388792338652"
        t1.ScaleType = "Crop"

        return react.createElement("imagebutton", t1, react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Font = "FredokaOne",
            TextScaled = true,
            ZIndex = 3,
            Size = UDim2.fromScale(1, 1),
            Text = text,
            TextColor3 = Color3.new(1, 1, 1)
        }, react.createElement("uistroke", {
            Thickness = 1,
            Color = Color3.new(0, 0, 0)
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = 18,
            MinTextSize = 8
        })))
    end
}
