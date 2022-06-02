// Unpack the payload to get _tokenOut,_deadline,_amountOutMin,_toAddr. Approve the amm router so it can swap our tokens. Get the pre balance of the _toAddr to emit an event of exact amount sent.

(address _tokenOut, uint _deadline, uint _amountOutMin, address _toAddr) = abi.decode(payload, (address, uint, uint, address));

IERC20(_token).approve(address(ammRouter), amountLD);

uint _toBalancePreTransferOut = address(_toAddr).balance;
