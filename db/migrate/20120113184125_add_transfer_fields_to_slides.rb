class AddTransferFieldsToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :transfer_to_slide_id, :integer
    add_column :slides, :transfer_wait, :integer
  end
end
