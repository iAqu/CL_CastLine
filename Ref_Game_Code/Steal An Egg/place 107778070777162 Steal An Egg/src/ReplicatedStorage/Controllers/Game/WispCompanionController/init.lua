-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local GUI = require(ReplicatedStorage.Client.GUI)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)
local Save = require(ReplicatedStorage.Shared.Save)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local WispQuests = require(ReplicatedStorage.Data.WispQuests)
local WispProgression = require(ReplicatedStorage.Shared.Modules.WispProgression)
local WispCompanion = require(ReplicatedStorage.Shared.Types.WispCompanion)
local v1 = require(script.IntroDialogue).new()
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local v2, Frame
local t2 = {}
local n1 = 1
local Stage = nil
local QuestHolder
local ContentHolder = nil
local v3 = WispCompanion.Blank()
local v4 = false
local EnchantedTree, WispAnchor, WispTreePrompt, v5
local t3 = {}
local v6 = false
local v7 = false
local clone
local t4 = {}

t4[1] = nil

local clone2, ProximityPrompt, v8, v9
local v10 = false
local t5 = {}
local t6 = {}
local t7 = {}
local t8 = {}
local t9 = {}
local t10 = {}
local v11 = false

Color3.fromRGB(128, 236, 170)

local v12 = Color3.fromRGB(244, 210, 94)
local v13, v14

local function updateCompanionPrompt(p1) -- line: 57
    -- upvalues: WispQuests (copy), LocalPlayer (copy), v3 (ref)
    local v15 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local Parent = p1.Parent

    if not v15 or not Parent then
        p1.Enabled = false

        return
    end

    local v16 = Parent.WorldPosition - v15.Position

    p1.MaxActivationDistance = math.sqrt(WispQuests.PromptRadius ^ 2 + v16.Y ^ 2) + 0.1

    local Accepted = v3.Accepted

    if Accepted then
        Accepted = not v3.Unlocked
        Accepted = Accepted and Vector3.new(v16.X, 0, v16.Z).Magnitude <= WispQuests.PromptRadius
    end

    p1.Enabled = Accepted
end

local function focus() -- line: 70
    -- upvalues: GuiService (copy), UserInputService (copy), Frame (ref), t2 (copy)
    if UserInputService.GamepadEnabled then
        GuiService.GuiNavigationEnabled = true

        local v18 = if Frame.ReturnButton_Ready.Selectable then Frame.ReturnButton_Ready else Frame.Close

        for _, v19 in t2 do
            if v19.Claim.Selectable then
                v18 = v19.Claim
                break
            end
        end

        GuiService.SelectedObject = v18
    end
end

local function open() -- line: 84
    -- upvalues: Tabs (copy), v13 (ref), focus (copy)
    v13()
    Tabs.Activate("WispCompanion")
    focus()
end

local function clearArrow() -- line: 90
    -- upvalues: TutorialBeam (copy), v5 (ref)
    if v5 then
        TutorialBeam.Destroy(v5)
        v5 = nil
    end
end

local function guide() -- line: 97
    -- upvalues: TutorialBeam (copy), LocalPlayer (copy), v3 (ref), WispAnchor (ref), v5 (ref)
    local v20 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if v3.Returning and not v3.Unlocked and WispAnchor and v20 then
        if v5 then
            TutorialBeam.Retarget(v5, WispAnchor)
        else
            v5 = TutorialBeam.Attach(WispAnchor, {
                BeamName = "WispReturnBeam"
            })
        end
    elseif v5 then
        TutorialBeam.Destroy(v5)
        v5 = nil
    end
end

local function openDoors(p2) -- line: 110
    -- upvalues: TweenService (copy), EnchantedTree (ref), t3 (copy), v6 (ref)
    if not EnchantedTree or v6 then
        return
    end

    v6 = true

    for _, child in EnchantedTree.Doors:GetChildren() do
        if child:IsA("Model") then
            local v21 = t3[child] or child:GetPivot()

            t3[child] = v21

            local v23 = v21 + Vector3.new(if child.Name == "DoorLeft" then 7 else -7, 0, 0)

            for _, descendant in child:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = false
                end
            end

            if p2 then
                child:PivotTo(v23)
            else
                local CFrameValue = Instance.new("CFrameValue")

                CFrameValue.Value = v21

                local connection = CFrameValue.Changed:Connect(function(p3) -- line: 131
                    -- upvalues: child (copy)
                    if child.Parent then
                        child:PivotTo(p3)
                    end
                end)
                local tween = TweenService:Create(CFrameValue, TweenInfo.new(1.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Value = v23
                })

                tween.Completed:Once(function() -- line: 137
                    -- upvalues: CFrameValue (copy), connection (copy)
                    connection:Disconnect()
                    CFrameValue:Destroy()
                end)
                tween:Play()
            end
        end
    end
end

local function canTalkToWisp() -- line: 147
    -- upvalues: Save (copy)
    local v24 = Save.Peek()
    local v25 = v24 and v24.WispCompanion

    return v25 ~= nil and not v25.Accepted and not v25.Unlocked and workspace.World.Build:GetAttribute("EnchantedForestZoneRevealed") == true
end

local function canMeetWisp() -- line: 154
    -- upvalues: Save (copy), WispQuests (copy)
    local v26 = Save.Peek()
    local v27 = Save.Peek()
    local v28 = v27 and v27.WispCompanion

    return v28 ~= nil and not v28.Accepted and not v28.Unlocked and workspace.World.Build:GetAttribute("EnchantedForestZoneRevealed") == true and typeof(v26.SpeedPower) == "number" and v26.SpeedPower >= WispQuests.RequiredSpeedPower
end

