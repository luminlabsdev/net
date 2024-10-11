---
hide:
  - toc
  - navigation
---

A simple and efficient networking library.

[Guides](./guides/){ .md-button .md-button--primary }
[Reference](./api/){ .md-button }

## Better API

```luau
local Net = require(Packages.net).Client
local MyEvent = Net.Event("MyEvent")

MyEvent:Fire("Hello server")
MyEvent:Listen(function()
    print("Listening to the server!")
end)
```

Has some of the best API out all of the non-buffer networking libraries available, with no caveats.

## Easy Type Validation

```luau
local Net = require(Packages.net).Server
local MyEvent = Net.Event("MyEvent", true, {"number", "string", "boolean"})

MyEvent:Listen(function(number, string, boolean)
    print("Only accepting numbers, strings, and bools in this order")
end) -- If the client does not send these types in that order, the packet will be dropped
```

Provides better type validation API than other libraries like Red, which require lots of extra code.

## Simple Middleware

```luau
local Net = require(Packages.net).Server
local MyEvent = Net.Event("MyEvent", true, {"number", "string", "boolean"})

MyEvent:SetMiddleware({
    Dropped = function(value1, value2, value3) -- got string, boolean, number
        print("Packet dropped!") -- Net will drop the packet, but this allows for a custom callback
    end
})

MyEvent:Listen(function(number, string, boolean)
    print("Only accepting numbers, strings, and bools in this order")
end)
```

Has a great middleware API which makes some of the internal code extendable, and allow it to do more.
