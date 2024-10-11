# Interface

References the server event and function constructors

## Functions

---

### `Event`

Creates a new event

**Parameters**

- **name:** `string`\
The name of the event to reference or create

- **reliable:** `boolean`\
Whether the event should be reliable or not. Defaults to true

- **types:** `{ string }`\
Type validation params to be applied at `Listen`

**Returns**

- [**Event**](./event)

---

### `Async`

Creates a new async

**Parameters**

- **name:** `string`\
The name of the async to reference or create

- **reliable:** `boolean`\
Whether the async should be reliable or not. Defaults to true\
*This currently has no effect on asyncs*

- **types:** `{ string }`\
Type validation params to be applied at `OnRequest`

**Returns**

- [**Async**](./async)
