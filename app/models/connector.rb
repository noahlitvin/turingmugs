class Connector < ActiveRecord::Base
	validates :mug_number, uniqueness: true, presence: true
	validates :channel, uniqueness: true, presence: true
	validates_format_of :user_number, :with => /[+]+[1]+\d{10}/, :allow_blank => true

	after_save :announce_user_number_change

	def announce_user_number_change
    	connector = Slack::Web::Client.new
    	connector.message text: "I now send messages in this channel to " + connector.user_number, channel: connector.channel if connector.status_changed?
	end
end
