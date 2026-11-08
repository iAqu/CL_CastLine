-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Parent = script.Parent
local Launcher = Parent:WaitForChild("Launcher")
local Hub = require(Parent.Hub)
local Areas = require(ReplicatedStorage.Data.Areas)
local Assets = require(ReplicatedStorage.Data.Assets)
local EnchantedForestFlags = require(ReplicatedStorage.Shared.Flags.EnchantedForestFlags)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local StaffEntryHotkey = require(ReplicatedStorage.Client.StaffEntryHotkey)
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local GUI = require(ReplicatedStorage.Client.GUI)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local CreatorCommands = require(ReplicatedStorage.Shared.CreatorCommands)
local ContentCreatorRemotes = ReplicatedStorage:WaitForChild("ContentCreatorRemotes")
local Request = ContentCreatorRemotes:WaitForChild("Request")
local Update = ContentCreatorRemotes:WaitForChild("Update")
local Colors = Hub.Colors
local t1 = {
    {
        Name = "Camera",
        Color = Color3.fromRGB(68, 196, 255)
    },
    {
        Name = "Character",
        Color = Color3.fromRGB(119, 255, 65)
    },
    {
        Name = "Collection",
        Color = Color3.fromRGB(255, 211, 49)
    },
    {
        Name = "Mutations",
        Color = Color3.fromRGB(236, 104, 255)
    },
    {
        Name = "Scene",
        Color = Color3.fromRGB(255, 149, 62)
    },
    {
        Name = "Servers",
        Color = Color3.fromRGB(170, 144, 255)
    },
    {
        Name = "Manage",
        Color = Color3.fromRGB(255, 111, 136)
    }
}
local _ = {
    target = "Player",
    server = "Creator server",
    zone = "Zone",
    destination = "Zone",
    zoneOrAll = "Guards to pause",
    guard = "Guard look",
    guardPose = "Pose",
    asset = "Animal / egg",
    egg = "Placed egg",
    pet = "Pen pet",
    currency = "What to give",
    event = "Server event",
    prank = "Prank",
    mutations = "Mutations",
    guardZone = "Zone",
    rarity = "Rarity"
}
local t2 = {
    asset = "an animal / egg type",
    zoneOrAll = "a zone",
    destination = "a zone",
    guardZone = "a zone",
    guard = "a guard",
    currency = "what to give",
    event = "an event"
}
local t3 = {
    {
        Key = "Rank",
        Descending = false,
        Label = "Rarity ↑"
    },
    {
        Key = "Rank",
        Descending = true,
        Label = "Rarity ↓"
    },
    {
        Key = "Price",
        Descending = false,
        Label = "Price ↑"
    },
    {
        Key = "Price",
        Descending = true,
        Label = "Price ↓"
    },
    {
        Key = "Label",
        Descending = false,
        Label = "Name A–Z"
    },
    {
        Key = "Label",
        Descending = true,
        Label = "Name Z–A"
    }
}

local function amountMax(p1) -- line: 71
    if p1 == "giveShards" then
        return 1E+06
    end

    return 25
end

local t4 = {
    Access = false,
    Owns = false
}
local v1 = t4

t4.Commands = {}
t4.Active = {}
t4.TargetActive = {}
t4.Players = {}
t4.Servers = {}
t4.Balances = {}
t4.PlacedEggs = {}
t4.PenPets = {}
t4.Mutations = {}
t4.Events = {}
t4.Destinations = {}

local t5 = {}
local v2 = false
local n1 = 0
local n2 = 0
local v3 = false
local v4 = false
local SelectedObject, v5, v6, v7, v8, v9, v10
local Root = Parent:FindFirstChild("Root")

if Root then
    Root:Destroy()
end

Hub.BindCaptions(Parent)

local function focus(p2) -- line: 112
    -- upvalues: GuiService (copy), UserInputService (copy), MenuNavigation (copy)
    if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
        GuiService.SelectedObject = p2
    end
end

local v11 = Hub.Window({
    Name = "Root",
    Title = "Creator Panel",
    SearchPlaceholder = "Find a tool...",
    Parent = Parent,
    Kit = Parent.UIKit,
    Focus = focus,
    OnClose = function() -- OnClose | line: 125
        -- upvalues: v9 (ref)
        v9(false)
    end
})

for _, v12 in t1 do
    v11:Tab({
        Name = v12.Name,
        Color = v12.Color,
        Icon = Parent.UIKit.Icons[v12.Name]
    })
end

local function notice(p3, p4) -- line: 133
    -- upvalues: v11 (copy)
    v11:Notify(p3, p4)
end

local function panelEnabled() -- line: 137
    -- upvalues: UserInputService (copy), Preferences (copy)
    return UserInputService.KeyboardEnabled or Preferences.IsOn("CreatorPanel")
end

local function refreshLauncher(p5) -- line: 141
    -- upvalues: UserInputService (copy), Parent (copy), Launcher (copy), StaffEntryHotkey (copy), Preferences (copy), GUI (copy), PlatformController (copy), v1 (ref)
    local v13 = if PlatformController.IsConsole() then GUI.HUD() else Parent

    if Launcher.Parent ~= v13 then
        Launcher.Parent = v13
    end

    local Enabled = Parent.Enabled
    local v14, v15

    if Enabled then
        local Access = v1.Access

        if Access then
            v14 = UserInputService.KeyboardEnabled or Preferences.IsOn("CreatorPanel")
            v15 = v14 and not p5 and not UserInputService.KeyboardEnabled and not StaffEntryHotkey.IsHidden()
        else
            v15 = Access
        end
    else
        v15 = Enabled
    end

    Launcher.Visible = v15
end

v9 = function(p6) -- line: 157
    -- upvalues: GuiService (copy), UserInputService (copy), Preferences (copy), MenuNavigation (copy), v1 (ref), n2 (ref), v3 (ref), v4 (ref), SelectedObject (ref), v11 (copy), refreshLauncher (copy)
    if not (not p6 or v1.Access and (UserInputService.KeyboardEnabled or Preferences.IsOn("CreatorPanel"))) then
        return
    end

    local Visible = v11.Frame.Visible

    if p6 and not Visible then
        v3 = true
        n2 = 0
        SelectedObject = GuiService.SelectedObject

        if not v4 and v1.Owns and not v1.Reserved then
            v4 = true
            v11:SelectTab("Servers")
        end
    end

    v11:SetVisible(p6)
    refreshLauncher(p6)

    if p6 then
        local Button = v11.Selected.Button

        if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
            GuiService.SelectedObject = Button
        end
    elseif Visible then
        v3 = false
        GuiService.SelectedObject = if SelectedObject and SelectedObject.Parent then SelectedObject else nil
    end
end

local function applyState(p7) -- line: 183
    -- upvalues: v1 (ref), v8 (ref), v10 (ref)
    if type(p7) ~= "table" then
        return
    end

    if p7.Lightweight == true and p7.Access == true then
        if p7.Admin == v1.Admin then
            p7.Servers = v1.Servers
            p7.PlacedEggs = v1.PlacedEggs
            p7.PenPets = v1.PenPets
        else
            p7.Servers = {}
            p7.PlacedEggs = {}
            p7.PenPets = {}
        end
    end

    v1 = p7
    v8.Refresh()
    v10()
end

local function send(p8, p9) -- line: 200
    -- upvalues: Request (copy), v2 (ref), n1 (ref), n2 (ref), v3 (ref), v11 (copy), applyState (copy)
    if v2 then
        return nil
    end

    v2 = true
    n1 += 1

    local function v16() -- line: 206
        -- upvalues: p8 (copy), p9 (copy), Request (copy)
        return Request:InvokeServer(p8, p9)
    end

    local ok, result = pcall(v16)

    v2 = false

    if ok and type(result) == "table" then
        applyState(result.State)

        if type(result.State) == "table" and not result.State.Lightweight then
            v3 = false
            n2 = os.clock() + (if v11.Frame.Visible then 3 else 30)
        end

        if result.Message then
            v11:Notify(result.Message, result.Ok)
        end

        return result
    end

    v11:Notify("Connection interrupted. Please try again.", false)

    return nil
