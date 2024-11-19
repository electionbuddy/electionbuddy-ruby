# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Ability to import voters to a vote

## [0.3.0] - 2024-11-18

### Added

- Added Global configuration for setting the API key using `ElectionBuddy.configure` method
- Ability to retrieve voter list's validation results
- Automated gem documentation using YARD and GitHub Pages

### Changed

- Update README.md with get validtion results usage instructions
- Update .rubocop.yml with new rules
- Enhance code documentation with detailed YARD comments

### Fixed

- Fix changelog version ordering

## [0.2.0] - 2024-11-07

### Added

- Faraday as a runtime dependency
- Debug as a development dependency
- API call framework: resource-oriented design to structure and support API calls
- Ability to validate the voter list of a given vote

### Changed

- Update README.md with usage instructions
- Update .rubocop.yml with new rules

### Fixed

- Fix console startup issue caused by incorrect code reference

## [0.1.0] - 2024-10-29

- Initial release

[unreleased]: https://github.com/electionbuddy/electionbuddy-ruby/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/electionbuddy/electionbuddy-ruby/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/electionbuddy/electionbuddy-ruby/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/electionbuddy/electionbuddy-ruby/releases/tag/v0.1.0

