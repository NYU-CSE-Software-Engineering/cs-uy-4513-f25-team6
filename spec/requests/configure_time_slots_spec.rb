require 'rails_helper'

RSpec.describe "Configure Time Slots (request)", type: :request do
    let(:time_slot_class) { class_double("TimeSlot").as_stubbed_const }
    let(:doctor_class) { class_double("Doctor").as_stubbed_const }
    
    describe "while logged in" do
        before :each do
            @doc = login_doctor
        end

        def expect_configure_redirect
            expect(response).to redirect_to(configure_time_slots_path)
            expect(doctor_class).to receive(:find).and_return(@doc)
            expect(@doc).to receive(:time_slots).and_return([])
            follow_redirect!
        end

        describe "GET /doctor/time_slots" do
            it "shows your current slots when logged in as doctor" do
                slot1 = instance_double("TimeSlot", id: 101,
                                        starts_at: Time.zone.parse("2000-01-01 09:00"),
                                        ends_at:   Time.zone.parse("2000-01-01 09:30"))
                slot2 = instance_double("TimeSlot", id: 102,
                                        starts_at: Time.zone.parse("2000-01-01 09:30"),
                                        ends_at:   Time.zone.parse("2000-01-01 10:00")) 
    
                expect(doctor_class).to receive(:find).with(@doc.id).and_return(@doc)
                expect(@doc).to receive(:time_slots).and_return([slot1, slot2])
    
                get configure_time_slots_path
    
                expect(response).to have_http_status(:ok)
                expect(response.body).to include(/9:00([ -APM]*)9:30/)
                expect(response.body).to include(/9:30([ -APM]*)10:00/)
            end
        end
    
        describe "POST /doctors/:id/time_slots" do
            it "attempts to create a new time slot" do
                new_slot = instance_double("TimeSlot")
                expect(time_slot_class).to receive(:new).with({doctor_id: @doc.id.to_s, starts_at: "3:00 PM", ends_at: "3:15 PM"}).and_return(new_slot)
                expect(new_slot).to receive(:valid?).and_return(true)
                expect(new_slot).to receive(:save)
    
                post doctor_time_slots_path(@doc.id), params: {starts_at: "3:00 PM", ends_at: "3:15 PM"}
    
                expect_configure_redirect
                expect(response.body).to include("Succesfully added new time slot")
            end
    
            it "alerts user if new slot isn't valid" do
                bad_slot = instance_double("TimeSlot")
                expect(time_slot_class).to receive(:new).and_return(bad_slot)
                expect(bad_slot).to receive(:valid?).and_return(false)
                expect(bad_slot).not_to receive(:save)
                expect(bad_slot).to receive_message_chain(:errors, :as_json).and_return("{}")
    
                post doctor_time_slots_path(@doc.id), params: {starts_at: "3:00 PM", ends_at: "2:00 PM"}
    
                expect_configure_redirect
                expect(response.body).to include("Invalid time slot details: ")
            end

            it "fails if trying to add a slot to someone else" do
                expect(time_slot_class).not_to receive(:new)
    
                post doctor_time_slots_path(@doc.id + 1), params: {starts_at: "3:00 PM", ends_at: "3:15 PM"}
    
                expect_configure_redirect
                expect(response.body).to include("Attempted to add a time slot to another doctor (this should not be possible)")
            end
        end
    
        describe "DELETE /doctors/:id/time_slots/:tid" do
            it "attempts to delete the specified time slot" do
                to_delete = instance_double("TimeSlot")
                expect(time_slot_class).to receive(:find_by).with({id: "14"}).and_return(to_delete)
                expect(to_delete).to receive_message_chain(:doctor, :id).and_return(@doc.id)
                expect(to_delete).to receive(:destroy)

                delete doctor_time_slot_path(@doc.id, 14)

                expect_configure_redirect
                expect(response.body).to include("Successfully removed time slot")
            end
    
            it "fails if the slot is owned by someone else" do
                to_delete = instance_double("TimeSlot")
                expect(time_slot_class).to receive(:find_by).with({id: "14"}).and_return(to_delete)
                expect(to_delete).to receive_message_chain(:doctor, :id).and_return(@doc.id + 1)
                expect(to_delete).not_to receive(:destroy)

                delete doctor_time_slot_path(@doc.id, 14)

                expect_configure_redirect
                expect(response.body).to include("Attempted to remove a slot from another doctor (this should not be possible)")
            end

            it "fails if the slot doesn't exist" do
                expect(time_slot_class).to receive(:find_by).with({id: "14"}).and_return(nil)

                delete doctor_time_slot_path(@doc.id, 14)

                expect_configure_redirect
                expect(response.body).to include("Attempted to remove a nonexistent slot (this should not be possible)")
            end
        end
    end

    describe "while not logged in" do
        it "GET /doctor/time_slots kicks you out" do
            get configure_time_slots_path

            expect(response).to redirect_to(login_path)
            follow_redirect!
            expect(response.body).to include("This page or action requires you to be logged in")
        end

        it "POST /doctors/:id/time_slots kicks you out" do
            post doctor_time_slots_path(7), params: {starts_at: "3:00 PM", ends_at: "3:15 PM"}

            expect(response).to redirect_to(login_path)
            follow_redirect!
            expect(response.body).to include("This page or action requires you to be logged in")
        end

        it "DELETE /doctors/:id/time_slots/:tid kicks you out" do
            delete doctor_time_slot_path(7, 14)

            expect(response).to redirect_to(login_path)
            follow_redirect!
            expect(response.body).to include("This page or action requires you to be logged in")
        end
    end
end