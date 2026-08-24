import { db } from "@/lib/firebaseAdmin";
import { getReadContract } from "@/lib/chain";
import { certIdKey, dataHashOf } from "@/lib/certHash";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

const LABELS = {
  valid: "✓ Authentic certificate",
  tampered: "✗ Does not match the blockchain record",
  revoked: "⚠ This certificate has been revoked",
  not_found: "✗ No certificate found with this ID",
  error: "Could not verify right now",
};

export default async function VerifyPage({ params }) {
  const { certId } = await params;

  let cert = null;
  let onchain = null;
  let status = "not_found";

  try {
    const snap = await db().collection("certificates").doc(certId).get();
    if (snap.exists) {
      cert = snap.data();
      const recomputed = dataHashOf({ ...cert, certId });
      const contract = getReadContract();
      const [valid, revoked, issuedAt, issuer] = await contract.verify(
        certIdKey(certId),
        recomputed
      );
      onchain = { valid, revoked, issuedAt: Number(issuedAt), issuer, recomputed };
      status = revoked ? "revoked" : valid ? "valid" : "tampered";
    }
  } catch (e) {
    status = "error";
  }

  return (
    <section className="verify-wrap">
      <h1>Certificate verification</h1>
      <div className={`verify-status`}>
        <span className={`badge ${status}`}>{LABELS[status]}</span>
      </div>

      {cert && (
        <div className="kv">
          <div><span className="k">Certificate ID</span><span className="mono">{certId}</span></div>
          <div><span className="k">Worker</span><span>{cert.workerName || cert.workerId}</span></div>
          <div><span className="k">Modules</span><span>{(cert.modules || []).join(", ") || "—"}</span></div>
          <div><span className="k">Score</span><span>{cert.score ?? "—"}</span></div>
          <div><span className="k">Issued</span><span>{cert.issuedAt || "—"}</span></div>
          <div><span className="k">Expires</span><span>{cert.expiresAt || "—"}</span></div>
          {onchain && (
            <>
              <div><span className="k">On-chain issuer</span><span className="mono">{onchain.issuer}</span></div>
              <div><span className="k">Tx hash</span><span className="mono">{cert.txHash || "—"}</span></div>
            </>
          )}
        </div>
      )}

      {status === "valid" && (
        <div className="notice" style={{ background: "#e6f4ea", borderColor: "#bfe3c9", color: "#08512c" }}>
          The certificate data matches the hash anchored on Polygon. It is authentic and unmodified.
        </div>
      )}
      {status === "tampered" && (
        <div className="notice" style={{ background: "#fdecea", borderColor: "#f5c6c0", color: "#7a1c12" }}>
          The stored certificate data does not match the blockchain hash — it may have been altered.
        </div>
      )}
      {status === "error" && (
        <div className="notice">
          Verification service isn&apos;t fully configured yet (Firebase + contract address). See{" "}
          <span className="mono">docs/firebase-setup.md</span>.
        </div>
      )}
    </section>
  );
}
