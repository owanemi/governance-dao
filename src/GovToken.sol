// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import {ERC20Votes} from "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol";
// import {Nonces} from "lib/openzeppelin-contracts/contracts/utils/Nonces.sol";

contract GovToken is ERC20, ERC20Permit, ERC20Votes {
    constructor() ERC20("GovToken", "GOV") ERC20Permit("GovToken") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }
}
