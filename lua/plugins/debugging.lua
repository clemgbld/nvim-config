return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local mason_dap = require("mason-nvim-dap")
    local dap = require("dap")
    local ui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")

    -- Define a helper function to set keymaps
    local function map_dap(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc, nowait = true, noremap = true, silent = true })
    end

    -- 💡 Debugger Keymaps Block 💡
    map_dap("<leader>dt", function()
      require("dap").toggle_breakpoint()
    end, "Toggle Breakpoint")

    map_dap("<leader>dc", function()
      require("dap").continue()
    end, "Continue")

    map_dap("<leader>di", function()
      require("dap").step_into()
    end, "Step Into")

    map_dap("<leader>do", function()
      require("dap").step_over()
    end, "Step Over")

    map_dap("<leader>du", function()
      require("dap").step_out()
    end, "Step Out")

    map_dap("<leader>dr", function()
      require("dap").repl.open()
    end, "Open REPL")

    map_dap("<leader>dl", function()
      require("dap").run_last()
    end, "Run Last")

    map_dap("<leader>dq", function()
      require("dap").terminate()
      require("dapui").close()
      require("nvim-dap-virtual-text").toggle() -- Assuming it is loaded
    end, "Terminate")

    map_dap("<leader>db", function()
      require("dap").list_breakpoints()
    end, "List Breakpoints")

    map_dap("<leader>de", function()
      require("dap").set_exception_breakpoints({ "all" })
    end, "Set Exception Breakpoints")

    map_dap("<leader>df", function()
      require("dap").goto_()
    end, "Go to current frame")
    -- 💡 End Debugger Keymaps Block 💡

    -- Dap Virtual Text
    dap_virtual_text.setup()

    mason_dap.setup({
      ensure_installed = { "cppdbg" },
      automatic_installation = true,
      handlers = {
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    })

    -- Configurations
    dap.configurations = {
      c = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
          MIMode = "lldb",
          console = "integratedTerminal",
        },
        {
          name = "Launch file (codelldb)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          terminal = "integrated",
        },
        {
          name = "Attach to lldbserver :1234",
          type = "cppdbg",
          request = "launch",
          MIMode = "lldb",
          miDebuggerServerAddress = "localhost:1234",
          miDebuggerPath = "/usr/bin/lldb",
          cwd = "${workspaceFolder}",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
        },
      },
    }

    -- Dap UI

    ui.setup()

    vim.fn.sign_define("DapBreakpoint", { text = "🛑" })

    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end
  end,
}
