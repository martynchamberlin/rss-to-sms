class Notification < ActiveRecord::Base

	def generate

        require 'open-uri'
        require 'twilio-ruby'
        output = ''
        link = ''

        doc = Nokogiri::HTML(open(RssToSms.config.rss_url))

        client = Twilio::REST::Client.new RssToSms.config.twilio_account_sid, RssToSms.config.twilio_auth_token
        notifications = Array.new;
        num_checked = 0;

        doc.xpath('//entry').each do |item|
            link = item.xpath('link')[2].attr('href')
            title = item.xpath('title')[0].content

            # Sometimes publishers will rearrange their content and push out a new article that's
            # underneath a previously published article. When we encounter the most recently sent
            # item, we want to look a couple underneath that to make sure nothing sticky is going on
            if Notification.exists?(guid: link)
                if num_checked < 2
                    num_checked += 1
                    next
                else
                    break
                end
            end

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
                :body => notification[:link]
            })
            output += notification[:message]

        end

        return output

	end
end
