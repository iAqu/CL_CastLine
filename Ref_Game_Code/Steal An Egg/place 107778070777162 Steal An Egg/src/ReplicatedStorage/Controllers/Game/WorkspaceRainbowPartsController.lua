-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local v1 = require(ReplicatedStorage.Packages.Log).new()

return {
    Start = function() -- Start | line: 32
        -- upvalues: CollectionService (copy), ReplicatedStorage (copy), RunService (copy), v1 (copy)
        local t2 = {}
        local t3 = {}
        local t4 = {}
        local t5 = {}

        t5[1] = 1

        local n1 = 0
        local v2 = false
        local n2 = 0
        local n3 = 1
        local elapsed = os.clock()

        local function getTargetColor(p1) -- line: 44
            if p1:IsA("BasePart") then
            end

            return p1.Color
        end

        local function setTargetColor(p2, p3) -- line: 51
            if p2:IsA("BasePart") then
            end

            p2.Color = p3
        end

        local function getOriginalHsv(p4) -- line: 59
            local OriginalColor = p4:GetAttribute("OriginalColor")

            if typeof(OriginalColor) == "Vector3" then
                return OriginalColor
            end

            local v3, v4, v5 = Color3.toHSV(p4.Color)
            local v6 = Vector3.new(v3, v4, v5)

            p4:SetAttribute("OriginalColor", v6)

            return v6
        end

        local function addTarget(p5) -- line: 71
            -- upvalues: t2 (copy), t3 (copy)
            if t3[p5] ~= nil then
                return
            end

            if typeof((p5:GetAttribute("OriginalColor"))) ~= "Vector3" then
                local v7, v8, v9 = Color3.toHSV(p5.Color)

                p5:SetAttribute("OriginalColor", (Vector3.new(v7, v8, v9)))
            end

            table.insert(t2, p5)
            t3[p5] = #t2
        end

        local function removeTarget(p6) -- line: 81
            -- upvalues: t2 (copy), t3 (copy), n3 (ref), v1 (copy)
            local v10 = t3[p6]

            if v10 ~= nil then
                local OriginalColor = p6:GetAttribute("OriginalColor")

                if typeof(OriginalColor) == "Vector3" then
                    local v11 = Color3.fromHSV(OriginalColor.X, OriginalColor.Y, OriginalColor.Z)

                    if p6:IsA("BasePart") then
                    end

                    p6.Color = v11
                end

                local v13 = t2[#t2]

                t2[v10] = v13
                t3[v13] = v10
                table.remove(t2)
                t3[p6] = nil

                local v14 = n3

                if v14 > #t2 then
                    n3 = 1
                end
            else
                v1:AtWarning():Log((("Rainbow target %* not found in active targets."):format((p6:GetFullName()))))
            end
        end

        local function drainQueue() -- line: 105
            -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy), n1 (ref), v2 (ref), removeTarget (copy)
            while t5[1] <= n1 do
                local v15 = t4[t5[1]]

                t5[1] += 1

                if v15.Add then
                    local Target = v15.Target

                    if t3[Target] == nil then
                        if typeof((Target:GetAttribute("OriginalColor"))) ~= "Vector3" then
                            local v16, v17, v18 = Color3.toHSV(Target.Color)

                            Target:SetAttribute("OriginalColor", (Vector3.new(v16, v17, v18)))
                        end

                        table.insert(t2, Target)
                        t3[Target] = #t2
                    end
                else
                    removeTarget(v15.Target)
                end
            end

            table.clear(t4)
            t5[1] = 1
            n1 = 0
            v2 = false
        end

        local function requireRainbowTarget(p7) -- line: 136
            assert(p7:IsA("BasePart") or p7:IsA("SurfaceAppearance"), (("RainbowPart tag requires a BasePart or SurfaceAppearance, got %*"):format(p7.ClassName)))

            return p7
        end

        local function preRender(p8) -- line: 144
            -- upvalues: t2 (copy), n2 (ref), n3 (ref), elapsed (copy)
            local v22 = n2

            n2 = math.min(v22 + math.min(p8, 0.06666666666666667), 0.25)

            if n2 < 0.05 then
                return
            end

            n2 -= 0.05

            local v23 = #t2

            if v23 == 0 then
                return
            end

            debug.profilebegin("WorkspaceRainbowParts :: PreRender")

            local v24 = (os.clock() - elapsed) * 0.5 % 1
            local v26 = math.min(n3 + 50 - 1, v23)

            for i = n3, v26 do
                local v28 = t2[i]

                if v28.Parent ~= nil then
                    local OriginalColor = v28:GetAttribute("OriginalColor")

                    if typeof(OriginalColor) ~= "Vector3" then
                        local v29, v30, v31 = Color3.toHSV(v28.Color)

                        OriginalColor = Vector3.new(v29, v30, v31)
                        v28:SetAttribute("OriginalColor", OriginalColor)
                    end

                    local Y, Z = OriginalColor.Y, OriginalColor.Z

                    if Y <= 0.05 then
                        if Z >= 0.9725490196078431 then
                            Z = 1
                        end

                        Y = 1
                    end

                    local RainbowOffset = v28:GetAttribute("RainbowOffset")
                    local v32 = if type(RainbowOffset) == "number" then (v24 + RainbowOffset) % 1 else v24
                    local v33 = Color3.fromHSV(v32, Y, Z)

                    if v28:IsA("BasePart") then
                    end

                    v28.Color = v33
                end
            end

            n3 = v26 + 1

            if v23 < n3 then
                n3 = 1
            end

            debug.profileend()
        end

        CollectionService:GetInstanceAddedSignal("RainbowPart"):Connect(function(p9) -- line: 187
            -- upvalues: t4 (copy), n1 (ref), v2 (ref), drainQueue (copy), ReplicatedStorage (copy)
            if p9:IsDescendantOf(ReplicatedStorage) then
                return
            end

            assert(p9:IsA("BasePart") or p9:IsA("SurfaceAppearance"), (("RainbowPart tag requires a BasePart or SurfaceAppearance, got %*"):format(p9.ClassName)))
            n1 += 1
            t4[n1] = {
                Add = true,
                Target = p9
            }

            if not v2 then
                v2 = true
                task.defer(drainQueue)
            end
        end)
        CollectionService:GetInstanceRemovedSignal("RainbowPart"):Connect(function(p10) -- line: 194
            -- upvalues: t4 (copy), n1 (ref), v2 (ref), drainQueue (copy), ReplicatedStorage (copy)
            if p10:IsDescendantOf(ReplicatedStorage) then
                return
            end

            assert(p10:IsA("BasePart") or p10:IsA("SurfaceAppearance"), (("RainbowPart tag requires a BasePart or SurfaceAppearance, got %*"):format(p10.ClassName)))
            n1 += 1
            t4[n1] = {
                Add = false,
                Target = p10
            }

            if not v2 then
                v2 = true
                task.defer(drainQueue)
            end
        end)

        for _, v40 in CollectionService:GetTagged("RainbowPart") do
            if not v40:IsDescendantOf(ReplicatedStorage) then
                assert(v40:IsA("BasePart") or v40:IsA("SurfaceAppearance"), (("RainbowPart tag requires a BasePart or SurfaceAppearance, got %*"):format(v40.ClassName)))

                if t3[v40] == nil then
                    if typeof((v40:GetAttribute("OriginalColor"))) ~= "Vector3" then
                        local v43, v44, v45 = Color3.toHSV(v40.Color)

                        v40:SetAttribute("OriginalColor", (Vector3.new(v43, v44, v45)))
                    end

                    table.insert(t2, v40)
                    t3[v40] = #t2
                end
            end
        end

        RunService.PreRender:Connect(preRender)
    end
}
