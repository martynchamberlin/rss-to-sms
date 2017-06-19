require 'net/http'
require 'json'

class Notification < ActiveRecord::Base

  def generate

        require 'open-uri'
        require 'twilio-ruby'
        output = ''

        response = Net::HTTP.get(URI(RssToSms.config.rss_url))
        feed = JSON.parse(response)

        client = Twilio::REST::Client.new RssToSms.config.twilio_account_sid, RssToSms.config.twilio_auth_token
        notifications = Array.new;
        num_checked = 0;

        feed['items'].each do |item|

          # Do this when your guid method changes and you don't want to flood yourself
          # with notifications for things that you've already sent out. In theory the
          # hardcoded date on the left corresponds to the timestamp of when you deployed
          # the updated guid schema.
          if (DateTime.parse('2017-06-18T18:55:35Z') > DateTime.parse(item['date_published']))
            break
          end

            # Sometimes publishers will rearrange their content and push out a new article that's
            # underneath a previously published article. When we encounter the most recently sent
            # item, we want to look a couple underneath that to make sure nothing sticky is going on
            if Notification.exists?(guid: item['id'])
                if num_checked < 2
                    num_checked += 1
                    next
                else
                    break
                end
            end

            # SMS limit is 140 and subtract additional for white space
            max_title = 140 - item['url'].length - 1
            message = item['title'][0..max_title] + " " + item['url']
            notifications << {message: message, link: item['url']}

        end

        puts notifications.inspect

        notifications.reverse_each do |notification|

            Notification.new({guid: notification[:link]}).save

            # send SMS
            response = client.messages.create({
                :from => RssToSms.config.from_phone,
                :to => RssToSms.config.to_phone,
                :body => notification[:message]
            })
            output += notification[:message]

        end

        return output

  end
end
