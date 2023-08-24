// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {IAuth} from "chronicle-std/auth/IAuth.sol";
import {Auth} from "chronicle-std/auth/Auth.sol";

import {IToll} from "chronicle-std/toll/IToll.sol";

import {ISelfKisser} from "./ISelfKisser.sol";

contract SelfKisser is ISelfKisser, Auth {
    mapping(address => uint) public oracles;

    uint public dead;

    modifier live() {
        if (dead == 1) {
            revert Dead();
        }
        _;
    }

    modifier supported(address oracle) {
        if (oracles[oracle] == 0) {
            revert OracleNotSupported(oracle);
        }
        _;
    }

    constructor(address initialAuthed) Auth(initialAuthed) {}

    // -- User Functionality --

    function selfKiss(address oracle) external live {
        selfKiss(oracle, msg.sender);
    }

    function selfKiss(address oracle, address who)
        public
        live
        supported(oracle)
    {
        IToll(oracle).kiss(who);

        emit SelfKissed(msg.sender, oracle, who);
    }

    // -- Auth'ed Functionality --

    function support(address oracle) external live auth {
        if (oracles[oracle] == 1) return;

        require(IAuth(oracle).authed(address(this)));

        oracles[oracle] = 1;

        emit OracleSupported(msg.sender, oracle);
    }

    function unsupport(address oracle) external live auth {
        if (oracles[oracle] == 0) return;

        oracles[oracle] = 0;

        emit OracleUnsupported(msg.sender, oracle);
    }

    function kill() external auth {
        if (dead == 1) return;

        dead = 1;

        emit Killed(msg.sender);
    }
}
