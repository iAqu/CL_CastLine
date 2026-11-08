-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Boss = require(script.Boss)
local Drop = require(script.Drop)
local GhostBoss = require(ReplicatedStorage.Shared.Util.GhostBoss)
local GhostBoss2 = require(ReplicatedStorage.Client.Notifications.GhostBoss)
local GhostBoss3 = require(ReplicatedStorage.Shared.Remotes).GhostBoss
local Sfx = require(script.Sfx)
local SoulsHud = require(script.SoulsHud)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local TrainGhostVisuals = require(ReplicatedStorage.Controllers.Game.TrainGhostVisuals)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local Attributes, Phases = GhostBoss.Attributes, GhostBoss.Phases
local v1 = Color3.fromRGB(125, 255, 210)
local v2 = Color3.fromRGB(8, 63, 52)
local v3 = false
local t1 = {}

local function toast(p1, p2) -- line: 45
    -- upvalues: Toast (copy), v1 (copy), v2 (copy)
    Toast.Show({
        Lane = "Feed",
        Text = p1,
        Seconds = p2 or 3,
        Color = v1,
        StrokeColor = v2
    })
end

local function isBossVacuum(p3) -- line: 55
    -- upvalues: GhostBoss (copy)
    return p3:IsA("Tool") and p3:GetAttribute(GhostBoss.ToolAttribute) ~= nil
end

local function cameraLook() -- line: 59
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    return if CurrentCamera then CurrentCamera.CFrame.LookVector else nil
end

local function nameOf(p4) -- line: 64
    -- upvalues: Players (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p4)

    if PlayerByUserId then
        return PlayerByUserId.DisplayName
    end

    return "Someone"
end

