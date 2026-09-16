/* ============================================================
   EDIT ME — your links go here
   ============================================================ */
const CONFIG = {
  discord: "https://discord.gg/t4PXSPk949",       // Iconic Rig Discord
  tiktok:  "https://www.tiktok.com/@bloxyield",   // TikTok
  youtube: "https://www.youtube.com/@Crwths",     // YouTube
};

/* ============================================================
   EDIT ME — your mods. 4 × 100M in-game, 1 free.
   ------------------------------------------------------------
   name:    mod title
   desc:    short description
   tags:    small labels (version, loader, feature...)
   price:   in-game price shown on the card (e.g. "100M"), or null = FREE
   link:    a direct download URL, or null to arrange it via Discord
   hot:     true = amber "Most Popular" tag
   image:   icon file in images/mods/ (shown centered, pixel-perfect)
   glow:    light colour above the icon, e.g. "rgba(74, 222, 128, 0.4)"
   stripeA / stripeB: the two colours of the lines behind the icon
   anim:    mod icons bob up and down by default. "shake" = wobble, "none" = still
   ============================================================ */
const MODS = [
  {
    name: "Gambling Rig",
    desc: "Rig your gambling in-game — 50/50, 45/45/10, blackjack, paper and piko, all faked live.",
    tags: ["Fabric", "1.21.1"],
    price: null,
    link: "downloads/IconicRig.jar", // direct download (file lives in downloads/)
    hot: true,
    image: "images/mods/gambling-rig.png",
    glow: "rgba(226, 57, 62, 0.42)", // red light
    stripeA: "#2a0a0c",
    stripeB: "#4a1216",
  },
  {
    name: "Skeleton Spawners",
    desc: "Turns glass into skeleton spawners — place one and the mobs start spawning live.",
    tags: ["Fabric", "1.21.11"],
    price: "100M",
    link: null, // null = buy via Discord
    hot: false,
    image: "images/mods/skeleton-spawner.png",
    glow: "rgba(74, 222, 128, 0.4)", // green light
    stripeA: "#06231e",
    stripeB: "#0b3f33",
  },
  {
    name: "Paymod",
    desc: "Change how your in-game balance looks — pay people or get paid and it updates live.",
    tags: ["Fabric", "1.21.11"],
    price: "100M",
    link: null,
    hot: false,
    image: "images/mods/paymod.png",
    glow: "rgba(255, 214, 64, 0.42)", // gold light
    stripeA: "#2a1c02",
    stripeB: "#48340a",
  },
  {
    name: "Media Mod",
    desc: "Media-styled name and rank displays so every clip looks official.",
    tags: ["Fabric", "1.21.11"],
    price: "100M",
    link: null,
    hot: false,
    image: "images/mods/media-mod.png",
    glow: "rgba(255, 122, 194, 0.42)", // pink light
    stripeA: "#2a0f22",
    stripeB: "#4a1a3c",
  },
  {
    name: "Elytra Mod",
    desc: "Real elytra physics with a chestplate on — fly like vanilla intended.",
    tags: ["Fabric", "1.21.11"],
    price: "100M",
    link: null,
    hot: false,
    image: "images/mods/elytra-mod.png",
    glow: "rgba(78, 168, 255, 0.42)", // blue light
    stripeA: "#08192e",
    stripeB: "#0f2f52",
  },
];

/* ============================================================
   EDIT ME — your 9 texture packs
   ------------------------------------------------------------
   name:     pack title
   platform: "Java" (or "Bedrock")
   image:    pixel icon in images/packs/
   changes:  the bullet list behind "What it changes"
   file:     the filename this pack's download will live at inside the
             downloads/ folder. Drop the file in and the Download pill goes
             live by itself — nothing to edit.
   link:     OR paste a direct URL (MediaFire, Drive, Discord upload...) in
             link: "" — an external URL always wins over file:. With neither,
             the pill stays greyed out instead of giving anyone a dead link.
   ============================================================ */
