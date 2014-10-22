class AddDefaultImageToAllUsers < ActiveRecord::Migration
  def change
    change_column :users, :image_path, :string, default: 'https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg?sz=50'
  end
end
