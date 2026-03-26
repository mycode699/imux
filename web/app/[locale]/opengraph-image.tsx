import { ImageResponse } from "next/og";
import { readFile } from "fs/promises";
import { join } from "path";
import { getMarketingCopy } from "../marketing-copy";
import { siteConfig } from "../site-config";

export const runtime = "nodejs";
export const size = { width: 1200, height: 630 };
export const contentType = "image/png";
export const alt = "icc — AI Command Center for macOS";

const S = 2; // render at 2x for sharper images on social platforms

export default async function Image({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  const copy = getMarketingCopy(locale);
  const logoData = await readFile(join(process.cwd(), "public", "logo.png"));

  const logoSrc = `data:image/png;base64,${logoData.toString("base64")}`;

  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          background:
            "radial-gradient(circle at top left, rgba(37,99,235,0.38), transparent 34%), radial-gradient(circle at top right, rgba(249,115,22,0.28), transparent 28%), linear-gradient(180deg, #08101d 0%, #0f172a 100%)",
          fontFamily: "sans-serif",
          padding: 48 * S,
        }}
      >
        <div
          style={{
            display: "flex",
            flex: 1,
            alignItems: "stretch",
            justifyContent: "space-between",
          }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: 16 * S,
              }}
            >
              <img
                src={logoSrc}
                width={80 * S}
                height={80 * S}
                style={{ borderRadius: 18 * S }}
              />
              <div style={{ display: "flex", flexDirection: "column" }}>
                <div
                  style={{
                    fontSize: 34 * S,
                    fontWeight: 600,
                    color: "#ededed",
                    letterSpacing: "-0.02em",
                    lineHeight: 1.1,
                  }}
                >
                  {siteConfig.name}
                </div>
                <div
                  style={{
                    fontSize: 16 * S,
                    fontWeight: 400,
                    color: "#94a3b8",
                    marginTop: 6 * S,
                    lineHeight: 1.2,
                  }}
                >
                  {copy.descriptor}
                </div>
              </div>
            </div>

            <div
              style={{
                display: "flex",
                alignItems: "center",
                border: "1px solid rgba(148,163,184,0.28)",
                borderRadius: 9999,
                padding: `${8 * S}px ${14 * S}px`,
                color: "#cbd5e1",
                fontSize: 12 * S,
                textTransform: "uppercase",
                letterSpacing: "0.18em",
              }}
            >
              {siteConfig.version}
            </div>
          </div>

          <div
            style={{
              display: "flex",
              flexDirection: "column",
              maxWidth: 860 * S,
              gap: 18 * S,
            }}
          >
            <div
              style={{
                fontSize: 58 * S,
                fontWeight: 600,
                color: "white",
                letterSpacing: "-0.05em",
                lineHeight: 0.95,
              }}
            >
              {copy.tagline}
            </div>
            <div
              style={{
                fontSize: 24 * S,
                lineHeight: 1.5,
                color: "#cbd5e1",
                maxWidth: 820 * S,
              }}
            >
              {copy.heroDescription}
            </div>
          </div>

          <div
            style={{
              display: "flex",
              gap: 16 * S,
            }}
          >
            {copy.capabilities.items.slice(0, 4).map((item) => (
              <div
                key={item.title}
                style={{
                  display: "flex",
                  borderRadius: 24 * S,
                  border: "1px solid rgba(148,163,184,0.24)",
                  background: "rgba(15,23,42,0.6)",
                  color: "#e2e8f0",
                  padding: `${16 * S}px ${18 * S}px`,
                  fontSize: 14 * S,
                }}
              >
                {item.title}
              </div>
            ))}
          </div>
        </div>
      </div>
    ),
    {
      width: size.width * S,
      height: size.height * S,
    }
  );
}
