-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SocialService = game:GetService("SocialService")
local TweenService = game:GetService("TweenService")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local FeedSequencer = require(ReplicatedStorage.Shared.TreadmillVideoController.FeedSequencer)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Log = require(ReplicatedStorage.Packages.Log)
local Media = require(ReplicatedStorage.Shared.TreadmillVideoController.Media)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local TreadmillFlags = require(ReplicatedStorage.Shared.Flags.TreadmillFlags)
local TreadmillMediaIdentity = require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity)
local Schema = require(ReplicatedStorage.Shared.Types.TreadmillMediaLike.Types.Schema)
local TreadmillMediaOverlay = require(ReplicatedStorage.Shared.Modules.TreadmillMediaOverlay)

require(ReplicatedStorage.Shared.TreadmillVideoController.Types.Interface)

local Trove = require(ReplicatedStorage.Packages.Trove)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local VideoComments = require(ReplicatedStorage.Client.VideoComments)
local v1 = Color3.fromRGB(255, 92, 122)
local v2 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
local v6 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v7 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

return {
    Start = function() -- Start | line: 112
        -- upvalues: CollectionService (copy), Players (copy), RunService (copy), SocialService (copy), TweenService (copy), ButtonFX (copy), FeedSequencer (copy), Simple (copy), Log (copy), Media (copy), Remotes (copy), Save (copy), TreadmillFlags (copy), TreadmillMediaIdentity (copy), Schema (copy), TreadmillMediaOverlay (copy), Trove (copy), TryCall (copy), VideoComments (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy)
        local LocalPlayer = Players.LocalPlayer
        local v8 = Log.new()
        local _warn
        local t2 = nil
        local tween
        local v9 = false
        local v10
        local Main = require(script.Parent.BackpackController.Main)
        local v11
        local v12 = false

        local function dismissEquipHint() -- line: 125
            -- upvalues: v11 (ref)
            local v13 = v11

            v11 = nil

            if v13 ~= nil then
                v13:Destroy()
            end
        end

        local function warnMissingUi(p1) -- line: 137
            -- upvalues: v9 (ref)
            if not v9 then
                v9 = true
                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(p1)))
            end
        end

        local function findTyped(p2, p3, p4, p5) -- line: 145
            -- upvalues: v9 (ref)
            local v14 = p2:FindFirstChild(p3, p5 == true)

            if v14 ~= nil and v14:IsA(p4) then
                return v14
            end

            local v15 = ("%*.%* (%*)"):format(p2:GetFullName(), p3, p4)

            if not v9 then
                v9 = true
                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v15)))
            end

            return nil
        end

        local function resolvePhoneUi() -- line: 154
            -- upvalues: LocalPlayer (copy), _warn (ref), v9 (ref)
            local v16 = _warn

            if v16 ~= nil and v16.Gui.Parent ~= nil then
                return v16
            end

            _warn = nil
            v16 = LocalPlayer:FindFirstChildOfClass("PlayerGui")

            local PhoneVideoUI = v16 and v16:FindFirstChild("PhoneVideoUI")
            local v17, v18

            if PhoneVideoUI ~= nil and PhoneVideoUI:IsA("ScreenGui") then
                v17 = PhoneVideoUI:FindFirstChild("Phone", false)

                if v17 == nil or not v17:IsA("Frame") then
                    local v19 = ("%*.Phone (Frame)"):format((PhoneVideoUI:GetFullName()))

                    v18 = v9

                    if not v18 then
                        v9 = true
                        warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v19)))
                    end

                    v17 = nil
                end

                if v17 ~= nil then
                    local v20 = v17:FindFirstChild("MainVideo", true)
                    local v21

                    if v20 == nil or not v20:IsA("VideoFrame") then
                        v18 = ("%*.MainVideo (VideoFrame)"):format((v17:GetFullName()))
                        v21 = v9

                        if not v21 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v18)))
                        end

                        v20 = nil
                    end

                    v18 = v17:FindFirstChild("Bar", false)

                    local v22, v23

                    if v18 ~= nil then
                        if v18:IsA("Frame") then
                            v23 = true
                        else
                            v21 = ("%*.Bar (Frame)"):format((v17:GetFullName()))
                            v22 = v9

                            if not v22 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v21)))
                            end

                            v23 = false
                        end
                    else
                        v21 = ("%*.Bar (Frame)"):format((v17:GetFullName()))
                        v22 = v9

                        if not v22 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v21)))
                        end

                        v23 = false
                    end

                    if not v23 then
                        v18 = nil
                    end

                    local v24

                    if v18 then
                        v21 = v18:FindFirstChild("Progress", false)

                        local v25 = false

                        if v21 ~= nil then
                            if v21:IsA("GuiObject") then
                                v25 = true
                            else
                                v22 = ("%*.Progress (GuiObject)"):format((v18:GetFullName()))
                                v24 = v9

                                if not v24 then
                                    v9 = true
                                    warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v22)))
                                end
                            end
                        else
                            v22 = ("%*.Progress (GuiObject)"):format((v18:GetFullName()))
                            v24 = v9

                            if not v24 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v22)))
                            end
                        end

                        if not v25 then
                            v21 = nil
                        end
                    else
                        v21 = v18
                    end

                    local v26 = v17:FindFirstChild("Loading", false)
                    local v27 = false

                    if v26 ~= nil then
                        if v26:IsA("GuiObject") then
                            v27 = true
                        else
                            v22 = ("%*.Loading (GuiObject)"):format((v17:GetFullName()))
                            v24 = v9

                            if not v24 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v22)))
                            end
                        end
                    else
                        v22 = ("%*.Loading (GuiObject)"):format((v17:GetFullName()))
                        v24 = v9

                        if not v24 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v22)))
                        end
                    end

                    if not v27 then
                        v26 = nil
                    end

                    local v28

                    if v26 then
                        v22 = v26:FindFirstChild("Spin", false)

                        local v29 = false

                        if v22 ~= nil then
                            if v22:IsA("GuiObject") then
                                v29 = true
                            else
                                v24 = ("%*.Spin (GuiObject)"):format((v26:GetFullName()))
                                v28 = v9

                                if not v28 then
                                    v9 = true
                                    warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v24)))
                                end
                            end
                        else
                            v24 = ("%*.Spin (GuiObject)"):format((v26:GetFullName()))
                            v28 = v9

                            if not v28 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v24)))
                            end
                        end

                        if not v29 then
                            v22 = nil
                        end
                    else
                        v22 = v26
                    end

                    v24 = v17:FindFirstChild("GoToNext", false)

                    local v30, v31

                    if v24 ~= nil then
                        if v24:IsA("CanvasGroup") then
                            v31 = true
                        else
                            v28 = ("%*.GoToNext (CanvasGroup)"):format((v17:GetFullName()))
                            v30 = v9

                            if not v30 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v28)))
                            end

                            v31 = false
                        end
                    else
                        v28 = ("%*.GoToNext (CanvasGroup)"):format((v17:GetFullName()))
                        v30 = v9

                        if not v30 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v28)))
                        end

                        v31 = false
                    end

                    if not v31 then
                        v24 = nil
                    end

                    local v32, v33

                    if v24 then
                        v28 = v24:FindFirstChild("Arrow", false)

                        local v34 = false

                        if v28 ~= nil then
                            if v28:IsA("ImageLabel") then
                                v34 = true
                            else
                                v30 = ("%*.Arrow (ImageLabel)"):format((v24:GetFullName()))
                                v32 = v9

                                if not v32 then
                                    v9 = true
                                    warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v30)))
                                end
                            end
                        else
                            v30 = ("%*.Arrow (ImageLabel)"):format((v24:GetFullName()))
                            v32 = v9

                            if not v32 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v30)))
                            end
                        end

                        if not v34 then
                            v28 = nil
                        end

                        v30 = v24:FindFirstChild("ArrowShadow", false)

                        local v35 = false

                        if v30 ~= nil then
                            if v30:IsA("ImageLabel") then
                                v35 = true
                            else
                                v32 = ("%*.ArrowShadow (ImageLabel)"):format((v24:GetFullName()))
                                v33 = v9

                                if not v33 then
                                    v9 = true
                                    warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v32)))
                                end
                            end
                        else
                            v32 = ("%*.ArrowShadow (ImageLabel)"):format((v24:GetFullName()))
                            v33 = v9

                            if not v33 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v32)))
                            end
                        end

                        if not v35 then
                            v30 = nil
                        end
                    else
                        v30 = v24
                        v28 = v24
                    end

                    v32 = v17:FindFirstChild("Paused", false)

                    local v36, v37

                    if v32 ~= nil then
                        if v32:IsA("CanvasGroup") then
                            v37 = true
                        else
                            v33 = ("%*.Paused (CanvasGroup)"):format((v17:GetFullName()))
                            v36 = v9

                            if not v36 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v33)))
                            end

                            v37 = false
                        end
                    else
                        v33 = ("%*.Paused (CanvasGroup)"):format((v17:GetFullName()))
                        v36 = v9

                        if not v36 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v33)))
                        end

                        v37 = false
                    end

                    if not v37 then
                        v32 = nil
                    end

                    v33 = v17:FindFirstChild("TapCatcher", false)

                    local v38, v39

                    if v33 ~= nil then
                        if v33:IsA("GuiButton") then
                            v39 = true
                        else
                            v36 = ("%*.TapCatcher (GuiButton)"):format((v17:GetFullName()))
                            v38 = v9

                            if not v38 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v36)))
                            end

                            v39 = false
                        end
                    else
                        v36 = ("%*.TapCatcher (GuiButton)"):format((v17:GetFullName()))
                        v38 = v9

                        if not v38 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v36)))
                        end

                        v39 = false
                    end

                    if not v39 then
                        v33 = nil
                    end

                    v36 = v17:FindFirstChild("Close", false)

                    local v40, v41

                    if v36 ~= nil then
                        if v36:IsA("GuiButton") then
                            v41 = true
                        else
                            v38 = ("%*.Close (GuiButton)"):format((v17:GetFullName()))
                            v40 = v9

                            if not v40 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v38)))
                            end

                            v41 = false
                        end
                    else
                        v38 = ("%*.Close (GuiButton)"):format((v17:GetFullName()))
                        v40 = v9

                        if not v40 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v38)))
                        end

                        v41 = false
                    end

                    if not v41 then
                        v36 = nil
                    end

                    v38 = v17:FindFirstChild("ButtonSwapLeft", true)

                    local v42, v43

                    if v38 ~= nil then
                        if v38:IsA("GuiButton") then
                            v43 = true
                        else
                            v40 = ("%*.ButtonSwapLeft (GuiButton)"):format((v17:GetFullName()))
                            v42 = v9

                            if not v42 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v40)))
                            end

                            v43 = false
                        end
                    else
                        v40 = ("%*.ButtonSwapLeft (GuiButton)"):format((v17:GetFullName()))
                        v42 = v9

                        if not v42 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v40)))
                        end

                        v43 = false
                    end

                    if not v43 then
                        v38 = nil
                    end

                    v40 = v17:FindFirstChild("ButtonSwapRight", true)

                    local v44, v45

                    if v40 ~= nil then
                        if v40:IsA("GuiButton") then
                            v45 = true
                        else
                            v42 = ("%*.ButtonSwapRight (GuiButton)"):format((v17:GetFullName()))
                            v44 = v9

                            if not v44 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v42)))
                            end

                            v45 = false
                        end
                    else
                        v42 = ("%*.ButtonSwapRight (GuiButton)"):format((v17:GetFullName()))
                        v44 = v9

                        if not v44 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v42)))
                        end

                        v45 = false
                    end

                    if not v45 then
                        v40 = nil
                    end

                    v42 = v17:FindFirstChild("Share", false)

                    local v46, v47

                    if v42 ~= nil then
                        if v42:IsA("GuiObject") then
                            v47 = true
                        else
                            v44 = ("%*.Share (GuiObject)"):format((v17:GetFullName()))
                            v46 = v9

                            if not v46 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v44)))
                            end

                            v47 = false
                        end
                    else
                        v44 = ("%*.Share (GuiObject)"):format((v17:GetFullName()))
                        v46 = v9

                        if not v46 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v44)))
                        end

                        v47 = false
                    end

                    if not v47 then
                        v42 = nil
                    end

                    local v48

                    if v42 then
                        v44 = v42:FindFirstChild("ShareButton", true)

                        local v49 = false

                        if v44 ~= nil then
                            if v44:IsA("GuiButton") then
                                v49 = true
                            else
                                v46 = ("%*.ShareButton (GuiButton)"):format((v42:GetFullName()))
                                v48 = v9

                                if not v48 then
                                    v9 = true
                                    warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v46)))
                                end
                            end
                        else
                            v46 = ("%*.ShareButton (GuiButton)"):format((v42:GetFullName()))
                            v48 = v9

                            if not v48 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v46)))
                            end
                        end

                        if not v49 then
                            v44 = nil
                        end
                    else
                        v44 = v42
                    end

                    v46 = v17:FindFirstChild("SideButtons", false)

                    local v50, v51

                    if v46 ~= nil then
                        if v46:IsA("GuiObject") then
                            v51 = true
                        else
                            v48 = ("%*.SideButtons (GuiObject)"):format((v17:GetFullName()))
                            v50 = v9

                            if not v50 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v48)))
                            end

                            v51 = false
                        end
                    else
                        v48 = ("%*.SideButtons (GuiObject)"):format((v17:GetFullName()))
                        v50 = v9

                        if not v50 then
                            v9 = true
                            warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v48)))
                        end

                        v51 = false
                    end

                    if not v51 then
                        v46 = nil
                    end

                    local v52

                    if v46 then
                        v48 = v46:FindFirstChild("LikeButton", true)

                        local v53 = false

                        if v48 ~= nil then
                            if v48:IsA("ImageButton") then
                                v53 = true
                            else
                                v50 = ("%*.LikeButton (ImageButton)"):format((v46:GetFullName()))
                                v52 = v9

                                if not v52 then
                                    v9 = true
                                    warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v50)))
                                end
                            end
                        else
                            v50 = ("%*.LikeButton (ImageButton)"):format((v46:GetFullName()))
                            v52 = v9

                            if not v52 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v50)))
                            end
                        end

                        if not v53 then
                            v48 = nil
                        end
                    else
                        v48 = v46
                    end

                    local v54

                    if v48 then
                        v50 = v48:FindFirstChild("LikeCount", false)

                        local v55 = false

                        if v50 ~= nil then
                            if v50:IsA("TextLabel") then
                                v55 = true
                            else
                                v52 = ("%*.LikeCount (TextLabel)"):format((v48:GetFullName()))
                                v54 = v9

                                if not v54 then
                                    v9 = true
                                    warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v52)))
                                end
                            end
                        else
                            v52 = ("%*.LikeCount (TextLabel)"):format((v48:GetFullName()))
                            v54 = v9

                            if not v54 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v52)))
                            end
                        end

                        if not v55 then
                            v50 = nil
                        end
                    else
                        v50 = v48
                    end

                    local VideoCounter

                    if v46 then
                        v52 = v46:FindFirstChild("CommentsButton", true)

                        local v56 = false

                        if v52 ~= nil then
                            if v52:IsA("GuiButton") then
                                v56 = true
                            else
                                v54 = ("%*.CommentsButton (GuiButton)"):format((v46:GetFullName()))
                                VideoCounter = v9

                                if not VideoCounter then
                                    v9 = true
                                    warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v54)))
                                end
                            end
                        else
                            v54 = ("%*.CommentsButton (GuiButton)"):format((v46:GetFullName()))
                            VideoCounter = v9

                            if not VideoCounter then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(v54)))
                            end
                        end

                        if not v56 then
                            v52 = nil
                        end
                    else
                        v52 = v46
                    end

                    local _warn2

                    if v52 then
                        v54 = v52:FindFirstChild("CommentsCount", false)

                        local v57 = false

                        if v54 ~= nil then
                            if v54:IsA("TextLabel") then
                                v57 = true
                            else
                                VideoCounter = ("%*.CommentsCount (TextLabel)"):format((v52:GetFullName()))
                                _warn2 = v9

                                if not _warn2 then
                                    v9 = true
                                    warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(VideoCounter)))
                                end
                            end
                        else
                            VideoCounter = ("%*.CommentsCount (TextLabel)"):format((v52:GetFullName()))
                            _warn2 = v9

                            if not _warn2 then
                                v9 = true
                                warn((("[PhoneVideoController] %* is missing. The PhoneVideoUI ScreenGui is incomplete."):format(VideoCounter)))
                            end
                        end

                        if not v57 then
                            v54 = nil
                        end
                    else
                        v54 = v52
                    end

                    if v20 ~= nil and v21 ~= nil and v26 ~= nil and v22 ~= nil and v24 ~= nil and v28 ~= nil and v30 ~= nil and v32 ~= nil and v33 ~= nil and v36 ~= nil and v38 ~= nil and v40 ~= nil and v42 ~= nil and v44 ~= nil then
                        if v46 == nil or v48 == nil or v50 == nil or v52 == nil or v54 == nil then
                            return nil
                        end

                        local v58 = v32:FindFirstChild("EnjoyFree", true)

                        VideoCounter = v17:FindFirstChild("VideoCounter")

                        for _, v59 in { v17 } do
                            for _, descendant in v59:GetDescendants() do
                                if descendant.Name == "GamepadGlyph" and descendant:IsA("GuiObject") then
                                    descendant.Visible = false
                                end
                            end
                        end

                        _warn2 = {
                            Gui = PhoneVideoUI,
                            Phone = v17,
                            Video = v20,
                            Progress = v21,
                            Loading = v26,
                            LoadingSpin = v22,
                            GoToNext = v24,
                            Arrow = v28,
                            ArrowShadow = v30,
                            Paused = v32
                        }

                        if v58 == nil or not v58:IsA("TextLabel") then
                            v58 = nil
                        end

                        _warn2.EnjoyFreeLabel = v58

                        if VideoCounter == nil or not VideoCounter:IsA("TextLabel") then
                            VideoCounter = nil
                        end

                        _warn2.VideoCounter = VideoCounter
                        _warn2.TapCatcher = v33
                        _warn2.Close = v36
                        _warn2.SwapLeftButton = v38
                        _warn2.SwapRightButton = v40
                        _warn2.ShareContainer = v42
                        _warn2.ShareButton = v44
                        _warn2.SideButtonsContainer = v46
                        _warn2.LikeButton = v48
                        _warn2.LikeCountLabel = v50
                        _warn2.CommentsButton = v52
                        _warn2.CommentsCountLabel = v54

                        local Comments = v17:FindFirstChild("Comments")

                        if Comments == nil or not Comments:IsA("GuiObject") then
                            Comments = nil
                        end

                        _warn2.CommentsPanel = Comments
                        _warn2.ArrowBasePosition = v28.Position
                        _warn2.ArrowShadowBasePosition = v30.Position
                        _warn2.VideoBaseSize = v20.Size
                        _warn2.OnscreenPosition = v17.Position
                        _warn2.OffscreenPosition = UDim2.new(v17.Position.X.Scale, 0, 2, 0)
                        _warn = _warn2

                        return _warn2
                    end
                end

                return nil
            end

            if not v9 then
                v9 = true
                warn("[PhoneVideoController] PlayerGui.PhoneVideoUI is missing. The PhoneVideoUI ScreenGui is incomplete.")
            end

            return nil
        end

        local v60 = table.clone(Media)

        TreadmillMediaOverlay.ApplyTo(v60)

        local function isSkippedMediaIndex(p6) -- line: 281
            -- upvalues: v60 (copy), TreadmillMediaIdentity (copy), TreadmillMediaOverlay (copy)
            local v61 = v60[p6]

            if v61 ~= nil and v61.Kind == "Video" and v61.Disabled ~= true then
                return TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v61))
            end

            return true
        end

        local function countPlayableVideos() -- line: 289
            -- upvalues: v60 (copy), TreadmillMediaIdentity (copy), TreadmillMediaOverlay (copy)
            local n1 = 0

            for v62 in v60 do
                local v63 = v60[v62]

                if v63 ~= nil and v63.Kind == "Video" and v63.Disabled ~= true and not TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v63)) then
                    n1 += 1
                end
            end

            return n1
        end

        local function sequencerNextSkippingUnplayable(p7) -- line: 299
            -- upvalues: v60 (copy), FeedSequencer (copy), Remotes (copy), TreadmillMediaIdentity (copy), TreadmillMediaOverlay (copy)
            local v64, v65 = FeedSequencer.Next(p7.Feed)

            for _ = 1, #v60 do
                local v66 = v60[v64]

                if v66 ~= nil and v66.Kind == "Video" and v66.Disabled ~= true and not TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v66)) then
                    break
                end

                Remotes.Treadmill.RefreshClipCursor:FireServer(v65)
                v64, v65 = FeedSequencer.Next(p7.Feed)
            end

            return v64, v65
        end

        local function sequencerPreviousSkippingUnplayable(p8) -- line: 311
            -- upvalues: v60 (copy), sequencerNextSkippingUnplayable (copy), FeedSequencer (copy), Remotes (copy), TreadmillMediaIdentity (copy), TreadmillMediaOverlay (copy)
            local v67, v68, v69 = FeedSequencer.Previous(p8.Feed)

            if not v69 then
                return v67, v68, false
            end

            for _ = 1, #v60 do
                local v70 = v60[v67]

                if v70 ~= nil and v70.Kind == "Video" and v70.Disabled ~= true and not TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v70)) then
                    return v67, v68, true
                end

                Remotes.Treadmill.RefreshClipCursor:FireServer(v68)

                local v71

                v67, v68, v71 = FeedSequencer.Previous(p8.Feed)

                if not v71 then
                    local v72, v73 = sequencerNextSkippingUnplayable(p8)

                    return v72, v73, true
                end
            end

            return v67, v68, true
        end

        local function currentMediaKey(p9) -- line: 336
            -- upvalues: v60 (copy), TreadmillMediaIdentity (copy)
            return TreadmillMediaIdentity.GetMediaKey(v60[p9.Index])
        end

        local function formatCompactCount(p10) -- line: 340
            -- upvalues: Simple (copy)
            return Simple.FormatCompact(math.max(p10, 0), ".#")
        end

        local function updateSocialPresentation(p11, p12) -- line: 344
            -- upvalues: v60 (copy), Simple (copy), TreadmillFlags (copy), TreadmillMediaIdentity (copy), VideoComments (copy), v1 (copy)
            local v74 = TreadmillMediaIdentity.GetMediaKey(v60[p12.Index])
            local v75 = p12.LikedByMediaKey[v74] == true
            local LikeButton = p11.LikeButton

            if v75 then
                LikeButton.ImageColor3 = v1
            else
                LikeButton.ImageColor3 = Color3.new(1, 1, 1)
            end

            p11.LikeButton.Image = v75 and "rbxassetid://90146064998908" or "rbxassetid://123761405635833"

            local LikeCountLabel = p11.LikeCountLabel
            local v76 = p12.LikeCountsByMediaKey[v74] or 0

            LikeCountLabel.Text = Simple.FormatCompact(math.max(v76, 0), ".#")
            p11.CommentsButton.Visible = not TreadmillFlags.CommentsDisabled:Get()

            local CommentsCountLabel = p11.CommentsCountLabel
            local v77 = VideoComments.GetCachedCommentCount(v74) or 0

            CommentsCountLabel.Text = Simple.FormatCompact(math.max(v77, 0), ".#")
        end

        local function toggleLike(p13, p14) -- line: 375
            -- upvalues: v8 (copy), t2 (ref), v60 (copy), updateSocialPresentation (copy), Remotes (copy), TreadmillMediaIdentity (copy), Schema (copy), TryCall (copy)
            if p14.LikeBusy then
                return
            end

            p14.LikeBusy = true

            local v78 = TreadmillMediaIdentity.GetMediaKey(v60[p14.Index])
            local v79 = p14.LikedByMediaKey[v78] == true
            local v80 = p14.LikeCountsByMediaKey[v78] or 0
            local v81 = not v79

            p14.LikedByMediaKey[v78] = v81
            p14.LikeCountsByMediaKey[v78] = math.max(v80 + (if v81 then 1 else -1), 0)
            updateSocialPresentation(p13, p14)
            task.spawn(function() -- line: 389
                -- upvalues: p13 (copy), p14 (copy), v78 (copy), v80 (copy), v79 (copy), v81 (copy), v8 (copy), t2 (ref), updateSocialPresentation (copy), Remotes (copy), Schema (copy), TryCall (copy)
                local v84, v85 = TryCall(function() -- line: 390
                    -- upvalues: v78 (copy), v81 (copy), Remotes (copy)
                    return Remotes.Treadmill.AskClipFavour:InvokeServer(v78, v81)
                end)

                if t2 ~= p14 then
                    return
                end

                p14.LikeBusy = false

                if v84 and Schema.LikeToggleResult(v85) and v85.Ok == true then
                    p14.LikedByMediaKey[v78] = v85.Liked == true

                    if type(v85.Count) == "number" then
                        p14.LikeCountsByMediaKey[v78] = v85.Count
                    end

                    updateSocialPresentation(p13, p14)
                else
                    p14.LikedByMediaKey[v78] = v79
                    p14.LikeCountsByMediaKey[v78] = v80
                    updateSocialPresentation(p13, p14)
                    v8:AtWarning():Log("[PhoneVideoController] Media like update was rejected")
                end
            end)
        end

        local function fadeInCard(p15, p16, p17) -- line: 419
            -- upvalues: TweenService (copy)
            p16.GroupTransparency = 1
            p16.Visible = true

            local tween = TweenService:Create(p16, p17, {
                GroupTransparency = 0
            })

            p15:Add(function() -- line: 423
                -- upvalues: tween (copy)
                tween:Cancel()
            end)
            tween:Play()
        end

        local function hidePausedCard(p18, p19) -- line: 429
            local PausedCardTrove = p19.PausedCardTrove

            p19.PausedCardTrove = nil

            if PausedCardTrove ~= nil then
                PausedCardTrove:Destroy()
            end

            p18.Paused.Visible = false

            local PreviewBaseSize = p19.PreviewBaseSize

            p19.PreviewBaseSize = nil

            if PreviewBaseSize ~= nil then
                p18.Video.Size = PreviewBaseSize
            end
        end

        local function showPausedCard(p20, p21) -- line: 444
            -- upvalues: fadeInCard (copy), Trove (copy), v4 (copy)
            if p21.PausedCardTrove == nil and p21.EndCardTrove == nil then
                local v87 = Trove.new()

                p21.PausedCardTrove = v87

                local EnjoyFreeLabel = p20.EnjoyFreeLabel

                if EnjoyFreeLabel ~= nil then
                    EnjoyFreeLabel.Visible = not p21.HasPlayed
                end

                fadeInCard(v87, p20.Paused, v4)

                if p20.Video.TimePosition <= 0 and not p20.Video.Playing then
                    local function v88() -- line: 464
                        -- upvalues: p20 (copy)
                        p20.Video:Play()
                        p20.Video:Pause()
                        p20.Video.TimePosition = 0
                    end

                    pcall(v88)
                end

                local PreviewBaseSize = p21.PreviewBaseSize

                if PreviewBaseSize ~= nil then
                    p21.PreviewBaseSize = nil
                    p20.Video.Size = PreviewBaseSize
                end

                local Size = p20.Video.Size
                local v91 = math.max(if Size.X.Scale > 0 then 1 / Size.X.Scale else 1, if Size.Y.Scale > 0 then 1 / Size.Y.Scale else 1)

                if v91 > 1 then
                    p21.PreviewBaseSize = Size
                    p20.Video.Size = UDim2.new(Size.X.Scale * v91, Size.X.Offset * v91, Size.Y.Scale * v91, Size.Y.Offset * v91)
                end
            end
        end

        local function hideEndCard(p22, p23) -- line: 493
            local EndCardTrove = p23.EndCardTrove

            p23.EndCardTrove = nil

            if EndCardTrove ~= nil then
                EndCardTrove:Destroy()
            end

            p22.GoToNext.Visible = false
        end

        local function spawnArrowPulse(p24, p25) -- line: 502
            -- upvalues: TweenService (copy), v2 (copy)
            local clone = p24.Arrow:Clone()

            clone.Name = "ArrowPulse"
            clone.ZIndex = math.max(p24.Arrow.ZIndex - 1, 0)
            clone.ImageTransparency = 0.35
            clone.Parent = p24.GoToNext
            p25:Add(clone)

            local tween = TweenService:Create(clone, v2, {
                ImageTransparency = 1,
                Size = UDim2.new(p24.Arrow.Size.X.Scale * 2.2, 0, p24.Arrow.Size.Y.Scale * 2.2, 0)
            })

            tween.Completed:Once(function() -- line: 519
                -- upvalues: clone (copy)
                clone:Destroy()
            end)
            tween:Play()
        end

        local function showEndCard(p26, p27) -- line: 525
            -- upvalues: fadeInCard (copy), spawnArrowPulse (copy), RunService (copy), Trove (copy), v3 (copy)
            if p27.EndCardTrove ~= nil then
                return
            end

            local PausedCardTrove = p27.PausedCardTrove

            p27.PausedCardTrove = nil

            if PausedCardTrove ~= nil then
                PausedCardTrove:Destroy()
            end

            p26.Paused.Visible = false

            local PreviewBaseSize = p27.PreviewBaseSize

            p27.PreviewBaseSize = nil

            if PreviewBaseSize ~= nil then
                p26.Video.Size = PreviewBaseSize
            end

            local v93 = Trove.new()

            p27.EndCardTrove = v93
            p26.ShareContainer.Visible = false
            p26.SideButtonsContainer.Visible = false
            fadeInCard(v93, p26.GoToNext, v3)

            local v94 = p26.GoToNext:GetAttribute("SwaySeconds") or 1.2
            local v95 = p26.GoToNext:GetAttribute("SwayScale") or 0.02
            local elapsed = os.clock()
            local n2 = 0

            v93:Connect(RunService.RenderStepped, function() -- line: 541
                -- upvalues: p26 (copy), v93 (copy), v94 (copy), v95 (copy), elapsed (copy), n2 (ref), spawnArrowPulse (copy)
                local v96 = os.clock() - elapsed
                local v98 = math.sin(v96 * 3.141592653589793 * 2 / v94) * v95
                local v99 = UDim2.fromScale(v98, 0)

                p26.Arrow.Position = p26.ArrowBasePosition + v99
                p26.ArrowShadow.Position = p26.ArrowShadowBasePosition + v99

                local v101 = math.floor(v96 / v94 + 0.75)

                if n2 < v101 then
                    n2 = v101
                    spawnArrowPulse(p26, v93)
                end
            end)
            v93:Add(function() -- line: 555
                -- upvalues: p26 (copy)
                p26.Arrow.Position = p26.ArrowBasePosition
                p26.ArrowShadow.Position = p26.ArrowShadowBasePosition
            end)
        end

        local function playVideo(p28, p29) -- line: 565
            p29.HasPlayed = true

            local PausedCardTrove = p29.PausedCardTrove

            p29.PausedCardTrove = nil

            if PausedCardTrove ~= nil then
                PausedCardTrove:Destroy()
            end

            p28.Paused.Visible = false

            local PreviewBaseSize = p29.PreviewBaseSize

            p29.PreviewBaseSize = nil

            if PreviewBaseSize ~= nil then
                p28.Video.Size = PreviewBaseSize
            end

            p28.Video:Play()
        end

        local function pauseVideo(p30, p31) -- line: 571
            -- upvalues: showPausedCard (copy)
            p30.Video:Pause()
            showPausedCard(p30, p31)
        end

        local function stopLoading(p32, p33) -- line: 576
            local LoadingTween = p33.LoadingTween

            p33.LoadingTween = nil

            if LoadingTween ~= nil then
                LoadingTween:Cancel()
            end

            p32.Loading.Visible = false
            p32.LoadingSpin.Rotation = 0
        end

        local function finishLoad(p34, p35) -- line: 586
            -- upvalues: updateSocialPresentation (copy), showPausedCard (copy)
            local LoadingTween = p35.LoadingTween

            p35.LoadingTween = nil

            if LoadingTween ~= nil then
                LoadingTween:Cancel()
            end

            p34.Loading.Visible = false
            p34.LoadingSpin.Rotation = 0
            p34.ShareContainer.Visible = true
            p34.SideButtonsContainer.Visible = true
            updateSocialPresentation(p34, p35)

            if not p35.HasPlayed then
                showPausedCard(p34, p35)

                return
            end

            p35.HasPlayed = true

            local PausedCardTrove = p35.PausedCardTrove

            p35.PausedCardTrove = nil

            if PausedCardTrove ~= nil then
                PausedCardTrove:Destroy()
            end

            p34.Paused.Visible = false

            local PreviewBaseSize = p35.PreviewBaseSize

            p35.PreviewBaseSize = nil

            if PreviewBaseSize ~= nil then
                p34.Video.Size = PreviewBaseSize
            end

            p34.Video:Play()
        end

        local function loadVideo(p36, p37, p38, p39) -- line: 598
            -- upvalues: v8 (copy), t2 (ref), v10 (ref), v60 (copy), updateSocialPresentation (copy), showPausedCard (copy), TweenService (copy), Remotes (copy), v5 (copy)
            local v102 = v60[p38]
            local LoadToken, v103

            if v102 ~= nil then
                if v102.Kind == "Video" then
                    p37.LoadToken += 1
                    LoadToken = p37.LoadToken

                    local EndCardTrove = p37.EndCardTrove

                    p37.EndCardTrove = nil

                    if EndCardTrove ~= nil then
                        EndCardTrove:Destroy()
                    end

                    v103 = false
                else
                    v103 = true
                end
            else
                v103 = true
            end

            if v103 then
                v8:AtWarning():Log((("[PhoneVideoController] Media index %* is not a playable video"):format(p38)))

                return
            end

            p36.GoToNext.Visible = false

            local PausedCardTrove = p37.PausedCardTrove

            p37.PausedCardTrove = nil

            if PausedCardTrove ~= nil then
                PausedCardTrove:Destroy()
            end

            p36.Paused.Visible = false

            local PreviewBaseSize = p37.PreviewBaseSize

            p37.PreviewBaseSize = nil

            if PreviewBaseSize ~= nil then
                p36.Video.Size = PreviewBaseSize
            end

            local CommentsPanel = p36.CommentsPanel

            if CommentsPanel ~= nil then
                CommentsPanel.Visible = false
            end

            p37.Index = p38
            Remotes.Treadmill.RefreshClipCursor:FireServer(p39)
            v10 = p39
            p36.Video:Pause()
            p36.Video.Size = v102.Size or p36.VideoBaseSize
            p36.Video.Volume = v102.Volume or 1
            p36.Video.Video = v102.Video
            p36.Video.TimePosition = 0

            local Size = p36.Progress.Size

            p36.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset)

            if p36.Video.IsLoaded then
                local LoadingTween = p37.LoadingTween

                p37.LoadingTween = nil

                if LoadingTween ~= nil then
                    LoadingTween:Cancel()
                end

                p36.Loading.Visible = false
                p36.LoadingSpin.Rotation = 0
                p36.ShareContainer.Visible = true
                p36.SideButtonsContainer.Visible = true
                updateSocialPresentation(p36, p37)

                if p37.HasPlayed then
                    p37.HasPlayed = true

                    local PausedCardTrove = p37.PausedCardTrove

                    p37.PausedCardTrove = nil

                    if PausedCardTrove ~= nil then
                        PausedCardTrove:Destroy()
                    end

                    p36.Paused.Visible = false

                    local PreviewBaseSize = p37.PreviewBaseSize

                    p37.PreviewBaseSize = nil

                    if PreviewBaseSize ~= nil then
                        p36.Video.Size = PreviewBaseSize
                    end

                    p36.Video:Play()
                else
                    showPausedCard(p36, p37)
                end
            else
                p36.ShareContainer.Visible = false
                p36.SideButtonsContainer.Visible = false

                local LoadingTween = p37.LoadingTween

                p37.LoadingTween = nil

                if LoadingTween ~= nil then
                    LoadingTween:Cancel()
                end

                p36.Loading.Visible = false
                p36.LoadingSpin.Rotation = 0
                p36.Loading.Visible = true

                local tween = TweenService:Create(p36.LoadingSpin, v5, {
                    Rotation = 360
                })

                p37.LoadingTween = tween
                tween:Play()

                local connection
                local Loaded = p36.Video.Loaded
                local LoadToken2 = LoadToken

                connection = Loaded:Connect(function() -- line: 640
                    -- upvalues: p36 (copy), p37 (copy), connection (ref), LoadToken2 (copy), t2 (ref), updateSocialPresentation (copy), showPausedCard (copy)
                    connection:Disconnect()

                    if t2 ~= p37 or p37.LoadToken ~= LoadToken2 then
                        return
                    end

                    local LoadingTween = p37.LoadingTween

                    p37.LoadingTween = nil

                    if LoadingTween ~= nil then
                        LoadingTween:Cancel()
                    end

                    p36.Loading.Visible = false
                    p36.LoadingSpin.Rotation = 0
                    p36.ShareContainer.Visible = true
                    p36.SideButtonsContainer.Visible = true
                    updateSocialPresentation(p36, p37)

                    if not p37.HasPlayed then
                        showPausedCard(p36, p37)

                        return
                    end

                    p37.HasPlayed = true

                    local PausedCardTrove = p37.PausedCardTrove

                    p37.PausedCardTrove = nil

                    if PausedCardTrove ~= nil then
                        PausedCardTrove:Destroy()
                    end

                    p36.Paused.Visible = false

                    local PreviewBaseSize = p37.PreviewBaseSize

                    p37.PreviewBaseSize = nil

                    if PreviewBaseSize ~= nil then
                        p36.Video.Size = PreviewBaseSize
                    end

                    p36.Video:Play()
                end)
                p37.Trove:Add(connection)
            end
        end

        local function closePhone() -- line: 654
            -- upvalues: t2 (ref), tween (ref), resolvePhoneUi (copy), TweenService (copy), v7 (copy)
            local t3 = t2

            t2 = nil

            if t3 == nil then
                return
            end

            local v104 = resolvePhoneUi()

            t3.Trove:Destroy()

            if v104 == nil then
                return
            end

            v104.Video:Pause()

            if tween ~= nil then
                tween:Cancel()
            end

            local tween2 = TweenService:Create(v104.Phone, v7, {
                Position = v104.OffscreenPosition
            })

            tween = tween2
            tween2.Completed:Once(function() -- line: 673
                -- upvalues: v104 (copy), t2 (ref)
                if t2 == nil then
                    v104.Gui.Enabled = false
                end
            end)
            tween2:Play()
        end

        local function openPhone() -- line: 681
            -- upvalues: LocalPlayer (copy), v8 (copy), t2 (ref), tween (ref), v10 (ref), v11 (ref), v12 (ref), resolvePhoneUi (copy), v60 (copy), sequencerNextSkippingUnplayable (copy), sequencerPreviousSkippingUnplayable (copy), updateSocialPresentation (copy), toggleLike (copy), showPausedCard (copy), showEndCard (copy), loadVideo (copy), closePhone (copy), RunService (copy), SocialService (copy), TweenService (copy), ButtonFX (copy), FeedSequencer (copy), Remotes (copy), Save (copy), TreadmillMediaIdentity (copy), Schema (copy), TreadmillMediaOverlay (copy), Trove (copy), TryCall (copy), v6 (copy)
            v12 = true

            local v105 = v11

            v11 = nil

            if v105 ~= nil then
                v105:Destroy()
            end

            if t2 == nil then
                local v106 = resolvePhoneUi()

                if v106 ~= nil then
                    local v107 = Save.Await()

                    if v107 ~= nil then
                        local n3 = 0

                        for v108 in v60 do
                            local v109 = v60[v108]

                            if v109 ~= nil and v109.Kind == "Video" and v109.Disabled ~= true and not TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v109)) then
                                n3 += 1
                            end
                        end

                        if n3 == 0 then
                            v8:AtWarning():Log("[PhoneVideoController] No treadmill videos are available")
                        else
                            local t4 = {
                                EndCardTrove = nil,
                                PausedCardTrove = nil,
                                LoadingTween = nil,
                                HasPlayed = false,
                                Index = 1,
                                LoadToken = 0,
                                PreviewBaseSize = nil,
                                LikeBusy = false,
                                Trove = Trove.new(),
                                Feed = FeedSequencer.CreateRuntime(v60, v10 or v107.TreadmillMediaFeedState, LocalPlayer.UserId),
                                LikedByMediaKey = {},
                                LikeCountsByMediaKey = {}
                            }

                            t2 = t4
                            t4.Trove:Add(function() -- line: 720
                                -- upvalues: v106 (copy), t4 (copy)
                                local EndCardTrove = t4.EndCardTrove

                                t4.EndCardTrove = nil

                                if EndCardTrove ~= nil then
                                    EndCardTrove:Destroy()
                                end

                                v106.GoToNext.Visible = false

                                local PausedCardTrove = t4.PausedCardTrove

                                t4.PausedCardTrove = nil

                                if PausedCardTrove ~= nil then
                                    PausedCardTrove:Destroy()
                                end

                                v106.Paused.Visible = false

                                local PreviewBaseSize = t4.PreviewBaseSize

                                t4.PreviewBaseSize = nil

                                if PreviewBaseSize ~= nil then
                                    v106.Video.Size = PreviewBaseSize
                                end

                                local LoadingTween = t4.LoadingTween

                                t4.LoadingTween = nil

                                if LoadingTween ~= nil then
                                    LoadingTween:Cancel()
                                end

                                v106.Loading.Visible = false
                                v106.LoadingSpin.Rotation = 0
                            end)

                            local function goToNextVideo() -- line: 726
                                -- upvalues: v106 (copy), t4 (copy), sequencerNextSkippingUnplayable (copy), loadVideo (copy)
                                local v111, v112 = sequencerNextSkippingUnplayable(t4)

                                loadVideo(v106, t4, v111, v112)
                            end

                            local VideoCounter = v106.VideoCounter

                            if VideoCounter ~= nil then
                                local n4 = 0

                                for v113 in v60 do
                                    local v114 = v60[v113]

                                    if v114 ~= nil and v114.Kind == "Video" and v114.Disabled ~= true and not TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v114)) then
                                        n4 += 1
                                    end
                                end

                                VideoCounter.Text = ("Total Videos: %*"):format(n4)
                            end

                            t4.Trove:Add(ButtonFX(v106.Close, nil, function() -- line: 736
                                -- upvalues: LocalPlayer (copy), closePhone (copy)
                                local Character = LocalPlayer.Character
                                local Humanoid = if Character == nil then nil else Character:FindFirstChildOfClass("Humanoid")

                                if Humanoid ~= nil then
                                    Humanoid:UnequipTools()
                                else
                                    closePhone()
                                end
                            end))
                            t4.Trove:Add(ButtonFX(v106.SwapLeftButton, nil, function() -- line: 745
                                -- upvalues: v106 (copy), t4 (copy), sequencerPreviousSkippingUnplayable (copy), loadVideo (copy)
                                local v115, v116, v117 = sequencerPreviousSkippingUnplayable(t4)

                                if v117 then
                                    loadVideo(v106, t4, v115, v116)
                                end
                            end))
                            t4.Trove:Add(ButtonFX(v106.SwapRightButton, nil, goToNextVideo))
                            t4.Trove:Add(ButtonFX(v106.ShareButton, nil, function() -- line: 752
                                -- upvalues: LocalPlayer (copy), SocialService (copy), TryCall (copy)
                                local v118, v119 = TryCall(SocialService.CanSendGameInviteAsync, SocialService, LocalPlayer)

                                if v118 and v119 then
                                    SocialService:PromptGameInvite(LocalPlayer)
                                end
                            end))
                            t4.Trove:Add(ButtonFX(v106.LikeButton, nil, function() -- line: 758
                                -- upvalues: v106 (copy), t4 (copy), toggleLike (copy)
                                toggleLike(v106, t4)
                            end))
                            t4.Trove:Add(ButtonFX(v106.CommentsButton, nil, function() -- line: 761
                                -- upvalues: v106 (copy)
                                local CommentsPanel = v106.CommentsPanel

                                if CommentsPanel ~= nil then
                                    CommentsPanel.Visible = not CommentsPanel.Visible
                                end
                            end))
                            t4.Trove:Add(function() -- line: 769
                                -- upvalues: v106 (copy)
                                local CommentsPanel = v106.CommentsPanel

                                if CommentsPanel ~= nil then
                                    CommentsPanel.Visible = false
                                end
                            end)
                            task.spawn(function() -- line: 356
                                -- upvalues: v106 (copy), t4 (copy), v8 (copy), t2 (ref), updateSocialPresentation (copy), Remotes (copy), Schema (copy), TryCall (copy)
                                local v120, v121 = TryCall(function() -- line: 357
                                    -- upvalues: Remotes (copy)
                                    return Remotes.Treadmill.AskFavourSnapshot:InvokeServer()
                                end)

                                if not (v120 and Schema.LikeSnapshot(v121)) then
                                    v8:AtWarning():Log("[PhoneVideoController] Could not load the media like snapshot")
                                elseif t2 == t4 then
                                    t4.LikeCountsByMediaKey = table.clone(v121.CountsByMediaLikeKey)
                                    t4.LikedByMediaKey = table.clone(v121.LikedTreadmillMedia)
                                    updateSocialPresentation(v106, t4)
                                end
                            end)
                            t4.Trove:Connect(v106.TapCatcher.Activated, function() -- line: 776
                                -- upvalues: v106 (copy), t4 (copy), sequencerNextSkippingUnplayable (copy), showPausedCard (copy), loadVideo (copy)
                                if t4.EndCardTrove ~= nil then
                                    local v122, v123 = sequencerNextSkippingUnplayable(t4)

                                    loadVideo(v106, t4, v122, v123)
                                elseif v106.Video.Playing then
                                    v106.Video:Pause()
                                    showPausedCard(v106, t4)
                                else
                                    t4.HasPlayed = true

                                    local PausedCardTrove = t4.PausedCardTrove

                                    t4.PausedCardTrove = nil

                                    if PausedCardTrove ~= nil then
                                        PausedCardTrove:Destroy()
                                    end

                                    v106.Paused.Visible = false

                                    local PreviewBaseSize = t4.PreviewBaseSize

                                    t4.PreviewBaseSize = nil

                                    if PreviewBaseSize ~= nil then
                                        v106.Video.Size = PreviewBaseSize
                                    end

                                    v106.Video:Play()
                                end
                            end)
                            t4.Trove:Connect(v106.Video.Ended, function() -- line: 786
                                -- upvalues: v106 (copy), t4 (copy), t2 (ref), showEndCard (copy)
                                if t2 == t4 then
                                    showEndCard(v106, t4)
                                end
                            end)
                            t4.Trove:Connect(RunService.RenderStepped, function() -- line: 791
                                -- upvalues: v106 (copy)
                                local TimeLength = v106.Video.TimeLength

                                if not (TimeLength > 0) then
                                    return
                                end

                                local Size = v106.Progress.Size

                                v106.Progress.Size = UDim2.new(math.clamp(v106.Video.TimePosition / TimeLength, 0, 1), 0, Size.Y.Scale, Size.Y.Offset)
                            end)
                            v106.Video.Looped = false

                            if tween ~= nil then
                                tween:Cancel()
                            end

                            v106.Phone.Position = v106.OffscreenPosition
                            v106.Gui.Enabled = true

                            local tween2 = TweenService:Create(v106.Phone, v6, {
                                Position = v106.OnscreenPosition
                            })

                            tween = tween2
                            tween2:Play()

                            local v125, v126 = FeedSequencer.Current(t4.Feed)
                            local v127 = v60[v125]

                            if v127 == nil or v127.Kind ~= "Video" or v127.Disabled == true or TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v127)) then
                                Remotes.Treadmill.RefreshClipCursor:FireServer(v126)
                                v125, v126 = sequencerNextSkippingUnplayable(t4)
                            end

                            loadVideo(v106, t4, v125, v126)
                        end
                    else
                        v8:AtWarning():Log("[PhoneVideoController] Save data is not loaded yet")
                    end
                end
            end
        end

        local function isPhoneEnabled() -- line: 826
            -- upvalues: TreadmillFlags (copy)
            return TreadmillFlags.PhoneEnabled:Get()
        end

        local function bindPhoneTool(p40) -- line: 830
            -- upvalues: LocalPlayer (copy), closePhone (copy), openPhone (copy), TreadmillFlags (copy)
            if not p40:IsA("Tool") then
                return
            end

            p40.Equipped:Connect(function() -- line: 835
                -- upvalues: p40 (copy), LocalPlayer (copy), openPhone (copy), TreadmillFlags (copy)
                if TreadmillFlags.PhoneEnabled:Get() and p40.Parent == LocalPlayer.Character then
                    openPhone()
                end
            end)
            p40.Unequipped:Connect(closePhone)

            if TreadmillFlags.PhoneEnabled:Get() and LocalPlayer.Character ~= nil and p40.Parent == LocalPlayer.Character then
                openPhone()
            end
        end

        CollectionService:GetInstanceAddedSignal("PhoneTool"):Connect(bindPhoneTool)

        for _, v128 in CollectionService:GetTagged("PhoneTool") do
            bindPhoneTool(v128)
        end

        LocalPlayer.CharacterRemoving:Connect(function() -- line: 855
            -- upvalues: v11 (ref), closePhone (copy)
            local v129 = v11

            v11 = nil

            if v129 ~= nil then
                v129:Destroy()
            end

            closePhone()
        end)

        local function buildEquipHintArrow(p41) -- line: 860
            local Frame = Instance.new("Frame")

            Frame.Name = "PhoneEquipHint"
            Frame.AnchorPoint = Vector2.new(0.5, 1)
            Frame.BackgroundTransparency = 1
            Frame.Size = UDim2.fromScale(0.7, 0.7)
            Frame.Visible = false
            Frame.ZIndex = 30
            p41:Add(Frame)

            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Arrow"
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
            ImageLabel.Size = UDim2.fromScale(1, 1)
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = "rbxassetid://107875622740177"
            ImageLabel.ScaleType = Enum.ScaleType.Fit
            ImageLabel.Rotation = 90
            ImageLabel.ZIndex = 31
            ImageLabel.Parent = Frame
            Instance.new("UIAspectRatioConstraint").Parent = ImageLabel

            return Frame
        end

        local function showEquipHint() -- line: 888
            -- upvalues: Main (copy), v11 (ref), resolvePhoneUi (copy), buildEquipHintArrow (copy), RunService (copy), TreadmillFlags (copy), Trove (copy)
            if v11 == nil and TreadmillFlags.PhoneEnabled:Get() and resolvePhoneUi() ~= nil then
                local v130 = Trove.new()

                v11 = v130

                local v131 = buildEquipHintArrow(v130)

                v130:Connect(RunService.RenderStepped, function() -- line: 905
                    -- upvalues: v131 (copy), Main (copy)
                    local PhoneSlotFrame = Main:GetPhoneSlotFrame()

                    if PhoneSlotFrame ~= nil then
                        if v131.Parent ~= PhoneSlotFrame then
                            v131.Parent = PhoneSlotFrame
                        end

                        v131.Visible = true

                        local v133 = math.sin(os.clock() * 3.141592653589793 * 2 / 0.9) * 6

                        v131.Position = UDim2.new(0.5, 0, 0, v133 - 10)
                    else
                        v131.Visible = false
                    end
                end)
            end
        end

        TreadmillFlags.PhoneEnabled.Changed:Connect(function(p42) -- line: 920
            -- upvalues: v11 (ref), closePhone (copy)
            if p42 then
                return
            end

            local v134 = v11

            v11 = nil

            if v134 ~= nil then
                v134:Destroy()
            end

            closePhone()
        end)
        Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p43) -- line: 927
            -- upvalues: v11 (ref), v12 (ref), showEquipHint (copy), Save (copy)
            if p43 ~= nil then
                local v136 = Save.Await()

                if not v12 and v136 ~= nil and v136.HasRiddenTreadmill == true and v136.HasEquippedPhone ~= true then
                    showEquipHint()
                end
            else
                local v135 = v11

                v11 = nil

                if v135 ~= nil then
                    v135:Destroy()
                end
            end
        end)
    end
}
