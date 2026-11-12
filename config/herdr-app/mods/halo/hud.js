import { div, image } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";

const CHAMFER = 30;
import { theme, home, panes } from "herdr";

export const HUD = "Orbitron";
export const BODY = "Geist";

export function palette() {
  const t = theme();
  return {
    ...t,
    shield: t.accent,
    visor: t.ansi3,
    hostile: t.ansi1,
    friendly: t.ansi2,
    plasma: t.ansi5,
    gold: "#f0b443",
    goldGlow: "#f0b44322",
    armor: "#6b7d45",
    armorBright: "#9db866",
    glass: "#6b7d4514",
    edge: "#6b7d4580",
    edgeBright: "#9db866",
    panel: "#00000000",
    plate: "#03101a99",
    hudGlass: "#3fc8e40d",
    hudEdge: "#3fc8e433",
    hudBright: "#3fc8e499",
    rim: "#3fc8e4aa",
  };
}

export const STATUS = {
  working: { color: "visor", word: "ENGAGED", ring: 0.55 },
  blocked: { color: "hostile", word: "HOSTILE", ring: 0.25 },
  done: { color: "shield", word: "OBJECTIVE", ring: 0.75 },
  idle: { color: "friendly", word: "STANDBY", ring: 0.9 },
};

export function statusOf(s) {
  return STATUS[s] ?? STATUS.idle;
}

export function label(text, c, size = 9) {
  return div().font_family(HUD).text_size(size).text_color(c.armorBright).child(text.toUpperCase());
}

export function folder(cwd) {
  if (!cwd) return "";
  const h = home();
  return cwd === h ? "~" : cwd.startsWith(h + "/") ? "~" + cwd.slice(h.length) : cwd;
}

export function own(el) {
  return el.on_mouse_down("left", (_e, cx) => cx.stop_propagation()).on_mouse_down("right", (_e, cx) => cx.stop_propagation());
}

const clean = (s) => (s ?? "").replace(/^[^\p{L}\p{N}]+/u, "").trim();

export function tabTitle(tab) {
  if (tab.named) return tab.name;
  const mine = panes().filter((p) => p.tab === tab.id && p.terminal);
  const lead = mine.find((p) => p.program?.agent) ?? mine.find((p) => p.focused) ?? mine[0];
  const live = clean(lead?.title);
  if (live && !/^[~/]/.test(live) && !live.includes("@") && live !== lead?.program?.name) return live;
  return lead?.program?.name && !lead.program.shell ? lead.program.name : tab.name;
}

export function stored(key, fallback) {
  try {
    const v = localStorage.getItem(key);
    return v === "1" ? true : v === "0" ? false : fallback;
  } catch {
    return fallback;
  }
}

export function store(key, value) {
  try {
    localStorage.setItem(key, value ? "1" : "0");
  } catch {}
}

export function section(c, { id, title, open, toggle, badge, grow, max }, body) {
  return v_flex().id(`halo-sec-${id}`).min_h(0).py(6).mx(8).mb(8).bg(c.plate).border_1().border_color(c.hudEdge)
    .when(open && grow, (el) => el.flex_1())
    .when(!(open && grow), (el) => el.flex_none())
    .when(open && !grow && Boolean(max), (el) => el.max_h(max))
    .child(h_flex().id(`halo-sec-${id}-head`).flex_none().px(12).pb(open ? 4 : 0).gap(6).items_center().cursor_pointer()
      .on_click((_e, cx) => toggle(cx))
      .child(div().w(8).font_family(HUD).text_size(9).text_color(c.armorBright).child(open ? "▾" : "▸"))
      .child(label(title, c))
      .child(div().flex_1())
      .when(Boolean(badge), (el) => el.child(badge)))
    .when(open, (el) => body(el));
}

export function rims(c, edges) {
  const line = () => div().absolute().bg(c.rim);
  const out = [];
  if (edges.includes("t")) out.push(line().left(0).top(0).w_full().h(2));
  if (edges.includes("b")) out.push(line().left(0).bottom(0).w_full().h(2));
  if (edges.includes("l")) out.push(line().left(0).top(0).w(2).h_full());
  if (edges.includes("r")) out.push(line().right(0).top(0).w(2).h_full());
  return out;
}

export function chamfer(corner) {
  const el = image(`mods/halo/art/chamfer-${corner}.svg`).absolute().w(CHAMFER).h(CHAMFER);
  const x = corner.endsWith("l") ? el.left(0) : el.right(0);
  return corner.startsWith("t") ? x.top(0) : x.bottom(0);
}

export function hash(s) {
  let h = 2166136261;
  for (const ch of s) h = Math.imul(h ^ ch.charCodeAt(0), 16777619);
  return (h >>> 0) / 4294967295;
}
