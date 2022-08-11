const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Artifacts Test", function () {
  it("Should mint Gate Pass", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH");

    await artifacts.mintGatePass();
    const balance = await artifacts.balanceOf(accounts[0].address,1)
    expect(1).to.equal(Number(balance.toString()));
  });

  it("Should mint Anvil", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH");

    await artifacts.mintGatePass();
    await artifacts.mintAnvil();
    const balance = await artifacts.balanceOf(accounts[0].address,2)
    expect(1).to.equal(Number(balance.toString()));
  });

  it("Should mint Necklace of Frenship", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH");

    await artifacts.mintGatePass();
    await artifacts.mintAnvil();
    await artifacts.mintNecklaceOfFrenship();
    const balance = await artifacts.balanceOf(accounts[0].address,3)
    expect(1).to.equal(Number(balance.toString()));
  });

  it("Should mint Hammer", async function () {
    const accounts = await ethers.getSigners();

    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH");

    await artifacts.mintGatePass();
    await artifacts.mintAnvil();
    await artifacts.mintNecklaceOfFrenship();
    await artifacts.mintHammer();
    const balance = await artifacts.balanceOf(accounts[0].address,4)
    expect(1).to.equal(Number(balance.toString()));
  });

  it("Check that has functions work", async function () {
    const Artifacts = await ethers.getContractFactory("JerichoArtifacts");
    const artifacts = await Artifacts.deploy("Jericho Artifacts", "JCH");

    await artifacts.mintGatePass();
    const hasGatePass = await artifacts.hasGatePass()
    
    await artifacts.mintAnvil();
    const hasAnvil = await artifacts.hasAnvil()
    
    await artifacts.mintNecklaceOfFrenship();
    const hasNecklaceOfFrenship = await artifacts.hasNecklaceOfFrenship()
    
    await artifacts.mintHammer();
    const hasHammer = await artifacts.hasHammer()
    expect(true).to.equal(hasGatePass);
    expect(true).to.equal(hasAnvil);
    expect(true).to.equal(hasNecklaceOfFrenship);
    expect(true).to.equal(hasHammer);
  });
});
