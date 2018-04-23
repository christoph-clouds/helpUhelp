class User < ApplicationRecord
  belongs_to :role
  has_and_belongs_to_many :tasks
  has_secure_password
end
