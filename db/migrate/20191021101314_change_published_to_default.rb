class ChangePublishedToDefault < ActiveRecord::Migration[5.1]
  def up
    change_column :posts, :published, :boolean, default: false
  end
  
  def down
    change_column :posts, :published, :boolean, default: false
  end
end
