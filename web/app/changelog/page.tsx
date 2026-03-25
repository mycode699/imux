import type { Metadata } from "next";
import ChangelogPage, { generateMetadata as generateLocalizedMetadata } from "../[locale]/changelog/page";

export function generateMetadata(): Promise<Metadata> {
  return generateLocalizedMetadata({ params: Promise.resolve({ locale: "en" }) });
}

export default function EnglishChangelogPage() {
  return ChangelogPage({ params: Promise.resolve({ locale: "en" }) });
}
