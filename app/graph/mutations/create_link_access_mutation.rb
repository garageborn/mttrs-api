CreateLinkAccessMutation = GraphQL::Relay::Mutation.define do
  name 'Create Link Access Mutation'

  input_field :link_id, !types.ID
  return_field :link, LinkType

  resolve lambda { |_obj, inputs, _ctx|
    link = Link.find(inputs[:link_id])
    Link::CreateAccess.run(model: link)
    { link: link }
  }
end