end

local function succeeded(p10) -- line: 225
    return p10 ~= nil and p10.Ok == true
end

local function balanceLabel(p11) -- line: 231
    -- upvalues: v1 (ref)
    for _, v17 in v1.Balances or {} do
        if v17.Value == p11 then
            return v17.Label
        end
    end

    return nil
end

local function ownServer() -- line: 240
    -- upvalues: LocalPlayer (copy), v1 (ref)
    for _, v18 in v1.Servers do
        if v18.OwnerUserId == LocalPlayer.UserId then
            return v18
        end
    end

    return nil
end

local function byLabel(p12) -- line: 249
    table.sort(p12, function(p13, p14) -- line: 250
        return p13.Label < p14.Label
    end)

    return p12
end

local function playerOption(p15, p16, p17) -- line: 256
    return {
        Value = p15,
        Label = if p17 then ("%* (@%*) · %*"):format(p16 or p17, p17, p15) else "User ID: " .. tostring(p15),
        Title = p16 or p17 or "Player",
        Subtitle = if p17 then "@" .. p17 else "ID: " .. tostring(p15),
        Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=420&h=420"):format(p15)
    }
end

local function targetOf(p18) -- line: 268
    -- upvalues: LocalPlayer (copy)
    local target = p18.Elements.target

    if not (target and target.Instance.Visible) then
        return LocalPlayer.UserId
    end

    return target.Value
end

local function unreleased() -- line: 273
    -- upvalues: Areas (copy), EnchantedForestFlags (copy)
    if EnchantedForestFlags.ShouldReveal() then
        return {}
    end

    local t7 = {
        ["Enchanted Forest"] = true,
        ["World Spirit"] = true,
        ["Banjo Firefly"] = true
    }

    for _, v19 in Areas.Directory["Enchanted Forest"].DropTable do
        t7[v19[1]] = true
    end

    return t7
end

local function areaOptions(p19) -- line: 288
    -- upvalues: Areas (copy), unreleased (copy)
    local t8 = {}
    local v20 = unreleased()

    for v21 in Areas.Directory do
        if not v20[v21] then
            table.insert(t8, {
                Value = v21,
                Label = v21
            })
        end
    end

    table.sort(t8, function(p20, p21) -- line: 250
        return p20.Label < p21.Label
    end)

    if p19 then
        table.insert(t8, 1, {
            Value = "all",
            Label = "All zones"
        })
    end

    return t8
end

local function assetOptions(p22) -- line: 303
    -- upvalues: Assets (copy), v1 (ref), unreleased (copy)
    local t11 = {
        ["Light 7"] = "Pegasus",
        ["Light 8"] = "ArchAngel",
        ["Dark 7"] = "Skeleton Horse",
        ["Dark 8"] = "World Burner"
    }
    local v22 = unreleased()

    local function hidden(p23) -- line: 312
        -- upvalues: t11 (copy), v22 (copy), Assets (copy), v1 (ref)
        if t11[p23] == nil or Assets.Directory[t11[p23]] == nil then
            local v23 = v1

            if (v23.ExcludedAssets or {})[p23] == nil then
                return v22[p23] == true
            end
        end

        return true
    end

    local t12 = {}

    for v24, v25 in Assets.Directory do
        if t11[v24] == nil or Assets.Directory[t11[v24]] == nil then
            local v26 = v1

            if (v26.ExcludedAssets or {})[v24] == nil and v22[v24] ~= true then
                local v27 = v25.DisplayName or v24

                t12[v27] = (t12[v27] or 0) + 1
            end
        end
    end

    local t13 = {}

    for v28, v29 in Assets.Directory do
        if t11[v28] == nil or Assets.Directory[t11[v28]] == nil then
            local v30 = v1

            if (v30.ExcludedAssets or {})[v28] == nil and v22[v28] ~= true then
                local v31 = v29.DisplayName or v28

                table.insert(t13, {
                    Value = v28,
                    Label = if t12[v31] > 1 then v28 else v31,
                    Rank = v29.Rarity and v29.Rarity.Rank or 0,
                    Price = v29.EarningRate or 0,
                    Image = if p22 then v29.Icon or "rbxassetid://83736894896123" else v29.Egg and v29.Egg.Icon or "rbxassetid://103094823152347"
                })
            end
        end
    end

    return t13
end

local function ownedOptions(p24) -- line: 344
    local t15 = {}

    for _, v32 in p24 or {} do
        local t16 = {
            Value = v32.Uid
        }

        t16.Title = v32.Title or v32.Label
        t16.Subtitle = v32.Subtitle or string.sub(v32.Uid, -6)

        local Label, Subtitle2 = v32.Label, v32.Subtitle

        if not Subtitle2 then
            Subtitle2 = string.sub(v32.Uid, -6)
        end

        t16.Label = Label .. " · " .. Subtitle2
        t16.Image = v32.Image
        table.insert(t15, t16)
    end

    return t15
end

local function listOptions(p25) -- line: 358
    local t17 = {}

    for _, v33 in p25 or {} do
        table.insert(t17, {
            Value = v33.Value,
            Label = v33.Label
        })
    end

    return t17
end

local function number(p26, p27, p28, p29, p30, p31, p32) -- line: 366
    p26.Checks[p27] = function(p33) -- line: 367
        -- upvalues: p27 (copy), p29 (copy), p30 (copy), p32 (copy)
        return if type(p33) ~= "number" or p33 ~= p33 or p33 < p29 or p30 < p33 or p32 and p33 % 1 ~= 0 then ("Enter %* from %* to %*."):format(p27, p29, p30) else nil
    end

    return p26.Group:Input({
        Numeric = true,
        Title = p28,
        Default = p31
    })
end

