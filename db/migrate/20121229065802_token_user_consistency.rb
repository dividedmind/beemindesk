class TokenUserConsistency < ActiveRecord::Migration
  def up
    execute """
      ALTER TABLE consumer_tokens
      ADD CONSTRAINT token_user_fk
      FOREIGN KEY (user_id)
      REFERENCES users(id);
      
      ALTER TABLE consumer_tokens
      ALTER COLUMN user_id
      SET NOT NULL;
    """
  end
end
