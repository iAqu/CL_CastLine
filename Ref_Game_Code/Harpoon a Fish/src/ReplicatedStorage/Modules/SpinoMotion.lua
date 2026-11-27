-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return require(script.Parent:WaitForChild("DartTitan")).New({
    HEAD = Vector3.new(-0.1, 0.2, -104.2),
    LENGTH = 211.07,
    KIND = {
        lam = 1.05,
        alpha = 1.9,
        tail = 0.13,
        stride = 0.8,
        finAmp = 0.18,
        finRate = 0.5,
        bite = {
            gape = 0.14,
            lift = 0.04,
            shut = 0.3,
            snap = 0.09,
            hold = 0.12,
            reopen = 0.5,
            every = { 2.8, 4.6 }
        }
    }
})
