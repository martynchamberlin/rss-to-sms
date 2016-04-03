# RSS to SMS

Sometimes you follow a site very closely and want an SMS whenever it publishes something new

Be sure to run `bundle install` to install the project-specific gems

Delicate environment variables are stored via https://github.com/elabs/econfig. They are:
- phone
- twilio_sid
- twilio_token

Installing pg for postgress on Mac OS X El Capitan required:

   sudo ARCHFLAGS="-arch x86_64" gem install pg

For the necessary environment parameters you'll need to define the following:

- FROM_PHONE
- TO_PHONE
- TWILIO_ACCOUNT_SID
- TWILIO_AUTH_TOKEN
- RSS_URL

Given how many of these there are, the command for starting the rails server is recommended to be stored in an alias. Also, these environment variables need to be prepended before any rake task that accesses them, too.
