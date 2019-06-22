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
end
