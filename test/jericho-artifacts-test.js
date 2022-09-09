const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Artifacts Test", function () {
  it("Should mint Gate Pass", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH", "0x4124dbd5f4612f15494e87d4351f1f7137f5283b");

    await artifacts.mintArtifact(1, accounts[0].address, "0x0000000000000000000000000000000000000000");
    const balance = await artifacts.balanceOf(accounts[0].address,1)
    expect(1).to.equal(Number(balance.toString()));
  });

  it("Should mint Hammer", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH", "0x4124dbd5f4612f15494e87d4351f1f7137f5283b");

    await artifacts.mintArtifact(1, accounts[0].address, "0x0000000000000000000000000000000000000000");
    await artifacts.mintArtifact(2, accounts[0].address, "0x0000000000000000000000000000000000000000");
    const balance = await artifacts.balanceOf(accounts[0].address,2)
    expect(1).to.equal(Number(balance.toString()));
  });

  it("Should mint Necklace of Frenship", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH", "0x4124dbd5f4612f15494e87d4351f1f7137f5283b");
    const frenWallet = "0xcb43C75051F93F95DEfF5F9A971b8D5109a4f25C";

    await artifacts.mintArtifact(1, accounts[0].address, frenWallet);
    await artifacts.mintArtifact(2, accounts[0].address, frenWallet);
    
    await artifacts.mintArtifact(1, frenWallet, accounts[0].address);
    await artifacts.mintArtifact(2, frenWallet, accounts[0].address);

    await artifacts.mintArtifact(0, accounts[0].address, frenWallet);

    const balance = await artifacts.balanceOf(accounts[0].address,50000);
    const balanceFren = await artifacts.balanceOf(frenWallet,50000);
    expect(1).to.equal(Number(balance.toString()));
    expect(1).to.equal(Number(balanceFren.toString()));
  });

  it("Should mint Anvil", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH", "0x4124dbd5f4612f15494e87d4351f1f7137f5283b");
    const frenWallet = "0xcb43C75051F93F95DEfF5F9A971b8D5109a4f25C";

    await artifacts.mintArtifact(1, accounts[0].address, frenWallet);
    await artifacts.mintArtifact(2, accounts[0].address, frenWallet);

    await artifacts.mintArtifact(1, frenWallet, accounts[0].address);
    await artifacts.mintArtifact(2, frenWallet, accounts[0].address);

    await artifacts.setJerichoMember(accounts[0].address);

    await artifacts.mintArtifact(0, accounts[0].address, frenWallet);
    await artifacts.mintArtifact(3, accounts[0].address, frenWallet);

    const balance = await artifacts.balanceOf(accounts[0].address,3);
 
    expect(1).to.equal(Number(balance.toString()));
  });

    it("Should mint Anvil for first Believer", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH", "0x4124dbd5f4612f15494e87d4351f1f7137f5283b");
    const frenWallet = "0xcb43C75051F93F95DEfF5F9A971b8D5109a4f25C";

    await artifacts.mintArtifact(1, accounts[0].address, frenWallet);
    await artifacts.mintArtifact(2, accounts[0].address, frenWallet);

    await artifacts.mintArtifact(1, frenWallet, accounts[0].address);
    await artifacts.mintArtifact(2, frenWallet, accounts[0].address);

    await artifacts.setFirstBeliever(accounts[0].address);
    await artifacts.setJerichoMember(accounts[0].address);

    await artifacts.mintArtifact(3, accounts[0].address, frenWallet);
    const balance = await artifacts.balanceOf(accounts[0].address,3);
 
    expect(1).to.equal(Number(balance.toString()));
  });
});
