// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./IUniswapV4Pool.sol";
import "../v4-core/src/libraries/TickMath.sol";
import "./IERC20.sol";

interface IHooks {
    function afterSwap(
        address sender,
        PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external returns (bytes4, int128);

}

contract RebalancingHook is IHooks {
    address public immutable token0;
    address public immutable token1;
    address public immutable pool;

    int24 public constant MAX_TICK = 887272; // Maximum tick value in Uniswap V4

    constructor(address _token0, address _token1, address _pool) {
        require(_token0 != address(0), "Token0 address is zero");
        require(_token1 != address(0), "Token1 address is zero");
        require(_pool != address(0), "Pool address is zero");

        token0 = _token0;
        token1 = _token1;
        pool = _pool;
    }

    function calculateSqrtPrice(int24 price) external pure returns (uint160) {
        return TickMath.getSqrtPriceAtTick(price);
    }

    function afterSwap(
        address,
        address,
        int256,
        int256,
        uint160 sqrtPriceX96,
        bytes calldata
    ) external {
        require(msg.sender == pool, "Unauthorized: Only pool can call");
        int24 currentTick = TickMath.getTickAtSqrtPrice(sqrtPriceX96);

        IUniswapV4Pool(pool).burn(currentTick - 1, MAX_TICK, type(uint128).max);
        IERC20(token0).approve(pool, type(uint256).max);
        IERC20(token1).approve(pool, type(uint256).max);

        IUniswapV4Pool(pool).mint(
            address(this),
            currentTick,
            MAX_TICK,
            type(uint128).max,
            abi.encode(0)
        );
    }

}
