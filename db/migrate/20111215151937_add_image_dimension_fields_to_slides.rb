class AddImageDimensionFieldsToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :image_width, :integer
    add_column :slides, :image_height, :integer
  end
end
