require 'spec_helper'
describe 'dar' do

  context 'with defaults for all parameters' do
    it { should contain_class('dar') }
  end
end
