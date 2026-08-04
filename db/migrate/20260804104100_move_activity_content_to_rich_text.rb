class MoveActivityContentToRichText < ActiveRecord::Migration[8.0]
  def up
    select_all("SELECT id, content FROM activities").each do |activity|
      execute(ActiveRecord::Base.sanitize_sql_array([
        "INSERT INTO action_text_rich_texts (name, body, record_type, record_id, created_at, updated_at)
				VALUES ('content', ? , 'Activity', ? , CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
        activity['content'], activity['id']
      ]))
    end
    remove_column :activities, :content, :text
  end

  def down
    add_column :activities, :content, :text
  end
end
