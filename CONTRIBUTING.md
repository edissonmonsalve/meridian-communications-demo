# Contributing

This is a personal portfolio project, not an open-source project soliciting
external contributions — it exists to demonstrate one person's
architecture decisions, and outside pull requests would dilute that
purpose rather than improve it. Issues pointing out real bugs or metadata
errors are genuinely welcome, though; if something doesn't deploy or a
diagram is wrong, opening an issue is the fastest way to get it looked at.

## If you want to build your own version

Fork it. That's the intended use — the [MIT license](LICENSE) means the
patterns here (data model design, security architecture, declarative
automation) are free to reuse for your own portfolio or real project. A
few suggestions if you do:

1. **Don't keep "Meridian Communications" or any of its fictional
   details** — invent your own company, your own object names, your own
   data. The value of this project is the _patterns_, not the specific
   fictional company; a fork that's obviously just a renamed copy reads
   worse than an original built with the same rigor.
2. **Keep the non-negotiable rule that made this project possible**: never
   derive object names, data, or metadata from real client or employer
   work, no matter how minor it seems. See
   [ARCHITECTURE.md](ARCHITECTURE.md)'s "Non-negotiable ground rules"
   section for the full reasoning.
3. **Write your own decision log as you build**, not after — see
   [PORTFOLIO/architecture/decision-log.md](PORTFOLIO/architecture/decision-log.md)
   for the format. The reasoning-at-the-time is what makes it useful in an
   interview; a decision log reconstructed from memory after the fact
   tends to smooth over what actually happened.

## Reporting a real issue

Open a GitHub issue with:

- What you ran (`sf project deploy start`, a specific Apex script, etc.)
- The exact error message
- Which file it points to

Metadata issues are genuinely useful reports — this project hasn't been
deploy-tested against a live org yet (see
[PORTFOLIO/deployment/README.md](PORTFOLIO/deployment/README.md#known-risk-areas-on-first-deploy)),
so real deployment errors are expected and worth documenting even if they
don't get fixed immediately.
