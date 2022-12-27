ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local VGUI_System010=client.create_interface("vgui2.dll", "VGUI_System010") or print("Error finding VGUI_System010")
local VGUI_System=ffi.cast(ffi.typeof('void***'), VGUI_System010)
local get_clipboard_text_count=ffi.cast( "get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print("get_clipboard_text_count Invalid")
local set_clipboard_text=ffi.cast("set_clipboard_text", VGUI_System[ 0 ][ 9 ]) or print("set_clipboard_text Invalid")
local get_clipboard_text=ffi.cast("get_clipboard_text", VGUI_System[ 0 ][ 11 ]) or print("get_clipboard_text Invalid")

function clipboard_import()
    local clipboard_text_length=get_clipboard_text_count( VGUI_System )
  local clipboard_data = ""
  if clipboard_text_length > 0 then
      buffer=ffi.new("char[?]", clipboard_text_length)
      size=clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
      get_clipboard_text( VGUI_System, 0, buffer, size )
      clipboard_data=ffi.string( buffer, clipboard_text_length-1 )
  end
  return clipboard_data
end

function clipboard_export(string)
  if string then
      set_clipboard_text(VGUI_System, string, string:len())
  end
end