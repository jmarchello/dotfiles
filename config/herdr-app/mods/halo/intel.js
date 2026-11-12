import { div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { agents, focused, exec, home, notify, run, setShared, shared } from "herdr";
import { HUD, BODY, stored, store, section } from "./hud.js";

const SCAN_EVERY = 10000;
const SCAN_ALL_EVERY = 20000;
const FETCH_EVERY = 60000;
const CI = { SUCCESS: ["✓", "friendly"], FAILURE: ["✗", "hostile"], ERROR: ["✗", "hostile"], PENDING: ["●", "visor"], EXPECTED: ["●", "visor"] };
const STATE = { MERGED: ["merged", "plasma"], CLOSED: ["closed", "hostile"] };
const REVIEW = { APPROVED: ["approved", "friendly"], CHANGES_REQUESTED: ["changes", "hostile"] };

function ci(pr) {
  const rollup = pr.commits?.nodes?.[0]?.commit?.statusCheckRollup;
  return (rollup && CI[rollup.state]) || ["·", "dim"];
}

function word(pr) {
  return STATE[pr.state] || (pr.isDraft ? ["draft", "dim"] : REVIEW[pr.reviewDecision] || ["open", "shield"]);
}

export default class Intel {
  constructor(cx) {
    this.helper = `${home()}/.local/share/herdr-sessions/session_prs.py`;
    this.bySession = {};
    this.sessionFor = {};
    this.address = null;
    this.loading = false;
    this.error = null;
    this.open = stored("intel.open", true);
    this.showMerged = stored("intel.merged", false);
    this.all = stored("intel.all", false);
    this.scannedAt = 0;
    this.cache = {};
    this.closed = new Set();
    this.allRows = [];
    this.allLoading = false;
    this.allScannedAt = 0;
    this.allFetchedAt = 0;
    cx.timer.every(2000, (cx) => {
      if (Date.now() - this.allScannedAt > SCAN_ALL_EVERY) this.updateAll(cx, false);
      if (this.all) return;
      const a = this.agent();
      if (a && (a.address !== this.address || Date.now() - this.scannedAt > SCAN_EVERY)) this.update(cx, false);
    });
    this.updateAll(cx, true);
    if (!this.all) this.update(cx, true);
  }

  agent() {
    const tab = focused()?.tab;
    const inTab = agents().filter((a) => a.tab === tab);
    return inTab.find((a) => a.app === "claude-code") ?? inTab[0] ?? null;
  }

  async helperRun(args) {
    const r = await exec("python3", ["-I", this.helper, ...args], { timeout: 90000 });
    const out = JSON.parse(r.stdout || "{}");
    if (out.error) throw new Error(out.error);
    return out;
  }

  update(cx, force) {
    if (this.loading) return;
    const a = this.agent();
    if (!a) return;
    this.loading = true;
    this.address = a.address;
    this.scannedAt = Date.now();
    cx.spawn(async (cx) => {
      try {
        const { session, urls } = await this.helperRun(["scan", a.address]);
        if (session) {
          const prev = this.bySession[session] ?? { urls: [], prs: [], at: 0 };
          if (force || urls.join() !== prev.urls.join() || Date.now() - prev.at > FETCH_EVERY) {
            const prs = urls.length ? (await this.helperRun(["fetch", ...urls])).prs : [];
            this.bySession[session] = { urls, prs, at: Date.now() };
          }
          this.sessionFor[a.address] = session;
        }
        this.error = null;
      } catch (e) {
        this.error = String(e?.message ?? e);
      }
      this.loading = false;
      cx.notify();
    });
  }

  updateAll(cx, force) {
    if (this.allLoading) return;
    const list = agents().filter((a) => a.app === "claude-code");
    this.allLoading = true;
    this.allScannedAt = Date.now();
    cx.spawn(async (cx) => {
      try {
        const { results } = list.length ? await this.helperRun(["scan-many", ...list.map((a) => a.address)]) : { results: {} };
        const owner = {};
        for (const a of list) for (const url of results[a.address]?.urls ?? []) owner[url] ??= a.address;
        const urls = Object.keys(owner).filter((u) => !this.closed.has(u));
        const unknown = urls.some((u) => !this.cache[u]);
        if (urls.length && (force || unknown || Date.now() - this.allFetchedAt > FETCH_EVERY)) {
          for (const pr of (await this.helperRun(["fetch", ...urls])).prs) {
            this.cache[pr.url] = pr;
            if (pr.state !== "OPEN") this.closed.add(pr.url);
          }
          this.allFetchedAt = Date.now();
        }
        this.allRows = urls.map((u) => ({ pr: this.cache[u], address: owner[u] }))
          .filter((r) => r.pr?.state === "OPEN")
          .sort((x, y) => (y.pr.updatedAt ?? "").localeCompare(x.pr.updatedAt ?? ""));
        if (shared("halo.prs") !== this.allRows.length) setShared("halo.prs", this.allRows.length);
        this.error = null;
      } catch (e) {
        this.error = String(e?.message ?? e);
      }
      this.allLoading = false;
      cx.notify();
    });
  }

  prs() {
    const a = this.agent();
    const session = a && this.sessionFor[a.address];
    return (session && this.bySession[session]?.prs) || [];
  }

  row(c, pr, owner) {
    const [icon, iconColor] = ci(pr);
    const [state, stateColor] = word(pr);
    const repo = `${pr.repository.nameWithOwner.split("/").pop()}#${pr.number}`;
    const tag = owner && (owner.tab_name && !/^\d+$/.test(owner.tab_name) ? owner.tab_name : owner.title || owner.space_name);
    return v_flex().id(`halo-pr-${pr.url}`).px(8).py(4).gap(1).cursor_pointer()
      .hover((s) => s.bg(c.glass))
      .on_click(() => exec("xdg-open", [pr.url]))
      .on_mouse_down("right", (_e, cx) => {
        cx.stop_propagation();
        exec("wl-copy", [pr.url]);
        notify({ title: "PR link copied", body: repo, level: "success", timeout: 2000 });
      })
      .child(h_flex().gap(6).items_center()
        .child(div().w(10).text_size(11).text_color(c[iconColor]).child(icon))
        .child(div().flex_1().min_w(0).truncate().font_family(HUD).text_size(10).text_color(c.foreground).child(repo.toUpperCase()))
        .child(div().font_family(HUD).text_size(8).text_color(c[stateColor]).child(state.toUpperCase())))
      .child(div().pl(16).font_family(BODY).text_size(11).text_color(c.muted).truncate().child(pr.title))
      .when(Boolean(tag), (el) => el.child(div().id(`halo-pr-tab-${pr.url}`).pl(16).font_family(HUD).text_size(8).text_color(c.armorBright).truncate()
        .hover((s) => s.text_color(c.gold))
        .on_mouse_down("left", (_e, cx) => {
          cx.stop_propagation();
          run("agent.focus", { terminal: owner.address });
        })
        .child(`◂ ${tag.toUpperCase()}`)));
  }

  modeSwitch(c) {
    const chip = (key, text, on) => div().id(`halo-intel-${key}`).px(5).font_family(HUD).text_size(8).cursor_pointer()
      .text_color(on ? "#0b1118" : c.armorBright).bg(on ? c.armorBright : "#00000000")
      .border_1().border_color(c.edge)
      .on_click((_e, cx) => {
        if (this.all === (key === "all")) return;
        this.all = key === "all";
        store("intel.all", this.all);
        if (this.all) this.updateAll(cx, true);
        else this.update(cx, true);
        cx.notify();
      })
      .child(text);
    return h_flex().gap(0).child(chip("tab", "TAB", !this.all)).child(chip("all", "ALL", this.all));
  }

  render(c, grow) {
    const toggle = (cx) => { this.open = !this.open; store("intel.open", this.open); cx.notify(); };
    if (this.all) {
      const byAddress = Object.fromEntries(agents().map((a) => [a.address, a]));
      const rows = this.allRows;
      const badge = rows.length > 0 ? div().px(5).font_family(HUD).text_size(8).text_color("#0b1118").bg(c.gold).child(String(rows.length)) : null;
      return section(c, { id: "intel", title: "Intel // PRs", open: this.open, toggle, badge, extra: this.modeSwitch(c), grow, max: 320 }, (el) => el
        .child(v_flex().id("halo-intel").when(grow, (l) => l.flex_1().min_h(0)).overflow_y_scrollbar()
          .when(rows.length === 0, (l) => l.child(div().px(12).py(2).font_family(BODY).text_size(11).text_color(c.dim)
            .child(this.error ? this.error : this.allLoading && !this.allFetchedAt ? "scanning sessions…" : "no open PRs in any session")))
          .children(rows.map((r) => this.row(c, r.pr, { ...(byAddress[r.address] ?? {}), address: r.address })))));
    }
    const all = this.prs();
    const shown = all.filter((pr) => this.showMerged || pr.state !== "MERGED");
    const hidden = all.length - shown.length;
    const live = all.filter((pr) => pr.state === "OPEN").length;
    const badge = live > 0 ? div().px(5).font_family(HUD).text_size(8).text_color("#0b1118").bg(c.gold).child(String(live)) : null;
    return section(c, { id: "intel", title: "Intel // PRs", open: this.open, toggle, badge, extra: this.modeSwitch(c), grow, max: 280 }, (el) => el
      .child(v_flex().id("halo-intel").when(grow, (l) => l.flex_1().min_h(0)).overflow_y_scrollbar()
        .when(shown.length === 0, (l) => l.child(div().px(12).py(2).font_family(BODY).text_size(11).text_color(c.dim)
          .child(this.error ? this.error : this.agent() ? (hidden ? "all merged" : "no PRs from this session") : "no agent in this tab")))
        .children(shown.map((pr) => this.row(c, pr, null))))
      .when(hidden > 0 || this.showMerged, (l) => l.child(div().id("halo-intel-merged").flex_none().px(12).pt(4).font_family(HUD).text_size(8).text_color(c.dim).cursor_pointer()
        .hover((s) => s.text_color(c.gold))
        .on_click((_e, cx) => { this.showMerged = !this.showMerged; store("intel.merged", this.showMerged); cx.notify(); })
        .child(this.showMerged ? "HIDE MERGED" : `+${hidden} MERGED`))));
  }
}
