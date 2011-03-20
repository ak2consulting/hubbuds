class GithubProject < ActiveRecord::Base
	has_many :yammer_posts
end
