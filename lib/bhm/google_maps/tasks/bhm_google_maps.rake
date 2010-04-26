namespace "bhm-google-maps" do
  
  desc "Will copy across the newest version of the javascript files"
  task :install => :environment do
    puts "Installing gmap.js file into public/javascripts"
    BHM::GoogleMaps.install_js!
  end
  
end