local t19 = {
    target = function(p34) -- line: 384
        -- upvalues: LocalPlayer (copy), v1 (ref), v10 (ref), playerOption (copy)
        local v37 = p34.Group:Dropdown({
            Title = "Player",
            PickerTitle = "Choose a player",
            Search = "Search name, username or user ID...",
            Options = function() -- Options | line: 389
                -- upvalues: v1 (ref), playerOption (copy)
                local t21 = {}

                for _, v34 in v1.Players do
                    table.insert(t21, (playerOption(v34.UserId, v34.DisplayName, v34.Name)))
                end

                table.sort(t21, function(p35, p36) -- line: 250
                    return p35.Label < p36.Label
                end)

                return t21
            end,
            Callback = function() -- Callback | line: 396
                -- upvalues: p34 (copy), v10 (ref)
                for _, v36 in { "egg", "pet" } do
                    if p34.Elements[v36] then
                        p34.Elements[v36]:Set(nil)
                    end
                end

                v10()
            end
        })

        v37:Set(LocalPlayer.UserId, "You · " .. LocalPlayer.DisplayName)

        return v37
    end,
    server = function(p37) -- line: 408
        -- upvalues: v1 (ref)
        return p37.Group:Dropdown({
            Title = "Creator server",
            Options = function() -- Options | line: 411
                -- upvalues: v1 (ref)
                local t22 = {}

                for _, v38 in v1.Servers do
                    local Id = v38.Id

                    if not Id then
                        Id = tostring(v38.OwnerUserId)
                    end

                    table.insert(t22, {
                        Value = Id,
                        Label = v38.Name .. (if v38.Enabled then " · " .. (v38.Status or "Checking…") else " · Disabled")
                    })
                end

                table.sort(t22, function(p38, p39) -- line: 250
                    return p38.Label < p39.Label
                end)

                return t22
            end
        })
    end,
    zone = function(p40) -- line: 425
        -- upvalues: areaOptions (copy)
        return p40.Group:Dropdown({
            Title = "Zone",
            Options = function() -- Options | line: 428
                -- upvalues: areaOptions (copy)
                return (areaOptions(false))
            end
        })
    end,
    destination = function(p41) -- line: 433
        -- upvalues: v1 (ref), areaOptions (copy), listOptions (copy)
        return p41.Group:Dropdown({
            Title = "Zone",
            Options = function() -- Options | line: 436
                -- upvalues: v1 (ref), areaOptions (copy), listOptions (copy)
                local v39 = areaOptions(false)

                for _, v40 in listOptions(v1.Destinations) do
                    table.insert(v39, v40)
                end

                table.sort(v39, function(p42, p43) -- line: 250
                    return p42.Label < p43.Label
                end)

                return v39
            end
        })
    end,
    guard = function(p44) -- line: 445
        -- upvalues: areaOptions (copy)
        return p44.Group:Dropdown({
            Title = "Guard look",
            Options = function() -- Options | line: 448
                -- upvalues: areaOptions (copy)
                return (areaOptions(false))
            end
        })
    end,
    zoneOrAll = function(p45) -- line: 453
        -- upvalues: areaOptions (copy)
        return p45.Group:Dropdown({
            Title = "Guards to pause",
            Options = function() -- Options | line: 456
                -- upvalues: areaOptions (copy)
                return (areaOptions(true))
            end
        })
    end,
    asset = function(p46) -- line: 461
        -- upvalues: t3 (copy), assetOptions (copy)
        local v41 = p46.Id == "giveAnimal" or p46.Id == "spawnMutatedPet"

        return p46.Group:Dropdown({
            Title = "Animal / egg",
            PickerTitle = v41 and "Choose a pet" or "Choose an egg",
            Search = v41 and "Search pets..." or "Search eggs...",
            Sorts = t3,
            Options = function() -- Options | line: 468
                -- upvalues: v41 (copy), assetOptions (copy)
                return (assetOptions(v41))
            end
        })
    end,
    egg = function(p47) -- line: 473
        -- upvalues: LocalPlayer (copy), v1 (ref), ownedOptions (copy)
        return p47.Group:Dropdown({
            Title = "Placed egg",
            PickerTitle = "Choose an egg",
            Placeholder = "Choose an egg",
            Options = function() -- Options | line: 478
                -- upvalues: p47 (copy), LocalPlayer (copy), v1 (ref), ownedOptions (copy)
                local PlacedEggs = v1.PlacedEggs
                local target = p47.Elements.target

                return (ownedOptions(PlacedEggs[tostring(if not (target and target.Instance.Visible) then LocalPlayer.UserId else target.Value)]))
            end
        })
    end,
    pet = function(p48) -- line: 483
        -- upvalues: LocalPlayer (copy), v1 (ref), ownedOptions (copy)
        return p48.Group:Dropdown({
            Title = "Pen pet",
            PickerTitle = "Choose a pet",
            Placeholder = "Choose a pet",
            Options = function() -- Options | line: 488
                -- upvalues: p48 (copy), LocalPlayer (copy), v1 (ref), ownedOptions (copy)
                local PenPets = v1.PenPets
                local target = p48.Elements.target

                return (ownedOptions(PenPets[tostring(if not (target and target.Instance.Visible) then LocalPlayer.UserId else target.Value)]))
            end
        })
    end,
    currency = function(p49) -- line: 493
        -- upvalues: v1 (ref), listOptions (copy)
        p49.Checks.currency = function(p50) -- line: 494
            -- upvalues: v1 (ref)
            local v44 = false
            local Label

            for _, v45 in v1.Balances or {} do
                if v45.Value == p50 then
                    Label = v45.Label
                    v44 = true
                    break
                end
            end

            if not v44 then
                Label = nil
            end

            return if not Label then "Choose what to give to continue." else nil
        end

        return p49.Group:Dropdown({
            Title = "What to give",
            Options = function() -- Options | line: 499
                -- upvalues: v1 (ref), listOptions (copy)
                return (listOptions(v1.Balances))
            end
        })
    end,
    event = function(p51) -- line: 504
        -- upvalues: v1 (ref), listOptions (copy)
        return p51.Group:Dropdown({
            Title = "Server event",
            PickerTitle = "Choose an event",
            Options = function() -- Options | line: 508
                -- upvalues: v1 (ref), listOptions (copy)
                local v46 = listOptions(v1.Events)

                table.sort(v46, function(p52, p53) -- line: 250
                    return p52.Label < p53.Label
                end)

                return v46
            end
        })
    end,
    prank = function(p54) -- line: 513
        return p54.Group:Dropdown({
            Title = "Prank",
            Options = {
                {
                    Value = "fling",
                    Label = "Fling · Launch into the air"
                },
                {
                    Value = "slip",
                    Label = "Slip · A brief sideways tumble"
                },
                {
                    Value = "dropEgg",
                    Label = "Drop egg · Drop a stolen egg"
                }
            }
        })
    end,
    mutations = function(p55) -- line: 523
        -- upvalues: Mutations (copy), t3 (copy), v1 (ref)
        local v47 = p55.Id == "setPetMutation"

        p55.Checks.mutations = function(p56) -- line: 525
            -- upvalues: v47 (copy)
            return if type(p56) ~= "table" or #p56 == 0 and not v47 then "Choose at least one mutation to continue." else nil
        end

        return p55.Group:Dropdown({
            Title = "Mutations",
            PickerTitle = "Pick one or more, then Back",
            Multi = true,
            Placeholder = v47 and "No mutation" or "Choose...",
            Sorts = t3,
            Options = function() -- Options | line: 537
                -- upvalues: v47 (copy), Mutations (copy), v1 (ref)
                local t28 = {}

                for _, v48 in v1.Mutations or {} do
                    table.insert(t28, {
                        Value = v48.Value,
                        Label = v48.Label,
                        Rank = v48.Rank,
                        Price = v48.Rank
                    })
                end

                if v47 then
                    table.insert(t28, {
                        Label = "No mutation",
                        Clears = true,
                        Value = Mutations.NO_MUTATION
                    })
                end

                return t28
            end
        })
    end,
    speed = function(p57) -- line: 554
        return p57.Group:Slider({
            Title = "Walk speed",
            Min = 1,
            Max = 300,
            Default = 32
        })
    end,
    speedPower = function(p58) -- line: 557
        -- upvalues: number (copy)
        return number(p58, "speedPower", "Speed", 0, 1E+21, 10, true)
    end,
    money = function(p59) -- line: 560
        -- upvalues: number (copy)
        return number(p59, "money", "Cash", 0, 1E+21, 0, true)
    end,
    guardZone = function(p60) -- line: 564
        -- upvalues: areaOptions (copy)
        return p60.Group:Dropdown({
            Title = "Zone",
            Options = function() -- Options | line: 567
                -- upvalues: areaOptions (copy)
                local t31 = {}

                for _, v49 in areaOptions(false) do
                    if v49.Value ~= "Forest" then
                        table.insert(t31, v49)
                    end
                end

                return t31
            end
        })
    end,
    guardSpeed = function(p61) -- line: 578
        return p61.Group:Slider({
            Title = "Guard speed",
            Min = 0.25,
            Max = 5,
            Step = 0.25,
            Default = 1,
            Suffix = "x"
        })
    end,
    guardSize = function(p62) -- line: 581
        return p62.Group:Slider({
            Title = "Guard size",
            Min = 0.25,
            Max = 4,
            Step = 0.25,
            Default = 1,
            Suffix = "x"
        })
    end,
    eggSize = function(p63) -- line: 584
        -- upvalues: number (copy)
        return number(p63, "eggSize", "Egg size (0.1–100)", 0.1, 100, 1, false)
    end,
    eggLuck = function(p64) -- line: 587
        -- upvalues: number (copy)
        return number(p64, "eggLuck", "Spawn luck (1–999)", 1, 999, 1, false)
    end,
    treadmillSpeed = function(p65) -- line: 590
        -- upvalues: number (copy)
        return number(p65, "treadmillSpeed", "Speed multiplier (2–1000000000)", 2, 1E+09, 1E+06, true)
    end,
    guardPose = function(p66) -- line: 593
        local v50 = p66.Group:Dropdown({
            Title = "Pose",
            Options = {
                {
                    Value = "Sleep",
                    Label = "Sleep · The guard's real sleep pose"
                },
                {
                    Value = "Idle",
                    Label = "Idle · Stand still, even while moving"
                },
                {
                    Value = "Attack",
                    Label = "Attack · Play the attack once"
                }
            }
        })

        v50:Set("Sleep", "Sleep · The guard's real sleep pose")

        return v50
    end,
    mutationBoost = function(p67) -- line: 605
        return p67.Group:Slider({
            Title = "Mutation luck",
            Min = 1,
            Max = 100,
            Step = 1,
            Default = 1,
            Suffix = "x"
        })
    end,
    sizeBoost = function(p68) -- line: 608
        return p68.Group:Slider({
            Title = "Pet size",
            Min = 1,
            Max = 5,
            Step = 0.25,
            Default = 1,
            Suffix = "x"
        })
    end,
    earningsBoost = function(p69) -- line: 611
        return p69.Group:Slider({
            Title = "Money",
            Min = 1,
            Max = 100,
            Step = 1,
            Default = 1,
            Suffix = "x"
        })
    end,
    speedBoost = function(p70) -- line: 614
        return p70.Group:Slider({
            Title = "Speed",
            Min = 1,
            Max = 5,
            Step = 0.25,
            Default = 1,
            Suffix = "x"
        })
    end,
    rarity = function(p71) -- line: 617
        -- upvalues: Rarity (copy)
        local v51 = p71.Group:Dropdown({
            Title = "Rarity",
            Options = function() -- Options | line: 620
                -- upvalues: Rarity (copy)
                local t32 = {}

                for v52, v53 in Rarity.Rarities do
                    if v53._id == v52 then
                        table.insert(t32, {
                            Value = v52,
                            Label = v53.DisplayName,
                            Rank = v53.Rank
                        })
                    end
                end

                table.sort(t32, function(p72, p73) -- line: 627
                    return p72.Rank < p73.Rank
                end)
                table.insert(t32, 1, {
                    Value = "all",
                    Label = "All rarities"
                })

                return t32
            end
        })

        v51:Set("all", "All rarities")

        return v51
    end,
    size = function(p74) -- line: 637
        -- upvalues: number (copy)
        return number(p74, "size", "Size (0.1–100)", 0.1, 100, 1, false)
    end,
    amount = function(p75) -- line: 640
        -- upvalues: number (copy)
        local v54 = if p75.Id == "giveShards" then 1E+06 else 25

        return number(p75, "amount", ("Amount (1–%*)"):format(v54), 1, v54, 1, true)
    end,
    minutes = function(p76) -- line: 644
        -- upvalues: number (copy)
        return number(p76, "minutes", "Minutes (1–120)", 1, 120, 10, true)
    end,
    message = function(p77) -- line: 647
        p77.Checks.message = function(p78) -- line: 648
            return if type(p78) ~= "string" or string.match(p78, "^%s*$") then "Write a message to continue." else nil
        end

        return p77.Group:Input({
            Title = "Message",
            Placeholder = "Type your announcement"
        })
    end
}

