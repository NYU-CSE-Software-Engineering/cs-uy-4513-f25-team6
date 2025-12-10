# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

cln1 = Clinic.create!(name: "Clinic One", specialty: "General Medicine", location: "Manhattan", rating: 5)
cln2 = Clinic.create!(name: "Clinic Two", specialty: "Pediatrics", location: "Brooklyn", rating: 4.5)

pw_hash = Digest::MD5.hexdigest('password')

pat1 = Patient.create!(username: "Patient One", email: "patient1@example.com", password: pw_hash, age: 21)
pat2 = Patient.create!(username: "Patient Two", email: "patient2@example.com", password: pw_hash, age: 27)
doc1 = Doctor.create!(username: "Doctor One", email: "doctor1@example.com", password: pw_hash, phone: "123-456-7890", specialty: "Headache", rating: 4.7)
doc2 = Doctor.create!(clinic: cln2, username: "Doctor Two", email: "doctor2@example.com", password: pw_hash, phone: "123-456-7890", specialty: "Stomach", rating: 4.3)
adm = Admin.create!(username: "Example Admin", email: "admin@example.com", password: pw_hash)

sl1 = TimeSlot.create!(doctor: doc1, starts_at: '1:00 PM', ends_at: '1:30 PM')
sl2 = TimeSlot.create!(doctor: doc1, starts_at: '1:30 PM', ends_at: '2:00 PM')

sl3 = TimeSlot.create!(doctor: doc2, starts_at: '9:30 AM', ends_at: '10:00 AM')
sl4 = TimeSlot.create!(doctor: doc2, starts_at: '10:00 AM', ends_at: '10:30 AM')
sl5 = TimeSlot.create!(doctor: doc2, starts_at: '10:30 AM', ends_at: '11:00 AM')
sl6 = TimeSlot.create!(doctor: doc2, starts_at: '3:00 PM', ends_at: '3:15 PM')

Appointment.create!(patient: pat2, time_slot: sl3, date: '2025-12-25')