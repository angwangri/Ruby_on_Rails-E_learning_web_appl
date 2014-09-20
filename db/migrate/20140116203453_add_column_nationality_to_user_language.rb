class AddColumnNationalityToUserLanguage < ActiveRecord::Migration
  def change
    add_column :user_languages, :nationality, :string
  end
end
