-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Run = function(p1, p2, p3) -- Run | line: 16
        task.spawn(function() -- line: 17
            -- upvalues: p1 (copy), p2 (copy), p3 (copy)
            local n1 = 0

            while p3() do
                if not (p1.Visible and p1.AbsoluteSize.Y > 2) then
                    task.wait(0.25)
                else
                    n1 += 1

                    for v1, v2 in ipairs(p2) do
                        local v3 = v2:GetAttribute("Frames") or 16
                        local v4 = v2:GetAttribute("Cols") or 2
                        local v5 = v2:GetAttribute("Cell") or Vector2.new(512, 128)
                        local v6 = (n1 + (v1 - 1) * 7) % v3

                        v2.ImageRectOffset = Vector2.new(v6 % v4 * v5.X, v6 // v4 * v5.Y)
                    end

                    task.wait(0.05)
                end
            end
        end)
    end
}