const PACKS = [
  {
    name: "Green Glass to Spawner",
    platform: "Java",
    image: "images/packs/green-glass-spawner.png",
    file: "downloads/green-glass-spawner.zip",
    changes: [
      "Green stained glass reads as a spawner",
      "Works in the inventory, in hand and placed",
    ],
    link: "", // ← paste direct download link here
  },
  {
    name: "Shears to Elytra",
    platform: "Java",
    image: "images/packs/shears-elytra.png",
    file: "downloads/shears-to-elytra.zip",
    changes: [
      "Shears read as a worn elytra",
      "Handles stay red so you can still spot them",
    ],
    link: "", // ← paste direct download link here
  },
  {
    name: "Lootdrop Megapack",
    platform: "Java",
    image: "images/packs/lootdrop-megapack.png",
    file: "downloads/lootdrop-megapack.zip",
    changes: [
      "Loot stacks read as gold bars",
      "Built for recording drop videos",
    ],
    link: "", // ← paste direct download link here
  },
  {
    name: "Netherite Mega Pack",
    platform: "Java",
    image: "images/packs/netherite-megapack.png",
    file: "downloads/netherite-mega-pack.zip",
    changes: [
      "Diamond armour reads as netherite",
      "Diamond tools read as netherite",
      "Wear the diamond set for the full effect",
    ],
    link: "", // ← paste direct download link here
  },
  {
    name: "Stained Glass to Lantern and Beacon",
    platform: "Java",
    image: "images/packs/stained-glass-lantern.png",
    file: "downloads/stained-glass-to-lantern-and-beacon.zip",
    changes: [
      "Stained glass reads as lanterns",
      "Stained glass reads as beacons",
    ],
    link: "", // ← paste direct download link here
  },
  {
    name: "Deepslate Bricks to Gilded Blackstone",
    platform: "Java",
    image: "images/packs/deepslate-gilded.png",
    file: "downloads/deepslate-bricks-to-gilded-blackstone.zip",
    changes: [
      "Deepslate bricks read as gilded blackstone",
      "Cleaner look for your base",
    ],
    link: "", // ← paste direct download link here
  },
  {
    name: "Orange Dye to Netherite Ingot",
    platform: "Java",
    image: "images/packs/orange-dye-ingot.png",
    file: "downloads/orange-dye-to-netherite-ingot.zip",
    changes: [
      "Orange dye reads as netherite ingots",
      "Fill a barrel and it looks like a stack of ingots",
    ],
    link: "", // ← paste direct download link here
  },
  {
    name: "Crystal Optimizer",
    platform: "Java",
    image: "images/packs/crystal-optimizer.png",
    file: "downloads/crystal-optimizer.zip",
    changes: [
      "Cleaner crystal PvP",
      "Leaner crystal and anchor textures",
    ],
    link: "", // ← paste direct download link here
  },
  {
    name: "Anti Block Rotation",
    platform: "Java",
    image: "images/packs/anti-block-rotation.png",
    file: "downloads/anti-block-rotation.zip",
    changes: [
      "Stops leaked bases looking obvious",
      "Blocks keep the rotation you set",
    ],
    link: "", // ← paste direct download link here
  },
];

/* ============================================================
   Wiring — no need to touch below this line
   ============================================================ */

// Point every social link at the real URL.
document.querySelectorAll("[data-discord]").forEach(a => { a.href = CONFIG.discord; });
document.querySelectorAll("[data-tiktok]").forEach(a => { a.href = CONFIG.tiktok; });
document.querySelectorAll("[data-youtube]").forEach(a => { a.href = CONFIG.youtube; });

