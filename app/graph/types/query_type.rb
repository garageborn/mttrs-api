require Rails.root.join('lib', 'graphql_cache')

class Viewer < Struct.new :id
  # HACK:// For relay root queries
  STATIC = new(id: 'root').freeze

  def self.find(_)
    STATIC
  end
end

QueryType = GraphQL::ObjectType.define do
  name 'Mttrs'

  field :node, GraphQL::Relay::Node.field

  # Hack until relay has lookup for root fields
  field :root, ViewerType do
    description 'Root object to get viewer related collections'
    resolve -> (obj, args, ctx) { Viewer::STATIC }
  end
end
