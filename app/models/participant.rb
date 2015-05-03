class Participant < ActiveRecord::Base
	validates :login, uniqueness: true
	validates :login, presence: true
	validates_with EtuUttLoginValidator, on: :create

	belongs_to :game
	
	has_paper_trail

	def to_param
		login
	end

	
end
