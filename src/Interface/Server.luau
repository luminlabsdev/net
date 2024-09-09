-- Variables

local PlayerService = game:GetService("Players")

local Ratelimit = require(script.Parent.Parent.Parent.ratelimit)
local Types = require(script.Parent.Parent.Types)

local Network = script.Parent.Parent.Network
local Server = require(Network.Server)

-- Functions

--[=[
	Fires an event which sends data to the client, equivalent to [RemoteEvent:FireClient](https://create.roblox.com/docs/reference/engine/classes/RemoteEvent#FireClient).

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#fire)
]=]
local function Fire<T...>(self: Types.EventServer<T...>, recipient: Player, ...: T...)
	self._Fire(recipient, self._Identifier, table.pack(...))
end

--[=[
	Same as `Fire` but does not batch the call / wait until the next frame.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#firenow)
]=]
local function FireNow<T...>(self: Types.EventServer<T...>, recipient: Player, ...: T...)
	self._FireNow(recipient, self._Identifier, table.pack(...))
end

--[=[
	Fires an event which sends data to every client connected to the server, equivalent [RemoteEvent:FireAllClients](https://create.roblox.com/docs/reference/engine/classes/RemoteEvent#FireAllClients).

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#fireall)
]=]
local function FireAll<T...>(self: Types.EventServer<T...>, ...: T...)
	for _, recipient in PlayerService:GetPlayers() do
		self._Fire(recipient, self._Identifier, table.pack(...))
	end
end

--[=[
	Fires an event which sends data to every client connected to the server, except for players defined in the `except` parameter.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#fireexcept)
]=]
local function FireExcept<T...>(self: Types.EventServer<T...>, except: Player | { Player }, ...: T...)
	if type(except) == "table" then
		for _, player in PlayerService:GetPlayers() do
			if table.find(except, player) then
				continue
			end
			self._Fire(player, self._Identifier, table.pack(...))
		end
		return
	end

	for _, player in PlayerService:GetPlayers() do
		if player == except then
			continue
		end
		self._Fire(player, self._Identifier, table.pack(...))
	end
end

--[=[
	Fires an event with a filter function, and runs the provided filter on every player in the server.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#firefilter)
]=]
local function FireFilter<T...>(self: Types.EventServer<T...>, filter: (Player) -> boolean, ...: T...)
	for _, recipient in PlayerService:GetPlayers() do
		if filter(recipient) then
			self._Fire(recipient, self._Identifier, table.pack(...))
		end
	end
end

--[=[
	Fires an event with a array of players, and loops through the provided array and fires on the given players.
]=]

local function FireFor<T...>(self: Types.EventServer<T...>, players: { Player }, ...: T...)
	for _, recipient in pairs(players) do
		self._Fire(recipient, self._Identifier, table.pack(...))
	end
end

--[=[
	Listens for the event to be fired by the client, then runs the provided function.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#listen)
]=]
local function Listen<T...>(self: Types.EventServer<T...>, listener: (sender: Player, T...) -> (), validTypes: { string }?)
	assert(listener, "Must provide a listener")
	Server.Listen(self._Identifier, function(sender, args)
		if (self._Ratelimit and self._InvokeOverflow) and not self._Ratelimit(sender) then
			self._InvokeOverflow(sender)
			return
		end

		if validTypes then
			for index, value in args do
				if typeof(value) ~= validTypes[index] then
					if self._OnInvalidType then
						self._OnInvalidType(sender)
						return
					end
					warn(`Argument #{index} does not match the type '{validTypes[index]}'`)
					return
				end
			end
		end

		listener(sender, table.unpack(args))
	end)
end

--[=[
	Allows you to set a callback that runs whenever an invalid type is sent by the client.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#setinvalidtypecallback)
]=]
local function SetInvalidTypeCallback<T...>(
	self: Types.EventServer<T...> & Types.FunctionServer<T...>,
	callback: (sender: Player) -> ()
)
	self._OnInvalidType = callback
end

--[=[
	Sets a rate limit that is applied when firing an event from the client.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#setratelimit)
]=]
local function SetRateLimit<T...>(
	self: Types.EventServer<T...> & Types.FunctionServer<T...>,
	maxCalls: number,
	resetInterval: number?,
	overflowCallback: ((sender: Player) -> ())?
)
	if maxCalls <= -1 then
		self._Ratelimit = nil
		self._InvokeOverflow = nil
	end

	if not (resetInterval and overflowCallback) then
		return
	end

	self._Ratelimit = Ratelimit(maxCalls, resetInterval or 1)
	self._InvokeOverflow = overflowCallback
end

--[=[
	Recieves an invoke from the client, and runs the callback function which returns some data. Equivalent to [RemoteFunction.OnServerInvoke](https://create.roblox.com/docs/reference/engine/classes/RemoteFunction#OnServerInvoke).

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#oninvoke)
]=]
local function OnInvoke<T...>(
	self: Types.FunctionServer<T...>,
	callback: (sender: Player, T...) -> T...,
	validTypes: { string }?
)
	assert(callback, "Must provide a callback")
	Server.Listen(self._Identifier, function(sender, args)
		if (self._Ratelimit and self._InvokeOverflow) and not self._Ratelimit(sender) then
			self._InvokeOverflow(sender)
			return
		end

		local CallId = table.remove(args, 1)

		if type(CallId) ~= "string" then
			return
		end

		if validTypes then
			for index, value in args do
				if typeof(value) ~= validTypes[index] then
					if self._OnInvalidType then
						self._OnInvalidType(sender)
						return
					end
					warn(`Argument #{index} does not match the type '{validTypes[index]}'`)
					return
				end
			end
		end

		task.spawn(function(player: Player, callId: string, ...: any)
			Server.SendReliableBatchedCallReturn(player, callId, table.pack(callback(player, ...)))
		end, sender, CallId, table.unpack(args))
	end)
end

-- Module

return {
	Fire = Fire,
	FireNow = FireNow,
	FireAll = FireAll,
	FireExcept = FireExcept,
	FireFilter = FireFilter,
	FireFor = FireFor,

	Listen = Listen,

	SetRateLimit = SetRateLimit,
	SetInvalidTypeCallback = SetInvalidTypeCallback,

	OnInvoke = OnInvoke,
}
