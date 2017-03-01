CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES humans(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "625 East 14th Street"), (2, "Somewhere in San Jose");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Jeffrey", "T.", 1),
  (2, "Howie", "C.", 1),
  (3, "Justin", "P.", 1),
  (4, "Ryen", "L.", 2);

INSERT INTO
  dogs (id, name, owner_id)
VALUES
  (1, "Rocky", 1),
  (2, "Gatsby", 4);
