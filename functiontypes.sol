// all function types
uint8 public constant TYPE_SWAP_REMOTE            = 1;
uint8 public constant TYPE_ADD_LIQUIDITY          = 2;
uint8 public constant TYPE_REDEEM_LOCAL_CALL_BACK = 3;
uint8 public constant TYPE_WITHDRAW_REMOTE        = 4;

/* 

Function types are used to by quoteLayerZeroFee() to get the cross chain message fee.
For standard a Stargate swap(), use function type = 1

Each of the above types corresponds to a function within Stargate that sends a cross chain message.
Type 1: Used for swap()
Type 2: Used for addLiquidity()
Type 3: Used for the B->A portion of an A->B->A withdrawLocal()
Type 4: Use to initiate a withdrawLocal() 

*/
