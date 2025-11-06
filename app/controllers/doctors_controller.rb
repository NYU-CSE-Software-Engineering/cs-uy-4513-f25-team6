class DoctorsController < ApplicationController
  def schedule
    @doctor = find_doctor!(params[:id])
    @time_slots = TimeSlot.where(doctor_id: @doctor.id).order(:starts_at)

    render inline: <<-'ERB'
      <h1>Available time slots</h1>
      <% if flash[:alert].present? %>
        <p><%= flash[:alert] %></p>
      <% end %>
      <ul>
        <% @time_slots.each do |slot| %>
          <li>
            <%= slot.starts_at.strftime("%Y-%m-%d %I:%M %p") %> – <%= slot.ends_at.strftime("%I:%M %p") %>
            <%= button_to "Book #{slot.starts_at.strftime("%Y-%m-%d %I:%M %p")}",
                  appointments_path,
                  method: :post,
                  params: { appointment: { time_slot_id: slot.id, doctor_id: @doctor.id } } %>
          </li>
        <% end %>
      </ul>
    ERB
  end

  private

  def find_doctor!(id_or_username)
    if id_or_username.to_s =~ /\A\d+\z/
      Doctor.find(id_or_username)
    else
      Doctor.joins(:user).find_by!(users: { username: id_or_username })
    end
  end
end
