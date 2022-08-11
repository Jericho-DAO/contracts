const hre = require("hardhat");

async function main() {
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

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
