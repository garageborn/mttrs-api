CreateLinkAccessMutation = GraphQL::Relay::Mutation.define do
  name 'Create Link Access Mutation'

  input_field :link_id, !types.ID
  return_field :link, LinkType

  resolve -> (_obj, inputs, _ctx) {
    link = Link.find(inputs[:link_id])
    Access::Create.run(access: { accessable_type: 'Link', accessable_id: link.id })
    { link: link }
  }
end
