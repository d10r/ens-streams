# About

Simluates the set up of a stream with autowrap from the ENS DAO to a steward contract.
See https://hackmd.io/@alexvansande/HJ6VyJQFp

Needs foundry to be installed, see https://book.getfoundry.sh/getting-started/installation

After checking out, run `forge install`.
Then you can run the fork test with:

```
RPC=https://eth.llamarpc.com forge test -vv
```

The calldata was generated with `get-calldata.sh`.
If changing that script, make sure to also update the callData values in `ENSOpsForkTest.t.sol`.

Current output of the script:
```
OPERATION 1: approve USDCx SuperToken contract to transfer 300k USDC
target: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
function: approve(address spender, uint256 amount)
calldata: 0x095ea7b30000000000000000000000001ba8603da702602a8657980e825a6daa03dee93a00000000000000000000000000000000000000000000000000000045d964b800

OPERATION 2: wrap 300k USDC to USDCX
target 0x1BA8603DA702602A8657980e825A6DAa03Dee93a
function: upgrade(uint256 amount)
calldata: 0x45977d03000000000000000000000000000000000000000000003f870857a3e0e3800000

OPERATION 3: start flow to Safe with flowrate of 9,863.01369863 / day
target: 0xcfA132E353cB4E398080B9700609bb008eceB125
function: setFlowrate(ISuperToken token, address receiver, int96 flowrate)
calldata: 0x57e6aa360000000000000000000000001ba8603da702602a8657980e825a6daa03dee93a000000000000000000000000b162bf7a7fd64ef32b787719335d06b2780e31d100000000000000000000000000000000000000000000000001958f989989a35c

OPERATION 4: approve auto-wrap for 5.1M
target: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
function: approve(address spender, uint256 amount)
calldata: 0x095ea7b30000000000000000000000001d65c6d3ad39d454ea8f682c49ae7744706ea96d000000000000000000000000000000000000000000000000000004a36fb03800

OPERATION 5: create auto-wrap schedule
target: 0x30aE282CF477E2eF28B14d0125aCEAd57Fe1d7a1
function: createWrapSchedule(address superToken, address strategy, address liquidityToken, uint64 expiry, uint64 lowerLimit,  uint64 upperLimit)
calldata: 0x5626f9e60000000000000000000000001ba8603da702602a8657980e825a6daa03dee93a0000000000000000000000001d65c6d3ad39d454ea8f682c49ae7744706ea96d000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000000b2d05e0000000000000000000000000000000000000000000000000000000000001baf80000000000000000000000000000000000000000000000000000000000041eb00

```