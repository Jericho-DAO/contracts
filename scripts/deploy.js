const hre = require("hardhat");

async function main() {
  const forwarder = "0x9399BB24DBB5C4b782C70c2969F58716Ebbd6a3b";
  const contractFactory = await hre.ethers.getContractFactory("JerichoArtifacts");
  const contract = await contractFactory.deploy("Jericho Artifacts", "JCH", forwarder);
  await contract.deployed();
  console.log("Contract is deployed on:", contract.address);

  // let txn;
  txn = await contract.mintArtifact(1, "0xcb43C75051F93F95DEfF5F9A971b8D5109a4f25C");
  await txn.wait();
  // console.log("Minted NFT #1");

  txn = await contract.mintArtifact(2, "0xcb43C75051F93F95DEfF5F9A971b8D5109a4f25C");
  await txn.wait();
  // console.log("Minted NFT #2");

  txn = await contract.mintArtifact(3, "0xcb43C75051F93F95DEfF5F9A971b8D5109a4f25C");
  await txn.wait();
  // console.log("Minted NFT #3");

  // txn = await contract.mintHammer();
  // await txn.wait();
  // console.log("Minted NFT #4");


}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