local function nearSpawn() -- line: 160
    -- upvalues: WispQuests (copy), LocalPlayer (copy), t4 (copy)
    local Character = LocalPlayer.Character
    local v30 = Character

    if Character then
        v30 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    local v31

    if t4[1] ~= nil then
        v31 = t4[1]:IsDescendantOf(workspace)

        if v31 then
            v31 = v30 ~= nil and Character ~= nil and Character.Health > 0 and (v30.Position - t4[1].Position).Magnitude <= WispQuests.SpawnPromptRadius
        end
    else
        v31 = false
    end

    return v31
end

local function createSpawnBillboard(p4) -- line: 169
    local BoundingBox, BoundingBox2 = p4:GetBoundingBox()
    local PrimaryPart = p4.PrimaryPart
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "WispNameBillboard"
    BillboardGui.Adornee = PrimaryPart
    BillboardGui.Size = UDim2.fromOffset(160, 36)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, BoundingBox.Position.Y - PrimaryPart.Position.Y + BoundingBox2.Y * 0.5 + 1, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.MaxDistance = 150
    BillboardGui.LightInfluence = 0

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Title"
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.GothamBlack
    TextLabel.Text = "Wisp"
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    TextLabel.TextStrokeTransparency = 0
    TextLabel.Parent = BillboardGui
    BillboardGui.Parent = PrimaryPart

    return BillboardGui
end

local self = setmetatable({}, {
    __mode = "k"
})

local function syncWispVisual(p5, p6) -- line: 197
    -- upvalues: self (copy)
    for _, v34 in {
            p5,
            table.unpack(p5:GetDescendants())
        } do
        local v35, v36

        if v34:IsA("BasePart") then
            v35 = "LocalTransparencyModifier"
            v36 = 1
        elseif v34:IsA("Decal") or v34:IsA("Texture") then
            v35 = "Transparency"
            v36 = 1
        elseif v34:IsA("ParticleEmitter") or v34:IsA("Beam") or v34:IsA("Trail") or v34:IsA("Light") then
            v35 = "Enabled"
            v36 = false
        end

        if v35 then
            local v37 = self[v34]

            if not v37 then
                v37 = {
                    Property = v35
                }

                if v34:IsA("BasePart") then
                    v37.Value = 0
                else
                    v37.Value = v34[v35]
                end

                self[v34] = v37
            end

            if p6 then
                v36 = v37.Value
            end

            v34[v35] = v36
        end
    end
end

local function syncSpawn() -- line: 222
    -- upvalues: ReplicatedStorage (copy), Save (copy), WispQuests (copy), v1 (copy), t4 (copy), clone2 (ref), ProximityPrompt (ref), v8 (ref), v9 (ref), v10 (ref), createSpawnBillboard (copy), syncWispVisual (copy)
    local EnchantedForestZone = workspace.World.Build:FindFirstChild("EnchantedForestZone")
    local WispVisual = EnchantedForestZone and EnchantedForestZone:FindFirstChild("WispVisual")
    local v38 = Save.Peek()
    local v39 = v38 and v38.WispCompanion
    local WispVisual2

    if WispVisual and v39 and (v39.Accepted or v39.Unlocked) then
        WispVisual:Destroy()
    else
        WispVisual2 = WispVisual
    end

    local WispSpawn = EnchantedForestZone and EnchantedForestZone:FindFirstChild("WispSpawn")
    local v40 = Save.Peek()
    local v41 = v40 and v40.WispCompanion
    local WispSpawn2 = if v41 ~= nil and not v41.Accepted and not v41.Unlocked and workspace.World.Build:GetAttribute("EnchantedForestZoneRevealed") == true and WispVisual2 and WispSpawn and WispSpawn:IsA("BasePart") then WispSpawn else nil

    if t4[1] ~= WispSpawn2 or clone2 and not clone2.Parent then
        if v10 then
            v1.Close()
            v10 = false
        end

        if clone2 then
            clone2:Destroy()
        end

        if ProximityPrompt then
            ProximityPrompt:Destroy()
        end

        clone2 = nil
        ProximityPrompt = nil
        v8 = nil
        t4[1] = WispSpawn2
    end

    if not t4[1] or clone2 then
        if WispVisual2 then
            syncWispVisual(WispVisual2, t4[1] ~= nil and clone2 ~= nil)
        end
    else
        local clone = ReplicatedStorage.Assets.UI.WispStages["1"]:Clone()

        clone.Name = "BabyWisp"

        local _, BoundingBox = clone:GetBoundingBox()

        clone:ScaleTo(clone:GetScale() * WispQuests.CompanionHeights[1] / BoundingBox.Y)

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
            end
        end

        local BoundingBox2, BoundingBox3 = clone:GetBoundingBox()
        local v44 = clone:GetPivot():PointToObjectSpace(BoundingBox2.Position)

        v9 = Vector3.new(-v44.X, WispQuests.SpawnHoverHeight + BoundingBox3.Y * 0.5 - v44.Y, -v44.Z)

        local _CFrame = t4[1].CFrame
        local new = CFrame.new
        local v48 = v9

        clone:PivotTo(_CFrame * new(v48 + Vector3.new(0, t4[1].Size.Y * 0.5, 0)))
        clone.Parent = workspace.Transient
        clone2 = clone
        v8 = createSpawnBillboard(clone)

        local ProximityPrompt2 = Instance.new("ProximityPrompt")

        ProximityPrompt2.Name = "WispTalkPrompt"
        ProximityPrompt2.ActionText = "Talk"
        ProximityPrompt2.ObjectText = "Baby Wisp"
        ProximityPrompt2.KeyboardKeyCode = Enum.KeyCode.E
        ProximityPrompt2.GamepadKeyCode = Enum.KeyCode.ButtonX
        ProximityPrompt2.MaxActivationDistance = WispQuests.SpawnPromptRadius
        ProximityPrompt2.Style = Enum.ProximityPromptStyle.Custom
        ProximityPrompt2.HoldDuration = 0
        ProximityPrompt2.RequiresLineOfSight = false
        ProximityPrompt2.ClickablePrompt = true
        ProximityPrompt2.Enabled = false
        ProximityPrompt2.Style = Enum.ProximityPromptStyle.Custom
        ProximityPrompt2.Parent = t4[1]
        ProximityPrompt = ProximityPrompt2
        syncWispVisual(WispVisual2, true)
    end
