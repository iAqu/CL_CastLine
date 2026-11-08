-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local HalloweenManor = require(ReplicatedStorage.Data.HalloweenManor)
local ManorInterior = require(ReplicatedStorage.Shared.Util.ManorInterior)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Unlock = require(script.Parent.Unlock)
local LocalPlayer = Players.LocalPlayer
local Sounds, Prompt, Messages = ManorInterior.Sounds, ManorInterior.Prompt, ManorInterior.Messages
local GearId = HalloweenManor.GearId
local Inside = HalloweenDimension.PlayerAttributes.Inside
local v1 = Color3.fromRGB(196, 120, 255)
local t1 = nil
local v2 = false
local v3 = false
local n1 = 0
local n2 = (-1e999)
local v4 = false
local v5 = false
local clone, v6
local v7 = false
local v8
local t2 = {}

local function manorState() -- line: 73
    -- upvalues: Save (copy)
    local v9 = Save.Peek()
    local v10 = v9 and v9.HalloweenDimension

    return v10 and v10.Manor
end

local function isUnlocked() -- line: 79
    -- upvalues: Save (copy)
    local v11 = Save.Peek()
    local v12 = v11 and v11.HalloweenDimension
    local v13 = v12 and v12.Manor

    return v13 ~= nil and v13.GateUnlocked == true
end

local function hasKey() -- line: 84
    -- upvalues: Save (copy), GearId (copy)
    local v14 = Save.Peek()
    local v15 = v14 and v14.GearInventory

    return v15 ~= nil and (v15[GearId] or 0) > 0
end

local function lockOf(p1) -- line: 90
    -- upvalues: ManorInterior (copy)
    local v16 = p1:FindFirstChild(ManorInterior.LockName)

    return if v16 ~= nil and v16:IsA("Model") then v16 else nil
end

local function keyTool() -- line: 95
    -- upvalues: LocalPlayer (copy), GearId (copy)
    for _, v17 in {
            LocalPlayer.Character,
            LocalPlayer:FindFirstChildOfClass("Backpack")
        } do
        if v17 ~= nil then
            for _, child in v17:GetChildren() do
                if child:IsA("Tool") and (child:GetAttribute("GearName") == GearId or child.Name == GearId) then
                    return child
                end
            end
        end
    end

    return nil
end

local function captureKey() -- line: 112
    -- upvalues: clone (ref), keyTool (copy)
    local v18 = keyTool()

    if v18 ~= nil then
        local Archivable = v18.Archivable

        v18.Archivable = true

        local clone2 = v18:Clone()

        v18.Archivable = Archivable
        clone = clone2
    else
        clone = nil
    end
end

local function soundAt(p2) -- line: 125
    -- upvalues: ManorInterior (copy)
    local v19 = p2:FindFirstChild(ManorInterior.LockName)

    if v19 == nil or not v19:IsA("Model") then
        v19 = nil
    end

    return (if v19 == nil then p2:GetBoundingBox() else v19:GetBoundingBox()).Position
end

local function toast(p3) -- line: 131
    -- upvalues: Toast (copy), v1 (copy)
    Toast.Show({
        Lane = "Feed",
        Seconds = 3,
        UniqueKey = "ManorDoor",
        Text = p3,
        Color = v1
    })
end

local function shakeLock(p4) -- line: 141
    -- upvalues: RunService (copy), v5 (ref)
    if v5 then
        return
    end

    v5 = true

    local Pivot = p4:GetPivot()
    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 149
        -- upvalues: p4 (copy), Pivot (copy), elapsed (copy), connection (ref), v5 (ref)
        local v20 = (os.clock() - elapsed) / 0.35

        if v20 >= 1 or p4.Parent == nil then
            connection:Disconnect()

            if p4.Parent ~= nil then
                p4:PivotTo(Pivot)
            end

            v5 = false
        else
            local v22 = math.sin(v20 * 3.141592653589793 * 5) * 0.06981317007977318 * (1 - v20)

            p4:PivotTo(Pivot * CFrame.Angles(0, 0, v22))
        end
    end)
end

