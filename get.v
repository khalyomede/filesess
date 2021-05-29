module filesess

import os
import json

pub fn (mut file_session FileSession) get(key string) ?string {
	id := file_session.context.get_cookie(file_session.session_id) ?
	file_path := os.join_path(file_session.folder, id)
	file_content := os.read_file(file_path) ?
	mut json_data := json.decode(map[string]SessionData, file_content) ?

	if key in json_data {
		value := json_data[key].value

		if json_data[key].flashed {
			json_data.delete(key)

			os.write_file(file_path, json.encode(json_data)) ?
		}

		return value
	}

	return none
}
