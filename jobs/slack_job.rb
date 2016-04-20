## NEXT STEPS:
# - Show horizontal rules for date lines
# - Show the different channels? #technical, #general, #
require 'net/http'
require 'json'
require 'pp'
require 'websocket-client-simple' # see https://github.com/shokai/websocket-client-simple
require './assets/ringbuffer'


AUTH_TOKEN = open('assets/.auth_token').read

rtm_url = 'https://slack.com/api/rtm.start?token=' + AUTH_TOKEN + '&pretty=1'
resp = Net::HTTP.get_response(URI.parse(rtm_url))
rtm_obj = JSON.parse(resp.body)
ws_url = rtm_obj["url"]
ws = WebSocket::Client::Simple.connect ws_url
prev_msg = ""

messages = RingBuffer.new(5)

def get_user(user_id)
    url = 'https://slack.com/api/users.info?token=' + AUTH_TOKEN + '&user=' + user_id
    getUser = Net::HTTP.get_response(URI.parse(url)).body
    return JSON.parse(getUser)["user"]["name"]
end

def sanitize_text(text)
    user_re = /<@(\w*)>/
    matches = text.scan(user_re)
    if matches then
        matches.each do |match|
            text = text.sub("<@"+match[0]+">", get_user(match[0]))
        end
    end
    return text
end

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|

    ws.on :message do |msg|
        if msg == prev_msg
            next
        else
            prev_msg = msg
        end

        event = JSON.parse(msg.data)
        user = get_user(event["user"])

        if event["type"] == "message"
            messages << {"user" => user, "text" => sanitize_text(event["text"])}
        elsif event["type"] == "user_typing"
            messages << {"user" => user, "text" => user + " is typing..."}
        elsif event["type"] == "presence_change"
            messages << {"user" => user, "text" => user + "'s presence changed to " + event["presence"]}
        end
    end

    send_event('slack', { items: messages })
end