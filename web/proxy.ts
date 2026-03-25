import { type NextRequest, NextResponse } from "next/server";
import createMiddleware from "next-intl/middleware";
import { routing } from "./i18n/routing";
import { siteConfig } from "./app/site-config";

const intlMiddleware = createMiddleware(routing);

export default function middleware(request: NextRequest) {
  const host = request.headers.get("host") ?? "";
  const url = new URL(request.url);

  if (host === "iccjk.com" || host === "clean.iccjk.com") {
    url.host = siteConfig.domain;
    url.protocol = "https:";
    return NextResponse.redirect(url.toString(), 301);
  }

  if (url.pathname === "/") {
    return NextResponse.next();
  }

  const pathParts = url.pathname.split("/").filter(Boolean);
  const maybeLocale = pathParts[0];
  const hasLocale = routing.locales.includes(maybeLocale as typeof routing.locales[number]);
  const normalizedParts = hasLocale ? pathParts.slice(1) : pathParts;
  const firstSegment = normalizedParts[0] ?? "";
  const legacySections = new Set([
    "blog",
    "docs",
    "community",
    "nightly",
    "wall-of-love",
    "privacy-policy",
    "terms-of-service",
    "eula",
  ]);

  if (legacySections.has(firstSegment)) {
    url.pathname = hasLocale ? `/${maybeLocale}` : "/";
    url.search = "";
    url.hash = "";
    return NextResponse.redirect(url.toString(), 308);
  }

  return intlMiddleware(request);
}

export const config = {
  matcher: ["/((?!api|_next|_vercel|.*\\..*).*)"],
};
