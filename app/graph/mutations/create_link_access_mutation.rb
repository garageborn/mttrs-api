CreateLinkAccessMutation = GraphQL::Relay::Mutation.define do
  name 'Create Link Access Mutation'

  input_field :slug, !types.String
  return_field :link, LinkType

  resolve lambda { |_obj, inputs, _ctx|
    link = Link.find(inputs[:slug])
    Link::CreateAccess.run(model: link)
    { link: link }
  }
end
