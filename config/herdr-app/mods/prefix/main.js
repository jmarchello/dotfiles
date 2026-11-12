import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { run, props, closeOverlay, theme, home } from "herdr";

const BINDINGS = {
  "?": ["app.help"],
  d: ["window.close"],
  h: ["pane.split", { direction: "down" }],
  v: ["pane.split", { direction: "right" }],
  x: ["pane.close"],
  z: ["pane.zoom"],
  c: ["tab.new"],
  r: ["tab.rename"],
  k: ["tab.close", { confirmed: true }],
  p: ["tab.prev"],
  n: ["tab.next"],
  C: ["space.new"],
  R: ["space.rename"],
  K: ["space.close", { confirmed: true }],
  P: ["space.prev"],
  N: ["space.next"],
  g: ["terminal.open", { name: "PRs", argv: ["python3", "board.py"], folder: `${home()}/.config/herdr/plugins/pr-board` }],
};

for (let i = 1; i <= 9; i++) BINDINGS[String(i)] = ["tab.select", { index: i }];

export default class Prefix extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(50, () => this.handle.focus());
  }

  key(e, cx) {
    cx.stop_propagation();
    const m = e.modifiers;
    if (["shift", "control", "alt", "platform"].includes(e.key)) return;
    const plain = !m.control && !m.alt && !m.platform;
    const ch = e.key_char ?? (m.shift ? e.key.toUpperCase() : e.key);
    const binding = plain ? BINDINGS[ch] : undefined;
    closeOverlay(props()?.overlay);
    if (binding) run(binding[0], binding[1] ?? {});
  }

  render() {
    const t = theme();
    return h_flex().id("prefix").track_focus(this.handle).on_key_down((e, cx) => this.key(e, cx))
      .px(12).py(6).rounded(8).bg(t.accent).text_color(t.accent_foreground).text_size(12).font_semibold()
      .child(div().child("ctrl-space"));
  }
}
