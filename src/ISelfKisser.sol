// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface ISelfKisser {
    /// @notice Thrown if SelfKisser dead.
    error Dead();

    /// @notice Emitted when SelfKisser killed.
    /// @param caller The caller's address.
    event Killed(address indexed caller);

    /// @notice Emitted when new address kissed on an oracle.
    /// @param caller The caller's address.
    /// @param oracle The oracle on which address `who` got kissed on.
    /// @param who The address that got kissed on oracle `oracle`.
    event SelfKissed(
        address indexed caller, address indexed oracle, address indexed who
    );

    // -- User Functionality --

    /// @notice Kisses caller on oracle `oracle`.
    ///
    /// @dev Reverts if SelfKisser dead.
    ///
    /// @param oracle The oracle to kiss the caller on.
    function selfKiss(address oracle) external;

    /// @notice Kisses address `who` on oracle `oracle`.
    ///
    /// @dev Reverts if SelfKisser dead.
    ///
    /// @param oracle The oracle to kiss address `who` on.
    /// @param who The address to kiss on oracle `oracle`.
    function selfKiss(address oracle, address who) external;

    // -- View Functionality --

    /// @notice Returns whether SelfKisser is dead.
    /// @return True if SelfKisser dead, false otherwise.
    function dead() external view returns (bool);

    // -- Auth'ed Functionality --

    /// @notice Kills the contract.
    /// @dev Only callable by auth'ed address.
    function kill() external;
}
