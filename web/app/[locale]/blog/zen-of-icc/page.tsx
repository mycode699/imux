import { redirect } from "next/navigation";

export default async function ZenOfIccRedirect({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  redirect(locale === "en" ? "/blog/zen-of-imux" : `/${locale}/blog/zen-of-imux`);
}
