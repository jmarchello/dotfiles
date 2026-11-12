import { div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { agents, focused, exec, home, notify } from "herdr";
import { HUD, BODY, stored, store, section } from "./hud.js";

const SCAN_EVERY = 10000;
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
    this.address = null;
    this.loading = false;
    this.error = null;
    this.open = stored("intel.open", true);
    this.showMerged = stored("intel.merged", false);
    this.scannedAt = 0;
    cx.timer.every(2000, (cx) => {
      const a = this.agent();
      if (a && (a.address !== this.address || Date.now() - this.scannedAt > SCAN_EVERY)) this.update(cx, false);
    });
    this.update(cx, true);
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
          this.sessionFor = { ...(this.sessionFor ?? {}), [a.address]: session };
        }
        this.error = null;
      } catch (e) {
        this.error = String(e?.message ?? e);
      }
      this.loading = false;
      cx.notify();
    });
  }

  prs() {
    const a = this.agent();
    const session = a && this.sessionFor?.[a.address];
    return (session && this.bySession[session]?.prs) || [];
  }

  row(c, pr) {
    const [icon, iconColor] = ci(pr);
    const [state, stateColor] = word(pr);
    const repo = `${pr.repository.nameWithOwner.split("/").pop()}#${pr.number}`;
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
      .child(div().pl(16).font_family(BODY).text_size(11).text_color(c.muted).truncate().child(pr.title));
  }

  render(c, grow) {
    const all = this.prs();
    const shown = all.filter((pr) => this.showMerged || pr.state !== "MERGED");
    const hidden = all.length - shown.length;
    const live = all.filter((pr) => pr.state === "OPEN").length;
    const badge = live > 0 ? div().px(5).font_family(HUD).text_size(8).text_color("#0b1118").bg(c.gold).child(String(live)) : null;
    const toggle = (cx) => { this.open = !this.open; store("intel.open", this.open); cx.notify(); };
    return section(c, { id: "intel", title: "Intel // PRs", open: this.open, toggle, badge, grow, max: 280 }, (el) => el
      .child(v_flex().id("halo-intel").when(grow, (l) => l.flex_1().min_h(0)).overflow_y_scrollbar()
        .when(shown.length === 0, (l) => l.child(div().px(12).py(2).font_family(BODY).text_size(11).text_color(c.dim)
          .child(this.error ? this.error : this.agent() ? (hidden ? "all merged" : "no PRs from this session") : "no agent in this tab")))
        .children(shown.map((pr) => this.row(c, pr))))
      .when(hidden > 0 || this.showMerged, (l) => l.child(div().id("halo-intel-merged").flex_none().px(12).pt(4).font_family(HUD).text_size(8).text_color(c.dim).cursor_pointer()
        .hover((s) => s.text_color(c.gold))
        .on_click((_e, cx) => { this.showMerged = !this.showMerged; store("intel.merged", this.showMerged); cx.notify(); })
        .child(this.showMerged ? "HIDE MERGED" : `+${hidden} MERGED`))));
  }
}
