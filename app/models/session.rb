class Session < ApplicationRecord
  # Backed by `user_sessions` (see the CreateSessions migration for why the bare
  # `sessions` name is avoided).
  self.table_name = "user_sessions"

  belongs_to :user
end