local function lockedFeedback(p5) -- line: 164
    -- upvalues: RunService (copy), Audio (copy), ManorInterior (copy), Toast (copy), Sounds (copy), Messages (copy), v1 (copy), v5 (ref)
    local v23 = p5:FindFirstChild(ManorInterior.LockName)

    if v23 == nil or not v23:IsA("Model") then
        v23 = nil
    end

    local Position = (if v23 == nil then p5:GetBoundingBox() else v23:GetBoundingBox()).Position

    Audio.Play(Sounds.ChainRattle, Position, {
        Volume = 0.9,
        MaxDistance = 120,
        PlaybackSpeed = { 0.95, 1.08 }
    })
    Audio.Play(Sounds.PadlockClunk, Position, {
        Volume = 0.8,
        MaxDistance = 120
    })

    local v24 = p5:FindFirstChild(ManorInterior.LockName)

    if v24 == nil or not v24:IsA("Model") then
        v24 = nil
    end

    if v24 ~= nil and not v5 then
        v5 = true

        local Pivot = v24:GetPivot()
        local elapsed = os.clock()
        local connection
        local RenderStepped = RunService.RenderStepped
        local v25 = v24

        connection = RenderStepped:Connect(function() -- line: 149
            -- upvalues: Pivot (copy), elapsed (copy), connection (ref), v25 (copy), v5 (ref)
            local v26 = (os.clock() - elapsed) / 0.35

            if v26 >= 1 or v25.Parent == nil then
                connection:Disconnect()

                if v25.Parent ~= nil then
                    v25:PivotTo(Pivot)
                end

                v5 = false
            else
                local v28 = math.sin(v26 * 3.141592653589793 * 5) * 0.06981317007977318 * (1 - v26)

                v25:PivotTo(Pivot * CFrame.Angles(0, 0, v28))
            end
        end)
    end

    local Locked = Messages.Locked

    Toast.Show({
        Lane = "Feed",
        Seconds = 3,
        UniqueKey = "ManorDoor",
        Text = Locked,
        Color = v1
    })
end

local function refreshPrompt(p6) -- line: 179
    -- upvalues: Save (copy), LocalPlayer (copy), Prompt (copy), GearId (copy), Inside (copy), v2 (ref)
    local v29 = Save.Peek()
    local v30 = v29 and v29.GearInventory
    local v31 = if v30 ~= nil and (v30[GearId] or 0) > 0 then Prompt.Unlock else Prompt.Locked

    if p6.Prompt.ActionText ~= v31 then
        p6.Prompt.ActionText = v31
    end

    local Prompt2 = p6.Prompt
    local v32 = not v2

    if not v32 then
        Prompt2.Enabled = v32

        return
    end

    local v33 = Save.Peek()
    local v34 = v33 and v33.HalloweenDimension
    local v35 = v34 and v34.Manor

    Prompt2.Enabled = not (v35 ~= nil and v35.GateUnlocked == true) and LocalPlayer:GetAttribute(Inside) == true
end

local function applyOpen(p7, p8) -- line: 189
    -- upvalues: ManorInterior (copy), Save (copy), Unlock (copy), LocalPlayer (copy), n1 (ref)
    local v36 = Save.Peek()
    local v37 = v36 and v36.HalloweenDimension
    local v38 = v37 and v37.Manor
    local v39 = v38 ~= nil and v38.GateUnlocked == true

    if v39 == p7.Open or not v39 and os.clock() < n1 then
        return
    end

    p7.Open = v39

    if p8 then
        return
    end

    local SetOpen = Unlock.SetOpen
    local t3 = {
        Key = nil,
        Doors = p7.Doors
    }
    local v40 = p7.Doors:FindFirstChild(ManorInterior.LockName)

    t3.Lock = if v40 ~= nil and not v40:IsA("Model") then nil else v40
    t3.Character = LocalPlayer.Character
    SetOpen(t3, v39)
end

local function sendRequest(p9) -- line: 206
    -- upvalues: Remotes (copy), Toast (copy), v1 (copy), v2 (ref), n2 (ref), v4 (ref), v6 (ref), lockedFeedback (copy)
    local elapsed = os.clock()

    if v2 or v4 or elapsed - n2 < 1.5 then
        return
    end

    n2 = elapsed
    v4 = true

    local function v41() -- line: 213
        -- upvalues: Remotes (copy)
        return Remotes.ManorInterior.Request:InvokeServer()
    end

    local v42, v43, v44 = pcall(v41)

    v4 = false

    if not v42 or v43 == "Outside" or v43 == "Busy" then
        n2 = os.clock() - 1.5 + 0.3

        return
    end

    if v43 == "Locked" then
        lockedFeedback(p9)
    elseif v43 == "Unlocked" then
        local v45 = v6

        if v45 ~= nil then
            v45(p9)
        end

        if type(v44) == "string" then
            Toast.Show({
                Lane = "Feed",
                Seconds = 3,
                UniqueKey = "ManorDoor",
                Text = v44,
                Color = v1
            })
        end
    elseif type(v44) == "string" and v43 ~= "Enter" then
        Toast.Show({
            Lane = "Feed",
            Seconds = 3,
            UniqueKey = "ManorDoor",
            Text = v44,
            Color = v1
        })
    end
end

