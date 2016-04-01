class NotificationsController < ApplicationController

    def index
        latestNotification = Notification.last(1)[0];
        #notification.save
        require 'open-uri'
        output = ''
        link = ''

        doc = Nokogiri::HTML(open("https://martynchamberlin.com/feed"))

        begin_sending = false

        doc.xpath('//item').reverse_each do |item|
            link = item.xpath('guid')[0].content
            title = item.xpath('title')[0].content

            if ( begin_sending )
                # send SMS
                output += link
                Notification.new({guid: link}).save
            end

            if ( latestNotification.guid == link )
                begin_sending = true
            end
        end

        render :json => output
    end

end
