# Redmine Post-Action Hooks

Sends a HTTP POST request with information about some action to a URL of your choise

## Installation

* Copy the plugin directory into the vendor/plugins directory
* Copy vendor/plugins/redmine_post_action_hooks/config/redmine_post_action_hooks.yml to RAILS_ROOT/config/ and set an URL in the config
* (Re)Start Redmine

Note: This plugin goes well with the [Bishop IRC Bot](https://github.com/ta/bishop)

## Supported hooks

Currently the following hooks are supported:

* :controller_issues_new_after_save
* :controller_issues_edit_after_save

If you want more hooks please see http://www.redmine.org/projects/redmine/wiki/Hooks_List for complete list - and send a pull request when you have forked, fixed and tested.

# Todo

* Better documentation (Read the source for now)

# Licence

Copyright (c) 2012 Tonni Aagesen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.