# helper class
Helper = require './helper'
window.helper = new Helper()

#helper.setLoading helper.$id 'container'

Members = require './members'
members = new Members()
members.getList helper.$id 'members'

# mixpanel events
mixpanel.track 'view.top'
mixpanel.track_links "#navigation a", "Navigations"
