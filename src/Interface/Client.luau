-- Variables

local Types = require(script.Parent.Parent.Types)
local Identifier = require(script.Parent.Identifier)

local Network = script.Parent.Parent.Network
local Client = require(Network.Client)

-- Functions

--[=[
	Fires an event which sends data to the server, equivalent to [RemoteEvent:FireServer](https://create.roblox.com/docs/reference/engine/classes/RemoteEvent#FireServer)

	[Learn More](https://luminlabsdev.github.io/net/reference/client/event#fire)
]=]
local function Fire<T...>(self: Types.EventClient<T...>, ...: T...)
	self._Fire(self._Identifier, table.pack(...))
end

--[=[
	Same as `Fire` but does not batch the call / wait until the next frame

	[Learn More](https://luminlabsdev.github.io/net/reference/client/event#firenow)
]=]
local function FireNow<T...>(self: Types.EventClient<T...>, ...: T...)
	self._FireNow(self._Identifier, table.pack(...))
end

--[=[
	Listens for the event to be fired by the server, then runs the provided function.

	[Learn More](https://luminlabsdev.github.io/net/reference/client/event#listen)
]=]
local function Listen<T...>(self: Types.EventClient<T...>, listener: (T...) -> ())
	assert(listener, "Must provide a listener")
	Client.Listen(self._Identifier, function(args)
		listener(table.unpack(args))
	end)
end

--[=[
	Invokes the server, equivalent to [RemoteFunction:InvokeServer](https://create.roblox.com/docs/reference/engine/classes/RemoteFunction#InvokeServer).

	[Learn More](https://luminlabsdev.github.io/net/reference/client/function#invokeasync)
]=]
local function InvokeAsync<T...>(self: Types.FunctionClient<T...>, ...: T...): T...
	local Packed = table.pack(...)
	return table.unpack(Client.SendReliableBatchedCall(self._Identifier, table.pack(Identifier.Unique(), table.unpack(Packed))))
end

-- Module

return {
	Fire = Fire,
	FireNow = FireNow,
	Listen = Listen,
	InvokeAsync = InvokeAsync,
}
