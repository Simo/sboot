require 'spec_helper'
require 'sboot/cli'

describe Sboot::CLI do

  it 'has a version number' do
    expect(Sboot::VERSION).not_to be nil
  end

end
