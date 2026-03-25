"use client";

import { DownloadButton } from "./download-button";
import { ThemeToggle } from "../theme";
import { GitHubStarsBadge } from "./github-stars";
import {
  useMobileDrawer,
  MobileDrawerOverlay,
  MobileDrawerToggle,
} from "./mobile-drawer";
import { siteConfig } from "../../site-config";

export function SiteHeader({
  section,
  hideLogo,
}: {
  section?: string;
  hideLogo?: boolean;
}) {
  const { open, toggle, close, drawerRef, buttonRef } = useMobileDrawer();

  return (
    <>
      <header className="sticky top-0 z-30 w-full border-b border-border/60 bg-background/88 backdrop-blur-xl">
        <div className="w-full max-w-6xl mx-auto flex items-center px-6 h-14">
          {/* Left: logo + section */}
          <div className="flex flex-1 items-center gap-3 min-w-0">
            {!hideLogo && (
              <>
                <a href="/" className="flex items-center gap-3">
                  <img
                    src="/logo.png"
                    alt={siteConfig.name}
                    width={28}
                    height={28}
                    className="rounded-lg"
                  />
                  <div className="flex flex-col leading-none">
                    <span className="text-sm font-semibold tracking-tight">
                      {siteConfig.name}
                    </span>
                    <span className="text-[11px] text-muted">
                      {siteConfig.descriptor}
                    </span>
                  </div>
                </a>
                {section && (
                  <>
                    <span className="text-border text-[13px]">/</span>
                    <span className="text-[13px] text-muted">{section}</span>
                  </>
                )}
              </>
            )}
          </div>

          {/* Center: nav links */}
          <nav className="hidden md:flex items-center justify-center gap-5 text-sm text-muted shrink-0">
            <a href="#capabilities" className="hover:text-foreground transition-colors">
              Capabilities
            </a>
            <a href="#workflow" className="hover:text-foreground transition-colors">
              Workflow
            </a>
            <a href="#faq" className="hover:text-foreground transition-colors">
              FAQ
            </a>
            <a
              href={siteConfig.repoUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-foreground transition-colors"
            >
              GitHub
            </a>
          </nav>

          {/* Right: GitHub stars + Download + theme + mobile */}
          <div className="flex flex-1 items-center justify-end gap-3 min-w-0">
            <GitHubStarsBadge />
            <div className="hidden md:block">
              <DownloadButton size="sm" location="navbar" />
            </div>
            <ThemeToggle />
            <MobileDrawerToggle
              open={open}
              onClick={toggle}
              buttonRef={buttonRef}
            />
          </div>
        </div>
      </header>

      {/* Mobile overlay + drawer */}
      <MobileDrawerOverlay open={open} onClose={close} />
      <nav
        ref={drawerRef}
        role="navigation"
        aria-label="Main navigation"
        className={`fixed inset-y-0 right-0 z-50 w-56 bg-background border-l border-border overflow-y-auto transition-transform md:hidden ${
          open ? "translate-x-0" : "translate-x-full invisible"
        }`}
      >
        <div className="flex items-center justify-end gap-1 px-4 h-12">
          <ThemeToggle />
          <button
            onClick={close}
            className="w-8 h-8 flex items-center justify-center text-muted hover:text-foreground transition-colors"
            aria-label="Close menu"
          >
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              aria-hidden="true"
            >
              <path d="M18 6L6 18M6 6l12 12" />
            </svg>
          </button>
        </div>

        <div className="flex flex-col gap-3 text-sm text-muted px-4 pb-4">
          <a href="#capabilities" onClick={close} className="hover:text-foreground transition-colors py-1">
            Capabilities
          </a>
          <a href="#workflow" onClick={close} className="hover:text-foreground transition-colors py-1">
            Workflow
          </a>
          <a href="#faq" onClick={close} className="hover:text-foreground transition-colors py-1">
            FAQ
          </a>
          <a
            href={siteConfig.repoUrl}
            target="_blank"
            rel="noopener noreferrer"
            onClick={close}
            className="hover:text-foreground transition-colors py-1"
          >
            GitHub
          </a>
          <GitHubStarsBadge location="mobile_drawer" />
          <div className="pt-2">
            <DownloadButton size="sm" location="mobile_drawer" />
          </div>
        </div>
      </nav>
    </>
  );
}
