export default function Home() {
  const apkUrl = process.env.NEXT_PUBLIC_APK_URL || "#";
  return (
    <section>
      <div className="hero">
        <h1>Every worker, safe.</h1>
        <p>
          JOHAR is an AR-based vocational safety trainer for Jharkhand&apos;s mining, steel and
          mica workers. Learn life-saving drills in Hindi &amp; Santali with voice guidance — fully
          offline, no headset — and earn a certificate whose authenticity is anchored on a public
          blockchain.
        </p>
        <a className="btn" href={apkUrl}>Download the Android app (APK)</a>
      </div>

      <div className="grid">
        <div className="card">
          <h3>AR training, any phone</h3>
          <p>Markerless AR on mid-range Android 10+. A non-AR 3D fallback keeps it usable on every device.</p>
        </div>
        <div className="card">
          <h3>Hindi &amp; Santali + voice</h3>
          <p>Icon-first, audio-narrated UI built for low-literacy recruits.</p>
        </div>
        <div className="card">
          <h3>Blockchain-verified certs</h3>
          <p>Scan a QR to confirm a certificate on-chain. Tamper-evident by design.</p>
        </div>
        <div className="card">
          <h3>Compliance dashboard</h3>
          <p>Employers &amp; DGMS track completion, expiry and site-wise risk. <a href="/dashboard">Open →</a></p>
        </div>
      </div>
    </section>
  );
}
