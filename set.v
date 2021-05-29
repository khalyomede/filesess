module filesess

pub fn (mut file_session FileSession) set(key string, value string) ? {
	return file_session.set_value(key, value, false)
}
