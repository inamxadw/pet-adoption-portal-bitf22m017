class AddOwnerToPets < ActiveRecord::Migration[8.0]
  def change
    add_reference :pets, :owner, null: false, foreign_key: { to_table: :users }
  end
end
