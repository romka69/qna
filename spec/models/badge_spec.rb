require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to :question }

  it 'have one attached img' do
    expect(Badge.new.img).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it { should validate_presence_of :name }
end
