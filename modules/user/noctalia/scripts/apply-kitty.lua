#!/usr/bin/env luajit
local ffi = require 'ffi'

local path = ('%s/.config/kitty/themes/noctalia.conf'):format(os.getenv 'HOME')

ffi.cdef [[
typedef struct DIR DIR;
struct dirent {
  unsigned long d_ino;
  long d_off;
  unsigned short d_reclen;
  unsigned char d_type;
  char d_name[256];
};
DIR *opendir(const char *name);
struct dirent *readdir(DIR *dirp);
int closedir(DIR *dirp);
int kill(int pid, int sig);
]]

---@param filepath string
---@return string? content
local function read_file(filepath)
  local f = io.open(filepath, 'r')
  if not f then
    io.stderr:write(('apply-kitty.lua: could not open %s\n'):format(filepath))
    return nil
  end
  local content = f:read '*a'
  f:close()
  return content
end

---@param filepath string
---@param content  string
---@return boolean success
local function write_file(filepath, content)
  local f = io.open(filepath, 'w')
  if not f then
    io.stderr:write(('apply-kitty.lua: could not write %s\n'):format(filepath))
    return false
  end
  f:write(content)
  f:close()
  return true
end

local function patch_background()
  local content = read_file(path)
  if not content then
    return
  end

  local replaced = false
  local output_lines = {}

  for line in (content .. '\n'):gmatch '(.-)\n' do
    local output_line = line

    if not replaced then
      local indent, head, color = line:match '^(%s*)(background%s+#)(%x%x%x%x%x%x)%s*$'
      if head and color then
        local n = tonumber(color, 16)
        if n == nil then
          return
        end

        output_line = ('%s%s%06x'):format(indent, head, math.min(n + 1, 0xffffff))
        replaced = true
      end
    end

    table.insert(output_lines, output_line)
  end

  if replaced then
    write_file(path, table.concat(output_lines, '\n') .. '\n')
  else
    io.stderr:write "apply-kitty.lua: no 'background #......' line found, skipping patch\n"
  end
end

---@param sig integer
local function signal_kitty(sig)
  local dir = ffi.C.opendir '/proc'
  if dir == nil then
    return
  end

  while true do
    local entry = ffi.C.readdir(dir)
    if entry == nil then
      break
    end

    local pid = tonumber(ffi.string(entry.d_name))
    if pid then
      local comm_file = io.open(('/proc/%d/comm'):format(pid), 'r')
      if comm_file then
        local comm = comm_file:read '*l'
        comm_file:close()
        if comm == 'kitty' then
          ffi.C.kill(pid, sig)
        end
      end
    end
  end
  ffi.C.closedir(dir)
end

patch_background()

local SIGUSR1 = 10
signal_kitty(SIGUSR1)
