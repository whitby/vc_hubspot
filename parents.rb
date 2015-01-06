require 'json'
require 'rest-client'
require "slack-notify"
require 'yaml'
require 'date'

# Gets all the parents that have been updated in the last day and updates HubSpot contacts.

one_day_ago=Date.parse("#{DateTime.now-1}")
def read_config
  config = YAML.load_file("config.yaml")
  @username = config["veracross"]["username"]
  @password = config["veracross"]["password"]
  @client = config["veracross"]["client"]
  @webhook_url = config["slack"]["webhook_url"]
  @hapikey = config["hubspot"]["hapikey"]
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
all_parents = RestClient.get("https://#{@username}:#{@password}@api.veracross.com/#{@client}/v1/parents.json?option=1&updated_after=#{one_day_ago}")
list = []
JSON.parse(all_parents).each do |parent|
  unless parent['email_1'].nil?
    list << {
      :email => parent['email_1'],
      :properties => [
        {
          :property => 'whitby_parent',
          :value => 'current_parent'
        },
        {
          :property => 'csource',
          :value => 'veracross_api'
        },
        {
          :property => 'household_fk',
          :value => parent['household_fk']
        },
        {
          :property => 'firstname',
          :value => parent['first_name']
        },
        {
          :property => 'lastname',
          :value => parent['last_name']
        }
      ]
    }
  else
    message = "*Missing Email*: #{parent['first_name']} #{parent['last_name']}"
    client.notify(message) #slack notification
  end
end

hubspot_url = "http://api.hubapi.com/contacts/v1/contact/batch/?hapikey=#{@hapikey}"
RestClient.post hubspot_url, list.to_json, :content_type => :json, :accept => :json
