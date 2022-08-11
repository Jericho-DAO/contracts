// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const contractFactory = await hre.ethers.getContractFactory("JerichoArtifacts");
  const contract = await contractFactory.deploy("Jericho Artifacts", "JCH");
  await contract.deployed();
  console.log("Contract is deployed on:", contract.address);

  let txn;
  txn = await contract.mintGatePass();
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await contract.mintAnvil();
  await txn.wait();
  console.log("Minted NFT #2");

  txn = await contract.mintNecklaceOfFrenship();
  await txn.wait();
  console.log("Minted NFT #3");

  txn = await contract.mintHammer();
  await txn.wait();
  console.log("Minted NFT #4");


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
