-- 真实会话回归：从轻啄接触结束到下一次进食，鱼身中心必须始终向前游。
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local settings = require(storage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingForwardValidation", workspace
local active
local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local target = Vector3.new(0, 1000, 0)
	local owner = { folder = folder, bait = bait, forward = Vector3.zAxis }
	local cases, samples = 0, 0
	for _, turn in ipairs({ -45, -15, 15, 45 }) do
		for _, baitYaw in ipairs({ 0, math.pi / 4 }) do
			for sector = 1, 3 do
				owner.spin = baitYaw
				local gameplay = {
					NextInteger = function(_, low)
						return if low == 0 then settings.MaxNibbles else sector
					end,
					NextNumber = function(_, low)
						return if low < 0 then 0 else 1
					end,
				}
				local visual = {
					NextInteger = function()
						return if turn > 0 then 1 else 0
					end,
					NextNumber = function(_, low, high)
						if low == settings.Nibble.SpeedMin and high == settings.Nibble.SpeedMax then
							return if sector == 1 then low elseif sector == 2 then high else 1
						elseif low == settings.Nibble.ReturnSpeedMin and high == settings.Nibble.ReturnSpeedMax then
							return if sector == 1 then high elseif sector == 2 then low else 1
						end
						return if low == settings.Nibble.TurnMin and high == settings.Nibble.TurnMax
							then math.abs(turn)
							else (low + high) / 2
					end,
				}
				active = Bite.new(owner, 0, 0, gameplay, visual)
				local timeline = active.timeline
				while timeline.phase ~= "Nibbling" do
					timeline:Advance(timeline.endsAt)
				end
				for nibble = 1, settings.MaxNibbles do
					assert(timeline.nibbleIndex == nibble, "Lost nibble order")
					local now = timeline.startedAt + timeline:GetNibbleTiming().returnAt
					local previous = active:_basePose(timeline.phase, now - timeline.startedAt, target)
					local deadline = now + 20
					while now < deadline do
						now += 1 / 120
						local phase = timeline:Advance(now)
						if phase ~= "Holding" and (phase ~= "Nibbling" or timeline.nibbleIndex ~= nibble) then
							break
						end
						local frame = active:_basePose(phase, now - timeline.startedAt, target)
						local displacement = (frame.Position - previous.Position) * Vector3.new(1, 0, 1)
						local heading = frame.LookVector * Vector3.new(1, 0, 1)
						if displacement.Magnitude > 0.00001 then
							local alignment = heading.Unit:Dot(displacement.Unit)
							assert(
								alignment > 0.99,
								string.format(
									"Fish did not swim forward: turn=%d nibble=%d phase=%s alignment=%.4f",
									turn,
									nibble,
									phase,
									alignment
								)
							)
						else
							assert(frame.LookVector:Dot(previous.LookVector) > 0.9999, "Fish rotated in place")
						end
						previous = frame
						samples += 1
					end
					assert(now < deadline, "Relocation never finished")
				end
				assert(timeline.phase == "Bite", "Final relocation did not reach true bite")
				active:Destroy()
				active = nil
				cases += 1
				task.wait()
			end
		end
	end
	return { passed = true, cases = cases, forwardSamples = samples }
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
