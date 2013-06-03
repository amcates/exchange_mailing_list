require 'date'
require 'time'
require 'csv'
require 'viewpoint'
include Viewpoint::EWS

begin
  settings = YAML.load_file('settings.yml')
  endpoint = settings["endpoint"]
  user = settings["username"]
  pass = settings["password"]
rescue
  raise "setting.yml not found, please see setting.yml.example"
end

cli = Viewpoint::EWSClient.new endpoint, user, pass

inbox = cli.get_folder :inbox

sd = Date.iso8601('2012-01-01')
ed = Date.iso8601('2012-01-02')

all = []

CSV.open("addresses.csv", "w") do |csv|
  while sd < (Date.today + 1)
    puts "Processing #{sd.to_s} to #{ed.to_s}"

    begin
      items = inbox.items_between sd, ed

      items.each do |item|
        next unless item.from.respond_to? :email_address
        address = item.from.email_address
        next if address.nil?
        
        next if all.include? address.downcase
        csv << [address]
        all << address.downcase
      end
    rescue
      puts "Error processing #{sd.to_s} to #{ed.to_s}"
    ensure
      sd += 1
      ed += 1
    end
  end
end
