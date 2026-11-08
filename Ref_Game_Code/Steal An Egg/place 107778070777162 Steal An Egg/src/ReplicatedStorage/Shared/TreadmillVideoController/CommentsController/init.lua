-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local CommentRenderer = require(script.CommentRenderer)
local GUI = require(ReplicatedStorage.Client.GUI)
local Log = require(ReplicatedStorage.Packages.Log)
local Media = require(script.Parent.Media)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PhotoInputController = require(script.PhotoInputController)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local TreadmillFlags = require(ReplicatedStorage.Shared.Flags.TreadmillFlags)
local TreadmillMediaCommentsConfig = require(ReplicatedStorage.Shared.Modules.TreadmillMediaCommentsConfig)
local TreadmillMediaIdentity = require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity)

require(ReplicatedStorage.Shared.TreadmillVideoController.Types.Interface)

local Trove = require(ReplicatedStorage.Packages.Trove)

require(script.Types.Interface)
require(ReplicatedStorage.Client.VideoComments.Types.Interface)

local VideoComments = require(ReplicatedStorage.Client.VideoComments)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local v1 = Color3.fromRGB(232, 158, 158)
local v2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = UDim2.fromScale(0.98, 0.65)
local v4 = Log.new()
local t1 = {}
local v5, Content, BackgroundColor3
local v6 = false
local t2 = {}
local TextInput, tween
local v7 = false
local v8 = false
local v9 = false
local v10 = ""
local v11
local n1 = 1
local n2 = 0
local NoComments
local t3 = {}
local v12
local t4 = {}
local n3 = 0
local Comment_01

local function v13(_) -- line: 66
end

local CommentsCount, CommentsTemplate
local n4 = 0
local v14

local function v15() -- line: 71
end

local t5 = {}

local function trim(p2) -- line: 80
    return p2:match("^%s*(.-)%s*$") or ""
end

local function characterCount(p3) -- line: 82
    local v16 = utf8.len(p3)

    assert(v16 ~= nil, "Comment text must contain valid UTF-8")

    return v16
end

local function showTooLongNotification() -- line: 88
    -- upvalues: Toast (copy)
    Toast.Show({
        Lane = "Banner",
        Text = "Your message is too long, please make it shorter!",
        Seconds = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    })
end

local function showAlreadyCommentedNotification() -- line: 98
    -- upvalues: Toast (copy)
    Toast.Show({
        Lane = "Banner",
        Text = "You already commented this video.",
        Seconds = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    })
end

local function showInvalidImageNotification() -- line: 108
    -- upvalues: Toast (copy)
    Toast.Show({
        Lane = "Banner",
        Text = "Invalid image, please upload another image.",
        Seconds = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    })
end

local function showImageLookupFailedNotification() -- line: 118
    -- upvalues: Toast (copy)
    Toast.Show({
        Lane = "Banner",
        Text = "Something went wrong, please try again later.",
        Seconds = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    })
end

local function showPostRateLimitNotification() -- line: 128
    -- upvalues: Toast (copy)
    Toast.Show({
        Lane = "Banner",
        Text = "You're doing this too fast, please wait a bit.",
        Seconds = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    })
end

local function showFilteredCommentNotification() -- line: 138
    -- upvalues: Toast (copy)
    Toast.Show({
        Lane = "Banner",
        Text = "Your comment was filtered, please try another message!",
        Seconds = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    })
end

local function isRateLimitError(p4) -- line: 148
    if p4 == "You're doing that too fast!" then
        return true
    end

    return p4 == "You're on cooldown. Please try again later."
end

local function formatCommentsTitle(p5) -- line: 152
    -- upvalues: Simple (copy)
    if p5 == 1 then
        return "1 comment"
    end

    return (("%* comments"):format((Simple.FormatCompact(p5, ".#"))))
end

local function projectCount(p6) -- line: 158
    -- upvalues: Simple (copy), CommentsCount (ref), CommentsTemplate (ref), n4 (ref)
    n4 = math.max(0, p6)

    local CommentsCount2 = CommentsCount

    CommentsCount2.Text = Simple.FormatCompact(n4, ".#")

    local Title = CommentsTemplate.Sheet.Header.Content.SubContent.Title
    local v18 = n4

    if v18 == 1 then
        Title.Text = "1 comment"
    else
        Title.Text = ("%* comments"):format((Simple.FormatCompact(v18, ".#")))
    end
end

