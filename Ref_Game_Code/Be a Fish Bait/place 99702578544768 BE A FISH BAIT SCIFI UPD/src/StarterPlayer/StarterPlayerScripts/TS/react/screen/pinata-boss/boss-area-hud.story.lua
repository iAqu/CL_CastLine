-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "boss-area-hud").default

local function Story() -- line: 7
    -- upvalues: react (copy), default (copy), default2 (copy)
    local t1 = {
        ["1"] = 420,
        ["2"] = 180,
        ["3"] = 65
    }

    return react.createElement(default, nil, react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        hp = 35,
        maxHp = 50,
        damageContributions = t1,
        despawnTimestamp = os.time() + 90
    })))
end

return storyForScreenGui(react.createElement(Story))
