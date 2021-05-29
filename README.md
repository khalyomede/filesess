# filesess

Functions to manipulate the session based on files for V.

## Summary

- [About](#about)
- [Features](#features)
- [Installation](#installation)
- [Examples](#examples)
- [Known issues](#known-issues)
- [Test](#test)

## About

I created this library to easily manipulate my session data.

## Features

- Stores session data in a file
- Can configure to which folder to store session file data
- Only allows key/value string pairs
- Can set and get key values
- Can check if a key is in the session
- Can "flash" a key when setting its value, useful to create single-use data that disapears after getting their value

## Installation

```bash
v install khalyomede.filesess
```

## Examples

- [1. Start the session](#1-start-the-session)
- [2. Getting data from the session](#2-getting-data-from-the-session)
- [3. Setting data to the session](#3-setting-data-to-the-session)
- [4. Flashing data to the session](#4-flashing-data-to-the-session)
- [5. Check if a key is in the session](#5-check-if-a-key-is-in-the-session)

### 1. Start the session

In this example, we will boot the session. This step is important to be ran before you try to get your session data.

```v
import khalyomede.filesess { FileSession }
import vweb

struct App {
  vweb.Context
}

fn (mut app App) index() vweb.Result {
  session := FileSession{
    folder: "sessions",
    context: &app.Context,
  }

  session.start() or {
    panic('Could not start session ($err).')
  }

  return app.html("<h1>Home page</h1>")
}

fn main() {
  vweb.run(&App{}, 8000)
}
```

The ideal is to start your session on pages that precedes pages that will need to use the session. For example, if you know to edit a product (/product/1/edit), your user will go throug the product detail page (/product/1), it's great to start the session at the detail page.

See the know issue about [starting the session and immediately writing to it](starting-the-session-and-immediately-writing-to-it) to understand why.

### 2. Getting data from the session

In this example, we will see how to get a data in the session.

```v
import khalyomede.filesess { FileSession }
import vweb

struct App {
  vweb.Context
}

fn (mut app App) index() vweb.Result {
  session := FileSession{
    folder: "sessions",
    context: &app.Context,
  }

  session.start()

  theme := session.get("theme") or { "white" }

  return app.html("<h1>Home page</h1>")
}
```

### 3. Setting data to the session

In this example, we will store a key/value in the session.

```v
import khalyomede.filesess { FileSession }
import vweb

struct App {
  vweb.Context
}

fn (mut app App) index() vweb.Result {
  session := FileSession{
    folder: "sessions",
    context: &app.Context,
  }

  session.start()
  session.set("theme", "white") or {
    panic('Could not set theme to session ($err).')
  }

  return app.html("<h1>Home page</h1>")
}
```

### 4. Flashing data to the session

In this example, we will store a one-use key/value in the session. It is convenient for example when your form returns a success message, and you want to pass this message only once to the redircted page, so that the user will only see this message until he/she reloads the page.

```v
import khalyomede.filesess { FileSession }
import vweb

struct App {
  vweb.Context
}

fn (mut app App) index() vweb.Result {
  session := FileSession{
    folder: "sessions",
    context: &app.Context,
  }

  session.start()
  session.flash("success", "Product 1 successfuly edited.") or {
    panic('Coult not flash success message to session ($err).')
  }

  return app.html("<h1>Home page</h1>")
}
```

### 5. Check if a key is in the session

In this example, we will check if a key is present in the session.

```v
import khalyomede.filesess { FileSession }
import vweb

struct App {
  vweb.Context
}

fn (mut app App) index() vweb.Result {
  session := FileSession{
    folders: "sessions",
    context: &app.Context,
  }

  return app.html("<h1>Home page</h1>")
}
```

## Known issues

- [Starting the session and immediately writing to it](#starting-the-session-and-immediately-writing-to-it)
- [Clear data in the file session](#clear-data-in-the-file-session)

### Starting the session and immediately writing to it

I've tested this code, and it looks like the browser is too slow between starting the session (e.g. writing the cookie) and writing a key/value to the cookie (in the file to be correct).

This code will panic around `file_session.set("foo", "bar")`:

```v
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

	file_session.set("foo", "bar") or {
		eprintln(err)
	}

	return app.html("<h1>Hello world</h1>")
}

fn main() {
	vweb.run(&App{}, 8000)
}
```

But if you restart your server, as the cookie is set, this code will no longer panic.

### Clear data in the file session

For the moment, each session file are written without being encrypted. This means you can easily read the content of the file.

If a malicious user access your server's sessions, he/she can view the data in clear as well.

Encrypting session files is often discutable because some will argue since a malicious user access your server, he/she will also have access to the encryption key used to encrypt the data, so this ends up being just not worth for some folks to encrypt the session data.

I am of those who think we should do it anyway, so you are at least not tempted as a user when you want to debug on your server, to view what's stored in the session (if your app stores critical user data). At the end, it's just a way to prevent low motivation intruders, but any user that really want to view data will reach this goal anyway if he/she has found a breach.

## Test

I did not spend too much time trying to figure out how to run a test so that it spins up a web server, run the expected code, and shuts down the web server and make assertions.

What I currently do to test this library is to move all my files to a "filesess" folder, so that I can import it in an index.v file at the root of the folder, then run the server and check if the methods returns the expected results.
