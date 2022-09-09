const hre = require("hardhat");

async function main() {
  const forwarderMumbai = "0x9399BB24DBB5C4b782C70c2969F58716Ebbd6a3b";
  const forwarderMatic = "0x86C80a8aa58e0A4fa09A69624c31Ab2a6CAD56b8";
  console.log('Getting Contract Factory...')
  const contractFactory = await hre.ethers.getContractFactory("JerichoArtifacts");
  console.log('Deploying SC...')
  const contract = await contractFactory.deploy("Jericho Artifacts", "JCH", forwarderMatic);
  await contract.deployed();
  console.log("Contract is deployed on:", contract.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
