class Notification < ActiveRecord::Base

	def generate

       latestNotification = Notification.last(1).first
        require 'open-uri'
        require 'twilio-ruby' 
        output = ''
        link = ''

        doc = Nokogiri::HTML(open(RssToSms.config.rss_url))

        # returns true when, working our way from the bottom of the feed,
        # we encounter the message we last notified about. Anything
        # after that is gravy and needs to be sent.
        latest_sent_found = false

        client = Twilio::REST::Client.new RssToSms.config.twilio_account_sid, RssToSms.config.twilio_auth_token 

        doc.xpath('//entry').reverse_each do |item|
            link = item.xpath('link')[1].attr('href')
            title = item.xpath('title')[0].content

            if ( latest_sent_found )
                # SMS limit is 140 and subtract additional for white space
                max_title = 140 - link.length - 1
                message = title[0..max_title] + " " + link
                # send SMS
                response = client.messages.create({
                    :from => RssToSms.config.from_phone,  
                    :to => RssToSms.config.to_phone,  
                    :body => message
                })
                output += message
                Notification.new({guid: link}).save
            end

            if ( latestNotification and latestNotification.guid == link )
                latest_sent_found = true
            end
        end

        # if begin_sending was never set, that either means our DB is empty
        # or it means that more than a full page of RSS items has run since
        # the last time this code ran. In either case let's grab the latest
        # post and insert it and then move on
        if ( not latest_sent_found ) 
            Notification.new({guid: link}).save
        end

        return output

	end
end
