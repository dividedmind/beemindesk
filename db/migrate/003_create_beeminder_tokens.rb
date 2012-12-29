class CreateBeeminderTokens < ActiveRecord::Migration
  def up
    create_table :beeminder_tokens, id: false do |t|
      t.string :user_id
      t.string :username, null: false
      t.string :access_token, null: false
    end
    
    execute """
      ALTER TABLE beeminder_tokens
      ADD CONSTRAINT beeminder_tokens_pk
      PRIMARY KEY (user_id);
    """
  end
  
  def down
    drop_table :beeminder_tokens
  end
end
