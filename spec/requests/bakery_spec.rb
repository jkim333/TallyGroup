require 'rails_helper'

RSpec.describe "Bakeries", type: :request do
  before(:all) do
    Item.create(name: "Vegemite Scroll", code: "VS5", pack_number: 3, pack_price: 699)
    Item.create(name: "Vegemite Scroll", code: "VS5", pack_number: 5, pack_price: 899)
    Item.create(name: "Blueberry Muffin", code: "MB11", pack_number: 2, pack_price: 995)
    Item.create(name: "Blueberry Muffin", code: "MB11", pack_number: 5, pack_price: 1695)
    Item.create(name: "Blueberry Muffin", code: "MB11", pack_number: 8, pack_price: 2495)
    Item.create(name: "Croissant", code: "CF", pack_number: 3, pack_price: 595)
    Item.create(name: "Croissant", code: "CF", pack_number: 5, pack_price: 995)
    Item.create(name: "Croissant", code: "CF", pack_number: 9, pack_price: 1699)
  end

  after(:all) do
    Item.delete_all
  end

  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end

    it "returns all items" do
      get "/"
      expect(assigns(:items).size).to eq(8)
    end
  end

  describe "POST /calculate" do
    it "returns error if the number of items is negative" do
      post "/calculate", params: { item: 'VS5', number: -1 }
      expect(response).to have_http_status(422)
      response_body = JSON.parse(response.body)
      expect(response_body["error"]).to eq("The number of items must be greater than or equal to 0.")
      expect(response_body["output"]).to eq(nil)
    end

    it "returns error if invalid item code is provided" do
      post "/calculate", params: { item: 'invalid', number: 10}
      expect(response).to have_http_status(422)
      response_body = JSON.parse(response.body)
      expect(response_body["error"]).to eq("Please select a valid item.")
      expect(response_body["output"]).to eq(nil)
    end

    it "returns error if problem could not be solved with the provided input" do
      post "/calculate", params: { item: 'VS5', number: 1 }
      expect(response).to have_http_status(422)
      response_body = JSON.parse(response.body)
      expect(response_body["error"]).to eq("The problem could not be solved. Please try again with different input.")
      expect(response_body["output"]).to eq(nil)
    end

    it "returns correct output for 10 VS5" do
      post "/calculate", params: { item: 'VS5', number: 10 }

      expect(response).to have_http_status(:success)

      request_body = JSON.parse(response.body)
      request_body_output = JSON.parse(request_body["output"])

      expect(request_body["error"]).to eq(nil)
      expect(request_body_output.size).to eq(2)

      pack_number_3 = request_body_output.detect {|item| item["pack_number"] == 3}
      pack_number_5 = request_body_output.detect {|item| item["pack_number"] == 5}

      expect(pack_number_3["quantity"]).to eq(0)
      expect(pack_number_5["quantity"]).to eq(2)

      total_price = pack_number_3["quantity"] * pack_number_3["pack_price"] +
                    pack_number_5["quantity"] * pack_number_5["pack_price"]

      expect(total_price).to eq(1798)
    end

    it "returns correct output for 14 MB11" do
      post "/calculate", params: { item: 'MB11', number: 14 }

      expect(response).to have_http_status(:success)

      request_body = JSON.parse(response.body)
      request_body_output = JSON.parse(request_body["output"])

      expect(request_body["error"]).to eq(nil)
      expect(request_body_output.size).to eq(3)

      pack_number_2 = request_body_output.detect {|item| item["pack_number"] == 2}
      pack_number_5 = request_body_output.detect {|item| item["pack_number"] == 5}
      pack_number_8 = request_body_output.detect {|item| item["pack_number"] == 8}

      expect(pack_number_2["quantity"]).to eq(3)
      expect(pack_number_5["quantity"]).to eq(0)
      expect(pack_number_8["quantity"]).to eq(1)

      total_price = pack_number_2["quantity"] * pack_number_2["pack_price"] +
                    pack_number_5["quantity"] * pack_number_5["pack_price"] +
                    pack_number_8["quantity"] * pack_number_8["pack_price"]

      expect(total_price).to eq(5480)
    end

    it "returns correct output for 13 CF" do
      post "/calculate", params: { item: 'CF', number: 13 }

      expect(response).to have_http_status(:success)

      request_body = JSON.parse(response.body)
      request_body_output = JSON.parse(request_body["output"])

      expect(request_body["error"]).to eq(nil)
      expect(request_body_output.size).to eq(3)

      pack_number_3 = request_body_output.detect {|item| item["pack_number"] == 3}
      pack_number_5 = request_body_output.detect {|item| item["pack_number"] == 5}
      pack_number_9 = request_body_output.detect {|item| item["pack_number"] == 9}

      expect(pack_number_3["quantity"]).to eq(1)
      expect(pack_number_5["quantity"]).to eq(2)
      expect(pack_number_9["quantity"]).to eq(0)

      total_price = pack_number_3["quantity"] * pack_number_3["pack_price"] +
                    pack_number_5["quantity"] * pack_number_5["pack_price"] +
                    pack_number_9["quantity"] * pack_number_9["pack_price"]

      expect(total_price).to eq(2585)
    end
  end
end
