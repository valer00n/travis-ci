require 'spec_helper'

describe SslKey do
  let(:repository) { Factory(:repository, :name => "ssl_key") }
  let(:ssl_key) { repository.get_or_create_config_key }

  describe "key type" do
    it "should not have the same key_type for one repository" do
      key = SslKey.new(:key_type => ssl_key.key_type, :repository_id => repository.id)
      key.should have(1).error_on(:key_type)
    end

    it "should accept twice the same key_type for two repositories" do
      key = Factory(:repository).get_or_create_config_key
      key.key_type.should eql(ssl_key.key_type)
    end
  end

  describe "generate keys" do

    it "should generate the public key" do
      ssl_key.reload.public_key.should_not be_nil
    end

    it "should generate the private key" do
      ssl_key.reload.private_key.should_not be_nil
    end
  end
end
