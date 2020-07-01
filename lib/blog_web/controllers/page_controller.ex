defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  alias Blog.Posts

  action_fallback BlogWeb.FallbackController

  def index(conn, _params) do
    posts = Posts.all_posts()
    render(conn, "index.html", posts: posts)
  end

  def get(conn, %{ "id" => id }) do
    with {:ok, post} <- Posts.get_post_by_id(id) do
      render(conn, "post.html", post: post)
    end
  end

  def tag(conn, %{ "tag" => tag }) do
    with {:ok, posts} <- Posts.get_posts_by_tag(tag) do
      render(conn, "index.html", posts: posts)
    end
  end

  def date(conn, %{"month" => month, "year" => year}) do
    iyear  = String.to_integer(year)
    imonth = String.to_integer(month)
    with {:ok, posts} <- Posts.get_posts_by_date(iyear, imonth) do
      render(conn, "index.html", posts: posts)
    end
  end
end
