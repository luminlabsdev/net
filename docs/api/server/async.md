# Async

A server-sided async.

## Properties

---

### `Reliable`

Whether or not the async uses a reliable remote event.

- **boolean**

## Methods

---

### `OnRequest`

Recieves a request from the client, and runs the callback function which returns some data. Equivalent to [RemoteFunction.OnServerInvoke](https://create.roblox.com/docs/reference/engine/classes/RemoteFunction#OnServerInvoke).

**Parameters**

- **callback:** `(sender: Player, ...: any) -> (any, ...any)`<br>
The callback function to run on requesting, must return at least 1 value

**Returns**

- **void**

---

### `SetMiddleware`

Allows you to set middleware that runs at specific points in time.

**Parameters**

- **middleware** `{ [MiddlewareType]: (...any) -> () }`<br>
A table of middleware for the event.

**Returns**

- **void**
