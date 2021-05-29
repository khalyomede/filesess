module filesess

import json
import os
import rand
import vweb { Cookie }

pub fn (mut file_session FileSession) start() ? {
	id := file_session.context.get_cookie(file_session.session_id) or {
		rand.string(32)
	}

	file_path := os.join_path(file_session.folder, id)

	if !os.exists(file_path) {
		os.write_file(file_path, json.encode(map[string]SessionData{})) ?
	}

	file_session.context.set_cookie(Cookie{
		name: file_session.session_id,
		value: id,
		secure: file_session.secure,
		http_only: file_session.http_only,
	})
}
