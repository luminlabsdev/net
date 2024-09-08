# Function

A server-sided function.

## Properties

---

### `Reliable`

Whether or not the function uses a reliable remote event.

- **boolean**

## Methods

---

### `OnInvoke`

Recieves an invoke from the client, and runs the callback function which returns some data. Equivalent to [RemoteFunction.OnServerInvoke](https://create.roblox.com/docs/reference/engine/classes/RemoteFunction#OnServerInvoke).

**Parameters**

- **callback:** `(sender: Player, ...: any) -> (any, ...any)`<br>
The callback function to run on invoke, must return at least 1 value

- **validTypes:** `{ string }?`<br>
Valid types that the server should recieve in the order they are specified

**Returns**

- **void**

---

### `SetRateLimit`

Sets a rate limit that is applied when firing an event from the client.

**Parameters**

- **maxCalls:** `number`<br>
The maximum amount of invokes allowed every `interval` seconds; set to -1 to disable the rate limit

- **resetInterval:** `number?`<br>
The interval of which `maxCalls` is reset

- **overflowCallback:** `(sender: Player) -> ()?`<br>
The callback function to run when the player has exceeded the current rate limit

**Returns**

- **void**

---

### `SetInvalidTypeCallback`

Allows you to set a callback that runs whenever an invalid type is sent by the client.

**Parameters**

- **callback:** `(sender: Player) -> ()`<br>
The function to run when an invalid type is reached and a packet is dropped

**Returns**

- **void**
