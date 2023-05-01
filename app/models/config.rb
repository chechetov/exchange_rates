class Config < ApplicationRecord
	validates :url, :apikey, presence: true
end