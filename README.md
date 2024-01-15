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