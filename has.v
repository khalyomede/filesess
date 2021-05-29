module filesess

import os
import json

pub fn (mut file_session FileSession) has(key string) bool {
	id := file_session.context.get_cookie(file_session.session_id) or {
		return false
	}
	file_path := os.join_path(file_session.folder, id)
	file_content := os.read_file(file_path) or {
		return false
	}
	json_data := json.decode(map[string]SessionData, file_content) or {
		return false
	}

	return key in json_data
}
