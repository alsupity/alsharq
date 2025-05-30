String notifications = """
CREATE TABLE notifications(
    id varchar(255) PRIMARY key,
    title varchar(255),
    body text,
    img text,
    url text,
    page text,
    
    done_visit INTEGER DEFAULT 0,
    created_at varchar(50)
);
""";

String countries = """
CREATE TABLE countries (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name varchar(255) NOT NULL,
	code varchar(255) NOT NULL,
	priority INTEGER NOT NULL DEFAULT 1,
	deleted_at varchar(255),
	created_at varchar(255) NOT NULL,
	updated_at varchar(255) NOT NULL
);
""";

String classes = """
CREATE TABLE classes (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name varchar(255) NOT NULL,
	seat INTEGER NOT NULL, -- bool: 0 or 1
	
	country_id INTEGER NOT NULL,
	
	priority INTEGER NOT NULL DEFAULT 1,
	deleted_at varchar(255),
	created_at varchar(255) NOT NULL,
	updated_at varchar(255) NOT NULL,
FOREIGN KEY(country_id) REFERENCES countries(id) 
);
""";

String subjects = """
CREATE TABLE subjects (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name varchar(255) NOT NULL,
	image varchar(255),
	body varchar(255),
	
	class_id INTEGER NOT NULL,
	
	priority INTEGER NOT NULL DEFAULT 1,
	deleted_at varchar(255),
	created_at varchar(255) NOT NULL,
	updated_at varchar(255) NOT NULL,
FOREIGN KEY(class_id) REFERENCES classes(id) 
);
""";

String phases = """
CREATE TABLE phases (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name varchar(255) NOT NULL,

	override_rate REAL,
	sequence INTEGER, -- boll 0 or 1
	num_actual_asks INTEGER,
	
	subject_id INTEGER NOT NULL,
	
	rate REAL DEFAULT 0.0, -- local
	status INTEGER, -- local
	
	priority INTEGER NOT NULL DEFAULT 1,
	deleted_at varchar(255),
	created_at varchar(255) NOT NULL,
	updated_at varchar(255) NOT NULL,
FOREIGN KEY(subject_id) REFERENCES subjects(id) 
);
""";

String asks = """
CREATE TABLE asks (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name varchar(255) NOT NULL,
	options_json TEXT NOT NULL,
	
	phase_id INTEGER NOT NULL,
	
	priority INTEGER NOT NULL DEFAULT 1,
	deleted_at varchar(255),
	created_at varchar(255) NOT NULL,
	updated_at varchar(255) NOT NULL,
FOREIGN KEY(phase_id) REFERENCES phases(id) 
);
""";

String marks = """
CREATE TABLE marks (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name varchar(255) NOT NULL,
	min_grade REAL NOT NULL,
	max_grade REAL NOT NULL,
	
	priority INTEGER NOT NULL DEFAULT 1,
	deleted_at varchar(255),
	created_at varchar(255) NOT NULL,
	updated_at varchar(255) NOT NULL
);
""";

String tmp = """
  CREATE TABLE tmp(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name varchar(255),
      
  detail varchar(255),
  is_show INTEGER,
  created_at varchar(50),
  updated_at varchar(50)
);
""";