local function updateEmptyState() -- line: 164
    -- upvalues: Content (ref), v8 (ref), NoComments (ref), t4 (copy)
    local v19 = next(t4) == nil and not v8
    local Content2 = Content

    Content2.Visible = not v19
    NoComments.Visible = v19
end

local function clearRows() -- line: 170
    -- upvalues: t1 (copy), Content (ref), n1 (ref), n2 (ref), t3 (copy), t4 (copy)
    for v20, v21 in t4 do
        v21.Destroy()
        t4[v20] = nil
    end

    table.clear(t1)
    table.clear(t3)
    n1 = 1
    n2 = 0

    local Content2 = Content

    Content2.CanvasPosition = Vector2.zero
end

local function renderComment(p7, p8) -- line: 183
    -- upvalues: CommentRenderer (copy), t1 (copy), Content (ref), t4 (copy), Comment_01 (ref), t5 (copy)
    if t4[p7.Id] == nil then
        t1[p7.Id] = p7
        t4[p7.Id] = CommentRenderer.Create(Comment_01, Content, p7, p8, t5.ToggleLike)
    end
end

local function requestPage() -- line: 198
    -- upvalues: CommentRenderer (copy), TreadmillMediaCommentsConfig (copy), VideoComments (copy), v4 (copy), t1 (copy), Content (ref), v6 (ref), v7 (ref), v8 (ref), v10 (ref), v11 (ref), n1 (ref), NoComments (ref), t4 (copy), n3 (ref), Comment_01 (ref), t5 (copy)
    local v22, v23

    if not v7 or v8 then
        v23 = true
    elseif not v6 or v11 == nil or v10 == "" then
        v23 = true
    else
        v8 = true
        v22 = next(t4) == nil and not v8
        v23 = false
    end

    if v23 then
        return
    end

    local Content2 = Content

    Content2.Visible = not v22
    NoComments.Visible = v22

    local v24 = v11
    local v25 = n3
    local v26 = v10

    task.spawn(function() -- line: 208
        -- upvalues: v24 (copy), v25 (copy), v26 (copy), CommentRenderer (copy), TreadmillMediaCommentsConfig (copy), VideoComments (copy), v4 (copy), t1 (copy), Content (ref), v6 (ref), v7 (ref), v8 (ref), v11 (ref), n1 (ref), NoComments (ref), t4 (copy), n3 (ref), Comment_01 (ref), t5 (copy)
        local v27 = VideoComments.RequestCommentPage(v26, v24, TreadmillMediaCommentsConfig.COMMENT_PAGE_SIZE)

        if v7 and v25 == n3 then
            v8 = false

            if v27.Ok then
                VideoComments.ReconcileCommentCount(v26, v27.TotalCreatedCount)

                for _, v28 in v27.Comments do
                    local v29 = n1

                    if t4[v28.Id] == nil then
                        t1[v28.Id] = v28
                        t4[v28.Id] = CommentRenderer.Create(Comment_01, Content, v28, v29, t5.ToggleLike)
                    end

                    n1 += 1
                end

                v11 = v27.NextCursor
                v6 = v27.NextCursor ~= nil

                local v30 = next(t4) == nil and not v8

                Content.Visible = not v30
                NoComments.Visible = v30
            else
                v6 = false
                v11 = nil

                local v31 = next(t4) == nil and not v8

                Content.Visible = not v31
                NoComments.Visible = v31
                v4:AtTrace():Log((("Unable to load treadmill comments: %*"):format(v27.Error)))
            end
        end
    end)
end

local function requestInitialPage() -- line: 239
    -- upvalues: v6 (ref), v8 (ref), v11 (ref), n3 (ref), requestPage (copy)
    n3 += 1
    v11 = 0
    v6 = true
    v8 = false
    requestPage()
end

local function updateInputLimitPresentation() -- line: 247
    -- upvalues: TweenService (copy), TreadmillMediaCommentsConfig (copy), v1 (copy), v2 (copy), BackgroundColor3 (ref), TextInput (ref), tween (ref)
    local Text = TextInput.Text
    local v32 = utf8.len(Text)

    assert(v32 ~= nil, "Comment text must contain valid UTF-8")

    local v34 = if TreadmillMediaCommentsConfig.MAX_COMMENT_CHARACTERS <= v32 then v1 else BackgroundColor3

    if tween ~= nil then
        tween:Cancel()
    end

    local tween2 = TweenService:Create(TextInput, v2, {
        BackgroundColor3 = v34
    })

    tween = tween2
    tween2:Play()
end

