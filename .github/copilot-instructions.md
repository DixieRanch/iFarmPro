# iFarmPro - AI Coding Agent Instructions

## Architecture Overview
This is a Rails 7.0 irrigation management application with multi-tenant architecture scoped by `Company.current_id`. The core domain hierarchy is: **Company > Farm > Block > Field**.

- **Data Flow**: Fields track soil moisture, ET (evapotranspiration), rainfall, and irrigation events. The `NextIrrigation` service calculates optimal irrigation timing based on soil class properties, management allowed depletion (45%), and weather data.
- **Key Models**: `Farm` (belongs_to weather_station), `Block`, `Field` (belongs_to soil_class, has_many irrigations/soil_applications), `Irrigation` (has_many meter_readings)
- **Business Logic**: Service objects in `app/services/` handle complex calculations (e.g., `NextIrrigation.call(irrigation, field)`)

## Development Workflow
- **Testing**: Use `guard` for auto-running RSpec tests (excludes `:slow` and `:js` tags by default). Run `spring rspec` for faster test execution.
- **Database**: PostgreSQL with custom CSV import tasks (`rake import:soil_class`, `rake import:et`, etc.) for reference data.
- **Dependencies**: Uses `american_date` gem for date parsing, `mechanize` for web scraping, `bootstrap-sass` for styling.

## Code Patterns
- **Multi-tenancy**: All models use `default_scope { where(company_id: Company.current_id) }` - ensure new records set `company_id`.
  > **Note**: Using `default_scope` for multi-tenancy is intentional here to enforce tenant isolation at the model level. While `default_scope` is often considered an anti-pattern in Rails due to potential for unexpected behavior (e.g., in associations or when bypassing scopes is needed), it provides a simple way to ensure all queries are tenant-aware. Alternatives include explicit scoping via class methods (e.g., `for_company(id)`), but this requires discipline across the codebase. Consider the trade-offs and test thoroughly for edge cases.
- **Form Objects**: Complex forms use ActiveModel classes in `app/forms/` (e.g., `LotForm`) with delegation to underlying models and custom validation.
- **Associations**: Use `dependent: :restrict_with_error` to prevent deletion of referenced records.
- **Validation**: Email uniqueness is case-insensitive (`uniqueness: { case_sensitive: false }`).
- **Services**: Business logic extracted to service classes with `.call` class methods (e.g., `NextIrrigation.call(*args)`).

## Key Files
- `app/models/field.rb`: Core irrigation calculations and soil nutrient tracking
- `app/services/next_irrigation.rb`: ET-based irrigation scheduling logic
- `app/forms/lot_form.rb`: Example form object pattern with delegation
- `config/routes.rb`: RESTful routes for farm management resources
- `lib/tasks/import.rake`: CSV data import patterns for reference tables

## Testing Conventions
- **Database Cleaning**: Uses `DatabaseCleaner` with transaction strategy, preserving reference tables (`ets` - evapotranspiration rates, `kcs` - crop coefficients, `current_ets` - current evapotranspiration values)
- **Feature Tests**: Capybara with Poltergeist for JavaScript testing, email testing with `capybara-email`

## Common Gotchas
- Always set `company_id` when creating records due to default scopes
- Use `field.name_with_block` for display (combines block and field names)
- Irrigation calculations depend on weather station data and soil class properties
- Form objects handle complex multi-model validation before saving