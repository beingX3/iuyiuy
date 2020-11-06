// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../token/ERC721/ERC721UpgradeSafe.sol";
import "../Initializable.sol";

/**
 * @title ERC721Mock
 * This mock just provides a public safeMint, mint, and burn functions for testing purposes
 */
contract ERC721MockUpgradeSafe is __Initializable, ERC721UpgradeSafe {
    function __ERC721Mock_init(string memory name, string memory symbol) internal __initializer {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __ERC721_init_unchained(name, symbol);
        __ERC721Mock_init_unchained(name, symbol);
    }

    function __ERC721Mock_init_unchained(string memory name, string memory symbol) internal __initializer { }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function setTokenURI(uint256 tokenId, string memory uri) public {
        _setTokenURI(tokenId, uri);
    }

    function setBaseURI(string memory baseURI) public {
        _setBaseURI(baseURI);
    }

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    function safeMint(address to, uint256 tokenId, bytes memory _data) public {
        _safeMint(to, tokenId, _data);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }
}
