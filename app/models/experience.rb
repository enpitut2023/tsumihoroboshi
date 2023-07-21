class Experience < ApplicationRecord
  belongs_to :user
  LEVEL_UP_EXPERIENCE = 100
end
