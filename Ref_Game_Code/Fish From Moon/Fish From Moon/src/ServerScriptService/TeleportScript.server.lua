local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)

-- 需要传送模块
local TeleportModule = require(ServerStorage:WaitForChild("TeleportModule"))

-- 为客户端至服务器使用创建远程事件
local teleportEvent = Instance.new("RemoteEvent")
teleportEvent.Name = "TeleportEvent"
teleportEvent.Parent = ReplicatedStorage

-- 在服务器事件触发模块函数
teleportEvent.OnServerEvent:Connect(function(player, targetPlaceID)
	
	DataStore2.SaveAll(player)

	-- 定义传送选项
	local teleportOptions = Instance.new("TeleportOptions")

	-- 设置带玩家生命值的传送数据
	local humanoid = player.Character:FindFirstChild("Humanoid")
	if humanoid then
		local teleportData = {
			currentHealth = humanoid.Health,
		}
		teleportOptions:SetTeleportData(teleportData)
	end

	local teleportResult = TeleportModule.teleportWithRetry(130840440285347, {player},teleportOptions)
end)


----jump
--local Gravity = Vector3.new(0, -workspace.Gravity, 0)
--local function JumpProgress(startPos, endPos, t, car)
--	-- calculate the v0 needed to reach mouse.Hit.p
--	local V0 = (endPos - startPos- 0.5*Gravity*t*t)/t
--	-- have the ball travel that path
--	local dur = 0
--	while (dur <= t) do
--		if not car or not car.PrimaryPart or car.Parent ~= workspace.Cars then
--			break
--		end
--		local dt = dur + 0.05
--		car:PivotTo(CFrame.lookAt(CFrame.new(0.5 * Gravity * dur * dur + V0 * dur + startPos).Position, CFrame.new(0.5 * Gravity * dt * dt + V0 * dt + startPos).Position))
--		--car:PivotTo(CFrame.new(0.5*Gravity*dur*dur + V0*dur + startPos))
--		dur = dur
--			--+ Common.Run.Heartbeat:Wait()
--	end
--	car:PivotTo(CFrame.new(endPos))
--end

----关键词roblox Projectile Physics
