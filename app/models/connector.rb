class Connector < ActiveRecord::Base
	validates :mug_number, uniqueness: true
	validates :channel, uniqueness: true
end
