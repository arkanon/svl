# openmsx.tcl

# openMSX Config Script
#
#   Arkanon <arkanon@lsd.org.br>
#   2014/03/06 (Thu) 04:12:21 (BRS)
#   2014/03/05 (Wed) 14:40:53 (BRS)
#   2011/07/29 (Sex) 13:32:59 (BRS)



  set consolebackground     skins/pixel.png

# set default_machine       Gradiente_Expert_DDPlus
# set         machine       Gradiente_Expert_DDPlus

  set grabinput             false

# set speed                 800
  set throttle              true
  set fullspeedwhenloading  true

  set printerlogfilename    printer.txt
  set print-resolution      600

# set renderer              none
  set renderer              sdl

  set scale_algorithm       tv
  set display_deform        3d
  set scale_algorithm       simple
  set scanline              50
  set deinterlace           false

  set horizontal_stretch    320
  set scale_factor          3
# set consolerows           51
# set consolecolumns        136

  set brightness            0
  set contrast              0
  set noise                 0
  set glow                  50
  set gamma                 1.00

  set limitsprites          true

  set save_settings_on_exit false

  set rom $env(ROM_PREFIX)



  if [ info exists env(FILE) ] \
  {
    set file $env(FILE)
  } \
  else \
  {
    set file ""
  }



  proc tr { args } \
  {
    if { [llength $args] == 1 && ( $args == 0 || $args == "deactivate" ) } \
    {
      trainer deactivate
    } \
    else \
    {
      foreach arg [lrange $args 0 end] { trainer [guess_title] $arg }
    }
    puts [trainer [guess_title]]
  }



  monitor_type normal

# filepool add -path $env(OPENMSX_USER_DATA)/rom -types [rom disk tape] -position 0

  if { $rom != "basic" } { carta "$env(ROM)" }

  diska "$env(DISK)"



# set kbd_trace_key_presses on

  bind CTRL+F1           { toggle grabinput }
  bind CTRL+F2           { tr "all" }
  bind CTRL+F3           { set scale_factor [ expr 1 + $scale_factor % 2 ] }

  bind F6                { toggle_osd_keyboard }

  bind F9                { set throttle false }
  bind F9,release        { set throttle true  }

  bind F11               { savestate }
  bind F12               { loadstate }

  bind SHIFT+PRINT       { screenshot -raw -doublesize -prefix "$rom-raw-" }
  bind  CTRL+PRINT       { screenshot        -with-osd -prefix "$rom-osd-" }

  bind HOME              { record start    -doublesize -prefix "$rom-rec-" }
  bind END               { record stop }

  bind SCROLLOCK         { toggle mute }

  bind CTRL+SHIFT+DELETE { reset }

  # ' QUOTE
  # - MINUS
  # = EQUALS
  # ç WORLD_71
  # , COMMA
  # . PERIOD
  # ; SEMICOLON
  # / SLASH
  # \ BACKSLASH
  # [ LEFTBRACKET
  # ] RIGHTBRACKET
  #
  # <key> + SHIFT CTRL ALT MODE
  # ESCAPE TAB CAPSLOCK LSHIFT LCTRL LSUPER LALT SPACE RMODE RSUPER MENU RCTRL RSHIFT RETURN BACKSPACE
  # F1..12
  # PRESS
  # PRINT SCROLLOCK PAUSE INSERT DELETE HOME END PAGEUP PAGEDOWN
  # UP DOWN LEFT RIGHT
  # NUMLOCK KP_DIVIDE KP_MULTIPLY KP_MINUS KP_PLUS KP_ENTER KP_PERIOD KP0..9



  if { $rom == "basic" } \
  {
    after time 16 \
    {
      type "$env(OPENMSX_DATE)\r"
      after time 1 \
      {
        type "files\r"
        after time 2 \
        {
          type "load \"$file"
          if { $file != "" } \
          {
            type "\r"
            after time 4 { type "run\r" }
          }
        }
      }
    }
  }



  if { $rom == "hotlogo" } \
  {
    after time 18 \
    {
      type "dt esc \" arquivos esc \"\r"
      after time 4 \
      {
        type "carregue \"$file"
        if { $file != "" } \
        {
          type "\r"
        # after time 4 { type "tudo\r" }
        }
      }
    }
  }



# EOF
