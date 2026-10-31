-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectPlayerChatTags = function(p1) -- selectPlayerChatTags | line: 2
        return function(p2) -- line: 3
            -- upvalues: p1 (copy)
            return p2.chatTags[p1]
        end
    end
}
