-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local getLetterData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "letters").getLetterData
local default = RuntimeLib.import(script, script.Parent, "letter-window").default

return {
    default = function() -- LetterWindowManager | line: 11
        -- upvalues: react (copy), useCallback (copy), useRootProducer (copy), useRootSelector (copy), getLetterData (copy), default (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(function(p1) -- line: 13
            return p1.letterUi.selectedLetterId
        end)
        local v3 = if v2 == nil then nil else getLetterData(v2)
        local v4 = useCallback(function() -- line: 17
            -- upvalues: v1 (copy)
            v1.windowClosed({})
            v1.letterCleared({})
        end, { v1 })

        if v3 then
            return react.createElement(default, {
                bodyRichText = v3.bodyRichText,
                onClose = v4,
                recipientColor = v3.recipientColor,
                recipientName = v3.recipientName
            })
        end

        return nil
    end
}
