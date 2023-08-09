// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (finance/VestingWallet.sol)
pragma solidity ^0.8.20;

import { IERC20Upgradeable } from "../token/ERC20/IERC20Upgradeable.sol";
import { SafeERC20Upgradeable } from "../token/ERC20/utils/SafeERC20Upgradeable.sol";
import { AddressUpgradeable } from "../utils/AddressUpgradeable.sol";
import { ContextUpgradeable } from "../utils/ContextUpgradeable.sol";
import { OwnableUpgradeable } from "../access/OwnableUpgradeable.sol";
import "../proxy/utils/Initializable.sol";

/**
 * @dev A vesting wallet is an ownable contract that can receive native currency and ERC20 tokens, and release these
 * assets to the wallet owner, also referred to as "beneficiary", according to a vesting schedule.
 *
 * Any assets transferred to this contract will follow the vesting schedule as if they were locked from the beginning.
 * Consequently, if the vesting has already started, any amount of tokens sent to this contract will (at least partly)
 * be immediately releasable.
 *
 * By setting the duration to 0, one can configure this contract to behave like an asset timelock that hold tokens for
 * a beneficiary until a specified time.
 *
 * NOTE: Since the wallet is {Ownable}, and ownership can be transferred, it is possible to sell unvested tokens.
 * Preventing this in a smart contract is difficult, considering that: 1) a beneficiary address could be a
 * counterfactually deployed contract, 2) there is likely to be a migration path for EOAs to become contracts in the
 * near future.
 *
 * NOTE: When using this contract with any token whose balance is adjusted automatically (i.e. a rebase token), make sure
 * to account the supply/balance adjustment in the vesting schedule to ensure the vested amount is as intended.
 */
contract VestingWalletUpgradeable is Initializable, ContextUpgradeable, OwnableUpgradeable {
    event EtherReleased(uint256 amount);
    event ERC20Released(address indexed token, uint256 amount);

    /**
     * @dev The `beneficiary` is not a valid account.
     */
    error VestingWalletInvalidBeneficiary(address beneficiary);

    uint256 private _released;
    mapping(address token => uint256) private _erc20Released;
    uint64 private _start;
    uint64 private _duration;

    /**
     * @dev Sets the sender as the initial owner, the beneficiary as the pending owner, the start timestamp and the
     * vesting duration of the vesting wallet.
     */
    function __VestingWallet_init(address beneficiary, uint64 startTimestamp, uint64 durationSeconds) internal onlyInitializing {
        __Ownable_init_unchained(beneficiary);
        __VestingWallet_init_unchained(beneficiary, startTimestamp, durationSeconds);
    }

    function __VestingWallet_init_unchained(address beneficiary, uint64 startTimestamp, uint64 durationSeconds) internal onlyInitializing {
        if (beneficiary == address(0)) {
            revert VestingWalletInvalidBeneficiary(address(0));
        }

        _start = startTimestamp;
        _duration = durationSeconds;
    }

    /**
     * @dev The contract should be able to receive Eth.
     */
    receive() external payable virtual {}

    /**
     * @dev Getter for the start timestamp.
     */
    function start() public view virtual returns (uint256) {
        return _start;
    }

    /**
     * @dev Getter for the vesting duration.
     */
    function duration() public view virtual returns (uint256) {
        return _duration;
    }

    /**
     * @dev Getter for the end timestamp.
     */
    function end() public view virtual returns (uint256) {
        return start() + duration();
    }

    /**
     * @dev Amount of eth already released
     */
    function released() public view virtual returns (uint256) {
        return _released;
    }

    /**
     * @dev Amount of token already released
     */
    function released(address token) public view virtual returns (uint256) {
        return _erc20Released[token];
    }

    /**
     * @dev Getter for the amount of releasable eth.
     */
    function releasable() public view virtual returns (uint256) {
        return vestedAmount(uint64(block.timestamp)) - released();
    }

    /**
     * @dev Getter for the amount of releasable `token` tokens. `token` should be the address of an
     * IERC20 contract.
     */
    function releasable(address token) public view virtual returns (uint256) {
        return vestedAmount(token, uint64(block.timestamp)) - released(token);
    }

    /**
     * @dev Release the native token (ether) that have already vested.
     *
     * Emits a {EtherReleased} event.
     */
    function release() public virtual {
        uint256 amount = releasable();
        _released += amount;
        emit EtherReleased(amount);
        AddressUpgradeable.sendValue(payable(owner()), amount);
    }

    /**
     * @dev Release the tokens that have already vested.
     *
     * Emits a {ERC20Released} event.
     */
    function release(address token) public virtual {
        uint256 amount = releasable(token);
        _erc20Released[token] += amount;
        emit ERC20Released(token, amount);
        SafeERC20Upgradeable.safeTransfer(IERC20Upgradeable(token), owner(), amount);
    }

    /**
     * @dev Calculates the amount of ether that has already vested. Default implementation is a linear vesting curve.
     */
    function vestedAmount(uint64 timestamp) public view virtual returns (uint256) {
        return _vestingSchedule(address(this).balance + released(), timestamp);
    }

    /**
     * @dev Calculates the amount of tokens that has already vested. Default implementation is a linear vesting curve.
     */
    function vestedAmount(address token, uint64 timestamp) public view virtual returns (uint256) {
        return _vestingSchedule(IERC20Upgradeable(token).balanceOf(address(this)) + released(token), timestamp);
    }

    /**
     * @dev Virtual implementation of the vesting formula. This returns the amount vested, as a function of time, for
     * an asset given its total historical allocation.
     */
    function _vestingSchedule(uint256 totalAllocation, uint64 timestamp) internal view virtual returns (uint256) {
        if (timestamp < start()) {
            return 0;
        } else if (timestamp >= end()) {
            return totalAllocation;
        } else {
            return (totalAllocation * (timestamp - start())) / duration();
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[47] private __gap;
}
