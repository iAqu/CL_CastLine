-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local v1 = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD") or FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationDGA")
local UserControlModuleDisabledUpdate = FlagUtil.getUserFlag("UserControlModuleDisabledUpdate")
local StarterPlayer = game:GetService("StarterPlayer")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Workspace = game:GetService("Workspace")
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
local UserAbilitiesUserInterfaceB = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceB")
local v2 = if UserAbilitiesUserInterfaceB then "ControlState" else "PlayerControlState"
local t1 = {}

t1.__index = t1

function t1._calculatePlayerInputValues(p1) -- line: 16
    local Character = p1.Character

    if Character ~= nil then
        local Humanoid = Character:FindFirstChild("Humanoid")

        if Humanoid ~= nil then
            local InputContexts = p1:FindFirstChild("InputContexts")

            if InputContexts ~= nil then
                local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

                if CharacterContext ~= nil then
                    local MoveAction = CharacterContext.MoveAction
                    local RotationAction = CharacterContext:FindFirstChild("RotationAction")
                    local v3 = RotationAction ~= nil and RotationAction:GetState()

                    local function isValidInput2D(p2) -- line: 37
                        return not (p2.X ~= p2.X or p2.Y ~= p2.Y or p2.X == 1e999 or p2.Y == 1e999)
                    end

                    local function isValidInput3D(p3) -- line: 46
                        return not (p3.X ~= p3.X
                            or p3.Y ~= p3.Y
                            or p3.Z ~= p3.Z
                            or p3.X == 1e999
                            or p3.Y == 1e999
                            or p3.Z == 1e999)
                    end

                    local v4 = if MoveAction == nil then Vector2.new(0, 0) else MoveAction:GetState()
                    local LookVector = p1:GetCameraState().CFrame.LookVector

                    if v4.X == v4.X and v4.Y == v4.Y and v4.X ~= 1e999 and v4.Y ~= 1e999 and LookVector.X == LookVector.X and LookVector.Y == LookVector.Y and LookVector.Z == LookVector.Z and LookVector.X ~= 1e999 and LookVector.Y ~= 1e999 and LookVector.Z ~= 1e999 and LookVector.Magnitude > 0 then
                        local v5 = if not Humanoid or Humanoid:GetState() == Enum.HumanoidStateType.Swimming then LookVector else Vector3.new(LookVector.X, 0, LookVector.Z).Unit
                        local Unit = v5:Cross((Vector3.new(0, 1, 0))).Unit

                        return v5 * v4.Y + Unit * v4.X, v5, v3
                    end
                end
            end
        end
    end

    return Vector3.new(0, 0, 0), Vector3.new(0, 0, 1), false
end

function t1.CloneInputsIfAbsent(p4) -- line: 77
    -- upvalues: StarterPlayer (copy)
    if p4:FindFirstChild("InputContexts") then
        return
    end

    local clone = StarterPlayer.PlayerModule.InputContexts:Clone()

    clone.CharacterContext.Enabled = true
    clone.CameraContext.Enabled = true
    clone.Parent = p4
end

function t1.FireCustomInputs(p5) -- line: 88
    -- upvalues: UserGameSettings (copy)
    local InputContexts = p5:FindFirstChild("InputContexts")

    if InputContexts then
        local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

        if CharacterContext and InputContexts:FindFirstChild("CameraContext") then
            local RotationAction = CharacterContext:FindFirstChild("RotationAction")
            local RotationScriptableBinding, v6

            if RotationAction then
                RotationScriptableBinding = RotationAction:FindFirstChild("RotationScriptableBinding")

                if RotationScriptableBinding then
                    v6 = UserGameSettings.RotationType == Enum.RotationType.CameraRelative
                    RotationScriptableBinding:Fire(v6)
                end
            end
        end
    end
end

function t1.SendInputToCCLCharacter(p6) -- line: 113
    -- upvalues: AvatarAbilitiesInterface (copy), t1 (copy)
    if not p6 then
        return
    end

    local v7 = AvatarAbilitiesInterface.get(p6)
    local InputContexts = p6:FindFirstChild("InputContexts")

    if InputContexts then
        local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

        if CharacterContext then
            for _, v8 in v7:GetAbilities() do
                local v9 = CharacterContext:FindFirstChild(v8 .. "Action")

                if v9 then
                    v7:SendInput(v8, v9:GetState())
                end
            end

            local v10, v11, v12 = t1._calculatePlayerInputValues(p6)

            v7:SendInput("Move", v10)
            v7:SendInput("CameraLookDirection", v11)
            v7:SendInput("CameraRelativeRotation", v12)
        end
    end
end

function t1.SendInputToHumanoidForServerAuth(p7) -- line: 140
    -- upvalues: t1 (copy)
    local Character = p7.Character

    if Character ~= nil then
        local Humanoid = Character:FindFirstChild("Humanoid")

        if Humanoid ~= nil then
            local InputContexts = p7:FindFirstChild("InputContexts")

            if InputContexts ~= nil then
                local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

                if CharacterContext ~= nil then
                    local JumpAction = CharacterContext.JumpAction
                    local v13, v14, v15 = t1._calculatePlayerInputValues(p7)

                    Humanoid:Move(v13)
                    Humanoid.AutoRotate = not v15

                    if v15 and Humanoid.SeatPart == nil and Humanoid.RootPart ~= nil and not Humanoid.Sit and not Humanoid.RootPart:IsGrounded() then
                        Humanoid.RootPart.CFrame = CFrame.new(Humanoid.RootPart.CFrame.Position, Humanoid.RootPart.CFrame.Position + v14)
                    end

                    if JumpAction ~= nil then
                        Humanoid.Jump = JumpAction:GetState()
                    else
                        Humanoid.Jump = false
                    end
                end
            end
        end
    end
