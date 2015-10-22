class Connector < ActiveRecord::Base
	validates :mug_number, uniqueness: true, presence: true
	validates :channel, uniqueness: true, presence: true
	validates_format_of :user_number, :with => /[+]+[1]+\d{10}/
end
