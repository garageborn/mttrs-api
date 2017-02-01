class GraphqlController < ApplicationController
  def create
    query_string = params[:query]
    query_variables = params[:variables].present? ? params[:variables] : {}

    result = MttrsSchema.execute(query_string, variables: query_variables, context: { batata: 10 })

    expires_in 1.minutes, public: true
    render json: result
  end
end
