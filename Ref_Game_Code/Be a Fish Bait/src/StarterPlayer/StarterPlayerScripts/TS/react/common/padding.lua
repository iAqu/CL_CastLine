-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local props = RuntimeLib.import(script, script.Parent.Parent, "utils", "props")
local noBackground, fillSize = props.noBackground, props.fillSize

return {
    Padding = function(p1) -- Padding | line: 7
        -- upvalues: react (copy), noBackground (copy), fillSize (copy)
        local t1

        if p1.all ~= nil then
            t1 = {
                type = "all"
            }

            for v3, v4 in p1 do
                t1[v3] = v4
            end
        else
            t1 = {
                type = "specific"
            }

            for v1, v2 in p1 do
                t1[v1] = v2
            end
        end

        local v5 = table.clone(noBackground)

        setmetatable(v5, nil)

        for v6, v7 in fillSize do
            v5[v6] = v7
        end

        local overrideProps = t1.overrideProps

        if overrideProps then
            for v8, v9 in overrideProps do
                v5[v8] = v9
            end
        end

        return react.createElement("frame", v5, react.createElement("uipadding", {
            PaddingBottom = if t1.type == "all" then t1.all else t1.bottom,
            PaddingLeft = if t1.type == "all" then t1.all else t1.left,
            PaddingRight = if t1.type == "all" then t1.all else t1.right,
            PaddingTop = if t1.type == "all" then t1.all else t1.top
        }), p1.children)
    end
}
