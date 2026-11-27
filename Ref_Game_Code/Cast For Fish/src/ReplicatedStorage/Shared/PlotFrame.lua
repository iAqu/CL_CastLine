-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Of = function(p1) -- Of | line: 11
        local Gate = p1 and p1:GetAttribute("Gate")

        if typeof(Gate) == "CFrame" then
            return Gate
        end

        local v1

        if not p1 then
            v1 = 3

            return CFrame.new((v1 - 3) * 48, 0, 94)
        end

        v1 = tonumber(string.match(p1.Name, "%d+")) or 3

        return CFrame.new((v1 - 3) * 48, 0, 94)
    end,
    Plot = function(p2) -- Plot | line: 20
        if type(p2) ~= "number" then
            return nil
        end

        local World = workspace:FindFirstChild("World")
        local Plots = World and World:FindFirstChild("Plots")

        return Plots and Plots:FindFirstChild("Plot" .. tostring(p2)) or nil
    end
}

function t1.ById(p3) -- line: 29
    -- upvalues: t1 (copy)
    local v2 = t1.Plot(p3)

    return if v2 then t1.Of(v2) else nil
end

function t1.BackLimit(p4) -- line: 35
    return p4 and p4:GetAttribute("BackLimit") or 166
end

return t1
