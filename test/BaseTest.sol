// SPDX-License-Identifier: GPL-3
pragma solidity ^0.8.15;

import "lib/forge-std/src/console2.sol";
import "./utils/DSTestPlus.sol";
import "./utils/MigratorHarness.sol";
import "src/Migrator.sol";
import "src/interfaces/IMigrator.sol";

contract BaseTest is DSTestPlus {
    Migrator public migrator;
    MigratorHarness public migratorHarness;
    ProxyAdmin public proxyAdmin;
    TransparentUpgradeableProxy migratorProxy;
    TransparentUpgradeableProxy migratorHarnessProxy;

    // Initialization parameters
    WETH public weth = WETH(payable(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2));
    IERC20 public token = IERC20(0xdBdb4d16EdA451D0503b854CF79D55697F90c8DF);
    IERC20 public bpt = IERC20(0xf16aEe6a71aF1A9Bc8F56975A4c2705ca7A782Bc);
    IERC20 public auraBpt = IERC20(0x8B227E3D50117E80a02cd0c67Cd6F89A8b7B46d7);
    IUniswapV2Pair public slp = IUniswapV2Pair(0xC3f279090a47e80990Fe3a9c30d24Cb117EF91a8);
    IRewardPool4626 public auraPool = IRewardPool4626(0x8B227E3D50117E80a02cd0c67Cd6F89A8b7B46d7);
    AggregatorV3Interface public tokenPrice = AggregatorV3Interface(0x194a9AaF2e0b67c35915cD01101585A33Fe25CAa);
    AggregatorV3Interface public wethPrice = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    IUniswapV2Router02 public sushiRouter = IUniswapV2Router02(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);
    IVault public balancerVault = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);

    // Test variables
    address public user;
    uint256 public userPrivateKey = 0xBEEF;
    uint256 public TOKEN_1 = 1e18;
    uint256 public TOKEN_100K = 1e23;
    uint256 public TOKEN_1M = 1e24;
    uint256 public BPS = 10000;

    IMigrator.InitializationParams public params =
        IMigrator.InitializationParams(
            address(weth),
            address(token),
            address(bpt),
            address(auraBpt),
            address(slp),
            address(auraPool),
            address(tokenPrice),
            address(wethPrice),
            address(sushiRouter),
            address(balancerVault)
        );

    function setUp() public {
        user = hevm.addr(userPrivateKey);

        migrator = new Migrator();
        proxyAdmin = new ProxyAdmin();
        migratorProxy = new TransparentUpgradeableProxy(address(migrator), address(proxyAdmin), "");
        migrator.initialize(params);

        migratorHarness = new MigratorHarness();
        proxyAdmin = new ProxyAdmin();
        migratorHarnessProxy = new TransparentUpgradeableProxy(address(migratorHarness), address(proxyAdmin), "");
        migratorHarness.initialize(params);
    }
}
