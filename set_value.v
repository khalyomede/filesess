module filesess

import os
import json

fn (mut file_session FileSession) set_value(key string, value string, flash bool) ? {
	id := file_session.context.get_cookie(file_session.session_id) ?
	file_path := os.join_path(file_session.folder, id)
	file_content := os.read_file(file_path) ?
	mut json_data := json.decode(map[string]SessionData, file_content) ?
	json_data[key] = SessionData{
		value: value,
		flashed: flash,
	}
	os.write_file(file_path, json.encode(json_data)) ?
}
