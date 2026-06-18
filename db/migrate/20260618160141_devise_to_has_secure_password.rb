class DeviseToHasSecurePassword < ActiveRecord::Migration[8.1]
  def change
    # has_secure_password requires the column to be named password_digest.
    # devise stored its bcrypt hash in encrypted_password; bcrypt hashes are
    # compatible between the two, so renaming preserves existing passwords.
    rename_column :users, :encrypted_password, :password_digest

    # Drop devise :recoverable columns. Password resets now use signed, stateless
    # tokens via User.generates_token_for, so no DB column is needed.
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime

    # Drop devise :rememberable / :trackable columns. The session-based auth
    # tracks logins through the user_sessions table instead.
    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer, null: false, default: 0
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :string
    remove_column :users, :last_sign_in_ip, :string

    # Drop devise :confirmable columns. Not replaced (no email confirmation flow).
    remove_column :users, :confirmation_token, :string
    remove_column :users, :confirmed_at, :datetime
    remove_column :users, :confirmation_sent_at, :datetime
    remove_column :users, :unconfirmed_email, :string

    # Drop devise :lockable columns. Brute-force protection now lives at the
    # request layer (login throttling), not on the user record.
    remove_column :users, :failed_attempts, :integer, null: false, default: 0
    remove_column :users, :unlock_token, :string
    remove_column :users, :locked_at, :datetime
  end
end
