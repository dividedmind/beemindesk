class BeeminderUsernameNotRequired < ActiveRecord::Migration
  def up
    execute """
      ALTER TABLE beeminder_tokens
      ALTER COLUMN username
      DROP NOT NULL
    """
  end

  def down
    execute """
      ALTER TABLE beeminder_tokens
      ALTER COLUMN username
      SET NOT NULL
    """
  end
end
