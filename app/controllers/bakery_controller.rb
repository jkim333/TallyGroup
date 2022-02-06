class BakeryController < ApplicationController
  def index
    @items = Item.all
  end

  def calculate
    item = params[:item]
    number = params[:number].to_i

    filtered_items = Item.where(code: item)

    response = HTTP.post(
      "https://ugb04f8ek2.execute-api.ap-southeast-2.amazonaws.com/test/",
      json: { filtered_items: filtered_items, number: number })

    if number < 0
      return render json: {
        error: "The number of items must be greater than or equal to 0.",
        output: nil
      }, status: 422
    end

    if filtered_items.count < 1
      return render json: {
        error: "Please select a valid item.",
        output: nil
      }, status: 422
    end

    if response.status.success?
      render json: {
        error: nil,
        output: response.body.to_s
      }
    elsif response.status.client_error?
      render json: {
        error: response.body.to_s,
        output: nil
      }, status: 422
    else
      render json: {
        error: "Something went wrong with the server. Please try again another time.",
        output: nil
      }, status: 500
    end
  end
end
