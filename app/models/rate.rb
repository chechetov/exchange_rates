class Rate < ApplicationRecord
	belongs_to :currency, class_name: "Currency", foreign_key: :base, primary_key: :code
	validates :date, :rate, :base, :to, presence: true
end
