-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {}
local t3, v1
local v2 = false
local n1 = 0
local t4 = {}

local function remember(p1) -- line: 34
    -- upvalues: t4 (copy)
    table.insert(t4, {
        p1,
        os.clock()
    })

    if #t4 > 4 then
        table.remove(t4, 1)
    end
end

local function syncTouch() -- line: 42
    -- upvalues: GuiService (copy), UserInputService (copy), t2 (copy), v2 (ref), n1 (ref)
    if UserInputService.TouchEnabled then
        local v3 = n1 > 0

        for _, v4 in t2 do
            v3 = v3 or not v4.canJump
        end

        if v3 ~= v2 then
            v2 = v3
            GuiService.TouchControlsEnabled = not v3
        end
    end
end

local function humanoid() -- line: 56
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    return if Humanoid and Humanoid.Health > 0 then Humanoid else nil
end

local function defaults(p2) -- line: 62
    -- upvalues: StarterPlayer (copy)
    local v5 = if not (p2 and p2.WalkSpeed > 0) then StarterPlayer.CharacterWalkSpeed else p2.WalkSpeed
    local v6 = if not (p2 and p2.JumpHeight > 0.01) then StarterPlayer.CharacterJumpHeight else p2.JumpHeight

    if not (p2 and p2.JumpPower > 0.01) then
        return v5, v6, StarterPlayer.CharacterJumpPower
    end

    return v5, v6, p2.JumpPower
end

local function apply() -- line: 69
    -- upvalues: GuiService (copy), StarterPlayer (copy), UserInputService (copy), LocalPlayer (copy), t2 (copy), t3 (ref), v2 (ref), n1 (ref)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (Humanoid and Humanoid.Health > 0) then
        return
    end

    if not t3 or t3[1] ~= Humanoid then
        local v7 = if Humanoid.WalkSpeed > 0 then Humanoid.WalkSpeed else StarterPlayer.CharacterWalkSpeed
        local v8 = Humanoid.JumpHeight > 0.01
        local v9 = if not Humanoid or not v8 then StarterPlayer.CharacterJumpHeight else Humanoid.JumpHeight
        local v10 = Humanoid.JumpPower > 0.01

        t3 = {
            Humanoid,
            v7,
            v9,
            if not Humanoid or not v10 then StarterPlayer.CharacterJumpPower else Humanoid.JumpPower
        }
    end

    local v11 = true

    for _, v12 in t2 do
        v11 = v11 and v12.canJump
    end

    local v13 = if v11 then 0.01 else 0

    Humanoid.WalkSpeed = 0
    Humanoid.JumpHeight = v13
    Humanoid.JumpPower = v13
    Humanoid.AutoRotate = false
    Humanoid:Move((Vector3.new(0, 0, 0)))

    if UserInputService.TouchEnabled then
        local v14 = n1 > 0

        for _, v15 in t2 do
            v14 = v14 or not v15.canJump
        end

        if v14 ~= v2 then
            v2 = v14
            GuiService.TouchControlsEnabled = not v14
        end
    end
end

local function restore() -- line: 92
    -- upvalues: GuiService (copy), StarterPlayer (copy), UserInputService (copy), LocalPlayer (copy), t2 (copy), t3 (ref), v2 (ref), n1 (ref)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (Humanoid and Humanoid.Health > 0) then
        Humanoid = nil
    end

    if Humanoid then
        if t3 and t3[1] == Humanoid then
            local v16 = t3[2]
            local v17 = t3[3]
            local v18 = t3[4]

            Humanoid.WalkSpeed = v16
            Humanoid.JumpHeight = v17
            Humanoid.JumpPower = v18
        elseif Humanoid.WalkSpeed <= 0 then
            local CharacterWalkSpeed, CharacterJumpHeight, CharacterJumpPower = StarterPlayer.CharacterWalkSpeed, StarterPlayer.CharacterJumpHeight, StarterPlayer.CharacterJumpPower

            Humanoid.WalkSpeed = CharacterWalkSpeed
            Humanoid.JumpHeight = CharacterJumpHeight
            Humanoid.JumpPower = CharacterJumpPower
        end

        Humanoid.AutoRotate = true
    end

    t3 = nil
    n1 = 3

    if UserInputService.TouchEnabled then
        local v19 = n1 > 0

        for _, v20 in t2 do
            v19 = v19 or not v20.canJump
        end

        if v19 ~= v2 then
            v2 = v19
            GuiService.TouchControlsEnabled = not v19
        end
    end
end

function t1.lock(p3, p4, p5) -- line: 109
    -- upvalues: LocalPlayer (copy), t2 (copy), remember (copy), apply (copy)
    if not t2[p3] then
        remember("+" .. p3)
    end

    t2[p3] = {
        canJump = p5 == true
    }
    apply()

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (Humanoid and Humanoid.Health > 0) then
        Humanoid = nil
    end

    local v21 = Humanoid and Humanoid.RootPart

    if p4 and v21 then
        v21.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        v21.CFrame = p4
    end
end

function t1.unlock(p6) -- line: 124
    -- upvalues: t2 (copy), remember (copy), apply (copy), restore (copy)
    if t2[p6] then
        t2[p6] = nil
        remember("-" .. p6)

        if next(t2) then
            apply()
        else
            restore()
        end
    end
