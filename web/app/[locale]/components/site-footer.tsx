import { siteConfig } from "../../site-config";

export async function SiteFooter() {
  const year = new Date().getFullYear();

  return (
    <footer className="mt-24 border-t border-border/70">
      <div className="max-w-6xl mx-auto px-6 py-10">
        <div className="grid gap-10 md:grid-cols-[minmax(0,1.4fr)_minmax(0,0.8fr)_minmax(0,0.8fr)]">
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <img
                src="/logo.png"
                alt={siteConfig.name}
                width={28}
                height={28}
                className="rounded-lg"
              />
              <div>
                <div className="text-sm font-semibold tracking-tight">{siteConfig.name}</div>
                <div className="text-xs text-muted">{siteConfig.descriptor}</div>
              </div>
            </div>
            <p className="max-w-xl text-sm leading-6 text-muted">
              Native Swift and AppKit. Ghostty-grade rendering. Local and remote context, file operations,
              browser execution, source control, and supervision in one operator-first workspace.
            </p>
          </div>

          <div>
            <div className="mb-3 text-xs font-semibold uppercase tracking-[0.18em] text-muted">
              Explore
            </div>
            <div className="space-y-2 text-sm text-muted">
              <a href="#capabilities" className="block hover:text-foreground transition-colors">Capabilities</a>
              <a href="#workflow" className="block hover:text-foreground transition-colors">Workflow</a>
              <a href="#faq" className="block hover:text-foreground transition-colors">FAQ</a>
            </div>
          </div>

          <div>
            <div className="mb-3 text-xs font-semibold uppercase tracking-[0.18em] text-muted">
              Release
            </div>
            <div className="space-y-2 text-sm text-muted">
              <a href={siteConfig.downloadUrl} className="block hover:text-foreground transition-colors">
                Download for macOS
              </a>
              <a
                href={siteConfig.releasesUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="block hover:text-foreground transition-colors"
              >
                Releases
              </a>
              <a
                href={siteConfig.repoUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="block hover:text-foreground transition-colors"
              >
                GitHub Repository
              </a>
              <a
                href={siteConfig.issuesUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="block hover:text-foreground transition-colors"
              >
                Support / Issues
              </a>
            </div>
          </div>
        </div>

        <div className="mt-10 flex flex-col gap-2 border-t border-border/70 pt-5 text-xs text-muted sm:flex-row sm:items-center sm:justify-between">
          <p>© {year} {siteConfig.name}. {siteConfig.tagline}</p>
          <p>{siteConfig.domain}</p>
        </div>
      </div>
    </footer>
  );
}
