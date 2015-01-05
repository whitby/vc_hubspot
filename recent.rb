require 'json'
require 'rest-client'
require "slack-notify"
require 'yaml'
def read_config
  config = YAML.load_file("config.yaml")
  @username = config["veracross"]["username"]
  @password = config["veracross"]["password"]
  @client = config["veracross"]["client"]
  @webhook_url = config["slack"]["webhook_url"]
end
read_config
# Initialize Slack WebHook
client = SlackNotify::Client.new(
  webhook_url: @webhook_url,
  channel: "#it-veracross",
  username: "Vera",
  icon_emoji: ":raising_hand:",
  link_names: 1
)


# Veracross API URLs
recent_alumni = RestClient.get("https://#{@username}:#{@password}@api.veracross.com/#{@client}/v1/alumni/recent.json?option=1")
recent_parents = RestClient.get("https://#{@username}:#{@password}@api.veracross.com/#{@client}/v1/parents/recent.json?option=1")
recent_students = RestClient.get("https://#{@username}:#{@password}@api.veracross.com/#{@client}/v1/students/recent.json?option=1")
#TODO: parse for errors
puts @username
#Unless the list is empty, notify Slack channel
unless JSON.parse(recent_students).empty?
  JSON.parse(recent_students).each do |student|
    unless student['new_student'] == true
      message = "*Updated Student*: #{student['first_name']} #{student['last_name']}"
      client.notify(message) #slack notification
    else
      # If new student
      message = "*New Student*: #{student['first_name']} #{student['last_name']}"
      client.notify(message)
    end
  end
end
unless JSON.parse(recent_parents).empty?
  JSON.parse(recent_parents).each do |parent|
    message = "*Updated Parent*: #{parent['first_name']} #{parent['last_name']}"
    client.notify(message)
  end
end
unless JSON.parse(recent_alumni).empty?
  JSON.parse(recent_alumni).each do |alumni|
    message = "*Recent Alumni*: #{alumni['first_name']} #{alumni['last_name']}"
    client.notify(message)
  end
end
