class TopicsController <ApplicationController

  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index

    @topics = Topic.all.page(params[:page]).order("created_at ASC")
    @topic = Topic.new
  end

  def show
    @topic = Topic.friendly.find(params[:id])
  end

  def new
    @topic = Topic.new
    authorize @topic
  end

  def create
    @topic = current_user.topics.build(topic_params)
    @new_topic = Topic.new
    authorize @topic

    if @topic.save
      flash.now[:success] = "You've created a new topic."

    else
      flash.now[:danger] = @topic.errors.full_messages

    end
  end

    def edit
      @topic = Topic.friendly.find( params[:id])
    end



  def update
    @topic = Topic.friendly.find( params[:id])
    authorize @topic

    if @topic.update(topic_params)
      redirect_to topics_path(@topic)
    else
      redirect_to edit_topic_path(@topic)
    end
  end

  def destroy
    @topic = Topic.friendly.find( params[:id])
    authorize @topic
    if @topic.destroy
      redirect_to topics_path
    else
      redirect_to topic_path(@topic)
    end
  end

  def new
   @topic = Topic.new
   authorize @topic
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :description, :image)
  end

end
