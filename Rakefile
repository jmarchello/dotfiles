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
    next
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
  next if command_exists?('zellij')

  install_command 'zellij'
end

task :lazygit do
  next if command_exists?('lg')

  install_command 'lazygit'
end

task :lazydocker do
  next if command_exists?('lazydocker')

  install_command 'lazydocker'
end

task lazyvim: :neovim do
  # next if File.exist?(File.join(Dir.home, '.config', 'nvim', 'lazyvim.json'))

  nvim_dir = File.join(Dir.home, '.config', 'nvim')
  sh "mv #{nvim_dir} #{nvim_dir}.bak"
  FileUtils.ln_sf(
    File.join(File.dirname(__FILE__), 'lazyvim', 'nvim'),
    File.join(Dir.home, '.config')
  )
end

task :neovim do
  next if command_exists?('nvim')

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
