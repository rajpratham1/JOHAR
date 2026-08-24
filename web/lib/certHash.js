import { ethers } from "ethers";

/**
 * Canonical certificate serialization.
 * MUST stay byte-for-byte identical to the Dart implementation in
 * app/lib/features/certificate/certificate_service.dart, or hashes won't match.
 *
 * Format: certId|workerId|workerName|modules(comma-joined)|score|issuedAt|expiresAt|issuer
 */
export function canonicalString(cert) {
  const modules = Array.isArray(cert.modules)
    ? cert.modules.join(",")
    : String(cert.modules ?? "");
  return [
    cert.certId,
    cert.workerId,
    cert.workerName,
    modules,
    String(cert.score),
    cert.issuedAt,
    cert.expiresAt,
    cert.issuer,
  ].join("|");
}

// bytes32 key used in the on-chain mapping.
export function certIdKey(certId) {
  return ethers.keccak256(ethers.toUtf8Bytes(certId));
}

// bytes32 hash of the canonical certificate data.
export function dataHashOf(cert) {
  return ethers.keccak256(ethers.toUtf8Bytes(canonicalString(cert)));
}
