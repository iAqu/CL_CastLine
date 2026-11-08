-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Types.Interface)

return {
    BindOnAdapterChanged = function(p1, p2, p3) -- BindOnAdapterChanged | line: 16
        local connection = p1.Changed:Connect(function() -- line: 21
            -- upvalues: p1 (copy), p2 (copy), p3 (copy)
            if p2(p1) then
                p3()
            end
        end)

        task.defer(function() -- line: 27
            -- upvalues: p1 (copy), p2 (copy), p3 (copy)
            if p2(p1) then
                p3()
            end
        end)

        return function() -- line: 33
            -- upvalues: connection (copy)
            connection:Disconnect()
        end
    end
}