local function isActive(p79) -- line: 657
    -- upvalues: LocalPlayer (copy), v1 (ref)
    local target = p79.Elements.target
    local v55 = if not (target and target.Instance.Visible) then LocalPlayer.UserId else target.Value

    return (if v55 == LocalPlayer.UserId then v1.Active else (v1.TargetActive or {})[tostring(v55)] or {})[p79.Id] ~= nil
end

local function payloadOf(p80) -- line: 665
    local t35 = {}

    for v56, v57 in p80.Elements do
        if v57.Instance.Visible then
            t35[v56] = v57.Value
        end
    end

    return t35
end

local function ready(p81, p82) -- line: 676
    -- upvalues: t2 (copy), v1 (ref), v11 (copy)
    local v58 = v1.Commands[p81.Id]

    if not (v58 and v58.Allowed) then
        local Reason = if v58 then v58.Reason else nil

        if not v58 or not Reason then
            Reason = "Access unavailable."
        end

        v11:Notify(Reason, false)

        return false
    end

    if not p82 then
        for _, v59 in p81.Order do
            local v60 = p81.Elements[v59]

            if v60.Instance.Visible and not v60.Skip then
                local v61 = p81.Checks[v59]
                local v62 = if v61 then v61(v60.Value) elseif v60.Value == nil or v60.Value == "" then ("Choose %* to continue."):format(t2[v59] or "a " .. v59) else nil

                if v62 then
                    v11:Notify(v62, false)

                    return false
                end
            end
        end
    end

    return true
end

local function run(p83, p84) -- line: 704
    -- upvalues: send (copy), payloadOf (copy), ready (copy)
    if not ready(p83, p84 ~= nil and p84.enabled == false) then
        return nil
    end

    local v65 = payloadOf(p83)

    for v66, v67 in p84 or {} do
        v65[v66] = v67
    end

    return (send(p83.Id, v65))
end

local function addField(p85, p86) -- line: 715
    -- upvalues: t19 (copy)
    local v68 = t19[p86]

    assert(v68, (("CreatorCommands field \"%*\" has no builder in Panel.Fields"):format(p86)))

    local v70 = v68(p85)

    p85.Elements[p86] = v70
    table.insert(p85.Order, p86)

    return v70
end

local function openGuestPicker(p87) -- line: 725
    -- upvalues: v5 (ref), v11 (copy), send (copy)
    local v71 = send("manageWhitelist", {
        action = "presence",
        server = p87
    })

    if not (v71 and v71.Ok and v71.Data) then
        return
    end

    local t36 = {}

    for _, v72 in v71.Data.Accounts do
        local v73 = v72.Status == "Here"

        table.insert(t36, {
            Value = v72.UserId,
            Here = v73,
            Title = v72.Name,
            Subtitle = if v73 then "● In this server"
                elseif v72.Status == "Online" then "● Online elsewhere"
                elseif v72.Status == "Offline" then "● Offline"
                else "● Unknown",
            Label = ("%* %* %*"):format(v72.Name, v72.UserId, v72.Status),
            Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=420&h=420"):format(v72.UserId)
        })
    end

    if #t36 == 0 then
        v11:Notify("Add someone to your guest list first.", false)
    else
        v11:Pick({
            Title = "Choose a guest",
            Placeholder = "Search name, username or user ID...",
            Options = t36,
            OnPick = function(p88) -- OnPick | line: 754
                -- upvalues: p87 (copy), v5 (ref), send (copy)
                task.spawn(function() -- line: 755
                    -- upvalues: p88 (copy), p87 (copy), v5 (ref), send (copy)
                    if p88.Here then
                        send("sendps", {
                            target = p88.Value,
                            server = p87
                        })
                    else
                        local v74 = send("invitePlayers", {
                            action = "guests",
                            server = p87,
                            targets = { (tostring(p88.Value)) }
                        })

                        if v74 ~= nil and v74.Ok == true and v74.Data and v74.Data.Native then
                            v5.Native(v74.Data.Native)
                        end
                    end
                end)

                return false
            end
        })
    end
end

local function toggle(p89, p90) -- line: 775
    -- upvalues: run (copy)
    local v76 = p89.Group:Toggle({
        Title = p90 or "Enabled",
        Callback = function(p91) -- Callback | line: 778
            -- upvalues: p89 (copy), run (copy)
            local v75 = run(p89, {
                enabled = p91
            })

            return v75 ~= nil and v75.Ok == true
        end
    })

    p89.Switch = v76

    return v76
end

