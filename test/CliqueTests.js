const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SoulBoundToken Contract", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployContract() {
    // Contracts are deployed using the first signer/account by default
    const [owner, account1, account2, account3, account4, account5, account6] =
      await ethers.getSigners();

    const SoulBoundToken = await ethers.getContractFactory("SoulBoundToken");
    const soulBoundToken = await SoulBoundToken.deploy();

    return {
      soulBoundToken,
      owner,
      account1,
      account2,
      account3,
      account4,
      account5,
      account6,
    };
  }

  describe("Deployment", function () {
    it("Should set the right owner of Contract", async function () {
      const { soulBoundToken, owner } = await loadFixture(deployContract);

      expect(await soulBoundToken.owner()).to.equal(owner.address);
    });
  });
  describe("setPlatformFeeInfo ", function () {
    it("Should set initially set the setPlatformFeeInfo of Contract to be zero", async function () {
      const { soulBoundToken, owner } = await loadFixture(deployContract);

      expect(await soulBoundToken.owner()).to.equal(owner.address);
    });
  });
});
