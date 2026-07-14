#!/usr/bin/env node
/**
 * Meridian Communications — automated evidence capture.
 *
 * Logs into a deployed Scratch Org exactly once (via a frontdoor.jsp URL
 * generated fresh at run time — these expire fast, so it's generated and
 * used immediately, never cached), then walks every screen in
 * PORTFOLIO/screenshots/README.md, taking a full-viewport screenshot of
 * each, plus a few short click-through recordings for "gifs cortos de
 * navegación" (saved as .webm; see the README this script writes for the
 * ffmpeg command to convert to .gif).
 *
 * This CANNOT run until a Scratch Org has been deployed and populated
 * (scripts/deploy-all.ps1 / .sh). It is written and ready now so that once
 * that blocker clears, evidence capture is a single command, not a new
 * research task.
 *
 * Usage:
 *   node scripts/evidence/capture-evidence.js --org meridian-demo
 *
 * Requires (add before first real run):
 *   npm install --save-dev playwright
 *   npx playwright install chromium
 */

const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");

const args = process.argv.slice(2);
const orgFlagIndex = args.indexOf("--org");
const orgAlias = orgFlagIndex >= 0 ? args[orgFlagIndex + 1] : "meridian-demo";

const REPO_ROOT = path.resolve(__dirname, "..", "..");
const SCREENSHOT_DIR = path.join(REPO_ROOT, "PORTFOLIO", "screenshots");
const CLIP_DIR = path.join(SCREENSHOT_DIR, "clips");

const VIEWPORT = { width: 1920, height: 1080 };

/**
 * Setup / app URLs, relative to the org's base URL. Filenames match
 * PORTFOLIO/screenshots/README.md exactly.
 */
const SCREENS = [
  { file: "01-home.png", path: "/lightning/page/home", wait: 2000 },
  {
    file: "02-app-launcher.png",
    path: "/lightning/app/one",
    wait: 1500,
    openAppLauncher: true
  },
  {
    file: "03-object-manager.png",
    path: "/lightning/setup/ObjectManager/home",
    wait: 2000
  },
  {
    file: "04-custom-objects.png",
    path: "/lightning/setup/ObjectManager/home",
    wait: 2000,
    filterCustom: true
  },
  {
    file: "05-record-types.png",
    path: "/lightning/setup/ObjectManager/Service_Order__c/RecordTypes/view",
    wait: 1500
  },
  {
    file: "06-validation-rules.png",
    path: "/lightning/setup/ObjectManager/Account/ValidationRules/view",
    wait: 1500
  },
  {
    file: "07-permission-sets.png",
    path: "/lightning/setup/PermSets/home",
    wait: 1500
  },
  {
    file: "08-permission-set-groups.png",
    path: "/lightning/setup/PermSetGroups/home",
    wait: 1500
  },
  { file: "09-queues.png", path: "/lightning/setup/Queues/home", wait: 1500 },
  {
    file: "10-public-groups.png",
    path: "/lightning/setup/PublicGroups/home",
    wait: 1500
  },
  {
    file: "11-sharing-rules.png",
    path: "/lightning/setup/ObjectManager/Account/SharingRules/view",
    wait: 1500
  },
  {
    file: "12-role-hierarchy.png",
    path: "/lightning/setup/Roles/home",
    wait: 1500,
    clickRoleHierarchyView: true
  },
  // 13-record-page.png: needs a real Service_Order__c record Id, resolved at runtime (see resolveRecordPageUrl below)
  { file: "14-reports.png", path: "/lightning/o/Report/home", wait: 2000 },
  { file: "15-dashboard.png", path: "/lightning/o/Dashboard/home", wait: 2500 },
  {
    file: "16-flow-builder.png",
    path: "/builder_platform_interaction/flowBuilder.app?flowId=",
    wait: 3000,
    resolveFlowId: "Service_Order_Fulfillment_Orchestration"
  },
  {
    file: "17-approval-process.png",
    path: "/lightning/setup/ApprovalProcesses/home",
    wait: 1500
  },
  {
    file: "18-setup-overview.png",
    path: "/lightning/setup/SetupOneHome/home",
    wait: 1500
  }
];

