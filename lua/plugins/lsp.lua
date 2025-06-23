require("mason").setup({
  ui = {
      icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
      }
  }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").lua_ls.setup {
  capabilities = capabilities,
}

require("lspconfig").clangd.setup({
  capabilities = capabilities,
  cmd = { "clangd-19" },  -- 如果你要指定特定版本（如 clangd-19）
})

require("lspconfig").cmake.setup({
  capabilities = capabilities,
})

require("lspconfig").rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = {
        command = "clippy",
      },
    },
  },
})

require("lspconfig").bashls.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  filetypes = { "sh", "bash" },
})

-- Java lsp (jdtls)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local jdtls = require("jdtls")

    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "/java/workspace/" .. project_name

    local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    local root_dir = require("jdtls.setup").find_root(root_markers)

    if root_dir == nil then
      vim.notify("jdtls: No root dir found", vim.log.levels.WARN)
      return
    end

    local config = {
      cmd = {
        "jdtls",
        "--jvm-arg=-javaagent:" .. os.getenv("HOME") .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
      },
      root_dir = root_dir,
      capabilities = capabilities,
      init_options = {
        workspace = workspace_dir,
      },
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = "interactive",
          },
        },
      },
    }

    jdtls.start_or_attach(config)
  end,
})
-- jdtls end
