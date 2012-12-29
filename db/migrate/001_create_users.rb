class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users, id: false do |t|
      t.string :id
    end
    
    execute """
      ALTER TABLE users
      ADD CONSTRAINT users_pk
      PRIMARY KEY (id)
    """
  end
  
  def down
    drop_table :users
  end
end
