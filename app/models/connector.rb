class Connector < ActiveRecord::Base
	validates :mug_number, uniqueness: true, presence: true
	validates :channel, uniqueness: true, presence: true
	validates_format_of :user_number, :with => /[+]+[1]+\d{10}/, :allow_blank => true

	after_save :announce_user_number_change

	def channel_name
    	client = Slack::Web::Client.new
    	return client.channels_info(channel: self.channel)['channel']['name']
	end

	def announce_user_number_change
    	client = Slack::Web::Client.new
    	client.chat_postMessage text: "I now send messages in this channel to " + self.user_number, channel: self.channel, as_user: true if self.user_number_changed?
	end
end
