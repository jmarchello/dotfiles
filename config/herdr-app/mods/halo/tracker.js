import { div, svg } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { agents, terminals, focused, spaces, run, setAgentOrder, openOverlay } from "herdr";
import { HUD, BODY, palette, label, statusOf, hash, stored, store, section } from "./hud.js";
import Intel from "./intel.js";

const GOLDEN = Math.PI * (3 - Math.sqrt(5));

const RADAR = 140;
const DOT = 8;
const RANK = { blocked: 0, done: 1, working: 2, idle: 3 };

const kidStatus = (k, listed) => {
  const s = listed.get(k.address) ?? k.status;
  return s === "error" ? "blocked" : s === "done" ? "idle" : s;
};

function tree(all, addr, lead = []) {
  const kids = all.filter((k) => k.parent === addr && k.state === "live");
  return kids.flatMap((k, i) => {
    const last = i === kids.length - 1;
    return [{ t: k, lines: [...lead, last ? "└" : "├"] }, ...tree(all, k.address, [...lead, last ? "" : "│"])];
  });
}

function ring(c, frac) {
  const d = RADAR * frac;
  const off = (RADAR - d) / 2;
  return div().absolute().left(off).top(off).w(d).h(d).rounded_full().border_1().border_color(c.hudEdge);
}

function blip(c, a, slot) {
  const s = statusOf(a.status);
  const angle = slot * GOLDEN + hash(a.address) * 0.4;
  const r = (RADAR / 2 - DOT) * s.ring;
  const x = RADAR / 2 + Math.cos(angle) * r - DOT / 2;
  const y = RADAR / 2 + Math.sin(angle) * r - DOT / 2;
  const color = c[s.color];
  return div().id(`halo-blip-${a.address}`).absolute().left(x).top(y).w(DOT).h(DOT).rounded_full()
    .bg(color).border_1().border_color(a.focused ? c.foreground : color).cursor_pointer()
    .when(a.status === "working" || a.status === "blocked", (el) => el.loop("opacity", { from: 0.35, to: 1, period: a.status === "blocked" ? 600 : 1400 }))
    .on_click(() => run("agent.focus", { terminal: a.address }));
}

function slots(list) {
  const order = list.map((a) => a.address).sort((x, y) => x.localeCompare(y, undefined, { numeric: true }));
  return list.map((a) => [a, order.indexOf(a.address)]);
}

function radar(c, list) {
  return div().relative().w(RADAR).h(RADAR).flex_none().rounded_full().bg(c.hudGlass).border_1().border_color(c.hudBright)
    .child(ring(c, 0.66))
    .child(ring(c, 0.33))
    .child(div().absolute().left(RADAR / 2).top(0).w(1).h(RADAR).bg(c.hudEdge))
    .child(div().absolute().left(0).top(RADAR / 2).w(RADAR).h(1).bg(c.hudEdge))
    .child(div().absolute().left(0).top(0).size(RADAR).text_color(c.shield).child(svg("mods/halo/sweep.svg").size(RADAR).spin(3600)))
    .child(div().absolute().left(RADAR / 2 - 4).top(RADAR / 2 - 4).w(8).h(8).bg(c.shield))
    .children(slots(list).map(([a, slot]) => blip(c, a, slot)));
}

export default class Tracker {
  init(_props, cx) {
    this.intel = new Intel(cx);
    this.squadOpen = stored("squad.open", true);
    this.waypointsOpen = stored("waypoints.open", true);
    this.hovered = null;
    this.folded = new Set();
    this.pressed = null;
    this.over = null;
  }

  subRow(c, sub, listed, shown) {
    const k = sub.t;
    const st = statusOf(kidStatus(k, listed));
    const on = k.address === shown;
    const raw = kidStatus(k, listed);
    return h_flex().id(`halo-sub-${k.address}`).pl(14).pr(8).h(22).gap(0).items_center().cursor_pointer()
      .bg(on ? c.goldGlow : "#00000000")
      .hover((x) => x.bg(c.glass))
      .on_click(() => (listed.has(k.address) ? run("pane.focus", { terminal: k.address }) : run("terminal.peek", { terminal: k.address })))
      .children(sub.lines.map((l) => div().self_start().mt(-3).w(9).h(14).mr(3).flex_none()
        .when(Boolean(l), (el) => el.border_l_1().border_color(c.hudBright))
        .when(l === "└" || l === "├", (el) => el.border_b_1())))
      .child(div().w(5).h(5).mr(6).flex_none().bg(c[st.color])
        .when(raw === "working" || raw === "blocked", (d) => d.loop("opacity", { from: 0.35, to: 1, period: raw === "blocked" ? 600 : 1400 })))
      .child(div().flex_1().min_w(0).truncate().font_family(BODY).text_size(11).text_color(on ? c.foreground : c.muted)
        .child(k.name || k.template || k.program?.name || k.address))
      .child(div().flex_none().font_family(HUD).text_size(7).text_color(c[st.color]).child(st.word));
  }

