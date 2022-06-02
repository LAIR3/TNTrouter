IStargateRouter(stargateRouter).swap{value:msg.value.sub(nativeAmountIn)}(
    dstChainId,                               // the destination chain id
    srcPoolId,                                // the source Stargate poolId
    dstPoolId,                                // the destination Stargate poolId
    payable(msg.sender),                      // refund adddress. if msg.sender pays too much gas, return extra eth
    bridgeAmount,                             // total tokens to send to destination chain
    amountOutMinSg,                           // minimum
    IStargateRouter.lzTxObj(500000, 0, "0x"), // 500,000 for the sgReceive()
    abi.encodePacked(destStargateComposed),   // destination address, the sgReceive() implementer
    data                                      // bytes payload
);
