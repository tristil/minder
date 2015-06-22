Vedeu.keymap('tasks') do
  key(:up, 'k') { Vedeu.trigger(:_cursor_up_) }
  key(:down, 'j') { Vedeu.trigger(:_cursor_down_) }
  key('?') { Vedeu.trigger(:show_help) }
end
