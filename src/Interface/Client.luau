-- Variables

local Future = require(script.Parent.Parent.Parent.future)
local Types = require(script.Parent.Parent.Types)
local Identifier = require(script.Parent.Identifier)

local Network = script.Parent.Parent.Network
local Client = require(Network.Client)

-- Functions

local function Fire<T...>(self: Types.EventClient<T...>, ...: T...)
	self._Fire(self._Identifier, table.pack(...))
end

local function FireNow<T...>(self: Types.EventClient<T...>, ...: T...)
	self._FireNow(self._Identifier, table.pack(...))
end

local function Listen<T...>(self: Types.EventClient<T...>, listener: (T...) -> ())
	assert(listener, "Must provide a listener")
	Client.Listen(self._Identifier, function(args)
		listener(table.unpack(args))
	end)
end

local function InvokeAsync<T...>(self: Types.FunctionClient<T...>, ...: T...): Future.Future<T...>
	local Packed = table.pack(...)
	return Future.new(function()
		return table.unpack(
			Client.SendReliableBatchedCall(self._Identifier, table.pack(Identifier.Unique(), table.unpack(Packed)))
		)
	end)
end

-- Module

return {
	Fire = Fire,
	FireNow = FireNow,
	Listen = Listen,
	InvokeAsync = InvokeAsync,
}
