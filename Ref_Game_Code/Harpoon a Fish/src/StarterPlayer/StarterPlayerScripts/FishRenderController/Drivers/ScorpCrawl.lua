-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked = p2.fightHooked

    p1.ScorpCrawl = {
        CLAW_IDLE = 0.06,
        CLAW_RATE = 1.3,
        CLAW_BOB = 0.05,
        HOOK_RATE = 3,
        BODY_RATIO = 0.3333333333333333,
        IDLE_HZ = 0.35,
        IDLE_AMP = 0.35,
        SWAY = 0.03,
        LAG = 0.9,
        ROLL = 0.07,
        HEAD_YAW = 0.28,
        HEAD_LAG = 0.9,
        HEAD_PITCH = 0.09,
        TAIL_CURL = 0.18,
        BODY_CHAIN = { "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        body = function(p3, p4, p5) -- body | line: 28
            -- upvalues: p1 (copy)
            local ScorpCrawl = p1.ScorpCrawl
            local body, crawl = p3.body, p3.crawl
            local walk = crawl.walk
            local HOOK_RATE = p5 and ScorpCrawl.HOOK_RATE or crawl.vel.Magnitude / (crawl.stride * crawl.length)

            body.theta += p4 * 2 * 3.141592653589793 * (HOOK_RATE * ScorpCrawl.BODY_RATIO * walk + ScorpCrawl.IDLE_HZ * (1 - walk))

            local v1 = body.amp * (ScorpCrawl.IDLE_AMP + (1 - ScorpCrawl.IDLE_AMP) * walk)
            local v2 = #ScorpCrawl.BODY_CHAIN
            local cumY, cumR = body.cumY, body.cumR
            local n1 = 0
            local n2 = 0
            local n3 = 0

            for i = 1, v2 do
                local v5 = v1 * ScorpCrawl.SWAY * math.sin(body.theta - (v2 - i) * ScorpCrawl.LAG)
                local v8 = v1 * ScorpCrawl.ROLL * math.sin(body.theta - (v2 - i) * ScorpCrawl.LAG + 1.5707963267948966)
                local v9 = v8 - n1

                n1 = v8
                n2 += v5
                n3 += v9
                cumY[i] = n2
                cumR[i] = n3

                local v10 = body.chain[i]

                if v10 then
                    local v11 = CFrame.fromAxisAngle(v10.yaw, v5) * CFrame.fromAxisAngle(v10.roll, v9)

                    if i == v2 and body.tailPitch then
                        v11 *= CFrame.fromAxisAngle(body.tailPitch, v1 * ScorpCrawl.TAIL_CURL * math.sin(body.theta + 0.6))
                    end

                    v10.bone.Transform = v11
                end
            end

            local head = body.head

            if head then
                head.bone.Transform = CFrame.fromAxisAngle(head.yaw, v1 * ScorpCrawl.HEAD_YAW * math.sin(body.theta - (v2 - 1) * ScorpCrawl.LAG - ScorpCrawl.HEAD_LAG)) * CFrame.fromAxisAngle(head.pitch, v1 * ScorpCrawl.HEAD_PITCH * math.sin(2 * body.theta))
            end

            for _, v19 in ipairs(body.legs) do
                if v19.upto > 0 then
                    v19.L.leg.Transform = CFrame.fromAxisAngle(v19.u, -cumY[v19.upto]) * CFrame.fromAxisAngle(v19.n, -cumR[v19.upto]) * v19.L.leg.Transform
                end
            end
        end,
        claws = function(p6, p7, p8) -- claws | line: 65
            -- upvalues: p1 (copy)
            local ScorpCrawl = p1.ScorpCrawl

            return ScorpCrawl.CLAW_IDLE * math.sin(ScorpCrawl.CLAW_RATE * p8) + p7 * ScorpCrawl.CLAW_BOB * math.sin(12.566370614359172 * p6)
        end,
        register = function(p9) -- register | line: 69
            -- upvalues: p1 (copy)
            local StrokeClock = p1.StrokeClock
            local CrawlKind = p9:GetAttribute("CrawlKind")
            local CrawlKind2 = if (CrawlKind == "trilobite" or CrawlKind == "spider" or CrawlKind == "seaspider") and CrawlKind then CrawlKind else nil
            local v24 = CrawlKind2 ~= nil
            local v25 = StrokeClock.setup(p9, v24 and {
                "LegL1_1",
                "LegR1_1"
            } or { "LegL1_1", "LegR3_1", "ClawL_1", "ClawR_1" })

            if not (v25 and p1.Crawl.setup(v25, CrawlKind2 or "scorpion")) then
                return nil
            end

            v25.claws = {}

            for _, v26 in ipairs(v24 and {} or {
                    "ClawL_1",
                    "ClawR_1"
                }) do
                v25.claws[#v25.claws + 1] = {
                    bone = v25.bones[v26],
                    axis = StrokeClock.axis(v25, v25.bones[v26], v25.right)
                }
            end

            v25.t = math.random() * 10

            local CrawlBody = p9:GetAttribute("CrawlBody")

            if type(CrawlBody) == "number" then
                local ScorpCrawl = p1.ScorpCrawl
                local t2 = {}
                local t3 = {
                    theta = 0,
                    amp = CrawlBody,
                    chain = {},
                    legs = {},
                    cumY = {},
                    cumR = {}
                }

                for v27, v28 in ipairs(ScorpCrawl.BODY_CHAIN) do
                    t2[v28] = v27

                    local v29 = v25.bones[v28]

                    if v29 then
                        t3.chain[v27] = {
                            bone = v29,
                            yaw = StrokeClock.axis(v25, v29, v25.up),
                            roll = StrokeClock.axis(v25, v29, v25.nose)
                        }
                    end
                end

                local Head, Tail_03 = v25.bones.Head, v25.bones.Tail_03

                if Head then
                    t3.head = {
                        bone = Head,
                        yaw = StrokeClock.axis(v25, Head, v25.up),
                        pitch = StrokeClock.axis(v25, Head, v25.right)
                    }
                end

                if Tail_03 then
                    t3.tailPitch = StrokeClock.axis(v25, Tail_03, -v25.right)
                end

                for _, v30 in ipairs(v25.crawl.legs) do
                    local legParent = v30.leg.Parent

                    t3.legs[#t3.legs + 1] = {
                        L = v30,
                        upto = legParent and t2[legParent.Name] or 0,
                        u = StrokeClock.axis(v25, v30.leg, v25.up),
                        n = StrokeClock.axis(v25, v30.leg, v25.nose)
                    }
                end

                v25.body = t3
            end

            return v25
        end,
        update = function(p10, p11) -- update | line: 108
            -- upvalues: p1 (copy), fightHooked (copy)
            local ScorpCrawl = p1.ScorpCrawl
            local crawl = p10.crawl

            p10.t += p11

            if fightHooked(p10.model) then
                crawl.walk = 1
                crawl.phase = (crawl.phase + p11 * ScorpCrawl.HOOK_RATE) % 1
                p1.Crawl.pose(p10, crawl.phase, p10.nose, 1)
            else
                p1.Crawl.update(p10, p11)
            end

            if p10.body then
                ScorpCrawl.body(p10, p11, fightHooked(p10.model))
            end

            local v32 = ScorpCrawl.claws(crawl.phase, crawl.walk, p10.t)

            for _, v33 in ipairs(p10.claws) do
                v33.bone.Transform = CFrame.fromAxisAngle(v33.axis, v32)
            end
        end
    }
end
