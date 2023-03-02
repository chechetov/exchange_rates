class Currency < ApplicationRecord
	self.primary_key = :code
	has_many :rates, foreign_key: :base, primary_key: :code
	validates :code, :desc, presence: true
end