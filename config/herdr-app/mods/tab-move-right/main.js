import { View, div } from "gpui-kit";
import { run, props, closeOverlay, spaces, focused } from "herdr";

export default class TabMove extends View {
  init() {
    const overlay = props()?.overlay;
    if (overlay) closeOverlay(overlay);
    const f = focused();
    const space = spaces().find((s) => s.id === f?.space);
    const tabs = space?.tabs ?? [];
    const i = tabs.findIndex((t) => t.id === f?.tab);
    const to = i + 1;
    if (i < 0 || to < 0 || to >= tabs.length) return;
    run("tab.move", { id: tabs[i].id, index: to + 1 });
  }

  render() {
    return div();
  }
}
