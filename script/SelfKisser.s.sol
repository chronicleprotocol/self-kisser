// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

import {IAuth} from "chronicle-std/auth/IAuth.sol";

import {ISelfKisser} from "src/ISelfKisser.sol";
import {SelfKisser} from "src/SelfKisser.sol";

contract SelfKisserScript is Script {
    /// @dev Run via:
    ///
    ///      ```bash
    ///      $ forge script \
    ///          --private-key $PRIVATE_KEY \
    ///          --rpc-url $RPC_URL \
    ///          --broadcast \
    ///          --verifier-url $ETHERSCAN_API_URL \
    ///          --etherscan-api-key $ETHERSCAN_API_KEY \
    ///          --verify \
    ///          -vvv \
    ///          --sig "$(cast calldata "deploy(address)" $INITIAL_AUTHED)" \
    ///          script/SelfKisser.s.sol:SelfKisserScript
    ///      ```
    function deploy(address initialAuthed) public {
        vm.startBroadcast();
        SelfKisser deployed = new SelfKisser(initialAuthed);
        vm.stopBroadcast();

        console2.log("Deployed at", address(deployed));
    }

    /// @dev Run via:
    ///
    ///      ```bash
    ///      $ forge script \
    ///          --private-key $PRIVATE_KEY \
    ///          --rpc-url $RPC_URL \
    ///          --broadcast \
    ///          -vvv \
    ///          --sig "$(cast calldata "support(address,address)" $SELF_KISSER $ORACLE)" \
    ///          script/SelfKisser.s.sol:SelfKisserScript
    ///      ```
    function support(address self, address oracle) public {
        vm.startBroadcast();
        ISelfKisser(self).support(oracle);
        vm.stopBroadcast();

        console2.log("Supported", oracle);
    }

    /// @dev Run via:
    ///
    ///      ```bash
    ///      $ forge script \
    ///          --private-key $PRIVATE_KEY \
    ///          --rpc-url $RPC_URL \
    ///          --broadcast \
    ///          -vvv \
    ///          --sig "$(cast calldata "unsupport(address,address)" $SELF_KISSER $ORACLE)" \
    ///          script/SelfKisser.s.sol:SelfKisserScript
    ///      ```
    function unsupport(address self, address oracle) public {
        vm.startBroadcast();
        ISelfKisser(self).unsupport(oracle);
        vm.stopBroadcast();

        console2.log("Unsupported", oracle);
    }

    /// @dev !!! DANGER !!!
    ///
    /// @dev Run via:
    ///
    ///      ```bash
    ///      $ forge script \
    ///          --private-key $PRIVATE_KEY \
    ///          --rpc-url $RPC_URL \
    ///          --broadcast \
    ///          -vvv \
    ///          --sig "$(cast calldata "kill(address)" $SELF_KISSER)" \
    ///          script/SelfKisser.s.sol:SelfKisserScript
    ///      ```
    function kill(address self) public {
        vm.startBroadcast();
        ISelfKisser(self).kill();
        vm.stopBroadcast();

        console2.log("Killed");
    }
}
