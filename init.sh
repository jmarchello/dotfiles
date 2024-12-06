if command -v somecommand >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

mise use ruby

gem install rake

rake
