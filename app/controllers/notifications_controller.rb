class NotificationsController < ApplicationController

    def index
        notification = Notification.new
        render :json =>notification.generate
    end
end