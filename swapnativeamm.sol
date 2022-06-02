// special token value that indicates the sgReceive() should swap OUT native asset
address public OUT_TO_NATIVE = 0x0000000000000000000000000000000000000000;

uint bridgeAmount;
// using the amm router, swap native into the Stargate pool token, sending the output token to this contract
{
    // create path[] for amm swap
    address[] memory path = new address[](2);
    path[0] = IUniswapV2Router02(ammRouter).WETH();    // native IN requires that we specify the WETH in path[0]
    path[1] = bridgeToken;                             // the bridge token,

    uint[] memory amounts = IUniswapV2Router02(ammRouter).swapExactETHForTokens{value:nativeAmountIn}(
        amountOutMin,
        path,
        address(this),
        deadline
    );

    bridgeAmount = amounts[1];
    require(bridgeAmount > 0, 'error: ammRouter gave us 0 tokens to swap() with stargate');

    // this contract needs to approve the stargateRouter to spend its path[1] token!
    IERC20(bridgeToken).approve(address(stargateRouter), bridgeAmount);
}

// encode payload data to send to destination contract, which it will handle with sgReceive()
bytes memory data;
{
    data = abi.encode(OUT_TO_NATIVE, deadline, amountOutMinDest, to);
}
