Vedeu.interface 'tasks' do
  border!
  geometry do
    y { use('pomodoro').south }
    yn { use('quick_add').north }
  end
  cursor!
  group 'main'
end
