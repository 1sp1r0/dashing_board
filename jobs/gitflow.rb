require 'net/http'
require 'json'
require 'pp'


# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
# SCHEDULER.every '5s', :first_in => 0 do |job|

# end