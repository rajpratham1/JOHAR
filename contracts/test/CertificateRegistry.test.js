const { expect } = require("chai");
const { ethers } = require("hardhat");

const id = (s) => ethers.keccak256(ethers.toUtf8Bytes(s));

describe("CertificateRegistry", function () {
  let registry, owner, issuer, stranger;

  beforeEach(async function () {
    [owner, issuer, stranger] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory("CertificateRegistry");
    registry = await Factory.deploy();
    await registry.waitForDeployment();
  });

  it("marks the deployer as owner and an issuer", async function () {
    expect(await registry.owner()).to.equal(owner.address);
    expect(await registry.issuers(owner.address)).to.equal(true);
  });

  it("issues and verifies a certificate", async function () {
    const certId = id("JOHAR-0001");
    const dataHash = id('{"certId":"JOHAR-0001","score":92}');

    await expect(registry.issueCertificate(certId, dataHash))
      .to.emit(registry, "CertificateIssued");

    const [valid, revoked, issuedAt, issuerAddr] = await registry.verify(certId, dataHash);
    expect(valid).to.equal(true);
    expect(revoked).to.equal(false);
    expect(issuedAt).to.be.gt(0);
    expect(issuerAddr).to.equal(owner.address);
  });

  it("fails verification when the hash is tampered", async function () {
    const certId = id("JOHAR-0002");
    await registry.issueCertificate(certId, id("original"));
    const [valid] = await registry.verify(certId, id("tampered"));
    expect(valid).to.equal(false);
  });

  it("blocks non-issuers from issuing", async function () {
    await expect(
      registry.connect(stranger).issueCertificate(id("X"), id("Y"))
    ).to.be.revertedWith("JOHAR: not authorized issuer");
  });

  it("lets the owner authorise a new issuer", async function () {
    await registry.setIssuer(issuer.address, true);
    await expect(registry.connect(issuer).issueCertificate(id("JOHAR-0003"), id("h")))
      .to.emit(registry, "CertificateIssued");
  });

  it("revokes a certificate and reflects it in verify", async function () {
    const certId = id("JOHAR-0004");
    const h = id("h4");
    await registry.issueCertificate(certId, h);
    await registry.revokeCertificate(certId);
    const [valid, revoked] = await registry.verify(certId, h);
    expect(valid).to.equal(false);
    expect(revoked).to.equal(true);
  });

  it("prevents duplicate issuance", async function () {
    const certId = id("JOHAR-0005");
    await registry.issueCertificate(certId, id("h5"));
    await expect(registry.issueCertificate(certId, id("h5")))
      .to.be.revertedWith("JOHAR: cert already exists");
  });
});