local function postComment() -- line: 262
    -- upvalues: CommentRenderer (copy), Toast (copy), TreadmillMediaCommentsConfig (copy), VideoComments (copy), v4 (copy), t1 (copy), Content (ref), t2 (copy), TextInput (ref), v8 (ref), v9 (ref), v10 (ref), n2 (ref), NoComments (ref), v12 (ref), t4 (copy), n3 (ref), Comment_01 (ref), n4 (ref), v15 (ref), t5 (copy)
    if v9 or v10 == "" then
        return
    end

    if t2[v10] then
        Toast.Show({
            Lane = "Banner",
            Text = "You already commented this video.",
            Seconds = 3,
            ShowShadow = true,
            Color = Color3.new(1, 1, 1)
        })
    else
        v15()

        local Text = TextInput.Text
        local v35 = utf8.len(Text)

        assert(v35 ~= nil, "Comment text must contain valid UTF-8")

        if TreadmillMediaCommentsConfig.MAX_COMMENT_CHARACTERS < v35 then
            Toast.Show({
                Lane = "Banner",
                Text = "Your message is too long, please make it shorter!",
                Seconds = 3,
                ShowShadow = true,
                Color = Color3.new(1, 1, 1)
            })
        else
            local v37 = Text:match("^%s*(.-)%s*$") or ""
            local ImageAssetId = v12:GetImageAssetId()

            if v37 ~= "" or ImageAssetId ~= nil then
                v9 = true

                local v38 = n3
                local v39 = v10

                task.spawn(function() -- line: 288
                    -- upvalues: v37 (copy), ImageAssetId (copy), v38 (copy), v39 (copy), CommentRenderer (copy), Toast (copy), VideoComments (copy), v4 (copy), t1 (copy), Content (ref), t2 (copy), TextInput (ref), v8 (ref), v9 (ref), n2 (ref), NoComments (ref), v12 (ref), t4 (copy), n3 (ref), Comment_01 (ref), n4 (ref), t5 (copy)
                    local v40 = VideoComments.PostComment(v39, v37, ImageAssetId)

                    if v38 == n3 then
                        v9 = false

                        if v40.Ok then
                            t2[v39] = true
                            TextInput.Text = ""
                            v12:Reset()
                            n2 -= 1

                            local Comment = v40.Comment
                            local v41 = n2

                            if t4[Comment.Id] == nil then
                                t1[Comment.Id] = Comment
                                t4[Comment.Id] = CommentRenderer.Create(Comment_01, Content, Comment, v41, t5.ToggleLike)
                            end

                            VideoComments.ReconcileCommentCount(v39, n4 + 1)

                            local v42 = next(t4) == nil and not v8

                            Content.Visible = not v42
                            NoComments.Visible = v42
                            Content.CanvasPosition = Vector2.zero
                        else
                            if v40.Error == "AlreadyCommented" then
                                t2[v39] = true
                                Toast.Show({
                                    Lane = "Banner",
                                    Text = "You already commented this video.",
                                    Seconds = 3,
                                    ShowShadow = true,
                                    Color = Color3.new(1, 1, 1)
                                })
                            elseif v40.Error == "MessageFiltered" then
                                Toast.Show({
                                    Lane = "Banner",
                                    Text = "Your comment was filtered, please try another message!",
                                    Seconds = 3,
                                    ShowShadow = true,
                                    Color = Color3.new(1, 1, 1)
                                })
                            elseif v40.Error == "InvalidImageAssetId" then
                                Toast.Show({
                                    Lane = "Banner",
                                    Text = "Invalid image, please upload another image.",
                                    Seconds = 3,
                                    ShowShadow = true,
                                    Color = Color3.new(1, 1, 1)
                                })
                            elseif v40.Error == "ImageAssetLookupFailed" then
                                Toast.Show({
                                    Lane = "Banner",
                                    Text = "Something went wrong, please try again later.",
                                    Seconds = 3,
                                    ShowShadow = true,
                                    Color = Color3.new(1, 1, 1)
                                })
                            else
                                local Error = v40.Error

                                if Error == "You're doing that too fast!" or Error == "You're on cooldown. Please try again later." then
                                    Toast.Show({
                                        Lane = "Banner",
                                        Text = "You're doing this too fast, please wait a bit.",
                                        Seconds = 3,
                                        ShowShadow = true,
                                        Color = Color3.new(1, 1, 1)
                                    })
                                end
                            end

                            v4:AtTrace():Log((("Unable to post treadmill comment: %*"):format(v40.Error)))
                        end
                    end
                end)
            end
        end
    end
