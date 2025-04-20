// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/MyToken.sol";  // 引入你的 ERC20 合约

contract DeployScript is Script{
    MyToken public mytoken;

    function setUp() public{}

    function run() public{
        vm.startBroadcast();

        mytoken = new MyToken(10000);

        vm.stopBroadcast();
    }
}
