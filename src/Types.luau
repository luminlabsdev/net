-- Throttle: if the returned value resolves to true, the packet gets throttled
-- Dropped: packet dropped for not matching types or containing NaN
export type MiddlewareType = "Throttle" | "Dropped"
export type Constructor<T> = (name: string, reliable: boolean?, types: { string }?) -> T

export type EventClient<T...> = {
	Listen: (self: EventClient<T...>, listener: (T...) -> ()) -> (),
	Fire: (self: EventClient<T...>, T...) -> (),
	FireNow: (self: EventClient<T...>, T...) -> (),

	Reliable: boolean,
	Id: string,

	_Fire: (id: string, args: { any }) -> (),
	_FireNow: (id: string, args: { any }) -> (),
}

export type EventServer<T...> = {
	Listen: (self: EventServer<T...>, listener: (sender: Player, T...) -> ()) -> (),
	Fire: (self: EventServer<T...>, recipient: Player, T...) -> (),
	FireNow: (self: EventServer<T...>, recipient: Player, T...) -> (),
	FireAll: (self: EventServer<T...>, T...) -> (),
	FireAllExcept: (self: EventServer<T...>, except: Player | { Player }, T...) -> (),
	FireFilter: (self: EventServer<T...>, filter: (Player) -> boolean, T...) -> (),
	SetMiddleware: (self: EventServer<T...>, middleware: { [MiddlewareType]: (...any) -> () }) -> (),

	Reliable: boolean,
	Id: string,

	_Fire: (player: Player, id: string, args: { any }) -> (),
	_FireNow: (player: Player, id: string, args: { any }) -> (),
	_Middleware: {
        Dropped: (value: any) -> (),
        Throttle: (sender: Player) -> (),
    },
	_Types: { string }?,
}

export type AsyncClient<T...> = {
	Request: (self: AsyncClient<T...>, T...) -> T...,

	Reliable: boolean,
	Id: string,
}

export type AsyncServer<T...> = {
	OnRequest: (self: AsyncServer<T...>, callback: (sender: Player, T...) -> T...) -> (),
    SetMiddleware: (self: EventServer<T...>, middleware: { [MiddlewareType]: (...any) -> () }) -> (),

	Reliable: boolean,
	Id: string,

	_Middleware: {
        Dropped: (value: any) -> (),
        Throttle: (sender: Player) -> (),
    },
	_Types: { string }?,
}

return {}