end

local function updateWorld() -- line: 288
    -- upvalues: ReplicatedStorage (copy), WispQuests (copy), v3 (ref), EnchantedTree (ref), WispAnchor (ref), WispTreePrompt (ref), v7 (ref), clone (ref), guide (copy), openDoors (copy)
    if not EnchantedTree then
        return
    end

    if WispTreePrompt then
        local WispTreePrompt2 = WispTreePrompt

        WispTreePrompt2.Enabled = v3.Accepted and v3.Returning and not v3.Unlocked
        WispTreePrompt.ActionText = "Return Wisp"
        WispTreePrompt.ObjectText = "Enchanted Tree"
    end

    if not v3.Unlocked or v7 then
        if clone then
            clone:Destroy()
            clone = nil
        end
    else
        openDoors(true)

        if not clone and WispAnchor then
            clone = ReplicatedStorage.Assets.UI.WispStages["4"]:Clone()
            clone.Name = "ReturnedWisp"

            local _, BoundingBox = clone:GetBoundingBox()
            local clone2 = clone

            clone2:ScaleTo(clone:GetScale() * WispQuests.CompanionHeights[4] / BoundingBox.Y)

            local clone3 = clone

            clone3:PivotTo(WispAnchor.CFrame * CFrame.new(0, 4, 16))

            local clone4 = clone

            clone4.Parent = workspace.Transient
        end
    end

    guide()
end

local function rebuildRows() -- line: 314
    -- upvalues: GUI (copy), WispQuests (copy), t2 (copy), QuestHolder (ref), v3 (ref), v4 (ref), v14 (ref)
    for _, v50 in t2 do
        v50:Destroy()
    end

    table.clear(t2)

    for v51, v52 in WispQuests.List do
        local clone = QuestHolder.Template:Clone()

        clone.Name = v52.Id
        clone.Visible = true
        clone.LayoutOrder = v51
        clone.QuestName.Text = v52.Title
        clone.Icon.Image = v52.Icon
        clone.Parent = QuestHolder

        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Claim"
        TextButton.Size = UDim2.fromScale(1, 1)
        TextButton.BackgroundTransparency = 1
        TextButton.Text = ""
        TextButton.ZIndex = 20
        TextButton.Parent = clone
        t2[v52.Id] = clone
        GUI.OnActivated(TextButton, function() -- line: 335
            -- upvalues: v52 (copy), v51 (copy), v3 (ref), v4 (ref), v14 (ref)
            if not v4 and v51 == v3.Stage and v3.Accepted and not v3.Claimed[v52.Id] and (v3.Progress[v52.Id] or 0) >= v52.Target then
                v14("Claim", v52.Id)
            end
        end)
    end
end

v13 = function() -- line: 343
    -- upvalues: WispQuests (copy), WispProgression (copy), Frame (ref), t2 (copy), n1 (ref), Stage (ref), QuestHolder (ref), ContentHolder (ref), v3 (ref), v4 (ref), t10 (copy), v12 (copy), updateCompanionPrompt (copy), rebuildRows (copy)
    if not Frame then
        return
    end

    if Stage ~= v3.Stage then
        Stage = v3.Stage
        n1 = math.min(v3.Stage, WispQuests.StageCount)
        Frame:SetAttribute("ViewedStage", nil)
    end

    for i = 1, WispQuests.StageCount do
        local v53 = ContentHolder["Stage" .. i]
        local v54 = v3.Accepted and i <= v3.Stage
        local Accepted = v3.Accepted and i == v3.Stage and not v3.Unlocked

        v53.CompletedHolder.Visible = v54
        v53.RequirementHolder.Visible = false
        v53.LockedHolder.Visible = not v54
        v53.LockedOverlay.Visible = not v54
        v53.Glow.Visible = Accepted

        local UIStroke = v53.UIStroke

        if Accepted then
            UIStroke.Color = v12
        else
            UIStroke.Color = Color3.fromRGB(25, 25, 25)
        end
    end

    if next(t2) == nil then
        rebuildRows()
    end

    for v55, v56 in WispQuests.List do
        local v57 = t2[v56.Id]
        local v58 = v3.Claimed[v56.Id] == true or v3.Unlocked
        local v59 = not v3.Accepted or v3.Stage < v55
        local v60 = if v58 then v56.Target else v3.Progress[v56.Id] or 0
        local Accepted = v3.Accepted and not v58 and v55 == v3.Stage and v56.Target <= v60

        v57.Count.Text = ("%* / %*"):format(math.min(v60, v56.Target), v56.Target)
        v57.Progress.Fill.Size = UDim2.fromScale(math.clamp(v60 / v56.Target, 0, 1), 1)
        v57.Reward.Amount.Text = ("+%*"):format(v56.Reward)

        if Accepted then
            v57.Count.Text = "CLAIM"
        end

        v57.CompletedOverlay.Visible = v58
        v57.LockedOverlay.Visible = v59 and not v58

        local Requirement = v57.LockedOverlay.Requirement

        if v3.Accepted then
            Requirement.Text = ("Finish Quest %* & unlock Stage %*"):format(v55 - 1, v55)
        else
            Requirement.Text = "Talk to the Baby Wisp"
        end

        v57.Claim.Active = Accepted and not v4
        v57.Claim.Selectable = Accepted and not v4
        v57.Claim.Visible = Accepted
    end

    for _, v62 in t10 do
        updateCompanionPrompt(v62.Prompt)
        v62.Claim.Enabled = WispProgression.HasClaimable(v3)
    end

    Frame.Dialogue.Visible = false
    QuestHolder.Visible = true

    local v63 = WispProgression.IsReady(v3)
    local v64 = not v3.Accepted or v63 or v3.Returning
    local ReturnButton_Ready = Frame.ReturnButton_Ready

    ReturnButton_Ready.Visible = v64 and not v3.Unlocked
    Frame.ReturnButton_Unready.Visible = not ReturnButton_Ready.Visible

    local Title = ReturnButton_Ready.Title

    if v4 then
        Title.Text = "Please wait..."
    elseif v3.Accepted then
        if v3.Returning then
            Title.Text = "Show me the tree"
        else
            Title.Text = "RETURN THE WISP"
        end
    else
        Title.Text = "Meet the Baby Wisp"
    end

    ReturnButton_Ready.Active = not v4 and v64 and not v3.Unlocked
    ReturnButton_Ready.Selectable = ReturnButton_Ready.Active
    Frame.ReturnButton_Unready.Title.Text = v3.Unlocked and "TREE UNLOCKED" or "RETURN THE WISP"
    Frame.ReturnButton_Unready.SubTitle.Text = v3.Unlocked and "Your Wisp is home" or "Complete all 3 quests"
    Frame.ReturnButton_Unready.Lock.Visible = not v3.Unlocked
    Frame.ReturnButton_Unready.Active = false
    Frame.ReturnButton_Unready.Selectable = false
