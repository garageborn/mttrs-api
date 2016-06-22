class Cluster < ActiveRecord::Base
  has_many :stories, inverse_of: :cluster, dependent: :destroy
end
