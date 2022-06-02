// Use the amm router to swap the incoming bridge token into an ERC20 token

else {
    uint _toAddrTokenBalancePre = IERC20(_tokenOut).balanceOf(_toAddr);
    address[] memory path = new address[](2);
    path[0] = _token;
    path[1] = _tokenOut;
    try IUniswapV2Router02(ammRouter).swapExactTokensForTokens(
        amountLD,       // the stable received from stargate at the destination
        _amountOutMin,  // slippage param, min amount native token out
        path,           // path[0]: stabletoken address, path[1]: WETH from sushi router
        _toAddr,        // the address to send the *out* tokens to
        _deadline       // the unix timestamp deadline
    ) {
        emit ReceivedOnDestination(_tokenOut, IERC20(_tokenOut).balanceOf(_toAddr).sub(_toAddrTokenBalancePre));
    } catch {
        IERC20(_token).transfer(_toAddr, amountLD);
        emit ReceivedOnDestination(_token, amountLD);
    }
}