const ICON_DOWNLOAD = '<svg class="ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 3v12m0 0 4-4m-4 4-4-4M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2"/></svg>';
const ICON_DISCORD  = '<svg class="ico" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M20.3 4.4A19.8 19.8 0 0 0 15.4 3c-.2.4-.5 1-.6 1.4a18.3 18.3 0 0 0-5.5 0C9.1 4 8.8 3.4 8.6 3a19.7 19.7 0 0 0-4.9 1.5A20.4 20.4 0 0 0 .2 18.1a19.9 19.9 0 0 0 6 3c.5-.6.9-1.3 1.3-2-.7-.3-1.4-.6-2-1l.5-.4a14.2 14.2 0 0 0 12.2 0l.5.4c-.7.4-1.3.7-2 1 .4.7.8 1.4 1.3 2a19.8 19.8 0 0 0 6-3A20.3 20.3 0 0 0 20.3 4.4ZM8.7 15.3c-1.2 0-2.2-1.1-2.2-2.4s1-2.4 2.2-2.4 2.2 1.1 2.2 2.4-1 2.4-2.2 2.4Zm6.6 0c-1.2 0-2.2-1.1-2.2-2.4s1-2.4 2.2-2.4 2.2 1.1 2.2 2.4-1 2.4-2.2 2.4Z"/></svg>';

const MOD_ICON = '<svg class="media-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="3" width="7.5" height="7.5" rx="1.5"/><rect x="13.5" y="3" width="7.5" height="7.5" rx="1.5"/><rect x="3" y="13.5" width="7.5" height="7.5" rx="1.5"/><path d="M17.25 14v6.5M14 17.25h6.5"/></svg>';
const PACK_ICON = '<svg class="media-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M21 8.2 12 3 3 8.2v7.6L12 21l9-5.2V8.2Z"/><path d="M3.3 8.3 12 13l8.7-4.7M12 13v8"/></svg>';

function tagsHtml(item) {
  let html = "";
  if (item.hot) html += '<span class="tag tag-hot">★ Most Popular</span>';
  if (item.platforms) item.platforms.forEach(p => { html += `<span class="tag">${p}</span>`; });
  if (item.tags) item.tags.forEach(t => { html += `<span class="tag">${t}</span>`; });
  return `<div class="card-tags">${html}</div>`;
}

function discordBtn(label) {
  return `<a class="get-btn" href="${CONFIG.discord}" target="_blank" rel="noopener">${ICON_DISCORD} ${label}</a>`;
}

function footHtml(item) {
  const isFree = !item.price;
  const label = isFree
    ? '<span class="free">FREE</span>'
    : `<div class="price-wrap"><span class="price">${item.price}</span><span class="price-note">in-game</span></div>`;
  const discordLabel = isFree ? "Get on Discord" : "Buy on Discord";
  let btn;
  if (item.link) {
    // A self-hosted file (downloads/...) is probed on load: until the file is
    // actually there the card hands you the Discord button instead of a 404.
    const attrs = isLocalLink(item.link)
      ? ` data-file="${item.link}" data-dl-label="${discordLabel}"`
      : "";
    btn = `<a class="get-btn" href="${item.link}" download${attrs}>${ICON_DOWNLOAD} Download</a>`;
  } else {
    btn = discordBtn(discordLabel);
  }
  return `<div class="card-foot">${label}${btn}</div>`;
}

function cardHtml(item, kind) {
  // Image handling: photo previews fill the media box; square icons get the
  // zebra backdrop (stripes + soft light + centered icon).
  // Every mod icon bobs by default; override with anim: "shake" or "none".
  const animKind = item.anim === "none" ? "" : (item.anim || (kind === "mod" ? "bob" : ""));
  const animCls = animKind === "bob" ? " anim-bob" : animKind === "shake" ? " anim-shake" : "";
  let media = '';
  if (item.image) {
    if (kind === "mod") {
      media = `<img class="mod-icon${animCls}" src="${item.image}" alt="${item.name}" loading="lazy" />`;
    } else {
      media = `<img src="${item.image}" alt="${item.name}" loading="lazy" />`;
    }
  } else {
    media = (kind === "mod" ? MOD_ICON : PACK_ICON);
  }
  // Per-card theme: light color (--glow) and stripe colors (--stripe-a/b).
  const vars = [];
  if (item.glow) vars.push(`--glow: ${item.glow}`);
  if (item.stripeA) vars.push(`--stripe-a: ${item.stripeA}`);
  if (item.stripeB) vars.push(`--stripe-b: ${item.stripeB}`);
  const glowVar = vars.length ? ` style="${vars.join("; ")}"` : "";
  const mediaTag = item.platforms
    ? item.platforms[0]
    : (item.tags && item.tags[0]) || (kind === "mod" ? "Fabric" : "Pack");
  return `
  <article class="card${item.hot ? " hot-card" : ""}">
    <div class="card-media${kind === "mod" ? " zebra" : ""}${animKind ? " pulse" : ""}"${glowVar}><span class="media-tag">${mediaTag}</span>${media}</div>
    <div class="card-body">
      <h3 class="card-title">${item.name}</h3>
      <p class="card-desc">${item.desc}</p>
      ${tagsHtml(item)}
    </div>
    ${footHtml(item)}
  </article>`;
}

