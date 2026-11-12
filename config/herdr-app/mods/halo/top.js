import { div, svg } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, agents, run, window as win } from "herdr";
import { HUD, palette, label, own, tabTitle, chamfer, rims } from "./hud.js";

const SEGMENTS = 12;

function shield(c) {
  const all = agents();
  const hostile = all.filter((a) => a.status === "blocked").length;
  const frac = all.length ? (all.length - hostile) / all.length : 1;
  const lit = Math.round(frac * SEGMENTS);
  const color = hostile ? c.hostile : c.shield;
  return h_flex().gap(8).items_center().flex_none()
    .child(label(hostile ? "Shield low" : "Shield", c))
    .child(h_flex().gap(2).items_center()
      .when(hostile > 0, (el) => el.loop("opacity", { from: 0.35, to: 1, period: 700 }))
      .children(Array.from({ length: SEGMENTS }, (_, i) =>
        div().w(9).h(12).bg(i < lit ? color : c.hudGlass).border_1().border_color(i < lit ? color : c.hudEdge))));
}

function windowButtons(c) {
  const w = win();
  if (!w?.buttons) return null;
  const btn = (id, icon, command) => own(div().id(id).w(28).h(24).flex().items_center().justify_center()
    .text_color(c.muted).cursor_pointer().border_1().border_color(c.edge)
    .hover((s) => s.text_color(id === "halo-close" ? c.hostile : c.gold).border_color(c.gold))
    .on_click(() => run(command))
    .child(svg(`mods/halo/${icon}.svg`).size(12)));
  return h_flex().gap(4).flex_none()
    .child(btn("halo-min", "min", "window.minimize"))
    .child(btn("halo-max", "max", "window.maximize"))
    .child(btn("halo-close", "close", "window.close"));
}

function tabChip(c, tab, i) {
  const color = tab.status === "blocked" ? c.hostile : tab.status === "working" ? c.visor : tab.status === "done" ? c.shield : null;
  return own(h_flex().id(`halo-tab-${tab.id}`).h(28).px(10).gap(7).items_center().when(tab.active, (el) => el.flex_none().max_w(280)).when(!tab.active, (el) => el.flex_shrink(1).min_w(0).max_w(200))
    .cursor_pointer()
    .border_1().border_color(tab.active ? c.gold : c.edge)
    .bg(tab.active ? c.goldGlow : c.glass)
    .hover((s) => s.border_color(c.edgeBright))
    .on_click(() => run("tab.select", { id: tab.id }))
    .on_mouse_down("middle", (_e, cx) => { cx.stop_propagation(); run("tab.close", { id: tab.id }); })
    .child(div().font_family(HUD).text_size(10).font_weight(700).text_color(tab.active ? c.gold : c.armorBright).child(String(i + 1).padStart(2, "0")))
    .when(Boolean(color), (el) => el.child(div().w(6).h(6).flex_none().bg(color)
      .when(tab.status === "working" || tab.status === "blocked", (d) => d.loop("opacity", { from: 0.3, to: 1, period: 900 }))))
    .child(div().truncate().text_size(12).text_color(tab.active ? c.foreground : c.muted).child(tabTitle(tab))));
}

export default class Top {
  render() {
    const c = palette();
    const space = spaces().find((s) => s.active);
    const tabs = (space?.tabs ?? []).filter((t) => !t.settled);
    return h_flex().id("halo-top").relative().size_full().px(18).gap(14).items_center()
      .bg(c.panel)
      .child(h_flex().gap(10).items_center().flex_none()
        .child(div().w(10).h(10).bg(c.gold))
        .child(div().flex().flex_col()
          .child(label("Mission", c, 8))
          .child(own(div().id("halo-mission").font_family(HUD).text_size(13).font_weight(700).text_color(c.foreground).cursor_pointer()
            .hover((s) => s.text_color(c.gold))
            .on_click(() => run("space.next"))
            .child((space?.name ?? "No mission").toUpperCase())))))
      .child(div().w(1).h(28).bg(c.edge).flex_none())
      .child(h_flex().flex_1().min_w(0).gap(6).items_center().overflow_hidden()
        .children(tabs.map((t, i) => tabChip(c, t, i)))
        .child(own(div().id("halo-newtab").w(28).h(28).flex_none().flex().items_center().justify_center()
          .border_1().border_color(c.edge).text_color(c.dim).cursor_pointer()
          .hover((s) => s.text_color(c.gold).border_color(c.gold))
          .on_click(() => run("tab.new"))
          .child(svg("mods/halo/plus.svg").size(12)))))
      .child(shield(c))
      .when(Boolean(win()?.buttons), (el) => el.child(windowButtons(c)))
      .children(rims(c, "tlr"))
      .child(chamfer("tl"))
      .child(chamfer("tr"));
  }
}
