-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useFlameworkComponents = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-flamework-components").useFlameworkComponents
local default = RuntimeLib.import(script, script.Parent, "hall-of-fame-chat-surface-gui").default

return {
    default = function() -- HallOfFameChatSurfaceGuiManager | line: 6
        -- upvalues: react (copy), useFlameworkComponents (copy), default (copy)
        local v1 = useFlameworkComponents(function() -- line: 7
            return true
        end, "client/components/hall-of-fame-chat-board-component@HallOfFameChatBoardComponent")
        local v2 = table.create(#v1)

        local function v3(p1) -- line: 12
            -- upvalues: react (copy), default (copy)
            return react.createElement(default, {
                boardPart = p1.instance,
                key = tostring(p1.instance)
            })
        end

        for v4, v5 in v1 do
            local _ = v4 - 1

            v2[v4] = react.createElement(default, {
                boardPart = v5.instance,
                key = tostring(v5.instance)
            })
        end

        return react.createElement(react.Fragment, nil, v2)
    end
}
