-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")

return {
    new = function(p1, p2, p3) -- new | line: 5
        -- upvalues: Players (copy)
        local t2 = {}
        local t3 = {}
        local t4 = {}
        local n1 = -1
        local v1 = false
        local t5 = {}

        local function discard(p4) -- line: 10
            -- upvalues: p3 (copy), t4 (copy)
            local v2 = t4[p4]

            if not v2 then
                return
            end

            p3(v2)
            v2:Destroy()
            t4[p4] = nil
        end

        local function update(p5, p6) -- line: 14
            for v3, v4 in p6.Attributes do
                p5:SetAttribute(v3, v4)
            end

            local Hitbox, Hitbox2 = p5.Hitbox, p5.Hitbox
            local CFrame, Size = p6.CFrame, p6.Size

            Hitbox.CFrame = CFrame
            Hitbox2.Size = Size
            p5.Hitbox:SetAttribute("MaxHealth", p6.MaxHealth)
            p5.Hitbox:SetAttribute("Health", p6.Health)
        end

        function t2.Apply(p7) -- line: 20
            -- upvalues: p3 (copy), t2 (copy), t3 (copy), t4 (copy), n1 (ref), v1 (ref), t5 (copy), update (copy), Players (copy)
            if type(p7) ~= "table" or p7.OwnerUserId ~= Players.LocalPlayer.UserId then
                return
            end

            if type(p7.Revision) == "number" and not (p7.Revision <= n1) then
                if v1 or p7.Full then
                    v1 = true
                    n1 = p7.Revision

                    if p7.Full then
                        local t6 = {}

                        for _, v5 in p7.Upserts do
                            t6[v5.Id] = true
                        end

                        for v6 in t3 do
                            if not t6[v6] then
                                local v7 = t4[v6]

                                if v7 then
                                    p3(v7)
                                    v7:Destroy()
                                    t4[v6] = nil
                                end

                                t3[v6] = nil
                            end
                        end
                    end

                    for _, v8 in p7.Removed or {} do
                        local v9 = t4[v8]

                        if v9 then
                            p3(v9)
                            v9:Destroy()
                            t4[v8] = nil
                        end

                        t3[v8] = nil
                    end

                    for _, v10 in p7.Upserts or {} do
                        if v10.OwnerUserId == Players.LocalPlayer.UserId then
                            t3[v10.Id] = v10

                            if t4[v10.Id] then
                                update(t4[v10.Id], v10)
                            end
                        end
                    end

                    if next(t5) then
                        local t7 = {}

                        for _, v11 in t5 do
                            table.insert(t7, v11)
                        end

                        table.clear(t5)
                        table.sort(t7, function(p8, p9) -- line: 45
                            return p8.Revision < p9.Revision
                        end)

                        for _, v12 in t7 do
                            t2.Apply(v12)
                        end
                    end
                else
                    t5[p7.Revision] = p7
                end
            end
        end

        function t2.Tick() -- line: 49
            -- upvalues: p1 (copy), p2 (copy), p3 (copy), t3 (copy), t4 (copy), update (copy)
            local CurrentCamera = workspace.CurrentCamera

            if not CurrentCamera then
                return
            end

            local ServerTimeNow = workspace:GetServerTimeNow()
            local t8 = {}

            for v13, v14 in t3 do
                if v14.ExpiresAt and v14.ExpiresAt <= ServerTimeNow then
                    local v15 = t4[v13]

                    if v15 then
                        p3(v15)
                        v15:Destroy()
                        t4[v13] = nil
                    end

                    t3[v13] = nil
                else
                    local Magnitude = (CurrentCamera.CFrame.Position - v14.CFrame.Position).Magnitude

                    if Magnitude <= 180 then
                        table.insert(t8, {
                            Id = v13,
                            Distance = Magnitude
                        })
                    end
                end
            end

            table.sort(t8, function(p10, p11) -- line: 60
                return p10.Distance < p11.Distance
            end)

            local t10 = {}

            for i = 1, math.min(32, #t8) do
                t10[t8[i].Id] = true
            end

            for v17 in t4 do
                if not t10[v17] then
                    local v18 = t4[v17]

                    if v18 then
                        p3(v18)
                        v18:Destroy()
                        t4[v17] = nil
                    end
                end
            end

            for v19 in t10 do
                if not t4[v19] then
                    local v20 = t3[v19]
                    local Model = Instance.new("Model")

                    Model.Name = "PersonalDrone_" .. v19

                    local Part = Instance.new("Part")

                    Part.Name = "Hitbox"
                    Part.Anchored = true
                    Part.Transparency = 1
                    Part.CanCollide = false
                    Part.CanTouch = false
                    Part.CanQuery = false
                    Part.Parent = Model
                    Model.PrimaryPart = Part
                    update(Model, v20)
                    Model.Parent = p1
                    t4[v19] = Model
                    p2(Model)
                end
            end
        end

        function t2.Ready() -- line: 81
            -- upvalues: v1 (ref)
            return v1
        end

        function t2.Destroy() -- line: 82
            -- upvalues: p3 (copy), t3 (copy), t4 (copy)
            for v21 in t4 do
                local v22 = t4[v21]

                if v22 then
                    p3(v22)
                    v22:Destroy()
                    t4[v21] = nil
                end
            end

            table.clear(t3)
        end

        return t2
    end
}
