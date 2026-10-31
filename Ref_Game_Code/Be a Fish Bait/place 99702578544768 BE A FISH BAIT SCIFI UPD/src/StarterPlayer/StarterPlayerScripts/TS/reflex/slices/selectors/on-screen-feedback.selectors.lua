-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectMostRecentFeedback = function(p1) -- selectMostRecentFeedback | line: 2
        local feedbacks = p1.onScreenFeedback.feedbacks
        local n1 = 0

        for _ in feedbacks do
            n1 += 1
        end

        if n1 == 0 then
            return nil
        end

        local v1

        for _, v2 in feedbacks do
            if v1 == nil or v2.timestamp > v1.timestamp then
                v1 = v2
            end
        end

        return v1
    end
}
