namespace :newtest do

    desc "Pick a random user as the winner"
    task :winner => :environment do
      puts "Winner: #{pick(User).name}"
    end

    desc "Pick a random product as the prize"
    task :prize => :environment do
      puts "Prize: #{pick(Product).name}"
    end
  
    desc "Pick a random prize and winner"
    task :all => [:prize, :winner]
  
    def pick(model_class)
      model_class.find(:first, :order => 'RAND()')
    end
end
