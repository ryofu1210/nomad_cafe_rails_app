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
#

class Store < ApplicationRecord
  belongs_to :user
  has_many :favorites
  has_many :favorited_user, throuth: :favorites, source: :user
end
