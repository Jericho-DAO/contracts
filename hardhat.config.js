require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

const { API_URL, PRIVATE_KEY, PROD_API_URL, POLYGON_SCAN_API_KEY } = process.env;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.9",
  networks: {
    mumbai: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    polygon: {
      url: PROD_API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    }
  },
    etherscan: {
    apiKey: POLYGON_SCAN_API_KEY
  },
};