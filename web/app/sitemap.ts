import type { MetadataRoute } from "next";
import { locales } from "../i18n/routing";
import { siteConfig } from "./site-config";

export default function sitemap(): MetadataRoute.Sitemap {
  const base = siteConfig.canonicalUrl;

  const entries: MetadataRoute.Sitemap = [];

  const alternates: Record<string, string> = {};
  for (const locale of locales) {
    alternates[locale] = locale === "en" ? base : `${base}/${locale}`;
  }
  alternates["x-default"] = base;

  entries.push({
    url: base,
    lastModified: "2026-03-25",
    changeFrequency: "weekly",
    priority: 1,
    alternates: { languages: alternates },
  });

  return entries;
}
