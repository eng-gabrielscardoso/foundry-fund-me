// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from 'forge-std/Script.sol';

struct NetworkConfig {
    address priceFeed;
}

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        }

        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        }

        if {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function setUp() public view {}

    function run() external {}

    /**
     * Get in Chainlink Data Feeds
     * @link https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=ETH/USD
     */
    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({ priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 });

        return mainnetConfig;
    }

    /**
     * Get in Chainlink Data Feeds
     * @link https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=ETH/USD
     */
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({ priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 });

        return sepoliaConfig;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        //
    }
}
