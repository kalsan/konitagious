class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    # NOTE: table is `user_sessions`, not `sessions`. The bare `sessions` name is
    # conventionally owned by the request/cookie session store; keeping the auth
    # session model on its own table avoids any future clash. The model maps back
    # to this table via `Session.table_name` (see app/models/session.rb).
    create_table :user_sessions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :ip_address
      t.string :user_agent
      # Whether this session opted into a persistent ("Stay signed in") cookie.
      t.boolean :remember, null: false, default: false

      t.timestamps
    end
  end
end
