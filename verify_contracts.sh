#!/bin/bash

# Core Testnet Contract Verification Script
# Make sure to update your CORESCAN_API_KEY in the .env file first!

echo "🔍 Verifying contracts on Core Testnet..."
echo "Make sure your CORESCAN_API_KEY is set in .env file"

# Load environment variables
source .env

# Verify Protocol contracts
echo "Verifying Protocol..."
forge verify-contract 0xd36e48bb0Fe86b3E6A8B0012C00591650023a50d src/Protocol.sol:Protocol --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "Verifying IsHealthy..."
forge verify-contract 0x0D07e289995A13f7685FeE5E75E654ddD1059d93 src/IsHealthy.sol:IsHealthy --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "Verifying LendingPoolDeployer..."
forge verify-contract 0x3F912D945AFE21280F8Bb264f7661C0995F26813 src/LendingPoolDeployer.sol:LendingPoolDeployer --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "Verifying LendingPoolFactory..."
forge verify-contract 0x92b3f4D2312a108998a8E0fF91B90e6aB7AC97bE src/LendingPoolFactory.sol:LendingPoolFactory --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "Verifying LendingPool..."
forge verify-contract 0xb268f61c7dF38E14574fdC8b042f9Ad25ea0839A src/LendingPool.sol:LendingPool --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "Verifying Position..."
forge verify-contract 0x1902BeEC99317B5d1D6E9d3bD9498B8d539365D2 src/Position.sol:Position --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

# Verify Helper contract
echo "Verifying HelperTestnet..."
forge verify-contract 0x1cC78286933D8E81aA8e5Cc39c9FCD87FDCA246f src/HelperTestnet.sol:HelperTestnet --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

# Verify Mock tokens
echo "Verifying MockUSDC..."
forge verify-contract 0xcD108eEE9a62baEeA4a03e4CE5D2dD15b47b2857 src/mocks/MockUSDC.sol:MockUSDC --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "Verifying MockUSDT..."
forge verify-contract 0xBd788D49ffD8707dC713897614D96755FF72b313 src/mocks/MockUSDT.sol:MockUSDT --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "Verifying MockWCORE..."
forge verify-contract 0x14A9bEe4e32f4862e648a4cb208E57FF299662a5 src/mocks/MockWCORE.sol:MockWCORE --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "Verifying MockWBTC..."
forge verify-contract 0x3217D2b65Df07C7FD5BBa61144ad4B7ec623E311 src/mocks/MockWBTC.sol:MockWBTC --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "Verifying MockWETH..."
forge verify-contract 0x21077433B716F12e6aC2218184DC8fBbAd5E47fc src/mocks/MockWETH.sol:MockWETH --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

# forge verify-contract 0x7829DbB93c2adfa103b7eC9EB06919017aDA77Da src/Pricefeed.sol:Pricefeed --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

# forge verify-contract 0x1f823ebbDf56DF330452D2Eb2DfA3DCf117BF33D src/Oracle.sol:Oracle --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

# forge verify-contract 0x8BDa1a549676B056A84b37F17739614b2F41Dd02 src/HelperUtils.sol:HelperUtils --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5

echo "✅ Contract verification completed!"
echo "Check your contracts on Core Scan: https://scan.test2.btcs.network/"

1000000000000000000
