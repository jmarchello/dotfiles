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

class RunRailsTestCommand(sublime_plugin.WindowCommand):

  encoding = 'utf-8'
  proc = None
  panel = None
  panel_lock = threading.Lock()

  def run(self):
    active_file = self.window.active_view().file_name()
    if not active_file.endswith('.rb'):
      return

    if is_test_file(active_file):
      self.run_tests(active_file)
    else:
      self.run_tests(test_file_name(active_file))

  # def active_folder(self):
  #   folders = self.window.folders()
  #   active_file = self.window.active_view().file_name()
  #   return [f for f in folders if active_file.startswith(f)][0]

  def run_tests(self, test_file_path):
    with self.panel_lock:
      self.panel = self.window.create_output_panel('rails_test')
      self.panel.settings().set("gutter", False)
      self.window.run_command('show_panel', {'panel': 'output.rails_test'})

    if self.proc is not None:
            self.proc.terminate()
            self.proc = None

    cmd_args = ['/Users/jmarchello/.rbenv/shims/bundle', 'exec', 'rails', 'test', test_file_path]
    self.queue_write(f'Running test file : {test_file_path}\n\n')
    self.proc = subprocess.Popen(
        cmd_args,
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
      self.panel.set_read_only(True)