end

v14 = function(p7, p8) -- line: 400
    -- upvalues: Remotes (copy), Frame (ref), v4 (ref), v13 (ref)
    if v4 then
        return false
    end

    v4 = true
    v13()

    local function v65() -- line: 406
        -- upvalues: p7 (copy), p8 (copy), Remotes (copy)
        return Remotes.WispCompanion.Request:InvokeServer(p7, p8)
    end

    local v66, v67, v68 = pcall(v65)

    v4 = false

    if v66 and v67 then
        Frame.Status.Text = p7 == "Claim" and "Your Wisp grew!" or "Your Wisp progress is saved."
        v13()

        return true
    end

    Frame.Status.Text = if typeof(v68) ~= "string" then "Your Wisp could not save. Please try again." else v68
    v13()

    return false
end

local function returnWisp() -- line: 420
    -- upvalues: TweenService (copy), Tabs (copy), TutorialBeam (copy), LocalPlayer (copy), v4 (ref), WispAnchor (ref), v5 (ref), v7 (ref), v14 (ref), openDoors (copy), updateWorld (copy)
    local v69, v70

    if v7 or v4 then
        v70 = true
    elseif WispAnchor then
        v69 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("WispCompanion")
        v70 = false
    else
        v70 = true
    end

    if v70 then
        return
    end

    local clone = v69 and v69:Clone()

    if clone then
        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("ProximityPrompt") or descendant:IsA("ClickDetector") or descendant.Name == "WispFollowJoint" then
                descendant:Destroy()
            elseif descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
            end
        end
    end

    v7 = true

    if v14("Return") then
        Tabs.Deactivate()

        if v5 then
            TutorialBeam.Destroy(v5)
            v5 = nil
        end

        if clone then
            clone.Name = "WispReturnVisual"
            clone.Parent = workspace.Transient

            local CFrameValue = Instance.new("CFrameValue")

            CFrameValue.Value = clone:GetPivot()

            local connection = CFrameValue.Changed:Connect(function(p9) -- line: 449
                -- upvalues: clone (copy)
                clone:PivotTo(p9)
            end)
            local tween = TweenService:Create(CFrameValue, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Value = WispAnchor.CFrame * CFrame.new(0, 4, 16)
            })

            tween:Play()
            tween.Completed:Wait()
            connection:Disconnect()
            CFrameValue:Destroy()
            clone:Destroy()
        end

        v7 = false
        openDoors(false)
        updateWorld()
    else
        v7 = false

        if clone then
            clone:Destroy()
        end
    end
end

