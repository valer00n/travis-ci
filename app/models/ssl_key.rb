class SslKey < ActiveRecord::Base
  VALID_KEYS = {
    :config => 1
  }
  belongs_to :repository
  validates_presence_of :key_type, :repository_id, :public_key, :private_key
  validates_uniqueness_of :key_type, :scope => :repository_id

  before_validation :generate_keys, :on => :create

  def encrypt(string)
    build_key.public_encrypt(string)
  end

  def decrypt(string)
    build_key.private_decrypt(string)
  end

  private
  def generate_keys
    keys = OpenSSL::PKey::RSA.generate(1024)
    self.public_key = keys.public_key
    self.private_key = keys.to_pem
  end

  def build_key
    @build_key ||= OpenSSL::PKey::RSA.new(private_key)
  end
end
