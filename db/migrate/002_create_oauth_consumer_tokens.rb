class CreateOauthConsumerTokens < ActiveRecord::Migration
  def self.up

    create_table :consumer_tokens, id: false do |t|
      t.string :user_id, null: false
      t.string :type, :limit => 30
      t.string :token, :limit => 1024 # This has to be huge because of Yahoo's excessively large tokens
      t.string :secret
      t.timestamps
    end

    execute """
      ALTER TABLE consumer_tokens
      ADD CONSTRAINT consumer_tokens_pk
      PRIMARY KEY (token);
    """
  end

  def self.down
    drop_table :consumer_tokens
  end

end
