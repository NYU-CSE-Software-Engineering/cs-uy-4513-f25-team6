# Clinic Appointment & Prescription System
*CS-UY 4513 – Software Engineering*

## Project Title and Description
This project implements a modular SaaS-style **Clinic Appointment & Prescription System** that supports three categories of users—**patients**, **doctors**, and **administrators**. The system provides functionality for:
- Secure user authentication and authorization  
- Viewing clinics and available doctors  
- Scheduling and managing medical appointments  
- Doctors issuing prescriptions and patients viewing them  
- Billing and payment management  

The system uses **Ruby on Rails**, follows a **modular architecture** with clear module dependencies, exposes **RESTful API endpoints**, and stores all persistent data in a **MySQL relational database**.

## Team Members and Roles
| Name | Role | Primary Contributions |
|------|------|------------------------|
| Ben Miller | Group Leader | Login, account creation, appointment scheduling, CSS |
| Joe Aronov | Developer | Appointments model, doctor appointments list |
| Guanqiao Chen | Developer | Clinic model, bill payment and creation |
| Nelson Jiang | Developer | Login, clinic indexing and search system |
| Charlie Li | Developer | Login, doctor index search system |
| Ananya Shah | Developer | Dashboard pages, patient appointments list |
| William Shi | Developer | Prescription system, clinic employment |



## Setup Instructions

### 1. Required Software Versions
- Ruby 3.4.7  
- Rails 8.1.1
- SQLite 2.1 (development/testing)
- PostgreSQL 17.5 (production)

### 2. Clone the Repository
```bash
git clone <repository-url>
cd <project-directory>
```

### 3. Set up Ruby
- Make sure Ruby is installed on your computer
```bash
gem install bundler
bundle install
```

### 4. Set up the Rails app
```bash
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails server
```

## Tesing Instructions
- Use `bundle exec rspec` to run the low-level RSpec tests
- Use `bundle exec cucumber` to run the high-level Cucumber scenarios
