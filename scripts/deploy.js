const hre = require("hardhat");

async function main() {
  const forwarder = "0x9399BB24DBB5C4b782C70c2969F58716Ebbd6a3b";
  const contractFactory = await hre.ethers.getContractFactory("JerichoArtifacts");
  const contract = await contractFactory.deploy("Jericho Artifacts", "JCH", forwarder);
  await contract.deployed();
  console.log("Contract is deployed on:", contract.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
