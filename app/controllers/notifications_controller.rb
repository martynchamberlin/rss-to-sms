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
                # SMS limit is 140 and subtract additional for white space
                max_title = 140 - link.length - 1
                message = title[0..max_title] + " " + link
                # send SMS
                output += message
                # Notification.new({guid: link}).save
            end

            if ( latestNotification.guid == link )
                begin_sending = true
            end
        end

        render :json => output
    end

end