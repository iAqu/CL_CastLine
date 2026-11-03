-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1, p2) --[[ new | Line: 26 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)
	v2._scrollFrame = p1
	v2._itemsPerPage = p2 and p2.ItemsPerPage or 50
	v2._loadFactor = p2 and p2.LoadFactor or 0.8
	v2._scrollDirection = p2 and p2.ScrollDirection or "Vertical"
	v2._onPageLoaded = if p2 then p2.OnPageLoaded else p2
	v2._allItems = {}
	v2._itemsLoaded = 0
	v2._isLoading = false
	v2._drawCallback = nil
	v2._scrollConnection = nil
	v2._sizeConnection = nil
	v2._destroyed = false
	return v2
end
function t.SetItems(p1, p2) --[[ SetItems | Line: 47 ]]
	p1._destroyed = false
	p1._allItems = p2
	p1._itemsLoaded = 0
end
function t.GetTotalItems(p1) --[[ GetTotalItems | Line: 54 ]]
	return #p1._allItems
end
function t.GetLoadedCount(p1) --[[ GetLoadedCount | Line: 59 ]]
	return p1._itemsLoaded
end
function t.IsFullyLoaded(p1) --[[ IsFullyLoaded | Line: 64 ]]
	return p1._itemsLoaded >= #p1._allItems
end
function t._shouldLoadMore(p1) --[[ _shouldLoadMore | Line: 69 ]]
	local _scrollFrame = p1._scrollFrame
	if p1._scrollDirection == "Horizontal" then
		return _scrollFrame.AbsoluteWindowSize.X * (2 - p1._loadFactor) + _scrollFrame.CanvasPosition.X >= _scrollFrame.AbsoluteCanvasSize.X
	else
		return _scrollFrame.AbsoluteWindowSize.Y * (2 - p1._loadFactor) + _scrollFrame.CanvasPosition.Y >= _scrollFrame.AbsoluteCanvasSize.Y
	end
end
function t.LoadNextPage(p1, p2) --[[ LoadNextPage | Line: 83 ]]
	if p1._isLoading then
		return 0
	end
	local v1 = #p1._allItems
	if v1 <= p1._itemsLoaded then
		return 0
	end
	p1._isLoading = true
	p1._drawCallback = p2
	local v2 = p1._itemsLoaded + 1
	local v4 = math.min(v2 + p1._itemsPerPage - 1, v1)
	local count = 0
	for i = v2, v4 do
		local v5 = p1._allItems[i]
		if v5 then
			p2(v5, i)
			count = count + 1
		end
	end
	p1._itemsLoaded = v4
	p1._isLoading = false
	if p1._onPageLoaded then
		p1._onPageLoaded()
	end
	task.delay(0.1, function() --[[ Line: 117 | Upvalues: p1 (copy), p2 (copy) ]]
		if p1._destroyed then
			return
		end
		if p1:IsFullyLoaded() or not p1:_shouldLoadMore() then
			return
		end
		p1:LoadNextPage(p2)
	end)
	return count
end
function t.StartScrollMonitoring(p1, p2) --[[ StartScrollMonitoring | Line: 131 ]]
	p1:StopScrollMonitoring()
	p1._drawCallback = p2
	p1._scrollConnection = p1._scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function() --[[ Line: 136 | Upvalues: p1 (copy), p2 (copy) ]]
		if p1._destroyed then
			return
		end
		if not p1:_shouldLoadMore() or (p1._isLoading or p1:IsFullyLoaded()) then
			return
		end
		p1:LoadNextPage(p2)
	end)
	p1._sizeConnection = p1._scrollFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() --[[ Line: 147 | Upvalues: p1 (copy), p2 (copy) ]]
		if p1._destroyed then
			return
		end
		if not p1:_shouldLoadMore() or (p1._isLoading or p1:IsFullyLoaded()) then
			return
		end
		p1:LoadNextPage(p2)
	end)
end
function t.StopScrollMonitoring(p1) --[[ StopScrollMonitoring | Line: 159 ]]
	if p1._scrollConnection then
		p1._scrollConnection:Disconnect()
		p1._scrollConnection = nil
	end
	if not p1._sizeConnection then
		return
	end
	p1._sizeConnection:Disconnect()
	p1._sizeConnection = nil
end
function t.Reset(p1) --[[ Reset | Line: 172 ]]
	p1:StopScrollMonitoring()
	p1._itemsLoaded = 0
	p1._isLoading = false
	table.clear(p1._allItems)
	p1._drawCallback = nil
end
function t.Destroy(p1) --[[ Destroy | Line: 181 ]]
	p1._destroyed = true
	p1:Reset()
end
return t