class Pet < ApplicationRecord
  class NameTaken < StandardError; end

  validates :name, uniqueness: true, strict: NameTaken
end
