-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ContextActionService = game:GetService("ContextActionService")
local SocialService = game:GetService("SocialService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local PromptLook = require(Modules:WaitForChild("PromptLook"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local RewardScreen = require(Modules:WaitForChild("RewardScreen"))
local KeyConfig = require(Modules:WaitForChild("KeyConfig"))
local Loc = require(Modules:WaitForChild("Loc"))
local DuhbbyKey = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DuhbbyKey")
local t1 = {
    COPIES = 4,
    VOLUME = 0.5,
    IDS = { "rbxassetid://99462344391311", "rbxassetid://84651254035271" },
    PITCH = { 0.96, 1.04 }
}
local t2 = {}
local n1 = 1

for _, v1 in ipairs(t1.IDS) do
    for _ = 1, t1.COPIES do
        local Sound = Instance.new("Sound")

        Sound.Name = "DuhbbyVoice"
        Sound.SoundId = v1
        Sound.Volume = t1.VOLUME
        Sound.Parent = game:GetService("SoundService")
        t2[#t2 + 1] = Sound
    end
end

task.spawn(function() -- line: 66
    -- upvalues: t2 (copy)
    game:GetService("ContentProvider"):PreloadAsync(t2)
end)

local v2 = Random.new()

local function speakLetter() -- line: 68
    -- upvalues: t1 (copy), t2 (copy), n1 (ref), v2 (copy)
    local v4 = t2[v2:NextInteger(0, #t1.IDS - 1) * t1.COPIES + n1]
    local v5 = n1

    n1 = v5 % t1.COPIES + 1
    v4.PlaybackSpeed = v2:NextNumber(t1.PITCH[1], t1.PITCH[2])
    v4.TimePosition = 0
    v4:Play()
end

local StrandedRaft = workspace:WaitForChild("StrandedRaft")
local Duhbby = StrandedRaft:WaitForChild("Duhbby")

Duhbby:WaitForChild("HumanoidRootPart")

local TalkPoint = StrandedRaft:WaitForChild("Root"):WaitForChild("TalkPoint")
local DuhbbyPrompt = TalkPoint:WaitForChild("DuhbbyPrompt")
local Panel = PlayerGui:WaitForChild("FeedbackGui"):WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local Send = Panel:WaitForChild("Send")
local Close = Panel:WaitForChild("Main"):WaitForChild("Close")
local rad = math.rad
local t3 = {
    start = {
        say = "Who... who are you!!??",
        replies = {
            { "idk bruh who are you", "story" },
            { "go away you're weird", "bye" }
        }
    },
    story = {
        say = "I own these waters, been trapped here for eons...",
        replies = {
            { "you're weird go away", "bye" },
            { "Whats in the crate?", "crate" }
        }
    },
    crate = {
        say = "Oh that? I found that in one of those treasure chests.",
        replies = {
            { "oh hey thats cool. btw its my birthday today", "bday" },
            { "ok get away from me", "bye" }
        }
    },
    bday = {
        say = "Oh nice. Happy birthday I guess...",
        next = "think"
    },
    think = {
        dots = true,
        replies = {
            { "yeah thats a really cool crate", "cool" },
            { "ok bye", "bye" }
        }
    },
    cool = {
        say = "OK FINE YOU CAN HAVE IT",
        shout = true,
        act = "give",
        next = "deal"
    },
    deal = {
        say = "Wait I'll let you have it if you can help me improve this place. How's that sound?",
        replies = {
            { "YAY SURE!", "help" },
            { "no go away you're weird", "bye" }
        }
    },
    bye = {
        say = "okay bye 😞",
        ends = true
    },
    afterFeedback = {
        say = "I hope you actually wrote something meaningful... there goes my key."
    },
    closedFeedback = {
        say = "ok I guess not..."
    },
    again = {
        say = "Oh its you again!",
        replies = {
            { "Give more feedback", "help" },
            { "So what is this place?", "place" },
            { "Ok bye", "bye" }
        }
    },
    place = {
        say = "idk really... place ain't on any maps. My raft was lost at sea for months then I washed up here... time works weird here. It never seems to get dark for some reason. I think there's something evil going on...",
        replies = {
            { "what do I do?", "whatdo" },
            { "what's in those waters?", "waters" },
            { "bye", "bye" }
        }
    },
    whatdo = {
        say = "Sink deeper and find out what lurks below... there may be a way to escape. I haven't found anything yet though.",
        replies = {
            { "what's in those waters?", "waters" },
            { "bye", "bye" }
        }
    },
    waters = {
        say = "Monstrosities. Almost died trying to document them. Put all the ones I found in a book, but I think I missed a few. Haven't been below the void yet... heard strange noises. I don't want to find out what lives beneath there...",
        replies = { { "I'll find out!!", "findout" } }
    },
    findout = {
        say = "Ha! You're just like the rest of them. They didn't survive either. Goodluck I guess...",
        ends = true
    }
}
local t4 = {
    FIRST = 0.55,
    TYPE = 40,
    READ = 2.4,
    LEAVE = 22,
    UP = 0.38,
    DOWN = 0.42,
    STAGGER = 0.4,
    LOOK = 9,
    REPLY_GAP = 0.08,
    MIN_SCALE = 0.62,
    REPLY_TEXT_H = 0.86,
    NEXT = 0.9,
    BREATH = {
        DEG = 1.6,
        RATE = 1.7
    },
    BUBBLE_POP = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    BUBBLE_OUT = TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
    DOTS = {
        TIME = 1.8,
        STEP = 0.3
    },
    SHOUT = {
        PUNCH = 1.18,
        TIME = 0.28,
        SHAKE = 5
    }
}
local t5 = {
    "Root",
    "Waist",
    "Neck",
    "LeftShoulder",
    "LeftElbow",
    "LeftWrist",
    "RightShoulder",
    "RightElbow",
    "RightWrist",
    "LeftHip",
    "LeftKnee",
    "LeftAnkle",
    "RightHip",
    "RightKnee",
    "RightAnkle"
}
local t6 = {}
local t7 = {}

for _, descendant in ipairs(Duhbby:GetDescendants()) do
    if descendant:IsA("AnimationConstraint") and descendant.Attachment0 and descendant.Attachment1 then
        t6[descendant.Name] = descendant
        t7[descendant.Name] = descendant:GetAttribute("Pose") or descendant.Transform
        descendant.Transform = t7[descendant.Name]
    end
end

local t8 = {}

for _, child in ipairs(Duhbby:GetChildren()) do
    local v6 = child:IsA("Accessory") and child:FindFirstChild("Handle")

    if v6 then
        for _, child in ipairs(v6:GetChildren()) do
            if child:IsA("Attachment") and not t8[v6] then
                for _, child2 in ipairs(Duhbby:GetChildren()) do
                    local BasePart = child2:IsA("BasePart") and child2 ~= v6 and child2:FindFirstChild(child.Name)

                    if BasePart and BasePart:IsA("Attachment") then
                        t8[v6] = {
                            ha = child,
                            ba = BasePart
                        }
                        break
                    end
                end
            end
        end
    end
end

local Act = require(script:WaitForChild("Act"))
local v7 = Act.new({
    char = Duhbby,
    root = StrandedRaft:WaitForChild("Root"),
    crate = StrandedRaft:WaitForChild("SupplyCrate"),
    J = t6,
    REST = t7,
    ORDER = t5,
    fits = t8
})

StrandedRaft = Act.FEEL

local v8 = StrandedRaft.UP + StrandedRaft.WALK + StrandedRaft.BEND + StrandedRaft.LIFT
local v9 = false
local v10
local v11 = table.clone(t7)
local v12 = v7.restHrp
local n2 = 0
local v13 = false
local t9 = {
    Waist = CFrame.Angles(-0.6981317007977318, 0, 0),
    LeftShoulder = CFrame.Angles(-0.6108652381980153, 0, -0.3839724354387525),
    RightShoulder = CFrame.Angles(-0.6108652381980153, 0, 0.3839724354387525),
    LeftElbow = CFrame.Angles(0.3490658503988659, 0, 0),
    RightElbow = CFrame.Angles(0.3490658503988659, 0, 0),
    LeftHip = CFrame.Angles(0.17453292519943295, 0, -0.2792526803190927),
    LeftKnee = CFrame.Angles(-0.24434609527920614, 0, 0),
    LeftAnkle = CFrame.Angles(0.17453292519943295, 0, 0),
    RightHip = CFrame.Angles(0.9599310885968813, 0, 0.20943951023931956),
    RightKnee = CFrame.Angles(-1.4835298641951802, 0, 0),
    RightAnkle = CFrame.Angles(0.4363323129985824, 0, 0)
}
local t10 = {
    Waist = 0,
    Neck = 0.14,
    LeftShoulder = 0.06,
    RightShoulder = 0.1,
    LeftElbow = 0.12,
    RightElbow = 0.16,
    RightHip = 0.18,
    RightKnee = 0.22,
    RightAnkle = 0.26,
    LeftHip = 0.24,
    LeftKnee = 0.28,
    LeftAnkle = 0.3
}
local _ = {
    YAW = 1.2217304763960306,
    PITCH = 0.6108652381980153
}
local t11 = {}
local t12 = {}
local t13 = {}
local t14 = {}

for v14 in pairs(t6) do
    t11[v14] = 0
    t12[v14] = 0
    t13[v14] = 0
    t14[v14] = 0
end

local n3 = 0
local n4 = 0
local v15 = false
local v16

local function neckTarget(p1) -- line: 207
    -- upvalues: LocalPlayer (copy), t4 (copy), t6 (copy), n3 (ref), n4 (ref)
    local Neck = t6.Neck
    local v17 = Neck.Attachment0.Parent.CFrame * Neck.Attachment0.CFrame
    local Character = LocalPlayer.Character
    local Head = Character and Character:FindFirstChild("Head")
    local v18 = v17:PointToObjectSpace(Head and Head.Position or workspace.CurrentCamera.CFrame.Position)
    local v22 = math.clamp(math.atan2(-v18.X, -v18.Z), -1.2217304763960306, 1.2217304763960306)
    local v26 = math.clamp(math.atan2(v18.Y, (math.sqrt(v18.X * v18.X + v18.Z * v18.Z))), -0.6108652381980153, 0.6108652381980153)
    local v28 = 1 - math.exp(-t4.LOOK * p1)
    local v29 = n3

    n3 = v29 + (v22 - n3) * v28

    local v30 = n4

    n4 = v30 + (v26 - n4) * v28

    return CFrame.Angles(0, n3, 0) * CFrame.Angles(n4, 0, 0)
end

local function pose(p2) -- line: 222
    -- upvalues: TweenService (copy), rad (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), Act (copy), v7 (copy), v9 (ref), v10 (ref), v11 (ref), v12 (ref), n2 (ref), t9 (copy), t11 (copy), t12 (copy), t13 (copy), t14 (copy), neckTarget (copy)
    local elapsed = os.clock()

    if v9 then
        local v31 = v7:Sample(elapsed)

        if v31.look then
            v31.T.Neck = neckTarget(p2)
        end

        Act.Apply(v7.ctx, v31.T, v31.hrp, v31.crate)

        local T, hrp, crate = v31.T, v31.hrp, v31.crate

        v11 = T
        v12 = hrp
        n2 = crate

        if v31.done then
            v9 = false

            local v32 = v10

            v10 = nil

            if v32 then
                v32()
            end
        end

        return false
    end

    local v33 = true

    for _, v34 in ipairs(t5) do
        local v35 = t6[v34]

        if v35 then
            local v36 = t11[v34]

            if v36 ~= t13[v34] then
                local v37 = t13[v34] == 1
                local v39 = math.clamp((elapsed - t14[v34]) / (v37 and t4.UP or t4.DOWN), 0, 1)
                local Value = TweenService:GetValue(v39, v37 and Enum.EasingStyle.Back or Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

                v36 = t12[v34] + (t13[v34] - t12[v34]) * Value

                if v39 >= 1 then
                    v36 = t13[v34]
                end

                v33 = false
                t11[v34] = v36
            end

            local v40 = t9[v34]

            if v34 == "Neck" then
                v40 = neckTarget(p2)
            end

            if v34 == "Waist" and v40 then
                v40 *= CFrame.Angles(rad(t4.BREATH.DEG) * math.sin(elapsed * t4.BREATH.RATE), 0, 0)
            end

            local v43 = v40 and t7[v34]:Lerp(v40, v36) or t7[v34]
            local v44 = v11

            v44[v34] = v43
            v35.Transform = v43
            v35.Attachment1.Parent.CFrame = v35.Attachment0.Parent.CFrame * v35.Attachment0.CFrame * v43 * v35.Attachment1.CFrame:Inverse()
        end
    end

    for v45, v46 in pairs(t8) do
        v45.CFrame = v46.ba.Parent.CFrame * v46.ba.CFrame * v46.ha.CFrame:Inverse()
    end

    return v33
end

local function step(p3) -- line: 264
    -- upvalues: v9 (ref), v15 (ref), v16 (ref), pose (copy)
    if not pose(p3) or v15 or v9 then
        return
    end

    v16:Disconnect()
    v16 = nil
end

local function sit(p4) -- line: 273
    -- upvalues: RunService (copy), t4 (copy), t6 (copy), t10 (copy), t11 (copy), t12 (copy), t13 (copy), t14 (copy), n3 (ref), n4 (ref), v16 (ref), step (copy)
    local elapsed = os.clock()

    for v47 in pairs(t6) do
        t12[v47] = t11[v47]
        t13[v47] = p4 and 1 or 0
        t14[v47] = elapsed + (t10[v47] or 0) * t4.STAGGER
    end

    if p4 then
        n3 = 0
        n4 = 0
    end

    v16 = v16 or RunService.RenderStepped:Connect(step)
end

local function play(p5, p6) -- line: 285
    -- upvalues: RunService (copy), v7 (copy), v9 (ref), v10 (ref), v11 (ref), v12 (ref), n2 (ref), v16 (ref), step (copy)
    v7:Play(p5, os.clock(), {
        T = table.clone(v11),
        hrp = v12,
        crate = n2
    })
    v9 = true
    v10 = p6
    v16 = v16 or RunService.RenderStepped:Connect(step)
end

local v48 = Vector2.new(300, 54)
local v49 = Vector2.new(440, 160)
local v50 = Vector2.new(v49.X, v49.Y + 12 + v48.Y * 3 + 20)
local FONT = PromptLook.FONT
local v51 = PromptLook.Billboard(Duhbby:WaitForChild("Head"), "DuhbbyTalkUI", v50, (Vector3.new(0, 0, 0)))

v51.StudsOffsetWorldSpace = Vector3.new(0, 1.4, 0)
v51.SizeOffset = Vector2.new(0, 0.5)

local Frame = Instance.new("Frame")

Frame.Name = "Box"
Frame.AnchorPoint = Vector2.new(0.5, 1)
Frame.Position = UDim2.fromScale(0.5, 1)
Frame.Size = UDim2.fromScale(1, 1)
Frame.BackgroundTransparency = 1
Frame.Parent = v51

local UIScale = Instance.new("UIScale")

UIScale.Parent = Frame

local Frame2 = Instance.new("Frame")

Frame2.Name = "Bubble"
Frame2.AnchorPoint = Vector2.new(0.5, 1)
Frame2.Position = UDim2.new(0.5, 0, 0, v49.Y)
Frame2.Size = UDim2.fromOffset(v49.X, v49.Y)
Frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame2.BackgroundTransparency = 1
Frame2.Parent = Frame
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 18)

local UIScale2 = Instance.new("UIScale")

UIScale2.Scale = 0
UIScale2.Parent = Frame2

local Frame3 = Instance.new("Frame")

Frame3.Name = "Tail"
Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
Frame3.Position = UDim2.fromScale(0.5, 1)
Frame3.Size = UDim2.fromOffset(18, 18)
Frame3.Rotation = 45
Frame3.BackgroundColor3 = Frame2.BackgroundColor3
Frame3.BackgroundTransparency = 1
Frame3.ZIndex = 0
Frame3.Parent = Frame2

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "Name"
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.fromOffset(16, 8)
TextLabel.Size = UDim2.new(1, -32, 0, 22)
TextLabel.FontFace = FONT
TextLabel.TextScaled = true
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
TextLabel.TextTransparency = 1
TextLabel.Text = "itsduhbby"
TextLabel.AutoLocalize = false
TextLabel.Parent = Frame2

local UIStroke = Instance.new("UIStroke")
local UIStroke2 = Color3.new(0, 0, 0)

UIStroke.Thickness = 0.09
UIStroke.Color = UIStroke2
UIStroke.Transparency = 1
UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
UIStroke.Parent = TextLabel

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Name = "Line"
TextLabel2.BackgroundTransparency = 1
TextLabel2.Position = UDim2.fromOffset(16, 32)
TextLabel2.Size = UDim2.new(1, -32, 1, -42)
TextLabel2.FontFace = FONT
TextLabel2.TextScaled = true
TextLabel2.TextWrapped = true
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
TextLabel2.TextColor3 = Color3.new(1, 1, 1)
TextLabel2.TextTransparency = 1
TextLabel2.AutoLocalize = false
TextLabel2.Parent = Frame2
UIStroke2 = Instance.new("UITextSizeConstraint")
UIStroke2.MaxTextSize = 30
UIStroke2.Parent = TextLabel2
UIStroke2 = Instance.new("UIStroke")

local v52 = Color3.new(0, 0, 0)

UIStroke2.Thickness = 0.07
UIStroke2.Color = v52
UIStroke2.Transparency = 1
UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
UIStroke2.Parent = TextLabel2

local t15 = {
    Enum.KeyCode.ButtonA,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonY
}
local t16 = {}
local v53

for i = 1, 3 do
    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Reply" .. i
    Frame2.AnchorPoint = Vector2.new(0.5, 0)
    Frame2.Position = UDim2.new(0.5, 0, 0, v49.Y + 12 + (i - 1) * (v48.Y + 10))
    Frame2.Size = UDim2.fromOffset(v48.X, v48.Y)
    Frame2.BackgroundTransparency = 1
    Frame2.Parent = Frame
    t16[i] = PromptLook.Row(Frame2, v48, function() -- line: 387
        -- upvalues: v53 (ref), i (copy)
        if v53 then
            v53(i)
        end
    end, {
        touch = "TAP",
        pc = tostring(i),
        pad = t15[i]
    })
end

local t17 = {
    { Frame2, "BackgroundTransparency", 0.15 },
    { Frame3, "BackgroundTransparency", 0.15 },
    { TextLabel, "TextTransparency", 0 },
    { UIStroke, "Transparency", 0.3 },
    { TextLabel2, "TextTransparency", 0 },
    { UIStroke2, "Transparency", 0.3 }
}

local function bubbleShown(p7, p8) -- line: 392
    -- upvalues: TweenService (copy), UIScale2 (copy), t17 (copy)
    for _, v54 in ipairs(t17) do
        local t18 = {}

        t18[v54[2]] = p7 and v54[3] or 1
        TweenService:Create(v54[1], p8, t18):Play()
    end

    TweenService:Create(UIScale2, p8, {
        Scale = p7 and 1 or 0
    }):Play()
end

local n5 = 0
local v55 = false
local v56 = false
local connection, v57
local t20 = {
    Enum.KeyCode.One,
    Enum.KeyCode.Two,
    Enum.KeyCode.Three
}
local t21 = {
    Enum.KeyCode.KeypadOne,
    Enum.KeyCode.KeypadTwo,
    Enum.KeyCode.KeypadThree
}

local function bindKeys(p9) -- line: 411
    -- upvalues: ContextActionService (copy), t15 (copy), v53 (ref), t20 (copy), t21 (copy)
    for i = 1, 3 do
        local v58 = "DuhbbyReply" .. i

        if i <= p9 then
            ContextActionService:BindActionAtPriority(v58, function(_, p11) -- line: 416
                -- upvalues: i (copy), v53 (ref)
                if p11 == Enum.UserInputState.Begin and v53 then
                    v53(i)
                end

                return Enum.ContextActionResult.Sink
            end, false, Enum.ContextActionPriority.High.Value + 100, t20[i], t21[i], t15[i])
        else
            ContextActionService:UnbindAction(v58)
        end
    end
end

local n6 = 0

local function hideReplies() -- line: 427
    -- upvalues: PromptLook (copy), t16 (copy), v55 (ref), bindKeys (copy), n6 (ref)
    if not v55 then
        return
    end

    v55 = false
    bindKeys(0)

    local v59 = n6

    for i = 1, v59 do
        PromptLook.Hide(t16[i])
    end

    n6 = 0
end

local function showReplies(p12) -- line: 435
    -- upvalues: PromptLook (copy), t4 (copy), t16 (copy), n5 (ref), v55 (ref), bindKeys (copy), n6 (ref)
    v55 = true
    n6 = math.min(#p12, 3)

    local v61 = n5
    local v62 = n6

    for i = 1, v62 do
        task.delay((i - 1) * t4.REPLY_GAP, function() -- line: 440
            -- upvalues: p12 (copy), v61 (copy), i (copy), PromptLook (copy), t4 (copy), t16 (copy), n5 (ref), v55 (ref)
            if n5 == v61 and v55 then
                PromptLook.Show(t16[i], p12[i][1], nil, 1)
                t16[i].top.Size = UDim2.new(1, -t16[i].left, t4.REPLY_TEXT_H, 0)
            end
        end)
    end

    bindKeys(n6)
end

local function say(p13, p14) -- line: 451
    -- upvalues: RunService (copy), Loc (copy), speakLetter (copy), t4 (copy), UIScale2 (copy), TextLabel2 (copy), bubbleShown (copy), n5 (ref)
    local v63 = p13
    local v64 = n5
    local v65 = Loc.T(p13)

    v63 = v65
    TextLabel2.Text = v65
    TextLabel2.MaxVisibleGraphemes = 0

    if UIScale2.Scale < 0.5 then
        bubbleShown(true, t4.BUBBLE_POP)
    end

    task.spawn(function() -- line: 457
        -- upvalues: v63 (ref), p14 (copy), v64 (copy), RunService (copy), speakLetter (copy), t4 (copy), TextLabel2 (copy), n5 (ref)
        local t22 = {}

        for v66, v67 in utf8.graphemes(v63) do
            t22[#t22 + 1] = string.sub(v63, v66, v67)
        end

        local v70 = #t22
        local n7 = 0
        local n8 = 0

        while n7 < v70 do
            if n5 == v64 then
                n7 = math.min(v70, n7 + t4.TYPE * RunService.RenderStepped:Wait())
                TextLabel2.MaxVisibleGraphemes = math.floor(n7)

                local v72 = false

                while n8 < math.floor(n7) do
                    n8 += 1

                    if not (v72 or (t22[n8] or " "):match("^[%s%p]+$")) then
                        v72 = true
                        speakLetter()
                    end
                end

                continue
            end

            return
        end

        TextLabel2.MaxVisibleGraphemes = -1

        if n5 == v64 and p14 then
            p14()
        end
    end)
end

local function shout(p15, p16) -- line: 503
    -- upvalues: TweenService (copy), Loc (copy), t4 (copy), Frame2 (copy), UIScale2 (copy), TextLabel2 (copy)
    TextLabel2.Text = Loc.T(p15)
    TextLabel2.MaxVisibleGraphemes = -1
    UIScale2.Scale = t4.SHOUT.PUNCH
    TweenService:Create(UIScale2, TweenInfo.new(t4.SHOUT.TIME, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    Frame2.Rotation = -t4.SHOUT.SHAKE

    local tween = TweenService:Create(Frame2, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 3, true), {
        Rotation = t4.SHOUT.SHAKE
    })

    tween.Completed:Once(function() -- line: 510
        -- upvalues: Frame2 (copy)
        Frame2.Rotation = 0
    end)
    tween:Play()

    if p16 then
        p16()
    end
end

local function keyCard() -- line: 515
    -- upvalues: KeyConfig (copy)
    local Ruby = KeyConfig.KEYS.Ruby

    return {
        setup = function(p17) -- setup | line: 518
            -- upvalues: Ruby (copy)
            local Icon = p17.Main.Icon

            if Ruby then
                Icon.Image = Ruby.image
                Icon.ImageRectOffset = Vector2.new(Ruby.rect[1], Ruby.rect[2])
                Icon.ImageRectSize = Vector2.new(Ruby.rect[3] - Ruby.rect[1], Ruby.rect[4] - Ruby.rect[2])
            end

            p17.Main.Title.Text = "Ruby Key"
            p17.Main.Rarity.Text = "x1"
        end
    }
end

local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))
local t24 = {}

local function closePanel() -- line: 535
    -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), v56 (ref), PadMenu (copy), t24 (copy)
    PadMenu.Close(Panel)

    for _, v73 in ipairs(t24) do
        v73:Disconnect()
    end

    table.clear(t24)
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)

    local tween = TweenService:Create(Scale, PanelFocus.popOut, {
        Scale = 0
    })

    tween.Completed:Once(function() -- line: 541
        -- upvalues: Panel (copy), v56 (ref)
        if not v56 then
            Panel.Visible = false
        end
    end)
    tween:Play()
    v56 = false
end

local function openPanel(p18) -- line: 546
    -- upvalues: TweenService (copy), SocialService (copy), PanelFocus (copy), RewardScreen (copy), KeyConfig (copy), DuhbbyKey (copy), Panel (copy), Scale (copy), Send (copy), Close (copy), t3 (copy), n5 (ref), v56 (ref), v57 (ref), PadMenu (copy), t24 (copy), closePanel (copy)
    v56 = true
    Scale.Scale = PanelFocus.FEEL.FROM
    Panel.Visible = true
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    TweenService:Create(Scale, PanelFocus.popIn, {
        Scale = 1
    }):Play()

    local v74 = n5

    table.insert(t24, Send.Activated:Connect(function() -- line: 553
        -- upvalues: p18 (copy), v74 (copy), SocialService (copy), RewardScreen (copy), KeyConfig (copy), DuhbbyKey (copy), t3 (copy), n5 (ref), v57 (ref), closePanel (copy)
        closePanel()
        task.spawn(function() -- line: 555
            -- upvalues: p18 (copy), v74 (copy), SocialService (copy), RewardScreen (copy), KeyConfig (copy), DuhbbyKey (copy), t3 (copy), n5 (ref), v57 (ref)
            local function v76() -- line: 557
                -- upvalues: SocialService (copy)
                SocialService:PromptFeedbackSubmissionAsync()
            end

            pcall(v76)

            local function v77() -- line: 558
                -- upvalues: DuhbbyKey (copy)
                return DuhbbyKey:InvokeServer()
            end

            local ok, result = pcall(v77)

            if ok and result == "granted" then
                local Show = RewardScreen.Show
                local Ruby = KeyConfig.KEYS.Ruby

                Show({
                    {
                        setup = function(p19) -- setup | line: 518
                            -- upvalues: Ruby (copy)
                            local Icon = p19.Main.Icon

                            if Ruby then
                                Icon.Image = Ruby.image
                                Icon.ImageRectOffset = Vector2.new(Ruby.rect[1], Ruby.rect[2])
                                Icon.ImageRectSize = Vector2.new(Ruby.rect[3] - Ruby.rect[1], Ruby.rect[4] - Ruby.rect[2])
                            end

                            p19.Main.Title.Text = "Ruby Key"
                            p19.Main.Rarity.Text = "x1"
                        end
                    }
                })
            end

            if not p18 and n5 == v74 then
                v57(t3.afterFeedback.say)
            end
        end)
    end))

    local function closed() -- line: 563
        -- upvalues: p18 (copy), v74 (copy), t3 (copy), n5 (ref), v57 (ref), closePanel (copy)
        closePanel()

        if not p18 and n5 == v74 then
            v57(t3.closedFeedback.say)
        end
    end

    table.insert(t24, Close.Activated:Connect(closed))
    PadMenu.Open(Panel, function() -- line: 568
        -- upvalues: p18 (copy), v74 (copy), t3 (copy), n5 (ref), v56 (ref), v57 (ref), closePanel (copy)
        if v56 then
            closePanel()

            if not p18 and n5 == v74 then
                v57(t3.closedFeedback.say)
            end
        end
    end, {
        first = Send,
        closeButton = Close
    })
end

local function node(p20) -- line: 571
    -- upvalues: PromptLook (copy), t3 (copy), t4 (copy), v8 (copy), v13 (ref), play (copy), UIScale2 (copy), TextLabel2 (copy), t16 (copy), v53 (ref), bubbleShown (copy), n5 (ref), v55 (ref), v57 (ref), bindKeys (copy), n6 (ref), showReplies (copy), say (copy), shout (copy), openPanel (copy), node (copy)
    local v78 = t3[p20]

    if p20 == "help" then
        bubbleShown(false, t4.BUBBLE_OUT)
        openPanel()
    else
        local v79 = n5

        local function after() -- line: 579
            -- upvalues: v78 (copy), v79 (copy), PromptLook (copy), t4 (copy), v8 (copy), t16 (copy), v53 (ref), n5 (ref), v55 (ref), v57 (ref), bindKeys (copy), n6 (ref), showReplies (copy), node (copy)
            if v78.ends then
                task.delay(t4.READ, function() -- line: 581
                    -- upvalues: v79 (copy), n5 (ref), v57 (ref)
                    if n5 == v79 then
                        v57()
                    end
                end)
            elseif v78.next then
                task.delay(v78.act and v8 or t4.NEXT, function() -- line: 584
                    -- upvalues: v78 (copy), v79 (copy), n5 (ref), node (copy)
                    if n5 == v79 then
                        node(v78.next)
                    end
                end)
            else
                local t26 = {}

                for _, v80 in ipairs(v78.replies) do
                    if v80[2] ~= "bye" then
                        t26[#t26 + 1] = v80
                    end
                end

                for _, v81 in ipairs(v78.replies) do
                    if v81[2] == "bye" then
                        t26[#t26 + 1] = v81
                    end
                end

                showReplies(t26)

                v53 = function(p21) -- line: 592
                    -- upvalues: t26 (copy), v79 (copy), PromptLook (copy), t16 (copy), v53 (ref), n5 (ref), v55 (ref), bindKeys (copy), n6 (ref), node (copy)
                    if n5 ~= v79 or not v55 or not t26[p21] then
                        return
                    end

                    v53 = nil

                    if v55 then
                        v55 = false
                        bindKeys(0)

                        for i = 1, n6 do
                            PromptLook.Hide(t16[i])
                        end

                        n6 = 0
                    end

                    node(t26[p21][2])
                end
            end
        end

        if v78.act then
            v13 = true
            play(v78.act)
        end

        if v78.dots then
            local v83 = n5

            TextLabel2.MaxVisibleGraphemes = -1

            if UIScale2.Scale < 0.5 then
                bubbleShown(true, t4.BUBBLE_POP)
            end

            task.spawn(function() -- line: 488
                -- upvalues: after (copy), v83 (copy), t4 (copy), TextLabel2 (copy), n5 (ref)
                local elapsed = os.clock()
                local n9 = 0

                while true do
                    if os.clock() - elapsed < t4.DOTS.TIME then
                        if n5 == v83 then
                            n9 = n9 % 3 + 1
                            TextLabel2.Text = string.rep(".", n9)
                            task.wait(t4.DOTS.STEP)
                            continue
                        end

                        return
                    end

                    break
                end

                TextLabel2.Text = "..."

                if n5 == v83 and after then
                    after()
                end
            end)
        elseif v78.shout then
            shout(v78.say, after)
        else
            say(v78.say, after)
        end
    end
end

v57 = function(p22) -- line: 612
    -- upvalues: PromptLook (copy), DuhbbyPrompt (copy), t4 (copy), t6 (copy), v13 (ref), t11 (copy), t12 (copy), t13 (copy), v15 (ref), sit (copy), play (copy), v51 (copy), TextLabel (copy), t16 (copy), v53 (ref), bubbleShown (copy), n5 (ref), v55 (ref), v56 (ref), connection (ref), bindKeys (copy), n6 (ref), say (copy), closePanel (copy)
    if not v15 then
        return
    end

    n5 += 1
    v15 = false
    v53 = nil

    if v55 then
        v55 = false
        bindKeys(0)

        for i = 1, n6 do
            PromptLook.Hide(t16[i])
        end

        n6 = 0
    end

    local v85 = v13 and p22 ~= nil

    if not v85 then
        bubbleShown(false, t4.BUBBLE_OUT)
    end

    if v56 then
        closePanel()
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end

    TextLabel.Text = "itsduhbby"

    local v86 = n5

    if not v13 then
        sit(false)
        task.delay(t4.DOWN + 0.4, function() -- line: 654
            -- upvalues: v86 (copy), DuhbbyPrompt (copy), v51 (copy), n5 (ref)
            if n5 == v86 then
                v51.Enabled = false
                DuhbbyPrompt.Enabled = true
            end
        end)

        return
    end

    v13 = false

    local v87 = if v85 then 2 else 1

    local function over() -- line: 628
        -- upvalues: v86 (copy), v87 (ref), DuhbbyPrompt (copy), v51 (copy), n5 (ref)
        v87 -= 1

        if v87 == 0 and n5 == v86 then
            v51.Enabled = false
            DuhbbyPrompt.Enabled = true
        end
    end

    if v85 then
        say(p22, function() -- line: 636
            -- upvalues: v86 (copy), over (copy), t4 (copy), bubbleShown (copy), n5 (ref)
            task.delay(t4.READ, function() -- line: 637
                -- upvalues: v86 (copy), over (copy), t4 (copy), bubbleShown (copy), n5 (ref)
                if n5 == v86 then
                    bubbleShown(false, t4.BUBBLE_OUT)
                    task.delay(t4.BUBBLE_OUT.Time, over)
                end
            end)
        end)
    else
        task.delay(t4.BUBBLE_OUT.Time, over)
    end

    play("back", function() -- line: 646
        -- upvalues: v86 (copy), v87 (ref), DuhbbyPrompt (copy), t6 (copy), t11 (copy), t12 (copy), t13 (copy), v51 (copy), n5 (ref)
        for v88 in pairs(t6) do
            t11[v88] = 0
            t12[v88] = 0
            t13[v88] = 0
        end

        v87 -= 1

        if v87 == 0 and n5 == v86 then
            v51.Enabled = false
            DuhbbyPrompt.Enabled = true
        end
    end)
end

local function startTalk() -- line: 662
    -- upvalues: RunService (copy), LocalPlayer (copy), PromptLook (copy), TalkPoint (copy), DuhbbyPrompt (copy), t4 (copy), v15 (ref), sit (copy), v51 (copy), UIScale (copy), n5 (ref), v56 (ref), connection (ref), v57 (ref), node (copy)
    if v15 then
        return
    end

    v15 = true
    n5 += 1

    local v89 = n5

    DuhbbyPrompt.Enabled = false
    UIScale.Scale = math.max(PromptLook.ScreenScale(), t4.MIN_SCALE)
    v51.Enabled = true
    sit(true)
    connection = RunService.Heartbeat:Connect(function() -- line: 672
        -- upvalues: LocalPlayer (copy), TalkPoint (copy), t4 (copy), v56 (ref), v57 (ref)
        local v91 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not (v56 or v91 and not ((v91.Position - TalkPoint.WorldPosition).Magnitude > t4.LEAVE)) then
            v57()
        end
    end)

    local v92 = if LocalPlayer:GetAttribute("DuhbbyKeyGiven") then "again" else "start"

    task.delay(t4.FIRST, function() -- line: 678
        -- upvalues: v89 (copy), v92 (copy), n5 (ref), node (copy)
        if n5 == v89 then
            node(v92)
        end
    end)
end

for _, v93 in ipairs({ Send, Close }) do
    ButtonHover.Attach(v93, {
        shine = false,
        highlight = true
    })
end

DuhbbyPrompt.Style = Enum.ProximityPromptStyle.Custom

local v94

ProximityPromptService.PromptShown:Connect(function(p23) -- line: 685
    -- upvalues: PromptLook (copy), TalkPoint (copy), DuhbbyPrompt (copy), startTalk (copy), v94 (ref)
    if p23 ~= DuhbbyPrompt then
        return
    end

    v94 = v94 or PromptLook.Build(TalkPoint, "DuhbbyPromptUI", startTalk)
    PromptLook.Show(v94, p23.ObjectText, p23.ActionText)
end)
ProximityPromptService.PromptHidden:Connect(function(p24) -- line: 690
    -- upvalues: PromptLook (copy), DuhbbyPrompt (copy), v94 (ref)
    if p24 == DuhbbyPrompt and v94 then
        PromptLook.Hide(v94)
    end
end)
ProximityPromptService.PromptTriggered:Connect(function(p25) -- line: 693
    -- upvalues: DuhbbyPrompt (copy), startTalk (copy)
    if p25 == DuhbbyPrompt then
        startTalk()
    end
end)

local BindableEvent = Instance.new("BindableEvent")

BindableEvent.Name = "Say"
BindableEvent.Parent = script
ProximityPromptService = {
    Y = 0.875,
    SCALE = 1.15
}

local ScreenGui, Frame4, UIScale3
local t27 = {
    parent = Frame2.Parent,
    position = Frame2.Position
}

local function bubbleOnScreen(p26) -- line: 711
    -- upvalues: PlayerGui (copy), PromptLook (copy), t4 (copy), v49 (copy), Frame2 (copy), ScreenGui (ref), Frame4 (ref), UIScale3 (ref), t27 (copy)
    if p26 then
        if not ScreenGui then
            ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "DuhbbyScreenTalk"
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.ResetOnSpawn = false
            ScreenGui.DisplayOrder = 99
            ScreenGui:SetAttribute("CinematicKeep", true)
            Frame4 = Instance.new("Frame")
            Frame4.Name = "Holder"
            Frame4.BackgroundTransparency = 1

            local Frame = Frame4

            Frame.AnchorPoint = Vector2.new(0.5, 1)

            local Frame2 = Frame4

            Frame2.Position = UDim2.fromScale(0.5, 0.875)

            local Frame3 = Frame4

            Frame3.Size = UDim2.fromOffset(v49.X, v49.Y)
            Frame4.Parent = ScreenGui
            UIScale3 = Instance.new("UIScale")
            UIScale3.Parent = Frame4
            ScreenGui.Parent = PlayerGui
        end

        local UIScale = UIScale3

        UIScale.Scale = math.max(PromptLook.ScreenScale(), t4.MIN_SCALE) * 1.15
        Frame2.Position = UDim2.fromScale(0.5, 1)
        Frame2.Parent = Frame4
        ScreenGui.Enabled = true
    else
        Frame2.Parent = t27.parent
        Frame2.Position = t27.position

        if ScreenGui then
            ScreenGui.Enabled = false
        end
    end
end

local function adminTakeover() -- line: 741
    -- upvalues: LocalPlayer (copy), PromptLook (copy), DuhbbyPrompt (copy), t4 (copy), t6 (copy), t7 (copy), Act (copy), v7 (copy), v9 (ref), v10 (ref), v11 (ref), v12 (ref), n2 (ref), v13 (ref), t11 (copy), t12 (copy), t13 (copy), v15 (ref), v16 (ref), v51 (copy), Frame2 (copy), TextLabel (copy), t16 (copy), v53 (ref), bubbleShown (copy), n5 (ref), v55 (ref), v56 (ref), connection (ref), bindKeys (copy), n6 (ref), closePanel (copy), ScreenGui (ref), t27 (copy), bubbleOnScreen (copy)
    local v96 = LocalPlayer:GetAttribute("AdminDuhbby") == true

    n5 += 1
    v15 = false
    v9 = false
    v10 = nil
    v13 = false
    v53 = nil

    if v55 then
        v55 = false
        bindKeys(0)

        local v97 = n6

        for i = 1, v97 do
            PromptLook.Hide(t16[i])
        end

        n6 = 0
    end

    if v56 then
        closePanel()
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if v16 then
        v16:Disconnect()
        v16 = nil
    end

    for v98 in pairs(t6) do
        t11[v98] = 0
        t12[v98] = 0
        t13[v98] = 0
    end

    local v99 = table.clone(t7)
    local restHrp = v7.restHrp

    v11 = v99
    v12 = restHrp
    n2 = 0
    TextLabel.Text = "itsduhbby"
    bubbleShown(false, t4.BUBBLE_OUT)

    if v96 then
        DuhbbyPrompt.Enabled = false
        v51.Enabled = false
        bubbleOnScreen(true)
    else
        Frame2.Parent = t27.parent
        Frame2.Position = t27.position

        if ScreenGui then
            ScreenGui.Enabled = false
        end

        Act.Apply(v7.ctx, t7, v7.restHrp, 0)
        v51.Enabled = false
        DuhbbyPrompt.Enabled = true
    end
end

LocalPlayer:GetAttributeChangedSignal("AdminDuhbby"):Connect(adminTakeover)

if LocalPlayer:GetAttribute("AdminDuhbby") == true then
    adminTakeover()
end

local BindableEvent2 = Instance.new("BindableEvent")

BindableEvent2.Name = "Feedback"
BindableEvent2.Parent = script
BindableEvent2.Event:Connect(function() -- line: 771
    -- upvalues: v15 (ref), v56 (ref), openPanel (copy)
    if not (v56 or v15) then
        openPanel(true)
    end
end)
ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 777
    -- upvalues: v56 (ref), closePanel (copy)
    if v56 then
        closePanel()
    end
end)
BindableEvent.Event:Connect(function(p27, p28) -- line: 780
    -- upvalues: LocalPlayer (copy), speakLetter (copy), t4 (copy), UIScale2 (copy), bubbleShown (copy), say (copy), shout (copy)
    if LocalPlayer:GetAttribute("AdminDuhbby") == true then
        if p27 then
            if not p28 then
                say(p27)

                return
            end

            if UIScale2.Scale < 0.5 then
                bubbleShown(true, t4.BUBBLE_POP)
            end

            shout(p27)
            speakLetter()
        else
            bubbleShown(false, t4.BUBBLE_OUT)
        end
    end
end)
