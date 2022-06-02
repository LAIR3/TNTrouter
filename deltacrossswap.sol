// perform a Stargate swap() in a solidity smart contract function
// the msg.value is the "fee" that Stargate needs to pay for the cross chain message
IStargateRouter(routerAddress).swap{value:msg.value}(
    10006,                           // send to Fuji (use LayerZero chainId)
    1,                               // source pool id
    1,                               // dest pool id                 
    msg.sender,                      // refund adddress. extra gas (if any) is returned to this address
    qty,                             // quantity to swap
    amountOutMin,                    // the min qty you would accept on the destination
    IStargateRouter.lzTxObj(0, 0, "0x")  // 0 additional gasLimit increase, 0 airdrop, at 0x address
    abi.encodePacked(msg.sender),    // the address to send the tokens to on the destination
    bytes("")                        // bytes param, if you wish to send additional payload you can abi.encode() them here
);

// ethers.js frontend to call the swap
let tx = await router.swap(
    2,                     // destination chainId
    1,                     // source poolId
    1,                     // destination poolId
    yourAddress,           // refund address. extra gas (if any) is returned to this address
    qty,                   // quantity to swap  
    amountOutMin,          // the min qty you would accept on the destination
    { dstGasForCall: 0, dstNativeAmount: 0, dstNativeAddr: "0x" },
    yourAddress,           // the address to send the tokens to on the destination
    "",                    // payload
    {value: fee}           // "fee" is the native gas to pay for the cross chain message fee. see 
);

// guess gas fee

let messageFee = ethers.utils.parseEther('0.025');     // send 0.02 eth converter to wei
await stargateRouter.swap(..., {value: messageFee});  // swap asset across chains

// Use quoteLayerZeroFee() to get the fee required to call swap(). The fee ensures the cross chain message is paid for.

// Router.sol method to get the value for swap()
function quoteLayerZeroFee(
    uint16 _dstChainId,
    uint8 _functionType,
    bytes calldata _toAddress,
    bytes calldata _transferAndCallPayload,
    Router.lzTxObj memory _lzTxParams
) external view override returns (uint256, uint256)

// use fee estimate

let quoteData = await router.quoteLayerZeroFee(
    dstChainId,                 // destination chainId
    functionType,               // function type: see Bridge.sol for all types
    toAddress,                  // destination of tokens
    "",                         // payload, using abi.encode()
    ({
        dstGasForCall: 0,       // extra gas, if calling smart contract,
        dstNativeAmount: 0,     // amount of dust dropped in destination wallet 
        dstNativeAddr: taskArgs.dstNativeAddr // destination wallet for dust
    })
)


// quoteLayerZeroFee() estimates the message fee and returns an amount of wei in source gas token. Use this as the { value: xxxx } passed to the actual swap() method when you perform the swap.
// Note:  quoteLayerZeroFee() returns a 2-value tuple:
// the message fee is the first value in the tuple.
let feeWei = quoteData[0]

// ethersjs example: call swap() with the feeWei value from quoteLayerZeroFee
// execute a Stargate swap on the Router.sol contract
await router.swap(
    dstChainId,
    srcPoolId,
    dstPoolId,
    payable(refundAddress),
    qty,
    qtyMin,
    { dstGasForCall: 0, dstNativeAmount: 0, dstNativeAddr: "0x" },   // lzTxObj
    toAddress, 
    "0x", // no payload
    { value: feeWei }  // <------ feeWei from quoteData[0] from quoteLayerZeroFee()   
)
