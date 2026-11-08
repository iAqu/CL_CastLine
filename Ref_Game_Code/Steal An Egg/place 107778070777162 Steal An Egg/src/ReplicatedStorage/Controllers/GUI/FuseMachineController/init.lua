-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Fusion = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).Fusion
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Shared.Types.AssetItem)

local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local Directory = require(ReplicatedStorage.Data.Assets).Directory
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)

require(ReplicatedStorage.Shared.Globals.Constants)

local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local FuseKernel = require(ReplicatedStorage.Shared.Util.FuseKernel)
local FuseMachineBackpackSelection = require(script.FuseMachineBackpackSelection)
local FuseMachineProgressPresentation = require(script.FuseMachineProgressPresentation)
local FuseMachineSelectedSlot = require(script.FuseMachineSelectedSlot)
local FuseMachineSignals = require(ReplicatedStorage.Client.FuseMachineSignals)
local FuseMachine = require(ReplicatedStorage.Shared.Types.FuseMachine)
local GUI = require(ReplicatedStorage.Client.GUI)
local Log = require(ReplicatedStorage.Packages.Log)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local v1 = Color3.fromRGB(255, 0, 0)
local v2 = Log.new()
local v3 = TryLock()
local v4 = TryLock()
local v5 = TryLock()

return {
    Start = function() -- Start | line: 52
        -- upvalues: Fusion (copy), GuiService (copy), ReplicatedStorage (copy), Workspace (copy), AssetItems (copy), Directory (copy), Audio (copy), ButtonFX (copy), Eggs (copy), FuseKernel (copy), FuseMachineBackpackSelection (copy), FuseMachineProgressPresentation (copy), FuseMachineSelectedSlot (copy), FuseMachineSignals (copy), FuseMachine (copy), GUI (copy), MenuNavigation (copy), Toast (copy), Remotes (copy), Save (copy), Simple (copy), Tabs (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
        local v6 = GUI.PetFuse()

        v6.ResetOnSpawn = false

        local FuseMain = v6.FuseMain

        assert(FuseMain:IsA("GuiObject"), "PetFuse.FuseMain must be a GuiObject")

        local FuseInputs = FuseMain.FuseInputs

        assert(FuseInputs:IsA("Frame"), "PetFuse.FuseMain.FuseInputs must be a Frame")

        local Fuse = FuseMain.Fuse

        assert(Fuse:IsA("ImageButton"), "PetFuse.FuseMain.Fuse must be an ImageButton")

        local Price = Fuse.Price

        assert(Price:IsA("TextLabel"), "PetFuse.FuseMain.Fuse.Price must be a TextLabel")

        local BackgroundColor3 = Fuse.BackgroundColor3
        local v7 = BackgroundColor3:Lerp(Color3.new(0, 0, 0), 0.35)
        local FusePetInventory = v6.FusePetInventory

        assert(FusePetInventory:IsA("GuiObject"), "PetFuse.FusePetInventory must be a GuiObject")

        local ScrollingFrame = FusePetInventory.ScrollingFrame

        assert(ScrollingFrame:IsA("ScrollingFrame"), "PetFuse.FusePetInventory.ScrollingFrame must be a ScrollingFrame")

        local Close = FusePetInventory:FindFirstChild("Close")
        local IncludeEquipped = FusePetInventory:WaitForChild("IncludeEquipped")
        local Box = IncludeEquipped:WaitForChild("Box")
        local Icon = Box:WaitForChild("Icon")
        local UIGradient = Box:WaitForChild("UIGradient")
        local EmptyState = FusePetInventory:WaitForChild("EmptyState")
        local v8 = false
        local Output = FuseMain.FuseOutput.Output

        assert(Output:IsA("Frame"), "PetFuse.FuseMain.FuseOutput.Output must be a Frame")

        local DesignBars = FuseMain.DesignBars

        assert(DesignBars:IsA("Frame"), "PetFuse.FuseMain.DesignBars must be a Frame")

        local Briefing = FuseMain:FindFirstChild("Briefing")
        local Ok = if Briefing == nil then nil else Briefing:FindFirstChild("Ok")

        local function inputSlot(p1) -- line: 118
            -- upvalues: FuseInputs (copy)
            local v9 = FuseInputs:FindFirstChild((("Input%*"):format(p1)))

            assert(v9 ~= nil and v9:IsA("Frame"), (("PetFuse.FuseMain.FuseInputs.Input%* is missing"):format(p1)))

            return v9
        end

        local Machines = Workspace:WaitForChild("World").Machines

        assert(Machines:IsA("Folder"), "Workspace.World.Machines must be a Folder")

        local FuseMachine2 = Machines.FuseMachine

        assert(FuseMachine2:IsA("Model"), "Workspace FuseMachine must be a Model")

        local Overhead = FuseMachine2.Overhead

        assert(Overhead:IsA("BasePart"), "FuseMachine.Overhead must be a BasePart")

        local BillboardGui = Overhead.BillboardGui

        assert(BillboardGui:IsA("BillboardGui"), "FuseMachine.Overhead.BillboardGui must be a BillboardGui")

        local Countdown = BillboardGui.Countdown

        assert(Countdown:IsA("TextLabel"), "FuseMachine overhead Countdown must be a TextLabel")

        local v12 = FuseMachineBackpackSelection.new(ScrollingFrame)
        local v13 = FuseMachineProgressPresentation.new(Output, DesignBars)
        local t2 = {}
        local v14 = false

        local function notifyError(p2) -- line: 165
            -- upvalues: Toast (copy), v1 (copy)
            Toast.Show({
                Seconds = 3,
                Text = p2,
                Color = v1
            })
        end

        local function getSelectedCategory(p3) -- line: 173
            local v15 = p3.FusionSlots[1]

            if v15 ~= nil then
                local v16 = p3.Inventory[v15]

                if v16 then
                    return v16.Category
                end
            end

            return nil
        end

        local function getSelectedTemporary(p4) -- line: 185
            local v17 = p4.FusionSlots[1]

            if v17 ~= nil then
                local v18 = p4.Inventory[v17]

                if v18 then
                    return v18.CreatorTemporary == true
                end
            end

            return nil
        end

        local function updateOverheadInputCount(p5) -- line: 197
            -- upvalues: Countdown (copy), Fusion (copy)
            local v19

            if p5 ~= nil then
                local v20 = p5.FusionSlots[1]
                local v21 = if v20 == nil or p5.Inventory[v20] == nil then 0 else 0 + 1
                local v22 = p5.FusionSlots[2]

                v19 = if v22 == nil or p5.Inventory[v22] == nil then v21 else v21 + 1

                local v23 = p5.FusionSlots[3]

                if v23 ~= nil and p5.Inventory[v23] ~= nil then
                    v19 += 1
                end
            else
                v19 = 0
            end

            Countdown.Text = ("%*/%*"):format(v19, Fusion.INPUT_COUNT)
        end

        local function destroySlot(p6) -- line: 213
            -- upvalues: t2 (copy)
            local v24 = t2[p6]

            if v24 then
                v24:Destroy()
                t2[p6] = nil
            end
        end

        local function requestReturn(p7) -- line: 222
            -- upvalues: Toast (copy), Remotes (copy), v1 (copy), v4 (copy)
            v4(function() -- line: 223
                -- upvalues: p7 (copy), Toast (copy), Remotes (copy), v1 (copy)
                local v25, v26 = Remotes.Fusery.EjectPet:InvokeServer(p7)

                if not v25 then
                    local v27 = if typeof(v26) == "string" then v26 else "Failed to return pet"

                    Toast.Show({
                        Seconds = 3,
                        Text = v27,
                        Color = v1
                    })
                end
            end)
        end

        local function render() -- line: 236
            -- upvalues: FuseInputs (copy), Fuse (copy), Price (copy), BackgroundColor3 (copy), v7 (copy), Briefing (copy), v13 (copy), t2 (copy), updateOverheadInputCount (copy), requestReturn (copy), Fusion (copy), AssetItems (copy), Directory (copy), FuseKernel (copy), FuseMachineSelectedSlot (copy), Save (copy), Simple (copy)
            local v28 = Save.Await()
            local v29 = table.create(3, false)

            if Briefing ~= nil then
                Briefing.Visible = v28 ~= nil and not v28.FusionInfoAcknowledged
            end

            updateOverheadInputCount(v28)

            if v28 ~= nil then
                local t3 = {}
                local v31

                for i = 1, 3 do
                    local v32 = v28.FusionSlots[i]
                    local v33 = if v32 then v28.Inventory[v32] else nil
                    local v34 = FuseInputs:FindFirstChild((("Input%*"):format(i)))

                    assert(v34 ~= nil and v34:IsA("Frame"), (("PetFuse.FuseMain.FuseInputs.Input%* is missing"):format(i)))

                    if v32 == nil or v33 == nil then
                        local v37 = t2[i]

                        if v37 then
                            v37:Destroy()
                            t2[i] = nil
                        end

                        v34.Full.Visible = false
                        v34.Empty.Visible = true
                    else
                        v29[i] = true
                        v31 = v31 or v33.Category

                        local v38 = t2[i]
                        local v39 = false

                        if v38 ~= nil then
                            if v38:GetUid() == v32 then
                                v39 = true
                            else
                                local v41 = t2[i]

                                if v41 then
                                    v41:Destroy()
                                    t2[i] = nil
                                end
                            end
                        else
                            local v40 = t2[i]

                            if v40 then
                                v40:Destroy()
                                t2[i] = nil
                            end
                        end

                        if not v39 then
                            t2[i] = FuseMachineSelectedSlot.new(v34, v32, v33, requestReturn)
                        end

                        table.insert(t3, AssetItems.Decode(v33))
                    end
                end

                local v42 = #t3 == Fusion.INPUT_COUNT and not v28.FusionLocked and v28.FusionEggReward == false
                local Icon

                if v31 ~= nil then
                    local v43 = Directory[v31]

                    assert(v43 ~= nil, (("Missing asset config %*"):format(v31)))
                    Icon = v43.Egg.Icon
                end

                v13:Update(v29, Icon)

                if v42 then
                    for _, v46 in ipairs(t3) do
                        if v46.Category ~= v31 then
                            v42 = false
                            break
                        end
                    end
                end

                Fuse.Visible = true
                Fuse.Active = v42

                if v42 then
                    Fuse.BackgroundColor3 = BackgroundColor3
                    Price.Text = "$ " .. Simple.FormatCompact(FuseKernel.PriceFor(t3))
                else
                    Fuse.BackgroundColor3 = v7
                    Price.Text = `{ Fusion.INPUT_COUNT - #t3 } Pet Left`
                end
            else
                Fuse.Visible = true
                Fuse.Active = false
                Fuse.BackgroundColor3 = v7
                Price.Text = ("%* Pet Left"):format(Fusion.INPUT_COUNT)
                v13:Update(v29, nil)
            end
        end

        local function scheduleRender() -- line: 325
            -- upvalues: v14 (ref), render (copy)
            if not v14 then
                v14 = true
                task.defer(function() -- line: 331
                    -- upvalues: v14 (ref), render (copy)
                    v14 = false
                    render()
                end)
            end
        end

        local function requestAcknowledgeInfo() -- line: 337
            -- upvalues: Briefing (copy), v14 (ref), render (copy), Toast (copy), Remotes (copy), v1 (copy), v5 (copy)
            v5(function() -- line: 338
                -- upvalues: Briefing (copy), v14 (ref), render (copy), Toast (copy), Remotes (copy), v1 (copy)
                if Briefing ~= nil and Briefing.Visible then
                    if Remotes.Fusery.ConfirmBriefing:InvokeServer() == true then
                        Briefing.Visible = false
                    else
                        Toast.Show({
                            Text = "Failed to save Fuse Machine info acknowledgement",
                            Seconds = 3,
                            Color = v1
                        })

                        if not v14 then
                            v14 = true
                            task.defer(function() -- line: 331
                                -- upvalues: v14 (ref), render (copy)
                                v14 = false
                                render()
                            end)
                        end
                    end
                end
            end)
        end

        local function closeSelection() -- line: 355
            -- upvalues: FuseMain (copy), FusePetInventory (copy), v12 (copy), MenuNavigation (copy)
            v12:Close()
            FusePetInventory.Visible = false
            FuseMain.Visible = true
            MenuNavigation.SetOverride("FusePetSelection", nil)
        end

        local function requestInsert(p8) -- line: 362
            -- upvalues: FuseMain (copy), FusePetInventory (copy), v8 (ref), v12 (copy), v14 (ref), render (copy), MenuNavigation (copy), Toast (copy), Remotes (copy), v1 (copy), v4 (copy)
            v4(function() -- line: 363
                -- upvalues: p8 (copy), FuseMain (copy), FusePetInventory (copy), v8 (ref), v12 (copy), v14 (ref), render (copy), MenuNavigation (copy), Toast (copy), Remotes (copy), v1 (copy)
                local v47, v48 = Remotes.Fusery.LoadPet:InvokeServer(p8, v8)

                if v47 then
                    v12:Close()
                    FusePetInventory.Visible = false
                    FuseMain.Visible = true
                    MenuNavigation.SetOverride("FusePetSelection", nil)

                    if not v14 then
                        v14 = true
                        task.defer(function() -- line: 331
                            -- upvalues: v14 (ref), render (copy)
                            v14 = false
                            render()
                        end)
                    end
                else
                    if typeof(v48) ~= "string" then
                        v48 = "Failed to insert pet"
                    end

                    Toast.Show({
                        Seconds = 3,
                        Text = v48,
                        Color = v1
                    })
                end
            end)
        end

        local function updateEmptyState(p9) -- line: 381
            -- upvalues: EmptyState (copy), v8 (ref)
            EmptyState.Visible = p9 == 0
            EmptyState.Text = v8 and "No eligible pets for this fuse." or "No matching unequipped pets.\nTry including equipped pets."
        end

        local function paintIncludeEquipped() -- line: 388
            -- upvalues: IncludeEquipped (copy), Icon (copy), UIGradient (copy), v8 (ref)
            Icon.Visible = v8
            UIGradient.Color = ColorSequence.new(if v8 then Color3.fromRGB(83, 202, 19) else Color3.fromRGB(83, 83, 102))
            IncludeEquipped:SetAttribute("Checked", v8)
        end

        local function startSelection() -- line: 398
            -- upvalues: FuseMain (copy), FusePetInventory (copy), IncludeEquipped (copy), EmptyState (copy), v8 (ref), v12 (copy), closeSelection (copy), requestInsert (copy), MenuNavigation (copy), Save (copy)
            if v12:IsOpen() then
                return
            end

            local v51 = Save.Await()

            if v51 ~= nil then
                local v52 = v51.FusionSlots[1]
                local Category

                if v52 ~= nil then
                    local v53 = v51.Inventory[v52]

                    if v53 then
                        Category = v53.Category
                    end
                end

                local v54 = v8
                local v55 = v51.FusionSlots[1]
                local v56

                if v55 ~= nil then
                    local v57 = v51.Inventory[v55]

                    if v57 then
                        v56 = v57.CreatorTemporary == true
                    end
                end

                local v58 = v12:Open(v51, Category, requestInsert, v54, v56)

                EmptyState.Visible = v58 == 0
                EmptyState.Text = v8 and "No eligible pets for this fuse." or "No matching unequipped pets.\nTry including equipped pets."
                FuseMain.Visible = false
                FusePetInventory.Visible = true
                v12:RefreshGridLayout()
                MenuNavigation.SetOverride("FusePetSelection", FusePetInventory, if v58 == 0 then IncludeEquipped else nil, closeSelection, 1000, true)
            end
        end

        local function refreshSelection() -- line: 427
            -- upvalues: FuseMain (copy), FusePetInventory (copy), ScrollingFrame (copy), IncludeEquipped (copy), EmptyState (copy), v8 (ref), v12 (copy), closeSelection (copy), requestInsert (copy), Fusion (copy), GuiService (copy), MenuNavigation (copy), Save (copy)
            if not v12:IsOpen() then
                return
            end

            local v59 = Save.Await()
            local CanvasPosition, Name, v60

            if v59 == nil or v59.FusionLocked then
                v60 = true
            elseif v59.FusionEggReward ~= false or #v59.FusionSlots >= Fusion.INPUT_COUNT then
                v60 = true
            else
                CanvasPosition = ScrollingFrame.CanvasPosition

                local v61 = MenuNavigation.TopOverride()

                if not MenuNavigation.IsCursorActive() and v61 ~= nil and v61.Root == FusePetInventory then
                    local SelectedObject = GuiService.SelectedObject

                    if SelectedObject == nil or SelectedObject.Parent ~= ScrollingFrame then
                        SelectedObject = v61.Initial
                    end

                    if SelectedObject ~= nil and SelectedObject.Parent == ScrollingFrame then
                        Name = SelectedObject.Name
                    end
                end

                v60 = false
            end

            v12:Close()

            if not v60 then
                local v62 = v59.FusionSlots[1]
                local Category

                if v62 ~= nil then
                    local v63 = v59.Inventory[v62]

                    if v63 then
                        Category = v63.Category
                    end
                end

                local v64 = v8
                local v65 = v59.FusionSlots[1]
                local v66

                if v65 ~= nil then
                    local v67 = v59.Inventory[v65]

                    if v67 then
                        v66 = v67.CreatorTemporary == true
                    end
                end

                EmptyState.Visible = v12:Open(v59, Category, requestInsert, v64, v66) == 0
                EmptyState.Text = v8 and "No eligible pets for this fuse." or "No matching unequipped pets.\nTry including equipped pets."
                v12:RefreshGridLayout()
                ScrollingFrame.CanvasPosition = CanvasPosition

                if Name ~= nil then
                    local v69 = ScrollingFrame:FindFirstChild(Name)

                    if not v69 or not v69:IsA("GuiObject") then
                        v69 = IncludeEquipped
                    end

                    MenuNavigation.SetOverride("FusePetSelection", FusePetInventory, v69, closeSelection, 1000, true)
                end
            else
                FusePetInventory.Visible = false
                FuseMain.Visible = true
                MenuNavigation.SetOverride("FusePetSelection", nil)
            end
        end

        local function toggleIncludeEquipped() -- line: 488
            -- upvalues: v8 (ref), paintIncludeEquipped (copy), refreshSelection (copy), v4 (copy)
            v4(function() -- line: 489
                -- upvalues: v8 (ref), paintIncludeEquipped (copy), refreshSelection (copy)
                v8 = not v8
                paintIncludeEquipped()
                refreshSelection()
            end)
        end

        local function refreshPickerLayout() -- line: 496
            -- upvalues: v12 (copy)
            if v12:IsOpen() then
                v12:RefreshGridLayout()
            end
        end

        local function requestFuse() -- line: 502
            -- upvalues: v14 (ref), render (copy), Audio (copy), Eggs (copy), FuseMachineSignals (copy), FuseMachine (copy), Toast (copy), Remotes (copy), Save (copy), v1 (copy), v2 (copy), v3 (copy)
            v3(function() -- line: 503
                -- upvalues: v14 (ref), render (copy), Audio (copy), Eggs (copy), FuseMachineSignals (copy), FuseMachine (copy), Toast (copy), Remotes (copy), Save (copy), v1 (copy), v2 (copy)
                local v70 = Save.Await()

                if v70 == nil then
                    return
                end

                local n1 = 0

                for _ in pairs(v70.EggInventory) do
                    n1 += 1
                end

                if Eggs.MAX_INVENTORY <= n1 then
                    Toast.Show({
                        Text = "Your egg inventory is full!",
                        Seconds = 3,
                        Color = v1
                    })
                else
                    local v71, v72, v73 = Remotes.Fusery.BeginFuse:InvokeServer()

                    if v71 then
                        if FuseMachine.FuseResult(v73) then
                            Audio.Play(83520877125467, script, {
                                Volume = 1.5
                            })
                            FuseMachineSignals.FuseStarted:Fire(v73)

                            if not v14 then
                                v14 = true
                                task.defer(function() -- line: 331
                                    -- upvalues: v14 (ref), render (copy)
                                    v14 = false
                                    render()
                                end)
                            end
                        else
                            v2:AtError():Log("Fuse server returned an invalid reward")
                        end
                    else
                        if typeof(v72) ~= "string" then
                            v72 = "Failed to start fuse"
                        end

                        Toast.Show({
                            Seconds = 3,
                            Text = v72,
                            Color = v1
                        })
                    end
                end
            end)
        end

        paintIncludeEquipped()
        v6:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshPickerLayout)
        ButtonFX(IncludeEquipped, 1.015, toggleIncludeEquipped)
        FuseMain.Visible = true
        Output.Visible = true
        FusePetInventory.Visible = false

        if Briefing ~= nil then
            Briefing.Visible = false
        end

        for i = 1, 3 do
            local v74 = FuseInputs:FindFirstChild((("Input%*"):format(i)))

            assert(v74 ~= nil and v74:IsA("Frame"), (("PetFuse.FuseMain.FuseInputs.Input%* is missing"):format(i)))
            v74.Full.Visible = false
            v74.Empty.Visible = true

            local Add = v74.Empty.Add

            assert(Add:IsA("ImageButton"), (("PetFuse.FuseMain.FuseInputs.Input%*.Empty.Add must be an ImageButton"):format(i)))
            Add.Activated:Connect(startSelection)
            ButtonFX(Add, 1.08)
        end

        Fuse.Activated:Connect(requestFuse)
        ButtonFX(Fuse, 1.08)

        if Close ~= nil then
            GUI.OnActivated(Close, closeSelection)
            ButtonFX(Close, 1.08)
        end

        if Ok ~= nil then
            Ok.Activated:Connect(requestAcknowledgeInfo)
            ButtonFX(Ok)
        end

        Save.WatchFields({
            "FusionSlots",
            "FusionLocked",
            "FusionEggReward",
            "FusionInfoAcknowledged",
            "Inventory",
            "EggInventory"
        }, function() -- line: 593
            -- upvalues: v14 (ref), render (copy), Tabs (copy)
            if not Tabs.IsActive("PetFuse") or v14 then
                return
            end

            v14 = true
            task.defer(function() -- line: 331
                -- upvalues: v14 (ref), render (copy)
                v14 = false
                render()
            end)
        end)
        Save.WatchFields({
            "FusionSlots",
            "FusionLocked",
            "FusionEggReward",
            "Inventory",
            "EquippedAssets"
        }, function() -- line: 604
            -- upvalues: refreshSelection (copy), Tabs (copy)
            if Tabs.IsActive("PetFuse") then
                refreshSelection()
            end
        end)
        Tabs.Activated:Connect(function(p10) -- line: 609
            -- upvalues: v14 (ref), render (copy)
            if p10 ~= "PetFuse" or v14 then
                return
            end

            v14 = true
            task.defer(function() -- line: 331
                -- upvalues: v14 (ref), render (copy)
                v14 = false
                render()
            end)
        end)
        Tabs.Deactivated:Connect(function(p11) -- line: 615
            -- upvalues: FuseMain (copy), FusePetInventory (copy), v8 (ref), v12 (copy), paintIncludeEquipped (copy), MenuNavigation (copy)
            if p11 ~= "PetFuse" then
                return
            end

            v8 = false
            paintIncludeEquipped()
            v12:Close()
            FusePetInventory.Visible = false
            FuseMain.Visible = true
            MenuNavigation.SetOverride("FusePetSelection", nil)
        end)
        render()
        require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(scheduleRender)
    end
}
