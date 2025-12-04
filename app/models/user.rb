class User < ApplicationRecord
    # this is not an actual model! it just defines things used by the patient/doctor/admin models
    self.abstract_class = true

    # all core attributes must be present
    validates :email, :username, :password, presence: true
    # must have unique email and username
    validates :email, uniqueness: true
    validates :username, uniqueness: true
    # md5 hashes are always 32 chars, anything shorter or longer is not hashed
    validates :password, length: {is: 32}
    # compare to hash of empty string to prevent blank passwords
    validates :password, comparison: {other_than: Digest::MD5.hexdigest(''), message: 'cannot be blank'}
end