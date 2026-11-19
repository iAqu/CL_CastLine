-- Test lifecycle coordination; all Studio access is supplied by the plugin adapter.
local Controller = {}
Controller.__index = Controller

function Controller.new(io)
	return setmetatable({ io = io, busy = false, alive = true, serial = 0 }, Controller)
end

local function singlePlayer(peers)
	local server, client
	for _, peer in peers do
		if not peer.supported then
			return nil
		end
		if peer.role == "server" and not server then
			server = peer
		elseif peer.role == "client" and not client then
			client = peer
		else
			return nil
		end
	end
	return if server and client then server else nil
end

function Controller:_check()
	if not self.alive then
		error("插件已卸载，取消重启。", 0)
	end
	if self.failure then
		error(self.failure, 0)
	end
end

function Controller:_run(onboarding)
	local io = self.io
	local peers = io.peers()
	if #peers > 0 or not io.isEdit() then
		local server = singlePlayer(peers)
		if not server then
			error("仅支持已加载完成的普通单人 Play 测试；请确认测试期间已加载用户插件。", 0)
		end

		local previous = {}
		for _, peer in peers do
			previous[peer.connection] = true
		end
		local deadline = io.now() + 60
		io.stopServer(server, self.serial)
		while true do
			self:_check()
			local remaining = io.peers()
			for _, peer in remaining do
				if not previous[peer.connection] then
					error("测试环境已改变，取消自动重新启动。", 0)
				end
			end
			local disconnected = true
			for _, peer in peers do
				if io.connected(peer.connection) then
					disconnected = false
				end
			end
			if io.isEdit() and #remaining == 0 and disconnected then
				break
			end
			if io.now() >= deadline then
				error("停止测试超过 60 秒，已取消自动重启；请手动检查 Studio。", 0)
			end
			io.wait(0.05)
		end

		-- Start the full synchronization allowance only after Edit AND disconnect.
		local readyAt = io.now() + io.delay()
		repeat
			self:_check()
			if not io.isEdit() or #io.peers() > 0 then
				error("等待期间已有新的测试，取消自动重新启动。", 0)
			end
			if io.now() >= readyAt then
				break
			end
			io.wait(math.min(0.05, readyAt - io.now()))
		until false
	end

	self:_check()
	io.startPlay(self.serial, onboarding)
	local deadline = io.now() + 60
	local observedTest = false
	while true do
		self:_check()
		local current = io.peers()
		local editing = io.isEdit()
		if not editing or #current > 0 then
			observedTest = true
		elseif observedTest then
			-- A manual Stop cancels this watch, even when the handshake never arrived.
			return
		end
		if not editing and singlePlayer(current) then
			return
		end
		if io.now() >= deadline then
			if not editing then
				error("测试已经运行，但未收到测试插件握手。若刚更新插件，请停止测试，在 PluginDebugService 下对 RestartTest 执行 Reload Plugin，再重试。不会重复启动测试。", 0)
			end
			error("60 秒内未能确认测试启动；不会重复启动，请检查 Studio。", 0)
		end
		io.wait(0.05)
	end
end

function Controller:request(onboarding)
	if self.busy or not self.alive then
		return false
	end
	self.busy = true
	self.serial += 1
	self.failure = nil
	self.io.busyChanged(true)
	self.io.spawn(function()
		local ok, message = pcall(function()
			self:_run(onboarding)
		end)
		self.busy = false
		if self.alive then
			self.io.busyChanged(false)
			if not ok then
				self.io.warning(tostring(message))
			end
		end
	end)
	return true
end

function Controller:fail(serial, message)
	if self.busy and serial == self.serial then
		self.failure = message
	end
end

function Controller:destroy()
	self.alive = false
end

return Controller
