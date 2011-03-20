class CreateGithubProjects < ActiveRecord::Migration
	def self.up
		create_table :github_projects do |t|
			t.string :url
			
			t.timestamps
		end
	end

	def self.down
		drop_table :github_projects
	end
end
