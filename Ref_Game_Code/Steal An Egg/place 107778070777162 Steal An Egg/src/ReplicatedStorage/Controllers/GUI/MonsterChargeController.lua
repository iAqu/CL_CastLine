-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local MonsterParasiteEligibility = require(ReplicatedStorage.Shared.Util.MonsterParasiteEligibility)
local MonsterParasite2 = require(ReplicatedStorage.Shared.Types.MonsterParasite)

require(ReplicatedStorage.Packages.Networking)

local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Trove = require(ReplicatedStorage.Packages.Trove)

return {
    Start = function() -- Start | line: 76
        -- upvalues: Players (copy), ReplicatedStorage (copy), RunService (copy), Workspace (copy), MonsterParasite (copy), MonsterParasiteEligibility (copy), MonsterParasite2 (copy), Remotes (copy), Save (copy), Timer (copy), Trove (copy)
        local MonsterParasite3 = Remotes.MonsterParasite
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local v1 = Trove.new()
        local t2 = {
            Active = false
        }
        local v2 = t2

        t2.EndsAt = MonsterParasite.EndsAt
        t2.ServerTime = os.time()

        local n1 = 0
        local Part, v3, Fill, v4, v5
        local v6 = false
        local t3 = {}
        local v7
        local v8 = true
        local n2 = 0
        local n3 = 0
        local v9
        local n4 = 0
        local v10
        local v11 = false
        local n5 = 0
        local Charge, v12
        local t4 = {}
        local Attribute

        local function formatRemaining(p1) -- line: 122
            local v14 = math.max(math.floor(p1), 0)
            local v15 = v14 // 86400
            local v16 = v14 % 86400 // 3600
            local v17 = v14 % 3600 // 60

            if v15 > 0 then
                return (("%*d %*h"):format(v15, v16))
            end

            return (("%*h %*m"):format(v16, v17))
        end

        local function getOwnedMonster() -- line: 133
            -- upvalues: LocalPlayer (copy), Workspace (copy), MonsterParasite (copy)
            local v18 = Workspace:FindFirstChild(MonsterParasite.WorldFolderName)

            if v18 ~= nil and v18:IsA("Folder") then
                for _, child in v18:GetChildren() do
                    if child:IsA("Model") and child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                        return child
                    end
                end
            end

            return nil
        end

        local function resolveTemplate() -- line: 146
            -- upvalues: v6 (ref), ReplicatedStorage (copy)
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local Extra = if Assets then Assets:FindFirstChild("Extra") else nil
            local MonsterBillboardAttachment = if Extra then Extra:FindFirstChild("MonsterBillboardAttachment") else nil

            if MonsterBillboardAttachment ~= nil and MonsterBillboardAttachment:IsA("Attachment") then
                return MonsterBillboardAttachment
            end

            if not v6 then
                v6 = true
                warn("[MonsterCharge] Missing ReplicatedStorage.Assets.Extra.MonsterBillboardAttachment; the monster billboard is skipped")
            end

            return nil
        end

        local function resolveMonsterTemplate(p2) -- line: 162
            -- upvalues: ReplicatedStorage (copy), MonsterParasite (copy)
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local Models = if Assets then Assets:FindFirstChild("Models") else nil
            local v19 = if Models then Models:FindFirstChild(MonsterParasite.AssetsFolderName) else nil
            local v20 = MonsterParasite.MonsterModelNames[p2]
            local v21 = if not v19 or not v20 then nil else v19:FindFirstChild(v20)

            return if v21 and v21:IsA("Model") and v21.PrimaryPart then v21 else nil
        end

        local function measureHeadHeight(p3) -- line: 177
            local PrimaryPart = p3.PrimaryPart

            if PrimaryPart == nil then
                return nil
            end

            local BoundingBox, BoundingBox2 = p3:GetBoundingBox()
            local v22 = BoundingBox.Position + Vector3.new(0, 1, 0) * (BoundingBox2.Y * 0.5)

            return PrimaryPart.CFrame:PointToObjectSpace(v22).Y
        end

        local function resolveBillboardHeight(p4, p5) -- line: 192
            -- upvalues: t3 (copy), resolveMonsterTemplate (copy), MonsterParasite (copy)
            local Attribute = p4:GetAttribute(MonsterParasite.MonsterModelIndexAttributeName)

            if typeof(Attribute) ~= "number" then
                Attribute = nil
            end

            local v23 = if Attribute then t3[Attribute] else nil
            local v24

            if v23 ~= nil then
                v24 = v23
            else
                local v25 = if Attribute then resolveMonsterTemplate(Attribute) else nil

                if v25 then
                    local PrimaryPart = v25.PrimaryPart

                    if PrimaryPart ~= nil then
                        local BoundingBox, BoundingBox2 = v25:GetBoundingBox()
                        local v26 = BoundingBox.Position + Vector3.new(0, 1, 0) * (BoundingBox2.Y * 0.5)

                        v24 = PrimaryPart.CFrame:PointToObjectSpace(v26).Y
                    end
                end

                if not v24 then
                    local PrimaryPart = p4.PrimaryPart

                    if PrimaryPart ~= nil then
                        local BoundingBox, BoundingBox2 = p4:GetBoundingBox()
                        local v27 = BoundingBox.Position + Vector3.new(0, 1, 0) * (BoundingBox2.Y * 0.5)

                        v24 = PrimaryPart.CFrame:PointToObjectSpace(v27).Y
                    else
                        v24 = nil
                    end
                end

                if v24 ~= nil and Attribute ~= nil then
                    t3[Attribute] = v24
                end
            end

            if v24 == nil then
                return 8.5
            end

            return v24 + (if p5 then p5.Size.Y.Scale * 0.5 else 2) + 0.75
        end

        local function setLabelText(p6, p7, p8) -- line: 214
            local v28 = p6:FindFirstChild(p7, true)

            if v28 ~= nil and v28:IsA("TextLabel") then
                v28.Text = p8
            end
        end

        local function resolveDebrisFolder() -- line: 221
            -- upvalues: Workspace (copy)
            local Transient = Workspace:FindFirstChild("Transient")

            if Transient == nil then
                return Workspace
            end

            return Transient
        end

        local function createAnchor() -- line: 230
            -- upvalues: Workspace (copy)
            local Part = Instance.new("Part")

            Part.Name = "MonsterBillboardAnchor"
            Part.Size = Vector3.new(0.1, 0.1, 0.1)
            Part.Transparency = 1
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Massless = true
            Part.Locked = true
            Part.Archivable = false

            local Transient = Workspace:FindFirstChild("Transient")

            Part.Parent = if Transient == nil then Workspace else Transient

            return Part
        end

        local function destroyBillboard() -- line: 247
            -- upvalues: Part (ref), v3 (ref), Fill (ref), v4 (ref), v5 (ref), v7 (ref), v8 (ref)
            if Part ~= nil then
                Part:Destroy()
                Part = nil
            end

            v3 = nil
            Fill = nil
            v4 = nil
            v5 = nil
            v7 = nil
            v8 = true
        end

        local function ensureBillboard(p9) -- line: 261
            -- upvalues: Part (ref), v3 (ref), Fill (ref), v4 (ref), v5 (ref), v7 (ref), v8 (ref), resolveTemplate (copy), resolveBillboardHeight (copy), Workspace (copy), MonsterParasite (copy)
            local PrimaryPart = p9.PrimaryPart

            if PrimaryPart == nil then
                if Part ~= nil then
                    Part:Destroy()
                    Part = nil
                end

                v3 = nil
                Fill = nil
                v4 = nil
                v5 = nil
                v7 = nil
                v8 = true

                return nil
            end

            local v29 = resolveTemplate()

            if v29 == nil then
                if Part ~= nil then
                    Part:Destroy()
                    Part = nil
                end

                v3 = nil
                Fill = nil
                v4 = nil
                v5 = nil
                v7 = nil
                v8 = true

                return nil
            end

            local Part2 = Part
            local Part3 = Part2

            if Part2 ~= nil then
                if Part2.Parent == nil then
                    if Part ~= nil then
                        Part:Destroy()
                        Part = nil
                    end

                    v3 = nil
                    Fill = nil
                    v4 = nil
                    v5 = nil
                    v7 = nil
                    v8 = true
                    Part3 = nil
                end
            end

            local v30 = v3
            local Part4, v31

            if Part3 == nil or v30 == nil then
                if Part ~= nil then
                    Part:Destroy()
                    Part = nil
                end

                v3 = nil
                Fill = nil
                v4 = nil
                v5 = nil
                v7 = nil
                v8 = true
                Part4 = Instance.new("Part")
                Part4.Name = "MonsterBillboardAnchor"
                Part4.Size = Vector3.new(0.1, 0.1, 0.1)
                Part4.Transparency = 1
                Part4.Anchored = true
                Part4.CanCollide = false
                Part4.CanQuery = false
                Part4.CanTouch = false
                Part4.CastShadow = false
                Part4.Massless = true
                Part4.Locked = true
                Part4.Archivable = false

                local Transient = Workspace:FindFirstChild("Transient")

                if Transient == nil then
                    Transient = Workspace
                end

                Part4.Parent = Transient
                v31 = v29:Clone()
                v31.Parent = Part4
                Part = Part4
                v3 = v31

                local MonsterDisplayName = MonsterParasite.MonsterDisplayName
                local v32 = v31:FindFirstChild("MonsterName", true)

                if v32 ~= nil and v32:IsA("TextLabel") then
                    v32.Text = MonsterDisplayName
                end

                local v33 = v31:FindFirstChild("Progress", true)
                local Fill2, v34

                if v33 then
                    Fill2 = v33:FindFirstChild("Fill")
                    v34 = v33:FindFirstChild("Progress", true)
                end

                if not (Fill2 and Fill2:IsA("GuiObject")) then
                    Fill2 = nil
                end

                Fill = Fill2

                if not (v34 and v34:IsA("TextLabel")) then
                    v34 = nil
                end

                v4 = v34
            else
                v31 = v30
                Part4 = Part3
            end

            if Part4.CFrame ~= PrimaryPart.CFrame then
                Part4.CFrame = PrimaryPart.CFrame
            end

            local v35 = resolveBillboardHeight(p9, (v31:FindFirstChildWhichIsA("BillboardGui")))

            v7 = v35

            if v8 then
                v8 = false
                v31.Position = Vector3.new(0, v35, 0)
            end

            v5 = p9

            return v31
        end

        local function render() -- line: 335
            -- upvalues: v2 (ref), n1 (ref), Part (ref), v3 (ref), Fill (ref), v4 (ref), v5 (ref), v7 (ref), v8 (ref), n2 (ref), n3 (ref), v9 (ref), v11 (ref), Charge (ref), v12 (ref), t4 (copy), getOwnedMonster (copy), ensureBillboard (copy), MonsterParasite (copy), MonsterParasiteEligibility (copy), Save (copy)
            local v36 = Save.Await()
            local v37 = v36 ~= nil and MonsterParasiteEligibility.IsEligible(v36.SpeedPower)
            local v38 = getOwnedMonster()

            if v36 ~= nil and v37 and v2.Active and v38 ~= nil then
                local v39 = ensureBillboard(v38)

                if v39 ~= nil then
                    local MonsterParasite2 = v36.MonsterParasite
                    local Charge2 = Charge

                    Charge = MonsterParasite2.Charge

                    if v12 ~= nil then
                        if Charge2 ~= nil and MonsterParasite2.Charge ~= Charge2 then
                            table.insert(t4, {
                                Wrap = MonsterParasite2.Charge < Charge2,
                                Since = os.clock()
                            })
                        end
                    else
                        v12 = MonsterParasite2.Charge
                    end

                    n2 = if v11 then 1 else math.clamp((v12 or 0) / MonsterParasite.MaxCharge, 0, 1)

                    local v42 = os.time() + n1
                    local v45 = math.max(math.floor(v2.EndsAt - v42), 0)
                    local v46 = v45 // 86400
                    local v47 = v45 % 86400 // 3600
                    local v48 = v45 % 3600 // 60
                    local v49 = ("Leaves in %*"):format(if v46 > 0 then ("%*d %*h"):format(v46, v47) else ("%*h %*m"):format(v47, v48))
                    local v50 = v39:FindFirstChild("Timer", true)

                    if v50 ~= nil and v50:IsA("TextLabel") then
                        v50.Text = v49
                    end
                end
            else
                if Part ~= nil then
                    Part:Destroy()
                    Part = nil
                end

                v3 = nil
                Fill = nil
                v4 = nil
                v5 = nil
                v7 = nil
                v8 = true
                Charge = nil
                v12 = nil
                table.clear(t4)
                v11 = false
                v9 = nil
                n3 = 0
                n2 = 0
            end
        end

        local function releaseGain() -- line: 399
            -- upvalues: n2 (ref), v11 (ref), n5 (ref), Charge (ref), v12 (ref), t4 (copy), MonsterParasite (copy)
            local v51 = table.remove(t4, 1)

            if v51 ~= nil then
                if v51.Wrap then
                    v12 = MonsterParasite.MaxCharge
                    v11 = true
                    n5 = os.clock()
                else
                    v12 = math.clamp((v12 or 0) + MonsterParasite.ChargePerFeed, 0, MonsterParasite.MaxCharge)

                    if #t4 == 0 then
                        v12 = Charge
                    end
                end

                n2 = if v11 then 1 else math.clamp((v12 or 0) / MonsterParasite.MaxCharge, 0, 1)
            end
        end

        local function stepAnchor(p10) -- line: 427
            -- upvalues: Part (ref), v3 (ref), v5 (ref), v7 (ref)
            local Part2 = Part
            local v57 = v3
            local v58 = v7

            if Part2 == nil or v57 == nil or v58 == nil then
                return
            end

            local v59 = v5
            local PrimaryPart = if v59 == nil then nil else v59.PrimaryPart

            if PrimaryPart ~= nil and Part2.CFrame ~= PrimaryPart.CFrame then
                Part2.CFrame = PrimaryPart.CFrame
            end

            local Y = v57.Position.Y

            if math.abs(v58 - Y) < 0.001 then
                if Y ~= v58 then
                    v57.Position = Vector3.new(0, v58, 0)
                end
            else
                v57.Position = Vector3.new(0, Y + (v58 - Y) * math.min(p10 * 9, 1), 0)
            end
        end

        local function stepBar(p11) -- line: 455
            -- upvalues: LocalPlayer (copy), Fill (ref), v4 (ref), v5 (ref), n2 (ref), n3 (ref), v9 (ref), n4 (ref), v10 (ref), v11 (ref), n5 (ref), Charge (ref), v12 (ref), t4 (copy), Attribute (ref), releaseGain (copy), stepAnchor (copy), MonsterParasite (copy), MonsterParasite2 (copy)
            stepAnchor(p11)

            local Fill2 = Fill

            if Fill2 == nil then
                return
            end

            local Attribute2 = LocalPlayer:GetAttribute(MonsterParasite2.ChargeGainAttributeName)

            if typeof(Attribute2) == "number" and Attribute2 ~= Attribute then
                Attribute = Attribute2
                releaseGain()
            end

            local v64 = t4[1]

            if v64 ~= nil and os.clock() - v64.Since > MonsterParasite2.ChargeGainCueTimeout then
                releaseGain()
            end

            local v65 = v5
            local v66 = if v65 then v65:GetAttribute(MonsterParasite2.ChargeDrainAttributeName) else nil

            if typeof(v66) ~= "number" or v66 == v10 then
                if v11 and os.clock() - n5 > 6 then
                    v11 = false
                    v9 = math.max(n3, n2)
                    n4 = os.clock()
                    v12 = Charge
                    n2 = if v11 then 1 else math.clamp((v12 or 0) / MonsterParasite.MaxCharge, 0, 1)
                end
            else
                v10 = v66
                v11 = false
                v9 = math.max(n3, n2)
                n4 = os.clock()
                v12 = Charge

                local v67 = if v11 then 1 else math.clamp((v12 or 0) / MonsterParasite.MaxCharge, 0, 1)

                n2 = v67
            end

            local v76 = v9

            if v76 ~= nil then
                local v82 = math.clamp((os.clock() - n4) / MonsterParasite2.ChargeDrainDuration, 0, 1)

                n3 = v76 * (1 - v82 * v82 * (3 - v82 * 2))

                if v82 >= 1 then
                    v9 = nil
                    n3 = 0
                end
            else
                n3 += (n2 - n3) * math.min(p11 * 14, 1)

                if math.abs(n2 - n3) < 0.001 then
                    n3 = n2
                end
            end

            local v84 = math.clamp(n3, 0, 1)

            Fill2.Size = UDim2.fromScale(v84, 1)

            local v85 = v4

            if v85 ~= nil then
                v85.Text = ("%*%%"):format((math.round(v84 * 100)))
            end
        end

        local function setEventState(p12) -- line: 526
            -- upvalues: v2 (ref), n1 (ref), render (copy)
            v2 = p12
            n1 = p12.ServerTime - os.time()
            render()
        end

        local function disableLegacyHud(p13) -- line: 532
            -- upvalues: PlayerGui (copy), MonsterParasite (copy)
            local v87 = if p13 == nil then PlayerGui:FindFirstChild(MonsterParasite.HudName) else p13

            if v87 ~= nil and v87.Name == MonsterParasite.HudName and v87:IsA("ScreenGui") then
                v87.Enabled = false
            end
        end

        v1:Connect(PlayerGui.ChildAdded, disableLegacyHud)

        local v88 = PlayerGui:FindFirstChild(MonsterParasite.HudName)

        if v88 ~= nil and v88.Name == MonsterParasite.HudName and v88:IsA("ScreenGui") then
            v88.Enabled = false
        end

        v1:Connect(Save.Watch("MonsterParasite"), render)
        v1:Connect(Save.Watch("SpeedPower"), render)
        v1:Connect(MonsterParasite3.EventStateShifted.OnClientEvent, function(p14) -- line: 550
            -- upvalues: v2 (ref), n1 (ref), render (copy), MonsterParasite2 (copy)
            if not MonsterParasite2.EventStateSchema(p14) then
                return
            end

            v2 = p14
            n1 = p14.ServerTime - os.time()
            render()
        end)
        v1:Connect(RunService.RenderStepped, stepBar)

        local v89 = Timer.new(0.15)

        v1:Add(v89)
        v1:Connect(v89.Tick, render)
        v89:Start()
        task.spawn(function() -- line: 563
            -- upvalues: MonsterParasite3 (copy), v2 (ref), n1 (ref), render (copy), MonsterParasite2 (copy)
            local function v90() -- line: 564
                -- upvalues: MonsterParasite3 (copy)
                return MonsterParasite3.AskSnapshot:InvokeServer()
            end

            local ok, result = pcall(v90)

            if not (ok and MonsterParasite2.SnapshotSchema(result)) then
                return
            end

            local Event = result.Event

            v2 = Event
            n1 = Event.ServerTime - os.time()
            render()
        end)
    end
}
