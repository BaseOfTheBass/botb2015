# helper class
Helper = require './helper'
window.helper = new Helper()


# mixpanel events
mixpanel.track 'view.top'
mixpanel.track_links "#navigation a", "Navigations"
