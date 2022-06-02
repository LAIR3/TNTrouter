// Use the amm router to swap the incoming bridge token into native token

if(_tokenOut == address(0x0)){
    address[] memory path = new address[](2);
    path[0] = _token;
    path[1] = IUniswapV2Router02(ammRouter).WETH();

    try IUniswapV2Router02(ammRouter).swapExactTokensForETH(
        amountLD,           // the stable received from stargate at the destination
        _amountOutMin,      // slippage param, min amount native token out
        path,               // path[0]: stabletoken address, path[1]: WETH from sushi router
        _toAddr,            // the address to send the *out* native to
        _deadline           // the unix timestamp deadline
    ) {
        emit ReceivedOnDestination(
            OUT_TO_NATIVE, 
            address(_toAddr).balance.sub(_toBalancePreTransferOut)
        );
    } catch {
        IERC20(_token).transfer(_toAddr, amountLD);
        emit ReceivedOnDestination(_token, amountLD);
    }
}
