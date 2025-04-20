// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/MyToken.sol"; // 导入你自己的合约

import "@openzeppelin/contracts/access/Ownable.sol"; // 确保导入 Ownable 合约

contract MyTokenTest is Test {
    MyToken token;

    function setUp() public {
        token = new MyToken(10000);
    }

    function testMintAndTransfer() public {
        token.mint(address(this), 1000 ether);
        token.transfer(address(0xBEEF), 500 ether);
        assertEq(token.balanceOf(address(0xBEEF)), 500 ether);
    }

    function testBurn() public {
        token.mint(address(this), 500 ether);
        token.transfer(address(0xBEEF), 500 ether);
        assertEq(token.balanceOf(address(0xBEEF)), 500 ether);

        token.burn(address(0xBEEF), 500 ether);
        assertEq(token.balanceOf(address(0xBEEF)), 0 ether);
    }

    function testOnlyOwnerCanMint() public {
        address attacker = address(0xDEAD);
        vm.prank(attacker); // 模拟攻击者调用
        //正确的报错捕获
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                attacker
            )
        ); // <- 正确捕获错误
        token.mint(attacker, 1000);
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), 10000);
        assertEq(token.balanceOf(address(this)), 10000);
    }
}
