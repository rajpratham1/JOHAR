import { ethers } from "ethers";

// Minimal ABI — just the functions the web app calls.
export const CERT_ABI = [
  "function issueCertificate(bytes32 certId, bytes32 dataHash) external",
  "function revokeCertificate(bytes32 certId) external",
  "function verify(bytes32 certId, bytes32 dataHash) view returns (bool valid, bool revoked, uint256 issuedAt, address issuer)",
  "function getCertificate(bytes32 certId) view returns (bytes32 dataHash, uint256 issuedAt, address issuer, bool revoked, bool exists)",
];

const RPC_URL = process.env.AMOY_RPC_URL || "https://rpc-amoy.polygon.technology";

export function getProvider() {
  return new ethers.JsonRpcProvider(RPC_URL);
}

export function getReadContract() {
  const address = process.env.CERT_CONTRACT_ADDRESS;
  if (!address) throw new Error("CERT_CONTRACT_ADDRESS not set");
  return new ethers.Contract(address, CERT_ABI, getProvider());
}

export function getWriteContract() {
  const address = process.env.CERT_CONTRACT_ADDRESS;
  const key = process.env.SIGNER_PRIVATE_KEY;
  if (!address) throw new Error("CERT_CONTRACT_ADDRESS not set");
  if (!key) throw new Error("SIGNER_PRIVATE_KEY not set");
  const wallet = new ethers.Wallet(key, getProvider());
  return new ethers.Contract(address, CERT_ABI, wallet);
}
