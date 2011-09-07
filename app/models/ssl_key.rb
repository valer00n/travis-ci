class SslKey < ActiveRecord::Base
  VALID_KEYS = {
    :config => 1
  }
  belongs_to :repository
  validates_presence_of :key_type, :repository_id, :public_key, :private_key
  validates_uniqueness_of :key_type, :scope => :repository_id

  before_validation :generate_keys, :on => :create

  private
  def generate_keys
    keys = OpenSSL::PKey::RSA.generate(1024)
    self.public_key = keys.public_key
    self.private_key = keys.to_pem
  end
end
