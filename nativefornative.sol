/// @param dstChainId The message ordering nonce
/// @param bridgeToken The remote Bridge address
/// @param srcPoolId The token contract on the local chain
/// @param dstPoolId The qty of local _token contract tokens  
/// @param nativeAmountIn The amount of native token coming in on source  
/// @param to The address to send the destination tokens to
/// @param amountOutMin The minimum amount of stargatePoolId token to get out of amm router
/// @param amountOutMinSg The minimum amount of stargatePoolId token to get out on destination chain
/// @param amountOutMinDest The minimum amount of native token to receive on destination
/// @param deadline The overall deadline
/// @param destStargateComposed The destination contract address that must implement sgReceive()
function swapNativeForNative(
    uint16 dstChainId,                      
    address bridgeToken,                    
    uint16 srcPoolId,                       
    uint16 dstPoolId,                       
    uint nativeAmountIn,                    
    address to,                             
    uint amountOutMin,                      
    uint amountOutMinSg,                    
    uint amountOutMinDest,                  
    uint deadline,                          
    address destStargateComposed            
)
