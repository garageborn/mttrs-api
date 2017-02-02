class GraphqlController < ApplicationController
  include Concerns::GraphqlCache

  def create
    query_string = params[:query]
    query_variables = params[:variables].present? ? params[:variables] : {}

    result = MttrsSchema.execute(
      query_string,
      variables: query_variables,
      context: { controller: self }
    )
    render json: result
  end
end
