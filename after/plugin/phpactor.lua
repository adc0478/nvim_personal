if not pcall(require,'lspconfig')then
    return
end
require('lspconfig').phpactor.setup { }
