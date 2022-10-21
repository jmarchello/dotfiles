import sublime
import sublime_plugin
import os
from pathlib import Path


class ToggleTestFileCommand(sublime_plugin.WindowCommand):
  def run(self):
    active_file = self.window.active_view().file_name()
    if not active_file.endswith('.rb'):
      return

    is_active_file_test = active_file.endswith('_test.rb')
    if is_active_file_test:
      file_to_open = self.source_file_name(active_file)
    else:
      file_to_open = self.test_file_name(active_file)

    self.open_file(file_to_open)

  def open_file(self, file_to_open):
    if not os.path.isfile(file_to_open):
      Path(file_to_open).touch()

    self.window.open_file(file_to_open)

  def test_file_name(self, active_file):
    return active_file.replace('/app/', '/test/').replace('.rb', '_test.rb')

  def source_file_name(self, active_file):
    return active_file.replace('/test/', '/app/').replace('_test.rb', '.rb')



