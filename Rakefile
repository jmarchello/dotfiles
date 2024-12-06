# frozen_string_literal: true

multitask default: %i[shell shell_tools dev alacritty git bin]

task dev: %i[lazyvim lazygit lazydocker]

task :shell do
  FileUtils.ln_sf(File.join(File.dirname(__FILE__), 'shell', 'shell'), Dir.home)

  if ENV['SHELL'].include?('zsh')
    puts 'installing zshrc'
    FileUtils.ln_sf(
      File.join(File.dirname(__FILE__), 'zsh', 'rc'),
      File.join(Dir.home, '.zshrc')
    )
    return
  end

  puts 'installing bashrc'
  FileUtils.ln_sf(
    File.join(File.dirname(__FILE__), 'bash', 'rc'),
    File.join(Dir.home, '.bashrc')
  )
end

task :alacritty do
  if command_exists?('brew')
    sh 'brew install --cask alacritty'
    FileUtils.ln_sf(
      File.join(File.dirname(__FILE__), 'alacritty', '.alacritty.toml'),
      File.join(Dir.home, '.config', '.alacritty.toml')
    )
  else
    puts 'skipping alacritty'
  end
end

task :git do
  FileUtils.ls_sf(
    File.join(File.dirname(__FILE__), 'git', '.gitignore_global'),
    File.join(Dir.home, '.gitignore_global')
  )
  FileUtils.ls_sf(
    File.join(File.dirname(__FILE__), 'git', '.gitconfig'),
    File.join(Dir.home, '.gitconfig')
  )
end

task :bin do
  FileUtils.ls_sf(File.join(File.dirname(__FILE__), 'bin'), Dir.home)
end

task :shell_tools do
  ['fd', 'fzf', 'bat', 'btop', 'eza', %w[ripgrep rg]].each do |tool|
    if tool.is_a?(Array)
      pkg, cmd = tool
    else
      pkg = cmd = tool
    end

    install_command(pkg) unless command_exists?(cmd)
  end
end

task :zellij do
  return if command_exists?('zellij')

  install_command 'zellij'
end

task :lazygit do
  return if command_exists?('lg')

  install_command 'lazygit'
end

task :lazydocker do
  return if command_exists?('lazydocker')

  install_command 'lazydocker'
end

task lazyvim: :neovim do
  return if File.exist?(File.join(Dir.home, '.config', 'nvim', 'lazyvim.json'))

  nvim_dir = File.join(Dir.home, '.config', 'nvim')
  sh "mv #{nvim_dir}{,.bak}"
  sh "git clone https://github.com/LazyVim/starter #{nvim_dir}"
  sh "rm -rf #{nvim_dir}/.git"
end

task :neovim do
  return if command_exists?('nvim')

  install_command 'neovim'
end

def install_command(pkg)
  puts "Installing #{pkg}"

  ['brew install', 'sudo apt-get install -y'].each do |command|
    if command_exists?(command)
      sh "#{command} #{pkg}"
      break
    end
  end
end

def command_exists?(command)
  system("command -v '#{command}' > /dev/null 2>&1")
end
