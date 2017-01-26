class GraphqlController < ApplicationController
  def create
    query_string = params[:query]
    query_variables = params[:variables] || {}

    result = MttrsSchema.execute(query_string, variables: query_variables)
    render json: result
  end
end
