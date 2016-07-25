class Feed
  class Index < Trailblazer::Operation
    include Collection

    def model!(_params)
      ::Feed.all.limit(10)
    end
  end
end
