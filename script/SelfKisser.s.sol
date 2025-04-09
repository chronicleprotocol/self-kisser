// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

import {IAuth} from "chronicle-std/auth/IAuth.sol";

import {ISelfKisser} from "src/ISelfKisser.sol";
import {SelfKisser_COUNTER as SelfKisser} from "src/SelfKisser.sol";
// @todo           ^^^^^^^ Adjust name of SelfKisser instance.

contract SelfKisserScript is Script {
    /// @dev Deploys a new SelfKisser instance with `initialAuthed` being the
    ///      address initially auth'ed.
    function deploy(address initialAuthed) public {
        vm.startBroadcast();
        address deployed = address(new SelfKisser(initialAuthed));
        vm.stopBroadcast();

        console2.log("Deployed at", deployed);
    }

    // -- ISelfKisser Functions --

    // -- User Functionality

    /// @dev Kisses caller on oracle `oracle`.
    function selfKiss(address self, address oracle) public {
        vm.startBroadcast();
        ISelfKisser(self).selfKiss(oracle);
        vm.stopBroadcast();

        console2.log("Self-Kissed on", oracle);
    }

    /// @dev Kisses address `who` on oracle `oracle`.
    function selfKiss(address self, address oracle, address who) public {
        vm.startBroadcast();
        ISelfKisser(self).selfKiss(oracle, who);
        vm.stopBroadcast();

        console2.log("SelfKissed");
        console2.log(" Oracle", oracle);
        console2.log(" Who", who);
    }

    // -- Auth'ed Functionality

    /// @dev !!! DANGER !!!
    ///
    /// @dev Kills `self`.
    function kill(address self) public {
        vm.startBroadcast();
        ISelfKisser(self).kill();
        vm.stopBroadcast();

        console2.log("Killed", self);
    }

    // -- IAuth Functions --

    /// @dev Grants auth to address `who`.
    function rely(address self, address who) public {
        vm.startBroadcast();
        IAuth(self).rely(who);
        vm.stopBroadcast();

        console2.log("Relied", who);
    }

    /// @dev Renounces auth from address `who`.
    function deny(address self, address who) public {
        vm.startBroadcast();
        IAuth(self).deny(who);
        vm.stopBroadcast();

        console2.log("Denied", who);
    }
}
