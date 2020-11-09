// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
import "../Initializable.sol";


/**
 * @dev Implementation contract with an admin() function made to clash with
 * @dev TransparentUpgradeableProxy's to test correct functioning of the
 * @dev Transparent Proxy feature.
 */
contract ClashingImplementationUpgradeSafe is __Initializable {
    function __ClashingImplementation_init() internal __initializer {
        __ClashingImplementation_init_unchained();
    }

    function __ClashingImplementation_init_unchained() internal __initializer {
    }

  function admin() external pure returns (address) {
    return 0x0000000000000000000000000000000011111142;
  }

  function delegatedFunction() external pure returns (bool) {
    return true;
  }
    uint256[50] private __gap;
}
