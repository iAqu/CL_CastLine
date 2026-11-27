-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Controls = require(script.Parent.Parent.Character.Controls)
local Poses = require(script.Parent.Parent.Character.Poses)
local Effects = require(script.Parent.Parent.Fishing.Effects)
local LocalPlayer = Players.LocalPlayer
local t1 = {
    TITLE = "PromoTitle"
}
local v1 = false
local v2

function t1.character() -- line: 22
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v3, v4

    if Character then
        v3 = Character:FindFirstChildOfClass("Humanoid")
        v4 = Character:FindFirstChild("HumanoidRootPart")
    else
        v4 = Character
        v3 = Character
    end

    if not v3 or not v4 then
        return nil, nil, nil
    end

    return Character, v3, v4
end

function t1.top(p1) -- line: 32
    return p1.Position + Vector3.new(0, p1.Size.Y / 2, 0)
end

function t1.standAt(p2, p3) -- line: 37
    -- upvalues: Controls (copy), t1 (copy)
    local v6, v7, v8 = t1.character()

    if not v6 then
        return nil
    end

    local v11 = CFrame.lookAt(p2, p2 + Vector3.new(p3.X, 0, p3.Z)) + Vector3.new(0, v7.HipHeight + v8.Size.Y / 2, 0)

    v8.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    v6:PivotTo(v11)
    Controls.lock("Promo", v11)

    return v11
end

function t1.myPlot() -- line: 49
    -- upvalues: LocalPlayer (copy)
    for _, child in workspace.Map.World1.Plots:GetChildren() do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return child
        end
    end

    return nil
end

function t1.setBoardIncome(p4) -- line: 59
    -- upvalues: Format (copy), t1 (copy)
    local v12 = t1.myPlot()
    local OwnerBoard = v12 and v12:FindFirstChild("OwnerBoard")
    local v13 = OwnerBoard and OwnerBoard:FindFirstChild("Income", true)

    if v13 then
        v13.Text = Format.money(p4) .. "/s"
    end
end

function t1.home() -- line: 68
    -- upvalues: t1 (copy)
    local v14 = t1.myPlot()
    local Spawn = v14 and v14:FindFirstChild("Spawn")

    if Spawn then
        t1.standAt(t1.top(Spawn), Spawn.CFrame.LookVector)
    end
end

local function rodTip() -- line: 76
    -- upvalues: LocalPlayer (copy)
    local v15 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RodModel")

    return v15 and v15:FindFirstChild("RodTip", true)
end

function t1.lineStart() -- line: 82
    -- upvalues: LocalPlayer (copy), t1 (copy)
    local v16 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RodModel")
    local v17 = v16 and v16:FindFirstChild("RodTip", true)

    if v17 then
        return v17
    end

    local _, _, v18 = t1.character()
    local v19 = v18:FindFirstChild("PromoTip") or Instance.new("Attachment")

    v19.Name = "PromoTip"
    v19.Position = Vector3.new(1, 2, -2)
    v19.Parent = v18

    return v19
end

function t1.toDock() -- line: 96
    -- upvalues: Remotes (copy), LocalPlayer (copy), t1 (copy), v1 (ref), v2 (ref)
    if v1 and v2 then
        return v2
    end

    local FishingDock = workspace.Map.World1.FishingDock
    local CastZone = FishingDock.CastZone
    local v21 = CastZone.CFrame:PointToWorldSpace((Vector3.new(0, 0, -CastZone.Size.Z / 2 + 2.5)))

    v2 = t1.standAt(Vector3.new(v21.X, t1.top(FishingDock.Deck).Y, v21.Z), (Vector3.new(0, 0, -1)))
    task.wait(0.3)

    for _ = 1, 3 do
        local InvokeServer = Remotes.FishMode.InvokeServer
        local FishMode = Remotes.FishMode
        local ok, result = pcall(InvokeServer, FishMode, true)

        if ok and result then
            v1 = true
            break
        end

        task.wait(0.3)
    end

    local n1 = 0

    while true do
        local v22 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RodModel")

        if not (v22 and v22:FindFirstChild("RodTip", true)) and n1 < 3 then
            n1 += task.wait()
            continue
        end

        break
    end

    return v2
end

function t1.leaveDock() -- line: 120
    -- upvalues: Remotes (copy), Poses (copy), v1 (ref)
    Poses.clear()

    if not v1 then
        return
    end

    v1 = false

    local InvokeServer = Remotes.FishMode.InvokeServer
    local FishMode = Remotes.FishMode

    pcall(InvokeServer, FishMode, false)
end

function t1.fadeIn(p5) -- line: 128
    -- upvalues: Effects (copy)
    task.spawn(Effects.fade, p5, false, 0.5)
end

function t1.title(p6, p7) -- line: 132
    -- upvalues: Kit (copy), t1 (copy)
    local v23 = p6:FindFirstChild(t1.TITLE)

    if v23 then
        v23:Destroy()
    end

    p7.Name = t1.TITLE
    p7.ZIndex = 20

    return Kit.text(p6, p7.Text or "", p7)
end

return t1
