-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Directory = require(ReplicatedStorage.Data.Assets).Directory

require(ReplicatedStorage.Shared.Globals.Constants)

local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local EggRenderer = require(ReplicatedStorage.Shared.Eggs.EggRenderer)
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Message = require(ReplicatedStorage.Client.Message)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Sakura = require(ReplicatedStorage.Data.Sakura)
local SakuraFX = require(ReplicatedStorage.Client.SakuraFX)
local SakuraSignals = require(ReplicatedStorage.Client.SakuraSignals)
local Sakura2 = require(ReplicatedStorage.Shared.Types.Sakura)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Emit = require(ReplicatedStorage.UserGenerated.VFX.Emit)

return {
    Start = function() -- Start | line: 35
        -- upvalues: ContentProvider (copy), Debris (copy), Players (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), Directory (copy), EggRecords (copy), EggRenderer (copy), GameFlags (copy), HiddenUIHandler (copy), Message (copy), Mutations (copy), Toast (copy), Remotes (copy), Sakura (copy), SakuraFX (copy), SakuraSignals (copy), Sakura2 (copy), Save (copy), Tabs (copy), Trove (copy), Emit (copy)
        if not GameFlags.GreatBloomEnabled:Get() then
            return
        end

        local v1 = Color3.fromRGB(255, 120, 200)
        local v2 = Color3.fromRGB(255, 0, 0)
        local t2 = {
            1.5, 9
        }
        local v3 = Color3.fromRGB(235, 154, 200)
        local v4 = Color3.fromRGB(255, 200, 232)
        local v5 = Color3.fromRGB(255, 240, 248)
        local LocalPlayer = Players.LocalPlayer
        local CurrentCamera = Workspace.CurrentCamera
        local World = Workspace:WaitForChild("World")
        local Build = World:WaitForChild("Build")
        local IncubatorAnchor = World:WaitForChild("Areas"):WaitForChild("CherryBlossom"):WaitForChild("IncubatorAnchor")

        assert(IncubatorAnchor:IsA("BasePart"), "CherryBlossom.IncubatorAnchor must be a BasePart")

        local Sakura3 = ReplicatedStorage.Assets.Models.Sakura
        local IncubatorDead, IncubatorBloomed, CraneSign, Cutscene = Sakura3.IncubatorDead, Sakura3.IncubatorBloomed, Sakura3.CraneSign, Sakura3.Cutscene
        local CameraRig, CraneRig, PlayerRig, LeafCover = Cutscene.CameraRig, Cutscene.CraneRig, Cutscene.PlayerRig, Cutscene.LeafCover
        local LeafRing, BlossomEffect, Floor = Cutscene.LeafRing, Cutscene.BlossomEffect, Cutscene.Floor
        local Cutscene2 = script:WaitForChild("Cutscene")

        assert(Cutscene2:IsA("Sound"), "SakuraIncubator.Cutscene must be a Sound")
        assert(BlossomEffect:IsA("BasePart") and Floor:IsA("BasePart"), "Sakura cutscene BlossomEffect and Floor must be BaseParts")
        assert(IncubatorDead.PrimaryPart and IncubatorBloomed.PrimaryPart, "Sakura incubator templates need PrimaryParts")
        assert(CraneSign:IsA("Model") and CraneSign.PrimaryPart, "Sakura.CraneSign must be a Model with a PrimaryPart")
        assert(CameraRig.PrimaryPart and CraneRig.PrimaryPart and PlayerRig.PrimaryPart, "Sakura cutscene rigs need PrimaryParts")
        assert(LeafCover.PrimaryPart, "Sakura cutscene LeafCover needs a PrimaryPart")
        assert(LeafRing.PrimaryPart, "Sakura cutscene LeafRing needs a PrimaryPart")

        local CameraAnimation = CameraRig.CameraAnimation
        local CraneAnimation = CraneRig.CraneAnimation
        local PlayerAnimation = PlayerRig.PlayerAnimation

        assert(CameraAnimation:IsA("Animation") and CraneAnimation:IsA("Animation") and PlayerAnimation:IsA("Animation"), "Sakura cutscene rigs need their Animation children")

        local IncubatorBillboard = Sakura3.IncubatorBillboard

        assert(IncubatorBillboard:IsA("BillboardGui"), "Sakura.IncubatorBillboard must be a BillboardGui")

        local v6 = Trove.new()
        local clone, PointLight, clone2, v7
        local v8 = false
        local refresh

        local function notifyError(p1) -- line: 135
            -- upvalues: v2 (copy), Toast (copy)
            Toast.Show({
                Seconds = 3,
                Text = p1,
                Color = v2
            })
        end

        local function isUnlocked() -- line: 143
            -- upvalues: Save (copy)
            local v9 = Save.Await()

            return v9 ~= nil and v9.Sakura.Unlocked
        end

        local function spawnVisual(p2, p3) -- line: 148
            -- upvalues: Workspace (copy)
            local clone = p2:Clone()

            clone:PivotTo(p3)
            clone.Parent = Workspace

            return clone
        end

        local function rigCFrame(p4) -- line: 155
            -- upvalues: IncubatorAnchor (copy)
            local RootOffset = p4:GetAttribute("RootOffset")

            assert(typeof(RootOffset) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(p4.Name)))

            return IncubatorAnchor.CFrame * RootOffset
        end

        local function makePrompt(p5, p6, p7, p8) -- line: 161
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "PromptAttachment"
            Attachment.Position = Vector3.new(0, 3, 0)
            Attachment.Parent = p5

            local ProximityPrompt = Instance.new("ProximityPrompt")

            ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
            ProximityPrompt.ActionText = p6
            ProximityPrompt.ObjectText = p7
            ProximityPrompt.HoldDuration = 0
            ProximityPrompt.RequiresLineOfSight = false
            ProximityPrompt.MaxActivationDistance = p8
            ProximityPrompt.Parent = Attachment

            return ProximityPrompt
        end

        local function getChargePercent() -- line: 182
            -- upvalues: Sakura (copy), Save (copy)
            local v12 = Save.Await()

            if v12 == nil or v12.Sakura.Egg == false then
                return 0, false
            end

            return Sakura.GetChargePercent(v12.Sakura.Deposited, Sakura.GetRequiredCrystals()), true
        end

        local function getNextBloomAt(p9) -- line: 191
            -- upvalues: Sakura (copy)
            local IntervalSeconds = Sakura.Bloom.IntervalSeconds

            return p9 + IntervalSeconds - (p9 + Sakura.Bloom.OffsetSeconds) % IntervalSeconds
        end

        local function getBloomStatusText() -- line: 196
            -- upvalues: Workspace (copy), Sakura (copy)
            local ServerTimeNow = Workspace:GetServerTimeNow()
            local Attribute = Workspace:GetAttribute(Sakura.Bloom.EndsAtAttribute)

            if typeof(Attribute) == "number" and ServerTimeNow < Attribute then
                return "The Great Bloom is live!"
            end

            local IntervalSeconds = Sakura.Bloom.IntervalSeconds
            local v14 = math.max(0, ServerTimeNow + IntervalSeconds - (ServerTimeNow + Sakura.Bloom.OffsetSeconds) % IntervalSeconds - ServerTimeNow)

            return (("Next Great Bloom in %*:%*"):format(math.floor(v14 / 60), (string.format("%02d", (math.floor(v14 % 60))))))
        end

        local function syncBillboardEnabled() -- line: 209
            -- upvalues: clone (ref), v8 (ref)
            local clone2 = clone

            if clone2 then
                clone2.Enabled = not v8
            end
        end

        local function renderBillboard() -- line: 216
            -- upvalues: clone (ref), PointLight (ref), v8 (ref), getBloomStatusText (copy), TweenService (copy), Sakura (copy), Save (copy)
            local clone2 = clone

            if clone2 == nil then
                return
            end

            clone2.Enabled = not v8

            local Countdown, Progress = clone2.Countdown, clone2.Progress

            assert(Countdown:IsA("TextLabel") and Progress:IsA("Frame"), "IncubatorBillboard needs Countdown and Progress")

            local Bar = Progress.Bar

            assert(Bar:IsA("Frame"), "IncubatorBillboard.Progress.Bar must be a Frame")

            local v19 = Save.Await()

            if v19 == nil or not v19.Sakura.Unlocked then
                Countdown.Text = "Return a Crane pet to unlock Great Bloom"
                Progress.Visible = false

                return
            end

            local v20 = Save.Await()
            local v21, v22

            if v20 == nil or v20.Sakura.Egg == false then
                v22 = 0
                v21 = false
            else
                v22 = Sakura.GetChargePercent(v20.Sakura.Deposited, Sakura.GetRequiredCrystals())
                v21 = true
            end

            Countdown.Text = getBloomStatusText()

            if not v21 then
                Progress.Visible = false

                return
            end

            Progress.Visible = true
            TweenService:Create(Bar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromScale(math.clamp(v22 / Sakura.Incubator.MaxChargePercent, 0, 1), 1)
            }):Play()

            local PointLight2 = PointLight

            if PointLight2 then
                TweenService:Create(PointLight2, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Brightness = math.clamp(v22 / Sakura.Incubator.MaxChargePercent, 0, 1) * 3
                }):Play()
            end
        end

        local function buildTree(p10) -- line: 257
            -- upvalues: v1 (copy), v2 (copy), IncubatorAnchor (copy), IncubatorDead (copy), IncubatorBloomed (copy), CraneSign (copy), IncubatorBillboard (copy), v6 (copy), clone (ref), PointLight (ref), clone2 (ref), v7 (ref), v8 (ref), renderBillboard (copy), TweenService (copy), Workspace (copy), Toast (copy), Remotes (copy), Tabs (copy)
            v6:Clean()

            local v27 = if p10 then IncubatorBloomed else IncubatorDead
            local CFrame = IncubatorAnchor.CFrame
            local clone3 = v27:Clone()

            clone3:PivotTo(CFrame)
            clone3.Parent = Workspace
            v6:Add(clone3)
            clone2 = clone3
            v7 = p10

            if p10 then
                local Door = clone3:WaitForChild("Door")

                Door.CanCollide = false
                Door.CanTouch = false
                Door.CanQuery = false
                TweenService:Create(Door, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Transparency = 1
                }):Play()
            end

            local Radius = v27:GetAttribute("Radius")
            local Height = v27:GetAttribute("Height")
            local PrimaryPart = clone3.PrimaryPart

            clone3:AddTag("MainSakuraTree")

            local clone4 = IncubatorBillboard:Clone()

            clone4.StudsOffsetWorldSpace = Vector3.new(0, Height * 0.65, 0)
            clone4.Enabled = not v8
            clone4.Parent = PrimaryPart
            clone = clone4
            PointLight = nil

            if p10 then
                local Attachment = Instance.new("Attachment")

                Attachment.Name = "ChargeGlow"
                Attachment.Position = Vector3.new(0, Height * 0.6, 0)
                Attachment.Parent = PrimaryPart

                local PointLight2 = Instance.new("PointLight")

                PointLight2.Color = v1
                PointLight2.Brightness = 0
                PointLight2.Range = 50
                PointLight2.Parent = Attachment
                PointLight = PointLight2
            end

            v6:Add(function() -- line: 301
                -- upvalues: clone (ref), PointLight (ref)
                clone = nil
                PointLight = nil
            end)
            renderBillboard()

            if p10 then
                local v30 = Radius + 8
                local Attachment = Instance.new("Attachment")

                Attachment.Name = "PromptAttachment"
                Attachment.Position = Vector3.new(0, 3, 0)
                Attachment.Parent = PrimaryPart

                local ProximityPrompt = Instance.new("ProximityPrompt")

                ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
                ProximityPrompt.ActionText = "Open Incubator"
                ProximityPrompt.ObjectText = "Sakura Incubator"
                ProximityPrompt.HoldDuration = 0
                ProximityPrompt.RequiresLineOfSight = false
                ProximityPrompt.MaxActivationDistance = v30
                ProximityPrompt.Parent = Attachment
                v6:Add(ProximityPrompt.Triggered:Connect(function() -- line: 308
                    -- upvalues: Tabs (copy)
                    Tabs.Activate("SakuraEggCharge")
                end))
            elseif not v8 then
                local RootOffset = CraneSign:GetAttribute("RootOffset")

                assert(typeof(RootOffset) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(CraneSign.Name)))

                local v33 = IncubatorAnchor.CFrame * RootOffset
                local clone = CraneSign:Clone()

                clone:PivotTo(v33)
                clone.Parent = Workspace
                v6:Add(clone)

                local v34 = Radius + 8
                local Attachment = Instance.new("Attachment")

                Attachment.Name = "PromptAttachment"
                Attachment.Position = Vector3.new(0, 3, 0)
                Attachment.Parent = PrimaryPart

                local ProximityPrompt = Instance.new("ProximityPrompt")

                ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
                ProximityPrompt.ActionText = "Hatch and Return Crane pet"
                ProximityPrompt.ObjectText = "Dormant Sakura Tree"
                ProximityPrompt.HoldDuration = 0
                ProximityPrompt.RequiresLineOfSight = false
                ProximityPrompt.MaxActivationDistance = v34
                ProximityPrompt.Parent = Attachment
                v6:Add(ProximityPrompt.Triggered:Connect(function() -- line: 312
                    -- upvalues: ProximityPrompt (copy), v2 (copy), Toast (copy), Remotes (copy)
                    ProximityPrompt.Enabled = false

                    local v35, v36 = Remotes.Bloomery.AskCraneReturn:InvokeServer()

                    if v35 then
                        return
                    end

                    local v37 = if typeof(v36) == "string" then v36 else "The tree sleeps... bring it a Crane pet"

                    Toast.Show({
                        Seconds = 3,
                        Text = v37,
                        Color = v2
                    })
                    ProximityPrompt.Enabled = true
                end))
            end
        end

        local function emitPetals(p11, p12) -- line: 327
            for _, descendant in ipairs(p11:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant:Emit(p12)
                end
            end
        end

        local function playTrack(p13, p14) -- line: 335
            local track = p13:LoadAnimation(p14)

            track.Priority = Enum.AnimationPriority.Action4
            track.Looped = false
            track:Play(0)

            return track
        end

        local function getAnimator(p15) -- line: 343
            local v38 = p15:FindFirstChildOfClass("Humanoid") or p15:FindFirstChildOfClass("AnimationController")

            assert(v38, (("%* needs a Humanoid or AnimationController"):format(p15.Name)))

            local Animator = v38:FindFirstChildOfClass("Animator")

            assert(Animator, (("%* needs an Animator"):format(p15.Name)))

            return Animator
        end

        local function cloneCharacterRig() -- line: 352
            -- upvalues: LocalPlayer (copy), IncubatorAnchor (copy), PlayerRig (copy), Workspace (copy)
            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if Character ~= nil and Humanoid ~= nil and Character.PrimaryPart ~= nil then
                local Archivable = Character.Archivable

                Character.Archivable = true

                local clone = Character:Clone()

                Character.Archivable = Archivable
                clone.Name = "SakuraCutscenePlayer"

                for _, child in ipairs(clone:GetChildren()) do
                    if child:IsA("LocalScript") then
                        child:Destroy()
                    elseif child:IsA("Script") then
                        child:Destroy()
                    elseif child:IsA("Tool") then
                        child:Destroy()
                    end
                end

                local Humanoid = clone:FindFirstChildOfClass("Humanoid")

                assert(Humanoid, "Cloned character lost its Humanoid")
                Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

                if Humanoid:FindFirstChildOfClass("Animator") == nil then
                    Instance.new("Animator").Parent = Humanoid
                end

                for _, descendant in ipairs(clone:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = descendant == clone.PrimaryPart
                        descendant.CanCollide = false
                        descendant.CanQuery = false
                        descendant.CanTouch = false
                        descendant.LocalTransparencyModifier = 0
                    end
                end

                local RootOffset = PlayerRig:GetAttribute("RootOffset")

                assert(typeof(RootOffset) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(PlayerRig.Name)))
                clone:PivotTo(IncubatorAnchor.CFrame * RootOffset)
                clone.Parent = Workspace

                return clone
            end

            local RootOffset = PlayerRig:GetAttribute("RootOffset")

            assert(typeof(RootOffset) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(PlayerRig.Name)))

            local v45 = IncubatorAnchor.CFrame * RootOffset
            local clone = PlayerRig:Clone()

            clone:PivotTo(v45)
            clone.Parent = Workspace

            return clone
        end

        local function hideCharacter(p16) -- line: 389
            -- upvalues: LocalPlayer (copy)
            local Character = LocalPlayer.Character

            if Character == nil then
                return
            end

            local t5 = {}

            for _, descendant in ipairs(Character:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    t5[descendant] = descendant.LocalTransparencyModifier
                    descendant.LocalTransparencyModifier = 1
                elseif descendant:IsA("Decal") then
                    t5[descendant] = descendant.Transparency
                    descendant.Transparency = 1
                end
            end

            p16:Add(function() -- line: 404
                -- upvalues: t5 (copy)
                for v46, v47 in t5 do
                    if v46.Parent then
                        if v46:IsA("BasePart") then
                            v46.LocalTransparencyModifier = v47
                        elseif v46:IsA("Decal") then
                            v46.Transparency = v47
                        end
                    end
                end
            end)
        end

        local function emitEffect(p17) -- line: 417
            -- upvalues: IncubatorAnchor (copy), Debris (copy), Workspace (copy), Emit (copy)
            local clone = p17:Clone()
            local RootOffset = p17:GetAttribute("RootOffset")

            assert(typeof(RootOffset) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(p17.Name)))
            clone.CFrame = IncubatorAnchor.CFrame * RootOffset
            clone.Parent = Workspace
            Debris:AddItem(clone, Emit(clone) + 1)
        end

        local function playBloom(p18) -- line: 424
            -- upvalues: v1 (copy), IncubatorAnchor (copy), BlossomEffect (copy), Floor (copy), clone2 (ref), buildTree (copy), emitPetals (copy), Debris (copy), TweenService (copy), Workspace (copy), Emit (copy)
            buildTree(true)

            local clone = clone2
            local PointLight = Instance.new("PointLight")

            PointLight.Color = v1
            PointLight.Brightness = 6
            PointLight.Range = 60
            PointLight.Parent = clone.PrimaryPart
            p18:Add(PointLight)
            TweenService:Create(PointLight, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Brightness = 0
            }):Play()

            local clone3 = BlossomEffect:Clone()
            local RootOffset = BlossomEffect:GetAttribute("RootOffset")

            assert(typeof(RootOffset) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(BlossomEffect.Name)))
            clone3.CFrame = IncubatorAnchor.CFrame * RootOffset
            clone3.Parent = Workspace
            Debris:AddItem(clone3, Emit(clone3) + 1)

            local clone4 = Floor:Clone()
            local RootOffset2 = Floor:GetAttribute("RootOffset")

            assert(typeof(RootOffset2) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(Floor.Name)))
            clone4.CFrame = IncubatorAnchor.CFrame * RootOffset2
            clone4.Parent = Workspace
            Debris:AddItem(clone4, Emit(clone4) + 1)
            emitPetals(clone, 80)
        end

        local function partKeys(p19) -- line: 444
            local t6 = {}

            local function walk(p20, p21) -- line: 446
                -- upvalues: t6 (copy), walk (copy)
                local t7 = {}

                for _, child in ipairs(p20:GetChildren()) do
                    local v54 = (t7[child.Name] or 0) + 1

                    t7[child.Name] = v54

                    local v55 = ("%*/%*#%*"):format(p21, child.Name, v54)

                    if child:IsA("BasePart") then
                        t6[v55] = child
                    end

                    walk(child, v55)
                end
            end

            walk(p19, "")

            return t6
        end

        local function tweenTreeToBloomed(p22) -- line: 462
            -- upvalues: IncubatorBloomed (copy), clone2 (ref), v7 (ref), TweenService (copy)
            local clone = clone2

            if clone == nil or v7 then
                return
            end

            local t8 = {}

            local function walk(p23, p24) -- line: 446
                -- upvalues: t8 (copy), walk (copy)
                local t9 = {}

                for _, child in ipairs(p23:GetChildren()) do
                    local v56 = (t9[child.Name] or 0) + 1

                    t9[child.Name] = v56

                    local v57 = ("%*/%*#%*"):format(p24, child.Name, v56)

                    if child:IsA("BasePart") then
                        t8[v57] = child
                    end

                    walk(child, v57)
                end
            end

            walk(IncubatorBloomed, "")

            local v58 = TweenInfo.new(p22, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local t10 = {}

            local function walk2(p25, p26) -- line: 446
                -- upvalues: t10 (copy), walk2 (copy)
                local t11 = {}

                for _, child in ipairs(p25:GetChildren()) do
                    local v59 = (t11[child.Name] or 0) + 1

                    t11[child.Name] = v59

                    local v60 = ("%*/%*#%*"):format(p26, child.Name, v59)

                    if child:IsA("BasePart") then
                        t10[v60] = child
                    end

                    walk2(child, v60)
                end
            end

            walk2(clone, "")

            for v61, v62 in t10 do
                local v63 = t8[v61]

                if v63 and v63.Color ~= v62.Color then
                    TweenService:Create(v62, v58, {
                        Color = v63.Color
                    }):Play()
                end
            end
        end

        local function playLeafCover(p27) -- line: 479
            -- upvalues: t2 (copy), v3 (copy), v4 (copy), v5 (copy), LocalPlayer (copy), CurrentCamera (copy), IncubatorAnchor (copy), LeafCover (copy), tweenTreeToBloomed (copy), RunService (copy), TweenService (copy), Workspace (copy)
            local CFrame = IncubatorAnchor.CFrame
            local clone = LeafCover:Clone()

            clone:PivotTo(CFrame)
            clone.Parent = Workspace
            p27:Add(clone)

            local t12 = {}

            for _, descendant in ipairs(clone:GetDescendants()) do
                if descendant:IsA("BasePart") and descendant ~= clone.PrimaryPart then
                    table.insert(t12, descendant)
                end
            end

            table.sort(t12, function(p28, p29) -- line: 488
                return p28.Position.Y < p29.Position.Y
            end)

            local t13 = {}

            for _, v64 in t12 do
                t13[v64] = v64.Size
                v64.Size = Vector3.new(0.05, 0.05, 0.05)
                v64.Transparency = 1
            end

            local Highlight = Instance.new("Highlight")

            Highlight.FillColor = v3
            Highlight.OutlineColor = v4
            Highlight.FillTransparency = 1
            Highlight.OutlineTransparency = 1
            Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            Highlight.Parent = clone

            local v65 = true
            local v66 = false

            p27:Add(function() -- line: 505
                -- upvalues: v65 (ref)
                v65 = false
            end)

            local function sweep(p30, p31, p32) -- line: 507
                -- upvalues: clone (copy), t12 (copy), v65 (ref)
                local v67 = #t12
                local elapsed = os.clock()

                for v68, v69 in t12 do
                    local v72 = p30 * p31((v68 - 1) / math.max(v67 - 1, 1)) - (os.clock() - elapsed)

                    if v72 > 0 then
                        task.wait(v72)
                    end

                    if not v65 or clone.Parent == nil then
                        return
                    end

                    p32(v69)
                end
            end

            local function accelerating(p33) -- line: 522
                return 1 - (1 - p33) ^ 2
            end

            local function linear(p34) -- line: 523
                return p34
            end

            local FieldOfView = CurrentCamera.FieldOfView

            p27:Add(function() -- line: 526
                -- upvalues: FieldOfView (copy), CurrentCamera (copy)
                CurrentCamera.FieldOfView = FieldOfView
            end)

            local t14 = {}

            for _, v73 in t12 do
                t14[v73] = v73.Color
            end

            task.spawn(function() -- line: 532
                -- upvalues: p27 (copy), t12 (copy), t13 (copy), Highlight (copy), v65 (ref), v66 (ref), sweep (copy), accelerating (copy), linear (copy), FieldOfView (copy), t14 (copy), t2 (copy), v5 (copy), CurrentCamera (copy), tweenTreeToBloomed (copy), RunService (copy), TweenService (copy)
                local v74 = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

                tweenTreeToBloomed(3.669999999999998)
                sweep(3.069999999999998, accelerating, function(p35) -- line: 536
                    -- upvalues: v74 (copy), t13 (copy), TweenService (copy)
                    p35.Transparency = 0
                    TweenService:Create(p35, v74, {
                        Size = t13[p35]
                    }):Play()
                end)
                task.wait(0.6)

                if v65 and not v66 then
                    local v76 = TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

                    TweenService:Create(Highlight, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                        OutlineTransparency = 0
                    }):Play()
                    TweenService:Create(CurrentCamera, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                        FieldOfView = FieldOfView - 12
                    }):Play()
                    task.spawn(sweep, 1.25, linear, function(p36) -- line: 562
                        -- upvalues: v76 (copy), t13 (copy), TweenService (copy)
                        TweenService:Create(p36, v76, {
                            Size = t13[p36] * 0.8
                        }):Play()
                    end)

                    local elapsed = os.clock()
                    local n1 = 0
                    local connection

                    connection = RunService.Heartbeat:Connect(function(p37) -- line: 569
                        -- upvalues: elapsed (copy), n1 (ref), connection (ref), t12 (copy), Highlight (copy), v65 (ref), v66 (ref), t14 (copy), t2 (copy), v5 (copy)
                        if not v65 or v66 then
                            connection:Disconnect()
                        else
                            local v79 = math.clamp((os.clock() - elapsed) / 2.5, 0, 1)
                            local v80 = t2[1] + (t2[2] - t2[1]) * v79 ^ 2

                            n1 += p37 * v80 * 3.141592653589793 * 2

                            local v83 = (math.sin(n1) + 1) * 0.5 * (v79 * 0.65 + 0.35)

                            Highlight.FillTransparency = 1 - v83 * 0.85

                            for _, v84 in t12 do
                                v84.Color = t14[v84]:Lerp(v5, v83)
                            end
                        end
                    end)
                    p27:Add(connection)
                end
            end)

            local function flashScreen() -- line: 587
                -- upvalues: p27 (copy), v5 (copy), LocalPlayer (copy), TweenService (copy)
                local ScreenGui = Instance.new("ScreenGui")

                ScreenGui.Name = "SakuraExplosionFlash"
                ScreenGui.IgnoreGuiInset = true
                ScreenGui.DisplayOrder = 1000
                ScreenGui.ResetOnSpawn = false

                local Frame = Instance.new("Frame")

                Frame.Size = UDim2.fromScale(1, 1)
                Frame.BackgroundColor3 = v5
                Frame.BorderSizePixel = 0
                Frame.Parent = ScreenGui
                ScreenGui.Parent = LocalPlayer.PlayerGui
                p27:Add(ScreenGui)
                TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()
                task.delay(0.6, function() -- line: 605
                    -- upvalues: ScreenGui (copy)
                    ScreenGui:Destroy()
                end)
            end

            return {
                Model = clone,
                Explode = function() -- explode | line: 608
                    -- upvalues: clone (copy), t13 (copy), Highlight (copy), v65 (ref), v66 (ref), sweep (copy), linear (copy), FieldOfView (copy), flashScreen (copy), v5 (copy), CurrentCamera (copy), TweenService (copy)
                    if v66 or not v65 then
                        return
                    end

                    v66 = true
                    flashScreen()

                    local v85 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                    TweenService:Create(Highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        FillTransparency = 1,
                        OutlineTransparency = 1,
                        FillColor = v5,
                        OutlineColor = v5
                    }):Play()

                    local tween = TweenService:Create(CurrentCamera, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        FieldOfView = FieldOfView + 14
                    })

                    tween.Completed:Once(function() -- line: 632
                        -- upvalues: FieldOfView (copy), CurrentCamera (copy), TweenService (copy)
                        TweenService:Create(CurrentCamera, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                            FieldOfView = FieldOfView
                        }):Play()
                    end)
                    tween:Play()
                    task.spawn(sweep, 0.25, linear, function(p38) -- line: 651
                        -- upvalues: v85 (copy), t13 (copy), TweenService (copy)
                        TweenService:Create(p38, v85, {
                            Transparency = 1,
                            Size = t13[p38] * 1.8
                        }):Play()
                    end)
                    task.delay(0.55, function() -- line: 657
                        -- upvalues: clone (copy)
                        clone:Destroy()
                    end)
                end
            }
        end

        local function setEmitters(p39, p40) -- line: 662
            local n2 = 0

            for _, descendant in ipairs(p39:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = p40
                    n2 = math.max(n2, descendant.Lifetime.Max)
                end
            end

            return n2
        end

        local function playLeafRing(p41) -- line: 673
            -- upvalues: IncubatorAnchor (copy), LeafRing (copy), setEmitters (copy), Workspace (copy)
            local RootOffset = LeafRing:GetAttribute("RootOffset")

            assert(typeof(RootOffset) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(LeafRing.Name)))

            local v88 = IncubatorAnchor.CFrame * RootOffset
            local clone = LeafRing:Clone()

            clone:PivotTo(v88)
            clone.Parent = Workspace
            p41:Add(clone)
            setEmitters(clone, true)

            return function() -- line: 677
                -- upvalues: clone (copy), setEmitters (copy)
                local v89 = setEmitters(clone, false)

                task.delay(v89, function() -- line: 679
                    -- upvalues: clone (copy)
                    clone:Destroy()
                end)
            end
        end

        local function setTrails(p42, p43) -- line: 683
            for _, descendant in ipairs(p42:GetDescendants()) do
                if descendant:IsA("Trail") then
                    descendant.Enabled = p43
                end
            end
        end

        local function playCutsceneSound(p44) -- line: 691
            -- upvalues: Cutscene2 (copy), SoundService (copy)
            local clone = Cutscene2:Clone()

            clone.Parent = SoundService
            p44:Add(clone)
            clone:Play()
        end

        local function runUnlockCutscene(p45) -- line: 698
            -- upvalues: CurrentCamera (copy), IncubatorAnchor (copy), CameraRig (copy), CraneRig (copy), Cutscene2 (copy), CameraAnimation (copy), CraneAnimation (copy), PlayerAnimation (copy), buildTree (copy), getAnimator (copy), cloneCharacterRig (copy), hideCharacter (copy), playBloom (copy), playLeafCover (copy), playLeafRing (copy), setTrails (copy), ContentProvider (copy), RunService (copy), SoundService (copy), Workspace (copy)
            buildTree(false)

            local RootOffset = CameraRig:GetAttribute("RootOffset")

            assert(typeof(RootOffset) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(CameraRig.Name)))

            local v92 = IncubatorAnchor.CFrame * RootOffset
            local clone = CameraRig:Clone()

            clone:PivotTo(v92)
            clone.Parent = Workspace

            local RootOffset2 = CraneRig:GetAttribute("RootOffset")

            assert(typeof(RootOffset2) == "CFrame", (("%* needs a RootOffset CFrame attribute"):format(CraneRig.Name)))

            local v95 = IncubatorAnchor.CFrame * RootOffset2
            local clone2 = CraneRig:Clone()

            clone2:PivotTo(v95)
            clone2.Parent = Workspace
            p45:Add(clone)
            p45:Add(clone2)

            local Torso = clone:FindFirstChild("Torso")

            assert(Torso and Torso:IsA("BasePart"), "CameraRig needs a Torso part")

            local v97 = cloneCharacterRig()

            p45:Add(v97)
            hideCharacter(p45)
            ContentProvider:PreloadAsync({
                CameraAnimation,
                CraneAnimation,
                PlayerAnimation
            })

            local track = getAnimator(clone):LoadAnimation(CameraAnimation)

            track.Priority = Enum.AnimationPriority.Action4
            track.Looped = false
            track:Play(0)

            local track2 = getAnimator(clone2):LoadAnimation(CraneAnimation)

            track2.Priority = Enum.AnimationPriority.Action4
            track2.Looped = false
            track2:Play(0)

            local track3 = getAnimator(v97):LoadAnimation(PlayerAnimation)

            track3.Priority = Enum.AnimationPriority.Action4
            track3.Looped = false
            track3:Play(0)

            local t15 = { track, track2, track3 }

            p45:Add(function() -- line: 720
                -- upvalues: t15 (copy)
                for _, v98 in t15 do
                    v98:Stop(0)
                    v98:Destroy()
                end
            end)

            local v99

            local function startOnce() -- line: 728
                -- upvalues: p45 (copy), v99 (ref), playLeafCover (copy)
                v99 = v99 or playLeafCover(p45)
            end

            local v100

            local function spellOnce() -- line: 735
                -- upvalues: p45 (copy), v100 (ref), playLeafRing (copy)
                v100 = v100 or playLeafRing(p45)
            end

            local v101 = false

            local function bloomOnce() -- line: 742
                -- upvalues: p45 (copy), v99 (ref), v100 (ref), v101 (ref), playBloom (copy)
                if v101 then
                    return
                end

                v101 = true

                local v102 = v99

                if v102 then
                    v102.Explode()
                end

                local v103 = v100

                if v103 then
                    v103()
                end

                task.spawn(playBloom, p45)
            end

            p45:Add(track:GetMarkerReachedSignal("Start"):Connect(startOnce))
            p45:Add(track:GetMarkerReachedSignal("Explosion"):Connect(bloomOnce))
            p45:Add(track2:GetMarkerReachedSignal("Spell"):Connect(spellOnce))
            setTrails(clone2, true)

            local clone3 = Cutscene2:Clone()

            clone3.Parent = SoundService
            p45:Add(clone3)
            clone3:Play()
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            p45:Add(function() -- line: 764
                -- upvalues: CurrentCamera (copy), RunService (copy)
                RunService:UnbindFromRenderStep("SakuraUnlockCamera")
                CurrentCamera.CameraType = Enum.CameraType.Custom
            end)
            RunService:BindToRenderStep("SakuraUnlockCamera", Enum.RenderPriority.Camera.Value + 1, function() -- line: 771
                -- upvalues: Torso (copy), CurrentCamera (copy)
                CurrentCamera.CFrame = Torso.CFrame
            end)
            task.wait(25)

            if v101 then
                return
            end

            v101 = true

            local v105 = v99

            if v105 then
                v105.Explode()
            end

            local v106 = v100

            if v106 then
                v106()
            end

            task.spawn(playBloom, p45)
        end

        local function playUnlockCutscene() -- line: 778
            -- upvalues: clone (ref), v8 (ref), refresh (ref), runUnlockCutscene (copy), HiddenUIHandler (copy), Tabs (copy), Trove (copy)
            if v8 then
                return
            end

            v8 = true

            local clone2 = clone

            if clone2 then
                clone2.Enabled = not v8
            end

            Tabs.Deactivate({
                instant = true
            })

            local v107 = HiddenUIHandler.Acquire()
            local v108 = Trove.new()
            local ok, result = pcall(runUnlockCutscene, v108)

            v108:Clean()
            v107()
            v8 = false
            refresh()

            if not ok then
                error(result)
            end
        end

        local function runMutateReveal(p46, p47) -- line: 798
            -- upvalues: v1 (copy), LocalPlayer (copy), CurrentCamera (copy), IncubatorAnchor (copy), IncubatorBloomed (copy), RunService (copy), TweenService (copy), Workspace (copy), Directory (copy), EggRecords (copy), EggRenderer (copy), Mutations (copy), SakuraFX (copy)
            local v109 = EggRecords.Decode(p47.Egg)
            local v110 = Directory[v109.AssetCategory]

            assert(v110 ~= nil, (("Missing asset config %*"):format(v109.AssetCategory)))

            local v113 = Mutations.Get(p47.Mutation)
            local v114 = if v113 then v113.Tint else v1
            local _CFrame = IncubatorAnchor.CFrame
            local v115 = _CFrame * CFrame.new(0, 0, -IncubatorBloomed:GetAttribute("Radius") - 4)
            local v116 = EggRenderer.RenderVisual({
                ModelName = "SakuraRevealEgg",
                OwnerUserId = LocalPlayer.UserId,
                UID = p47.Uid,
                Record = v109
            }, Workspace)
            local Model = v116.Model

            p46:Add(Model)

            for _, descendant in ipairs(Model:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                end
            end

            local Y = v116.Config and EggRenderer.GetVisibleBounds(v109).Y or 4
            local v118 = CFrame.new(v115.Position + Vector3.new(0, Y / 2 + 1.5, 0))

            Model:PivotTo(v118)

            local Scale = Model:GetScale()

            Model:ScaleTo((math.max(0.05, Scale * 0.05)))

            local PointLight = Instance.new("PointLight")

            PointLight.Color = v114
            PointLight.Brightness = 0
            PointLight.Range = 30
            PointLight.Parent = Model.PrimaryPart or Model:FindFirstChildWhichIsA("BasePart")
            p46:Add(PointLight)

            local v121 = math.max(Y * 2.2, 9)
            local LookVector = _CFrame.LookVector
            local v124 = CFrame.lookAt(v118.Position + LookVector * v121 * 1.6 + Vector3.new(0, Y * 0.9, 0), v118.Position)
            local v127 = CFrame.lookAt(v118.Position + (LookVector * 0.85 + _CFrame.RightVector * 0.5).Unit * v121 + Vector3.new(0, Y * 0.4, 0), v118.Position)

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            p46:Add(function() -- line: 852
                -- upvalues: CurrentCamera (copy), RunService (copy)
                RunService:UnbindFromRenderStep("SakuraMutateReveal")
                CurrentCamera.CameraType = Enum.CameraType.Custom
            end)

            local n3 = 0

            RunService:BindToRenderStep("SakuraMutateReveal", Enum.RenderPriority.Camera.Value + 1, function(p48) -- line: 860
                -- upvalues: Model (copy), v118 (copy), Scale (copy), v124 (copy), v127 (copy), n3 (ref), CurrentCamera (copy), TweenService (copy)
                n3 += p48
                CurrentCamera.CFrame = v124:Lerp(v127, (TweenService:GetValue(math.clamp(n3 / 3.2, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.Out)))
                Model:ScaleTo((math.max(0.05, Scale * TweenService:GetValue(math.clamp(n3 / 0.9, 0, 1), Enum.EasingStyle.Back, Enum.EasingDirection.Out))))
                Model:PivotTo(v118 * CFrame.Angles(0, n3 * 1.2, 0))
            end)
            SakuraFX.EmitBurst("Bloom", v118.Position, 80, Y * 2)
            SakuraFX.PlayCue("Bloom", LocalPlayer, 0.8, 1.15)
            TweenService:Create(PointLight, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Brightness = 5
            }):Play()
            task.wait(0.9)
            SakuraFX.PlayCue("Mutate", LocalPlayer, 1)
            SakuraFX.EmitBurst("Pickup", v118.Position, 40, Y * 1.5)
            task.wait(2.3000000000000003)

            return v110.Egg.DisplayName, v114, v110.Egg.Icon
        end

        local function playMutateReveal(p49) -- line: 893
            -- upvalues: clone (ref), v8 (ref), refresh (ref), runMutateReveal (copy), HiddenUIHandler (copy), Message (copy), Mutations (copy), Tabs (copy), Trove (copy)
            if v8 then
                return
            end

            v8 = true

            local clone2 = clone

            if clone2 then
                clone2.Enabled = not v8
            end

            Tabs.Deactivate({
                instant = true
            })

            local v132 = HiddenUIHandler.Acquire()
            local v133 = Trove.new()
            local v134, v135, v136, v137 = pcall(runMutateReveal, v133, p49)

            v133:Clean()
            v132()
            v8 = false
            refresh()

            if not v134 then
                error(v135)
            end

            Message.Notice(("Your %* is now <font color=\"#%*\">%*</font>!"):format(v135, v136:ToHex(), (Mutations.LabelOf(p49.Mutation))), {
                LeaveClosed = true,
                Image = v137
            })
        end

        function refresh() -- line: 920
            -- upvalues: Build (copy), v6 (copy), clone2 (ref), v7 (ref), v8 (ref), renderBillboard (copy), buildTree (copy), Save (copy)
            if v8 then
                return
            end

            local v138, v139

            if Build:GetAttribute("DragonEventMap") == true then
                v139 = true
            elseif Build:GetAttribute("CherryBlossomZoneRevealed") == true then
                local v140 = Save.Await()

                v138 = v140 ~= nil and v140.Sakura.Unlocked
                v139 = false
            else
                v139 = true
            end

            if not v139 then
                if v7 ~= v138 then
                    buildTree(v138)
                end

                renderBillboard()
            else
                v6:Clean()
                clone2 = nil
                v7 = nil
            end
        end

        Remotes.Bloomery.CutsceneOpened.OnClientEvent:Connect(function() -- line: 944
            -- upvalues: playUnlockCutscene (copy)
            task.spawn(playUnlockCutscene)
        end)
        SakuraSignals.Reveal:Connect(function(p50) -- line: 945
            -- upvalues: playMutateReveal (copy), Sakura2 (copy)
            assert(Sakura2.MutateResult(p50), "Sakura mutate reveal needs a valid result")
            task.spawn(playMutateReveal, p50)
        end)
        Save.WatchFields("Sakura", refresh)
        Build:GetAttributeChangedSignal("DragonEventMap"):Connect(refresh)
        Build:GetAttributeChangedSignal("CherryBlossomZoneRevealed"):Connect(refresh)
        Save.Loaded:Connect(function(p51) -- line: 953
            -- upvalues: LocalPlayer (copy), refresh (ref)
            if p51 == LocalPlayer then
                refresh()
            end
        end)

        if Save.IsLoaded() then
            refresh()
        end

        task.spawn(function() -- line: 962
            -- upvalues: clone (ref), renderBillboard (copy), Save (copy)
            while true do
                task.wait(1)

                if not clone then
                    continue
                end

                local v142 = Save.Await()

                if v142 ~= nil and v142.Sakura.Unlocked then
                    renderBillboard()
                end
            end
        end)
        task.spawn(function() -- line: 972
            -- upvalues: CameraAnimation (copy), CraneAnimation (copy), PlayerAnimation (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync({
                CameraAnimation,
                CraneAnimation,
                PlayerAnimation
            })
        end)
    end
}
