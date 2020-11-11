// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../GSN/GSNRecipientUpgradeSafe.sol";
import "../GSN/GSNRecipientSignatureUpgradeSafe.sol";
import "../proxy/Initializable.sol";

contract GSNRecipientSignatureMockUpgradeSafe is Initializable, GSNRecipientUpgradeSafe, GSNRecipientSignatureUpgradeSafe {
    function __GSNRecipientSignatureMock_init(address trustedSigner) internal initializer {
        __Context_init_unchained();
        __GSNRecipient_init_unchained();
        __GSNRecipientSignature_init_unchained(trustedSigner);
        __GSNRecipientSignatureMock_init_unchained(trustedSigner);
    }

    function __GSNRecipientSignatureMock_init_unchained(address trustedSigner) internal initializer { }

    event MockFunctionCalled();

    function mockFunction() public {
        emit MockFunctionCalled();
    }
    uint256[50] private __gap;
}
