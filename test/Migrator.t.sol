// SPDX-License-Identifier: GPL-3
pragma solidity ^0.8.15;

import "./BaseTest.sol";

contract MigratorTest is BaseTest {
    // Test migrating from LP to auraBPT
    function test_migrateToAuraBpt(uint256 _amount) external {
        // Set range to be less than 10% of LP supply
        uint256 lpSupply = lpToken.totalSupply();
        hevm.assume(_amount <= ((lpSupply * 1000) / BPS) && _amount > 1 ether);

        // Seed user with LP
        deal(address(lpToken), user, _amount);

        // User should only have LP
        assertEq(lpToken.balanceOf(user), _amount);
        assertEq(balancerPoolToken.balanceOf(user), 0);
        assertEq(auraPool.balanceOf(user), 0);

        // Off-chain parameters
        IMigrator.MigrationAddresses memory migrationAddresses = getMigrationAddresses();
        IMigrator.MigrationDetails memory migrationDetails = getMigrationDetails(_amount, true);

        hevm.startPrank(user);
        lpToken.approve(address(migrator), _amount);
        migrator.migrate(migrationAddresses, migrationDetails);
        hevm.stopPrank();

        // User should only have auraBPT (auraBPT amount > original LP amount)
        assertEq(lpToken.balanceOf(user), 0);
        assertEq(balancerPoolToken.balanceOf(user), 0);
        assertGt(auraPool.balanceOf(user), _amount);

        // Migrator should have no funds
        assertEq(weth.balanceOf(address(migrator)), 0);
        assertEq(token.balanceOf(address(migrator)), 0);
        assertEq(balancerPoolToken.balanceOf(address(migrator)), 0);
        assertEq(auraPool.balanceOf(address(migrator)), 0);
        assertEq(lpToken.balanceOf(address(migrator)), 0);
        assertEq((address(migrator).balance), 0);
    }

    // Test migrating from LP to BPT
    function test_migrateToBpt(uint256 _amount) external {
        // Set range to be less than 10% of LP supply
        uint256 lpSupply = lpToken.totalSupply();
        hevm.assume(_amount <= ((lpSupply * 1000) / BPS) && _amount > 1 ether);

        // Seed user with LP
        deal(address(lpToken), user, _amount);

        // User should only have LP
        assertEq(lpToken.balanceOf(user), _amount);
        assertEq(balancerPoolToken.balanceOf(user), 0);
        assertEq(auraPool.balanceOf(user), 0);

        // Off-chain parameters
        IMigrator.MigrationAddresses memory migrationAddresses = getMigrationAddresses();
        IMigrator.MigrationDetails memory migrationDetails = getMigrationDetails(_amount, false);

        hevm.startPrank(user);
        lpToken.approve(address(migrator), _amount);
        migrator.migrate(migrationAddresses, migrationDetails);
        hevm.stopPrank();

        // User should only have BPT (BPT amount > original LP amount)
        assertEq(lpToken.balanceOf(user), 0);
        assertGt(balancerPoolToken.balanceOf(user), _amount);
        assertEq(auraPool.balanceOf(user), 0);

        // Migrator should have no funds
        assertEq(weth.balanceOf(address(migrator)), 0);
        assertEq(token.balanceOf(address(migrator)), 0);
        assertEq(balancerPoolToken.balanceOf(address(migrator)), 0);
        assertEq(auraPool.balanceOf(address(migrator)), 0);
        assertEq(lpToken.balanceOf(address(migrator)), 0);
        assertEq((address(migrator).balance), 0);
    }
}
