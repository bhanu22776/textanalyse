class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    
    @comment = Comment.new
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    
    logger.info "$$$$$$$$$$$$$$$$$#{@comment.message}"

    # Using Sentimentalizer to get probability and sentiment of message
    
    sentiment_json = Sentimentalizer.analyze("#{@comment.message}") # it gives json output
    sentiment_hash = JSON.parse(sentiment_json) # parsing json to hash

    logger.info "&&&&&&&&&&&&&&&&&&&&#{sentiment_hash}"

    probability = sentiment_hash["probability"]
    sentiment = sentiment_hash["sentiment"]

    # End of Sentimentalizer

    # Using Sadpanda to get emotion and polarity of message
    
    emotion = SadPanda.emotion("#{@comment.message}")
    polarity = SadPanda.polarity("#{@comment.message}")

    # End of Sadpanda

    # parsing values to object
    @comment.probability = probability
    @comment.sentiment = sentiment
    @comment.emotion = emotion
    @comment.polarity = polarity

    respond_to do |format|
      if @comment.save
        format.html { redirect_to :back, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end
end