local function startDialogue(p10, p11) -- line: 464
    -- upvalues: Tabs (copy), v1 (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v71 = Character and Character:FindFirstChild("WispCompanion")

    if not v71 and Character then
        v71 = Character:WaitForChild("WispCompanion", 5)
    end

    if LocalPlayer.Character ~= Character or not v71 then
        return false
    end

    if Tabs.IsActive("WispCompanion") then
        Tabs.Deactivate({
            instant = true
        })
    end

    return v1.Start(v71, p10, p11)
end

local function startIntro() -- line: 475
    -- upvalues: Tabs (copy), WispQuests (copy), v3 (ref), v7 (ref), v13 (ref), focus (copy), startDialogue (copy)
    return startDialogue(WispQuests.Intro, function() -- line: 476
        -- upvalues: Tabs (copy), v3 (ref), v7 (ref), v13 (ref), focus (copy)
        if v3.Accepted and not v3.Unlocked and not v7 then
            v13()
            Tabs.Activate("WispCompanion")
            focus()
        end
    end)
end

local function startFinishedDialogue() -- line: 483
    -- upvalues: Tabs (copy), WispQuests (copy), WispProgression (copy), v1 (copy), Frame (ref), v3 (ref), v4 (ref), v7 (ref), v11 (ref), v13 (ref), v14 (ref), focus (copy), guide (copy), startDialogue (copy)
    if v4 or v7 or v11 or v1.IsPlaying() or not WispProgression.IsReady(v3) then
        return
    end

    v11 = true

    local v72 = startDialogue(WispQuests.Finished, function() -- line: 486
        -- upvalues: Tabs (copy), WispProgression (copy), v3 (ref), v7 (ref), v13 (ref), v14 (ref), focus (copy), guide (copy)
        task.spawn(function() -- line: 487
            -- upvalues: Tabs (copy), WispProgression (copy), v3 (ref), v7 (ref), v13 (ref), v14 (ref), focus (copy), guide (copy)
            if not WispProgression.IsReady(v3) or v7 then
                return
            end

            if v14("BeginReturn") then
                guide()
            else
                v13()
                Tabs.Activate("WispCompanion")
                focus()
            end
        end)
    end)

    v11 = false

    if not v72 then
        Frame.Status.Text = "Your Wisp is not ready to talk. Please try again."
        v13()
        Tabs.Activate("WispCompanion")
        focus()
    end
end

local function acceptWisp() -- line: 503
    -- upvalues: Tabs (copy), Save (copy), WispQuests (copy), v1 (copy), v4 (ref), v7 (ref), clone2 (ref), v10 (ref), v11 (ref), v13 (ref), v14 (ref), focus (copy), nearSpawn (copy)
    if not v4 and not v7 and not v11 and not v1.IsPlaying() then
        local v73 = Save.Peek()
        local v74 = v73 and v73.WispCompanion

        if not (v74 ~= nil and not v74.Accepted and not v74.Unlocked and workspace.World.Build:GetAttribute("EnchantedForestZoneRevealed") == true and nearSpawn() and clone2) then
            return
        end

        if Tabs.IsActive("WispCompanion") then
            Tabs.Deactivate({
                instant = true
            })
        end

        local v75 = Save.Peek()
        local v76 = Save.Peek()
        local v77 = v76 and v76.WispCompanion
        local v78 = v77 ~= nil and not v77.Accepted and not v77.Unlocked and workspace.World.Build:GetAttribute("EnchantedForestZoneRevealed") == true and typeof(v75.SpeedPower) == "number" and v75.SpeedPower >= WispQuests.RequiredSpeedPower

        if v78 then
            v10 = v1.Start(clone2, WispQuests.Intro, function() -- line: 512
                -- upvalues: Tabs (copy), Save (copy), WispQuests (copy), v10 (ref), v11 (ref), v13 (ref), v14 (ref), focus (copy), nearSpawn (copy)
                v10 = false

                local v79 = Save.Peek()
                local v80 = Save.Peek()
                local v81 = v80 and v80.WispCompanion
                local v82 = v81 ~= nil and not v81.Accepted and not v81.Unlocked and workspace.World.Build:GetAttribute("EnchantedForestZoneRevealed") == true and typeof(v79.SpeedPower) == "number" and v79.SpeedPower >= WispQuests.RequiredSpeedPower

                if v82 and nearSpawn() then
                    task.spawn(function() -- line: 515
                        -- upvalues: Tabs (copy), v11 (ref), v13 (ref), v14 (ref), focus (copy)
                        v11 = true
                        v14("Accept")
                        v13()
                        Tabs.Activate("WispCompanion")
                        focus()
                        v11 = false
                    end)
                end
            end)
        else
            v10 = v1.Start(clone2, WispQuests.LockedIntro, function() -- line: 507
                -- upvalues: v10 (ref)
                v10 = false
            end)
        end
    end
end

local function openCompanion() -- line: 524
    -- upvalues: Tabs (copy), WispQuests (copy), v1 (copy), v3 (ref), v7 (ref), v11 (ref), v13 (ref), v14 (ref), focus (copy), startDialogue (copy)
    if v7
        or v11
        or v1.IsPlaying()
        or not v3.Accepted
        or v3.Unlocked
        or Tabs.IsActive("WispCompanion") then
        return
    end

    if v3.MenuOpened then
        v13()
        Tabs.Activate("WispCompanion")
        focus()
    else
        v11 = true

        if startDialogue(WispQuests.Intro, function() -- line: 476
            -- upvalues: Tabs (copy), v3 (ref), v7 (ref), v13 (ref), focus (copy)
            if v3.Accepted and not v3.Unlocked and not v7 then
                v13()
                Tabs.Activate("WispCompanion")
                focus()
            end
        end) then
            v14("Open")
        end

        v11 = false
    end
end

local function bindCompanion(p12) -- line: 536
    -- upvalues: WispQuests (copy), WispProgression (copy), LocalPlayer (copy), v3 (ref), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), updateCompanionPrompt (copy), openCompanion (copy)
    local v83, v84, v85

    if p12:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId or t5[p12] then
        v85 = true
    else
        v83 = p12:WaitForChild("RootPart", 5)
        v84 = v83 and v83:WaitForChild("WispFollowJoint", 5)
        v85 = false
    end

    if v85 or not v84 then
        return
    end

    t5[p12] = v84
    t9[p12] = if v84.Part0 then v84.Part0.CFrame.Rotation else v83.CFrame.Rotation
    t6[p12] = if v84.Part0 then v84.Part0.CFrame * WispQuests.FollowOffset else v83.CFrame

    local v87 = p12:GetAttribute("OwnerUserId") == LocalPlayer.UserId

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("ProximityPrompt") then
            descendant:Destroy()
        end
    end

    local v88 = p12:FindFirstChildWhichIsA("ClickDetector", true)
    local connection, Attachment, BillboardGui

    if v87 then
        if v88 then
            connection = v88.MouseClick:Connect(openCompanion)
        end

        local BoundingBox, BoundingBox2 = p12:GetBoundingBox()
        local Attachment2 = Instance.new("Attachment")

        Attachment = Attachment2
        Attachment2.Name = "WispMenuAttachment"
        Attachment2.Position = v83.CFrame:PointToObjectSpace(BoundingBox.Position - Vector3.new(0, BoundingBox2.Y * 0.5 + 1.8, 0))
        Attachment2.Parent = v83

        local ProximityPrompt = Instance.new("ProximityPrompt")

        ProximityPrompt.Name = "WispMenuPrompt"
        ProximityPrompt.ActionText = "Open"
        ProximityPrompt.ObjectText = "Your Wisp"
        ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
        ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonX
        ProximityPrompt.MaxActivationDistance = WispQuests.PromptRadius
        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
        ProximityPrompt.HoldDuration = 0
        ProximityPrompt.RequiresLineOfSight = false
        ProximityPrompt.ClickablePrompt = true
        ProximityPrompt.Enabled = false
        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
        ProximityPrompt.Parent = Attachment2
        updateCompanionPrompt(ProximityPrompt)

        local BillboardGui2 = Instance.new("BillboardGui")

        BillboardGui = BillboardGui2
        BillboardGui2.Name = "WispClaimHint"
        BillboardGui2.Adornee = v83
        BillboardGui2.Size = UDim2.fromOffset(48, 56)
        BillboardGui2.StudsOffsetWorldSpace = Vector3.new(0, BoundingBox.Position.Y - v83.Position.Y + BoundingBox2.Y * 0.5 + 0.8, 0)
        BillboardGui2.AlwaysOnTop = true
        BillboardGui2.Active = true
        BillboardGui2.Enabled = WispProgression.HasClaimable(v3)

        local TextButton = Instance.new("TextButton")

        TextButton.Name = "OpenMenu"
        TextButton.Size = UDim2.fromScale(1, 1)
        TextButton.BackgroundTransparency = 1
        TextButton.Text = "!"
        TextButton.Font = Enum.Font.GothamBlack
        TextButton.TextScaled = true
        TextButton.TextColor3 = Color3.fromRGB(255, 0, 0)
        TextButton.TextStrokeTransparency = 0
        TextButton.Selectable = false
        TextButton.Parent = BillboardGui2
        TextButton.Activated:Connect(openCompanion)
        BillboardGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")
        t10[p12] = {
            Prompt = ProximityPrompt,
            Claim = BillboardGui2
        }
    elseif v88 then
        v88.MaxActivationDistance = 0
    end

    p12.Destroying:Once(function() -- line: 599
        -- upvalues: p12 (copy), connection (ref), Attachment (ref), BillboardGui (ref), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy)
        if connection then
            connection:Disconnect()
        end

        if Attachment then
            Attachment:Destroy()
        end

        if BillboardGui then
            BillboardGui:Destroy()
        end

        t10[p12] = nil
        t5[p12] = nil
        t6[p12] = nil
        t7[p12] = nil
        t8[p12] = nil
        t9[p12] = nil
    end)