  squadRow(c, a, subs = []) {
    const s = statusOf(a.status);
    const name = a.tab_name && !/^\d+$/.test(a.tab_name) ? a.tab_name : a.title || a.tab_name;
    const hover = this.hovered === a.address;
    return h_flex().id(`halo-agent-${a.address}`).px(8).py(5).gap(8).items_center().cursor_pointer()
      .border_l_2().border_color(a.focused ? c.gold : "#00000000")
      .bg(a.focused ? c.goldGlow : "#00000000")
      .hover((st) => st.bg(c.glass))
      .on_hover((on, cx) => {
        if (on) this.hovered = a.address;
        else if (this.hovered === a.address) this.hovered = null;
        cx.notify();
      })
      .on_click(() => run("agent.focus", { terminal: a.address }))
      .on_mouse_down("right", (_e, cx) => {
        cx.stop_propagation();
        openOverlay({ mod: "menu", kind: "popup", width: 200, height: 260, props: { tab: "pane", target: { pane: a.pane, terminal: a.address } } });
      })
      .child(div().w(7).h(7).flex_none().bg(c[s.color]))
      .child(v_flex().flex_1().min_w(0)
        .child(div().font_family(BODY).text_size(12).text_color(c.foreground).truncate().child(name))
        .child(div().font_family(HUD).text_size(8).text_color(c[s.color]).truncate().child(`${s.word} // ${a.space_name.toUpperCase()}`)))
      .when(subs.length > 0, (el) => el.child(this.fold(c, a, subs)))
      .when(a.pinned || hover, (el) => el.child(div().id(`halo-pin-${a.address}`).flex_none().p(2)
        .text_color(a.pinned && !hover ? c.gold : c.dim).cursor_pointer()
        .hover((st) => st.text_color(c.gold))
        .tooltip(a.pinned ? "Unpin" : "Pin to the top")
        .on_click((_e, cx) => {
          cx.stop_propagation();
          run("terminal.pin", { terminal: a.address, pinned: !a.pinned });
          this.hovered = null;
          cx.notify();
        })
        .child(svg(`mods/workspace-chrome/${a.pinned && hover ? "pin-off" : "pin"}.svg`).size(12))));
  }

  fold(c, a, subs) {
    const open = !this.folded.has(a.address);
    const top = subs.map((x) => x.st).reduce((m, x) => ((RANK[x] ?? 9) < (RANK[m] ?? 9) ? x : m), "idle");
    return h_flex().id(`halo-fold-${a.address}`).flex_none().px(3).gap(3).items_center().cursor_pointer()
      .border_1().border_color(c.edge)
      .text_color(open ? c.dim : c[statusOf(top).color])
      .hover((x) => x.text_color(c.gold).border_color(c.gold))
      .on_click((_e, cx) => {
        cx.stop_propagation();
        open ? this.folded.add(a.address) : this.folded.delete(a.address);
        cx.notify();
      })
      .child(svg(`mods/workspace-chrome/chevron-${open ? "down" : "right"}.svg`).size(10))
      .child(div().font_family(HUD).text_size(8).child(String(subs.length)));
  }

  waypoint(c, sp, i, all) {
    const color = sp.status === "blocked" ? c.hostile : sp.status === "working" ? c.visor : sp.status === "done" ? c.shield : c.dim;
    const from = all.findIndex((x) => x.id === this.pressed);
    const dropping = this.pressed !== null && this.over === sp.id && this.pressed !== sp.id;
    return h_flex().id(`halo-space-${sp.id}`).relative().px(8).py(4).gap(8).items_center().cursor_pointer()
      .bg(sp.active ? c.goldGlow : "#00000000")
      .hover((st) => st.bg(c.glass))
      .when(this.pressed === sp.id && this.over !== sp.id, (el) => el.opacity(0.5))
      .when(dropping, (el) => el.child(div().absolute().left(0).right(0).h(2).bg(c.gold)
        .when(from < i, (l) => l.bottom(0))
        .when(from > i, (l) => l.top(0))))
      .on_mouse_down("left", () => { this.pressed = sp.id; this.over = sp.id; })
      .on_mouse_move((_e, cx) => {
        const src = all.find((x) => x.id === this.pressed);
        const over = src && (src.machine ?? null) === (sp.machine ?? null) ? sp.id : null;
        if (this.pressed !== null && this.over !== over) { this.over = over; cx.notify(); }
      })
      .on_mouse_up("left", (_e, cx) => {
        const src = this.pressed, over = this.over;
        this.pressed = null;
        this.over = null;
        if (src !== null && over === sp.id && src !== sp.id) run("space.move", { id: src, index: i + 1 });
        else if (src === sp.id) run("space.select", { id: sp.id });
        cx.notify();
      })
      .on_mouse_down("right", (_e, cx) => {
        cx.stop_propagation();
        openOverlay({ mod: "menu", kind: "popup", width: 200, height: 260, props: { tab: "space", target: { id: sp.id } } });
      })
      .child(div().font_family(HUD).text_size(9).text_color(sp.active ? c.gold : c.armor).w(18).child(String(sp.index).padStart(2, "0")))
      .child(div().w(5).h(5).flex_none().bg(color))
      .child(div().flex_1().min_w(0).truncate().font_family(HUD).text_size(10).text_color(sp.active ? c.foreground : c.muted).child(sp.name.toUpperCase()));
  }

