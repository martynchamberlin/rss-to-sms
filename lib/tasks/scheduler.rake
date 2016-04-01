desc "This sends me SMS messages"
task :generate_notifications => :environment do
	notification = Notification.new
	notification.generate
end