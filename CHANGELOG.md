## 2015-09-12 - Release 2.0.0
### Summary
Major release to support Audisp and add significantly more testing.

#### Features
- Added Vagrant smoke tests for multiple distros.
- Now supporting Puppet 4.x.
- Support for Audisp.
- Updated the manage_service variable and associated documentation.

#### Bugfixes
- Added metadata-json-lint gem to Gemfile.
- Updated metadata requirements now issues in puppetlabs/concat with EL7 are fixed.

## 2015-07-25 - Release 1.1.0
### Summary
Various dependency updates, features & support for SLES.

#### Features
- SLES support added.
- Allow more fine grained control of service.
- Moved delete and buffer_size rules into every file via concat fragment.
- Added ability to add rules from main class rather than needing to call defined type.
- Added examples.

#### Bugfixes
- Changed concat requirement to allow EL7 systems to work.
- Forced stdlib dependency version due to validate functions required.

## 2015-05-31 - Release 1.0.2
### Summary
Minor bugfix release related to concat code.

#### Bugfixes
- Not supporting EL7 releases until upstream bug in concat is fixed (https://tickets.puppetlabs.com/browse/MODULES-2074).

## 2015-05-28 - Release 1.0.1
### Summary
Minor bugfix release related to concat code & incorrect validate function.

#### Bugfixes
- Fixed dependency issue that caused concated files to be blank in some cases.
- Typo fixed in validate function of the krb5_key_file variable.

## 2015-05-25 - Release 1.0.0
### Summary
First stable release, brings together core functionality and completed OS support.

#### Features
- Moved to using defined type exclusively for audit rules.

#### Bugfixes
- Fix rules path for EL7 systems (uses rules.d instead of audit.rules directly).

## 2015-05-21 - Release 0.1.1
### Summary
Minor point release with a small feature update to ease use.

#### Features
- Added defined type to allow rule additions from other modules.

## 2015-05-08 - Release 0.1.0
### Summary
This is the initial release.
