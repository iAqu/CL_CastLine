-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Workspace = game:GetService("Workspace")
local UnixTimestamp = DateTime.fromUniversalTime(2026, 10, 28, 15).UnixTimestamp
local t1 = {
    SeenKey = "ConcertReveal20261028",
    ConcertAt = DateTime.fromUniversalTime(2026, 10, 31, 15).UnixTimestamp
}

function t1.Override() -- line: 16
    -- upvalues: Workspace (copy)
    local ConcertRevealAt = Workspace:GetAttribute("ConcertRevealAt")

    return if type(ConcertRevealAt) == "number" then ConcertRevealAt else nil
end

function t1.RevealAt() -- line: 21
    -- upvalues: UnixTimestamp (copy), t1 (copy)
    return t1.Override() or UnixTimestamp
end

function t1.SetOverride(p1) -- line: 25
    -- upvalues: Workspace (copy)
    Workspace:SetAttribute("ConcertRevealAt", p1)
end

return t1
