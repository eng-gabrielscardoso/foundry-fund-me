// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

struct NetworkConfig {
    address priceFeed;
}

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    uint256 public constant MAINNET_CHAINID = 1;
    uint256 public constant SEPOLIA_CHAINID = 11155111;

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == MAINNET_CHAINID) {
            activeNetworkConfig = getMainnetEthConfig();
            console.log("Running using Mainnet");
        } else if (block.chainid == SEPOLIA_CHAINID) {
            activeNetworkConfig = getSepoliaEthConfig();
            console.log("Running using Sepolia");
        } else {
            activeNetworkConfig = getAnvilEthConfig();
            console.log("Running using Anvil");
        }
    }

    function setUp() public view {}

    function run() external {}

    /**
     * Get in Chainlink Data Feeds
     * https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=ETH/USD
     */
    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });

        return mainnetConfig;
    }

    /**
     * Get in Chainlink Data Feeds
     * https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=ETH/USD
     */
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );

        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}