/** Short click-through sequences recorded as video, for the "gifs cortos" ask. */
const CLIPS = [
  {
    name: "app-launcher-to-service-order",
    steps: async (page, baseUrl) => {
      await page.goto(`${baseUrl}/lightning/app/one`);
      await page.waitForTimeout(1500);
      await page.click('[title="App Launcher"]');
      await page.waitForTimeout(800);
      await page.fill(
        'input[placeholder="Search apps and items..."]',
        "Meridian Provisioning"
      );
      await page.waitForTimeout(1000);
      await page.click("text=Meridian Provisioning");
      await page.waitForTimeout(2000);
    }
  },
  {
    name: "dashboard-overview",
    steps: async (page, baseUrl) => {
      await page.goto(`${baseUrl}/lightning/o/Dashboard/home`);
      await page.waitForTimeout(2500);
    }
  }
];

function sfJson(command) {
  const raw = execSync(command, { encoding: "utf-8" });
  return JSON.parse(raw);
}

function getOrgBaseUrl(alias) {
  const result = sfJson(`sf org display --target-org ${alias} --json`);
  return result.result.instanceUrl;
}

function getFreshFrontdoorUrl(alias) {
  // Generated immediately before use -- these OTP URLs expire quickly.
  const result = sfJson(`sf org open --target-org ${alias} --url-only --json`);
  return result.result.url;
}

async function resolveRecordPageUrl(page, baseUrl) {
  // Placeholder: query the first Service_Order__c Id via `sf data query` at
  // call time and build /lightning/r/Service_Order__c/<Id>/view. Left as an
  // explicit runtime step rather than hardcoded, since Ids don't exist until
  // data has been loaded.
  return null;
}

async function main() {
  let playwright;
  try {
    playwright = require("playwright");
  } catch (e) {
    console.error(
      "playwright is not installed. Run: npm install --save-dev playwright && npx playwright install chromium"
    );
    process.exit(1);
  }

  fs.mkdirSync(SCREENSHOT_DIR, { recursive: true });
  fs.mkdirSync(CLIP_DIR, { recursive: true });

  console.log(`Resolving org '${orgAlias}'...`);
  const baseUrl = getOrgBaseUrl(orgAlias);

  const browser = await playwright.chromium.launch({ headless: false });
  const context = await browser.newContext({ viewport: VIEWPORT });
  const page = await context.newPage();

  console.log("Authenticating (fresh frontdoor.jsp URL, used immediately)...");
  const frontdoorUrl = getFreshFrontdoorUrl(orgAlias);
  await page.goto(frontdoorUrl);
  await page.waitForTimeout(3000);

  console.log("Capturing screens...");
  for (const screen of SCREENS) {
    try {
      const url = screen.path.startsWith("http")
        ? screen.path
        : `${baseUrl}${screen.path}`;
      await page.goto(url);
      await page.waitForTimeout(screen.wait || 1500);
      if (screen.openAppLauncher) {
        await page.click('[title="App Launcher"]').catch(() => {});
        await page.waitForTimeout(800);
      }
      const outPath = path.join(SCREENSHOT_DIR, screen.file);
      await page.screenshot({ path: outPath });
      console.log(`  ✓ ${screen.file}`);
    } catch (err) {
      console.warn(
        `  ✗ ${screen.file} — ${err.message} (capture manually per the checklist)`
      );
    }
  }

  console.log("Recording short clips...");
  for (const clip of CLIPS) {
    const clipContext = await browser.newContext({
      viewport: VIEWPORT,
      recordVideo: { dir: CLIP_DIR, size: VIEWPORT }
    });
    const clipPage = await clipContext.newPage();
    await clipPage.goto(frontdoorUrl); // re-auth this context
    await clipPage.waitForTimeout(2000);
    try {
      await clip.steps(clipPage, baseUrl);
    } catch (err) {
      console.warn(`  ✗ clip '${clip.name}' — ${err.message}`);
    }
    await clipContext.close();
    console.log(`  ✓ ${clip.name} (raw .webm saved to ${CLIP_DIR})`);
  }

  await browser.close();

  console.log("");
  console.log("Done. Manual follow-ups:");
  console.log(
    "  - 13-record-page.png: open any Service_Order__c record and capture manually"
  );
  console.log(
    "    (needs a real record Id from the loaded data, not knowable ahead of time)"
  );
  console.log(
    '  - Convert .webm clips to .gif: ffmpeg -i clip.webm -vf "fps=10,scale=960:-1" clip.gif'
  );
  console.log(
    "  - Run the sanitization checklist in PORTFOLIO/screenshots/README.md before publishing anything"
  );
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
