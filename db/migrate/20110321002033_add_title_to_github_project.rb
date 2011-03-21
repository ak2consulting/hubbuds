class AddTitleToGithubProject < ActiveRecord::Migration
  def self.up
		add_column :github_projects, :name, :string
		add_column :github_projects, :description, :text
  end

  def self.down
		remove_column :github_projects, :name
		remove_column :github_projects, :description
  end
end
