# SelfKisser

> The most important relationship you'll ever have is with yourself!
>
> Make it _physical_ ;)

The `SelfKisser` is a simple contract allowing everyone to whitelist (`kiss`) themselves on a set of supported _Chronicle Protocol_ oracles. This allows easy access during e.g. hackathons.

This contract may **never be deployed to production environments**!

## How to get physical?

To whitelist yourself (`msg.sender`) on an oracle, call the `ISelfKisser::selfKiss(address oracle)`.

To whitelist some other address, use `ISelfKisser::selfKiss(address oracle, address who)`.
