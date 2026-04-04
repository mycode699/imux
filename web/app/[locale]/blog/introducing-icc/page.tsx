import { redirect } from "next/navigation";

export default async function IntroducingIccRedirect({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  redirect(locale === "en" ? "/blog/introducing-imux" : `/${locale}/blog/introducing-imux`);
}
