defmodule CritWeb.Animal.EditLive do
  use Phoenix.LiveView
  alias Crit.Stable
  alias CritWeb.AnimalView

  def render(assigns) do
    AnimalView.render("edit_live.html", assigns)
  end

  def mount(
        %{"animal_id" => animal_id},
        socket
      ) do
    animal = Stable.get_animal!(animal_id)
    animal_changeset = Stable.change_animal(animal)

    new_service_gap_changeset = Stable.new_service_gap(animal) |> Stable.change_service_gap()

    {
      :ok,
      socket
      |> assign(
        animal: animal,
        animal_changeset: animal_changeset,
        new_service_gap_changeset: new_service_gap_changeset
      )
      |> update_service_gap_changesets()
    }
  end

  def handle_event("save_animal", %{"animal" => animal_params}, socket) do
    case Stable.update_animal(socket.assigns.animal, animal_params) do
      {:ok, animal} ->
        animal_changeset = Stable.change_animal(animal)

        {
          :noreply,
          assign(socket, animal: animal, animal_changeset: animal_changeset)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {
          :noreply,
          assign(socket, animal_changeset: changeset)
        }
    end
  end

  def handle_event("validate_animal", %{"animal" => animal_params}, socket) do
    changeset =
      socket.assigns.animal
      |> Stable.change_animal(animal_params)
      |> Map.put(:action, :update)

    {
      :noreply,
      assign(socket, animal_changeset: changeset)
    }
  end

  def handle_event("create_service_gap", %{"service_gap" => service_gap_params}, socket) do
    case Stable.create_service_gap(socket.assigns.animal, service_gap_params) do
      {:ok, _service_gap} ->
        changeset = Stable.new_service_gap(socket.assigns.animal) |> Stable.change_service_gap()

        {
          :noreply,
          socket
          |> update_service_gap_changesets()
          |> assign(new_service_gap_changeset: changeset)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {
          :noreply,
          assign(socket, new_service_gap_changeset: changeset)
        }
    end
  end

  def handle_event("validate_new_service_gap", %{"service_gap" => service_gap_params}, socket) do
    changeset =
      Stable.new_service_gap(socket.assigns.animal)
      |> Stable.change_service_gap(service_gap_params)
      |> Map.put(:action, :insert)

    {
      :noreply,
      assign(socket, new_service_gap_changeset: changeset)
    }
  end

  def handle_event(
        "update_service_gap",
        %{"service_gap" => service_gap_params},
        socket
      ) do
    service_gap = Stable.get_service_gap!(socket.assigns.animal, service_gap_params["id"])

    case Stable.update_service_gap(service_gap, service_gap_params) do
      {:ok, _service_gap} ->
        {
          :noreply,
          update_service_gap_changesets(socket)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {
          :noreply,
          replace_changeset_in_service_gap_changesets(socket, changeset)
        }
    end
  end

  def handle_event(
        "validate_existing_service_gap",
        %{"service_gap" => service_gap_params},
        socket
      ) do
    service_gap = Stable.get_service_gap!(socket.assigns.animal, service_gap_params["id"])

    changeset =
      Stable.change_service_gap(service_gap, service_gap_params) |> Map.put(:action, :update)

    {
      :noreply,
      replace_changeset_in_service_gap_changesets(socket, changeset)
    }
  end

  def handle_event(
        "delete_service_gap",
        %{"id" => id},
        socket
      ) do
    service_gap = Stable.get_service_gap!(socket.assigns.animal, id)

    {:ok, _service_gap} = Stable.delete_service_gap(service_gap)

    {
      :noreply,
      update_service_gap_changesets(socket)
    }
  end

  defp update_service_gap_changesets(socket) do
    changesets =
      socket.assigns.animal
      |> Stable.list_service_gaps()
      |> Enum.map(&Stable.change_service_gap(&1))

    assign(socket, :service_gap_changesets, changesets)
  end

  defp replace_changeset_in_service_gap_changesets(socket, updated_changeset) do
    changesets =
      Enum.map(socket.assigns.service_gap_changesets, fn existing_changeset ->
        if existing_changeset.data.id == updated_changeset.data.id,
          do: updated_changeset,
          else: existing_changeset
      end)

    assign(socket, :service_gap_changesets, changesets)
  end
end
