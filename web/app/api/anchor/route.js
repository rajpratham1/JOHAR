import { NextResponse } from "next/server";
import { db } from "@/lib/firebaseAdmin";
import { getWriteContract } from "@/lib/chain";
import { certIdKey, dataHashOf } from "@/lib/certHash";

export const runtime = "nodejs";

const REQUIRED = ["certId", "workerId", "workerName", "modules", "score", "issuedAt", "expiresAt", "issuer"];

/**
 * POST /api/anchor
 * Body: the canonical certificate object (see REQUIRED fields).
 * Anchors keccak256(dataHash) on-chain and mirrors the record to Firestore.
 * The signer key lives ONLY in server env — never in the mobile app.
 */
export async function POST(req) {
  try {
    const cert = await req.json();
    for (const f of REQUIRED) {
      if (cert[f] === undefined || cert[f] === null) {
        return NextResponse.json({ error: `missing field: ${f}` }, { status: 400 });
      }
    }

    const key = certIdKey(cert.certId);
    const hash = dataHashOf(cert);

    const contract = getWriteContract();
    const tx = await contract.issueCertificate(key, hash);
    const receipt = await tx.wait();

    await db()
      .collection("certificates")
      .doc(cert.certId)
      .set(
        {
          ...cert,
          dataHash: hash,
          txHash: receipt.hash,
          revoked: false,
          anchoredAt: new Date().toISOString(),
        },
        { merge: true }
      );

    return NextResponse.json({ ok: true, txHash: receipt.hash, dataHash: hash });
  } catch (e) {
    console.error("anchor error:", e);
    return NextResponse.json({ error: e.message || "anchor failed" }, { status: 500 });
  }
}
