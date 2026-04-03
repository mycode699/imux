import { marketingLocales } from "./marketing-copy";
import { siteConfig } from "./site-config";

type ResourceCard = {
  title: string;
  body: string;
  cta: string;
};

type GuideSection = {
  title: string;
  body: string;
  points: string[];
};

type ChangelogEntry = {
  date: string;
  version: string;
  title: string;
  body: string;
  bullets: string[];
};

type ProductPageCopy = {
  nav: {
    home: string;
    guide: string;
    changelog: string;
    github: string;
  };
  resources: {
    eyebrow: string;
    title: string;
    body: string;
    guide: ResourceCard;
    changelog: ResourceCard;
  };
  guide: {
    section: string;
    metaTitle: string;
    metaDescription: string;
    eyebrow: string;
    title: string;
    intro: string;
    quickStartTitle: string;
    quickStartSteps: string[];
    workflowsTitle: string;
    workflowsIntro: string;
    workflows: GuideSection[];
    sections: GuideSection[];
    bestPracticesTitle: string;
    bestPracticesIntro: string;
    bestPractices: string[];
    briefingTitle: string;
    briefingIntro: string;
    briefingChecklist: string[];
    troubleshootingTitle: string;
    troubleshootingIntro: string;
    troubleshooting: GuideSection[];
    updateTitle: string;
    updateSteps: string[];
    secondaryCta: string;
  };
  changelog: {
    section: string;
    metaTitle: string;
    metaDescription: string;
    eyebrow: string;
    title: string;
    intro: string;
    currentReleaseLabel: string;
    currentReleaseBody: string;
    releaseModelTitle: string;
    releaseModelIntro: string;
    releaseModel: GuideSection[];
    entriesTitle: string;
    entries: ChangelogEntry[];
    upgradeTitle: string;
    upgradeSteps: string[];
    supportTitle: string;
    supportBody: string;
    supportChecklistTitle: string;
    supportChecklist: string[];
    supportDownloadLabel: string;
    supportAppcastLabel: string;
    supportManifestLabel: string;
    supportRemoteManifestLabel: string;
    platformStatusTitle: string;
    platformStatusBody: string;
    secondaryCta: string;
  };
  shared: {
    viewReleases: string;
    backHome: string;
    reportIssue: string;
  };
};

