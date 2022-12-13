class AddNewsPostingAuthToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :news_posting_auth, :boolean, default: false, null: false, after: :employee_info_manage_auth
  end
end
