USE onepresstests;

CREATE EXTENSION uuid-ossp;

CREATE TABLE Items(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc()
);

CREATE TABLE SubItems (
) INHERITS (Items);

CREATE TABLE SubSubItems (
) INHERITS (SubItems);
