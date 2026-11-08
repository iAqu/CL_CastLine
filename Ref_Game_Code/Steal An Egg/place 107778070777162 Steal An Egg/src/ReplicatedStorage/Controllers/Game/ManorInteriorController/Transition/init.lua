-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Doors = require(script.Parent.Unlock.Doors)
local Iris = require(script.Iris)
local Sfx = require(script.Parent.Unlock.Sfx)
local Shot = require(script.Parent.Unlock.Shot)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local t1 = nil
local t2 = {}

local function begin() -- line: 60
    -- upvalues: Shot (copy), Trove (copy), LocalPlayer (copy), t1 (ref)
    local t3 = t1

    if t3 ~= nil and not t3.Done then
        t3.Done = true

        if t1 == t3 then
            t1 = nil
        end

        t3.Trove:Destroy()
    end

    Shot.Drop()

    local v1 = Trove.new()
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local t4 = {
        Done = false,
        Broken = false,
        Trove = v1
    }

    if Humanoid ~= nil then
        v1:Connect(Humanoid.Died, function() -- line: 75
            -- upvalues: t4 (copy)
            t4.Broken = true
        end)
    end

    v1:Connect(LocalPlayer.CharacterAdded, function() -- line: 79
        -- upvalues: t4 (copy)
        t4.Broken = true
    end)
    t1 = t4

    return t4
end

local function waitClosed(p1) -- line: 86
    -- upvalues: Iris (copy)
    local elapsed = os.clock()

    while not Iris.Closed() and not p1.Done do
        if p1.Broken or os.clock() - elapsed > 6 then
            break
        end

        task.wait()
    end

    return not p1.Done and not p1.Broken
end

local function hold(p2) -- line: 97
    local n1 = 0

    while n1 < p2 do
        n1 += task.wait()
    end
end

local function settle(p3) -- line: 104
    -- upvalues: Shot (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Face, v2

    if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
        Face = Shot.Face
        v2 = p3 or HumanoidRootPart.CFrame.LookVector
        Face(HumanoidRootPart, v2)
    end
end

local function doorPoint(p4) -- line: 112
    -- upvalues: Doors (copy)
    local Doors2 = p4.Doors
    local v3 = if Doors2 == nil then nil else Doors.Rig(Doors2, nil)

    if v3 == nil then
        return p4.DoorOutside.Position
    end

    return (Doors.Point(v3, 0, v3.Height * 0.2, 0))
end

local function closeSounds(p5, p6) -- line: 120
    -- upvalues: Doors (copy), Sfx (copy)
    if p6 == "Exit" then
        Sfx.At("Creak", p5.DoorInside.Position, 0.55, 1.1)
        Sfx.Play("Draft", 0.25, 1.2)
    else
        local At = Sfx.At
        local Doors2 = p5.Doors
        local v4 = if Doors2 == nil then nil else Doors.Rig(Doors2, nil)

        At("Creak", if v4 == nil then p5.DoorOutside.Position else Doors.Point(v4, 0, v4.Height * 0.2, 0), 0.5, 1.05)
        Sfx.Play("Draft", 0.3, 0.9)
    end
end

local function shutSounds() -- line: 130
    -- upvalues: Sfx (copy)
    Sfx.Play("DoorSlam", 0.45, 0.72)
    Sfx.Play("Boom", 0.16, 0.8)
end

local function travel(p7, p8) -- line: 135
    -- upvalues: Iris (copy), Sfx (copy), Shot (copy), LocalPlayer (copy), t1 (ref), begin (copy), waitClosed (copy), closeSounds (copy)
    local v5 = begin()

    closeSounds(p7, p8)
    Iris.Close(0.42)
    task.delay(20, function() -- line: 139
        -- upvalues: v5 (copy), Iris (copy), t1 (ref)
        if t1 ~= v5 then
            return
        end

        if not v5.Done then
            v5.Done = true

            if t1 == v5 then
                t1 = nil
            end

            v5.Trove:Destroy()
        end

        Iris.Open(0.45)
    end)

    if waitClosed(v5) then
        Sfx.Play("DoorSlam", 0.45, 0.72)
        Sfx.Play("Boom", 0.16, 0.8)

        local Arrive = p7.Arrive
        local ok, result = pcall(Arrive)

        if ok then
            ok = result == true and not v5.Broken
        end

        if ok then
            local Destination = p7.Destination

            if p8 == "Enter" then
                local LookVector = p7.Spawn.LookVector
                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                    Shot.Face(HumanoidRootPart, LookVector or HumanoidRootPart.CFrame.LookVector)
                end
            elseif Destination ~= nil then
                local LookVector = Destination.LookVector
                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                    Shot.Face(HumanoidRootPart, LookVector or HumanoidRootPart.CFrame.LookVector)
                end
            else
                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                    Shot.Face(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector)
                end
            end

            local n2 = 0

            while n2 < 0.12 do
                n2 += task.wait()
            end

            Sfx.Play("Shimmer", 0.35, p8 == "Enter" and 0.8 or 1)
        end

        if not v5.Done then
            v5.Done = true

            if t1 == v5 then
                t1 = nil
            end

            v5.Trove:Destroy()
        end

        Iris.Open(0.45)

        return ok
    end

    if not v5.Done then
        v5.Done = true

        if t1 == v5 then
            t1 = nil
        end

        v5.Trove:Destroy()
    end

    Iris.Open(0.45)

    return false
end

function t2.Enter(p9) -- line: 174
    -- upvalues: Sfx (copy), travel (copy)
    Sfx.Warm()

    return (travel(p9, "Enter"))
end

function t2.Exit(p10) -- line: 179
    -- upvalues: travel (copy)
    return (travel(p10, "Exit"))
end

function t2.Abort() -- line: 183
    -- upvalues: Iris (copy), Shot (copy), t1 (ref)
    local t5 = t1

    if t5 ~= nil and not t5.Done then
        t5.Done = true

        if t1 == t5 then
            t1 = nil
        end

        t5.Trove:Destroy()
    end

    Shot.Drop()
    Iris.Open(0.45)
end

function t2.Cover() -- line: 192
    -- upvalues: Iris (copy)
    Iris.Shut()
end

function t2.Reveal() -- line: 196
    -- upvalues: Iris (copy)
    Iris.Open(0.45)
end

return table.freeze(t2)
