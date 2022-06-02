function addLiquidity(
    uint _poolId,         // the stargate poolId representing the specific ERC20 token
    uint256 _amountLD,    // the amount to loan. quantity in local decimals
    address _to           // the address to receive the LP token. ie: shares of the pool
)

function redeemLocal(
    uint16 _dstChainId,             // the chainId to remove liquidity
    uint256 _srcPoolId,             // the source poolId
    uint256 _dstPoolId,             // the destination poolId
    address payable _refundAddress, // refund extra native gas to this address
    uint256 _amountLP,              // quantity of LP tokens to redeem
    bytes calldata _to,             // address to send the redeemed poolId tokens
    lzTxObj memory _lzTxParams      // adpater parameters 
)

// redeem remote liquidity

function redeemRemote(
    uint16 _dstChainId,             // the chainId to remove liquidity
    uint256 _srcPoolId,             // the source poolId
    uint256 _dstPoolId,             // the destination poolId
    address payable _refundAddress, // refund extra native gas to this address
    uint256 _amountLP,              // quantity of LP tokens to redeem
    uint256 _minAmountLD,           // slippage amount in local decimals
    bytes calldata _to,             // the address to redeem the poolId asset to
    lzTxObj memory _lzTxParams      // adpater parameters 
) 

function sendCredits(
    uint16 _dstChainId,             // destination chainId
    uint256 _srcPoolId,             // source poolId
    uint256 _dstPoolId,             // destination poolId
    address payable _refundAddress  // refund extra native gas to this address
)
