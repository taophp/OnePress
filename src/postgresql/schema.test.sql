CREATE EXTENSION "uuid-ossp";

CREATE TABLE items(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
	status INT
);

ALTER TABLE items OWNER TO onepresstests;

CREATE TABLE sub_items (
) INHERITS (items);

ALTER TABLE sub_items OWNER TO onepresstests;

CREATE TABLE sub_sub_items (
) INHERITS (sub_items);

ALTER TABLE sub_sub_items OWNER TO onepresstests;
