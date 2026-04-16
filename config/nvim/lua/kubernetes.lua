local wk = require("which-key")

local Terminal = require("toggleterm.terminal").Terminal

local k9sTerm = Terminal:new({ cmd = "k9s", hidden = true, direction = 'tab' })

function _k9s_toggle()
  k9sTerm:toggle()
end

wk.register({
  k = {
    name = "Kubernetes",
    n = { '<cmd>lua _k9s_toggle()<CR>', 'K9s' }
  }
}, { prefix = "<leader>" })
