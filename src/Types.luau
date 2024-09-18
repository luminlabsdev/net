export type Constructor<T> = (name: string, reliable: boolean?) -> T

export type EventClient<T...> = {
	Listen: (self: EventClient<T...>, listener: (T...) -> ()) -> (),
	Fire: (self: EventClient<T...>, T...) -> (),
	FireNow: (self: EventClient<T...>, T...) -> (),
	Reliable: boolean,

	_Fire: (id: string, args: { any }) -> (),
	_FireNow: (id: string, args: { any }) -> (),
	_Identifier: string,
}

export type EventServer<T...> = {
	Listen: (self: EventServer<T...>, listener: (sender: Player, T...) -> (), validTypes: { string }?) -> (),
	Fire: (self: EventServer<T...>, recipient: Player, T...) -> (),
	FireNow: (self: EventServer<T...>, recipient: Player, T...) -> (),
	FireAll: (self: EventServer<T...>, T...) -> (),
	FireExcept: (self: EventServer<T...>, except: Player | { Player }, T...) -> (),
	FireFilter: (self: EventServer<T...>, filter: (Player) -> boolean, T...) -> (),
	SetInvalidTypeCallback: (self: EventServer<T...>, callback: (sender: Player) -> ()) -> (),
	SetRateLimit: (
		self: EventServer<T...>,
		maxCalls: number,
		resetInterval: number?,
		fireOverflowCallback: (sender: Player) -> ()?
	) -> (),
	Reliable: boolean,

	_Fire: (player: Player, id: string, args: { any }) -> (),
	_FireNow: (player: Player, id: string, args: { any }) -> (),
	_Identifier: string,
	_Ratelimit: any,
	_InvokeOverflow: any,
	_OnInvalidType: any,
}

export type FunctionClient<T...> = {
	InvokeAsync: (self: FunctionClient<T...>, T...) -> T...,
	Reliable: boolean,

	_Identifier: string,
}

export type FunctionServer<T...> = {
	OnInvoke: (
		self: FunctionServer<T...>,
		callback: (sender: Player, T...) -> T...,
		validTypes: { string }?
	) -> (),
	SetRateLimit: (
		self: FunctionServer<T...>,
		maxCalls: number,
		resetInterval: number?,
		invokeOverflowCallback: (sender: Player) -> ()?
	) -> (),
	SetInvalidTypeCallback: (self: EventServer<T...>, callback: (sender: Player) -> ()) -> (),

	Reliable: boolean,

	_Identifier: string,
	_Ratelimit: any,
	_InvokeOverflow: any,
	_OnInvalidType: any,
}

return {}
