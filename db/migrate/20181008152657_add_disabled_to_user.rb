class AddDisabledToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :disabled, :boolean

    User.all.each do |u|
      u.update_attribute :disabled, false
    end
  end
end
