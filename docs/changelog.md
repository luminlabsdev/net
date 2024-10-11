* * *

hide:

- navigation

* * *

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2024-10-11

### Added

- Adds a middleware API in place of callbacks
- Packet is now dropped if args contain `NaN`

### Changed

- Changes `Functions` to `Async`
- Moves `Listen` & `OnRequest` type validation params to constructor
- Changes `OnInvoke` and `InvokeAsync` to `OnRequest` and `Request`

### Removed

- Removes default ratelimiting in favor of a custom middleware-based solution

## [0.4.1] - 2024-09-19

### Fixed

- Fixed an issue where `Futures` were still used that resulted in errornous code

## [0.4.0] - 2024-09-18

### Removed

- Removed `Futures`, all code now yields

## [0.3.0] - 2024-09-08

### Fixed

- Fixed issues with wally package types
- Fixed changelog problems

## [0.2.0] - 2024-09-08

### Added

- Added proper docs
- Futures in replacement of Promises

## [0.1.0] - 2024-08-06

Initial release! 🥳

[unreleased]: https://github.com/luminlabsdev/net/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/luminlabsdev/net/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/luminlabsdev/net/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/luminlabsdev/net/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/luminlabsdev/net/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/luminlabsdev/net/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/luminlabsdev/net/compare/54e6996b9825a91f9cc70fd2ccf9721db831df32...v0.1.0
