// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import { ERC1820RegistryCompiled } from "@superfluid-finance/ethereum-contracts/contracts/libs/ERC1820RegistryCompiled.sol";
import { ISuperfluid, ISuperToken, IERC20 } from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import { SuperTokenV1Library } from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";

using SuperTokenV1Library for ISuperToken;

contract ENSOpsForkTest is Test {
    // addresses for Ethereum mainnet
    address HOST_ADDR = 0x4E583d9390082B65Bef884b629DFA426114CED6d;
    address USDC_ADDR = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address USDCX_ADDR = 0x1BA8603DA702602A8657980e825A6DAa03Dee93a;
    address CFA_FWD_ADDR = 0xcfA132E353cB4E398080B9700609bb008eceB125;
    address STEWARDS_SAFE = 0xB162Bf7A7fD64eF32b787719335d06B2780e31D1;
    address SENDER = 0xFe89cc7aBB2C4183683ab71653C4cdc9B02D44b7;
    address AUTOWRAP_MGR_ADDR = 0x30aE282CF477E2eF28B14d0125aCEAd57Fe1d7a1;
    address AUTOWRAP_STRATEGY_ADDR = 0x1D65c6d3AD39d454Ea8F682c49aE7744706eA96d;
    ISuperfluid host = ISuperfluid(HOST_ADDR);
    IERC20 usdc = IERC20(USDC_ADDR);
    ISuperToken usdcx = ISuperToken(USDCX_ADDR);

    function setUp() public {
        vm.createSelectFork(vm.envString("RPC"));
    }

    function testSFInit() public {
        uint256 hostTS = host.getNow();
        assertGt(hostTS, 0, "host timestamp is 0");
    }

    // approve
    function _op1() internal {
        address target = USDC_ADDR;
        bytes memory callData = hex"095ea7b30000000000000000000000001ba8603da702602a8657980e825a6daa03dee93a000000000000000000000000000000000000000000003f870857a3e0e3800000";
        vm.prank(SENDER);
        (bool success, ) = address(target).call(callData);
        assertTrue(success, "op1 failed");
    }

    // wrap
    function _op2() internal {
        address target = USDCX_ADDR;
        bytes memory callData = hex"45977d03000000000000000000000000000000000000000000003f870857a3e0e3800000";
        vm.prank(SENDER);
        (bool success, ) = address(target).call(callData);
        assertTrue(success, "op2 failed");
    }

    // flow
    function _op3() internal {
        address target = CFA_FWD_ADDR;
        bytes memory callData = hex"57e6aa360000000000000000000000001ba8603da702602a8657980e825a6daa03dee93a000000000000000000000000b162bf7a7fd64ef32b787719335d06b2780e31d100000000000000000000000000000000000000000000000001958f989989a35c";
        vm.prank(SENDER);
        (bool success, ) = address(target).call(callData);
        assertTrue(success, "op3 failed");
    }

    // approve autowrap
    function _op4() internal {
        address target = USDC_ADDR;
        bytes memory callData = hex"095ea7b30000000000000000000000001d65c6d3ad39d454ea8f682c49ae7744706ea96d0000000000000000000000000000000000000000000437f78dd1e1ef1b800000";
        vm.prank(SENDER);
        (bool success, ) = address(target).call(callData);
        assertTrue(success, "op4 failed");
    }

    // schedule autowrap
    function _op5() internal {
        address target = AUTOWRAP_MGR_ADDR;
        bytes memory callData = hex"5626f9e60000000000000000000000001ba8603da702602a8657980e825a6daa03dee93a0000000000000000000000001d65c6d3ad39d454ea8f682c49ae7744706ea96d000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000000b2d05e0000000000000000000000000000000000000000000000000000000000000546000000000000000000000000000000000000000000000000000000000000278d00";
        vm.prank(SENDER);
        (bool success, ) = address(target).call(callData);
        assertTrue(success, "op5 failed");
    }

    function testOps() public {
        console.log("initial USDC allowance to USDCx", usdc.allowance(SENDER, USDCX_ADDR));
        _op1();

        console.log("sender USDC balance (6 digits) before upgrading", usdc.balanceOf(SENDER));

        _op2();

        console.log("sender USDC balance (6 digits) after upgrading ", usdc.balanceOf(SENDER));
        console.log("sender USDCx balance (18 digits) after upgrading", usdcx.balanceOf(SENDER));

        _op3();

        // 9863.01369863 * 1e18 / 86400
        int96 expectedFlowRate = 114155251141550940;
        assertEq(usdcx.getFlowRate(SENDER, STEWARDS_SAFE), expectedFlowRate, "flowrate is a instead of expected b");

        _op4();

        console.log("USDC allowance for autowrap", usdc.allowance(SENDER, AUTOWRAP_STRATEGY_ADDR));

        uint256 expectedAutoWrapAllowance = 5_100_000 ether;
        assertEq(usdc.allowance(SENDER, AUTOWRAP_STRATEGY_ADDR), expectedAutoWrapAllowance, "autowrap allowance is a instead of expected b");

        _op5();
    }
}
