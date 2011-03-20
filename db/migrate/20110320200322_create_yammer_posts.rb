class CreateYammerPosts < ActiveRecord::Migration
	def self.up
		create_table :yammer_posts do |t|
		t.string :yammer_id
		t.string :user
		t.references :github_projects

		t.timestamps
	end
end

	def self.down
		drop_table :yammer_posts
	end
end
