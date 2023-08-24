// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface ISelfKisser {
    error Dead();
    error OracleNotSupported(address oracle);

    event Killed(address indexed caller);

    event OracleSupported(address indexed caller, address indexed oracle);
    event OracleUnsupported(address indexed caller, address indexed oracle);

    event SelfKissed(
        address indexed caller, address indexed oracle, address indexed who
    );

    function selfKiss(address oracle) external;
    function selfKiss(address oracle, address who) external;

    function dead() external view returns (uint);
    function oracles(address oracle) external view returns (uint);

    // -- Auth'ed Functionality --

    function support(address oracle) external;
    function unsupport(address oracle) external;

    function kill() external;
}
