

RSpec.describe "Load Ruby provider" do

  it 'load Ruby provider into the env' do
    
    require 'binenc/ruby'

    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

  end

end
