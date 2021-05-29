import filesess { FileSession }
import vweb

struct App {
	vweb.Context
}

fn (mut app App) index() vweb.Result {
	mut file_session := FileSession{
		folder: "sessions",
		context: &app.Context
	}

	file_session.start() or {
		panic(err)
	}

	if file_session.has("foo") {
		println("has foo")
	} else {
		println("does not has foo")
	}

	file_session.set("foo", "bar") or {
		eprintln(err)
	}

	if file_session.has("foo") {
		println("has foo")
	} else {
		println("does not has foo")
	}

	value := file_session.get("foo") or { "not found" }

	println('value after set: $value')

	file_session.flash("baz", "buz") or {
		panic(err)
	}

	baz_value := file_session.get("baz") or { "not found" }

	println('value after flashing baz: $baz_value')

	again_baz_value := file_session.get("baz") or { "not found" }

	println('value again of baz: $again_baz_value')

	return app.html("<h1>Hello world</h1>")
}

fn main() {
	vweb.run(&App{}, 8000)
}
