LinkImageType = GraphQL::ObjectType.define do
  name 'LinkImageType'

  field :original, types.String do
    resolve Resolvers::LinkImageType::Original
  end

  field :thumb, types.String do
    resolve Resolvers::LinkImageType::Thumb
  end
end
