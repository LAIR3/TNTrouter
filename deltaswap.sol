/// @param qty The remote chainId sending the tokens
/// @param bridgeToken The remote Bridge address
/// @param dstChainId The message ordering nonce
/// @param srcPoolId The token contract on the local chain
/// @param dstPoolId The qty of local _token contract tokens  
/// @param to The bytes containing the toAddress
/// @param deadline The bytes containing the toAddress
/// @param destStargateComposed The bytes containing the toAddress
function swap(
    uint qty,
    address bridgeToken,                    
    uint16 dstChainId,                      
    uint16 srcPoolId,                       
    uint16 dstPoolId,                       
    address to,                             
    uint deadline,                          
    address destStargateComposed            
) external payable {
    require(msg.value > 0, "stargate requires a msg.value to pay crosschain message");
    require(qty > 0, 'error: swap() requires qty > 0');

    // encode payload data to send to destination contract, which it will handle with sgReceive()
    bytes memory data = abi.encode(to);

    // this contract calls stargate swap()
    IERC20(bridgeToken).transferFrom(msg.sender, address(this), qty);
    IERC20(bridgeToken).approve(address(stargateRouter), qty);

    // Stargate's Router.swap() function sends the tokens to the destination chain.
    IStargateRouter(stargateRouter).swap{value:msg.value}(
        dstChainId,                                     // the destination chain id
        srcPoolId,                                      // the source Stargate poolId
        dstPoolId,                                      // the destination Stargate poolId
        payable(msg.sender),                            // refund adddress. if msg.sender pays too much gas, return extra eth
        qty,                                            // total tokens to send to destination chain
        0,                                              // min amount allowed out
        IStargateRouter.lzTxObj(200000, 0, "0x"),       // default lzTxObj
        abi.encodePacked(destStargateComposed),         // destination address, the sgReceive() implementer
        data                                            // bytes payload
    );
}
