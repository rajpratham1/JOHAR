import "./globals.css";

export const metadata = {
  title: "JOHAR — Safety Compliance",
  description:
    "AR safety training & blockchain-verified certification for Jharkhand's mining, steel and mica workers.",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <header className="site-header">
          <a href="/" className="brand">
            JOHAR
          </a>
          <nav className="nav">
            <a href="/dashboard">Dashboard</a>
            <a href="https://github.com/your-org/johar" target="_blank" rel="noreferrer">
              GitHub
            </a>
          </nav>
        </header>
        <main className="container">{children}</main>
        <footer className="site-footer">
          JOHAR · Jharkhand Occupational Hazard Awareness &amp; Response · SIH 2026 · PS 26041
        </footer>
      </body>
    </html>
  );
}