end

local function open() -- line: 324
    -- upvalues: TreadmillFlags (copy), Content (ref), v6 (ref), v7 (ref), v8 (ref), v10 (ref), v11 (ref), NoComments (ref), t4 (copy), n3 (ref), v13 (ref), CommentsTemplate (ref), v15 (ref), clearRows (copy), requestPage (copy)
    if not v7 and v10 ~= "" and not TreadmillFlags.CommentsDisabled:Get() then
        v15()
        v7 = true
        CommentsTemplate.Visible = true
        v13(false)
        clearRows()

        local v43 = next(t4) == nil and not v8
        local Content2 = Content

        Content2.Visible = not v43
        NoComments.Visible = v43
        n3 += 1
        v11 = 0
        v6 = true
        v8 = false
        requestPage()
    end
end

local function handleScroll() -- line: 338
    -- upvalues: Content (ref), v6 (ref), v7 (ref), requestPage (copy)
    if v7 and v6 and Content.AbsoluteCanvasSize.Y - Content.CanvasPosition.Y - Content.AbsoluteWindowSize.Y <= 64 then
        requestPage()
    end
end

local function handleMediaChanged(p9, p10) -- line: 351
    -- upvalues: Simple (copy), TreadmillFlags (copy), TreadmillMediaIdentity (copy), VideoComments (copy), v5 (ref), v10 (ref), CommentsCount (ref), CommentsTemplate (ref), n4 (ref), t5 (copy)
    local v44 = TreadmillMediaIdentity.GetMediaKey(p9)

    t5.Close()
    v5.Adornee = p10
    v5.Enabled = not TreadmillFlags.CommentsDisabled:Get()
    v10 = v44
    n4 = math.max(0, VideoComments.GetCachedCommentCount(v44) or 0)
    CommentsCount.Text = Simple.FormatCompact(n4, ".#")

    local Title = CommentsTemplate.Sheet.Header.Content.SubContent.Title
    local v47 = n4

    if v47 == 1 then
        Title.Text = "1 comment"
    else
        Title.Text = ("%* comments"):format((Simple.FormatCompact(v47, ".#")))
    end
end

function t5.ToggleLike(p11) -- line: 367
    -- upvalues: VideoComments (copy), t1 (copy), v10 (ref), t3 (copy), t4 (copy), n3 (ref), v15 (ref)
    if t3[p11] then
        return
    end

    local v48 = t1[p11]
    local v49 = t4[p11]

    assert(v48 ~= nil and v49 ~= nil, (("Missing rendered comment %*"):format(p11)))
    v15()
    t3[p11] = true

    local LikedByViewer, LikeCount = v48.LikedByViewer, v48.LikeCount
    local v52 = not LikedByViewer

    v48.LikedByViewer = v52
    v48.LikeCount = math.max(0, LikeCount + (if v52 then 1 else -1))
    v49.UpdateLike(v48.LikedByViewer, v48.LikeCount)

    local v55 = n3
    local v56 = v10

    task.spawn(function() -- line: 387
        -- upvalues: p11 (copy), LikedByViewer (copy), LikeCount (copy), v52 (copy), v55 (copy), v56 (copy), VideoComments (copy), t1 (copy), t3 (copy), t4 (copy), n3 (ref)
        local v57 = VideoComments.SetCommentLike(v56, p11, v52)

        if v55 ~= n3 then
            return
        end

        t3[p11] = nil

        local v58 = t1[p11]
        local v59 = t4[p11]

        if v58 ~= nil and v59 ~= nil then
            if v57.Ok then
                v58.LikedByViewer = v57.Liked
                v58.LikeCount = math.max(0, v57.LikeCount)
            else
                v58.LikedByViewer = LikedByViewer
                v58.LikeCount = LikeCount
            end

            v59.UpdateLike(v58.LikedByViewer, v58.LikeCount)
        end
    end)
end

function t5.Close() -- line: 411
    -- upvalues: Content (ref), v6 (ref), TextInput (ref), v7 (ref), v8 (ref), v9 (ref), v11 (ref), NoComments (ref), v12 (ref), t4 (copy), n3 (ref), v13 (ref), CommentsTemplate (ref), clearRows (copy)
    n3 += 1
    v7 = false
    v8 = false
    v9 = false
    v6 = false
    v11 = nil
    CommentsTemplate.Visible = false
    v13(true)
    TextInput.Text = ""
    v12:Reset()
    clearRows()

    local v60 = next(t4) == nil and not v8

    Content.Visible = not v60
    NoComments.Visible = v60
