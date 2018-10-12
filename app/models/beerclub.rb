class Beerclub < ActiveRecord::Base
  has_many :memberships_and_applications, class_name: 'Membership'
  has_many :memberships, -> { where confirmed: true }
  has_many :applications, -> { where confirmed: false }, class_name: 'Membership'
  has_many :members_and_applicants, through: :memberships, source: :user

  def to_s
    "#{name} (#{city})"
  end
end
