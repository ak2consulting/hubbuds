class RenameProjectsId < ActiveRecord::Migration
	def self.up
		rename_column :yammer_posts, :github_projects_id, :github_project_id
	end

	def self.down
	end
end
