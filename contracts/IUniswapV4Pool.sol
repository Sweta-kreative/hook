// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @dev Interface for Uniswap V4 Pool.
 * Includes hooks and other advanced features introduced in Uniswap V4.
 */
interface IUniswapV4Pool {
    // Structs and enums may vary in Uniswap V4.
    
    /**
     * @notice Returns the current state of the pool.
     * @return sqrtPriceX96 The current sqrt price of the pool as a Q64.96 value.
     * @return tick The current tick of the pool, i.e., log base 1.0001 of price.
     * @return observationIndex The index of the last oracle observation.
     * @return observationCardinality The current maximum number of observations stored.
     * @return observationCardinalityNext The next maximum number of observations.
     */
    function slot0()
        external
        view
        returns (
            uint160 sqrtPriceX96,
            int24 tick,
            uint16 observationIndex,
            uint16 observationCardinality,
            uint16 observationCardinalityNext
        );

    /**
     * @notice Burn liquidity from the pool and collect tokens owed for a given position.
     * @param tickLower The lower tick of the position.
     * @param tickUpper The upper tick of the position.
     * @param amount The amount of liquidity to burn.
     * @return amount0 Amount of token0 sent to the recipient.
     * @return amount1 Amount of token1 sent to the recipient.
     */
    function burn(
        int24 tickLower,
        int24 tickUpper,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1);

    /**
     * @notice Mint liquidity for the pool.
     * @param recipient The address for which the liquidity will be created.
     * @param tickLower The lower tick of the position in which to add liquidity.
     * @param tickUpper The upper tick of the position in which to add liquidity.
     * @param amount The amount of liquidity to mint.
     * @param data Any data that should be passed through to the mint callback.
     * @return amount0 Amount of token0 required for the minted liquidity.
     * @return amount1 Amount of token1 required for the minted liquidity.
     */
    function mint(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        bytes calldata data
    ) external returns (uint256 amount0, uint256 amount1);

    /**
     * @notice Hook function to trigger custom logic on swaps or other pool interactions.
     * Details on hooks in V4 are speculative and may need adjustments.
     */
    function hook(bytes calldata data) external;
}
