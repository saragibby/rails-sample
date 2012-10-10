class CreateUserProspects < ActiveRecord::Migration
  def change
    create_table :user_prospects do |t|
      t.string  :email
      t.timestamps
    end
  end
end
