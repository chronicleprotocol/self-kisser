// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Test} from "forge-std/Test.sol";

import {IAuth} from "chronicle-std/auth/IAuth.sol";
import {IToll} from "chronicle-std/toll/IToll.sol";

import {ISelfKisser} from "src/ISelfKisser.sol";

abstract contract ISelfKisserTest is Test {
    ISelfKisser kisser;

    function setUp(address kisser_) internal {
        kisser = ISelfKisser(kisser_);
    }

    function test_Deployment() public {
        // Address given as constructor argument is auth'ed.
        assertTrue(IAuth(address(kisser)).authed(address(this)));

        // Contract is not dead.
        assertFalse(kisser.dead());
    }

    function test_kill() public {
        kisser.kill();
        kisser.kill(); // Call is idempotent and should not revert
        assertTrue(kisser.dead());
    }

    // -- Test: selfKiss --

    function testFuzz_selfKiss_Self(address caller) public {
        vm.assume(caller != address(kisser));

        // Make oracle.
        ChronicleMock mock = new ChronicleMock(address(this));
        IAuth(address(mock)).rely(address(kisser));

        vm.prank(caller);
        kisser.selfKiss(address(mock));

        assertTrue(IToll(address(mock)).tolled(caller));
    }

    function testFuzz_selfKiss_Other(address caller, address other) public {
        vm.assume(caller != address(kisser));
        vm.assume(other != address(kisser));

        // Make oracle.
        ChronicleMock mock = new ChronicleMock(address(this));
        IAuth(address(mock)).rely(address(kisser));

        vm.prank(caller);
        kisser.selfKiss(address(mock), other);

        assertTrue(IToll(address(mock)).tolled(other));
    }

    // -- Test: isLiveProtected --

    function test_selfKiss_Self_isLiveProtected() public {
        kisser.kill();

        vm.expectRevert(ISelfKisser.Dead.selector);
        kisser.selfKiss(address(0xdead));
    }

    function test_selfKiss_Other_isLiveProtected() public {
        kisser.kill();

        vm.expectRevert(ISelfKisser.Dead.selector);
        kisser.selfKiss(address(0xdead), address(0xdead));
    }
}

// -- Mocks --

import {Auth} from "chronicle-std/auth/Auth.sol";
import {Toll} from "chronicle-std/toll/Toll.sol";

contract ChronicleMock is Auth, Toll {
    constructor(address initialAuthed) Auth(initialAuthed) {}

    function toll_auth() internal override(Toll) auth {}
}
