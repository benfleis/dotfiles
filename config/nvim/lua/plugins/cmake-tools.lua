return {
   { "stevearc/overseer.nvim", opts = {} },
   {
      "Civitasv/cmake-tools.nvim",
      opts = {
         cmake_executor = {
            name = "overseer",
            --name = "quickfix",
            --opts = {
            --   show = "always", -- or "only_on_error" if you prefer quiet on success
            --   auto_close_when_success = true,
            --   position = "bottom",
            --   size = 10,
            --},
         },
         cmake_build_type = function()
            return "Debug"
         end,
         cmake_build_directory = function()
            return "build/debug"
         end,
      },
   },
}