// Texture pack card: centred pixel icon, "What it changes" expander,
// platform label and a Download pill.
// --- downloads --------------------------------------------------------------
// A card's download has two routes: paste a direct URL in link:, or host the
// file yourself in downloads/ (route two needs no editing at all — the page
// checks for the file on load and swaps the greyed pill for a live button).
const slug = s => s.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");
const isLocalLink = u => typeof u === "string" && u.length > 0 && !/^(https?:)?\/\//i.test(u);

async function fileExists(url) {
  if (!/^https?:$/.test(location.protocol)) return false; // opened straight off disk
  try {
    const r = await fetch(url, { method: "HEAD", cache: "no-store" });
    return r.ok;
  } catch {
    return false;
  }
}

function nodeFromHtml(html) {
  const t = document.createElement("template");
  t.innerHTML = html.trim();
  return t.content.firstElementChild;
}

function packDownloadHtml(item) {
  if (item.link && !isLocalLink(item.link)) return `<a class="dl-btn" href="${item.link}" download>Download</a>`;
  const file = item.link || item.file || `downloads/${slug(item.name)}.zip`;
  const name = file.split("/").pop();
  return `<span class="dl-btn pending" data-file="${file}" data-pack="1"`
    + ` title="Goes live as soon as ${name} is in the downloads folder — or paste a direct link in main.js">Download</span>`;
}

// Swap every placeholder whose file really exists for a working download.
async function activateLocalDownloads() {
  const els = [...document.querySelectorAll("[data-file]")];
  if (!els.length) return;
  const checked = await Promise.all(els.map(async el => ({ el, ok: await fileExists(el.getAttribute("data-file")) })));
  checked.forEach(({ el, ok }) => {
    const file = el.getAttribute("data-file");
    if (ok) {
      const a = document.createElement("a");
      a.className = el.dataset.pack ? "dl-btn" : "get-btn";
      a.href = file;
      a.setAttribute("download", "");
      a.innerHTML = el.dataset.pack ? "Download" : `${ICON_DOWNLOAD} Download`;
      el.replaceWith(a);
    } else if (el.dataset.dlLabel) {
      // Mod with a self-hosted link but no file yet — send them to Discord.
      el.replaceWith(nodeFromHtml(discordBtn(el.dataset.dlLabel)));
    }
  });
}

const ICON_CHEVRON = '<svg class="chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg>';

function packCardHtml(item) {
  const icon = item.image
    ? `<img class="pack-icon" src="${item.image}" alt="${item.name}" loading="lazy" />`
    : PACK_ICON;
  const bullets = (item.changes || []).map(c => `<li>${c}</li>`).join("");
  const changes = bullets
    ? `<details class="changes"><summary>What it changes ${ICON_CHEVRON}</summary><ul>${bullets}</ul></details>`
    : "";
  const download = packDownloadHtml(item);
  return `
  <article class="card pack-card">
    <div class="pack-top">${icon}</div>
    <h3 class="card-title">${item.name}</h3>
    ${changes}
    <div class="pack-foot">
      <span class="platform">${item.platform || "Java"}</span>
      ${download}
    </div>
  </article>`;
}

