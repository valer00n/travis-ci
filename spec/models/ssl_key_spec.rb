require 'spec_helper'

describe SslKey do
  let(:repository) { Factory(:repository, :name => "ssl_key") }
  let(:ssl_key) { repository.get_or_create_config_key }

  it "should have ssl keys" do
    SslKey::VALID_KEYS.should_not be_empty
  end

  describe "encrypt" do
    it "should encrypt something" do
      ssl_key.encrypt("hello").should_not be_nil
      ssl_key.encrypt("hello").should_not eql("hello")
    end

    it "should be decryptable" do
      encrypted = ssl_key.encrypt("hello")
      ssl_key.decrypt(encrypted).should eql("hello")
    end
  end

  describe "decrypt" do
    it "should decrypt something" do
      encrypted_string = ssl_key.encrypt("hello world")
      ssl_key.decrypt(encrypted_string).should_not be_nil
      ssl_key.decrypt(encrypted_string).should_not eql("hello")
    end
  end


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