  newSpace(c) {
    return div().id("halo-space-new").w(16).h(16).flex().items_center().justify_center()
      .border_1().border_color(c.edge).text_color(c.dim).cursor_pointer()
      .hover((st) => st.text_color(c.gold).border_color(c.gold))
      .tooltip("New space")
      .on_click((_e, cx) => { cx.stop_propagation(); run("space.new"); })
      .child(svg("mods/halo/plus.svg").size(9));
  }

  render(cx) {
    const c = palette();
    const raw = agents();
    const listed = new Map(raw.map((a) => [a.address, a.status]));
    const all = terminals();
    const shown = focused()?.agent;
    const kids = new Map(raw.map((a) => [a.address, tree(all, a.address).map((x) => ({ ...x, st: kidStatus(x.t, listed) }))]));
    const nested = new Set([...kids.values()].flat().map((x) => x.t.address));
    const urgency = (a) => Math.min(RANK[a.status] ?? 9, ...kids.get(a.address).map((x) => RANK[x.st] ?? 9));
    const list = [...raw].sort((a, b) => (b.pinned - a.pinned) || urgency(a) - urgency(b) || b.seq - a.seq);
    const squad = list.filter((a) => a.pinned || !nested.has(a.address));
    const rows = squad.flatMap((a) => {
      const subs = kids.get(a.address);
      const r = this.squadRow(c, a, subs);
      return this.folded.has(a.address) ? [r] : [r, ...subs.map((x) => this.subRow(c, x, listed, shown))];
    });
    const sp = spaces();
    setAgentOrder(squad.map((a) => a.address));
    const count = (s) => list.filter((a) => a.status === s).length;
    return v_flex().id("halo-tracker").size_full().min_h(0).border_r_1().border_color(c.hudEdge)
      .child(v_flex().flex_none().px(12).pt(10).pb(8).gap(6).items_center()
        .child(h_flex().w_full().justify_between().child(label("Motion tracker", c)).child(label(`${list.length} contacts`, c)))
        .child(radar(c, list))
        .child(h_flex().w_full().justify_between()
          .child(div().font_family(HUD).text_size(8).text_color(c.hostile).child(`HOS ${count("blocked")}`))
          .child(div().font_family(HUD).text_size(8).text_color(c.visor).child(`ENG ${count("working")}`))
          .child(div().font_family(HUD).text_size(8).text_color(c.shield).child(`OBJ ${count("done")}`))
          .child(div().font_family(HUD).text_size(8).text_color(c.friendly).child(`STB ${count("idle")}`))))
      .child(section(c, { id: "squad", title: "Squad", open: this.squadOpen, toggle: (cx) => { this.squadOpen = !this.squadOpen; store("squad.open", this.squadOpen); cx.notify(); }, grow: true },
        (el) => el.child(v_flex().id("halo-squad").flex_1().min_h(0).overflow_y_scrollbar().children(rows))))
      .child(section(c, { id: "waypoints", title: "Waypoints", open: this.waypointsOpen, toggle: (cx) => { this.waypointsOpen = !this.waypointsOpen; store("waypoints.open", this.waypointsOpen); cx.notify(); }, extra: this.newSpace(c), grow: !this.squadOpen, max: 200 },
        (el) => el.child(v_flex().id("halo-waypoints").when(!this.squadOpen, (l) => l.flex_1().min_h(0)).overflow_y_scrollbar()
          .on_mouse_up("left", (_e, cx) => { this.pressed = null; this.over = null; cx.notify(); })
          .children(sp.map((w, i) => this.waypoint(c, w, i, sp))))))
      .child(this.intel.render(c, !this.squadOpen && !this.waypointsOpen))
      .when(!this.squadOpen && !this.waypointsOpen && !this.intel.open, (el) => el.child(div().flex_1()));
  }
}
