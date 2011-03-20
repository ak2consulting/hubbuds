class GithubProjectsController < ApplicationController
	#POST /push_update
	def push_update
		the_update = JSON.parse params[:payload]
		
		@github_project = GithubProject.find_by_url payload['repository']['url']
		#what to do if github project not found?
		
		#lovingly stolen from https://github.com/github/github-services/blob/master/services/yammer.rb
		#TODO: LINK BACK HERE
		repository = payload['repository']['name']
		statuses=[]
		if data['digest'] == '1'
			commit = payload['commits'][-1]
			statuses << "@#{commit['author']['name']} pushed #{payload['commits'].length}.to {repository}. check it out at <todo: link>"
		else
			payload['commits'].each do |commit|
				statuses << "@#{commit['author']['name']} updated #{repository}: \"#{commit['message']}\". check it out at <todo: link>"
			end
		end
		
		
		yammer = Yammer::Client.new(:config=>$yammer_config)
		statuses.each do |status| 
			resp=yammer.message(:post, :body => status)
			#error catch, maybe?
			posted_message = JSON.parse resp.body
			YammerPost.create( :yammer_id=>posted_message["messages"][0]["id"], :github_project=>@github_project)
		end
	end
	
	# GET /github_projects
	# GET /github_projects.xml
	def index
		@github_projects = GithubProject.all

		respond_to do |format|
			format.html # index.html.erb
			format.xml	{ render :xml => @github_projects }
		end
	end

	# GET /github_projects/1
	# GET /github_projects/1.xml
	def show
		@github_project = GithubProject.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.xml	{ render :xml => @github_project }
		end
	end

	# GET /github_projects/new
	# GET /github_projects/new.xml
	def new
		@github_project = GithubProject.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml	{ render :xml => @github_project }
		end
	end

	# GET /github_projects/1/edit
	def edit
		@github_project = GithubProject.find(params[:id])
	end

	# POST /github_projects
	# POST /github_projects.xml
	def create
		@github_project = GithubProject.new(params[:github_project])

		respond_to do |format|
			if @github_project.save
				format.html { redirect_to(@github_project, :notice => 'Github project was successfully created.') }
				format.xml	{ render :xml => @github_project, :status => :created, :location => @github_project }
			else
				format.html { render :action => "new" }
				format.xml	{ render :xml => @github_project.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /github_projects/1
	# PUT /github_projects/1.xml
	def update
		@github_project = GithubProject.find(params[:id])

		respond_to do |format|
			if @github_project.update_attributes(params[:github_project])
				format.html { redirect_to(@github_project, :notice => 'Github project was successfully updated.') }
				format.xml	{ head :ok }
			else
				format.html { render :action => "edit" }
				format.xml	{ render :xml => @github_project.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /github_projects/1
	# DELETE /github_projects/1.xml
	def destroy
		@github_project = GithubProject.find(params[:id])
		@github_project.destroy

		respond_to do |format|
			format.html { redirect_to(github_projects_url) }
			format.xml	{ head :ok }
		end
	end
end