end

function t5.IsAvailable() -- line: 426
    -- upvalues: TreadmillFlags (copy), v14 (ref)
    return v14 ~= nil and not TreadmillFlags.CommentsDisabled:Get()
end

function t5.Toggle() -- line: 430
    -- upvalues: TreadmillFlags (copy), Content (ref), v6 (ref), v7 (ref), v8 (ref), v10 (ref), v11 (ref), NoComments (ref), t4 (copy), n3 (ref), v13 (ref), CommentsTemplate (ref), v14 (ref), v15 (ref), t5 (copy), clearRows (copy), requestPage (copy)
    if v14 ~= nil then
        if v7 then
            v15()
            t5.Close()
        elseif not v7 and v10 ~= "" then
            if TreadmillFlags.CommentsDisabled:Get() then
                return
            end

            v15()
            v7 = true
            CommentsTemplate.Visible = true
            v13(false)
            clearRows()

            local v61 = next(t4) == nil and not v8

            Content.Visible = not v61
            NoComments.Visible = v61
            n3 += 1
            v11 = 0
            v6 = true
            v8 = false
            requestPage()
        end
    end
end

function t5.Deactivate() -- line: 444
    -- upvalues: Simple (copy), v5 (ref), v10 (ref), CommentsCount (ref), CommentsTemplate (ref), n4 (ref), t5 (copy)
    t5.Close()
    v10 = ""
    v5.Enabled = false
    n4 = 0
    CommentsCount.Text = Simple.FormatCompact(n4, ".#")

    local Title = CommentsTemplate.Sheet.Header.Content.SubContent.Title
    local v62 = n4

    if v62 == 1 then
        Title.Text = "1 comment"
    else
        Title.Text = ("%* comments"):format((Simple.FormatCompact(v62, ".#")))
    end
end

