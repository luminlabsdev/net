# Event

A client-sided event.

## Properties

---

### `Reliable`

Whether or not the event uses a reliable remote event.

- **boolean**

## Methods

---

### `Fire`

Fires an event which sends data to the server, equivalent to [RemoteEvent:FireServer](https://create.roblox.com/docs/reference/engine/classes/RemoteEvent#FireServer).

**Parameters**

- **data:** `...any`<br>
The data that should be sent to the server

**Returns**

- **void**

---

### `FireNow`

Same as `Fire` but does not batch the call / wait until the next frame.

**Parameters**

- **data:** `...any`<br>
The data that should be sent to the server

**Returns**

- **void**

---

### `Listen`

Listens for the event to be fired by the server, then runs the provided function.

**Parameters**

- **listener:** `(...: any) -> ()`<br>
The function to call when data is recieved

**Returns**

- **void**
