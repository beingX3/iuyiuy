// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IBeaconUpgradeable} from "../proxy/beacon/IBeaconUpgradeable.sol";
import {Initializable} from "../proxy/utils/Initializable.sol";

contract UpgradeableBeaconMockUpgradeable is Initializable, IBeaconUpgradeable {
    address public implementation;

    function __UpgradeableBeaconMock_init(address impl) internal onlyInitializing {
        __UpgradeableBeaconMock_init_unchained(impl);
    }

    function __UpgradeableBeaconMock_init_unchained(address impl) internal onlyInitializing {
        implementation = impl;
    }
}

interface IProxyExposedUpgradeable {
    // solhint-disable-next-line func-name-mixedcase
    function $getBeacon() external view returns (address);
}

contract UpgradeableBeaconReentrantMockUpgradeable is Initializable, IBeaconUpgradeable {
    error BeaconProxyBeaconSlotAddress(address beacon);

    function __UpgradeableBeaconReentrantMock_init() internal onlyInitializing {
    }

    function __UpgradeableBeaconReentrantMock_init_unchained() internal onlyInitializing {
    }
    function implementation() external view override returns (address) {
        // Revert with the beacon seen in the proxy at the moment of calling to check if it's
        // set before the call.
        revert BeaconProxyBeaconSlotAddress(IProxyExposedUpgradeable(msg.sender).$getBeacon());
    }
}
