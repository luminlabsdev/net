# Setup

Setup is relatively easy when using the Net package. It is recommended to be used in conjunction with Lumin Framework, but it can also be used without it.

First and foremost, you must `require` the package on both the server and the client in order to start the networking process without any errors or yielding. The most favorable format is to declare the `.Server` or `.Client` interface depending on the current context.


### Server

```luau
local Net = require(Packages.net).Server
```

### Client

```luau
local Net = require(Packages.net).Client
```
