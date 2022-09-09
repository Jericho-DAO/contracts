import hre from "hardhat";
import pg from 'pg'
// const CONTRACT_ADDRESS = "0x80d01a8f7F20383834c98ab42233623dDAd42FE4"
const CONTRACT_ADDRESS = "0xb19560eEC13Cf28dfCB6f06583034E5dF33C5cdb"

async function mintNFT(contractAddress, to, frenWallet) {
   const Jericho = await hre.ethers.getContractFactory("JerichoArtifacts")
   const [owner] = await ethers.getSigners()
   const contract = await Jericho.attach(contractAddress)
//    await contract.mintArtifact(1, to, frenWallet)
    // const { data } = await contract.populateTransaction.mintArtifact(
    //                 1,
    //                 to,
    //                 frenWallet
    //             )
    //     let txParams = {
    //         data: data,
    //         to: CONTRACT_ADDRESS,
    //         from: to,
    //     };
    //     let gas = await contract.provider.estimateGas(txParams)
    //     console.log(gas)
    //    await contract.setJerichoMember(frenWallet)
    // await contract.mintArtifact(1, frenWallet, to)
//    await contract.setFirstBeliever(frenWallet)
//    await contract.setFirstBeliever(to)
//    await contract.setJerichoMember(frenWallet)
    await contract.setJerichoMember("0xAc54D08b4F206Fdba003F740BFE431c0E9dF08bA")
   // await contract.mintArtifact(3, frenWallet, to)
//    await contract.mintArtifact(2, to, frenWallet)
   // await contract.mintArtifact(2, frenWallet, to)
   // await contract.mintArtifact(0, to, frenWallet)
//    const isBeliever = await contract.balanceOf(to, 1)
//    const isMember = await contract.balanceOf(to, 2)
//    const anvil = await contract.balanceOf(to, 3)
//    console.log(isBeliever)
//    console.log(isMember)
//    console.log(anvil)
//    await contract.mintArtifact(3, to, frenWallet)
   // await contract.mintArtifact(3, frenWallet, to)
   // await contract.setCustomAttributes(1, "Gate Pass", "test", "https://blog.cdn.own3d.tv/resize=fit:crop,height:400,width:600/vonCtE84TGOfWPcco0Zg")
//    await contract.forcedBurn(to, 1, 1)
//    await contract.forcedBurn(to, 2, 1)
//    await contract.forcedBurn(to, 3, 1)

//    await contract.forcedBurn(frenWallet, 1, 1)
//    await contract.forcedBurn(frenWallet, 2, 1)
//    await contract.forcedBurn(frenWallet, 3, 1)
//    await contract.setCustomAttributes(2, 
//       "Rain Hammer",
//       "The Rain Hammer is an artifact built from Bifrost's fragments. It's granted by The Guardians of Jericho to high-potential builders. It's a prerequisite to getting Jericho citizenship.",
//       "https://ipfs.io/ipfs/bafybeihlhjdvn6stihbuyeanckich66rq4hahvocilvhlhouhch43z75f4"
//    )
   // const t = await contract.getAttributes(1)
   // console.log(contract)
   // console.log("NFT minted to: ", owner)
   console.log("NFT minted to: ", to)
}

let pgPool;

const setupPgPool = async () => {
    const pgConfig = {
        max: 1,
        host: "jericho.cildbrsbmzz7.eu-west-1.rds.amazonaws.com",
        user: "postgres",
        password: "8MZ7xKsFBBwlxnqyBoPX",
        database: "main",
    };
    pgPool = new pg.Pool(pgConfig);
}

// const main = async () => {
//    await setupPgPool()
//    if (pgPool) {
//       const result = await pgPool.query(`SELECT * FROM USERS;`);
//       console.log(result.rows);

//       result.rows.forEach(r => {
//          if (r.xp === 8) {
//             // builder mint everything
//          } else if (r.xp === 6) {
//             // mint gate pass + hammer
//          }
//       })
//    }
// }
0xcb43C75051F93F95DEfF5F9A971b8D5109a4f25C

mintNFT(CONTRACT_ADDRESS, "0xDDd22b816019a4E5Da5E048D5f07C4bCaa2Dd471", "0xab559967F7CD22afb1d897d6170233b41bfc8180")
   .then(() => process.exit(0))
   .catch((error) => {
       console.error(error);
       process.exit(1);
   });

// main()