end

function t1.isLocked() -- line: 137
    -- upvalues: t2 (copy)
    return next(t2) ~= nil
end

function t1.describe() -- line: 142
    -- upvalues: t2 (copy)
    local t6 = {}

    for v22 in t2 do
        table.insert(t6, v22)
    end

    table.sort(t6)

    return table.concat(t6, ",")
end

function t1.history() -- line: 152
    -- upvalues: t4 (copy)
    local t7 = {}
    local elapsed = os.clock()

    for i = #t4, 1, -1 do
        table.insert(t7, string.format("%s %.1fs", t4[i][1], elapsed - t4[i][2]))
    end

    return table.concat(t7, ",")
end

function t1.setWatchdogHandler(p7) -- line: 161
    -- upvalues: v1 (ref)
    v1 = p7
end

local function resetCamera(p8) -- line: 165
    local CurrentCamera = workspace.CurrentCamera

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    if p8 then
        CurrentCamera.CameraSubject = p8
    end
end

function t1.init() -- line: 174
    -- upvalues: GuiService (copy), RunService (copy), UserInputService (copy), LocalPlayer (copy), t2 (copy), t3 (ref), v1 (ref), v2 (ref), n1 (ref), remember (copy), restore (copy)
    LocalPlayer.CharacterAdded:Connect(function() -- line: 176
        -- upvalues: GuiService (copy), UserInputService (copy), t2 (copy), t3 (ref), v2 (ref), n1 (ref), remember (copy)
        if next(t2) then
            remember("respawn")
        end

        table.clear(t2)
        t3 = nil
        n1 = 3

        if UserInputService.TouchEnabled then
            local v25 = n1 > 0

            for _, v26 in t2 do
                v25 = v25 or not v26.canJump
            end

            if v25 ~= v2 then
                v2 = v25
                GuiService.TouchControlsEnabled = not v25
            end
        end
    end)

    local n2 = 0
    local n3 = 0

    RunService.Heartbeat:Connect(function(p9) -- line: 186
        -- upvalues: n2 (ref), n3 (ref), GuiService (copy), UserInputService (copy), LocalPlayer (copy), t2 (copy), v1 (ref), v2 (ref), n1 (ref), restore (copy)
        if n1 > 0 then
            n1 -= 1

            local v27

            if n1 == 0 and UserInputService.TouchEnabled then
                v27 = n1 > 0

                for _, v28 in t2 do
                    v27 = v27 or not v28.canJump
                end

                if v27 ~= v2 then
                    v2 = v27
                    GuiService.TouchControlsEnabled = not v27
                end
            end
        end

        n2 += p9

        if not (n2 < 1) then
            n2 = 0

            if next(t2) then
                n3 = 0
            else
                if v2 and n1 == 0 and UserInputService.TouchEnabled then
                    local v29 = n1 > 0

                    for _, v30 in t2 do
                        v29 = v29 or not v30.canJump
                    end

                    if v29 ~= v2 then
                        v2 = v29
                        GuiService.TouchControlsEnabled = not v29
                    end
                end

                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                if not (Humanoid and Humanoid.Health > 0) then
                    Humanoid = nil
                end

                if Humanoid then
                    local t8 = {}
                    local v31 = Humanoid.WalkSpeed <= 0 or not Humanoid.AutoRotate

                    if v31 then
                        table.insert(t8, (("move(ws=%*,ar=%*)"):format(Humanoid.WalkSpeed, Humanoid.AutoRotate)))
                    end

                    local CurrentCamera = workspace.CurrentCamera
                    local v33

                    if CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                        n3 += 1

                        if n3 >= 2 then
                            n3 = 0
                            v33 = true
                            table.insert(t8, "camera(Scriptable)")
                        else
                            v33 = false
                        end
                    else
                        n3 = 0

                        local v34 = false

                        if CurrentCamera.CameraSubject == Humanoid then
                            v33 = false
                            v34 = true
                        elseif CurrentCamera.CameraSubject ~= nil then
                            if CurrentCamera.CameraSubject:IsDescendantOf(workspace) then
                                v33 = false
                                v34 = true
                            end
                        end

                        if not v34 then
                            v33 = true
                            table.insert(t8, "camera(subject)")
                        end
                    end

                    if #t8 ~= 0 then
                        if v1 then
                            local v35 = v1
                            local concat = table.concat

                            pcall(v35, concat(t8, " "))
                        end

                        if v31 then
                            restore()
                        end

                        if v33 then
                            local CurrentCamera = workspace.CurrentCamera

                            CurrentCamera.CameraType = Enum.CameraType.Custom
                            CurrentCamera.FieldOfView = 70
                            CurrentCamera.CameraSubject = Humanoid
                            n1 = 3

                            if not UserInputService.TouchEnabled then
                                return
                            end

                            local v36 = n1 > 0

                            for _, v37 in t2 do
                                v36 = v36 or not v37.canJump
                            end

                            if v36 ~= v2 then
                                v2 = v36
                                GuiService.TouchControlsEnabled = not v36
                            end
                        end
                    end
                end
            end
        end
    end)
end

return t1
