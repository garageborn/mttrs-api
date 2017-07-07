PublisherIconType = GraphQL::ObjectType.define do
  name 'PublisherIconType'

  field :original, !types.String do
    resolve ->(obj, _args, _ctx) { obj.url }
  end

  field :xsmall, !types.String do
    resolve ->(obj, _args, _ctx) { obj.url(:xsmall) }
  end

  field :small, !types.String do
    resolve ->(obj, _args, _ctx) { obj.url(:small) }
  end

  field :medium, !types.String do
    resolve ->(obj, _args, _ctx) { obj.url(:medium) }
  end
end