# Middleware

The middleware feature allows you to run functions before or after something happens. For example, the `Throttle` middleware runs before the internal `Listen` code is ran and will throttle the event with your code.

## Usage

There are 2 different types of middleware. These are `Throttle` and `Dropped`. Throttle runs before `Listen` or `OnRequest`, and `Dropped` runs when the packet is dropped due to invalid types or NaN.

```luau
local Net = require(Packages.net).Server
local MyEvent = Net.Event("MyEvent")

MyEvent:SetMiddleware({
    Throttle = function()
        if math.random(1, 2) == 1 then
            print("I randomly decided to throttle.")
            return false -- Returning false indicates that the event/async should throttle
        end
        return true
    end,

    Dropped = function(sender)
        print(sender.Name, "sent the incorrect value from the client!")
    end,
})

MyEvent:Listen(function()
    print("Might print depending on the throttle middleware.")
end)
```

`Dropped` middleware is explained further in the [type validation article](type-validation.md).
