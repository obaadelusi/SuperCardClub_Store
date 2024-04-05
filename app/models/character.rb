class Character < ApplicationRecord
  belongs_to :publisher
  belongs_to :alignment
  belongs_to :race
end
