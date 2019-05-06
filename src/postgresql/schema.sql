CREATE EXTENSION uuid-ossp;

CREATE TABLE items(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc()
);
