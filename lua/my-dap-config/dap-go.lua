local status_ok, dap = pcall(require, "dap")
if not status_ok then
  vim.notify("dap is null")
  return
end

dap.adapters.codelldb = { -- find out more
  type = 'server',
  host = '127.0.0.1',
  port = 13000
}

-- dap.adapters.delve = {
--   type = 'server',
--   port = '${port}',
--   executable = {
--     command = 'dlv',
--     args = { 'dap', '-l', '127.0.0.1:${port}', "--log", '--log-output="dap"' },
--     -- args = { 'dap', '-l', '127.0.0.1:${port}' },
--   }
-- }

dap.adapters.go = function(callback, config)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = math.random(38697, 54000) -- math random to create many debuging instances
  handle, pid_or_err =
  vim.loop.spawn(
    "dlv",
    {
      stdio = { nil, stdout },
      args = { "dap", "-l", "127.0.0.1:" .. port, "--log=true", '--log-output="dap"' },
      detached = true
    },
    function(code)
      stdout:close()
      handle:close()
      print("Delve exited with exit code: " .. code)
    end
  )

  -- golang fmt.print will print to stdout.
  -- FIX: find how to fetch print using log function
  assert(handle, "Error running dlv: " .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)

  print("process opened", handle, pid_or_err)

  -- FIX: wait for delve to start?
  -- vim.defer_fn(
  -- function()
  -- dap.repl.open()
  -- callback({type = "server", host = "127.0.0.1", port = port})
  -- end,
  -- 100)
  dap.repl.open()
  callback({ type = "server", host = "127.0.0.1", port = port })
end

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
-- dap.configurations.go = {
--   {
--     type = "go",
--     name = "kabomm 1",
--     request = "launch",
--     program = "${file}",
--     options = {
--       initialize_timeout_sec = 10,
--     }
--   },
-- }