const englishCopy: ProductPageCopy = {
  nav: {
    home: "Home",
    guide: "Guide",
    changelog: "Changelog",
    github: "GitHub",
  },
  resources: {
    eyebrow: "Resources",
    title: "Use IMUX with less guesswork and track what changes release by release.",
    body:
      "The site now includes a practical product guide plus a changelog that records what shipped, when it shipped, and how to upgrade without losing context.",
    guide: {
      title: "Usage Guide",
      body:
        "A complete operating guide for local workspaces, remote hosts, file editing, supervisor flow, source control visibility, and safe upgrades.",
      cta: "Open guide",
    },
    changelog: {
      title: "Upgrade Log",
      body:
        "A structured release history for IMUX, including the first public line, website rollout, localization updates, and upgrade notes.",
      cta: "View changelog",
    },
  },
  guide: {
    section: "Guide",
    metaTitle: "IMUX Guide — How to Use IMUX",
    metaDescription:
      "A practical IMUX usage guide covering setup, local and remote workspaces, file editing, supervisor flow, source control, and upgrade steps.",
    eyebrow: "Usage Guide",
    title: "How to use IMUX from first launch to daily execution.",
    intro:
      "IMUX is designed to get you from intent to execution fast, without scattering the workflow across multiple apps. Use this guide as the baseline operating manual for local projects, remote hosts, file editing, source visibility, and supervisor-driven work.",
    quickStartTitle: "Quick start",
    quickStartSteps: [
      "Download the current macOS build from the IMUX website and install the app.",
      "Open IMUX and create a workspace from a local folder, or start from a configured SSH target.",
      "Set your LLM provider and model in Settings before you hand a task to the supervisor.",
      "Use the right-side explorer and editor to keep files, paths, and task context visible while the terminal remains primary.",
    ],
    workflowsTitle: "Recommended operating methods",
    workflowsIntro:
      "Most teams do better when IMUX is used as a repeatable operating surface rather than a one-off prompt box. These patterns keep the terminal primary while reducing drift.",
    workflows: [
      {
        title: "1. Local coding loop",
        body:
          "Use one workspace per repo, keep Git visible, and let the terminal drive the task while files stay open beside it for verification.",
        points: [
          "Open the target repo as its own workspace.",
          "Inspect the file tree before changing anything substantial.",
          "Keep edits small, verify them in the editor, then return to the active thread.",
        ],
      },
      {
        title: "2. Remote operations loop",
        body:
          "Treat each SSH host like a first-class workspace with the same discipline you would apply locally. Remote work gets safer when path awareness and authentication state are visible.",
        points: [
          "Connect only after confirming the correct SSH target.",
          "Wait for authentication and directory discovery before browsing files.",
          "Use a separate workspace per host so logs, paths, and objectives do not mix.",
        ],
      },
      {
        title: "3. Review and verification loop",
        body:
          "Do not rely on generated output alone. IMUX works best when the operator quickly checks files, paths, Git state, and command results before the next step is approved.",
        points: [
          "Open changed files immediately after each meaningful step.",
          "Confirm the exact path and branch before packaging or publishing.",
          "Use the right-side surfaces for evidence, not just for navigation.",
        ],
      },
      {
        title: "4. Multi-task supervisor loop",
        body:
          "When several tasks are moving at once, the supervisor should be used to keep goals bounded and progress interpretable rather than to produce abstract commentary.",
        points: [
          "Give every workspace a short, concrete objective.",
          "Revisit the supervisor only when context has materially changed.",
          "Prefer several clean workspaces over one overloaded universal session.",
        ],
      },
    ],
    sections: [
      {
        title: "1. Start with a workspace, not a loose terminal",
        body:
          "IMUX is optimized around a workspace model. The workspace should represent one concrete project or one concrete remote host so the terminal, files, browser tasks, and supervisor all reference the same operating context.",
        points: [
          "Create a local workspace from the repo or folder you actually want to work on.",
          "Use a dedicated remote workspace for each SSH target instead of mixing unrelated hosts together.",
          "Keep one goal per workspace when possible. That keeps supervisor plans and file context cleaner.",
        ],
      },
      {
        title: "2. Use the local and remote explorers as your control plane",
        body:
          "The explorer is not decorative. It is the fastest way to inspect project shape, open files, confirm paths, and stay oriented while the terminal conversation is active.",
        points: [
          "Use the local explorer to inspect repo structure before editing or delegating work.",
          "Use the remote explorer only after the SSH session is actually connected and authenticated.",
          "Drag file paths into the active terminal conversation when you want the path to become part of the task context.",
        ],
      },
      {
        title: "3. Read, edit, and save files without breaking flow",
        body:
          "IMUX includes in-workspace file viewing and editing so you do not have to keep bouncing out to a second editor for every small change or inspection pass.",
        points: [
          "Click a file to preview or edit it directly inside the workspace.",
          "Save edits in place and return to the active terminal thread without losing context.",
          "Use the file view for verification too: confirm the exact contents before you ask the supervisor or terminal to continue.",
        ],
      },
      {
        title: "4. Treat the supervisor as an execution layer, not a chat toy",
        body:
          "The supervisor works best when you give it a concrete target, enough repo context, and a bounded objective. It should reduce ambiguity and compress the next move into a plan that can actually be executed.",
        points: [
          "Give each workspace a clear objective before asking the supervisor to take over.",
          "Review the proposed next steps instead of accepting vague plans blindly.",
          "Use the supervisor to frame work, track progress, and keep multiple active tasks from drifting.",
        ],
      },
      {
        title: "5. Keep source control visible while changes are happening",
        body:
          "IMUX is most useful when Git state stays visible during execution rather than becoming an afterthought at the end of the task.",
        points: [
          "Check branch and working tree state before you start editing.",
          "Use visible file paths and repo context to avoid accidental edits in the wrong place.",
          "Review current changes before packaging or publishing any result.",
        ],
      },
      {
        title: "6. Upgrade with a release-first habit",
        body:
          "Do not treat upgrades as a blind overwrite. IMUX should be updated with the same discipline you apply to any other developer tool that controls project context, remote access, or model settings.",
        points: [
          "Read the changelog before replacing the app build.",
          "Reconfirm model settings, SSH behavior, and any saved connection preferences after updating.",
          "Use one clean workspace to validate the new build before you move all active work onto it.",
        ],
      },
    ],
    bestPracticesTitle: "Best practices that improve the experience fast",
    bestPracticesIntro:
      "A few habits change IMUX from a promising shell wrapper into a much more reliable command center.",
    bestPractices: [
      "Keep one repo or one remote host per workspace whenever possible.",
      "Set the workspace objective before handing control to the supervisor.",
      "Drag precise file paths into the active thread instead of describing files vaguely.",
      "Check Git state early, not only at the end of the task.",
      "Use the editor for confirmation after every non-trivial generated change.",
      "Validate one clean local path and one clean remote path after every upgrade.",
    ],
    briefingTitle: "How to brief IMUX so execution starts in 2 to 3 turns",
    briefingIntro:
      "Most slow starts come from vague goals, not from missing features. A short, concrete brief usually gets IMUX into execution mode fast.",
    briefingChecklist: [
      "Name the exact repo, folder, or SSH target first.",
      "State one outcome you need now instead of bundling several unrelated goals together.",
      "Mention the most relevant files, commands, or URLs if you already know them.",
      "Define what done looks like in one measurable sentence.",
      "Use the next reply to tighten scope or priorities instead of rewriting the full request.",
    ],
    troubleshootingTitle: "Troubleshooting and recovery",
    troubleshootingIntro:
      "When IMUX feels slow, noisy, or unreliable, the fix is usually operational rather than magical. These are the first checks worth making.",
    troubleshooting: [
      {
        title: "SSH connection looks stuck",
        body:
          "Most remote failures are caused by incomplete authentication, mismatched SSH config, or trying to browse files before the connection has fully settled.",
        points: [
          "Reconfirm the target in your SSH config and reconnect cleanly.",
          "Wait for the terminal to show the connected shell state before using the remote explorer.",
          "Test the target in a normal SSH session if the explorer still cannot populate.",
        ],
      },
      {
        title: "The workspace feels noisy or unfocused",
        body:
          "This usually means the workspace goal is too broad or too many unrelated paths and tasks are sharing the same surface.",
        points: [
          "Split unrelated efforts into separate workspaces.",
          "Narrow the active objective to one concrete outcome.",
          "Close files and panes that are no longer part of the current decision path.",
        ],
      },
      {
        title: "The supervisor is suggesting vague next steps",
        body:
          "That usually means it is missing a bounded objective, fresh file evidence, or a clear signal about what counts as done.",
        points: [
          "Restate the objective in one sentence with a measurable end condition.",
          "Open the most relevant files before asking it to continue.",
          "Point it at the current repo state instead of relying on old chat context.",
        ],
      },
    ],
    updateTitle: "Safe update checklist",
    updateSteps: [
      "Download the latest DMG from the IMUX website download endpoint.",
      "Quit the current app cleanly so open writes or active sessions are not interrupted mid-task.",
      "Install the new build, reopen IMUX, and verify LLM settings plus SSH connections before resuming important work.",
      "Check the changelog for behavior changes in explorers, supervisor flow, file editing, or routing.",
    ],
    secondaryCta: "View changelog",
  },
  changelog: {
    section: "Changelog",
    metaTitle: "IMUX Changelog — Release History",
    metaDescription:
      "Track IMUX release history, launch milestones, website updates, multilingual rollout, and upgrade guidance.",
    eyebrow: "Upgrade Log",
    title: "What changed, when it changed, and what to verify after upgrading.",
    intro:
      "This log is the public release record for IMUX. It tracks the current product line, the official website rollout, documentation changes, and the operating notes you should check before replacing your current build.",
    currentReleaseLabel: "Current release line",
    currentReleaseBody:
      "IMUX is currently published as v1.5.2. This stable line hardens multi-workspace session restore after close and reopen, adds explicit recovery for the recent task-completion black-panel path, and keeps the website plus GitHub release surface aligned on one current installer.",
    releaseModelTitle: "How to read IMUX releases",
    releaseModelIntro:
      "Use the changelog as an operating document, not just a marketing page. A good release note helps you decide whether to adopt immediately, validate first, or hold until an active workflow is done.",
    releaseModel: [
      {
        title: "1. Stable line first",
        body:
          "Treat the public version as the stable line you can standardize on for real work. Upgrade deliberately, not because a build happens to exist.",
        points: [
          "Check the current version label before replacing the app.",
          "Prefer one approved build across a team or project cluster.",
          "Use the changelog to decide when timing is safe for important work.",
        ],
      },
      {
        title: "2. Read for impact, not for headlines",
        body:
          "Focus on what changes your operating surface: file handling, SSH behavior, supervisor flow, model settings, or packaging.",
        points: [
          "Look for workflow changes before cosmetic changes.",
          "Verify whether remote behavior, routing, or settings persistence changed.",
          "Map release notes to your current active tasks before updating.",
        ],
      },
      {
        title: "3. Validate with one clean path",
        body:
          "Every upgrade should be checked in at least one controlled local workspace and one controlled remote workspace before it becomes your default daily build.",
        points: [
          "Open a local repo and confirm editing plus save behavior.",
          "Connect one SSH host and confirm remote browsing still matches expectation.",
          "Only then move critical tasks to the new version.",
        ],
      },
    ],
    entriesTitle: "Release history",
    entries: [
      {
        date: "April 3, 2026",
        version: "v1.5.2",
        title: "Durable session restore and stronger black-panel recovery",
        body:
          "This stable release focuses on two trust failures in the active workspace loop: IMUX reopening into a thinner pane set than the one you left behind, and intermittent black front panels after task-completion driven workspace churn.",
        bullets: [
          "Session persistence now keeps a richer stable snapshot and forces a full save when the last main window closes, so reopening IMUX is far less likely to drop previously opened conversation and workspace panes.",
          "Thin lifecycle saves no longer immediately downgrade a fuller recent snapshot during restore, which makes close-and-reopen behavior much more durable for multi-workspace setups.",
          "Notification-driven workspace reorders and focus jumps now request explicit render recovery, reducing the intermittent black front panel seen after task completion events.",
        ],
      },
      {
        date: "April 3, 2026",
        version: "v1.5.1",
        title: "Remote SSH workspace preservation and portal recovery hardening",
        body:
          "This stable release focuses on two interruptions that break active work: remote workspaces disappearing when the last SSH terminal exits, and terminal surfaces occasionally staying black after fast UI churn.",
        bullets: [
          "Remote SSH child-exit on the last terminal now preserves the workspace so reconnecting can resume from the same remote context instead of reopening everything from scratch.",
          "Enabled the existing transient terminal portal recovery path by default to reduce black-screen failures during split changes, sidebar churn, and workspace switching.",
          "Promoted `v1.5.1` across the public release surface so the website changelog, download endpoints, and GitHub release point to the same current installer.",
        ],
      },
      {
        date: "April 2, 2026",
        version: "v1.5.0",
        title: "Denser workspace polish and cleaner release surface",
        body:
          "This stable release finishes the current UI pass with a tighter VS Code-like workspace layout, safer text-input handling, and a cleaner public release path for the same installer and website surface.",
        bullets: [
          "Tightened the activity rail, workspace list, and sidebar header so the main operating surface reads much closer to a dense VS Code-style layout.",
          "Reduced the terminal startup banner to a compact status strip and fixed the stuck-width right sidebar path in the file inspector.",
          "Scoped Return forwarding away from the affected macOS IME composition path and kept the `v1.5.0` website and release pipeline aligned around one current installer target.",
        ],
      },
      {
        date: "April 1, 2026",
        version: "v1.2.0",
        title: "Install-repair release for direct in-place upgrades",
        body:
          "This stable release focuses on the last friction point in the desktop upgrade path: moving a running copy out of the DMG or translocated location, replacing the existing app bundle cleanly, and relaunching from a supported install path.",
        bullets: [
          "Added an install-and-relaunch recovery path when IMUX is opened from a disk image, App Translocation, or another unsupported launch location.",
          "Updated the recovery installer so an existing IMUX app bundle in Applications is treated as the intended replacement target instead of a blocking directory.",
          "Extended updater error handling so incompatible launch locations now expose the same direct repair action instead of ending on a dead-end retry loop.",
        ],
      },
      {
        date: "April 1, 2026",
        version: "v1.1.0",
        title: "Identity hardening pass and release-surface cleanup",
        body:
          "This stable release removes the remaining inherited brand shadows from the active IMUX experience and tightens the release-facing path from website to installer to support.",
        bullets: [
          "Replaced inherited repository, company, and support references across the app, website, docs, and localized public strings with the current IMUX-owned surfaces.",
          "Rebuilt the community, legal, and feedback paths so visible contact and support entry points now read as one deliberate IMUX product presence instead of a carried-over fork layer.",
          "Aligned the packaged app, website changelog copy, and download endpoints so the latest stable installer and its public guidance point to the same release line.",
        ],
      },
      {
        date: "March 31, 2026",
        version: "v1.0.10",
        title: "Interaction reliability pass and linked-mode quick launch",
        body:
          "This stable release focuses on the parts users hit first: inactive-window click reliability, a faster Claude + Codex launch path, and tighter alignment between the packaged app and the website release line.",
        bullets: [
          "Accepted first-click activation across the main window host, titlebar accessory host, and settings-style utility windows so buttons and toggles no longer need a second click after refocus.",
          "Promoted Claude + Codex linked mode into the titlebar control cluster and compact creation menu, using the same shared workspace launcher as the AI Command Center sidebar.",
          "Adjusted release-facing website copy so the homepage and changelog describe the same new stable line before users download the installer.",
        ],
      },
      {
        date: "March 31, 2026",
        version: "v1.0.9",
        title: "Brand consistency sweep and sidebar interaction consolidation",
        body:
          "This stable release unifies active website copy around the IMUX brand, aligns docs and legal surfaces to current repository endpoints, and stabilizes the sidebar interaction model so workspace navigation and tool panes no longer fight each other.",
        bullets: [
          "Rebranded active docs, legal, community, and localized website strings from legacy naming to IMUX while keeping historical blog and changelog archive content intentionally untouched.",
          "Aligned active GitHub links and release-facing website routes to the current IMUX repository and download endpoints.",
          "Updated sidebar behavior so left navigation can stay visible while right-side tools are open, and ensured file/remote explorer editor context resets correctly on workspace switches.",
        ],
      },
      {
        date: "March 31, 2026",
        version: "v1.0.8",
        title: "Installer path hardening and release artifact verification",
        body:
          "This stable release hardens the macOS packaging path so the shipped DMG behaves like a proper drag-to-Applications installer and the release pipeline now verifies the artifact shape instead of assuming it.",
        bullets: [
          "Unified local and GitHub release packaging behind one shared DMG creation helper so release behavior stays consistent across environments.",
          "Added release-time verification that mounts the DMG, checks the app bundle, validates the Applications drag target, and rejects malformed installer artifacts before publication.",
          "Kept the website, release manifest, and GitHub assets aligned to the same versioned installer so operators and users see one stable source of truth.",
        ],
      },
      {
        date: "March 31, 2026",
        version: "v1.0.7",
        title: "Release packaging refresh, branded assets, and supervisor layout hardening",
        body:
          "This stable release republishes IMUX with the refreshed branded app assets, a clean versioned installer path, and a safer supervisor panel layout for long generated prompts.",
        bullets: [
          "Rebuilt the IMUX app, icon set, favicon, Apple touch icon, and website logos from one branded asset generator so app and website visuals stay in sync.",
          "Aligned stable download naming around the versioned installer path so GitHub releases, the homepage, and the download manifest resolve to the same macOS package.",
          "Constrained long supervisor prompt cards inside the sidebar so generated task briefs no longer blow out narrow panes or dialogs.",
        ],
      },
      {
        date: "March 30, 2026",
        version: "v1.0.5",
        title: "Brand refinement, migration shortcuts, and updater compatibility improvements",
        body:
          "The current IMUX stable line sharpens the product identity, smooths migration from other AI coding clients, improves in-workspace control surfaces, and hardens update behavior for older local installs.",
        bullets: [
          "Replaced release-facing iconography, welcome copy, and visible product labels so IMUX is distinct across app and website surfaces.",
          "Added quick import actions for VS Code, Cursor, Claude Code, and Codex preferences.",
          "Upgraded the source-control area and collaboration tools so fast pull, fast push, and multi-model pane creation happen inside live IMUX terminals.",
          "Added explicit updater compatibility checks for disk-image, app-translocated, and non-Applications launches so older installs fail with actionable recovery guidance instead of vague Sparkle errors.",
        ],
      },
      {
        date: "March 26, 2026",
        version: "v0.0.1",
        title: "Documentation and multilingual website expansion",
        body:
          "The official website gained a full usage guide, a dedicated changelog page, and broader locale coverage across the public marketing surface.",
        bullets: [
          "Added dedicated /guide and /changelog routes.",
          "Expanded website language coverage across all routed marketing locales.",
          "Published practical setup, workflow, and upgrade instructions for IMUX users.",
        ],
      },
      {
        date: "March 25, 2026",
        version: "v0.0.1",
        title: "Official IMUX website launch",
        body:
          "The public site moved onto the IMUX brand and domain, with aligned downloads, repository links, metadata, and production hosting.",
        bullets: [
          "Launched https://www.iccjk.com as the official public domain.",
          "Aligned branding to IMUX across title, metadata, footer, download links, and repository links.",
          "Connected the website to the public GitHub release path for the macOS build.",
        ],
      },
      {
        date: "March 25, 2026",
        version: "v0.0.1",
        title: "First public IMUX product baseline",
        body:
          "The initial public line centered the workflow around a native macOS command center with terminal-first execution and surrounding control surfaces.",
        bullets: [
          "Terminal-first workspace model.",
          "Local and remote explorers with SSH-backed remote browsing.",
          "In-workspace file viewing and editing plus source control visibility.",
          "Supervisor-oriented execution flow for task framing and multi-step work.",
        ],
      },
    ],
    upgradeTitle: "Upgrade guidance",
    upgradeSteps: [
      "Read the latest changelog entry before installing a new build.",
      "Replace the app from the latest DMG instead of mixing partial app copies.",
      "Recheck LLM settings, saved SSH behavior, and workspace assumptions after upgrading.",
      "Validate one local workspace and one remote workspace before moving critical work onto the updated build.",
    ],
    supportTitle: "If an upgrade changes expected behavior",
    supportBody:
      "When something feels off after updating, use the guide to re-check the intended workflow, compare against the releases feed, and report a concrete issue with paths, settings, and reproduction steps.",
    supportChecklistTitle: "What to include in a useful issue report",
    supportChecklist: [
      "The IMUX version and whether the issue is local, remote, or supervisor-related.",
      "The workspace path or SSH target involved.",
      "Expected behavior versus actual behavior.",
      "A short sequence of clicks, commands, or prompts that reproduces it.",
      "A screenshot or terminal output when the problem is visual, remote, or stateful.",
    ],
    supportDownloadLabel: "Stable macOS download",
    supportAppcastLabel: "Sparkle appcast",
    supportManifestLabel: "Release manifest",
    supportRemoteManifestLabel: "Remote helper manifest",
    platformStatusTitle: "Platform status",
    platformStatusBody:
      "macOS is the only production desktop build today. IMUX currently ships as a native AppKit/SwiftUI client, so a Windows installer is not published yet.",
    secondaryCta: "Open guide",
  },
  shared: {
    viewReleases: "View releases",
    backHome: "Back home",
    reportIssue: "Report issue",
  },
};

