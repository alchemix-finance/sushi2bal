// SPDX-License-Identifier: GPL-3
pragma solidity ^0.8.15;

import "solmate/src/tokens/ERC20.sol";

import "src/interfaces/aura/IRewardPool4626.sol";
import "src/interfaces/balancer/IBasePool.sol";
import "src/interfaces/sushi/IUniswapV2Pair.sol";
import "src/interfaces/sushi/IUniswapV2Router02.sol";

interface IMigrator {
    /**
     * @notice Represents the addresses, migration details, and calculations required for migration
     */
    struct MigrationParams {
        // 80/20 TOKEN/WETH Balancer Pool Token
        IBasePool balancerPoolToken;
        // UniV2 50/50 TOKEN/WETH LP Token
        IUniswapV2Pair uniswapPoolToken;
        // ERC4626 Aura pool address
        IRewardPool4626 auraPool;
        // UniV2 Router for unwrapping the LP token
        IUniswapV2Router02 router;
        // Amount of LP tokens to be migrated
        uint256 uniswapPoolTokensIn;
        // Minimum amount of Tokens to be received from the LP
        uint256 amountCompanionMinimumOut;
        // Minimum amount of WETH to be received from the LP
        uint256 amountWETHMinimumOut;
        // Amount of WETH required to create an 80/20 TOKEN/WETH balance
        uint256 wethRequired;
        // Minimum amount of Tokens from swapping excess WETH due to the 80/20 TOKEN/WETH rebalance (amountWethMin is always > wethRequired)
        uint256 minAmountTokenOut;
        // Amount of BPT to be received given the rebalanced Token and WETH amounts
        uint256 amountBalancerLiquidityOut;
        // Amount of auraBPT to be received given the amount of BPT deposited
        uint256 amountAuraSharesMinimum;
        // Indicates whether to stake the migrated BPT in the Aura pool
        bool stake;
    }

    /**
     * @notice Emitted when an account migrates from SLP to BPT or auraBPT
     * @param account The account migrating
     * @param lpAmountMigrated Amount of LP tokens migrated
     * @param amountReceived The amount of BPT or auraBPT received
     * @param staked Indicates if the account received auraBPT
     */
    event Migrated(address indexed account, uint256 lpAmountMigrated, uint256 amountReceived, bool staked);

    /**
     * @notice Migrate SLP position into BPT position
     * @param params Migration addresses, details, and calculations
     */
    function migrate(MigrationParams calldata params) external;
}
