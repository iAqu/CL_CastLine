-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent, "context", "theme-context").ThemeContext

return {
    default = function(p1) -- StyledTextButton | line: 7
        -- upvalues: react (copy), useContext (copy), ThemeContext (copy)
        local v1 = useContext(ThemeContext)
        local t1 = {}
        local overrideProps = p1.overrideProps

        if overrideProps then
            for v2, v3 in overrideProps do
                t1[v2] = v3
            end
        end

        t1.Font = v1.textFont
        t1.Text = p1.text

        return react.createElement("textbutton", t1, p1.children)
    end
}