function t1.Start() -- line: 73
    -- upvalues: Players (copy), ReplicatedStorage (copy), RunService (copy), UserInputService (copy), Workspace (copy), Boss (copy), Drop (copy), GhostBoss (copy), GhostBoss2 (copy), GhostBoss3 (copy), Sfx (copy), SoulsHud (copy), Toast (copy), TrainGhostVisuals (copy), Trove (copy), LocalPlayer (copy), Attributes (copy), Phases (copy), v1 (copy), v2 (copy), v3 (ref)
    if v3 then
        return
    end

    v3 = true

    local v4 = Trove.new()
    local v5 = ReplicatedStorage:WaitForChild(GhostBoss.StateName)
    local Boss2 = ReplicatedStorage:WaitForChild(GhostBoss.AssetsName):WaitForChild("Boss")
    local v6 = v4:Add(Instance.new("Folder"))

    v6.Name = "GhostBossVisuals"
    v6.Parent = Workspace

    local v7, v8
    local v9 = ""
    local t2 = {}
    local t3 = {}
    local t4 = {}
    local t5 = {}
    local v10 = false
    local v11 = false
    local v12 = nil
    local n1 = 0
    local v13
    local n2 = (-1e999)
    local t6 = {}

    local function forMe() -- line: 102
        -- upvalues: v5 (copy), GhostBoss (copy), LocalPlayer (copy), Attributes (copy)
        return GhostBoss.RealmOf(LocalPlayer) == GhostBoss.RealmNamed(v5:GetAttribute(Attributes.Realm))
    end

    local function setSucking(p5) -- line: 107
        -- upvalues: v7 (ref), v11 (ref), v12 (ref), n1 (ref), GhostBoss (copy), GhostBoss3 (copy), TrainGhostVisuals (copy)
        if v11 == p5 then
            return
        end

        v11 = p5
        n1 = 0

        if not p5 then
            GhostBoss3.Suction:FireServer(false)
        end

        if v7 then
            v7:SetLocalSucking(p5)
        end

        local SetYield = TrainGhostVisuals.SetYield
        local v14, v15

        if p5 then
            if v12 ~= nil then
                local v16 = v12

                v14 = v16:IsA("Tool") and v16:GetAttribute(GhostBoss.ToolAttribute) ~= nil
                v15 = not v14
            else
                v15 = false
            end
        else
            v15 = p5
        end

        SetYield(v15)
    end

    local function wantsBoss(p6) -- line: 133
        -- upvalues: v5 (copy), v10 (ref), v11 (ref), v12 (ref), Workspace (copy), GhostBoss (copy), LocalPlayer (copy), Attributes (copy), Phases (copy)
        local v17, v18

        if p6 == nil or v12 == nil then
            v18 = true
        elseif v12.Parent == LocalPlayer.Character then
            v17 = GhostBoss.RealmOf(LocalPlayer) == GhostBoss.RealmNamed(v5:GetAttribute(Attributes.Realm))
            v18 = false
        else
            v18 = true
        end

        if v18 or not v17 then
            return false
        end

        local Phase = p6:GetPhase()

        if Phase ~= Phases.Alive and Phase ~= Phases.Spawning then
            return false
        end

        local v19 = v11 and LocalPlayer:GetAttribute(GhostBoss.SuckingAttribute) == true and p6:InReach(1.15)
        local LookVector, v20

        if v19 then
            v20 = v19
        else
            local v21 = p6:InReach()

            if v21 then
                local CurrentCamera = Workspace.CurrentCamera

                if CurrentCamera then
                    LookVector = CurrentCamera.CFrame.LookVector
                end

                v20 = p6:InCone(LookVector)
            else
                v20 = v21
            end
        end

        local v22 = v12

        return v22:IsA("Tool") and v22:GetAttribute(GhostBoss.ToolAttribute) ~= nil and v10 or v20
    end

    local function startDrop(p7) -- line: 156
        -- upvalues: v5 (copy), v6 (copy), t2 (copy), t3 (copy), t5 (copy), Drop (copy), Attributes (copy)
        if t3[p7] then
            return
        end

        local Attribute = v5:GetAttribute(Attributes.ExplodePosition)
        local Attribute2 = v5:GetAttribute(Attributes.DropPosition)

        if typeof(Attribute) == "Vector3" and typeof(Attribute2) == "Vector3" then
            local v23 = Drop.new(Attribute, Attribute2, v6)

            t3[p7] = v23
            table.insert(t2, v23)

            local v24 = t5[p7]

            if v24 then
                t5[p7] = nil
                v23:AddSouls(v24)
            end
        end
    end

    local function onPhase(p8, p9) -- line: 175
        -- upvalues: v5 (copy), v7 (ref), v10 (ref), v11 (ref), n1 (ref), startDrop (copy), Players (copy), GhostBoss (copy), GhostBoss3 (copy), Toast (copy), TrainGhostVisuals (copy), LocalPlayer (copy), Attributes (copy), Phases (copy), v1 (copy), v2 (copy)
        local v25 = v7

        if v25 == nil then
            return
        end

        local Phase = v25:GetPhase()

        v25:SetPhase(p8)

        if p8 ~= Phase then
            if p8 == Phases.Capturing then
                if v10 ~= false then
                    v10 = false

                    if not v10 and v11 ~= false then
                        v11 = false
                        n1 = 0
                        GhostBoss3.Suction:FireServer(false)

                        if v7 then
                            v7:SetLocalSucking(false)
                        end

                        TrainGhostVisuals.SetYield(false)
                    end
                end

                local Attribute = v5:GetAttribute(Attributes.CaptureUserId)

                if type(Attribute) == "number" and Attribute > 0 and GhostBoss.RealmOf(LocalPlayer) == GhostBoss.RealmNamed(v5:GetAttribute(Attributes.Realm)) then
                    local v26

                    if Attribute == LocalPlayer.UserId then
                        v26 = "You're sucking in Ghouler!"
                    else
                        local PlayerByUserId = Players:GetPlayerByUserId(Attribute)

                        v26 = ("%* is sucking in Ghouler!"):format(if PlayerByUserId then PlayerByUserId.DisplayName else "Someone")
                    end

                    Toast.Show({
                        Lane = "Feed",
                        Seconds = 3,
                        Text = v26,
                        Color = v1,
                        StrokeColor = v2
                    })
                end
            elseif p8 == Phases.Defeated then
                startDrop(p9)
            elseif p8 == Phases.Escaped and Phase ~= Phases.Defeated then
                if v10 ~= false then
                    v10 = false

                    if not v10 and v11 ~= false then
                        v11 = false
                        n1 = 0
                        GhostBoss3.Suction:FireServer(false)

                        if v7 then
                            v7:SetLocalSucking(false)
                        end

                        TrainGhostVisuals.SetYield(false)
                    end
                end

                if GhostBoss.RealmOf(LocalPlayer) == GhostBoss.RealmNamed(v5:GetAttribute(Attributes.Realm)) then
                    Toast.Show({
                        Lane = "Feed",
                        Text = "Ghouler got away...",
                        Seconds = 4,
                        Color = v1,
                        StrokeColor = v2
                    })
                end
            end
        end
    end

    local function sync() -- line: 205
        -- upvalues: v5 (copy), Boss2 (copy), v6 (copy), v7 (ref), v8 (ref), v9 (ref), t4 (copy), v11 (ref), n1 (ref), onPhase (copy), Workspace (copy), Boss (copy), GhostBoss (copy), GhostBoss2 (copy), GhostBoss3 (copy), Sfx (copy), TrainGhostVisuals (copy), LocalPlayer (copy), Attributes (copy), Phases (copy)
        local Attribute = v5:GetAttribute(Attributes.BossId)
        local Attribute2 = v5:GetAttribute(Attributes.Phase)
        local v27 = false
        local v28 = false
        local v29 = false
        local v30 = false
        local v31 = false

        if type(Attribute) == "string" then
            v27 = true
        else
            v31 = true
        end

        if v27 then
            if type(Attribute2) == "string" then
                v28 = true
            else
                v31 = true
            end
        end

        v27 = false

        if v28 then
            if Attribute == v9 then
                v31 = false
            else
                v27 = true
            end
        end

        v28 = false

        if v27 then
            if v11 == false then
                v29 = true
            else
                v28 = true
            end
        end

        v27 = false

        if v28 then
            v11 = false
            n1 = 0
            GhostBoss3.Suction:FireServer(false)

            if v7 then
                v27 = true
            else
                v30 = true
            end
        end

        v28 = false

        if v27 then
            v30 = true
            v7:SetLocalSucking(false)
        end

        v27 = false

        if v30 then
            v29 = true
            TrainGhostVisuals.SetYield(false)
        end

        v30 = false

        local v32

        if v29 then
            v32 = v7

            if v32 then
                v30 = true
            else
                v27 = true
            end
        end

        v29 = false

        if v30 then
            if v32:GetPhase() == Phases.Escaped then
                v29 = true
            else
                v28 = true
            end
        end

        if v29 then
            if v32:IsFinished() then
                v28 = true
            else
                v27 = true
            end
        end

        v29 = false

        if v28 then
            v32:Destroy()
            v7 = nil
            v27 = true
        end

        v28 = false

        if v27 then
            v9 = Attribute

            if Attribute == "" then
                v31 = false
            else
                v28 = true
            end
        end

        v27 = false

        if v28 then
            if v7 then
                v27 = true
            else
                v29 = true
            end
        end

        v28 = false

        if v27 then
            v29 = true
            v7:Destroy()
        end

        v27 = false

        local v33

        if v29 then
            v33 = Boss.new(v5, Boss2, v6)
            v7 = v33

            if v8 then
                v27 = true
            else
                v28 = true
            end
        end

        if v27 then
            v28 = true
            v8:Destroy()
        end

        if v28 then
            v8 = Sfx.new(v5, v33.Root, Attribute2)
            v31 = false
        end

        if v31 then
            return
        end

        if Attribute ~= "" and not t4[Attribute] and GhostBoss.RealmOf(LocalPlayer) == GhostBoss.RealmNamed(v5:GetAttribute(Attributes.Realm)) then
            local Attribute3 = v5:GetAttribute(Attributes.SpawnedAt)

            if type(Attribute3) == "number" and Workspace:GetServerTimeNow() - Attribute3 < 15 and Attribute2 ~= Phases.Defeated then
                t4[Attribute] = true
                GhostBoss2.Show()

                if Attribute2 == Phases.Spawning and v8 then
                    v8:Spawn()
                end
            end
        end

        if Attribute ~= "" and Attribute2 ~= Phases.None then
            onPhase(Attribute2, Attribute)
        end
    end

    local function bindTool(p10) -- line: 248
        -- upvalues: v4 (copy), v7 (ref), v10 (ref), v11 (ref), v12 (ref), n1 (ref), t6 (copy), GhostBoss (copy), GhostBoss3 (copy), TrainGhostVisuals (copy), LocalPlayer (copy)
        if GhostBoss.IsVacuum(p10) and not t6[p10] then
            local v34 = v4:Extend()

            t6[p10] = v34

            local function refresh() -- line: 255
                -- upvalues: p10 (copy), v7 (ref), v10 (ref), v11 (ref), v12 (ref), n1 (ref), GhostBoss3 (copy), TrainGhostVisuals (copy), LocalPlayer (copy)
                if p10.Parent == LocalPlayer.Character then
                    v12 = p10
                elseif v12 == p10 then
                    if v10 ~= false then
                        v10 = false

                        if not v10 and v11 ~= false then
                            v11 = false
                            n1 = 0
                            GhostBoss3.Suction:FireServer(false)

                            if v7 then
                                v7:SetLocalSucking(false)
                            end

                            TrainGhostVisuals.SetYield(false)
                        end
                    end

                    v12 = nil
                end
            end

            v34:Connect(p10.Equipped, refresh)
            v34:Connect(p10.Unequipped, function() -- line: 264
                -- upvalues: p10 (copy), v7 (ref), v10 (ref), v11 (ref), v12 (ref), n1 (ref), GhostBoss3 (copy), TrainGhostVisuals (copy)
                if v12 ~= p10 then
                    return
                end

                if v10 ~= false then
                    v10 = false

                    if not v10 and v11 ~= false then
                        v11 = false
                        n1 = 0
                        GhostBoss3.Suction:FireServer(false)

                        if v7 then
                            v7:SetLocalSucking(false)
                        end

                        TrainGhostVisuals.SetYield(false)
                    end
                end

                v12 = nil
            end)
            v34:Connect(p10.Activated, function() -- line: 270
                -- upvalues: p10 (copy), v7 (ref), v10 (ref), v11 (ref), v12 (ref), n1 (ref), GhostBoss3 (copy), TrainGhostVisuals (copy), LocalPlayer (copy)
                v12 = p10

                local v35 = v12 ~= nil and v12.Parent == LocalPlayer.Character

                if v10 ~= v35 then
                    v10 = v35

                    if not v10 then
                        if v11 == false then
                            return
                        end

                        v11 = false
                        n1 = 0
                        GhostBoss3.Suction:FireServer(false)

                        if v7 then
                            v7:SetLocalSucking(false)
                        end

                        TrainGhostVisuals.SetYield(false)
                    end
                end
            end)
            v34:Connect(p10.Deactivated, function() -- line: 274
                -- upvalues: v7 (ref), v10 (ref), v11 (ref), n1 (ref), GhostBoss3 (copy), TrainGhostVisuals (copy)
                if v10 == false then
                    return
                end

                v10 = false

                if not v10 then
                    if v11 == false then
                        return
                    end

                    v11 = false
                    n1 = 0
                    GhostBoss3.Suction:FireServer(false)

                    if v7 then
                        v7:SetLocalSucking(false)
                    end

                    TrainGhostVisuals.SetYield(false)
                end
            end)
            v34:Connect(p10.AncestryChanged, function() -- line: 277
                -- upvalues: p10 (copy), v34 (copy), v4 (copy), v7 (ref), v10 (ref), v11 (ref), v12 (ref), n1 (ref), t6 (copy), GhostBoss3 (copy), TrainGhostVisuals (copy), LocalPlayer (copy)
                if p10.Parent == LocalPlayer.Character then
                    v12 = p10
                elseif v12 == p10 then
                    if v10 ~= false then
                        v10 = false

                        if not v10 and v11 ~= false then
                            v11 = false
                            n1 = 0
                            GhostBoss3.Suction:FireServer(false)

                            if v7 then
                                v7:SetLocalSucking(false)
                            end

                            TrainGhostVisuals.SetYield(false)
                        end
                    end

                    v12 = nil
                end

                if not p10:IsDescendantOf(game) then
                    t6[p10] = nil
                    v4:Remove(v34)
                end
            end)

            if p10.Parent == LocalPlayer.Character then
                v12 = p10
            elseif v12 == p10 then
                if v10 ~= false then
                    v10 = false

                    if not v10 and v11 ~= false then
                        v11 = false
                        n1 = 0
                        GhostBoss3.Suction:FireServer(false)

                        if v7 then
                            v7:SetLocalSucking(false)
                        end

                        TrainGhostVisuals.SetYield(false)
                    end
                end

                v12 = nil
            end
        end
    end

    local function watchContainer(p11) -- line: 287
        -- upvalues: v4 (copy), t6 (copy), bindTool (copy), GhostBoss (copy), Toast (copy), v1 (copy), v2 (copy)
        for _, child in p11:GetChildren() do
            bindTool(child)
        end

        v4:Connect(p11.ChildAdded, function(p12) -- line: 291
            -- upvalues: p11 (copy), t6 (copy), bindTool (copy), GhostBoss (copy), Toast (copy), v1 (copy), v2 (copy)
            local v36 = p12:IsA("Tool") and p12:GetAttribute(GhostBoss.ToolAttribute) ~= nil and not t6[p12]

            bindTool(p12)

            if v36 and p11:IsA("Backpack") then
                Toast.Show({
                    Lane = "Feed",
                    Text = "You got a Ghost Vacuum! Equip it and hold to suck in Ghouler!",
                    Seconds = 4,
                    Color = v1,
                    StrokeColor = v2
                })
            end
        end)
    end

    local function trackCharacter(p13) -- line: 300
        -- upvalues: v7 (ref), v10 (ref), v11 (ref), v12 (ref), n1 (ref), watchContainer (copy), GhostBoss3 (copy), TrainGhostVisuals (copy)
        if v10 ~= false then
            v10 = false

            if not v10 and v11 ~= false then
                v11 = false
                n1 = 0
                GhostBoss3.Suction:FireServer(false)

                if v7 then
                    v7:SetLocalSucking(false)
                end

                TrainGhostVisuals.SetYield(false)
            end
        end

        v12 = nil
        watchContainer(p13)
    end

    v4:Connect(LocalPlayer.CharacterAdded, trackCharacter)

    if LocalPlayer.Character then
        local Character = LocalPlayer.Character

        if v10 ~= false then
            v10 = false

            if not v10 and v11 ~= false then
                v11 = false
                n1 = 0
                GhostBoss3.Suction:FireServer(false)

                if v7 then
                    v7:SetLocalSucking(false)
                end

                TrainGhostVisuals.SetYield(false)
            end
        end

        v12 = nil
        watchContainer(Character)
    end

    task.spawn(function() -- line: 310
        -- upvalues: watchContainer (copy), LocalPlayer (copy)
        watchContainer(LocalPlayer:WaitForChild("Backpack"))
    end)
    v4:Connect(LocalPlayer.ChildAdded, function(p14) -- line: 313
        -- upvalues: watchContainer (copy)
        if p14:IsA("Backpack") then
            watchContainer(p14)
        end
    end)
    v4:Connect(UserInputService.InputEnded, function(p15) -- line: 319
        -- upvalues: v7 (ref), v10 (ref), v11 (ref), n1 (ref), GhostBoss3 (copy), TrainGhostVisuals (copy)
        if p15.UserInputType ~= Enum.UserInputType.MouseButton1 and p15.UserInputType ~= Enum.UserInputType.Touch or v10 == false then
            return
        end

        v10 = false

        if v10 or v11 == false then
            return
        end

        v11 = false
        n1 = 0
        GhostBoss3.Suction:FireServer(false)

        if v7 then
            v7:SetLocalSucking(false)
        end

        TrainGhostVisuals.SetYield(false)
    end)
    v4:Connect(UserInputService.WindowFocusReleased, function() -- line: 327
        -- upvalues: v7 (ref), v10 (ref), v11 (ref), n1 (ref), GhostBoss3 (copy), TrainGhostVisuals (copy)
        if v10 == false then
            return
        end

        v10 = false

        if not v10 then
            if v11 == false then
                return
            end

            v11 = false
            n1 = 0
            GhostBoss3.Suction:FireServer(false)

            if v7 then
                v7:SetLocalSucking(false)
            end

            TrainGhostVisuals.SetYield(false)
        end
    end)
    v4:Connect(GhostBoss3.Defeated.OnClientEvent, function(p16) -- line: 331
        -- upvalues: t3 (copy), t5 (copy), startDrop (copy), Toast (copy), v1 (copy), v2 (copy)
        local t7, v37, v38

        if typeof(p16) == "table" then
            if type(p16.BossId) == "string" then
                if type(p16.Souls) == "number" then
                    if type(p16.Balance) == "number" then
                        t7 = {
                            BossId = p16.BossId
                        }
                        t7.Souls = math.max(math.floor(p16.Souls), 0)
                        v37 = if type(p16.Damage) == "number" then p16.Damage else 0
                        v38 = false
                    else
                        v38 = true
                    end
                else
                    v38 = true
                end
            else
                v38 = true
            end
        else
            v38 = true
        end

        if v38 then
            return
        end

        t7.Damage = v37
        t7.Balance = p16.Balance

        if type(p16.Rank) == "number" then
            t7.Rank = p16.Rank
        else
            t7.Rank = 0
        end

        if type(p16.Participants) == "number" then
            t7.Participants = p16.Participants
        else
            t7.Participants = 0
        end

        if t7.Rank == 1 and t7.Participants > 1 then
            Toast.Show({
                Lane = "Feed",
                Text = "You dealt the most damage to Ghouler!",
                Seconds = 4,
                Color = v1,
                StrokeColor = v2
            })
        end

        local v40 = t3[t7.BossId]

        if v40 then
            v40:AddSouls(t7)
        else
            t5[t7.BossId] = t7
            startDrop(t7.BossId)
        end

        if t7.Souls > 0 then
            Toast.Show({
                Lane = "Feed",
                Seconds = 3,
                Image = "rbxassetid://83798853441239",
                Text = ("+%* Souls"):format(t7.Souls),
                Color = v1,
                StrokeColor = v2
            })
        end
    end)
    v4:Connect(v5.AttributeChanged, sync)
    sync()
    v4:Connect(RunService.RenderStepped, function(p17) -- line: 373
        -- upvalues: v5 (copy), v7 (ref), v8 (ref), v9 (ref), t2 (copy), t3 (copy), v10 (ref), v11 (ref), v12 (ref), n1 (ref), v13 (ref), n2 (ref), setSucking (copy), wantsBoss (copy), Workspace (copy), GhostBoss (copy), GhostBoss3 (copy), Toast (copy), TrainGhostVisuals (copy), LocalPlayer (copy), Attributes (copy), Phases (copy), v1 (copy), v2 (copy)
        if v10 and (v12 == nil or v12.Parent ~= LocalPlayer.Character) and v10 ~= false then
            v10 = false

            if not v10 and v11 ~= false then
                v11 = false
                n1 = 0
                GhostBoss3.Suction:FireServer(false)

                if v7 then
                    v7:SetLocalSucking(false)
                end

                TrainGhostVisuals.SetYield(false)
            end
        end

        local v41 = v7

        setSucking((wantsBoss(v41)))

        if v11 and os.clock() >= n1 then
            n1 = os.clock() + 0.25

            local Suction = GhostBoss3.Suction
            local CurrentCamera = Workspace.CurrentCamera

            Suction:FireServer(true, if CurrentCamera then CurrentCamera.CFrame.LookVector else nil)
        end

        local v42

        if v41 == nil or v12 == nil then
            v42 = false
        else
            local v43 = v12
            local v44 = v43:IsA("Tool") and v43:GetAttribute(GhostBoss.ToolAttribute) ~= nil

            if v44 then
                v42 = v44
            else
                local CurrentCamera = Workspace.CurrentCamera

                v42 = v41:InCone(if CurrentCamera then CurrentCamera.CFrame.LookVector else nil)
            end
        end

        if v10 and v41 and v42 and GhostBoss.RealmOf(LocalPlayer) == GhostBoss.RealmNamed(v5:GetAttribute(Attributes.Realm)) and v41:GetPhase() == Phases.Alive and not v41:InReach() then
            local v45 = v13 or os.clock()

            v13 = v45

            if os.clock() - v45 >= 0.8 and os.clock() - n2 >= 5 then
                n2 = os.clock()
                Toast.Show({
                    Lane = "Feed",
                    Text = "Get closer to Ghouler!",
                    Seconds = 2,
                    Color = v1,
                    StrokeColor = v2
                })
            end
        else
            v13 = nil
        end

        if v41 then
            v41:Step(p17)

            if v8 then
                v8:Step(v41:GetPhase())
            end

            if v41:IsFinished() and v9 == "" then
                v41:Destroy()
                v7 = nil
            end
        end

        for i = #t2, 1, -1 do
            local v47 = t2[i]

            v47:Step(p17)

            if v47:IsDone() then
                v47:Destroy()
                table.remove(t2, i)

                for v48, v49 in t3 do
                    if v49 == v47 then
                        t3[v48] = nil
                    end
                end
            end
        end
    end)
    v4:Add(function() -- line: 431
        -- upvalues: v7 (ref), v8 (ref), t2 (copy), SoulsHud (copy), TrainGhostVisuals (copy)
        TrainGhostVisuals.SetYield(false)

        if v8 then
            v8:Destroy()
        end

        if v7 then
            v7:Destroy()
        end

        for _, v50 in t2 do
            v50:Destroy()
        end

        SoulsHud.Reset()
    end)
end

return t1