// Render cards if this page has a grid.
// Anything marked hot: true ("Most Popular") always renders first.
const byHot = (a, b) => (b.hot ? 1 : 0) - (a.hot ? 1 : 0);

const modsGrid = document.getElementById("modsGrid");
if (modsGrid) modsGrid.innerHTML = [...MODS].sort(byHot).map(m => cardHtml(m, "mod")).join("");

const packsGrid = document.getElementById("packsGrid");
if (packsGrid) packsGrid.innerHTML = PACKS.map(packCardHtml).join("");

// Any download file already sitting in downloads/ goes live right away.
activateLocalDownloads();

// Fill the home directory tile counts.
const packsMeta = document.getElementById("packsMeta");
if (packsMeta) packsMeta.innerHTML = `<span class="tag">${PACKS.length} packs</span><span class="tag">Java</span><span class="tag">Free</span>`;
const modsMeta = document.getElementById("modsMeta");
if (modsMeta) {
  const freeMods = MODS.filter(m => !m.price).length;
  modsMeta.innerHTML = `<span class="tag">${MODS.length} mods</span><span class="tag">${freeMods} free</span><span class="tag">Fabric</span>`;
}

/* ============================================================
   Download cooldown
   One download per visitor per 10 seconds, so nobody can sit
   there hammering the packs. Every download button on the page
   locks together, and the lock survives a reload or a page
   change (it's stored per tab), so it can't be skipped by
   refreshing.
   ============================================================ */
const DL_COOLDOWN_MS = 10000;
const DL_KEY = "iconicrig-download-unlock";
let dlTick = null;

// sessionStorage throws in some file:// setups, so fall back to memory.
const store = (() => {
  try {
    sessionStorage.setItem(DL_KEY + ":probe", "1");
    sessionStorage.removeItem(DL_KEY + ":probe");
    return sessionStorage;
  } catch {
    const mem = {};
    return { getItem: k => (k in mem ? mem[k] : null), setItem: (k, v) => { mem[k] = v; } };
  }
})();

const dlLockedFor = () => Math.max(0, (Number(store.getItem(DL_KEY)) || 0) - Date.now());
const dlLinks = () => [...document.querySelectorAll("a[download]")];

function paintDlLock() {
  const left = dlLockedFor();
  const cooling = left > 0;
  dlLinks().forEach(a => {
    a.classList.toggle("cooling", cooling);
    if (cooling) {
      a.dataset.cool = Math.ceil(left / 1000) + "s";
      a.setAttribute("aria-disabled", "true");
    } else {
      delete a.dataset.cool;
      a.removeAttribute("aria-disabled");
    }
  });
  // Nothing left to count: stop the ticker so it doesn't run forever.
  if (!cooling && dlTick) { clearInterval(dlTick); dlTick = null; }
}

function syncDlLock() {
  paintDlLock();
  if (dlLockedFor() > 0 && !dlTick) dlTick = setInterval(paintDlLock, 200);
}

function startDlCooldown() {
  store.setItem(DL_KEY, String(Date.now() + DL_COOLDOWN_MS));
  syncDlLock();
}

// Capture phase, so the click is stopped before the browser starts the download.
document.addEventListener("click", e => {
  const link = e.target.closest ? e.target.closest("a[download]") : null;
  if (!link) return;
  if (dlLockedFor() > 0) {
    e.preventDefault();
    return;
  }
  startDlCooldown();
}, true);

// Pick up a cooldown that was already running before this page loaded.
syncDlLock();

// Mobile nav.
const toggle = document.getElementById("navToggle");
const nav = document.getElementById("nav");
if (toggle && nav) {
  toggle.addEventListener("click", () => {
    const open = nav.classList.toggle("open");
    toggle.classList.toggle("open", open);
    toggle.setAttribute("aria-expanded", String(open));
  });
}
