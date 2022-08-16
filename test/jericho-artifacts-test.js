const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Artifacts Test", function () {
  it("Should mint Gate Pass", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH", "0x4124dbd5f4612f15494e87d4351f1f7137f5283b");

    // await artifacts.mintArtifact(1, "0x0000000000000000000000000000000000000000");
    const balance = await artifacts.balanceOf(accounts[0].address,1)
    expect(1).to.equal(Number(balance.toString()));
  });

  it("Should mint Hammer", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH", "0x4124dbd5f4612f15494e87d4351f1f7137f5283b");

    // await artifacts.mintArtifact(1, "0x0000000000000000000000000000000000000000");
    // await artifacts.mintArtifact(2, "0x0000000000000000000000000000000000000000");
    const balance = await artifacts.balanceOf(accounts[0].address,2)
    expect(1).to.equal(Number(balance.toString()));
  });

  it("Should mint Necklace of Frenship", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH", "0x4124dbd5f4612f15494e87d4351f1f7137f5283b");
    const frenWallet = "0xab559967f7cd22afb1d897d6170233b41bfc8180";

    // await artifacts.mintArtifact(1, "0x0000000000000000000000000000000000000000");
    // await artifacts.mintArtifact(2, "0x0000000000000000000000000000000000000000");
    // await artifacts.mintArtifact(3, frenWallet);
    const balance = await artifacts.balanceOf(accounts[0].address,3)
    const balanceFren = await artifacts.balanceOf(frenWallet,3)
    expect(1).to.equal(Number(balance.toString()));
    expect(1).to.equal(Number(balanceFren.toString()));
  });

  it("Should mint Anvil", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH", "0x4124dbd5f4612f15494e87d4351f1f7137f5283b");
    const frenWallet = "0xab559967f7cd22afb1d897d6170233b41bfc8180";

    // await artifacts.mintArtifact(1, "0x0000000000000000000000000000000000000000");
    // await artifacts.mintArtifact(2, "0x0000000000000000000000000000000000000000");
    // await artifacts.mintArtifact(3, frenWallet);
    // await artifacts.mintArtifact(4, "0x0000000000000000000000000000000000000000");
    const balance = await artifacts.balanceOf(accounts[0].address,4)
    expect(1).to.equal(Number(balance.toString()));
  });
});
