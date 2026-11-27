-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishModels = require(ReplicatedStorage:WaitForChild("Shared").FishModels)
local DataClient = require(script.Parent.DataClient)
local t2 = {}
local t3 = {}
local v1 = false
local t1 = {}

t1.Count = 0

local function clear(p1) -- line: 17
    -- upvalues: t1 (copy), t2 (copy)
    local v2 = t2[p1]

    if not v2 then
        return
    end

    t2[p1] = nil
    v2.model:Destroy()
    t1.Count -= 1
end

local function refresh(p2) -- line: 26
    -- upvalues: FishModels (copy), t1 (copy), t2 (copy), t3 (copy), v1 (ref), refresh (copy)
    local HeldId = p2:GetAttribute("HeldId")
    local v3 = p2:GetAttribute("HeldV") or 1
    local v4 = p2:GetAttribute("HeldS") or 1
    local v5 = if HeldId then HeldId .. "/" .. v3 .. "/" .. v4 else nil
    local v6 = t2[p2]

    if v6 and v6.key == v5 then
        return
    end

    local v7 = t2[p2]

    if v7 then
        t2[p2] = nil
        v7.model:Destroy()
        t1.Count -= 1
    end

    if not v1 and HeldId then
        if FishModels.Has(HeldId) then
            t3[p2] = nil

            local v8 = FishModels.Get(HeldId, v3, v4)
            local _, BoundingBox = v8:GetBoundingBox()
            local v9 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z, 0.1)

            v8:ScaleTo(v8:GetScale() * math.max(v9, 2.2) / v9)
            v8:PivotTo(CFrame.new())

            local _, BoundingBox2 = v8:GetBoundingBox()
            local v10 = FishModels.CenterOffset(v8)

            for _, descendant in ipairs(v8:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                    descendant.CanTouch = false
                    descendant.CastShadow = false
                elseif descendant:IsA("Texture") or descendant:IsA("PointLight") then
                    descendant:Destroy()
                end
            end

            local v11 = CFrame.Angles(0, -1.5707963267948966, 0)
            local v12 = if math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z) <= 7 then CFrame.new(0, 0.5 + BoundingBox2.Y * 0.2, -(1.7 + BoundingBox2.X / 2)) * v11 * CFrame.new(-v10) else CFrame.new(0, 3.4 + BoundingBox2.Y / 2, -(math.min(BoundingBox2.X / 2, 6) + 1.5)) * v11 * CFrame.new(-v10)

            game:GetService("CollectionService"):AddTag(v8, "OthersFish")
            v8.Parent = workspace
            t2[p2] = {
                model = v8,
                offset = v12,
                key = v5
            }
            t1.Count += 1
        else
            FishModels.Prepare({ HeldId })

            if t3[p2] ~= v5 then
                t3[p2] = v5
                task.spawn(function() -- line: 47
                    -- upvalues: p2 (copy), HeldId (copy), v5 (copy), FishModels (copy), t2 (copy), t3 (copy), refresh (copy)
                    local elapsed = os.clock()

                    while true do
                        if os.clock() - elapsed < 180 then
                            task.wait(0.5)

                            if p2.Parent and t3[p2] == v5 then
                                if not FishModels.Has(HeldId) then
                                    if math.floor(os.clock() - elapsed) % 6 == 0 then
                                        FishModels.Prepare({ HeldId })
                                    end

                                    continue
                                end

                                t3[p2] = nil

                                if p2:GetAttribute("HeldId") == HeldId and not t2[p2] then
                                    refresh(p2)
                                end

                                return
                            end

                            break
                        end

                        if t3[p2] == v5 then
                            t3[p2] = nil
                        end

                        return
                    end
                end)
            end
        end
    end
end

function t1.Init() -- line: 103
    -- upvalues: Players (copy), RunService (copy), FishModels (copy), DataClient (copy), t1 (copy), t2 (copy), v1 (ref), clear (copy), refresh (copy)
    local LocalPlayer = Players.LocalPlayer

    local function watch(p3) -- line: 105
        -- upvalues: LocalPlayer (copy), refresh (copy)
        if p3 == LocalPlayer then
            return
        end

        p3:GetAttributeChangedSignal("HeldId"):Connect(function() -- line: 109
            -- upvalues: p3 (copy), refresh (copy)
            refresh(p3)
        end)
        refresh(p3)
    end

    Players.PlayerAdded:Connect(watch)
    Players.PlayerRemoving:Connect(clear)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            player:GetAttributeChangedSignal("HeldId"):Connect(function() -- line: 109
                -- upvalues: player (copy), refresh (copy)
                refresh(player)
            end)
            refresh(player)
        end
    end

    local function apply(p4) -- line: 119
        -- upvalues: LocalPlayer (copy), Players (copy), t1 (copy), t2 (copy), v1 (ref), refresh (copy)
        local v16 = type(p4) == "table" and p4.HideOthersFish == true

        if v16 ~= v1 then
            v1 = v16

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if v1 then
                        local v17 = t2[player]

                        if v17 then
                            t2[player] = nil
                            v17.model:Destroy()
                            t1.Count -= 1
                        end
                    else
                        refresh(player)
                    end
                end
            end
        end
    end

    DataClient.Observe("Settings", apply)
    apply(DataClient.Get("Settings"))
    RunService.RenderStepped:Connect(function() -- line: 136
        -- upvalues: FishModels (copy), t2 (copy)
        local elapsed = os.clock()

        for v18, v19 in pairs(t2) do
            local Character = v18.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                v19.model:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, math.sin(elapsed * 2.2) * 0.08, 0) * v19.offset)
                FishModels.Animate(v19.model, elapsed, 9)
            end
        end
    end)
end

return t1
