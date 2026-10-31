-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "exclusive-shop-section").default

return {
    default = function(p1) -- SmallShopSection | line: 9
        -- upvalues: react (copy), default (copy)
        return react.createElement(default, {
            contentNode = p1.children,
            layoutOrder = p1.layoutOrder,
            sectionType = p1.sectionType,
            size = p1.size or UDim2.fromScale(1.05, 1.7),
            zIndex = p1.zIndex
        })
    end
}
