-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return require(script.Parent:WaitForChild("DartTitan")).New({
    HEAD = Vector3.new(-0.25, 3, -104.89),
    LENGTH = 205.58,
    KIND = {
        lam = 1.1,
        alpha = 1.8,
        tail = 0.05,
        stride = 1.6,
        stroke = {
            rate = 1.5,
            maxHz = 3,
            amp = 0.62,
            bias = 0.12,
            sweep = 0.22,
            sweepLag = 0.5,
            feather = 0.3,
            lagR = 1.5707963267948966,
            ampR = 0.85
        }
    }
})