end

function t1.setupPlayerControlState(p8) -- line: 180
    p8:AddVector3Field("Move", Vector3.new(0, 0, 0), 1)
    p8:AddBoolField("Jump", false)
    p8:AddBoolField("RotateToLookDirection", false)
    p8:AddUnitVector3Field("LookDirection", (Vector3.new(0, 0, 1)))
end

function t1.watchForPlayerControlState(p9) -- line: 188
    -- upvalues: t1 (copy), v2 (copy)
    local function watchCharacter(p10) -- line: 189
        -- upvalues: t1 (copy), v2 (copy)
        local function onPCSAdded(p11) -- line: 190
            -- upvalues: t1 (copy), v2 (copy)
            if p11:IsA(v2) then
                t1.setupPlayerControlState(p11)
            end
        end

        local v16 = p10:FindFirstChildOfClass(v2)

        if v16 then
            t1.setupPlayerControlState(v16)
        end

        p10.ChildAdded:Connect(onPCSAdded)
    end

    if p9.Character then
        local Character = p9.Character

        local function onPCSAdded(p12) -- line: 190
            -- upvalues: t1 (copy), v2 (copy)
            if p12:IsA(v2) then
                t1.setupPlayerControlState(p12)
            end
        end

        local v17 = Character:FindFirstChildOfClass(v2)

        if v17 then
            t1.setupPlayerControlState(v17)
        end

        Character.ChildAdded:Connect(onPCSAdded)
    end

    p9.CharacterAdded:Connect(watchCharacter)
end

function t1.createPlayerControlState(p13) -- line: 208
    -- upvalues: UserAbilitiesUserInterfaceB (copy), t1 (copy), v2 (copy)
    local function createForCharacter(p14) -- line: 209
        -- upvalues: p13 (copy), UserAbilitiesUserInterfaceB (copy), t1 (copy), v2 (copy)
        local v18, v19

        if UserAbilitiesUserInterfaceB then
            v18 = p14:FindFirstChildOfClass(v2)
        else
            v19 = p14:FindFirstChild(v2)
        end

        if (not UserAbilitiesUserInterfaceB or v18) and (UserAbilitiesUserInterfaceB or v19) then
            return
        end

        local v20 = Instance.new(v2)

        v20.Owner = p13
        v20.Parent = p14
        t1.setupPlayerControlState(v20)
    end

    local Character, v21

    if p13.Character then
        Character = p13.Character
        v21 = if UserAbilitiesUserInterfaceB then not not Character:FindFirstChildOfClass(v2) else not not Character:FindFirstChild(v2)
    else
        v21 = true
    end

    if not v21 then
        local v22 = Instance.new(v2)

        v22.Owner = p13
        v22.Parent = Character
        t1.setupPlayerControlState(v22)
    end

    p13.CharacterAdded:Connect(createForCharacter)
end

function t1.writeInputToCS(p15, p16) -- line: 231
    -- upvalues: UserControlModuleDisabledUpdate (copy), UserGameSettings (copy), Workspace (copy), AvatarAbilitiesInterface (copy), UserAbilitiesUserInterfaceB (copy), v2 (copy), v1 (copy)
    assert(not UserControlModuleDisabledUpdate)

    local data = p16.data
    local Character = p15.Character

    if Character then
        local v24 = if UserAbilitiesUserInterfaceB then Character:FindFirstChildOfClass(v2) else Character:FindFirstChild(v2)

        if v24 and p16.humanoid then
            local isJumping, worldMoveVector = data.controlModule.isJumping, data.controlModule.worldMoveVector
            local v25 = UserGameSettings.RotationType == Enum.RotationType.CameraRelative
            local LookVector = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
            local v26 = Vector3.new(LookVector.X, 0, LookVector.Z)
            local t2 = {
                Move = worldMoveVector,
                RotateToLookDirection = v25,
                LookDirection = if v26.Magnitude > 0.001 then v26.Unit else Vector3.new(0, 0, 1)
            }

            if not (v1 and AvatarAbilitiesInterface.get(p15):isEnabled()) then
                t2.Jump = isJumping
            end

            v24:UpdateFields(t2)
        end
    end
end

function t1.processPCSInputs(p17) -- line: 271
    -- upvalues: UserAbilitiesUserInterfaceB (copy), v2 (copy)
    local Character = p17.Character

    if Character ~= nil then
        local Humanoid = Character:FindFirstChild("Humanoid")

        if Humanoid ~= nil then
            local v27 = if UserAbilitiesUserInterfaceB then Character:FindFirstChildOfClass(v2) else Character:FindFirstChild(v2)

            if v27 ~= nil then
                local State = v27:GetState()
                local Move, Jump, RotateToLookDirection, LookDirection = State.Move, State.Jump, State.RotateToLookDirection, State.LookDirection

                if Move then
                    Humanoid:Move(Move)
                end

                Humanoid.AutoRotate = not RotateToLookDirection

                if RotateToLookDirection and LookDirection ~= nil and Humanoid.RootPart ~= nil and not Humanoid.Sit and Humanoid.SeatPart == nil and not Humanoid.RootPart:IsGrounded() then
                    Humanoid.RootPart.CFrame = CFrame.new(Humanoid.RootPart.CFrame.Position, Humanoid.RootPart.CFrame.Position + LookDirection)
                end

                Humanoid.Jump = Jump or false
            end
        end
    end
end

return t1
