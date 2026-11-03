-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function() --[[ Line: 1 ]]
	local createElement = require(script.Parent.createElement)
	local NoopRenderer = require(script.Parent.NoopRenderer)
	local createReconciler = require(script.Parent.createReconciler)
	local PureComponent = require(script.Parent.PureComponent)
	local v1 = createReconciler(NoopRenderer)
	it("should be extendable", function() --[[ Line: 10 | Upvalues: PureComponent (copy) ]]
		expect((PureComponent:extend("MyComponent"))).to.be.ok()
	end)
	it("should skip updates for shallow-equal props", function() --[[ Line: 16 | Upvalues: PureComponent (copy), createElement (copy), v1 (copy) ]]
		local v12 = 0
		local v2 = nil
		local v3 = PureComponent:extend("PureChild")
		function v3.willUpdate(p1) --[[ willUpdate | Line: 22 | Upvalues: v12 (ref) ]]
			v12 = v12 + 1
		end
		function v3.render(p1) --[[ render | Line: 26 ]]
			return nil
		end
		local v4 = PureComponent:extend("PureContainer")
		function v4.init(p1) --[[ init | Line: 32 ]]
			p1.state = {
				value = 0
			}
		end
		function v4.didMount(p1) --[[ didMount | Line: 38 | Upvalues: v2 (ref) ]]
			v2 = function(p12) --[[ Line: 39 | Upvalues: p1 (copy) ]]
				p1:setState({
					value = p12
				})
			end
		end
		function v4.render(p1) --[[ render | Line: 46 | Upvalues: createElement (ref), v3 (copy) ]]
			return createElement(v3, {
				value = p1.state.value
			})
		end
		local v5 = createElement(v4)
		local v6 = v1.mountVirtualTree(v5, nil, "PureComponent Tree")
		expect(v12).to.equal(0)
		v2(1)
		expect(v12).to.equal(1)
		v2(1)
		expect(v12).to.equal(1)
		v2(2)
		expect(v12).to.equal(2)
		v2(1)
		expect(v12).to.equal(3)
		v1.unmountVirtualTree(v6)
	end)
end