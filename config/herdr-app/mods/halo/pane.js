import { div, svg } from "gpui-kit";
import { h_flex } from "gpui-base";
import { panes, props, run } from "herdr";
import { HUD, palette, statusOf, folder } from "./hud.js";

export default class Pane {
  render() {
    const c = palette();
    const id = props()?.pane;
    const p = panes().find((x) => x.pane === id);
    const name = (p?.mod ?? p?.program?.name ?? "Terminal").toUpperCase();
    const s = p?.status ? statusOf(p.status) : null;
    const btn = (key, icon, command) => div().id(`halo-${key}-${id}`).w(22).h(20).flex().items_center().justify_center()
      .text_color(c.dim).cursor_pointer().hover((st) => st.text_color(key === "close" ? c.hostile : c.gold))
      .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
      .on_click(() => run(command, { pane: id }))
      .child(svg(`mods/halo/${icon}.svg`).size(11));
    return h_flex().id(`halo-pane-${id}`).size_full().px(10).gap(8).items_center()
      .bg(p?.focused ? c.goldGlow : c.glass).border_b_1().border_color(p?.focused ? c.gold : c.edge)
      .child(div().w(3).h(12).flex_none().bg(p?.focused ? c.gold : c.armor))
      .child(div().font_family(HUD).text_size(10).font_weight(700).text_color(p?.focused ? c.gold : c.armorBright).flex_none().child(name))
      .child(div().text_size(11).text_color(c.dim).truncate().flex_1().min_w(0).child(p?.cwd ? `// ${folder(p.cwd)}${p.branch ? `  ⎇ ${p.branch}` : ""}` : ""))
      .when(Boolean(s), (el) => el.child(div().font_family(HUD).text_size(8).text_color(c[s.color]).flex_none()
        .when(p.status === "working" || p.status === "blocked", (d) => d.loop("opacity", { from: 0.4, to: 1, period: 1000 }))
        .child(s.word)))
      .child(btn("zoom", "zoom", "pane.zoom"))
      .child(btn("close", "close", "pane.close"));
  }
}
