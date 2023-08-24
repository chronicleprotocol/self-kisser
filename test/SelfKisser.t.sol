// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Test} from "forge-std/Test.sol";

import {IAuth} from "chronicle-std/auth/IAuth.sol";
import {Auth} from "chronicle-std/auth/Auth.sol";

import {IToll} from "chronicle-std/toll/IToll.sol";
import {Toll} from "chronicle-std/toll/Toll.sol";

import {SelfKisser} from "src/SelfKisser.sol";
import {ISelfKisser} from "src/ISelfKisser.sol";

contract SelfKisserTest is Test {
    SelfKisser public kisser;

    function setUp() public {
        kisser = new SelfKisser(address(this));
    }

    function test_Deployment() public {
        // Address given as constructor argument is auth'ed.
        assertTrue(IAuth(address(kisser)).authed(address(this)));

        // Contract is not dead.
        assertEq(kisser.dead(), 0);
    }

    function test_kill() public {
        kisser.kill();
        kisser.kill(); // Call is idempotent and should not revert
        assertEq(kisser.dead(), 1);
    }

    // -- Test: selfKiss --

    function testFuzz_selfKiss_Self(address caller) public {
        vm.assume(caller != address(kisser));

        // Make and support oracle.
        ChronicleMock mock = new ChronicleMock(address(this));
        IAuth(address(mock)).rely(address(kisser));
        kisser.support(address(mock));

        vm.prank(caller);
        kisser.selfKiss(address(mock));

        assertTrue(IToll(address(mock)).tolled(caller));
    }

    function testFuzz_selfKiss_Other(address caller, address other) public {
        vm.assume(caller != address(kisser));
        vm.assume(other != address(kisser));

        // Make and support oracle.
        ChronicleMock mock = new ChronicleMock(address(this));
        IAuth(address(mock)).rely(address(kisser));
        kisser.support(address(mock));

        vm.prank(caller);
        kisser.selfKiss(address(mock), other);

        assertTrue(IToll(address(mock)).tolled(other));
    }

    // -- Test: support + unsupport

    function test_support() public {
        ChronicleMock mock = new ChronicleMock(address(this));
        IAuth(address(mock)).rely(address(kisser));

        kisser.support(address(mock));

        assertEq(kisser.oracles(address(mock)), 1);
    }

    function test_support_RevertsIf_NotAuthorized() public {
        ChronicleMock mock = new ChronicleMock(address(this));

        vm.expectRevert();
        kisser.support(address(mock));
    }

    function test_unsupport() public {
        ChronicleMock mock = new ChronicleMock(address(this));
        IAuth(address(mock)).rely(address(kisser));

        kisser.support(address(mock));
        kisser.unsupport(address(mock));

        assertEq(kisser.oracles(address(mock)), 0);
    }

    function test_support_unsupport() public {
        ChronicleMock mock = new ChronicleMock(address(this));
        IAuth(address(mock)).rely(address(kisser));

        kisser.support(address(mock));
        kisser.unsupport(address(mock));
        kisser.support(address(mock));

        assertEq(kisser.oracles(address(mock)), 1);
    }

    // -- Test: isSupportedProtected --

    function test_selfKiss_Self_isSupportedProtected() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                ISelfKisser.OracleNotSupported.selector, address(0xdead)
            )
        );
        kisser.selfKiss(address(0xdead));
    }

    function test_selfKiss_Other_isSupportedProtected() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                ISelfKisser.OracleNotSupported.selector, address(0xdead)
            )
        );
        kisser.selfKiss(address(0xdead), address(0xdead));
    }

    function test_unsupport_isSupportedProtected() public {}

    // -- Test: isLiveProtected --

    function test_support_isLiveProtected() public {
        kisser.kill();

        vm.expectRevert(ISelfKisser.Dead.selector);
        kisser.support(address(0xdead));
    }

    function test_unsupport_isLiveProtected() public {
        kisser.kill();

        vm.expectRevert(ISelfKisser.Dead.selector);
        kisser.unsupport(address(0xdead));
    }

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

    // -- Test: isAuthProtected --

    function test_support_isAuthProtected() public {
        vm.prank(address(0xdead));
        vm.expectRevert(
            abi.encodeWithSelector(
                IAuth.NotAuthorized.selector, address(0xdead)
            )
        );
        kisser.support(address(0xdead));
    }

    function test_unsupport_isAuthProtected() public {
        vm.prank(address(0xdead));
        vm.expectRevert(
            abi.encodeWithSelector(
                IAuth.NotAuthorized.selector, address(0xdead)
            )
        );
        kisser.unsupport(address(0xdead));
    }
}

contract ChronicleMock is Auth, Toll {
    constructor(address initialAuthed) Auth(initialAuthed) {}

    function toll_auth() internal override(Toll) auth {}
}
