defmodule Crit.Stable do
  import Ecto.Query, warn: false
  alias Crit.Repo
  alias Crit.Stable.{Animal, ServiceGap}

  def list_animals do
    Repo.all(Animal)
  end

  def get_animal!(id) do
    Repo.get!(Animal, id)
  end

  def new_animal do
    %Animal{}
  end

  def create_animal(attrs) do
    %Animal{}
    |> Animal.changeset(attrs)
    |> Repo.insert()
  end

  def change_animal(%Animal{} = animal, attrs \\ %{}) do
    animal
    |> Animal.changeset(attrs)
  end

  def update_animal(%Animal{} = animal, attrs) do
    animal
    |> Animal.changeset(attrs)
    |> Repo.update()
  end

  def delete_animal(%Animal{} = animal) do
    Repo.delete(animal)
  end

  def list_service_gaps(%Animal{} = animal) do
    from(s in ServiceGap, where: s.animal_id == ^animal.id, order_by: :inserted_at)
    |> Repo.all()
  end

  def get_service_gap!(%Animal{} = animal, id) do
    from(s in ServiceGap, where: s.animal_id == ^animal.id)
    |> Repo.get!(id)
  end

  def new_service_gap(%Animal{} = animal) do
    %ServiceGap{animal_id: animal.id}
  end

  def change_service_gap(%ServiceGap{} = service_gap, attrs \\ %{}) do
    service_gap
    |> ServiceGap.changeset(attrs)
  end

  def create_service_gap(%Animal{} = animal, attrs) do
    %ServiceGap{animal_id: animal.id}
    |> ServiceGap.changeset(attrs)
    |> Repo.insert()
  end

  def update_service_gap(%ServiceGap{} = service_gap, attrs) do
    service_gap
    |> ServiceGap.changeset(attrs)
    |> Repo.update()
  end

  def delete_service_gap(%ServiceGap{} = service_gap) do
    Repo.delete(service_gap)
  end
end