end

local function syncCompanion() -- line: 612
    -- upvalues: ReplicatedStorage (copy), WispQuests (copy), LocalPlayer (copy), v3 (ref), bindCompanion (copy)
    local Character = LocalPlayer.Character

    if not Character then
        return
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local WispCompanion = Character:FindFirstChild("WispCompanion")

    if v3.Accepted and not v3.Unlocked and HumanoidRootPart and Humanoid and not (Humanoid.Health <= 0) then
        local v91 = math.min(v3.Stage, WispQuests.StageCount)
        local v92 = if WispCompanion then WispCompanion:GetAttribute("Stage") == v91 else nil

        if not WispCompanion or not v92 then
            if WispCompanion then
                WispCompanion:Destroy()
            end

            local clone = ReplicatedStorage.Assets.UI.WispStages[tostring(v91)]:Clone()

            clone.Name = "WispCompanion"
            clone:SetAttribute("Stage", v91)
            clone:SetAttribute("OwnerUserId", LocalPlayer.UserId)

            local _, BoundingBox = clone:GetBoundingBox()

            clone:ScaleTo(clone:GetScale() * WispQuests.CompanionHeights[v91] / BoundingBox.Y)

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = false
                    descendant.CanCollide = false
                    descendant.CanTouch = false
                    descendant.CanQuery = true
                    descendant.Massless = true
                    descendant.RootPriority = -127
                end
            end

            clone:PivotTo(HumanoidRootPart.CFrame * WispQuests.FollowOffset)

            local Motor6D = Instance.new("Motor6D")

            Motor6D.Name = "WispFollowJoint"
            Motor6D.Part0 = HumanoidRootPart
            Motor6D.Part1 = clone.PrimaryPart
            Motor6D.C0 = WispQuests.FollowOffset
            Motor6D.Parent = clone.PrimaryPart

            local ClickDetector = Instance.new("ClickDetector")

            ClickDetector.MaxActivationDistance = 24
            ClickDetector.Parent = clone
            clone.Parent = Character
            bindCompanion(clone)
        end
    elseif WispCompanion then
        WispCompanion:Destroy()
    end
end

local function watchCharacter(p13) -- line: 655
    -- upvalues: Tabs (copy), TutorialBeam (copy), v1 (copy), LocalPlayer (copy), v5 (ref), syncCompanion (copy)
    v1.Close()

    if v5 then
        TutorialBeam.Destroy(v5)
        v5 = nil
    end

    if Tabs.IsActive("WispCompanion") then
        Tabs.Deactivate({
            instant = true
        })
    end

    task.spawn(function() -- line: 659
        -- upvalues: p13 (copy), LocalPlayer (copy), syncCompanion (copy)
        local v93 = p13:WaitForChild("HumanoidRootPart", 15)
        local v94 = p13:WaitForChild("Humanoid", 15)

        if LocalPlayer.Character == p13 and v93 and v94 then
            v94.Died:Once(syncCompanion)
            syncCompanion()
        end
    end)
end

