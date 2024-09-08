---
hide:
  - toc
  - navigation
---

A simple and efficient networking library.

[Guides](./guides/){ .md-button .md-button--primary }
[Reference](./reference/){ .md-button }

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
local MyEvent = Net.Event("MyEvent")

MyEvent:Listen(function(number, string, boolean)
    print("Only accepting numbers, strings, and bools")
end, {"number", "string", "boolean"}) -- If the client does not send these types in that order, the packet will be dropped
```

Provides better type validation API than other libraries like Red, which require lots of extra code.

## Built-In Ratelimiting

```luau
local Net = require(Packages.net).Server
local MyEvent = Net.Event("MyEvent")

MyEvent:Listen(function()
    print("Prints 1 time every 10 seconds")
end)

MyEvent:SetRateLimit(1, 10, function(sender)
    print(sender.DisplayName, "is sending too many requests")
end)
```

Has a built-in ratelimiting API which uses an efficient and reliable module under the hood.
