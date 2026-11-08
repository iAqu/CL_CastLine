-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

task.spawn(function() -- line: 1
    while true do
        local v1 = task.wait()
        local Pivot = script.Parent:GetPivot()

        script.Parent:PivotTo(Pivot * CFrame.fromEulerAnglesYXZ(0, 6.283185307179586 * v1, 0))
    end
end)
