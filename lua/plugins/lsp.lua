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

-- asm-lsp
require("lspconfig").asm_lsp.setup({
  capabilities = capabilities,   -- 与其它 LSP 共享的 capabilities
  filetypes   = { "asm", "s", "S" },  -- 需要时可按需调整
  settings    = {
    -- asm‑lsp 目前没有像 rust‑analyzer 那样丰富的嵌套设置，
    -- 这里保留空表，以后官方新增选项时可直接填进去。
    ["asm-lsp"] = {
      -- 例：切换 Intel ↔ AT&T 语法（若未来支持）
      -- syntax = "intel",   -- or "att"
    },
  },
  root_dir = require("lspconfig.util").root_pattern(".git", "."),
})
