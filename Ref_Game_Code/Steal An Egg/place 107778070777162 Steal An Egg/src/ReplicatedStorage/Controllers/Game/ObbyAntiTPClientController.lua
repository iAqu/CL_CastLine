-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local LocalPlayer = Players.LocalPlayer
local v1
local t1 = {}
local Position, v2, v3, v4
local v5 = false
local v6
local n1 = 0
local n2 = 16
local n3 = 0
local n4 = 0
local n5 = 0
local n6 = 0
local t2
local v7 = false

return {
    Start = function() -- Start | line: 95
        -- upvalues: HttpService (copy), RunService (copy), Workspace (copy), Remotes (copy), LocalPlayer (copy), v1 (ref), t1 (copy), Position (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref), n2 (ref), n3 (ref), n4 (ref), n5 (ref), n6 (ref), t2 (ref), v7 (ref)
        local function debugEnabled() -- line: 96
            -- upvalues: Workspace (copy)
            return Workspace:GetAttribute("ClientObbyAntiTpDebug") == true
        end

        local function dprint(p1) -- line: 100
            -- upvalues: Workspace (copy)
            if Workspace:GetAttribute("ClientObbyAntiTpDebug") == true then
                print("[ObbyAntiTP] " .. p1)
            end
        end

        local function nowClock() -- line: 106
            return os.clock()
        end

        local function parseRegionAttribute() -- line: 112
            -- upvalues: Workspace (copy)
            local AnticheatSuspendedRegion = Workspace:GetAttribute("AnticheatSuspendedRegion")

            if typeof(AnticheatSuspendedRegion) ~= "string" then
                return nil
            end

            local t4 = {}

            for match in string.gmatch(AnticheatSuspendedRegion, "[^,]+") do
                local v8 = tonumber(match)

                if v8 == nil then
                    return nil
                end

                table.insert(t4, v8)
            end

            return if #t4 == 6 then {
                Min = Vector3.new(t4[1], t4[2], t4[3]),
                Max = Vector3.new(t4[4], t4[5], t4[6])
            } else nil
        end

        local function regionFromMap(p2) -- line: 134
            local v15, v16

            for _, descendant in p2:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local Position = descendant.Position
                    local v17 = descendant.Size * 0.5
                    local v18 = Position - v17
                    local v19 = Position + v17

                    v15 = if v15 then Vector3.new(math.min(v15.X, v18.X), math.min(v15.Y, v18.Y), (math.min(v15.Z, v18.Z))) else v18
                    v16 = if v16 then Vector3.new(math.max(v16.X, v19.X), math.max(v16.Y, v19.Y), (math.max(v16.Z, v19.Z))) else v19
                end
            end

            return if v15 ~= nil and v16 ~= nil then {
                Min = v15 - Vector3.new(25, 25, 25),
                Max = v16 + Vector3.new(25, 25, 25)
            } else nil
        end

        local function collectMapLandmarks(p3) -- line: 166
            -- upvalues: t1 (copy), Position (ref)
            table.clear(t1)
            Position = nil

            if p3 == nil then
                return
            end

            local WinParts = p3:FindFirstChild("WinParts")

            if WinParts ~= nil then
                for _, child in WinParts:GetChildren() do
                    if child:IsA("BasePart") then
                        table.insert(t1, child.Position)
                    end
                end
            end

            local ObbyRespawn = p3:FindFirstChild("ObbyRespawn")

            if ObbyRespawn ~= nil and ObbyRespawn:IsA("BasePart") then
                Position = ObbyRespawn.Position
            end
        end

        local function refreshRegion() -- line: 186
            -- upvalues: parseRegionAttribute (copy), regionFromMap (copy), collectMapLandmarks (copy), Workspace (copy), v1 (ref), t1 (copy)
            local MonsterEventMap = Workspace:FindFirstChild("MonsterEventMap")
            local v26 = parseRegionAttribute()

            if v26 == nil and MonsterEventMap ~= nil then
                v26 = regionFromMap(MonsterEventMap)
            end

            v1 = v26
            collectMapLandmarks(MonsterEventMap)

            if v1 ~= nil then
                local v28 = ("armed: region %s -> %s, %d win gates"):format(tostring(v1.Min), tostring(v1.Max), #t1)

                if Workspace:GetAttribute("ClientObbyAntiTpDebug") == true then
                    print("[ObbyAntiTP] " .. v28)
                end
            elseif Workspace:GetAttribute("ClientObbyAntiTpDebug") == true then
                print("[ObbyAntiTP] disarmed: no event region")
            end
        end

        local function inRegion(p4) -- line: 205
            -- upvalues: v1 (ref)
            local v29 = v1

            if v29 == nil then
                return false
            end

            if p4.X >= v29.Min.X and p4.X <= v29.Max.X and p4.Y >= v29.Min.Y and p4.Y <= v29.Max.Y and p4.Z >= v29.Min.Z then
                return p4.Z <= v29.Max.Z
            end

            return false
        end

        local function isEnabled() -- line: 218
            -- upvalues: Workspace (copy), v1 (ref)
            if Workspace:GetAttribute("ClientObbyAntiTp") == false then
                return false
            end

            return v1 ~= nil
        end

        local function horizontal(p5, p6) -- line: 224
            return ((p5 - p6) * Vector3.new(1, 0, 1)).Magnitude
        end

        local function grace(p7) -- line: 228
            -- upvalues: n4 (ref)
            local v30 = n4

            n4 = math.max(v30, os.clock() + p7)
        end

        local function rebaseline(p8) -- line: 232
            -- upvalues: v4 (ref), v6 (ref), n1 (ref)
            local v32 = v4

            v6 = if p8 ~= nil or v32 == nil then p8 else v32.Position
            n1 = os.clock()
        end

        local function jumpVelocity(p9) -- line: 241
            -- upvalues: Workspace (copy)
            if p9.UseJumpPower then
                return (math.max(p9.JumpPower, 0))
            end

            return (math.sqrt(math.max(Workspace.Gravity, 0) * 2 * math.max(p9.JumpHeight, 0)))
        end

        local function nearWinPart(p10) -- line: 248
            -- upvalues: t1 (copy)
            for _, v35 in t1 do
                if (p10 - v35).Magnitude <= 30 then
                    return true
                end
            end

            return false
        end

        local function nearObbyRespawn(p11) -- line: 257
            -- upvalues: Position (ref)
            local Position2 = Position

            return Position2 ~= nil and (p11 - Position2).Magnitude <= 25
        end

        local function lagback(p12) -- line: 264
            -- upvalues: v2 (ref), v3 (ref), v4 (ref), v6 (ref), n1 (ref), n4 (ref)
            local v36 = v2
            local v37 = v4
            local v38 = v3

            if v36 == nil or v37 == nil or v38 == nil then
                return
            end

            v38.Sit = false
            v37.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            v37.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            v36:PivotTo(CFrame.new(p12) * v37.CFrame.Rotation)

            local v39 = v4

            v6 = if p12 ~= nil or v39 == nil then p12 else v39.Position
            n1 = os.clock()

            local v40 = n4

            n4 = math.max(v40, os.clock() + 0.3)
        end

        local function kill(p13) -- line: 277
            -- upvalues: Workspace (copy), v3 (ref), v4 (ref), v5 (ref)
            local v42 = v4
            local v43 = v3

            v5 = true

            local v44 = "KILL: " .. p13

            if Workspace:GetAttribute("ClientObbyAntiTpDebug") == true then
                print("[ObbyAntiTP] " .. v44)
            end

            if v42 ~= nil then
                v42.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                v42.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end

            if v43 ~= nil then
                v43.Health = 0
                v43:ChangeState(Enum.HumanoidStateType.Dead)
            end
        end

        local function punish(p14, p15, p16, p17, p18) -- line: 291
            -- upvalues: lagback (copy), Workspace (copy), t1 (copy), v3 (ref), v4 (ref), v5 (ref), n5 (ref), n6 (ref)
            if p18 - n6 > 5 then
                n5 = 0
            end

            n5 += 1
            n6 = p18

            local v45

            if p16 >= 300 or p17 >= 150 or n5 >= 6 then
                v45 = true
            elseif p16 >= 100 then
                local v46 = false

                for _, v47 in t1 do
                    if (p14 - v47).Magnitude <= 30 then
                        v45 = true
                        v46 = true
                        break
                    end
                end

                if not v46 then
                    v45 = false
                end
            else
                v45 = false
            end

            local v48 = n5
            local v49 = ("flag #%d: moved %.0f (up %.0f)%s"):format(v48, p16, p17, if v45 then " EXTREME" else "")

            if Workspace:GetAttribute("ClientObbyAntiTpDebug") == true then
                print("[ObbyAntiTP] " .. v49)
            end

            lagback(p15)

            if not v45 then
                return
            end

            local v50 = n5

            n5 = 0

            local v51 = ("jump %.0f studs (up %.0f), flags %d"):format(p16, p17, v50)
            local v52 = v4
            local v53 = v3

            v5 = true

            local v54 = "KILL: " .. v51

            if Workspace:GetAttribute("ClientObbyAntiTpDebug") == true then
                print("[ObbyAntiTP] " .. v54)
            end

            if v52 ~= nil then
                v52.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                v52.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end

            if v53 ~= nil then
                v53.Health = 0
                v53:ChangeState(Enum.HumanoidStateType.Dead)
            end
        end

        local function check() -- line: 323
            -- upvalues: inRegion (copy), punish (copy), Workspace (copy), v1 (ref), Position (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref), n2 (ref), n3 (ref), n4 (ref), t2 (ref), v7 (ref)
            local v55 = v4
            local v56 = v3

            if v55 ~= nil and v56 ~= nil and not v5 and not (v56.Health <= 0) and v55:IsDescendantOf(Workspace) then
                local elapsed = os.clock()
                local v57 = elapsed - n1

                if not (v57 < 0.1) then
                    n1 = elapsed

                    local Position2 = v55.Position

                    if Workspace:GetAttribute("ClientObbyAntiTp") ~= false and v1 ~= nil then
                        local v58 = math.clamp(v56.WalkSpeed, 2, 1000)

                        if n2 <= v58 then
                            n2 = v58
                            n3 = 0
                        else
                            n3 += math.min(v57, 0.4)

                            if n3 >= 3 then
                                n2 = v58
                            end
                        end

                        local v60 = inRegion(Position2)

                        if not (v60 and v7) then
                            v7 = v60
                        elseif v56.Sit or v56.PlatformStand then
                            local v61 = n4

                            n4 = math.max(v61, os.clock() + 1.5)
                        else
                            local t6 = t2

                            if t6 ~= nil then
                                if t6.ExpiresAt <= elapsed then
                                    t2 = nil
                                elseif (Position2 - t6.Target).Magnitude <= 15 then
                                    t2 = nil
                                    v6 = Position2

                                    return
                                end
                            end

                            if not (elapsed < n4) and not (v57 > 1) and v6 ~= nil then
                                local v63 = math.min(v57, 0.4)
                                local v64 = v6
                                local AssemblyLinearVelocity = v55.AssemblyLinearVelocity
                                local v65 = math.min((AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude, 400)
                                local v66 = math.clamp(AssemblyLinearVelocity.Y, 0, 400)
                                local v67 = n2 * 1.7000000000000002 * v63 + 14 + v65 * v63
                                local Magnitude2 = ((Position2 - v64) * Vector3.new(1, 0, 1)).Magnitude
                                local v71 = math.max(if v56.UseJumpPower then math.max(v56.JumpPower, 0) else math.sqrt(math.max(Workspace.Gravity, 0) * 2 * math.max(v56.JumpHeight, 0)), v66) * v63 + 14
                                local v72 = Position2.Y - v64.Y
                                local v73 = v67 + 80 < Magnitude2
                                local v74 = v71 + 60 < v72

                                if v73 or v74 then
                                    local Position3 = Position

                                    if Position3 ~= nil and (Position2 - Position3).Magnitude <= 25 then
                                        v6 = Position2
                                    else
                                        punish(Position2, v64, Magnitude2, math.max(v72, 0), elapsed)
                                    end
                                else
                                    v6 = Position2
                                end

                                return
                            end
                        end

                        v6 = Position2
                    else
                        v6 = Position2
                        v7 = false
                    end
                end
            end
        end

        Remotes.RigSync.Refresh.OnClientEvent:Connect(function(p19) -- line: 437
            -- upvalues: HttpService (copy), Workspace (copy), n4 (ref), t2 (ref)
            if typeof(p19) ~= "string" then
                return
            end

            local function v75() -- line: 441
                -- upvalues: p19 (copy), HttpService (copy)
                return HttpService:JSONDecode(p19)
            end

            local ok, result = pcall(v75)

            if not ok or typeof(result) ~= "table" then
                return
            end

            local Action, Arguments = result.Action, result.Arguments

            if typeof(Arguments) ~= "table" then
                Arguments = {}
            end

            if Action == "Relocate" then
                local v77 = tonumber(Arguments[1])
                local v79 = tonumber(Arguments[2])
                local v81 = tonumber(Arguments[3])

                if v77 ~= nil and v79 ~= nil and v81 ~= nil then
                    t2 = {
                        Target = Vector3.new(v77, v79, v81),
                        ExpiresAt = os.clock() + 8
                    }
                end

                local v82 = n4

                n4 = math.max(v82, os.clock() + 1)

                if Workspace:GetAttribute("ClientObbyAntiTpDebug") == true then
                    print("[ObbyAntiTP] grace: server relocation")
                end
            elseif Action == "BeginImpulse" or Action == "BeginRagdoll" then
                local v86 = math.clamp(tonumber(Arguments[1]) or 1, 1, 5) + 0.5
                local v87 = n4

                n4 = math.max(v87, os.clock() + v86)

                local v89 = "grace: server " .. tostring(Action)

                if Workspace:GetAttribute("ClientObbyAntiTpDebug") == true then
                    print("[ObbyAntiTP] " .. v89)
                end
            elseif Action == "EndRagdoll" then
                local v90 = n4

                n4 = math.max(v90, os.clock() + 1)
            end
        end)

        local function onCharacter(p20) -- line: 473
            -- upvalues: LocalPlayer (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref), n2 (ref), n3 (ref), n4 (ref), n5 (ref), t2 (ref), v7 (ref)
            v5 = false
            n5 = 0
            t2 = nil
            v7 = false
            v2 = p20
            v3 = nil
            v4 = nil
            v6 = nil

            local v92 = p20:WaitForChild("Humanoid", 10)
            local v93 = p20:WaitForChild("HumanoidRootPart", 10)
            local Position, v94

            if v92 ~= nil then
                if not v92:IsA("Humanoid") or v93 == nil then
                    v94 = true
                elseif v93:IsA("BasePart") and LocalPlayer.Character == p20 then
                    v3 = v92
                    v4 = v93
                    n2 = math.clamp(v92.WalkSpeed, 2, 1000)
                    n3 = 0

                    local v95 = n4

                    n4 = math.max(v95, os.clock() + 3)
                    Position = v93.Position

                    local v97 = v4

                    if Position == nil and v97 ~= nil then
                        Position = v97.Position
                    end

                    v94 = false
                else
                    v94 = true
                end
            else
                v94 = true
            end

            if v94 then
                return
            end

            v6 = Position
            n1 = os.clock()
            v92.Died:Connect(function() -- line: 501
                -- upvalues: v5 (ref)
                v5 = true
            end)
        end

        LocalPlayer.CharacterAdded:Connect(onCharacter)

        if LocalPlayer.Character ~= nil then
            task.spawn(onCharacter, LocalPlayer.Character)
        end

        Workspace:GetAttributeChangedSignal("AnticheatSuspendedRegion"):Connect(refreshRegion)
        Workspace.ChildAdded:Connect(function(p21) -- line: 514
            -- upvalues: refreshRegion (copy)
            if p21.Name == "MonsterEventMap" then
                task.defer(refreshRegion)
            end
        end)
        Workspace.ChildRemoved:Connect(function(p22) -- line: 520
            -- upvalues: refreshRegion (copy)
            if p22.Name == "MonsterEventMap" then
                task.defer(refreshRegion)
            end
        end)
        refreshRegion()
        RunService.Heartbeat:Connect(check)
    end
}
