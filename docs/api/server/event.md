# Event

A server-sided event.

## Properties

---

### `Reliable`

Whether or not the network event uses a reliable remote event.

- **boolean**

## Methods

---

### `Fire`

Fires an event which sends data to the client, equivalent to [RemoteEvent:FireClient](https://create.roblox.com/docs/reference/engine/classes/RemoteEvent#FireClient).

**Parameters**

- **recipient:** `Player`<br>
The player who should recieve the data and/or call

- **data:** `...any`<br>
The data that should be sent to the client

**Returns**

- **void**

---

### `FireNow`

Same as `Fire` but does not batch the call / wait until the next frame.

**Parameters**

- **recipient:** `Player`<br>
The player who should recieve the data and/or call

- **data:** `...any`<br>
The data that should be sent to the client

**Returns**

- **void**

---

### `FireAll`

Fires an event which sends data to every client connected to the server, equivalent [RemoteEvent:FireAllClients](https://create.roblox.com/docs/reference/engine/classes/RemoteEvent#FireAllClients).

**Parameters**

- **data:** `...any`<br>
The data that should be sent to each player

**Returns**

- **void**

---

### `FireAllExcept`

Fires an event which sends data to every client connected to the server, except for players defined in the `except` parameter.

**Parameters**

- **except:** `{ Player } | Player`<br>
The players which the call should not be sent to

- **data:** `...any`<br>
The data that should be sent to each player except `except`

**Returns**

- **void**

---

### `FireFilter`

Fires an event with a filter function, and runs the provided filter on every player in the server.

**Parameters**

- **filter:** `(Player) -> boolean`<br>
The filter to run on each player, return a boolean to indicate that the player meets the threshold

- **data:** `...any`<br>
The data that should be sent to each player that meets the threshold for `filter`

**Returns**

- **void**

---

### `Listen`

Listens for the event to be fired by the client, then runs the provided function.

**Parameters**

- **listener:** `(sender: Player, ...: any) -> ()`<br>
The function to call when data is recieved

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
