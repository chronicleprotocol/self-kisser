// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {IAuth} from "chronicle-std/auth/IAuth.sol";
import {Auth} from "chronicle-std/auth/Auth.sol";

import {IToll} from "chronicle-std/toll/IToll.sol";

import {ISelfKisser} from "./ISelfKisser.sol";

contract SelfKisser is ISelfKisser, Auth {

    /// @dev Whether SelfKisser is dead.
    uint internal _dead;

    modifier live() {
        if (_dead == 1) {
            revert Dead();
        }
        _;
    }

    constructor(address initialAuthed) Auth(initialAuthed) {}

    // -- User Functionality --

    /// @inheritdoc ISelfKisser
    function selfKiss(address oracle) external {
        selfKiss(oracle, msg.sender);
    }

    /// @inheritdoc ISelfKisser
    function selfKiss(address oracle, address who)
        public
        live
    {
        IToll(oracle).kiss(who);
        emit SelfKissed(msg.sender, oracle, who);
    }

    // -- View Functionality --

    /// @inheritdoc ISelfKisser
    function dead() external view returns (bool) {
        return _dead == 1;
    }

    // -- Auth'ed Functionality --

    /// @inheritdoc ISelfKisser
    function kill() external auth {
        if (_dead == 1) return;

        _dead = 1;
        emit Killed(msg.sender);
    }
}

/**
 * @dev Contract overwrite to deploy contract instances with specific naming.
 *
 *      For more info, see docs/Deployment.md.
 */
contract SelfKisser_COUNTER is SelfKisser {
    // @todo        ^^^^^^^ Adjust name of SelfKisser instance.
    constructor(address initialAuthed) SelfKisser(initialAuthed) {}
}