local function triggered(p10) -- line: 236
    -- upvalues: Audio (copy), ManorInterior (copy), Save (copy), Sounds (copy), GearId (copy), v2 (ref), v3 (ref), clone (ref), keyTool (copy), lockedFeedback (copy), sendRequest (copy)
    if v2 then
        return
    end

    local v46 = Save.Peek()
    local v47 = v46 and v46.HalloweenDimension
    local v48 = v47 and v47.Manor

    if v48 ~= nil and v48.GateUnlocked == true then
        return
    end

    local Doors = p10.Doors
    local v49 = Save.Peek()
    local v50 = v49 and v49.GearInventory

    if v50 == nil or not ((v50[GearId] or 0) > 0) then
        lockedFeedback(Doors)

        return
    end

    local v51 = keyTool()

    if v51 ~= nil then
        local Archivable = v51.Archivable

        v51.Archivable = true

        local clone2 = v51:Clone()

        v51.Archivable = Archivable
        clone = clone2
    else
        clone = nil
    end

    local Play = Audio.Play
    local PadlockClunk = Sounds.PadlockClunk
    local v52 = Doors:FindFirstChild(ManorInterior.LockName)

    if v52 == nil or not v52:IsA("Model") then
        v52 = nil
    end

    Play(PadlockClunk, (if v52 == nil then Doors:GetBoundingBox() else v52:GetBoundingBox()).Position, {
        Volume = 1,
        MaxDistance = 120
    })
    v3 = true
    task.spawn(function() -- line: 245
        -- upvalues: Doors (copy), v3 (ref), sendRequest (copy)
        sendRequest(Doors)
        v3 = false
    end)
end

local function bind(p11) -- line: 254
    -- upvalues: Workspace (copy), Trove (copy), Prompt (copy), t1 (ref), refreshPrompt (copy), applyOpen (copy), triggered (copy)
    local t4 = t1

    if t4 ~= nil then
        if t4.Doors == p11 then
            return
        end

        t1 = nil
        t4.Trove:Destroy()
    end

    local v53 = Trove.new()
    local BoundingBox, BoundingBox2 = p11:GetBoundingBox()
    local v56 = Vector3.new(-BoundingBox.LookVector.X, 0, -BoundingBox.LookVector.Z)
    local v57 = if v56.Magnitude > 0.01 then v56.Unit else Vector3.new(-0, -0, -1, -0)
    local v60 = BoundingBox.Position + v57 * (BoundingBox2.Z / 2 + 3) - Vector3.new(0, BoundingBox2.Y / 2 - 6, 0)
    local v61 = v53:Add(Instance.new("Part"))

    v61.Name = "ManorDoorPrompt"
    v61.Anchored = true
    v61.CanCollide = false
    v61.CanQuery = false
    v61.CanTouch = false
    v61.Transparency = 1
    v61.Size = Vector3.new(1, 1, 1)
    v61.CFrame = CFrame.new(v60)
    v61.Parent = Workspace

    local v62 = v53:Add(Instance.new("Attachment"))

    v62.Name = "ManorDoorPrompt"
    v62.Parent = v61

    local v63 = v53:Add(Instance.new("ProximityPrompt"))

    v63.Name = "ManorDoorPrompt"
    v63.ObjectText = Prompt.Object
    v63.ActionText = Prompt.Locked
    v63.Style = Enum.ProximityPromptStyle.Custom
    v63.HoldDuration = 0
    v63.RequiresLineOfSight = false
    v63.MaxActivationDistance = 16
    v63.Parent = v62

    local t5 = {
        Open = false,
        Doors = p11,
        Trove = v53,
        Prompt = v63,
        Center = BoundingBox.Position,
        Outward = v57
    }

    t1 = t5
    v53:Connect(v63.Triggered, function() -- line: 301
        -- upvalues: t5 (copy), triggered (copy)
        triggered(t5)
    end)
    v53:Connect(p11.AncestryChanged, function() -- line: 304
        -- upvalues: p11 (copy), v53 (copy), t5 (copy), t1 (ref)
        if not p11:IsDescendantOf(game) and t1 == t5 then
            t1 = nil
            v53:Destroy()
        end
    end)
    v53:Add(function() -- line: 310
        -- upvalues: t5 (copy)
        t5.Open = false
    end)
    applyOpen(t5, false)
    refreshPrompt(t5)
end

