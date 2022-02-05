require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'has a name' do
    item = Item.new(
      name: '',
      code: 'A valid code',
      pack_number: 123,
      pack_price: 123
    )

    expect(item).to_not be_valid
    item.name = 'Has a name'
    expect(item).to be_valid
  end

  it 'has a code' do
    item = Item.new(
      name: 'A valid name',
      code: '',
      pack_number: 123,
      pack_price: 123
    )

    expect(item).to_not be_valid
    item.code = 'Has a code'
    expect(item).to be_valid
  end

  it 'has numerical pack_number' do
    item = Item.new(
      name: 'A valid name',
      code: 'A valid code',
      pack_number: 123,
      pack_price: 123
    )

    expect(item.pack_number).to be_a(Integer)
  end

  it 'has numerical pack_price' do
    item = Item.new(
      name: 'A valid name',
      code: 'A valid code',
      pack_number: 123,
      pack_price: 123
    )

    expect(item.pack_price).to be_a(Integer)
  end
end
