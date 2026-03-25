import type { Metadata } from "next";
import GuidePage, { generateMetadata as generateLocalizedMetadata } from "../[locale]/guide/page";

export function generateMetadata(): Promise<Metadata> {
  return generateLocalizedMetadata({ params: Promise.resolve({ locale: "en" }) });
}

export default function EnglishGuidePage() {
  return GuidePage({ params: Promise.resolve({ locale: "en" }) });
}
