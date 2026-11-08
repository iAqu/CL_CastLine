-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t2 = {
    ScreenGui = "Enabled",
    BillboardGui = "Enabled",
    SurfaceGui = "Enabled"
}
local t1 = {
    Watch = function(p1, p2, p3) -- Watch | line: 26
        -- upvalues: t2 (copy)
        if typeof(p1) ~= "Instance" or not p1:IsA("GuiBase") then
            return nil
        end

        local t3 = {}
        local t4

        local function shiftHidden(p4) -- line: 34
            -- upvalues: p2 (copy), p3 (copy), t4 (ref)
            local t5 = t4

            t5.hidden += p4

            if not (t4.hidden > 0) or t4.isMuted then
                if t4.hidden == 0 and t4.isMuted then
                    t4.isMuted = false
                    p3()
                end
            else
                t4.isMuted = true
                p2()
            end
        end

        t4 = {
            hidden = 0,
            isMuted = false,
            links = t3,
            Destroy = function() -- Destroy | line: 50
                -- upvalues: t3 (copy), t4 (ref)
                for _, v1 in ipairs(t3) do
                    v1:Disconnect()
                end

                table.clear(t4)
            end
        }

        local v2 = p1

        while v2 and v2:IsA("GuiBase") do
            local v3 = t2[v2.ClassName]

            if not v3 then
                v3 = if v2:IsA("GuiObject") then "Visible" else nil
            end

            if v3 then
                if not v2[v3] then
                    local v4 = t4.hidden + 1

                    t4.hidden = v4

                    if not (t4.hidden > 0) or t4.isMuted then
                        local t9 = t4

                        if t9.hidden == 0 then
                            local t10 = t4

                            if t10.isMuted then
                                t4.isMuted = false
                                p3()
                            end
                        end
                    else
                        t4.isMuted = true
                        p2()
                    end
                end

                local v5 = #t3 + 1
                local PropertyChangedSignal = v2:GetPropertyChangedSignal(v3)
                local v6 = v2
                local v7 = v3

                t3[v5] = PropertyChangedSignal:Connect(function() -- line: 70
                    -- upvalues: p2 (copy), p3 (copy), t4 (ref), v6 (copy), v7 (copy)
                    local v8 = if v6[v7] then -1 else 1

                    t4.hidden += v8

                    if not (t4.hidden > 0) or t4.isMuted then
                        if t4.hidden == 0 and t4.isMuted then
                            t4.isMuted = false
                            p3()
                        end
                    else
                        t4.isMuted = true
                        p2()
                    end
                end)
            end

            v2 = v2.Parent
        end

        return t4
    end
}

return table.freeze(t1)
