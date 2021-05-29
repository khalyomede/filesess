module filesess

import vweb { Context }

pub struct FileSession {
	folder string
	http_only bool = true
	secure bool
	session_id string = "SESSID"
	mut:
		context &Context
}
