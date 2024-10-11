-- Variables

local PlayerService = game:GetService("Players")

local Packages = script.Parent.Parent.Parent
local Debugger = require(Packages.debugger)
local Types = require(script.Parent.Parent.Types)

local Network = script.Parent.Parent.Network
local Server = require(Network.Server)

-- Functions

--[=[
	Fires an event which sends data to the client, equivalent to [RemoteEvent:FireClient](https://create.roblox.com/docs/reference/engine/classes/RemoteEvent#FireClient).

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#fire)
]=]
local function Fire<T...>(self: Types.EventServer<T...>, recipient: Player, ...: T...)
	self._Fire(recipient, self.Id, table.pack(...))
end

--[=[
	Same as `Fire` but does not batch the call / wait until the next frame.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#firenow)
]=]
local function FireNow<T...>(self: Types.EventServer<T...>, recipient: Player, ...: T...)
	self._FireNow(recipient, self.Id, table.pack(...))
end

--[=[
	Fires an event which sends data to every client connected to the server, equivalent [RemoteEvent:FireAllClients](https://create.roblox.com/docs/reference/engine/classes/RemoteEvent#FireAllClients).

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#fireall)
]=]
local function FireAll<T...>(self: Types.EventServer<T...>, ...: T...)
	for _, recipient in PlayerService:GetPlayers() do
		self._Fire(recipient, self.Id, table.pack(...))
	end
end

--[=[
	Fires an event which sends data to every client connected to the server, except for players defined in the `except` parameter.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#fireallexcept)
]=]
local function FireAllExcept<T...>(self: Types.EventServer<T...>, except: Player | { Player }, ...: T...)
	if type(except) == "table" then
		for _, player in PlayerService:GetPlayers() do
			if table.find(except, player) then
				continue
			end
			self._Fire(player, self.Id, table.pack(...))
		end
		return
	end

	for _, player in PlayerService:GetPlayers() do
		if player == except then
			continue
		end
		self._Fire(player, self.Id, table.pack(...))
	end
end

--[=[
	Fires an event with a filter function, and runs the provided filter on every player in the server.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#firefilter)
]=]
local function FireFilter<T...>(self: Types.EventServer<T...>, filter: (Player) -> boolean, ...: T...)
	for _, recipient in PlayerService:GetPlayers() do
		if filter(recipient) then
			self._Fire(recipient, self.Id, table.pack(...))
		end
	end
end

--[=[
	Listens for the event to be fired by the client, then runs the provided function.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#listen)
]=]
local function Listen<T...>(self: Types.EventServer<T...>, listener: (sender: Player, T...) -> ())
	Debugger.Assert(listener, "NoListener")
	Server.Listen(self.Id, function(sender, args)
		if self._Middleware.Throttle and not self._Middleware.Throttle(sender) then
			return
		end

		if self._Types then
			for index, value in args do
				if typeof(value) ~= self._Types[index] or value ~= value then
					if self._Middleware.Dropped then
						self._Middleware.Dropped(value)
						return
					end
					Debugger.Warn("PacketDropped", `Arg #{index} does not have type of {self._Types[index]} or is NaN`)
					return
				end
			end
		end

		listener(sender, table.unpack(args))
	end)
end

--[=[
	Allows you to set middleware that runs at specific points in time.

	[Learn More](https://luminlabsdev.github.io/net/reference/server/event#setmiddleware)
]=]
local function SetMiddleware<T...>(self: Types.EventServer<T...>, middleware: { [Types.MiddlewareType]: (...any) -> () })
	Debugger.Assert(middleware, "NoMiddleware")
	Debugger.Assert(type(middleware) == "table", "InvalidMiddleware")
	self._Middleware = middleware :: any
end

--[=[
	Recieves an request from the client, and runs the callback function which returns some data. Equivalent to [RemoteFunction.OnServerInvoke](https://create.roblox.com/docs/reference/engine/classes/RemoteFunction#OnServerInvoke).

	[Learn More](https://luminlabsdev.github.io/net/reference/server/async#onrequest)
]=]
local function OnRequest<T...>(self: Types.AsyncServer<T...>, callback: (sender: Player, T...) -> T...)
	Debugger.Assert(callback, "NoCallback")
	Server.Listen(self.Id, function(sender, args)
		if self._Middleware.Throttle and self._Middleware.Throttle(sender) == false then
			return
		end

		local CallId = table.remove(args, 1)

		if type(CallId) ~= "string" then
			return
		end

		if self._Types then
			for index, value in args do
				if typeof(value) ~= self._Types[index] or value ~= value then
					if self._Middleware.Dropped then
						self._Middleware.Dropped(value)
						return
					end
					Debugger.Warn("PacketDropped", `Arg #{index} does not have type of {self._Types[index]} or is NaN`)
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
	FireAllExcept = FireAllExcept,
	FireFilter = FireFilter,

	Listen = Listen,
	SetMiddleware = SetMiddleware,

	OnRequest = OnRequest,
}
