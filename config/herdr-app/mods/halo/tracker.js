import { div, svg } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { agents, spaces, run, setAgentOrder } from "herdr";
import { HUD, BODY, palette, label, statusOf, hash, stored, store, section } from "./hud.js";
import Intel from "./intel.js";

const GOLDEN = Math.PI * (3 - Math.sqrt(5));

const RADAR = 196;
const DOT = 10;
const RANK = { blocked: 0, done: 1, working: 2, idle: 3 };

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

function squadRow(c, a) {
  const s = statusOf(a.status);
  return h_flex().id(`halo-agent-${a.address}`).px(8).py(5).gap(8).items_center().cursor_pointer()
    .border_l_2().border_color(a.focused ? c.gold : "#00000000")
    .bg(a.focused ? c.goldGlow : "#00000000")
    .hover((st) => st.bg(c.glass))
    .on_click(() => run("agent.focus", { terminal: a.address }))
    .child(div().w(7).h(7).flex_none().bg(c[s.color]))
    .child(v_flex().flex_1().min_w(0)
      .child(div().font_family(BODY).text_size(12).text_color(c.foreground).truncate().child(a.tab_name && !/^\d+$/.test(a.tab_name) ? a.tab_name : a.title || a.tab_name))
      .child(div().font_family(HUD).text_size(8).text_color(c[s.color]).truncate().child(`${s.word} // ${a.space_name.toUpperCase()}`)));
}

function waypoint(c, sp) {
  const color = sp.status === "blocked" ? c.hostile : sp.status === "working" ? c.visor : sp.status === "done" ? c.shield : c.dim;
  return h_flex().id(`halo-space-${sp.id}`).px(8).py(4).gap(8).items_center().cursor_pointer()
    .bg(sp.active ? c.goldGlow : "#00000000")
    .hover((st) => st.bg(c.glass))
    .on_click(() => run("space.select", { id: sp.id }))
    .child(div().font_family(HUD).text_size(9).text_color(sp.active ? c.gold : c.armor).w(18).child(String(sp.index).padStart(2, "0")))
    .child(div().w(5).h(5).flex_none().bg(color))
    .child(div().flex_1().min_w(0).truncate().font_family(HUD).text_size(10).text_color(sp.active ? c.foreground : c.muted).child(sp.name.toUpperCase()));
}

export default class Tracker {
  init(_props, cx) {
    this.intel = new Intel(cx);
    this.squadOpen = stored("squad.open", true);
    this.waypointsOpen = stored("waypoints.open", true);
  }

  render(cx) {
    const c = palette();
    const list = [...agents()].sort((a, b) => (RANK[a.status] ?? 9) - (RANK[b.status] ?? 9) || b.seq - a.seq);
    setAgentOrder(list.map((a) => a.address));
    const count = (s) => list.filter((a) => a.status === s).length;
    return v_flex().id("halo-tracker").size_full().min_h(0).border_r_1().border_color(c.hudEdge)
      .child(v_flex().flex_none().px(12).pt(12).pb(10).gap(8).items_center()
        .child(h_flex().w_full().justify_between().child(label("Motion tracker", c)).child(label(`${list.length} contacts`, c)))
        .child(radar(c, list))
        .child(h_flex().w_full().justify_between()
          .child(div().font_family(HUD).text_size(8).text_color(c.hostile).child(`HOS ${count("blocked")}`))
          .child(div().font_family(HUD).text_size(8).text_color(c.visor).child(`ENG ${count("working")}`))
          .child(div().font_family(HUD).text_size(8).text_color(c.shield).child(`OBJ ${count("done")}`))
          .child(div().font_family(HUD).text_size(8).text_color(c.friendly).child(`STB ${count("idle")}`))))
      .child(section(c, { id: "squad", title: "Squad", open: this.squadOpen, toggle: (cx) => { this.squadOpen = !this.squadOpen; store("squad.open", this.squadOpen); cx.notify(); }, grow: true },
        (el) => el.child(v_flex().id("halo-squad").flex_1().min_h(0).overflow_y_scrollbar().children(list.map((a) => squadRow(c, a))))))
      .child(section(c, { id: "waypoints", title: "Waypoints", open: this.waypointsOpen, toggle: (cx) => { this.waypointsOpen = !this.waypointsOpen; store("waypoints.open", this.waypointsOpen); cx.notify(); }, grow: !this.squadOpen, max: 200 },
        (el) => el.child(v_flex().id("halo-waypoints").when(!this.squadOpen, (l) => l.flex_1().min_h(0)).overflow_y_scrollbar().children(spaces().map((sp) => waypoint(c, sp))))))
      .child(this.intel.render(c, !this.squadOpen && !this.waypointsOpen))
      .when(!this.squadOpen && !this.waypointsOpen && !this.intel.open, (el) => el.child(div().flex_1()));
  }
}
