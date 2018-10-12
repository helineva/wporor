class AddGithubToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github, :boolean

    User.all.each do |u|
      u.update_attribute :github, false
    end
  end
end
