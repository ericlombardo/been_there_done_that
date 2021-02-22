i = 0
10.times do 
  user = User.create(username: "#{i}", password: "#{i}")
  3.times do
    adventure = Adventure.new(title: "epic trip #{i}")
    state = State.new(name: "#{i}")
    activity = Activity.new(name: "#{i}")


    adventure.states << state
    adventure.activities << activity

    adventure.save 
    state.save
    activity.save
  end
  i += 1
end