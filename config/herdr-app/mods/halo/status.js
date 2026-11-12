import { div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, focused, panes, shared } from "herdr";
import { HUD, palette, chamfer, rims } from "./hud.js";

function counter(c, word, value, color) {
  return h_flex().gap(6).items_center()
    .child(div().font_family(HUD).text_size(8).text_color(c.armorBright).child(word))
    .child(div().font_family(HUD).text_size(12).font_weight(700).text_color(color).child(String(value).padStart(2, "0")));
}

export default class Status {
  init(_props, cx) {
    this.now = new Date();
    cx.timer.every(15000, (cx) => { this.now = new Date(); cx.notify(); });
  }

  render() {
    const c = palette();
    const tabs = spaces().reduce((n, s) => n + s.tabs.length, 0);
    const pane = panes().find((p) => p.pane === focused()?.pane);
    const time = `${String(this.now.getHours()).padStart(2, "0")}:${String(this.now.getMinutes()).padStart(2, "0")}`;
    return h_flex().id("halo-status").relative().size_full().px(28).gap(18).items_center()
      .bg(c.panel)
      .child(counter(c, "TABS", tabs, c.gold))
      .child(counter(c, "SPACES", spaces().length, c.visor))
      .child(counter(c, "OPEN PRS", shared("halo.prs") ?? "--", c.plasma))
      .child(div().flex_1())
      .when(Boolean(pane?.branch), (el) => el.child(div().text_size(11).text_color(c.dim).child(`⎇ ${pane.branch}`)))
      .child(div().font_family(HUD).text_size(12).font_weight(700).text_color(c.gold).child(time))
      .children(rims(c, "blr"))
      .child(chamfer("bl"))
      .child(chamfer("br"));
  }
}
