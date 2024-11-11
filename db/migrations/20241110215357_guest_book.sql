-- migrate:up
CREATE TABLE guestbook (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

-- migrate:down
DROP TABLE questbook;
