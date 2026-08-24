import "./globals.css";
import { Roboto } from "next/font/google";
import { ShieldMark } from "./_components/shield";

// Roboto = Android's default font, so the website matches the app 1:1.
const roboto = Roboto({
  subsets: ["latin"],
  weight: ["400", "500", "700", "900"],
  display: "swap",
  variable: "--font-roboto",
});

export const metadata = {
  title: "JOHAR — Safety Compliance",
  description:
    "AR safety training & blockchain-verified certification for Jharkhand's mining, steel and mica workers.",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en" className={roboto.variable}>
      <body>
        <header className="site-header">
          <a href="/" className="brand">
            <span className="brand-mark">
              <ShieldMark size={20} />
            </span>
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
