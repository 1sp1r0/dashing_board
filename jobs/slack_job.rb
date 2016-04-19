require 'net/http'
require 'json'
require 'pp'

AUTH_TOKEN = open('assets/.auth_token').read

url = 'https://slack.com/api/channels.history?token=xoxp-32797682641-34096478214-35645111159-bddfd33fb9&channel=C0YPMM9JN&pretty=1'
resp = Net::HTTP.get_response(URI.parse(url))

resp_text = resp.body

obj = JSON.parse(resp_text)

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|
	resp = Net::HTTP.get_response(URI.parse(url))
	obj = JSON.parse(resp.body)

	# Grab first 8 messages
	messages = obj["messages"][0..7]

	# Replace user id's with actual usernames
	messages.each do |message|
		# For username display
		url = 'https://slack.com/api/users.info?token=' + AUTH_TOKEN + '&user=' + message["user"]
		getUser = Net::HTTP.get_response(URI.parse(url)).body
		user = JSON.parse(getUser)["user"]["name"]
		message["user"] = user

		# For @ mentions
		text = message["text"]
		if text.include? "<@"
			if(text.include? "|")
				text = text.gsub(/<@.*\|(.*)>/, '\1')
			else
				usernameMatch = /<@(\w*)>/.match(text)[1]
				# puts "usernameMatch is " + usernameMatch
				url = 'https://slack.com/api/users.info?token=' + AUTH_TOKEN + '&user=' + usernameMatch
				getUser = Net::HTTP.get_response(URI.parse(url)).body
				user = JSON.parse(getUser)["user"]["name"]
				puts "user is " + user
				text = text.gsub(/<@(\w*)>/, user)
				puts text
			end
			message["text"] = text
		end
	end

  	send_event('slack', { items: messages })
end