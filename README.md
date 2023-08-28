# SelfKisser • [![Unit Tests](https://github.com/chronicleprotocol/self-kisser/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/chronicleprotocol/self-kisser/actions/workflows/unit-tests.yml) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> The most important relationship you'll ever have is with yourself!
>
> Make it _physical_ ;)

The `SelfKisser` is a simple contract allowing everyone to whitelist (`kiss`) themselves on a set of supported _Chronicle Protocol_ oracles. This allows easy access during e.g. hackathons.

> **Warning**
>
> This contract may never be deployed to production environments!


## How to get physical?

To whitelist yourself (`msg.sender`) on an oracle, call the `ISelfKisser::selfKiss(address oracle)`.

To whitelist some other address, use `ISelfKisser::selfKiss(address oracle, address who)`.

For more info, see [docs/Management.md](./docs/Management.md).

## Dependencies

- [chronicleprotocol/chronicle-std@v2](https://github.com/chronicleprotocol/chronicle-std/tree/v2)

Deployment via:

- [chronicleprotocol/greenhouse@v1](https://github.com/chronicleprotocol/greenhouse/tree/v1)
