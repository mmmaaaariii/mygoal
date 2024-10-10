class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  validates :email, :password, presence: true

end
