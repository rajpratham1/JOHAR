// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title CertificateRegistry
 * @notice Tamper-evident registry of JOHAR safety-training certificates.
 *
 * We store only a keccak256 hash of the canonical certificate data on-chain
 * (no personal data). Anyone can later recompute the hash from a certificate
 * and check it against the chain to prove the certificate is authentic and
 * unmodified. Issuance is restricted to authorised issuer addresses (the
 * server-side signer); the signing key never lives in the mobile app.
 */
contract CertificateRegistry {
    struct Certificate {
        bytes32 dataHash;  // keccak256 of the canonical certificate JSON
        uint256 issuedAt;  // block timestamp of issuance
        address issuer;    // which authorised address issued it
        bool revoked;      // certificates can be revoked (e.g. fraud, expiry override)
        bool exists;       // distinguishes "not found" from zeroed struct
    }

    address public owner;
    mapping(address => bool) public issuers;
    mapping(bytes32 => Certificate) private certificates; // key = keccak256(certId string)

    event CertificateIssued(bytes32 indexed certId, bytes32 dataHash, address indexed issuer, uint256 issuedAt);
    event CertificateRevoked(bytes32 indexed certId, address indexed issuer, uint256 revokedAt);
    event IssuerUpdated(address indexed issuer, bool authorized);
    event OwnerTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "JOHAR: not owner");
        _;
    }

    modifier onlyIssuer() {
        require(issuers[msg.sender], "JOHAR: not authorized issuer");
        _;
    }

    constructor() {
        owner = msg.sender;
        issuers[msg.sender] = true;
        emit OwnerTransferred(address(0), msg.sender);
        emit IssuerUpdated(msg.sender, true);
    }

    /// @notice Authorise or de-authorise an issuer address.
    function setIssuer(address account, bool authorized) external onlyOwner {
        issuers[account] = authorized;
        emit IssuerUpdated(account, authorized);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "JOHAR: zero owner");
        emit OwnerTransferred(owner, newOwner);
        owner = newOwner;
    }

    /// @notice Anchor a certificate. `certId` is keccak256 of the human cert id string.
    function issueCertificate(bytes32 certId, bytes32 dataHash) external onlyIssuer {
        require(!certificates[certId].exists, "JOHAR: cert already exists");
        require(dataHash != bytes32(0), "JOHAR: empty hash");
        certificates[certId] = Certificate({
            dataHash: dataHash,
            issuedAt: block.timestamp,
            issuer: msg.sender,
            revoked: false,
            exists: true
        });
        emit CertificateIssued(certId, dataHash, msg.sender, block.timestamp);
    }

    /// @notice Batch anchor (gas-efficient when syncing many offline-issued certs).
    function issueBatch(bytes32[] calldata certIds, bytes32[] calldata dataHashes) external onlyIssuer {
        require(certIds.length == dataHashes.length, "JOHAR: length mismatch");
        for (uint256 i = 0; i < certIds.length; i++) {
            if (!certificates[certIds[i]].exists && dataHashes[i] != bytes32(0)) {
                certificates[certIds[i]] = Certificate({
                    dataHash: dataHashes[i],
                    issuedAt: block.timestamp,
                    issuer: msg.sender,
                    revoked: false,
                    exists: true
                });
                emit CertificateIssued(certIds[i], dataHashes[i], msg.sender, block.timestamp);
            }
        }
    }

    function revokeCertificate(bytes32 certId) external onlyIssuer {
        require(certificates[certId].exists, "JOHAR: no such cert");
        require(!certificates[certId].revoked, "JOHAR: already revoked");
        certificates[certId].revoked = true;
        emit CertificateRevoked(certId, msg.sender, block.timestamp);
    }

    /**
     * @notice Verify a certificate against a candidate hash.
     * @return valid    true iff the cert exists, is not revoked, and the hash matches
     * @return revoked  whether the cert has been revoked
     * @return issuedAt issuance timestamp (0 if not found)
     * @return issuer   issuing address (zero if not found)
     */
    function verify(bytes32 certId, bytes32 dataHash)
        external
        view
        returns (bool valid, bool revoked, uint256 issuedAt, address issuer)
    {
        Certificate memory c = certificates[certId];
        valid = c.exists && !c.revoked && c.dataHash == dataHash;
        return (valid, c.revoked, c.issuedAt, c.issuer);
    }

    function getCertificate(bytes32 certId)
        external
        view
        returns (bytes32 dataHash, uint256 issuedAt, address issuer, bool revoked, bool exists)
    {
        Certificate memory c = certificates[certId];
        return (c.dataHash, c.issuedAt, c.issuer, c.revoked, c.exists);
    }
}
