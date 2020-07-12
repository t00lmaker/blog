defmodule Blog.Posts do

  use NimblePublisher,
    build: Blog.Post,
    from: System.get_env("PATH_TEXTS") || "/home/luan/Documents/Blog/**/*.md",
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]


  # The @posts variable is first defined by NimblePublisher.
  # Let's further modify it by sorting all posts by descending date.
  @posts Enum.sort_by(@posts, &(&1.date), {:desc, Date})

  # Let's also get all tags
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  # And finally export them
  def all_posts, do: @posts
  def all_tags, do: @tags

  def recent_posts, do: Enum.take(all_posts(), 3)

  def get_post_by_id(id) do
    case Enum.find(all_posts(), &(&1.id == id)) do
      nil -> {:error, "Artigo com id=#{id} não encontrado."}
      post -> {:ok, post}
    end
  end

  def get_posts_by_tag(tag) do
    case Enum.filter(all_posts(), &(tag in &1.tags)) do
      [] -> {:error, "Nenhum artigo com tag=#{tag} encontrado."}
      posts -> {:ok, posts}
    end
  end

  def get_posts_by_date(year, month) do
    case Enum.filter(all_posts(), &(&1.date.year == year && &1.date.month == month)) do
      [] -> {:error, "Nenhum artigo no mês #{month}/#{year} encontrado."}
      posts -> {:ok, posts}
    end
  end
end
