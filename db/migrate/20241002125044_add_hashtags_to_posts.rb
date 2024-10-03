class AddHashtagsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :hashtags, :string
  end
end
