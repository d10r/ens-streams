#!/bin/bash

# computes the calldata for the operations to be done for ENS streams
# requires "cast" installed, see https://book.getfoundry.sh/getting-started/installation

set -eu

USDC_ADDR="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
USDCX_ADDR="0x1BA8603DA702602A8657980e825A6DAa03Dee93a"
STEWARDS_SAFE="0xB162Bf7A7fD64eF32b787719335d06B2780e31D1"

echo "OPERATION 1: approve USDCx SuperToken contract to transfer 300k USDC"
AMOUNT=$(cast to-wei 300000)
echo "target: $USDC_ADDR"
echo -n "calldata: "
cast calldata "approve(address,uint256)" $USDCX_ADDR $AMOUNT
echo

echo "OPERATION 2: wrap 300k USDC to USDCX"
echo "target $USDCX_ADDR"
echo -n "calldata: "
cast calldata "upgrade(uint256)" $AMOUNT
echo

echo "OPERATION 3: start flow to Safe with flowrate of 9,863.01369863 / day"
# 9863.01369863 * 1e18 / 86400
FLOWRATE="114155251141550940"
CFA_FWD_ADDR="0xcfA132E353cB4E398080B9700609bb008eceB125"
echo "target: $CFA_FWD_ADDR"
echo -n "calldata: "
# setFlowrate(ISuperToken token, address receiver, int96 flowrate)
cast calldata "setFlowrate(address,address,int96)" $USDCX_ADDR $STEWARDS_SAFE $FLOWRATE
echo

echo "OPERATION 4: approve auto-wrap for 5.1M"
# autowrap addresses, see https://github.com/superfluid-finance/protocol-monorepo/blob/dev/packages/metadata/networks.json
AW_STRAT_ADDR="0x1D65c6d3AD39d454Ea8F682c49aE7744706eA96d"
AW_AMOUNT=$(cast to-wei 5100000)
echo "target: $USDC_ADDR"
echo -n "calldata: "
cast calldata "approve(address,uint256)" $AW_STRAT_ADDR $AW_AMOUNT
echo

echo "OPERATION 5: create auto-wrap schedule"
#function createWrapSchedule(address superToken, address strategy, address liquidityToken, uint64 expiry, uint64 lowerLimit,  uint64 upperLimit)
AW_MGR_ADDR="0x30aE282CF477E2eF28B14d0125aCEAd57Fe1d7a1"
# same expiry value as in https://github.com/superfluid-finance/widget/blob/master/packages/widget/src/CommandMapper.tsx#L102
EXPIRY=3000000000
# 4 days (minimum is 2 days)
LOWER_LIMIT=345600
# 30 days (minimum is 7 days)
UPPER_LIMIT=2592000
echo "target: $AW_MGR_ADDR"
echo -n "calldata: "
cast calldata "createWrapSchedule(address,address,address,uint64,uint64,uint64)" $USDCX_ADDR $AW_STRAT_ADDR $USDC_ADDR $EXPIRY $LOWER_LIMIT $UPPER_LIMIT

