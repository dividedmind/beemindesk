task push: :environment do
  User.all.each do |u|
    puts "Pushing datapoints for #{u.id}..."
    u.push_data
  end
end
