class Story
  class Index < Trailblazer::Operation
    include Collection

    def model!(_params)
      ::Story.all.limit(10)
    end
  end
end