function t5.Start(p12) -- line: 451
    -- upvalues: Players (copy), TextChatService (copy), ButtonFX (copy), GUI (copy), Media (copy), PhotoInputController (copy), Simple (copy), TreadmillFlags (copy), TreadmillMediaIdentity (copy), Trove (copy), VideoComments (copy), TryCall (copy), v3 (copy), v5 (ref), Content (ref), BackgroundColor3 (ref), TextInput (ref), v8 (ref), v10 (ref), NoComments (ref), v12 (ref), t4 (copy), Comment_01 (ref), v13 (ref), CommentsCount (ref), CommentsTemplate (ref), n4 (ref), v14 (ref), v15 (ref), t5 (copy), updateInputLimitPresentation (copy), postComment (copy), open (copy), handleScroll (copy), handleMediaChanged (copy)
    assert(v14 == nil, "Treadmill comments controller must only start once")

    local CommentsButton = GUI.TreadmillScreenSideButtons().Frame.Buttons.CommentsButton
    local v64 = GUI.TreadmillScreenButtonShare()

    assert(v64:IsA("SurfaceGui"), "Treadmill share GUI must be a SurfaceGui")

    local ShareButton = v64.Frame.ShareButton

    assert(CommentsButton:IsA("GuiButton"), "Treadmill comments button must be a GuiButton")
    assert(ShareButton:IsA("GuiButton"), "Treadmill share button must be a GuiButton")

    local v65, v66 = TryCall(TextChatService.CanUserChatAsync, TextChatService, Players.LocalPlayer.UserId)

    CommentsButton.Visible = v65 and v66 == true

    if not CommentsButton.Visible then
        ShareButton.Position = v3

        return
    end

    v13 = p12.SetShareButtonVisible
    v15 = p12.SuppressScreenTap
    v5 = GUI.TreadmillScreenComments()
    CommentsTemplate = v5.Frame.CommentsTemplate
    Content = CommentsTemplate.Sheet.Content
    Comment_01 = Content.Comment_01
    TextInput = CommentsTemplate.Sheet.Actions.Content.TextInputWrapper.TextInput
    assert(v5:IsA("SurfaceGui"), "Treadmill comments GUI must be a SurfaceGui")
    assert(Content:IsA("ScrollingFrame"), "Treadmill comments content must be a ScrollingFrame")
    assert(Comment_01:IsA("Frame"), "Treadmill comments row template must be a Frame")
    assert(CommentsButton.CommentsCount:IsA("TextLabel"), "Treadmill comments count must be a TextLabel")
    BackgroundColor3 = TextInput.BackgroundColor3
    NoComments = CommentsTemplate.Sheet.NoComments
    v12 = PhotoInputController.new(CommentsTemplate, v15)
    CommentsCount = CommentsButton.CommentsCount
    v14 = Trove.new()

    for _, child in Content:GetChildren() do
        if child:IsA("Frame") and child.Name:match("^Comment_%d+$") then
            if child.Name == "Comment_01" then
                child.Visible = false
            else
                child:Destroy()
            end
        end
    end

    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v5.Enabled = false
    CommentsTemplate.Visible = false
    CommentsTemplate.Overlay.Active = true
    CommentsTemplate.AddPhoto.Visible = false

    local v67 = v14

    assert(v67 ~= nil, "Treadmill comments trove must exist after startup")
    v67:Add(ButtonFX(CommentsButton, nil, open))
    v67:Add(ButtonFX(CommentsTemplate.Sheet.Header.Content.Close, nil, function() -- line: 510
        -- upvalues: v15 (ref), t5 (copy)
        v15()
        t5.Close()
    end))
    v67:Connect(CommentsTemplate.Overlay.InputBegan, function(p13) -- line: 514
        -- upvalues: CommentsTemplate (ref), v15 (ref), t5 (copy)
        if (p13.UserInputType == Enum.UserInputType.MouseButton1 or p13.UserInputType == Enum.UserInputType.Touch) and p13.Position.Y < CommentsTemplate.Sheet.AbsolutePosition.Y then
            v15()
            t5.Close()
        end
    end)
    v67:Add(ButtonFX(CommentsTemplate.Sheet.Actions.Content.Send, nil, postComment))
    v67:Connect(TextInput:GetPropertyChangedSignal("Text"), updateInputLimitPresentation)
    v67:Connect(Content:GetPropertyChangedSignal("CanvasPosition"), handleScroll)
    v67:Add(p12.MediaChanged:Connect(handleMediaChanged))
    v67:Add(p12.Stopped:Connect(t5.Deactivate))
    v67:Add(VideoComments.CommentCountChanged:Connect(function(p14, p15) -- line: 530
        -- upvalues: Simple (copy), v10 (ref), CommentsCount (ref), CommentsTemplate (ref), n4 (ref)
        if p14 ~= v10 then
            return
        end

        n4 = math.max(0, p15)
        CommentsCount.Text = Simple.FormatCompact(n4, ".#")

        local Title = CommentsTemplate.Sheet.Header.Content.SubContent.Title
        local v69 = n4

        if v69 == 1 then
            Title.Text = "1 comment"
        else
            Title.Text = ("%* comments"):format((Simple.FormatCompact(v69, ".#")))
        end
    end))

    local ShareButtonPosition = ShareButton.Position

    local function applyCommentsDisabledFlag() -- line: 537
        -- upvalues: CommentsButton (copy), ShareButton (copy), ShareButtonPosition (copy), TreadmillFlags (copy), v3 (copy), v5 (ref), v10 (ref), t5 (copy)
        local v70 = TreadmillFlags.CommentsDisabled:Get()

        CommentsButton.Visible = not v70
        ShareButton.Position = if v70 then v3 else ShareButtonPosition

        if v70 then
            t5.Close()
            v5.Enabled = false
        elseif v10 ~= "" then
            v5.Enabled = true
        end
    end

    v67:Add(TreadmillFlags.CommentsDisabled.Changed:Connect(applyCommentsDisabledFlag))

    local v72 = TreadmillFlags.CommentsDisabled:Get()

    CommentsButton.Visible = not v72
    ShareButton.Position = if v72 then v3 else ShareButtonPosition

    if v72 then
        t5.Close()
        v5.Enabled = false
    elseif v10 ~= "" then
        v5.Enabled = true
    end

    local v74 = TreadmillMediaIdentity.BuildMediaKeys(Media)

    VideoComments.StartCommentCountCache(v74)
    n4 = 0
    CommentsCount.Text = Simple.FormatCompact(n4, ".#")

    local Title = CommentsTemplate.Sheet.Header.Content.SubContent.Title
    local v75 = n4

    if v75 == 1 then
        Title.Text = "1 comment"
    else
        Title.Text = ("%* comments"):format((Simple.FormatCompact(v75, ".#")))
    end

    local v76 = next(t4) == nil and not v8

    Content.Visible = not v76
    NoComments.Visible = v76
end

return t5
