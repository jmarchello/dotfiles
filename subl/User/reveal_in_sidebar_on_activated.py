# sublime text plugin that reveals the current file in the sidebar whenever a the active view changes
import sublime
import sublime_plugin

class RevealFileInSidebar(sublime_plugin.EventListener):

    def on_activated(self, view):
        window = view.window()
        window.run_command("reveal_in_side_bar")