local function walkIn(p12) -- line: 317
    -- upvalues: ManorInterior (copy), Player (copy), Save (copy), LocalPlayer (copy), Inside (copy), v2 (ref), v3 (ref), v7 (ref), v8 (ref), sendRequest (copy)
    local v64 = ManorInterior.Doorway()
    local v65 = Player.FindRootPart(LocalPlayer)
    local v66 = false
    local v67 = false
    local v68 = false
    local v69 = false
    local v70 = false

    if v64 ~= nil then
        v66 = true
    else
        v70 = true
    end

    if v66 then
        if v65 ~= nil then
            v67 = true
        else
            v70 = true
        end
    end

    v66 = false

    local Position, v71, v72

    if v67 then
        Position = v65.Position
        v71 = (Position - p12.Center):Dot(p12.Outward)

        local v73 = not v2

        if v73 then
            v66 = true
        else
            v72 = v73
            v70 = false
        end
    end

    v67 = false

    if v66 then
        local v74 = not v3

        if v74 then
            v67 = true
        else
            v72 = v74
            v70 = false
        end
    end

    v66 = false

    if v67 then
        local Open = p12.Open

        if Open then
            v66 = true
        else
            v72 = Open
            v70 = false
        end
    end

    v67 = false

    local v75, v76

    if v66 then
        v75 = Save.Peek()

        if v75 then
            v67 = true
        else
            v76 = v75
            v68 = true
        end
    end

    v66 = false

    if v67 then
        v76 = v75.HalloweenDimension
        v68 = true
    end

    v67 = false

    local v77

    if v68 then
        if v76 then
            v67 = true
        else
            v77 = v76
            v66 = true
        end
    end

    v68 = false

    if v67 then
        v77 = v76.Manor
        v66 = true
    end

    v67 = false

    local v78

    if v66 then
        if v77 ~= nil then
            v67 = true
        else
            v78 = false
            v68 = true
        end
    end

    v66 = false

    if v67 then
        if v77.GateUnlocked == true then
            v69 = true
        else
            v66 = true
        end
    end

    if v66 then
        v78 = false
        v68 = true
    end

    v66 = false

    if v69 then
        v78 = true
        v68 = true
    end

    v69 = false

    if v68 then
        if v78 then
            v69 = true
        else
            v72 = v78
            v70 = false
        end
    end

    v68 = false

    if v69 then
        if LocalPlayer:GetAttribute(Inside) == true then
            v66 = true
        else
            v68 = true
        end
    end

    if v68 then
        v72 = false
        v70 = false
    end

    if v66 then
        v72 = true
        v70 = false
    end

    if not v70 then
        if ManorInterior.Within(v64, Position, 0) then
            if v72 then
                if not v7 then
                    local v80 = math.max(v8 or v71, v71)

                    v8 = v80

                    if v80 - v71 < 3 then
                        return
                    end

                    v7 = true
                    v8 = nil
                end

                task.spawn(sendRequest, p12.Doors)
            else
                v7 = false
                v8 = v71
            end
        else
            v7 = v72
            v8 = nil
        end
    end
end

local function step() -- line: 352
    -- upvalues: ManorInterior (copy), t1 (ref), v2 (ref), v3 (ref), refreshPrompt (copy), applyOpen (copy), bind (copy), walkIn (copy)
    local v81 = ManorInterior.Doors()

    if v81 ~= nil then
        if t1 == nil or t1.Doors ~= v81 then
            bind(v81)
        end

        local t7 = t1

        if t7 ~= nil then
            applyOpen(t7, v2 or v3)
            refreshPrompt(t7)
            walkIn(t7)
        end
    else
        local t6 = t1

        if t6 ~= nil then
            t1 = nil
            t6.Trove:Destroy()
        end
    end
end

function t2.SetBusy(p13) -- line: 378
    -- upvalues: t1 (ref), v2 (ref), refreshPrompt (copy)
    v2 = p13

    local t8 = t1

    if t8 ~= nil then
        refreshPrompt(t8)
    end
end

function t2.TakeKey() -- line: 386
    -- upvalues: clone (ref)
    local clone2 = clone

    clone = nil

    return clone2
end

function t2.MarkOpen() -- line: 392
    -- upvalues: t1 (ref), n1 (ref)
    n1 = os.clock() + 15

    local t9 = t1

    if t9 ~= nil then
        t9.Open = true
    end
end

function t2.Start(p14, p15) -- line: 400
    -- upvalues: RunService (copy), t1 (ref), v6 (ref), step (copy)
    v6 = p15

    local n3 = 0.05

    p14:Connect(RunService.Heartbeat, function(p16) -- line: 403
        -- upvalues: n3 (ref), step (copy)
        n3 += p16

        if not (n3 < 0.05) then
            n3 = 0
            step()
        end
    end)
    p14:Add(function() -- line: 411
        -- upvalues: t1 (ref), v6 (ref)
        local t10 = t1

        t1 = nil
        v6 = nil

        if t10 ~= nil then
            t10.Trove:Destroy()
        end
    end)
end

return table.freeze(t2)
