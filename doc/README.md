## 项目开发第一阶段

完成简单的合约编写和测试

### 问题记录

#### 启动`anvil`后，发现运行了其他的合约

```
//使用forge清除缓存
forge clean
```

#### 后缀的使用

```
//测试类
ContractName.t.sol

//部署脚本类
ContractName.s.sol
```

#### 部署合约时发现部署失败错误

```
$ forge script script/DeployToken.s.sol  --rpc-url http://127.0.0.1:7545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
[⠊] Compiling...
[⠒] Compiling 22 files with Solc 0.8.26
[⠢] Solc 0.8.26 finished in 999.83ms
Compiler run successful!
The application panicked (crashed).
Message:  Unable to create fork: could not instantiate forked environment with provider 127.0.0.1; error sending request for url (http://127.0.0.1:7545/); client error (SendRequest); connection error; 你的主机中的软件中止了一个已建立的连接。 (os error 10053)
Location: crates\evm\core\src\backend\mod.rs:492

This is a bug. Consider reporting it at https://github.com/foundry-rs/foundry

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ BACKTRACE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   1: hid_write<unknown>
      at <unknown source file>:<unknown line>
   2: hid_write<unknown>
      at <unknown source file>:<unknown line>
   3: hid_write<unknown>
      at <unknown source file>:<unknown line>
   4: BaseThreadInitThunk<unknown>
      at <unknown source file>:<unknown line>
   5: RtlUserThreadStart<unknown>
      at <unknown source file>:<unknown line>

Run with COLORBT_SHOW_HIDDEN=1 environment variable to disable frame filtering.
Run with RUST_BACKTRACE=full to include source snippets.
```

关闭代理后发现部署成功！

```
$ forge script script/DeployToken.s.sol  --rpc-url http://127.0.0.1:7545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
[⠊] Compiling...
[⠊] Compiling 22 files with Solc 0.8.26
[⠢] Solc 0.8.26 finished in 981.95ms
Compiler run successful!
Script ran successfully.

## Setting up 1 EVM.

==========================

Chain 31337

Estimated gas price: 2.000000001 gwei

Estimated total gas used for script: 1547223

Estimated amount required: 0.003094446001547223 ETH

==========================

##### anvil-hardhat
✅  [Success] Hash: 0x201d4a974509526d15d0afbea4ee2ddb922368f9527e5a351b305c143d20259d
Contract Address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
Block: 1
Paid: 0.001190172001190172 ETH (1190172 gas * 1.000000001 gwei)

✅ Sequence #1 on anvil-hardhat | Total Paid: 0.001190172001190172 ETH (1190172 gas * avg 1.000000001 gwei)


==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.

Transactions saved to: C:/Users/Yotoha/Desktop/MyDocuments/1、Computer(CS)/solidity/@Yotoha0303/p4/erc20-dapp\broadcast\DeployToken.s.sol\31337\run-latest.json

Sensitive values saved to: C:/Users/Yotoha/Desktop/MyDocuments/1、Computer(CS)/solidity/@Yotoha0303/p4/erc20-dapp\cache\DeployToken.s.sol\31337\run-latest.json

```

### 使用 Ownable 进行测试

```
Contract.sol
//使用了onlyOwner
function burn(address from, uint256 amount) public onlyOwner{
        _burn(from, amount);
}
Contract.t.sol
//导入Ownable
import "@openzeppelin/contracts/access/Ownable.sol";
function testOnlyOwnerCanMint() public {
        address attacker = address(0xDEAD);
        vm.prank(attacker); // 模拟攻击者调用
        //非拥有者无法调用
        vm.expectRevert(
            abi.encodeWithSelector(
               //正确写法
                Ownable.OwnableUnauthorizedAccount.selector,
                attacker
            )
        ); // <- 正确捕获错误
        token.mint(attacker, 1000);
    }
```

## 安装类

### forge update
```
//更新openzeppelin/contracts
forge update openzeppelin-contracts

//错误方式（forge会将它视作依赖进行查找）
forge update @openzeppelin/contracts
```