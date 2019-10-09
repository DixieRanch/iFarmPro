require 'rails_helper'

describe TokenCreator, :not_a_tenant_model do
  it 'creates a token' do
    token = TokenCreator.call

    expect(token).not_to eq nil
  end

  it 'creates a unique token' do
    token1 = TokenCreator.call
    token2 = TokenCreator.call

    expect(token1).not_to eq token2
  end
end