local function action(p92, p93) -- line: 786
    local v77 = p92.Group:Button({
        Title = p92.Definition.Action or "Apply",
        Callback = p93
    })

    p92.Run = v77

    return v77
end

local t41 = {
    spawnEgg = function(p94) -- line: 794
        p94.Elements.randomSize = p94.Group:Toggle({
            Title = "Random size",
            Callback = function(p95) -- Callback | line: 797
                -- upvalues: p94 (copy)
                p94.Elements.size.Skip = p95
                p94.Elements.size:SetLocked(p95)

                return true
            end
        })
    end
}
local t43 = {
    freecam = function(p96) -- line: 807
        -- upvalues: v9 (ref), send (copy), isActive (copy), run (copy)
        local Group = p96.Group

        Group:Paragraph("Keyboard: W A S D · Q / E  ·  Mouse: hold right button to look  ·  Touch: on-screen controls  ·  Controller: sticks and triggers")
        p96.Switch = Group:Toggle({
            Title = "Enabled",
            Callback = function(p97) -- Callback | line: 812
                -- upvalues: p96 (copy), v9 (ref), run (copy)
                local v78 = run(p96, {
                    enabled = p97
                })
                local v79 = v78 ~= nil and v78.Ok == true

                if v79 and p97 then
                    v9(false)
                end

                return v79
            end
        })

        for _, v80 in {
                { "hideOtherUI", "Hide other UI during freecam" },
                { "hideControls", "Hide freecam controls" }
            } do
            local v81 = v80[1]

            p96.Elements[v81] = Group:Toggle({
                Title = v80[2],
                Callback = function(p98) -- Callback | line: 824
                    -- upvalues: p96 (copy), v81 (copy), send (copy), isActive (copy)
                    if not isActive(p96) then
                        return true
                    end

                    local t46 = {
                        enabled = true,
                        settingsOnly = true,
                        hideOtherUI = p96.Elements.hideOtherUI.Value == true,
                        hideControls = p96.Elements.hideControls.Value == true
                    }

                    t46[v81] = p98

                    local v82 = send("freecam", t46)

                    return v82 ~= nil and v82.Ok == true
                end
            })
        end
    end,
    disguisePlayer = function(p99) -- line: 840
        -- upvalues: LocalPlayer (copy), v7 (ref), ready (copy), run (copy)
        p99.Switch = p99.Group:Toggle({
            Title = "Enabled",
            Callback = function(p100) -- Callback | line: 843
                -- upvalues: p99 (copy), LocalPlayer (copy), v7 (ref), ready (copy), run (copy)
                if p100 then
                    if ready(p99) then
                        local Open = v7.Open
                        local target = p99.Elements.target

                        Open(if target and target.Instance.Visible then target.Value else LocalPlayer.UserId)
                    end

                    return false
                end

                local v83 = run(p99, {
                    enabled = false
                })

                return v83 ~= nil and v83.Ok == true
            end
        })
    end,
    followPlayer = function(p101) -- line: 854
        -- upvalues: v6 (ref), ready (copy)
        local function v84() -- line: 855
            -- upvalues: p101 (copy), v6 (ref), ready (copy)
            if ready(p101) then
                v6.Open()
            end
        end

        p101.Run = p101.Group:Button({
            Title = p101.Definition.Action or "Apply",
            Callback = v84
        })
    end,
    invitePlayers = function(p102) -- line: 861
        -- upvalues: v5 (ref), ready (copy)
        local function v85() -- line: 862
            -- upvalues: p102 (copy), v5 (ref), ready (copy)
            if not ready(p102) then
                return
            end

            v5.Open((tostring(p102.Elements.server.Value)))
        end

        p102.Run = p102.Group:Button({
            Title = p102.Definition.Action or "Apply",
            Callback = v85
        })
    end,
    manageWhitelist = function(p103) -- line: 868
        -- upvalues: v8 (ref), ready (copy)
        local function v86() -- line: 869
            -- upvalues: p103 (copy), v8 (ref), ready (copy)
            if not ready(p103) then
                return
            end

            v8.Open((tostring(p103.Elements.server.Value)))
        end

        p103.Run = p103.Group:Button({
            Title = p103.Definition.Action or "Apply",
            Callback = v86
        })
    end,
    listps = function(p104) -- line: 875
        -- upvalues: v1 (ref), v8 (ref), run (copy)
        local Group = p104.Group

        p104.Signature = function() -- line: 877
            -- upvalues: v1 (ref)
            local t48 = {}

            for _, v87 in v1.Servers do
                table.insert(t48, (("%*|%*|%*"):format(v87.Name, v87.Status, #v87.Whitelist)))
            end

            return table.concat(t48, ",")
        end

        p104.Render = function() -- line: 884
            -- upvalues: p104 (copy), Group (copy), v1 (ref), v8 (ref), run (copy)
            Group:Clear()

            if #v1.Servers == 0 then
                Group:Paragraph("No creator servers are available to you yet.")
            end

            for _, v89 in v1.Servers do
                local Id = v89.Id

                if not Id then
                    Id = tostring(v89.OwnerUserId)
                end

                Group:Button({
                    Style = "Secondary",
                    Title = ("%* · %* · %* guests"):format(v89.Name, v89.Status or "Checking…", #v89.Whitelist),
                    Callback = function() -- Callback | line: 894
                        -- upvalues: Id (ref), v8 (ref)
                        v8.Open(Id)
                    end
                })
            end

            Group:Button({
                Title = "Refresh",
                Callback = function() -- Callback | line: 901
                    -- upvalues: p104 (copy), run (copy)
                    run(p104)
                end
            })
        end
    end,
    myServer = function(p105) -- line: 907
        -- upvalues: LocalPlayer (copy), v1 (ref), v5 (ref), v8 (ref), v11 (copy), send (copy), ready (copy), openGuestPicker (copy)
        local Group = p105.Group

        p105.Signature = function() -- line: 910
            -- upvalues: LocalPlayer (copy), v1 (ref)
            local v90 = false
            local v91

            for _, v92 in v1.Servers do
                if v92.OwnerUserId == LocalPlayer.UserId then
                    v91 = v92
                    v90 = true
                    break
                end
            end

            if not v90 then
                v91 = nil
            end

            if not v91 then
                return ""
            end

            return (("%*|%*|%*|%*"):format(v91.Status, tostring(v91.Enabled), tostring(v91.Current), #v91.Whitelist))
        end

        p105.Render = function() -- line: 916
            -- upvalues: p105 (copy), Group (copy), LocalPlayer (copy), v1 (ref), v5 (ref), v8 (ref), v11 (copy), send (copy), ready (copy), openGuestPicker (copy)
            Group:Clear()

            local v94 = false
            local v95

            for _, v96 in v1.Servers do
                if v96.OwnerUserId == LocalPlayer.UserId then
                    v95 = v96
                    v94 = true
                    break
                end
            end

            if not v94 then
                v95 = nil
            end

            Group:SetDescription(if not v95 then "Your creator access is not set up yet. Ask an admin to add you."
                elseif v95.Current then ("You are in %*. Every creator tool is unlocked here."):format(v95.Name)
                elseif v95.Enabled then ("%* is open. Join it to unlock every creator tool."):format(v95.Name)
                else ("%* is closed. Start it to open your private server."):format(v95.Name))

            if not v95 then
                return
            end

            Group:Button({
                Title = if v95.Current then "You are in your server" elseif v95.Enabled then "Join my server" else "Start & join my server",
                Callback = function() -- Callback | line: 932
                    -- upvalues: v95 (ref), p105 (copy), v11 (copy), send (copy), ready (copy)
                    if v95.Current then
                        v11:Notify("You are already in your server. Manage it below.", false)
                    elseif ready(p105) then
                        send("myServer", {
                            action = "start"
                        })
                    end
                end
            })
            Group:Button({
                Style = "Secondary",
                Title = ("Guests · %* %*"):format(#v95.Whitelist, #v95.Whitelist == 1 and "guest" or "guests"),
                Callback = function() -- Callback | line: 943
                    -- upvalues: v95 (ref), v8 (ref)
                    v8.Open(v95.Id)
                end
            })
            Group:Button({
                Style = "Secondary",
                Title = v95.Enabled and "Invite a player" or "Invite · Start your server first",
                Callback = function() -- Callback | line: 951
                    -- upvalues: v95 (ref), v5 (ref)
                    v5.Open(v95.Id)
                end
            }):SetLocked(not v95.Enabled)
            Group:Button({
                Style = "Secondary",
                Title = v95.Enabled and "Send a guest" or "Send · Start your server first",
                Callback = function() -- Callback | line: 958
                    -- upvalues: v95 (ref), openGuestPicker (copy)
                    openGuestPicker(v95.Id)
                end
            }):SetLocked(not v95.Enabled)

            if v95.Enabled then
                local n3 = 0
                local v98

                v98 = Group:Button({
                    Title = "Close server",
                    Style = "Danger",
                    Callback = function() -- Callback | line: 968
                        -- upvalues: n3 (ref), v98 (ref), send (copy)
                        if os.clock() >= n3 then
                            n3 = os.clock() + 5
                            v98:SetTitle("Confirm close")
                        else
                            local v99 = send("myServer", {
                                action = "close"
                            })

                            if v99 == nil or v99.Ok ~= true then
                                n3 = 0
                                v98:SetTitle("Close server")
                            end
                        end
                    end
                })
            end
        end
    end,
    savedProfiles = function(p106) -- line: 984
        -- upvalues: LocalPlayer (copy), v1 (ref), v11 (copy), send (copy), ready (copy)
        local Group = p106.Group

        local function loaded() -- line: 986
            -- upvalues: LocalPlayer (copy)
            return LocalPlayer:GetAttribute("CreatorProfileSlot") or 0
        end

        p106.Signature = function() -- line: 989
            -- upvalues: LocalPlayer (copy), v1 (ref)
            local savedProfiles = v1.Commands.savedProfiles

            return (("%*|%*"):format(LocalPlayer:GetAttribute("CreatorProfileSlot") or 0, (tostring(savedProfiles and savedProfiles.Allowed))))
        end

        p106.Render = function() -- line: 993
            -- upvalues: p106 (copy), Group (copy), LocalPlayer (copy), v1 (ref), v11 (copy), send (copy), ready (copy)
            Group:Clear()

            local savedProfiles = v1.Commands.savedProfiles

            if not (savedProfiles and savedProfiles.Allowed) then
                Group:Paragraph("Join your creator server to switch profiles.")
            end

            for i = 0, 2 do
                local v102 = if i == 0 then "Default" else ("Profile %*"):format(i)
                local v103 = i == (LocalPlayer:GetAttribute("CreatorProfileSlot") or 0)

                Group:Button({
                    Title = if v103 then ("● %* · loaded"):format(v102) else ("Load %*"):format(v102),
                    Style = v103 and "Primary" or "Secondary",
                    Callback = function() -- Callback | line: 1005
                        -- upvalues: i (copy), v103 (copy), v102 (copy), p106 (copy), v11 (copy), send (copy), ready (copy)
                        if v103 then
                            v11:Notify(("%* is already loaded."):format(v102), false)
                        elseif ready(p106) then
                            send("savedProfiles", {
                                action = "load",
                                slot = i
                            })
                        end
                    end
                })

                if i ~= 0 then
                    for _, v105 in {
                            {
                                Action = "copy",
                                Title = ("New %* from my current data"):format(v102),
                                Warning = ("%* will be replaced with a copy of the data you have loaded now."):format(v102)
                            },
                            {
                                Action = "reset",
                                Title = ("New %* as a fresh account"):format(v102),
                                Warning = ("%* will become a brand new account."):format(v102)
                            }
                        } do
                        local n4 = 0
                        local v106 = nil

                        v106 = Group:Button({
                            Style = "Danger",
                            Title = v105.Title,
                            Callback = function() -- Callback | line: 1025
                                -- upvalues: i (copy), n4 (ref), v106 (ref), v105 (copy), p106 (copy), v11 (copy), send (copy), ready (copy)
                                if ready(p106) then
                                    if os.clock() >= n4 then
                                        n4 = os.clock() + 5

                                        local v107 = v106

                                        v107:SetTitle((("Confirm · %*"):format(v105.Title)))
                                        v11:Notify(v105.Warning, false)
                                    else
                                        n4 = 0

                                        local v108 = v106

                                        v108:SetTitle(v105.Title)
                                        send("savedProfiles", {
                                            action = v105.Action,
                                            slot = i
                                        })
                                    end
                                end
                            end
                        })
                    end
                end
            end
        end
    end,
    eggWorld = function(p107) -- line: 1045
        -- upvalues: isActive (copy), run (copy)
        p107.Switch = p107.Group:Toggle({
            Title = "Enabled",
            Callback = function(p108) -- Callback | line: 778
                -- upvalues: p107 (copy), run (copy)
                local v109 = run(p107, {
                    enabled = p108
                })

                return v109 ~= nil and v109.Ok == true
            end
        })
        p107.Group:Button({
            Title = "Reset to normal",
            Style = "Secondary",
            Callback = function() -- Callback | line: 1050
                -- upvalues: p107 (copy), isActive (copy), run (copy)
                p107.Elements.eggSize:Set(1)
                p107.Elements.eggLuck:Set(1)

                if isActive(p107) then
                    run(p107, {
                        enabled = false
                    })
                end
            end
        })
    end
}

local function defaultActions(p109) -- line: 1060
    -- upvalues: v11 (copy), send (copy), payloadOf (copy), ready (copy), run (copy)
    local Definition = p109.Definition

    if Definition.Toggle then
        p109.Switch = p109.Group:Toggle({
            Title = "Enabled",
            Callback = function(p110) -- Callback | line: 778
                -- upvalues: p109 (copy), run (copy)
                local v110 = run(p109, {
                    enabled = p110
                })

                return v110 ~= nil and v110.Ok == true
            end
        })
    else
        local v111 = Definition.Action or "Apply"
        local n5 = 0
        local v112

        v112 = p109.Group:Button({
            Title = v111,
            Style = Definition.Confirm and "Danger" or "Primary",
            Callback = function() -- Callback | line: 1072
                -- upvalues: p109 (copy), Definition (copy), v111 (copy), n5 (ref), v112 (ref), v11 (copy), ready (copy), run (copy)
                if ready(p109) then
                    if not (Definition.Confirm and os.clock() >= n5) then
                        n5 = 0
                        v112:SetTitle(v111)
                        run(p109)
                    else
                        n5 = os.clock() + 5

                        local v113 = v112

                        v113:SetTitle("Confirm · " .. v111)
                        v11:Notify(Definition.Confirm, false)
                        task.delay(5, function() -- line: 1080
                            -- upvalues: v111 (copy), n5 (ref), v112 (ref)
                            if os.clock() >= n5 then
                                v112:SetTitle(v111)
                            end
                        end)
                    end
                end
            end
        })
        p109.Run = v112

        if Definition.Reset then
            p109.Group:Button({
                Style = "Secondary",
                Title = Definition.Reset,
                Callback = function() -- Callback | line: 1097
                    -- upvalues: p109 (copy), send (copy), payloadOf (copy)
                    local v114 = payloadOf(p109)

                    v114.enabled = false
                    v114.reset = true
                    send(p109.Id, v114)
                end
            })
        end
    end
end

for _, v115 in CreatorCommands do
    local v116 = v11.Tabs[v115.Category]
    local v117 = ("CreatorCommands \"%*\" uses unknown category %*"):format(v115.Id, v115.Category)

    assert(v116, v117)

    local t61 = {
        Id = v115.Id,
        Definition = v115,
        Group = v116:Group({
            Title = v115.Title,
            Description = v115.Description,
            Open = v115.Id == "myServer"
        }),
        Elements = {},
        Order = {},
        Checks = {}
    }

    t5[v115.Id] = t61

    for _, v118 in v115.Fields do
        v116 = t19[v118]
        assert(v116, (("CreatorCommands field \"%*\" has no builder in Panel.Fields"):format(v118)))

        local v120 = v116(t61)

        t61.Elements[v118] = v120
        table.insert(t61.Order, v118)
    end

    if t41[v115.Id] then
        t41[v115.Id](t61)
    end

    if not v115.Self and not t61.Elements.target then
        t61.InjectedTarget = true

        local target = t19.target

        assert(target, "CreatorCommands field \"target\" has no builder in Panel.Fields")
        v117 = target(t61)
        t61.Elements.target = v117
        table.insert(t61.Order, "target")
    end

    (t43[v115.Id] or defaultActions)(t61)
end

local function shown(p111) -- line: 1135
    -- upvalues: v1 (ref)
    if v1.Guest then
        return p111.Guest == true
    end

    local v121 = v1.Commands[p111.Id]
    local v122, v123

    if p111.Admin then
        local Admin = v1.Admin

        if Admin then
            if p111.Owner then
                local v124 = v1
                local Owns = v124.Owns

                if Owns then
                    v123 = false
                else
                    v122 = Owns
                    v123 = true
                end
            else
                v123 = false
            end
        else
            v122 = Admin
            v123 = true
        end
    elseif p111.Owner then
        local v125 = v1
        local Owns = v125.Owns

        if Owns then
            v123 = false
        else
            v122 = Owns
            v123 = true
        end
    else
        v123 = false
    end

    if not v123 then
        v122 = not p111.OptIn

        if not v122 then
            v122 = v121 ~= nil and v121.Allowed == true
        end
    end

    return v122
end

local function canTarget(p112) -- line: 1145
    -- upvalues: v1 (ref)
    return v1.Admin or v1.CanTarget or v1.CanGiftEvents and p112.Id == "giveShards"
end

v10 = function() -- line: 1151
    -- upvalues: CreatorCommands (copy), Colors (copy), v1 (ref), t5 (copy), v9 (ref), v11 (copy), refreshLauncher (copy), isActive (copy)
    refreshLauncher(v11.Frame.Visible)

    if not v1.Access then
        v9(false)

        return
    end

    v11.Tabs.Manage:SetVisible(v1.Admin == true)

    for _, v126 in v11.TabList do
        if v126.Name ~= "Manage" then
            v126:SetVisible(not v1.Guest or v126.Name == "Servers")
        end
    end

    v11:SetStatus(if v1.Server then v1.Server .. "  /  CREATOR SERVER" else "PUBLIC SERVER", if v1.Admin then "Admin access · All controls available · Panel grants never save"
        elseif v1.Guest then "Guest access · Join servers you are whitelisted on."
        elseif v1.Reserved then "Creator access · Panel items last for this session only"
        elseif v1.Owns then "Start your server from the Servers tab to unlock every tool."
        else "Join a creator server to start your session.")

    for _, v129 in CreatorCommands do
        local v130 = t5[v129.Id]
        local Group = v130.Group
        local v131 = v1.Commands[v129.Id]
        local v132 = v131 ~= nil and v131.Allowed == true
        local v133 = v1.Active[v129.Id] ~= nil
        local Admin

        if v1.Guest then
            Admin = v129.Guest == true
        else
            local v134 = v1.Commands[v129.Id]

            if v129.Admin then
                Admin = v1.Admin

                if Admin then
                    if v129.Owner then
                        Admin = v1.Owns

                        if Admin then
                            Admin = not v129.OptIn

                            if not Admin then
                                Admin = v134 ~= nil and v134.Allowed == true
                            end
                        end
                    else
                        Admin = not v129.OptIn

                        if not Admin then
                            Admin = v134 ~= nil and v134.Allowed == true
                        end
                    end
                end
            elseif v129.Owner then
                Admin = v1.Owns

                if Admin then
                    Admin = not v129.OptIn

                    if not Admin then
                        Admin = v134 ~= nil and v134.Allowed == true
                    end
                end
            else
                Admin = not v129.OptIn

                if not Admin then
                    Admin = v134 ~= nil and v134.Allowed == true
                end
            end
        end

        Group:SetVisible(Admin)
        Group:SetStatus(if v133 then "● Enabled" elseif v132 then "Ready" else "Locked", if v132 or v133 then Group.Tab.Color else Colors.Muted)

        if v130.Render then
            local v137 = v130.Signature()

            if v137 ~= v130.Rendered then
                v130.Rendered = v137
                v130.Render()
            end
        else
            Group:SetLocked(if v132 then nil else v131 and v131.Reason or "Access unavailable.")
        end

        if v130.InjectedTarget then
            v130.Elements.target:SetVisible(v1.Admin or v1.CanTarget or v1.CanGiftEvents and v129.Id == "giveShards")
        end

        if v130.Switch then
            v130.Switch:Set((isActive(v130)))
        end

        local server = v130.Elements.server

        if server and server.Value == nil and #v1.Servers == 1 then
            local Id = v1.Servers[1].Id

            if not Id then
                Id = tostring(v1.Servers[1].OwnerUserId)
            end

            server:Set(Id, v1.Servers[1].Name)
        end

        local currency = v130.Elements.currency

        if currency then
            local Value = currency.Value
            local v138 = false
            local Label

            for _, v139 in v1.Balances or {} do
                if v139.Value == Value then
                    Label = v139.Label
                    v138 = true
                    break
                end
            end

            if not v138 then
                Label = nil
            end

            if not Label then
                local v140 = (v1.Balances or {})[1]
                local v141 = v140

                if v140 then
                    v141 = v140.Value
                    v140 = v140.Label
                end

                currency:Set(v141, v140)
            end
        end
    end
end

local InputBegan = Parent:WaitForChild("Pages")
local t62 = {
    Whitelist = InputBegan.Whitelist,
    Invite = InputBegan.Invite,
    Follow = InputBegan.Follow,
    Disguise = InputBegan.Disguise
}

for _, v142 in t62 do
    v11:AddPage(v142)
end

local function backToPanel() -- line: 1220
    -- upvalues: GuiService (copy), UserInputService (copy), MenuNavigation (copy), v11 (copy)
    local Button = v11.Selected.Button

    if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
        GuiService.SelectedObject = Button
    end
end

v5 = require(Parent.Invitations).new(Parent, t62.Invite, send, notice)
v6 = require(Parent.FollowPlayer).new(t62.Follow, send, notice, backToPanel)
v7 = require(Parent.DisguisePlayer).new(t62.Disguise, send, notice, backToPanel)
v8 = require(Parent.GuestList).new(t62.Whitelist, Parent.UIKit, send, notice, function() -- line: 1226
    -- upvalues: v1 (ref)
    return v1
end, function(p113) -- line: 1228
    -- upvalues: v5 (ref)
    v5.Native(p113)
end)

local v143 = require(Parent.CameraEffects).new(Parent, function() -- line: 1231
    -- upvalues: send (copy)
    send("freecam", {
        enabled = false
    })
end)

GUI.OnActivated(Launcher, function() -- line: 1235
    -- upvalues: v9 (ref), v11 (copy)
    v9(not v11.Frame.Visible)
end)
UserInputService.InputBegan:Connect(function(p114, p115) -- line: 1238
    -- upvalues: UserInputService (copy), Preferences (copy), v9 (ref), v11 (copy)
    if not (p115 or UserInputService:GetFocusedTextBox()) and p114.KeyCode == Enum.KeyCode.F3 and (UserInputService.KeyboardEnabled or Preferences.IsOn("CreatorPanel")) then
        v9(not v11.Frame.Visible)
    end
end)
StaffEntryHotkey.Changed:Connect(function() -- line: 1246
    -- upvalues: v11 (copy), refreshLauncher (copy)
    refreshLauncher(v11.Frame.Visible)
end)
LocalPlayer:GetAttributeChangedSignal("CreatorProfileSlot"):Connect(function() -- line: 1249
    -- upvalues: v10 (ref)
    v10()
end)

local KeyboardEnabled = UserInputService.KeyboardEnabled
local v145 = KeyboardEnabled

if not KeyboardEnabled then
    v145 = Preferences.IsOn("CreatorPanel")
end

Preferences.Observe("CreatorPanel", function(p116) -- line: 1253
    -- upvalues: v9 (ref), v11 (copy), refreshLauncher (copy), v145 (ref)
    if p116 == v145 then
        return
    end

    v145 = p116

    if not p116 then
        v9(false)
    end

    refreshLauncher(v11.Frame.Visible)
end)
PlatformController.Changed:Connect(function() -- line: 1263
    -- upvalues: v11 (copy), refreshLauncher (copy)
    refreshLauncher(v11.Frame.Visible)
end)
Parent:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 1266
    -- upvalues: v11 (copy), refreshLauncher (copy)
    refreshLauncher(v11.Frame.Visible)
end)

local t63 = {
    {
        "CreatorPanel",
        v11.Frame,
        v11.Tabs.Camera.Button,
        function() -- line: 1273
            -- upvalues: v9 (ref)
            v9(false)
        end,
        1000
    },
    {
        "CreatorPicker",
        v11.Picker,
        v11.Picker.Back,
        function() -- line: 1276
            -- upvalues: v11 (copy)
            v11:ClosePicker()
        end,
        1010
    },
    {
        "CreatorWhitelist",
        t62.Whitelist,
        t62.Whitelist.Add,
        v8.Back,
        1020
    },
    {
        "CreatorWhitelistConfirmation",
        t62.Whitelist.Confirmation,
        t62.Whitelist.Confirmation.Cancel,
        v8.Cancel,
        1040
    },
    {
        "CreatorInvite",
        t62.Invite,
        t62.Invite.Find,
        v5.Back,
        1030
    },
    {
        "CreatorInviteConfirmation",
        t62.Invite.Confirmation,
        t62.Invite.Confirmation.Cancel,
        v5.CancelWhitelist,
        1050
    },
    {
        "CreatorFollow",
        t62.Follow,
        t62.Follow.Find,
        v6.Back,
        1030
    },
    {
        "CreatorDisguise",
        t62.Disguise,
        t62.Disguise.Find,
        v7.Back,
        1030
    },
    {
        "CreatorInvitePrompt",
        Parent.InvitePrompt,
        Parent.InvitePrompt.Decline,
        v5.Decline,
        1100
    }
}

for _, v146 in t63 do
    MenuNavigation.SetOverride(v146[1], v146[2], v146[3], v146[4], v146[5], true, true)
end

Parent.Destroying:Connect(function() -- line: 1293
    -- upvalues: Parent (copy), Launcher (copy), MenuNavigation (copy), v143 (copy), t63 (copy)
    if Launcher.Parent ~= Parent then
        Launcher:Destroy()
    end

    for _, v147 in t63 do
        MenuNavigation.SetOverride(v147[1], nil)
    end

    v143.Destroy()
end)
Update.OnClientEvent:Connect(function(p117, p118) -- line: 1303
    -- upvalues: v5 (ref), v11 (copy), v143 (copy)
    if p117 == "invite" then
        v5.Receive(p118)
    elseif p117 == "notice" then
        v11:Notify(p118, nil)
    elseif p117 == "freecamSettings" then
        v143.SetFreecamSettings(p118)
    elseif p117 == "effect" then
        v143.Set(p118.Command, p118.Enabled, p118.HideOtherUI, p118.HideControls, p118.UserId)
    end
end)

local Observe = LocalPlayer:GetAttribute("CreatorPanelNotice")

if type(Observe) == "string" then
    v11:Notify(Observe, nil)
end

v10()
task.spawn(function() -- line: 1319
    -- upvalues: Parent (copy), Request (copy), v2 (ref), n1 (ref), n2 (ref), v3 (ref), v11 (copy), applyState (copy)
    while Parent.Parent do
        local v148 = v2
        local v149 = false
        local v150 = false
        local v151 = false
        local v152 = false
        local v153 = false

        if v148 then
        else
            v149 = true
        end

        if v149 then
            if os.clock() >= n2 then
                v150 = true
            else
                v153 = false
            end
        end

        v149 = false

        local v154

        if v150 then
            local Visible = v11.Frame.Visible

            if Visible then
                v154 = Visible
                v151 = true
            else
                v149 = true
            end
        end

        v150 = false

        if v149 then
            v154 = v3
            v151 = true
        end

        v149 = false

        local v155, elapsed, ok, result

        if v151 then
            v3 = false
            v155 = n1
            elapsed = os.clock()

            local v156 = v154

            local function v157() -- line: 1328
                -- upvalues: v156 (copy), Request (copy)
                return Request:InvokeServer("snapshot", {
                    lightweight = not v156
                })
            end

            ok, result = pcall(v157)

            if Parent.Parent then
                v149 = true
            else
                v153 = true
            end
        end

        v151 = false

        local v158

        if v149 then
            if ok then
                v151 = true
            else
                v158 = ok
                v150 = true
            end
        end

        v149 = false

        if v151 then
            if type(result) == "table" then
                v149 = true
            else
                v158 = false
                v150 = true
            end
        end

        v151 = false

        if v149 then
            if type(result.State) == "table" then
                v152 = true
            else
                v151 = true
            end
        end

        v149 = false

        if v151 then
            v158 = false
            v150 = true
        end

        v151 = false

        if v152 then
            v158 = true
            v150 = true
        end

        v152 = false

        if v150 then
            if v158 then
                v152 = true
            else
                v151 = true
            end
        end

        v150 = false

        if v152 then
            if v155 == n1 then
                v150 = true
            else
                v151 = true
            end
        end

        v152 = false

        if v151 then
            if v154 then
                v152 = true
            else
                v149 = true
            end
        end

        v151 = false

        if v152 then
            if v11.Frame.Visible then
                v151 = true
            else
                v149 = true
            end
        end

        v152 = false

        if v151 then
            if v155 == n1 then
                v152 = true
            else
                v149 = true
            end
        end

        v151 = false

        if v152 then
            v3 = true
            v149 = true
        end

        v152 = false

        if v150 then
            v149 = true
            applyState(result.State)
        end

        v150 = false

        if v149 then
            if v158 then
                v151 = true
            else
                v152 = true
            end
        end

        v149 = false

        if v152 then
            if ok then
                v149 = true
            else
                v150 = true
            end
        end

        v152 = false

        if v149 then
            if type(result) == "table" then
                v152 = true
            else
                v150 = true
            end
        end

        v149 = false

        if v152 then
            if result.Message == "Please wait." then
                v151 = true
            else
                v150 = true
            end
        end

        v152 = false

        local v159

        if v150 then
            v159 = 3
            v152 = true
        end

        v150 = false

        if v151 then
            v159 = 1.1
            v152 = true
        end

        v151 = false

        if v152 then
            if v3 then
                v151 = true
            else
                v150 = true
            end
        end

        v152 = false

        local elapsed2

        if v150 then
            elapsed2 = os.clock()

            if v11.Frame.Visible then
                v149 = true
            else
                v152 = true
            end
        end

        v150 = false

        local v160

        if v152 then
            v160 = 30
            v150 = true
        end

        if v149 then
            v160 = 3
            v150 = true
        end

        v149 = false

        local v161

        if v150 then
            v161 = elapsed2 + v160
            v149 = true
        end

        if v151 then
            v161 = math.max(os.clock(), elapsed + v159)
            v149 = true
        end

        if v149 then
            n2 = v161
            v153 = false
        end

        if v153 then
            break
        end

        task.wait(0.25)
    end
end)
