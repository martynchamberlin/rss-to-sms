class Notification < ActiveRecord::Base

	def generate

        require 'open-uri'
        require 'twilio-ruby' 
        output = ''
        link = ''

        doc = Nokogiri::HTML(open(RssToSms.config.rss_url))

        client = Twilio::REST::Client.new RssToSms.config.twilio_account_sid, RssToSms.config.twilio_auth_token 
        notifications = Array.new;

        doc.xpath('//entry').each do |item|
            link = item.xpath('link')[1].attr('href')
            title = item.xpath('title')[0].content

            break if Notification.exists?(guid: link) 

            # SMS limit is 140 and subtract additional for white space
            max_title = 140 - link.length - 1
            message = title[0..max_title] + " " + link
            notifications << {message: message, link: link}

        end

        puts notifications.inspect

        notifications.reverse_each do |notification|

            Notification.new({guid: notification[:link]}).save

            # send SMS
            response = client.messages.create({
                :from => RssToSms.config.from_phone,  
                :to => RssToSms.config.to_phone,  
                :body => message
            })
            output += notification[:message]

        end

        return output

	end
end
