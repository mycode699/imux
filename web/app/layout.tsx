import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { Providers } from "./[locale]/providers";
import { siteConfig } from "./site-config";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: `${siteConfig.name} — ${siteConfig.descriptor}`,
  description: siteConfig.description,
  metadataBase: new URL(siteConfig.canonicalUrl),
  openGraph: {
    title: `${siteConfig.name} — ${siteConfig.descriptor}`,
    description: siteConfig.description,
    url: siteConfig.canonicalUrl,
    siteName: siteConfig.name,
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: `${siteConfig.name} — ${siteConfig.descriptor}`,
    description: siteConfig.description,
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <meta name="theme-color" content="#f6f2e9" />
        <script
          dangerouslySetInnerHTML={{
            __html: `(function(){try{var t=localStorage.getItem("theme");var light=t==="light"||(t==="system"&&window.matchMedia("(prefers-color-scheme:light)").matches);if(!light)document.documentElement.classList.add("dark");var m=document.querySelector('meta[name="theme-color"]');if(m)m.content=light?"#f6f2e9":"#09111c"}catch(e){}})()`,
          }}
        />
      </head>
      <body
        className={`${geistSans.variable} ${geistMono.variable} font-sans antialiased`}
      >
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
