import sublime
import sublime_plugin
import subprocess
import threading
import os
from pathlib import Path


def test_file_name(file_path):
  return file_path.replace('/app/', '/test/').replace('.rb', '_test.rb')

def source_file_name(file_path):
  return file_path.replace('/test/', '/app/').replace('_test.rb', '.rb')

def is_test_file(file_path):
  return file_path.endswith('_test.rb')

class ToggleTestFileCommand(sublime_plugin.WindowCommand):
  def run(self):
    active_file = self.window.active_view().file_name()
    if not active_file.endswith('.rb'):
      return

    if is_test_file(active_file):
      file_to_open = source_file_name(active_file)
    else:
      file_to_open = test_file_name(active_file)

    self.open_file(file_to_open)

  def open_file(self, file_to_open):
    if not os.path.isfile(file_to_open):
      Path(file_to_open).touch()

    self.window.open_file(file_to_open)

class RunRailsFileCommand(sublime_plugin.WindowCommand):
  def run(self):
    active_file = self.window.active_view().file_name()
    if active_file.endswith('Gemfile'):
      self.run_bundle()
      return

    if 'db/migrate' in active_file and active_file.endswith('.rb'):
      self.run_migrations()
      return

    if active_file.endswith('.rake'):
      self.run_rake()
      return

    self.run_tests(active_file)

  def run_tests(self, active_file):
    if is_test_file(active_file):
      test_file_path = active_file
    else:
      test_file_path = test_file_name(active_file)

    cmd_args = ['/Users/jmarchello/.rbenv/shims/bundle', 'exec', 'rails', 'test', test_file_path]
    self.panel_command(cmd_args)

  def run_migrations(self):
    cmd_args = ['/Users/jmarchello/.rbenv/shims/bundle', 'exec', 'rails', 'db:migrate']
    self.panel_command(cmd_args)

  def run_bundle(self):
    cmd_args = ['/Users/jmarchello/.rbenv/shims/bundle', 'install']
    self.panel_command(cmd_args)

  def run_rake(self):
    rake_extractor = RakeTaskExtractor(self.window)
    rake_task = rake_extractor.run()
    if rake_task:
      cmd_args = ['/Users/jmarchello/.rbenv/shims/bundle', 'exec', 'rails', rake_task]
      self.panel_command(cmd_args)

  def panel_command(self, cmd_args):
    panel_command = PanelCommand(self.window, cmd_args)
    panel_command.run()


class RakeTaskExtractor():
  NAMESPACE_REGEX = r'(?<=namespace :)\w*'
  TASK_REGEX = r'(?<=task )\w*(?=:)'

  def __init__(self, window):
    self.active_view = window.active_view()
    self.current_point = self.active_view.sel()[0].begin()

  def run(self):
    namespace = self.find_nearest_name(self.NAMESPACE_REGEX)
    task = self.find_nearest_name(self.TASK_REGEX)

    if namespace and task:
      return f'{namespace}:{task}'

  def find_nearest_name(self, regex):
    regions = self.active_view.find_all(regex)
    regions.reverse()
    for region in regions:
      if region.begin() < self.current_point:
        return self.active_view.substr(region)


class PanelCommand():
  encoding = 'utf-8'
  proc = None
  panel = None
  panel_lock = threading.Lock()
  cmd_args = []
  window = None

  def __init__(self, window, cmd_args):
    self.window = window
    self.cmd_args = cmd_args

  def run(self):
    with self.panel_lock:
      self.panel = self.window.create_output_panel('panel_command')
      self.panel.settings().set("gutter", False)
      self.window.run_command('show_panel', {'panel': 'output.panel_command'})

    if self.proc is not None:
            self.proc.terminate()
            self.proc = None

    self.queue_write(f'Running command: {" ".join(self.cmd_args)}\n\n')
    self.proc = subprocess.Popen(
        self.cmd_args,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        cwd=self.window.folders()[0]
    )

    threading.Thread(
      target=self.read_handle,
      args=(self.proc.stdout,)
    ).start()

  def read_handle(self, handle):
    chunk_size = 2 ** 13
    out = b''
    while True:
        try:
            data = os.read(handle.fileno(), chunk_size)
            # If exactly the requested number of bytes was
            # read, there may be more data, and the current
            # data may contain part of a multibyte char
            out += data
            if len(data) == chunk_size:
                continue
            if data == b'' and out == b'':
                raise IOError('EOF')
            # We pass out to a function to ensure the
            # timeout gets the value of out right now,
            # rather than a future (mutated) version
            self.queue_write(out.decode(self.encoding))
            if data == b'':
                raise IOError('EOF')
            out = b''
        except (UnicodeDecodeError) as e:
            msg = 'Error decoding output using %s - %s'
            self.queue_write(msg  % (self.encoding, str(e)))
            break
        except (IOError):
            msg = 'Finished'
            self.queue_write('\n[%s]' % msg)
            break

  def queue_write(self, text):
    sublime.set_timeout(lambda: self.do_write(text), 1)

  def do_write(self, text):
    with self.panel_lock:
      self.panel.set_read_only(False)
      self.panel.run_command('append', {'characters': text})
      self.panel.run_command("move_to", {"to": "eof"})
      self.panel.set_read_only(True)




