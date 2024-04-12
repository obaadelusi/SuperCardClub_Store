class PagesController < InheritedResources::Base

  def show
    @page = Page.find_by(slug: params[:slug])
    puts @page
  end

  private

    def page_params
      params.require(:page).permit(:title, :content)
    end

end
