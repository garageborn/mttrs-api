module ElasticsearchHelper
  def build_elasticsearch_response(class_name, records)
    response = {
      hits: {
        hits: records.map { |record| { _id: record.id } }
      }
    }
    search = Elasticsearch::Model::Searching::SearchRequest.new(class_name, '*')
    allow(search).to receive(:execute!).and_return(response)
    Elasticsearch::Model::Response::Response.new(class_name, search)
  end
end

RSpec.configure do |config|
  config.include ElasticsearchHelper
end
