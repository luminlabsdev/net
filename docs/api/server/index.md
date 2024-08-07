# ServerInterface

References the server event and function constructors

## Functions

### `Event`

Creates a new remote event

**Parameters**

* **name:** `string`\
The name of the remote event to reference or create

* **reliable:** `boolean`\
Whether the remote event should be reliable or not. Defaults to true

**Returns**

- [**Event**](./event)

---

### `Function`

Creates a new remote function

**Parameters**

* **name:** `string`\
The name of the remote function to reference or create

* **reliable:** `boolean`\
Whether the remote function should be reliable or not. Defaults to true\
*This currently has no effect on remote functions*

**Returns**

- [**Function**](./function)