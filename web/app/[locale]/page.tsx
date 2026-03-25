import MarketingHome from "../marketing-home";

export default async function Home({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;

  return <MarketingHome locale={locale} />;
}
