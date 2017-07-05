LinkImageType = GraphQL::ObjectType.define do
  name 'LinkImageType'

  field :original, types.String do
    resolve lambda { |obj, _args, _ctx| obj.url }
  end

  field :thumb, types.String do
    resolve lambda { |obj, _args, _ctx| obj.url(:thumb) }
  end
end
