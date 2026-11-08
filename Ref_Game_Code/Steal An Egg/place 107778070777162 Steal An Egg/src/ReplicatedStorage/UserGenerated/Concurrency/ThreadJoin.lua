-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function ThreadJoin(p1, p2) -- line: 20
    local elapsed = os.clock()

    while coroutine.status(p1) ~= "dead" do
        if p2 ~= nil and p2 <= os.clock() - elapsed then
            return false
        end

        task.wait()
    end

    return true
end

return ThreadJoin