const zhCnCopy: ProductPageCopy = {
  nav: {
    home: "首页",
    guide: "使用说明",
    changelog: "升级日志",
    github: "GitHub",
  },
  resources: {
    eyebrow: "资源",
    title: "降低上手成本，并按版本追踪 IMUX 的变化。",
    body:
      "官网现在包含一套实用的产品使用说明，以及一份结构化升级日志，记录每次发布内容、发布时间和升级时需要核对的事项。",
    guide: {
      title: "完整使用说明",
      body:
        "覆盖本地工作区、远程主机、文件编辑、监督器流程、源码状态可见性以及安全升级步骤的完整操作指南。",
      cta: "查看说明",
    },
    changelog: {
      title: "升级日志",
      body:
        "按时间记录 IMUX 的发布历史，包括首个公开版本、官网上线、多语言扩展以及升级注意事项。",
      cta: "查看日志",
    },
  },
  guide: {
    section: "使用说明",
    metaTitle: "IMUX 使用说明",
    metaDescription:
      "IMUX 的完整使用说明，覆盖设置、本地与远程工作区、文件编辑、监督器流程、源码状态以及升级步骤。",
    eyebrow: "完整使用说明",
    title: "从第一次启动到日常执行，IMUX 应该这样用。",
    intro:
      "IMUX 的目标不是多一个聊天窗口，而是把意图快速压到可执行工作面上。下面这份说明可以作为 IMUX 的基准操作手册，帮助你在本地项目、远程主机、文件编辑、源码状态和监督器工作流之间保持一致。",
    quickStartTitle: "快速开始",
    quickStartSteps: [
      "从 IMUX 官方网站下载当前 macOS 安装包并完成安装。",
      "打开 IMUX，从本地目录创建工作区，或者从已配置的 SSH 目标开始。",
      "在交给监督器执行前，先在 Settings 中设置好你的 LLM 提供商与模型。",
      "让右侧资源管理器和编辑器承担文件、路径、任务上下文的展示，保持终端始终是主工作面。",
    ],
    workflowsTitle: "推荐的使用方式",
    workflowsIntro:
      "IMUX 最适合被当作一套可重复执行的操作面，而不是一次性提示框。下面这些方式可以在保持终端优先的同时，减少上下文漂移。",
    workflows: [
      {
        title: "1. 本地开发循环",
        body:
          "一个仓库对应一个工作区，Git 状态持续可见，终端驱动任务推进，文件视图承担核对与确认职责。",
        points: [
          "把目标仓库作为独立工作区打开。",
          "开始大改前先浏览一次文件树。",
          "每次重要修改后先在编辑器里确认，再回到主线程继续。",
        ],
      },
      {
        title: "2. 远程运维循环",
        body:
          "把每台 SSH 主机都当成一等工作区，使用和本地一致的纪律。远程任务只有在路径与认证状态清晰时才真正安全。",
        points: [
          "先确认 SSH 目标，再建立连接。",
          "等终端明确显示远端 shell 状态后再使用远程资源管理器。",
          "尽量一台主机一个工作区，避免日志、路径和目标混杂。",
        ],
      },
      {
        title: "3. 审核与验证循环",
        body:
          "不要只相信生成结果。IMUX 最强的地方，是你可以快速把文件、路径、Git 状态和命令结果放到同一视图里核对。",
        points: [
          "每次关键步骤完成后立刻打开相关文件。",
          "发布前确认准确路径和分支状态。",
          "把右侧面板当作证据面，而不仅仅是导航面。",
        ],
      },
      {
        title: "4. 多任务监督循环",
        body:
          "当多个任务并行时，监督器最适合做的是维持目标边界和进度可解释性，而不是输出空泛总结。",
        points: [
          "给每个工作区一个简短且具体的目标。",
          "只有在上下文发生明显变化时再重新调用监督器。",
          "优先使用多个干净工作区，而不是一个超载会话。",
        ],
      },
    ],
    sections: [
      {
        title: "1. 先建立工作区，而不是先堆终端",
        body:
          "IMUX 的核心不是孤立终端，而是工作区。一个工作区最好只对应一个明确项目或一个明确远程主机，这样终端、文件、浏览器任务和监督器都基于同一上下文运行。",
        points: [
          "本地工作区应该直接指向你真正要处理的仓库或目录。",
          "远程工作区最好一台主机一个，不要把不相关的远端任务混在一起。",
          "尽量一项目标对应一个工作区，这样监督器生成的计划更清晰。",
        ],
      },
      {
        title: "2. 把本地和远程资源管理器当作控制平面来用",
        body:
          "资源管理器不是装饰，而是你快速确认项目结构、打开文件、核对路径、保持方向感的主要界面。",
        points: [
          "在开始编辑或交给监督器前，先用本地资源管理器读一遍仓库结构。",
          "只有在 SSH 会话真正连接并认证完成后，再依赖远程资源管理器执行远端文件操作。",
          "需要让终端上下文明确指向某个文件时，直接把路径拖进当前终端对话。",
        ],
      },
      {
        title: "3. 在工作区内直接阅读、编辑和保存文件",
        body:
          "IMUX 提供工作区内文件查看与编辑能力，避免你为了每一次小改动或核对都跳到第二个编辑器里。",
        points: [
          "点击文件即可在工作区内部查看或编辑。",
          "保存后可以立刻回到当前终端线程，不丢上下文。",
          "文件视图也适合做核对：在让监督器继续前，先确认实际内容。",
        ],
      },
      {
        title: "4. 把监督器当成执行层，而不是聊天玩具",
        body:
          "监督器只有在目标具体、上下文充分、边界明确时才真正高效。它的价值在于压缩歧义、组织下一步，而不是输出一堆空泛话术。",
        points: [
          "给每个工作区先设定一个明确目标，再让监督器接手。",
          "先看监督器给出的下一步是否可执行，不要盲目接受模糊计划。",
          "监督器适合用来组织推进、追踪进度，以及约束多任务漂移。",
        ],
      },
      {
        title: "5. 让源码状态在执行过程中始终可见",
        body:
          "IMUX 最大的价值之一，是让 Git 状态在执行过程中始终可见，而不是到最后才想起来核对改动。",
        points: [
          "开始编辑前先确认当前分支和工作树状态。",
          "利用可见路径和仓库上下文，避免误改到错误目录。",
          "在准备发布或交付结果前，再检查一遍当前变更。",
        ],
      },
      {
        title: "6. 用发布优先的习惯来升级 IMUX",
        body:
          "不要把升级当成盲覆盖。IMUX 控制的是项目上下文、远程访问和模型设置，升级动作本身也应该有工程纪律。",
        points: [
          "先读升级日志，再替换应用构建。",
          "升级后重新确认模型设置、SSH 行为和保存的连接偏好。",
          "先用一个干净工作区验证新构建，再把全部重要任务迁移过去。",
        ],
      },
    ],
    bestPracticesTitle: "能立刻改善体验的习惯",
    bestPracticesIntro:
      "只要建立几条简单习惯，IMUX 就会从一个看起来不错的工具，变成真正稳定的指挥中心。",
    bestPractices: [
      "尽量保持一个工作区只对应一个仓库或一台远程主机。",
      "把工作区目标先写清楚，再交给监督器推进。",
      "把精确文件路径拖进线程，而不是用模糊描述代替。",
      "尽早看 Git 状态，不要到最后才检查。",
      "每次非小型改动后，都用编辑器做一次人工确认。",
      "每次升级后至少验证一个本地路径和一个远程路径。",
    ],
    briefingTitle: "怎样给 IMUX 下达任务，才能在 2 到 3 轮内进入执行",
    briefingIntro:
      "大多数启动缓慢的问题，并不是功能不够，而是目标太模糊。一个短而具体的任务简报，通常就足够让 IMUX 快速开工。",
    briefingChecklist: [
      "先说清楚具体仓库、目录或 SSH 目标。",
      "一次只讲当前最重要的一个结果，不要把多个无关目标塞在一起。",
      "如果你已经知道关键文件、命令或 URL，就直接指出来。",
      "用一句可衡量的话说明什么叫完成。",
      "下一轮只需要收紧范围或优先级，不需要把全部需求重新讲一遍。",
    ],
    troubleshootingTitle: "常见问题与恢复方式",
    troubleshootingIntro:
      "IMUX 出现卡顿、混乱或不可靠时，通常原因都在操作方式本身，而不是神秘错误。优先检查下面这些点。",
    troubleshooting: [
      {
        title: "SSH 连接像是卡住了",
        body:
          "大多数远程问题都来自认证未完成、SSH 配置不匹配，或者在连接尚未稳定前就开始浏览远程文件。",
        points: [
          "重新确认 SSH config 里的目标并干净重连。",
          "等终端明确出现远端 shell 状态后再使用远程资源管理器。",
          "如果仍然异常，先用普通 SSH 会话测试该目标。",
        ],
      },
      {
        title: "工作区显得很乱、不聚焦",
        body:
          "这通常意味着工作区目标过大，或者多个不相关路径与任务堆在了同一个操作面里。",
        points: [
          "把不相关任务拆成多个工作区。",
          "把当前目标压缩成一个明确结果。",
          "关闭不再参与当前决策链的文件和面板。",
        ],
      },
      {
        title: "监督器给出的下一步太空泛",
        body:
          "这往往意味着它缺少明确目标、最新文件证据，或者没有得到清晰的完成标准。",
        points: [
          "用一句话重述目标，并写明什么算完成。",
          "继续前先打开最相关的文件。",
          "把它重新指向当前仓库状态，而不是依赖旧对话记忆。",
        ],
      },
    ],
    updateTitle: "安全升级检查表",
    updateSteps: [
      "从 IMUX 官方网站下载最新 DMG。",
      "先正常退出当前应用，避免中途打断写入或活动会话。",
      "安装新构建后重新打开 IMUX，并在继续重要工作前核对 LLM 设置与 SSH 连接。",
      "如果资源管理器、监督器、文件编辑或路由行为有变化，先读升级日志再继续。",
    ],
    secondaryCta: "查看升级日志",
  },
  changelog: {
    section: "升级日志",
    metaTitle: "IMUX 升级日志",
    metaDescription:
      "查看 IMUX 的发布历史、官网更新、多语言扩展以及升级时需要核对的关键事项。",
    eyebrow: "升级日志",
    title: "记录每次变化、发布时间，以及升级后该核对什么。",
    intro:
      "这份页面是 IMUX 的公开发布记录。它追踪当前产品线、官网上线、多语言站点扩展，以及替换当前构建前应该检查的操作说明。",
    currentReleaseLabel: "当前发布线",
    currentReleaseBody:
      "IMUX 当前对外发布版本为 v1.5.2。这条稳定线会加固多工作区会话在关闭重开后的恢复行为，给最近任务完成后的黑色前面板路径补上显式恢复，并继续让网站与 GitHub 发布面围绕同一份安装包对齐。",
    releaseModelTitle: "应该怎么读 IMUX 的版本发布",
    releaseModelIntro:
      "把升级日志当成操作文档，而不仅仅是宣传页。好的发布记录应该帮助你判断是马上采用、先验证，还是等当前任务结束后再更新。",
    releaseModel: [
      {
        title: "1. 先把公开版本当作稳定线",
        body:
          "公开版本应该被视为可用于真实工作的稳定线。升级动作应该有节奏，而不是看到新构建就立即覆盖。",
        points: [
          "替换应用前先确认当前版本号。",
          "团队或项目集群尽量统一到同一批准构建。",
          "根据升级日志判断当前时机是否适合重要任务。",
        ],
      },
      {
        title: "2. 看影响面，不只看标题",
        body:
          "重点关注会改变操作面的内容，例如文件处理、SSH 行为、监督器流程、模型设置和打包行为。",
        points: [
          "优先看工作流变化，再看外观变化。",
          "确认远程行为、路由或设置持久化是否变化。",
          "把发布说明映射到你当前正在推进的任务上。",
        ],
      },
      {
        title: "3. 用一条干净路径做升级验证",
        body:
          "每次升级后，至少要在一个受控本地工作区和一个受控远程工作区中验证，确认无误后再作为默认日常版本。",
        points: [
          "打开一个本地仓库，确认编辑与保存正常。",
          "连接一台 SSH 主机，确认远程浏览符合预期。",
          "验证通过后，再把关键任务迁移到新版本。",
        ],
      },
    ],
    entriesTitle: "发布历史",
    entries: [
      {
        date: "2026年4月3日",
        version: "v1.5.2",
        title: "更稳的会话恢复与更强的黑屏恢复路径",
        body:
          "这个稳定版聚焦两条会直接破坏连续操作信任的问题: IMUX 关闭重开后恢复成更薄的面板集合，以及任务完成驱动的工作区切换后前面板偶发变黑。",
        bullets: [
          "会话持久化现在会保留更完整的稳定快照，并在最后一个主窗口关闭时强制落盘完整会话，所以重开 IMUX 时更不容易丢掉之前打开的对话面板和工作区面板。",
          "最近的轻量生命周期保存不再立刻覆盖更完整的近期稳定快照，这让多工作区场景下的关闭再打开恢复结果更可靠。",
          "通知驱动的工作区重排和焦点跳转现在会显式触发渲染恢复，降低任务完成事件后当前前面板偶发黑屏的概率。",
        ],
      },
      {
        date: "2026年4月3日",
        version: "v1.5.1",
        title: "远程工作区保留与 portal 恢复加固",
        body:
          "这个稳定版聚焦两条会直接打断操作的问题: SSH 最后一个终端退出后远程工作区被带着关闭，以及高频界面切换后终端偶发黑屏。",
        bullets: [
          "当远程 SSH 工作区中的最后一个终端因 child-exit 结束时，现在会保留该工作区，便于后续直接在原有远程上下文中重连。",
          "默认开启现有的短时 terminal portal 恢复路径，降低分栏变化、侧边栏切换和工作区切换期间出现黑屏的概率。",
          "把 `v1.5.1` 同步到公开发布面，让官网升级日志、下载端点和 GitHub 发布继续指向同一份当前安装包。",
        ],
      },
      {
        date: "2026年4月2日",
        version: "v1.5.0",
        title: "更紧凑的工作区界面与更干净的发布面",
        body:
          "这个稳定版继续收紧当前界面打磨，把主工作区做得更接近 VS Code 的密集布局，同时修正输入与侧边栏细节，并让安装包与网站发布面继续保持一致。",
        bullets: [
          "继续压缩活动栏、工作区列表和侧边栏头部，让主操作面更接近 VS Code 那种高密度布局。",
          "把终端启动欢迎区缩成简洁状态条，并修复文件检查器场景下右侧边栏宽度卡死的问题。",
          "把受影响的 macOS 输入法组合态回车转发收紧，并继续让 `v1.5.0` 的网站与 GitHub 发布链路围绕同一份安装包目标对齐。",
        ],
      },
      {
        date: "2026年4月1日",
        version: "v1.2.0",
        title: "面向直接覆盖升级的安装修复版本",
        body:
          "这个稳定版本专门处理桌面升级链路里最后一段阻塞点: 把从 DMG 或转移路径启动的运行中副本移入 Applications，平滑替换现有应用包，并从受支持路径重新拉起。",
        bullets: [
          "当 IMUX 从磁盘镜像、App Translocation 或其他不受支持位置启动时，新增一条“安装并重新启动”的修复路径。",
          "调整修复安装器逻辑，把 Applications 中已有的 IMUX 应用包视为预期替换目标，而不是把它当作阻断目录。",
          "扩展更新错误处理，让不兼容启动位置也能直接触发修复动作，而不是只停留在无效重试上。",
        ],
      },
      {
        date: "2026年4月1日",
        version: "v1.1.0",
        title: "产品身份加固与发布入口清理",
        body:
          "这个稳定版本继续清除活跃 IMUX 体验中残留的继承品牌影子，并把从官网到安装包再到支持入口的发布链路收紧成一条统一路径。",
        bullets: [
          "把应用、网站、文档以及多语言公开字符串中的旧仓库、旧公司和旧支持入口统一替换为当前 IMUX 自有发布面。",
          "重构社区、法务与反馈路径，让用户可见的联系与支持入口都表现为一套明确的 IMUX 产品存在，而不是带有二开痕迹的继承层。",
          "继续对齐打包后的桌面应用、官网升级日志文案和下载端点，让最新稳定安装包与公开说明始终指向同一条发布线。",
        ],
      },
      {
        date: "2026年3月31日",
        version: "v1.0.10",
        title: "交互可靠性修复与联动模式快速入口",
        body:
          "这个稳定版本优先修复用户最先接触到的交互问题，包括失焦后首击无响应、Claude + Codex 联动模式入口过深，以及官网发布线描述需要和安装包版本保持一致。",
        bullets: [
          "让主窗口宿主、标题栏控件宿主以及 Settings 类工具窗口都接受失焦后的第一次点击，避免按钮和开关需要点两次才触发。",
          "把 Claude + Codex 联动模式提升到标题栏快捷按钮和紧凑创建菜单中，并复用 AI Command Center 同一套工作区启动逻辑。",
          "同步调整官网发布文案，让首页、升级日志与用户实际下载到的稳定安装包版本保持一致。",
        ],
      },
      {
        date: "2026年3月31日",
        version: "v1.0.9",
        title: "品牌一致性清理与侧栏交互整合",
        body:
          "这个稳定版本集中完成了 IMUX 活跃站点面的品牌一致性清理，把文档与法务页面的发布入口对齐到当前仓库，并收敛了侧栏交互模型，避免工作区导航与工具面板互相打架。",
        bullets: [
          "把当前仍在使用的文档、法务、社区与多语言页面中的旧命名统一为 IMUX，同时保留历史博客与历史更新记录中的旧称呼作为档案信息。",
          "把活跃页面里的 GitHub 链接和发布下载入口统一到当前 IMUX 仓库与下载路径。",
          "调整侧栏行为，让左侧导航与右侧工具面板可同时工作，并在切换工作区时正确重置文件/远程编辑上下文。",
        ],
      },
      {
        date: "2026年3月31日",
        version: "v1.0.8",
        title: "安装包路径加固与发布产物校验",
        body:
          "这个稳定版本把 macOS 安装包链路进一步加固，让对外发布的 DMG 更接近标准的拖拽到 Applications 安装体验，同时发布流程会在上传前主动校验产物结构，而不再只是假定它是正确的。",
        bullets: [
          "把本地发布和 GitHub 发布统一到同一个 DMG 构建辅助脚本上，避免不同环境下产物行为漂移。",
          "新增发布时校验流程：自动挂载 DMG、检查 app bundle、验证 Applications 拖拽目标，并在安装包结构异常时直接阻止发布。",
          "继续保证官网、发布清单和 GitHub 资产始终指向同一个带版本号的安装包，让运维与用户看到的是同一条稳定真相源。",
        ],
      },
      {
        date: "2026年3月31日",
        version: "v1.0.7",
        title: "发布打包刷新、品牌资产统一，以及监督器布局加固",
        body:
          "这个稳定版本重新发布了 IMUX 的安装包，并把品牌化应用资源、官网下载路径，以及监督器侧栏中的长提示词展示统一到同一条发布线上。",
        bullets: [
          "通过统一的品牌资源生成器重建了 IMUX 应用图标、网站 logo、favicon 与 Apple touch icon，让应用和官网视觉保持一致。",
          "把稳定版下载统一到带版本号的安装包路径上，让 GitHub Releases、首页下载按钮和发布清单始终指向同一个 macOS 包。",
          "限制了监督器侧栏中长提示词卡片的展开高度，避免生成的任务包把窄侧栏或对话面板撑爆。",
        ],
      },
      {
        date: "2026年3月30日",
        version: "v1.0.5",
        title: "品牌细化、迁移快捷入口、协作能力与更新兼容性升级",
        body:
          "这是 IMUX 当前稳定线的持续优化更新，重点在于继续拉开品牌辨识度、降低从其他 AI 编码客户端迁移的成本、增强工作区内协作效率，并修复旧安装副本的更新兼容性问题。",
        bullets: [
          "替换了面向发布的图标、欢迎语和可见产品文案，让 IMUX 在应用与网站两侧都更统一、更有辨识度。",
          "新增 VS Code、Cursor、Claude Code、Codex 的快速导入入口。",
          "升级源码管理区和协作工具，让快速 pull、快速 push 以及多模型 pane 创建都能直接在 IMUX 的真实终端里完成。",
          "为磁盘镜像、App Translocation 和非 Applications 启动路径增加了明确的更新兼容性检查，让旧安装副本在升级失败前就能给出可执行的恢复提示。",
        ],
      },
      {
        date: "2026年3月26日",
        version: "v0.0.1",
        title: "文档与多语言官网扩展",
        body:
          "官方网站新增了完整使用说明、独立升级日志页面，并把公开营销层扩展到全部已路由语言。",
        bullets: [
          "新增 /guide 与 /changelog 独立页面。",
          "将官网语言覆盖扩展到全部营销路由语言。",
          "上线 IMUX 的实用设置说明、工作流说明与升级说明。",
        ],
      },
      {
        date: "2026年3月25日",
        version: "v0.0.1",
        title: "IMUX 官网正式上线",
        body:
          "公共站点切换到 IMUX 品牌与官方域名，并对齐下载地址、仓库地址、元信息和生产环境托管。",
        bullets: [
          "将 https://www.iccjk.com 上线为 IMUX 官方域名。",
          "标题、元信息、页脚、下载地址与仓库地址全部统一到 IMUX 品牌。",
          "将网站下载入口对接到 GitHub 上的 macOS 发布路径。",
        ],
      },
      {
        date: "2026年3月25日",
        version: "v0.0.1",
        title: "IMUX 首个公开产品基线",
        body:
          "首个公开版本围绕原生 macOS 指挥中心展开，核心是终端优先执行，以及围绕终端建立的一整套控制平面。",
        bullets: [
          "终端优先的工作区模型。",
          "本地与远程资源管理器，以及基于 SSH 的远程浏览能力。",
          "工作区内文件查看与编辑，以及源码状态可见性。",
          "面向多步骤任务组织的监督器执行流。",
        ],
      },
    ],
    upgradeTitle: "升级建议",
    upgradeSteps: [
      "安装新构建前，先看最新升级日志。",
      "尽量用最新 DMG 替换应用，不要混用多个不一致的应用副本。",
      "升级后重新检查 LLM 设置、SSH 行为和工作区假设。",
      "至少验证一个本地工作区和一个远程工作区，再迁移关键任务。",
    ],
    supportTitle: "如果升级后行为和预期不一致",
    supportBody:
      "如果升级后感觉不对劲，先回到使用说明重新核对预期工作流，再对照版本发布页确认变更点，并通过可复现步骤、路径和设置状态提交问题。",
    supportChecklistTitle: "提交有效问题时最好附带这些信息",
    supportChecklist: [
      "IMUX 版本号，以及问题属于本地、远程还是监督器相关。",
      "涉及的工作区路径或 SSH 目标。",
      "你的预期行为和实际行为分别是什么。",
      "一段可以稳定复现的点击、命令或提示词序列。",
      "如果问题和界面、远程连接或状态有关，附上截图或终端输出。",
    ],
    supportDownloadLabel: "稳定版 macOS 下载",
    supportAppcastLabel: "Sparkle 更新源",
    supportManifestLabel: "发布清单",
    supportRemoteManifestLabel: "远程助手清单",
    platformStatusTitle: "平台状态",
    platformStatusBody:
      "目前只有 macOS 提供正式桌面安装包。IMUX 当前是原生 AppKit/SwiftUI 客户端，因此 Windows 桌面安装包暂未发布。",
    secondaryCta: "查看使用说明",
  },
  shared: {
    viewReleases: "查看版本发布",
    backHome: "返回首页",
    reportIssue: "报告问题",
  },
};

const copy: Record<string, ProductPageCopy> = {
  en: englishCopy,
  "zh-CN": zhCnCopy,
};

export function getProductPagesCopy(locale?: string): ProductPageCopy {
  return copy[locale ?? "en"] ?? englishCopy;
}

export function getLocalizedProductPath(locale: string | undefined, slug: "guide" | "changelog") {
  if (!locale || locale === "en") {
    return `/${slug}`;
  }

  return `/${locale}/${slug}`;
}

export function buildLocalizedAlternates(locale: string | undefined, slug: "guide" | "changelog") {
  const languages = Object.fromEntries(
    marketingLocales.map((locale) => [
      locale,
      locale === "en" ? `${siteConfig.canonicalUrl}/${slug}` : `${siteConfig.canonicalUrl}/${locale}/${slug}`,
    ]),
  );
  const canonicalPath = getLocalizedProductPath(locale, slug);

  return {
    canonical: `${siteConfig.canonicalUrl}${canonicalPath}`,
    languages: {
      ...languages,
      "x-default": `${siteConfig.canonicalUrl}/${slug}`,
    },
  };
}
