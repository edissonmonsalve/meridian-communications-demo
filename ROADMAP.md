# Roadmap

This project is a permanent architecture lab, not a one-off — it's meant
to keep growing. Priorities below are ordered by what actually unblocks
the next thing, not by what's most interesting to build.

## Near-term (unblocks everything else)

- [ ] **Connect a Dev Hub and deploy to a Scratch Org** — the single
      blocker behind every item below. See
      `PORTFOLIO/deployment/README.md`.
- [ ] **Run the evidence capture script** (`scripts/capture-evidence.*`)
      once deployed — 18 screenshots + 2 short clips, mostly automated.
- [ ] **Fix the live Fiverr gig 1 title** — the current live listing
      includes an unverifiable "certified" claim; the corrected copy is
      already written in `MARKETING/Fiverr/gig-1-administration.md`.
      Highest-priority item in the whole roadmap, technically not even a
      "build" task — just needs to be pasted in.
- [ ] **Verify and fix the "Telecom" naming in the live Upwork portfolio**
      — see `MARKETING/Upwork/README.md`'s critical finding.

## Medium-term (once the org is live)

- [ ] Build the Experience Cloud site — the Scratch Org definition already
      enables the `Communities` feature; the site itself isn't built yet.
- [ ] Validate whether Einstein features are available on this org shape
      (documented as an honest gap, not yet empirically checked against a
      live org — see `ARCHITECTURE.md`'s Experience Cloud/Einstein/Data
      Cloud section).
- [ ] Confirm OmniStudio managed package licensing path and, if available,
      populate `PS_OmniStudio_Runtime` (currently an intentional empty
      placeholder).
- [ ] Publish the repository (make it public), apply the `MARKETING/GitHub/`
      changes, and update the CI badge URL in the root README once the
      real GitHub username/org is known.

## Longer-term (real growth, not required for the portfolio to "work")

- [ ] A small set of Apex classes with real unit tests, specifically to
      round out the "full-stack" story for roles that ask for it — see
      `PORTFOLIO/architecture/decision-log.md` for why the project is
      100% declarative today and what would justify adding code.
      **Only add this if evidence shows it's actually costing
      opportunities** — declarative-only is a real strength, not a gap to
      reflexively "fix."
- [ ] 1–2 Lightning Web Components, if the same evidence above supports it.
- [ ] A second fictional vertical (explicitly a new, unrelated company —
      not an extension of Meridian) to demonstrate the same rigor applied
      to a different industry, once Meridian itself has real engagement
      data (views, interview mentions) to justify the time.
- [ ] Multi-package split (`meridian-core` / `meridian-fulfillment` /
      `meridian-billing` / `meridian-support`) — only once a real reason to
      split appears; see `PORTFOLIO/deployment/packaging.md` for the
      documented trigger conditions.

## Explicitly not planned

- Turning this into an installable managed package or AppExchange listing
  — out of scope for a portfolio project, would add packaging overhead
  with no audience.
- Adding real client data or references at any point, ever, regardless of
  how the project evolves.

See `MARKETING/growth-plan-6-months.md` for the business-side roadmap
(reviews, contracts, reputation) this technical roadmap supports.
