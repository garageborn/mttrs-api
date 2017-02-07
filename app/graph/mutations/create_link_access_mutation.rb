CreateLinkAccessMutation = GraphQL::Relay::Mutation.define do
  name 'CreateLinkAccessMutation'

  input_field :slug, !types.String
  return_field :link, LinkType

  resolve lambda { |_obj, inputs, _ctx|
    link = Link.find(inputs[:slug])
    Link::CreateAccess.run(model: link)
    { link: link }
  }
end
