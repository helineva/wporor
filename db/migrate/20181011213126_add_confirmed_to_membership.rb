class AddConfirmedToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :confirmed, :boolean

    Membership.all.each do |m|
      m.update_attribute :confirmed, true
    end
  end
end
