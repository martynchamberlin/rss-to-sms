# rss-to-sms
Sometimes you follow a site very closely and want an SMS whenever it publishes something new

Be sure to run `bundle install` to install the project specific gems

Delicate environment variables are stored via https://github.com/elabs/econfig. They are:
- phone
- twilio_sid
- twilio_token

For Jekyll it's:
//item
guid
title

Outstanding items at this point:
1. Get Twilio integrated into the site.
2. Taylor the RSS tags to be specific to the target domain RSS, including shorturl param.
3. Get pushed to Heroku and set up the cron job.
