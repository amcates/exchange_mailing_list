require 'csv'

tlds = []
excluded_tlds = ["de", "ca", "uk", "kr", "za", "cn", "ie", "au", "ru", "eu", 
                 "jp", "tw", "fr", "es", "it", "nl", "ch", "se", "cz", "sg", "ua", "gr", "hu", "nz", "fi", "be", 
                 "pl", "il", "in", "br", "my", "sa", "mailer-daemon@mailer-daemon", "cl", "ag", "ae", "at", 
                 "mx", "co", "ar", "no", "me", "tr", "dk", "ph", "pt", "ee"]

CSV.open("clean_address.csv", "w") do |csv|
  CSV.foreach("addresses.csv") do |row|
    address = row[0]
    tld = address.split(".").last.downcase

    next unless address.match(/@/)
    next if excluded_tlds.include? tld

    csv << row # include this row before we skip if tld included
    
    next if tlds.include? tld
    tlds << tld
  end
end

puts tlds.inspect
