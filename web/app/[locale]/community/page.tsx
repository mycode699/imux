import { useTranslations } from "next-intl";
import { getTranslations } from "next-intl/server";
import { siteConfig } from "../../site-config";
import { SiteHeader } from "../components/site-header";

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "community" });
  return {
    title: t("metaTitle"),
    description: t("description"),
    alternates: { canonical: "./" },
  };
}

function CommunityLink({
  href,
  icon,
  name,
  action,
  description,
}: {
  href: string;
  icon: React.ReactNode;
  name: string;
  action: string;
  description: string;
}) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      className="group relative overflow-hidden rounded-[24px] border border-border/80 bg-background/88 p-5 shadow-[0_20px_60px_-40px_rgba(15,23,42,0.45)] transition duration-200 hover:-translate-y-0.5 hover:border-foreground/15 hover:shadow-[0_28px_70px_-40px_rgba(15,23,42,0.55)]"
    >
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(59,130,246,0.12),transparent_48%)] opacity-0 transition-opacity duration-200 group-hover:opacity-100" />
      <div className="relative flex items-start gap-4">
        <div className="mt-0.5 shrink-0 rounded-2xl border border-border/70 bg-code-bg/80 p-3 text-muted transition-colors group-hover:text-foreground">
          {icon}
        </div>
        <div className="min-w-0">
          <div className="font-medium text-[15px] text-foreground">{name}</div>
          <div className="mt-1 text-sm leading-6 text-muted">{description}</div>
          <div className="mt-3 text-xs font-medium uppercase tracking-[0.16em] text-muted transition-colors group-hover:text-foreground">
            {action} &rarr;
          </div>
        </div>
      </div>
    </a>
  );
}

export default function CommunityPage() {
  const t = useTranslations("community");
  const channels = [
    {
      href: "https://discord.gg/xsgFEVrWCZ",
      name: t("discord"),
      action: t("discordAction"),
      description: t("discordDesc"),
      icon: (
        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
          <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028c.462-.63.874-1.295 1.226-1.994a.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z" />
        </svg>
      ),
    },
    {
      href: siteConfig.repoUrl,
      name: "GitHub",
      action: t("githubAction"),
      description: t("githubDesc"),
      icon: (
        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
          <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
        </svg>
      ),
    },
    {
      href: "https://www.youtube.com/channel/UCAa89_j-TWkrXfk9A3CbASw",
      name: t("youtube"),
      action: t("youtubeAction"),
      description: t("youtubeDesc"),
      icon: (
        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
          <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
        </svg>
      ),
    },
  ];

  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_top_left,rgba(59,130,246,0.12),transparent_34%),radial-gradient(circle_at_bottom_right,rgba(34,197,94,0.12),transparent_32%)]">
      <SiteHeader section={t("title")} />
      <main className="mx-auto w-full max-w-6xl px-6 py-10">
        <section className="grid gap-6 lg:grid-cols-[minmax(0,1.05fr)_minmax(0,0.95fr)]">
          <div className="rounded-[32px] border border-border/80 bg-[linear-gradient(145deg,rgba(255,255,255,0.94),rgba(248,250,252,0.88))] p-8 shadow-[0_36px_120px_-70px_rgba(15,23,42,0.5)] dark:bg-[linear-gradient(145deg,rgba(15,23,42,0.92),rgba(15,23,42,0.82))]">
            <div className="inline-flex items-center rounded-full border border-border/70 bg-background/80 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.18em] text-muted">
              {siteConfig.domain}
            </div>
            <h1 className="mt-6 text-3xl font-semibold tracking-[-0.04em] text-foreground sm:text-4xl">
              {t("title")}
            </h1>
            <p className="mt-4 max-w-2xl text-[15px] leading-7 text-muted">
              {t("description")}
            </p>

            <div className="mt-8 grid gap-3 sm:grid-cols-3">
              {channels.map((channel) => (
                <div
                  key={`summary-${channel.name}`}
                  className="rounded-2xl border border-border/70 bg-background/72 px-4 py-4"
                >
                  <div className="text-sm font-medium text-foreground">{channel.name}</div>
                  <div className="mt-1 text-xs uppercase tracking-[0.16em] text-muted">
                    {channel.action}
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="grid gap-4">
            {channels.map((channel) => (
              <CommunityLink
                key={channel.name}
                href={channel.href}
                name={channel.name}
                action={channel.action}
                description={channel.description}
                icon={channel.icon}
              />
            ))}
          </div>
        </section>
      </main>
    </div>
  );
}
