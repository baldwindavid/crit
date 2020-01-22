defmodule CritWeb.AnimalController do
  use CritWeb, :controller
  alias Crit.Stable

  def index(conn, _) do
    animals = Stable.list_animals()
    render(conn, "index.html", animals: animals)
  end

  def new(conn, _) do
    changeset = Stable.new_animal() |> Stable.change_animal()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"animal" => animal_params}) do
    case Stable.create_animal(animal_params) do
      {:ok, animal} ->
        conn
        |> put_flash(:info, "Animal created successfully.")
        |> redirect(to: Routes.animal_path(conn, :edit, animal))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    animal = Stable.get_animal!(id)
    render(conn, "edit.html", animal: animal)
  end

  def delete(conn, %{"id" => id}) do
    animal = Stable.get_animal!(id)
    {:ok, _animal} = Stable.delete_animal(animal)

    conn
    |> put_flash(:info, "Animal deleted successfully.")
    |> redirect(to: Routes.animal_path(conn, :index))
  end
end
