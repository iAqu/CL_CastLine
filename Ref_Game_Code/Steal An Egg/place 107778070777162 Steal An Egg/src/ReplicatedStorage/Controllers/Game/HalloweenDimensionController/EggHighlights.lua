-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    new = function() -- new | line: 3
        local t1 = {}

        local function clear(p1) -- line: 5
            -- upvalues: t1 (copy)
            local v1 = t1[p1]

            t1[p1] = nil

            if v1 ~= nil then
                v1:Destroy()
            end
        end

        local function destroy() -- line: 12
            -- upvalues: t1 (copy)
            for v2 in t1 do
                local v3 = t1[v2]

                t1[v2] = nil

                if v3 ~= nil then
                    v3:Destroy()
                end
            end
        end

        return {
            Step = function(p2, p3, p4) -- step | line: 17
                -- upvalues: t1 (copy)
                local WorldEggs = if p2 == nil then nil else p2:FindFirstChild("WorldEggs")

                if p3 and p4 ~= nil and WorldEggs ~= nil then
                    local t2 = {}

                    for _, child in WorldEggs:GetChildren() do
                        if child:IsA("Model") and type(child:GetAttribute("HalloweenEggUid")) == "string" then
                            local v4 = child:FindFirstChild("StealPrompt", true)
                            local Magnitude = (child:GetPivot().Position - p4).Magnitude

                            if v4 ~= nil and v4:IsA("ProximityPrompt") and v4.Enabled and not (Magnitude <= v4.MaxActivationDistance) and not (Magnitude > 250) then
                                t2[child] = true

                                if t1[child] == nil then
                                    local Highlight = Instance.new("Highlight")

                                    Highlight.Name = "HalloweenEggDistanceHighlight"
                                    Highlight.Adornee = child
                                    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    Highlight.FillTransparency = 1
                                    Highlight.OutlineTransparency = 0.15
                                    Highlight.OutlineColor = Color3.new(1, 1, 1)
                                    Highlight.Parent = child
                                    t1[child] = Highlight
                                end
                            end
                        end
                    end

                    for v5 in t1 do
                        if not t2[v5] then
                            local v6 = t1[v5]

                            t1[v5] = nil

                            if v6 ~= nil then
                                v6:Destroy()
                            end
                        end
                    end
                else
                    for v7 in t1 do
                        local v8 = t1[v7]

                        t1[v7] = nil

                        if v8 ~= nil then
                            v8:Destroy()
                        end
                    end
                end
            end,
            Destroy = destroy
        }
    end
}
