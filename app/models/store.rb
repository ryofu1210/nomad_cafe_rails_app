# == Schema Information
#
# Table name: stores
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  long_stay        :integer          not null
#  consent          :boolean          not null
#  wifi             :boolean          not null
#  wifi_description :text
#  comment          :text
#  user_id          :bigint
#  status           :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image            :string
#

class Store < ApplicationRecord
  belongs_to :user
  has_many :favorites
  has_many :favorited_user, through: :favorites, source: :user

  mount_uploader :image, StoreImageUploader
  validates :name, presence: true, length: {maximum: 100}
  validates :long_stay, presence: true
  validates :consent, presence: true
  validates :wifi, presence: true
  validates :wifi_description, length: {maximum: 200}
  validates :comment, length: {maximum: 200}
  validates :status, presence: true

  scope :active, -> { where(status: 0) }
  scope :sorted, -> { order(updated_at: :desc) }
  scope :favorite, -> (user) { where(user_id: user.id) if user}

  # enum long_stay: { level_1: 1, level_2: 2, level_3: 3, level_4: 4, level_5: 5}
  enum consent: { consent_ari: true, consent_nashi: false}
  enum wifi: { wifi_ari: true, wifi_nashi: false}

  def self.search(search = nil)
    return Store.active.sorted unless search
    Store.where("name like ? OR comment like ?", "%#{search}%", "%#{search}%").active.sorted
  end

end
