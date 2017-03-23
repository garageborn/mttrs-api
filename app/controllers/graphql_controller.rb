class GraphqlController < ApplicationController
  include Concerns::GraphqlCache
  before_action :parse_query_variables

  def create
    batata
    result = MttrsSchema.execute(
      @query_string,
      variables: @query_variables,
      context: { controller: self }
    )
    render json: result
  end

  private

  def parse_query_variables
    @query_string = params[:query]
    @query_variables = case params[:variables]
                       when String then JSON.parse(params[:variables])
                       when NilClass then {}
                       else params[:variables]
                       end
  end
end
