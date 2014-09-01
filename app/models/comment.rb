class Comment < ActiveRecord::Base
  attr_accessible :emotion, :message, :polarity, :probability, :sentiment
end