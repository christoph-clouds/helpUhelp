class StatusTaskUser < ApplicationRecord
  belongs_to :user
  belongs_to :task
  belongs_to :status

  scope :pending, -> { where(status_id: 1) }
  scope :confirmed, -> { where(status_id: 3) }
end
