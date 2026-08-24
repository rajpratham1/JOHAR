import { db } from "@/lib/firebaseAdmin";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

const DAY = 24 * 60 * 60 * 1000;

export default async function Dashboard() {
  let stats = null;
  let recent = [];
  let error = null;

  try {
    const fs = db();
    const now = Date.now();
    let total = 0, valid = 0, expiringSoon = 0, revoked = 0;
    const byModule = {};

    const certs = await fs.collection("certificates").get();
    certs.forEach((doc) => {
      const c = doc.data();
      total++;
      if (c.revoked) revoked++;
      const exp = c.expiresAt ? new Date(c.expiresAt).getTime() : null;
      const isValid = !c.revoked && (!exp || exp > now);
      if (isValid) valid++;
      if (exp && exp > now && exp < now + 30 * DAY) expiringSoon++;
      (c.modules || []).forEach((m) => { byModule[m] = (byModule[m] || 0) + 1; });
    });

    const recentSnap = await fs
      .collection("certificates")
      .orderBy("issuedAt", "desc")
      .limit(10)
      .get();
    recent = recentSnap.docs.map((d) => ({ id: d.id, ...d.data() }));

    stats = { total, valid, expiringSoon, revoked, byModule };
  } catch (e) {
    error = e.message;
  }

  if (error) {
    return (
      <section>
        <h1>Compliance dashboard</h1>
        <div className="notice">
          Firebase isn&apos;t connected yet, so live data can&apos;t load. Add your service-account
          credentials to <span className="mono">web/.env.local</span> (see{" "}
          <span className="mono">docs/firebase-setup.md</span>). Details: {error}
        </div>
      </section>
    );
  }

  return (
    <section>
      <h1>Compliance dashboard</h1>
      <p style={{ color: "var(--muted)" }}>What an employer / DGMS officer sees.</p>

      <div className="grid">
        <div className="card"><h3>Certificates issued</h3><div className="stat">{stats.total}</div></div>
        <div className="card"><h3>Currently valid</h3><div className="stat ok">{stats.valid}</div></div>
        <div className="card"><h3>Expiring in 30 days</h3><div className="stat warn">{stats.expiringSoon}</div></div>
        <div className="card"><h3>Revoked</h3><div className="stat bad">{stats.revoked}</div></div>
      </div>

      <h2 style={{ marginTop: 32 }}>Certifications by module</h2>
      <table>
        <thead><tr><th>Module</th><th>Certified workers</th></tr></thead>
        <tbody>
          {Object.keys(stats.byModule).length === 0 ? (
            <tr><td colSpan={2}>No data yet.</td></tr>
          ) : (
            Object.entries(stats.byModule).map(([m, n]) => (
              <tr key={m}><td>{m}</td><td>{n}</td></tr>
            ))
          )}
        </tbody>
      </table>

      <h2 style={{ marginTop: 32 }}>Recent certificates</h2>
      <table>
        <thead>
          <tr><th>Cert ID</th><th>Worker</th><th>Score</th><th>Issued</th><th>Verify</th></tr>
        </thead>
        <tbody>
          {recent.length === 0 ? (
            <tr><td colSpan={5}>No certificates issued yet.</td></tr>
          ) : (
            recent.map((c) => (
              <tr key={c.id}>
                <td className="mono">{c.id}</td>
                <td>{c.workerName || c.workerId}</td>
                <td>{c.score ?? "—"}</td>
                <td>{c.issuedAt ? new Date(c.issuedAt).toLocaleDateString() : "—"}</td>
                <td><a href={`/verify/${c.id}`}>Verify →</a></td>
              </tr>
            ))
          )}
        </tbody>
      </table>
    </section>
  );
}
