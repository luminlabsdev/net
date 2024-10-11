# Type Validation

The type validation feature allows you to strictly specify what types that the server should be getting from the client. For most cases, this ensures safety on both ends of code and also prevents exploiters from just guessing. This can be used to ban/kick them as well.

## Usage

To use the type validation feature, you have to declare a table of types in the constructor. The types must also be in the exact order as they are sent; if they are not you might encounter some unexplainable issues if not tested. The example below will kick the sender of the packet if the type is invalid.

```luau
local Net = require(Packages.net).Server
local MyEvent = Net.Event("MyEvent", true, {"string", "Instance", "number"})

MyEvent:SetMiddleware({
    Dropped = function(sender, data1, data2, data3)
        sender:Kick("You might be exploiting...")
    end
})

MyEvent:Listen(function(sender, data1, data2, data3)
    print(sender.DisplayName, data1, data2, data3)
end)
```

For a scenario when the player is kicked;

- Data1 - `string` :octicons-check-16:
- Data2 - `boolean` :octicons-x-16:
- Data3 - `number` :octicons-check-16:

A warning will be sent in the server output and the packet will be dropped. If you manually set the middleware for this, that will be run instead and a warning will not be displayed.
