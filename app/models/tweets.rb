class Tweet
  include Mongoid::Document
  store_in collection: "tweets", database: "other"
  field :text, type: String
  field :user, type: String
  field :coordinates, type: Array
  field :created_at, type: DateTime
  
  index({ coordinates: "2d" }, { min: -180, max: 180 })
  index({ created_at: 1}, {unique: true})
end