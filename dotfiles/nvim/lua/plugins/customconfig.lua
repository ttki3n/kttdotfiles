-- return {
--   {
--     "nvim-lualine/lualine.nvim",
--     opts = function(_, opts)
--       local filenameFound = false
--       -- Find the filename component in lualine_c and change its path configuration
--       for _, component in ipairs(opts.sections.lualine_c) do
--         if component[1] == "filename" then
--           -- 0: Just filename
--           -- 1: Relative path
--           -- 2: Absolute path
--           -- 3: Absolute path with tilde (~/) for home directory
--           component.path = 2
--           filenameFound = true
--         end
--       end
--       if filenameFound == false then
--         table.insert(opts.sections.lualine_c, {
--           "filename",
--           path = 2,
--         })
--       end
--     end,
--   },
-- }
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c = {
        function()
          return vim.fn.expand("%:p")
        end,
      }
    end,
  },
}
