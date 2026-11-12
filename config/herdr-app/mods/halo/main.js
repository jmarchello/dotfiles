import { View, div } from "gpui-kit";
import { props } from "herdr";
import Top from "./top.js";
import Tracker from "./tracker.js";
import Pane from "./pane.js";
import Status from "./status.js";

const ROLES = { top: Top, tracker: Tracker, pane: Pane, status: Status };

export default class Halo extends View {
  init(p, cx) {
    const pr = props() ?? p ?? {};
    const R = ROLES[pr.role];
    this.role = R ? new R() : null;
    this.role?.init?.(pr, cx);
  }

  render(cx) {
    if (!this.role) return div().child(`halo: no role "${props()?.role}"`);
    return this.role.render(cx);
  }
}
