Vedeu.interface 'help' do
  border!
  geometry do
    y { use('pomodoro').south }
    yn { use('quick_add').north }
  end
  group 'main'
  hide!
end
