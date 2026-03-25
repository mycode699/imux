import { DownloadButton } from "./[locale]/components/download-button";
import { GitHubButton } from "./[locale]/components/github-button";
import { SiteFooter } from "./[locale]/components/site-footer";
import { SiteHeader } from "./[locale]/components/site-header";
import { siteConfig } from "./site-config";

export default function MarketingHome() {
  const capabilities = [
    {
      title: "Terminal-first execution",
      body:
        "Run serious AI work in a native macOS shell surface instead of bouncing between wrappers and detached browser tabs.",
    },
    {
      title: "Local and remote explorers",
      body:
        "Browse local projects and SSH-connected hosts from the same workspace, using the same mental model and the same right-side control plane.",
    },
    {
      title: "In-app file editing",
      body:
        "Open, inspect, edit, and save files without breaking terminal flow. Drag paths directly into the active conversation when needed.",
    },
    {
      title: "Supervisor mode",
      body:
        "Turn a few lines of user intent, project context, and recent work into a concrete execution brief with bounded next steps.",
    },
    {
      title: "Browser and automation",
      body:
        "Keep browser-backed tasks beside the terminal and expose them to the same operator workflow instead of juggling separate tools.",
    },
    {
      title: "Source control visibility",
      body:
        "Keep Git state, repo context, and working directories visible while agents or operators are pushing real work forward.",
    },
  ];

  const workflow = [
    {
      step: "01",
      title: "Open a workspace",
      body:
        "Point icc at a local repo or connect an SSH target. Zero-config flow infers enough structure to begin immediately.",
    },
    {
      step: "02",
      title: "Read the working surface",
      body:
        "Terminal state, files, Git context, remote paths, and recent interaction notes stay visible in the same command deck.",
    },
    {
      step: "03",
      title: "Let the supervisor frame the next move",
      body:
        "icc can compress current context into a startup plan, execution brief, or operator handoff without turning the workflow into ceremony.",
    },
    {
      step: "04",
      title: "Execute without losing context",
      body:
        "Browse files, edit code, inspect output, and move between local and remote targets while the conversation stays anchored.",
    },
  ];

  const faqs = [
    {
      q: "Is icc just a Ghostty fork?",
      a:
        "No. icc is a native macOS command center built on Ghostty-grade terminal rendering. The product expands that foundation with explorers, editing, browser execution, supervision, and workspace orchestration.",
    },
    {
      q: "Who is icc for?",
      a:
        "Operators, engineers, founders, and power users who already run multiple AI-assisted workflows and want one sharper control surface instead of more window sprawl.",
    },
    {
      q: "What makes the workflow different?",
      a:
        "icc keeps the terminal first-class while adding the missing surfaces around it: files, remote hosts, source control, browser context, and an execution-focused supervisor.",
    },
    {
      q: "Does it support remote work?",
      a:
        "Yes. icc reads SSH configuration, connects to remote targets, and exposes remote files in the same explorer model used for local work.",
    },
  ];

  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_top_left,_rgba(35,93,255,0.14),_transparent_42%),radial-gradient(circle_at_top_right,_rgba(249,115,22,0.14),_transparent_34%),linear-gradient(180deg,_rgba(255,255,255,0.98),_rgba(245,243,238,0.96))] dark:bg-[radial-gradient(circle_at_top_left,_rgba(59,130,246,0.18),_transparent_36%),radial-gradient(circle_at_top_right,_rgba(249,115,22,0.14),_transparent_28%),linear-gradient(180deg,_rgba(9,14,26,1),_rgba(7,10,20,1))]">
      <SiteHeader />

      <main className="mx-auto flex w-full max-w-6xl flex-col gap-20 px-6 pb-10 pt-12 md:pt-16">
        <section className="grid gap-10 lg:grid-cols-[minmax(0,1.1fr)_minmax(0,0.9fr)] lg:items-center">
          <div className="space-y-8">
            <div className="inline-flex items-center gap-2 rounded-full border border-border/70 bg-background/78 px-3 py-1 text-xs font-semibold uppercase tracking-[0.18em] text-muted shadow-[0_18px_60px_rgba(15,23,42,0.08)] backdrop-blur">
              <span className="h-2 w-2 rounded-full bg-emerald-500" />
              Official site
              <span className="text-border">/</span>
              {siteConfig.version}
            </div>

            <div className="space-y-5">
              <h1 className="max-w-3xl text-5xl font-semibold leading-[0.95] tracking-[-0.05em] text-foreground sm:text-6xl">
                {siteConfig.tagline}
              </h1>
              <p className="max-w-2xl text-lg leading-8 text-muted">
                {siteConfig.name} is a native macOS command center for serious AI work. Keep terminal execution,
                local and remote files, source control, browser tasks, and supervisor-driven next steps inside one
                deliberate workspace.
              </p>
            </div>

            <div className="flex flex-wrap items-center gap-3">
              <DownloadButton location="hero" />
              <GitHubButton />
            </div>

            <div className="grid gap-3 sm:grid-cols-3">
              <div className="rounded-2xl border border-border/70 bg-background/82 p-4 shadow-[0_18px_60px_rgba(15,23,42,0.06)] backdrop-blur">
                <div className="text-xs uppercase tracking-[0.18em] text-muted">Platform</div>
                <div className="mt-2 text-base font-semibold">Native macOS</div>
                <div className="mt-1 text-sm leading-6 text-muted">Swift, AppKit, Ghostty-grade rendering.</div>
              </div>
              <div className="rounded-2xl border border-border/70 bg-background/82 p-4 shadow-[0_18px_60px_rgba(15,23,42,0.06)] backdrop-blur">
                <div className="text-xs uppercase tracking-[0.18em] text-muted">Workspace</div>
                <div className="mt-2 text-base font-semibold">Local + remote</div>
                <div className="mt-1 text-sm leading-6 text-muted">One model for projects, SSH targets, and files.</div>
              </div>
              <div className="rounded-2xl border border-border/70 bg-background/82 p-4 shadow-[0_18px_60px_rgba(15,23,42,0.06)] backdrop-blur">
                <div className="text-xs uppercase tracking-[0.18em] text-muted">Operating style</div>
                <div className="mt-2 text-base font-semibold">Zero-config first</div>
                <div className="mt-1 text-sm leading-6 text-muted">Infer context early, expose controls only when needed.</div>
              </div>
            </div>
          </div>

          <div className="relative">
            <div className="absolute inset-0 -translate-x-6 translate-y-6 rounded-[32px] bg-[linear-gradient(135deg,rgba(37,99,235,0.22),rgba(249,115,22,0.14))] blur-3xl" />
            <div className="relative overflow-hidden rounded-[32px] border border-slate-200/80 bg-[linear-gradient(180deg,rgba(250,250,250,0.98),rgba(241,245,249,0.96))] p-5 shadow-[0_30px_120px_rgba(15,23,42,0.18)] dark:border-slate-800/80 dark:bg-[linear-gradient(180deg,rgba(15,23,42,0.96),rgba(8,12,22,0.98))]">
              <div className="mb-4 flex items-center justify-between border-b border-border/70 pb-4">
                <div className="flex items-center gap-2">
                  <span className="h-2.5 w-2.5 rounded-full bg-rose-400" />
                  <span className="h-2.5 w-2.5 rounded-full bg-amber-400" />
                  <span className="h-2.5 w-2.5 rounded-full bg-emerald-400" />
                </div>
                <div className="rounded-full border border-border/70 px-3 py-1 text-[11px] font-medium text-muted">
                  workspace: /Users/operator/work/icc
                </div>
              </div>

              <div className="grid gap-4 md:grid-cols-[148px_minmax(0,1fr)_170px]">
                <div className="space-y-3 rounded-3xl border border-border/70 bg-background/88 p-3 dark:bg-white/[0.03]">
                  <div className="text-[11px] font-semibold uppercase tracking-[0.18em] text-muted">Rail</div>
                  {["terminal / build", "repo / icc", "remote / prod-ssh", "browser / review"].map((item) => (
                    <div key={item} className="rounded-2xl border border-border/60 px-3 py-2 text-sm text-foreground/90">
                      {item}
                    </div>
                  ))}
                </div>

                <div className="space-y-3 rounded-3xl border border-border/70 bg-slate-950 p-4 text-slate-200 shadow-inner">
                  <div className="flex items-center justify-between text-[11px] uppercase tracking-[0.18em] text-slate-400">
                    <span>Terminal conversation</span>
                    <span>ready</span>
                  </div>
                  <div className="space-y-2 font-mono text-[12px] leading-6">
                    <div>$ icc connect prod-ssh</div>
                    <div className="text-slate-400">Connected. Reading remote workspace and shell state.</div>
                    <div>$ git status --short</div>
                    <div className="text-slate-400">M Sources/WorkspaceSupervisor.swift</div>
                    <div>$ open file explorer</div>
                    <div className="text-slate-400">Paths, files, remote tree, and next action remain visible together.</div>
                  </div>
                </div>

                <div className="space-y-3 rounded-3xl border border-border/70 bg-background/88 p-3 dark:bg-white/[0.03]">
                  <div className="text-[11px] font-semibold uppercase tracking-[0.18em] text-muted">Supervisor</div>
                  <div className="rounded-2xl border border-emerald-500/25 bg-emerald-500/10 p-3">
                    <div className="text-xs uppercase tracking-[0.18em] text-emerald-600 dark:text-emerald-300">Status</div>
                    <div className="mt-2 text-sm font-semibold">Ready to continue</div>
                    <div className="mt-1 text-sm leading-6 text-muted">Goal inferred from current repo, files, and recent task history.</div>
                  </div>
                  <div className="rounded-2xl border border-border/60 p-3">
                    <div className="text-xs uppercase tracking-[0.18em] text-muted">Files</div>
                    <div className="mt-2 text-sm leading-6 text-foreground/90">Open, inspect, edit, and save without leaving the workspace.</div>
                  </div>
                  <div className="rounded-2xl border border-border/60 p-3">
                    <div className="text-xs uppercase tracking-[0.18em] text-muted">Remote</div>
                    <div className="mt-2 text-sm leading-6 text-foreground/90">SSH-backed browsing, same layout, same path handling.</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <section id="capabilities" className="space-y-6">
          <div className="max-w-2xl space-y-3">
            <div className="text-xs font-semibold uppercase tracking-[0.22em] text-muted">Capabilities</div>
            <h2 className="text-3xl font-semibold tracking-[-0.04em] text-foreground sm:text-4xl">
              Built for operators who want context visible while work is happening.
            </h2>
            <p className="text-base leading-7 text-muted">
              icc is not another browser dashboard sitting on top of a terminal. It is a command center that keeps
              execution, files, remote state, and guidance within the same working surface.
            </p>
          </div>

          <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
            {capabilities.map((capability) => (
              <article
                key={capability.title}
                className="rounded-[26px] border border-border/70 bg-background/84 p-6 shadow-[0_18px_60px_rgba(15,23,42,0.06)] backdrop-blur"
              >
                <h3 className="text-lg font-semibold tracking-tight text-foreground">{capability.title}</h3>
                <p className="mt-3 text-sm leading-7 text-muted">{capability.body}</p>
              </article>
            ))}
          </div>
        </section>

        <section className="grid gap-5 lg:grid-cols-[minmax(0,1.1fr)_minmax(0,0.9fr)]">
          <article className="rounded-[28px] border border-border/70 bg-[linear-gradient(135deg,rgba(37,99,235,0.08),rgba(249,115,22,0.08))] p-8 shadow-[0_20px_70px_rgba(15,23,42,0.08)]">
            <div className="text-xs font-semibold uppercase tracking-[0.22em] text-muted">Why it lands differently</div>
            <h2 className="mt-4 max-w-xl text-3xl font-semibold tracking-[-0.04em] text-foreground">
              The fastest path from a few user turns to a real execution surface.
            </h2>
            <div className="mt-6 grid gap-4 sm:grid-cols-2">
              {[
                "Files stay beside the active terminal instead of hiding behind a separate app.",
                "Remote hosts use the same explorer and editing workflow as local projects.",
                "Source control and project context remain visible while changes are happening.",
                "Supervisor mode frames the next move without forcing a heavyweight setup ritual.",
              ].map((item) => (
                <div key={item} className="rounded-2xl border border-border/60 bg-background/78 px-4 py-4 text-sm leading-7 text-foreground/90">
                  {item}
                </div>
              ))}
            </div>
          </article>

          <article className="rounded-[28px] border border-border/70 bg-background/84 p-8 shadow-[0_18px_60px_rgba(15,23,42,0.06)]">
            <div className="text-xs font-semibold uppercase tracking-[0.22em] text-muted">Product profile</div>
            <div className="mt-6 space-y-5">
              {[
                ["Rendering", "Ghostty-grade terminal engine with a native macOS shell surface."],
                ["Surface model", "Workspace-first layout with files, browser tasks, and remote state in-view."],
                ["Automation", "Supervisor, browser control, CLI compatibility, and task-ready context compression."],
                ["Release line", `${siteConfig.version} on ${siteConfig.domain}`],
              ].map(([label, value]) => (
                <div key={label} className="flex flex-col gap-1 border-b border-border/60 pb-4 last:border-b-0 last:pb-0">
                  <span className="text-xs uppercase tracking-[0.18em] text-muted">{label}</span>
                  <span className="text-sm leading-7 text-foreground/90">{value}</span>
                </div>
              ))}
            </div>
          </article>
        </section>

        <section id="workflow" className="space-y-6">
          <div className="max-w-2xl space-y-3">
            <div className="text-xs font-semibold uppercase tracking-[0.22em] text-muted">Workflow</div>
            <h2 className="text-3xl font-semibold tracking-[-0.04em] text-foreground sm:text-4xl">
              Zero-config where it should be. Explicit control where it matters.
            </h2>
            <p className="text-base leading-7 text-muted">
              The product philosophy is simple: infer first, ask second. You should be able to open a project,
              connect a host, and start moving before you get buried in setup panels.
            </p>
          </div>

          <div className="grid gap-4 lg:grid-cols-4">
            {workflow.map((item) => (
              <article
                key={item.step}
                className="rounded-[26px] border border-border/70 bg-background/84 p-6 shadow-[0_18px_60px_rgba(15,23,42,0.06)]"
              >
                <div className="text-xs font-semibold uppercase tracking-[0.22em] text-muted">{item.step}</div>
                <h3 className="mt-3 text-lg font-semibold tracking-tight text-foreground">{item.title}</h3>
                <p className="mt-3 text-sm leading-7 text-muted">{item.body}</p>
              </article>
            ))}
          </div>
        </section>

        <section id="faq" className="space-y-6">
          <div className="max-w-2xl space-y-3">
            <div className="text-xs font-semibold uppercase tracking-[0.22em] text-muted">FAQ</div>
            <h2 className="text-3xl font-semibold tracking-[-0.04em] text-foreground sm:text-4xl">
              Direct answers for what people ask first.
            </h2>
          </div>

          <div className="grid gap-4 lg:grid-cols-2">
            {faqs.map((faq) => (
              <article
                key={faq.q}
                className="rounded-[26px] border border-border/70 bg-background/84 p-6 shadow-[0_18px_60px_rgba(15,23,42,0.06)]"
              >
                <h3 className="text-lg font-semibold tracking-tight text-foreground">{faq.q}</h3>
                <p className="mt-3 text-sm leading-7 text-muted">{faq.a}</p>
              </article>
            ))}
          </div>
        </section>

        <section className="rounded-[32px] border border-border/70 bg-[linear-gradient(135deg,rgba(15,23,42,0.96),rgba(30,41,59,0.96))] px-8 py-10 text-slate-100 shadow-[0_30px_100px_rgba(15,23,42,0.24)]">
          <div className="grid gap-8 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-end">
            <div className="space-y-4">
              <div className="text-xs font-semibold uppercase tracking-[0.22em] text-slate-400">Launch icc</div>
              <h2 className="max-w-2xl text-3xl font-semibold tracking-[-0.04em] text-white sm:text-4xl">
                Move from intent to execution without losing the shape of the work.
              </h2>
              <p className="max-w-2xl text-base leading-7 text-slate-300">
                Download the current macOS build or track releases and source on GitHub. The public site, release line,
                and repository are now aligned to one identity: {siteConfig.name}.
              </p>
            </div>

            <div className="flex flex-wrap items-center gap-3 lg:justify-end">
              <DownloadButton location="bottom" />
              <GitHubButton location="bottom" />
            </div>
          </div>
        </section>
      </main>

      <SiteFooter />
    </div>
  );
}
