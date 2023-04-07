module Admin
  class WelcomeController < Admin::ApplicationController
    def index
      @daily_threads = if User.staff_account
                         Article.where("title LIKE 'Welcome Thread - %'").where(user_id: User.staff_account&.id)
                       else
                         []
                       end
      render layout: "admin"
    end

    def create
      @article = Article.new(
        user: User.staff_account,
        body_markdown: welcome_thread_content,
      )

      @version = @article.has_frontmatter? ? "v1" : "v2"
      @user = @article.user
      @organizations = @user&.organizations
      @user_approved_liquid_tags = Users::ApprovedLiquidTags.call(@user)

      render "articles/edit"
    end

    private

    def welcome_thread_content
      I18n.t("admin.welcome_controller.thread_content",
             community: ::Settings::Community.community_name)
    end
  end
end