function t1.Start() -- line: 668
    -- upvalues: RunService (copy), UserInputService (copy), ProximityPromptService (copy), GUI (copy), Tabs (copy), ButtonFX (copy), TutorialBeam (copy), Save (copy), WispQuests (copy), WispProgression (copy), WispCompanion (copy), v1 (copy), LocalPlayer (copy), v2 (ref), Frame (ref), QuestHolder (ref), ContentHolder (ref), v3 (ref), v4 (ref), EnchantedTree (ref), WispAnchor (ref), WispTreePrompt (ref), v5 (ref), t3 (copy), v6 (ref), v7 (ref), clone (ref), t4 (copy), clone2 (ref), ProximityPrompt (ref), v8 (ref), v9 (ref), v10 (ref), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), v11 (ref), v13 (ref), updateCompanionPrompt (copy), guide (copy), nearSpawn (copy), syncSpawn (copy), updateWorld (copy), returnWisp (copy), startFinishedDialogue (copy), acceptWisp (copy), openCompanion (copy), syncCompanion (copy), watchCharacter (copy)
    syncSpawn()
    v2 = GUI.Get("WispCompanion")
    Frame = v2.Frame
    QuestHolder = Frame.ContentFrame.QuestHolder
    ContentHolder = Frame.ContentFrame.ProgressionHolder.ContentHolder
    ButtonFX(Frame.ReturnButton_Ready, 1.025, function() -- line: 674
        -- upvalues: Tabs (copy), WispProgression (copy), v1 (copy), v3 (ref), v4 (ref), v11 (ref), guide (copy), startFinishedDialogue (copy), acceptWisp (copy)
        if not v4 and not v11 and not v1.IsPlaying() then
            if v3.Returning then
                Tabs.Deactivate()
                guide()
            elseif WispProgression.IsReady(v3) then
                startFinishedDialogue()
            elseif not v3.Accepted then
                acceptWisp()
            end
        end
    end)

    local function readState() -- line: 685
        -- upvalues: Save (copy), WispCompanion (copy), v3 (ref), v13 (ref), syncSpawn (copy), updateWorld (copy), syncCompanion (copy)
        local v95 = Save.Peek()

        v3 = if not (v95 and v95.WispCompanion) then WispCompanion.Blank() else v95.WispCompanion
        syncCompanion()
        syncSpawn()
        v13()
        updateWorld()
    end

    Save.WatchFields("WispCompanion", readState)
    Save.WatchFields("SpeedPower", syncSpawn)
    workspace.World.Build:GetAttributeChangedSignal("EnchantedForestZoneRevealed"):Connect(syncSpawn)

    local function spawnChanged(p14) -- line: 696
        -- upvalues: syncSpawn (copy)
        if p14.Name == "EnchantedForestZone" or p14.Name == "WispSpawn" or p14.Name == "WispVisual" then
            task.defer(syncSpawn)
        end
    end

    workspace.World.Build.DescendantAdded:Connect(spawnChanged)
    workspace.World.Build.DescendantRemoving:Connect(spawnChanged)
    task.spawn(function() -- line: 703
        -- upvalues: Save (copy), WispCompanion (copy), v3 (ref), v13 (ref), syncSpawn (copy), updateWorld (copy), syncCompanion (copy)
        Save.Await()

        local v96 = Save.Peek()

        v3 = if not (v96 and v96.WispCompanion) then WispCompanion.Blank() else v96.WispCompanion
        syncCompanion()
        syncSpawn()
        v13()
        updateWorld()
    end)
    ProximityPromptService.PromptTriggered:Connect(function(p15, p16) -- line: 707
        -- upvalues: LocalPlayer (copy), v3 (ref), WispTreePrompt (ref), ProximityPrompt (ref), t10 (copy), returnWisp (copy), acceptWisp (copy), openCompanion (copy)
        if p16 ~= LocalPlayer then
            return
        end

        if p15 == ProximityPrompt then
            acceptWisp()
        elseif p15 == WispTreePrompt then
            if v3.Returning then
                returnWisp()
            end
        else
            for _, v97 in t10 do
                if p15 == v97.Prompt then
                    openCompanion()

                    return
                end
            end
        end
    end)

    local function tapCompanion(p17) -- line: 724
        -- upvalues: LocalPlayer (copy), t5 (copy), openCompanion (copy)
        local v98 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("WispCompanion")
        local CurrentCamera = workspace.CurrentCamera

        if v98 and CurrentCamera and t5[v98] then
            local v99 = CurrentCamera:ScreenPointToRay(p17.X, p17.Y)
            local v100 = RaycastParams.new()

            v100.FilterType = Enum.RaycastFilterType.Include
            v100.FilterDescendantsInstances = { v98 }

            if workspace:Raycast(v99.Origin, v99.Direction * 1000, v100) then
                openCompanion()
            end
        end
    end

    UserInputService.InputEnded:Connect(function(p18, p19) -- line: 736
        -- upvalues: tapCompanion (copy)
        if not p19 and p18.UserInputType == Enum.UserInputType.MouseButton1 then
            tapCompanion(p18.Position)
        end
    end)
    UserInputService.TouchTapInWorld:Connect(function(p20, p21) -- line: 741
        -- upvalues: tapCompanion (copy)
        if not p21 then
            tapCompanion(p20)
        end
    end)
    LocalPlayer.CharacterAdded:Connect(watchCharacter)
    LocalPlayer.CharacterRemoving:Connect(function(p22) -- line: 746
        -- upvalues: TutorialBeam (copy), v1 (copy), v5 (ref)
        local WispCompanion = p22:FindFirstChild("WispCompanion")

        if WispCompanion then
            WispCompanion:Destroy()
        end

        v1.Close()

        if v5 then
            TutorialBeam.Destroy(v5)
            v5 = nil
        end
    end)

    if LocalPlayer.Character then
        watchCharacter(LocalPlayer.Character)
    end

    RunService:BindToRenderStep("WispCompanionFollow", Enum.RenderPriority.Character.Value + 1, function(p23) -- line: 753
        -- upvalues: Save (copy), WispQuests (copy), v1 (copy), v3 (ref), v4 (ref), v7 (ref), t4 (copy), clone2 (ref), ProximityPrompt (ref), v8 (ref), v9 (ref), v10 (ref), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), v11 (ref), updateCompanionPrompt (copy), nearSpawn (copy)
        local v101 = v10

        if v101 then
            local v102 = Save.Peek()
            local v103 = v102 and v102.WispCompanion

            v101 = v103 ~= nil and not v103.Accepted and not v103.Unlocked and workspace.World.Build:GetAttribute("EnchantedForestZoneRevealed") == true and nearSpawn()
        end

        v1.Tick(not v7 and (v101 or v3.Accepted and not v3.Unlocked))

        if v10 and not v1.IsPlaying() then
            v10 = false
        end

        local ServerTimeNow = workspace:GetServerTimeNow()

        if clone2 and t4[1] and t4[1]:IsDescendantOf(workspace) then
            local v107 = Vector3.new(0, t4[1].Size.Y * 0.5 + math.sin(ServerTimeNow * 2) * 0.3, 0)

            clone2:PivotTo(t4[1].CFrame * CFrame.new(v9 + v107))
            v8.Enabled = not v1.IsPlaying()

            local ProximityPrompt2 = ProximityPrompt
            local v109 = Save.Peek()
            local v110 = v109 and v109.WispCompanion

            ProximityPrompt2.Enabled = v110 ~= nil and not v110.Accepted and not v110.Unlocked and workspace.World.Build:GetAttribute("EnchantedForestZoneRevealed") == true and nearSpawn() and not v4 and not v7 and not v11 and not v1.IsPlaying()
        end

        for _, v111 in t10 do
            updateCompanionPrompt(v111.Prompt)

            if v111.Claim.Enabled then
                local v113 = (1 - math.cos(ServerTimeNow * 3.141592653589793)) * 0.5

                v111.Claim.OpenMenu.TextTransparency = v113
                v111.Claim.OpenMenu.TextStrokeTransparency = v113
            end
        end

        for v114, v115 in t5 do
            if v115.Parent and v115.Part0 then
                local Part0 = v115.Part0
                local v116 = t6[v114]
                local v117 = Part0.Position + Vector3.new(0, WispQuests.FollowOffset.Y, 0)
                local Magnitude = (v116.Position - v117).Magnitude
                local v118 = t8[v114]
                local v119 = if v118 then Part0.Position - v118 else Vector3.new(0, 0, 0)
                local v121 = math.max(120, Part0.AssemblyLinearVelocity.Magnitude * p23 * 2 + 20)
                local v122 = v118 and v121 < v119.Magnitude

                t8[v114] = Part0.Position

                if v122 then
                    v116 = Part0.CFrame * WispQuests.FollowOffset
                    t9[v114] = Part0.CFrame.Rotation
                    t7[v114] = false
                else
                    if WispQuests.FollowStartRadius < Magnitude then
                        t7[v114] = true
                    elseif Magnitude <= WispQuests.FollowRadius + 0.05 then
                        t7[v114] = false
                    end

                    if t7[v114] then
                        local v124 = 1 - math.exp(-WispQuests.FollowResponse * math.min(p23, 0.1))
                        local v125 = v116 + v119
                        local v126 = Vector3.new(v119.X, 0, v119.Z).Magnitude / math.max(p23, 0.001)
                        local v128 = math.clamp(WispQuests.FollowRadius + v126 * WispQuests.FollowTrailSeconds, WispQuests.FollowRadius, WispQuests.FollowMaxDistance)

                        if v119.Magnitude > math.max(0.02, p23) then
                            t9[v114] = Part0.CFrame.Rotation
                        end

                        local v129 = CFrame.new(Part0.Position) * t9[v114] * CFrame.new(WispQuests.FollowOffset.X, WispQuests.FollowOffset.Y, v128)
                        local v130 = v117 - v125.Position
                        local v131 = Vector3.new(v130.X, 0, v130.Z)
                        local v132 = if v131.Magnitude > 0.001 then CFrame.lookAt(Vector3.new(0, 0, 0), v131) else v116.Rotation

                        v116 = v125:Lerp(CFrame.new(v129.Position) * v132, v124)

                        if (v116.Position - v117).Magnitude <= WispQuests.FollowRadius + 0.05 then
                            t7[v114] = false
                        end
                    end
                end

                t6[v114] = v116

                local v133 = ServerTimeNow * 2 + (v114:GetAttribute("OwnerUserId") or 0) % 13
                local v136 = CFrame.new(0, math.sin(v133) * 0.3, 0) * CFrame.Angles(0, math.sin(v133 * 0.7) * 0.14, math.sin(v133) * 0.07)

                v115.C0 = Part0.CFrame:ToObjectSpace(v116 * v136)
            end
        end
    end)
    task.spawn(function() -- line: 820
        -- upvalues: EnchantedTree (ref), WispAnchor (ref), WispTreePrompt (ref), t3 (copy), v6 (ref), clone (ref), syncSpawn (copy), updateWorld (copy)
        while true do
            syncSpawn()

            local EnchantedForestZone = workspace.World.Build:FindFirstChild("EnchantedForestZone")
            local Zone13Props = EnchantedForestZone and EnchantedForestZone:FindFirstChild("Zone13Props")
            local EnchantedTree2 = Zone13Props and Zone13Props:FindFirstChild("EnchantedTree")

            if EnchantedTree2 and EnchantedTree2:FindFirstChild("WispAnchor") then
                if EnchantedTree ~= EnchantedTree2 then
                    if clone then
                        clone:Destroy()
                        clone = nil
                    end

                    EnchantedTree = EnchantedTree2
                    v6 = false
                    table.clear(t3)
                end

                WispAnchor = EnchantedTree2.WispAnchor
                WispTreePrompt = WispAnchor:FindFirstChild("WispTreePrompt")
                updateWorld()
            end

            task.wait(0.5)
        end
    end)
    v13()
end

return t1
